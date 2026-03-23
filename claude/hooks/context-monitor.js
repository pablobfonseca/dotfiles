#!/usr/bin/env node
'use strict';

// Context Monitor — PostToolUse hook
// Reads context metrics from the bridge file written by the statusline hook
// and injects warnings when context usage is high. This makes the AGENT aware
// of context limits (the statusline only shows the user).
//
// Bridge file: /tmp/claude-ctx-<session_id>.json (written by cyberpunk-powerline)
//
// Thresholds:
//   WARNING  (remaining <= 35%): Agent should wrap up current task
//   CRITICAL (remaining <= 25%): Agent must stop and inform user
//
// Debounce: 5 tool uses between warnings to avoid spam.
// Severity escalation (WARNING → CRITICAL) bypasses debounce.

const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const WARNING_THRESHOLD = 35;
const CRITICAL_THRESHOLD = 25;
const STALE_SECONDS = 60;
const DEBOUNCE_CALLS = 5;

let input = '';

const stdinTimeout = setTimeout(() => process.exit(0), 10_000);
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => (input += chunk));
process.stdin.on('end', () => {
  clearTimeout(stdinTimeout);
  try {
    const data = JSON.parse(input);
    const sessionId = data.session_id;
    if (!sessionId) process.exit(0);

    const tmpDir = os.tmpdir();
    const metricsPath = path.join(tmpDir, `claude-ctx-${sessionId}.json`);

    // No bridge file → subagent or fresh session — exit silently
    if (!fs.existsSync(metricsPath)) process.exit(0);

    const metrics = JSON.parse(fs.readFileSync(metricsPath, 'utf8'));
    const now = Math.floor(Date.now() / 1000);

    // Ignore stale metrics
    if (metrics.timestamp && now - metrics.timestamp > STALE_SECONDS) {
      process.exit(0);
    }

    const remaining = metrics.remaining_percentage;
    const usedPct = metrics.used_pct;

    // No warning needed
    if (remaining > WARNING_THRESHOLD) process.exit(0);

    // Debounce: check if we warned recently
    const warnPath = path.join(tmpDir, `claude-ctx-${sessionId}-warned.json`);
    let warnData = { callsSinceWarn: 0, lastLevel: null };
    let firstWarn = true;

    if (fs.existsSync(warnPath)) {
      try {
        warnData = JSON.parse(fs.readFileSync(warnPath, 'utf8'));
        firstWarn = false;
      } catch {
        // Corrupted file, reset
      }
    }

    warnData.callsSinceWarn = (warnData.callsSinceWarn || 0) + 1;

    const isCritical = remaining <= CRITICAL_THRESHOLD;
    const currentLevel = isCritical ? 'critical' : 'warning';

    // Emit on first warning, then debounce. Severity escalation bypasses debounce.
    const severityEscalated =
      currentLevel === 'critical' && warnData.lastLevel === 'warning';
    if (
      !firstWarn &&
      warnData.callsSinceWarn < DEBOUNCE_CALLS &&
      !severityEscalated
    ) {
      fs.writeFileSync(warnPath, JSON.stringify(warnData));
      process.exit(0);
    }

    // Reset debounce counter
    warnData.callsSinceWarn = 0;
    warnData.lastLevel = currentLevel;
    fs.writeFileSync(warnPath, JSON.stringify(warnData));

    const progressInstructions =
      'Save current progress to claude-mem (what is done, what remains, ' +
      'current blockers). If claude-mem MCP tools are unavailable, write ' +
      'a brief HANDOFF.md in the working directory instead.';

    const message = isCritical
      ? `CONTEXT CRITICAL: Usage at ${usedPct}%. Remaining: ${remaining}%. ` +
        'Context is nearly exhausted. ' + progressInstructions + ' ' +
        'Then ask the user if they want to /clear and continue in a fresh session. ' +
        'Do NOT start new complex work.'
      : `CONTEXT WARNING: Usage at ${usedPct}%. Remaining: ${remaining}%. ` +
        'Context is getting limited. Wrap up the current task. ' +
        'Avoid unnecessary exploration or starting new complex work.';

    process.stdout.write(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'PostToolUse',
          additionalContext: message,
        },
      }),
    );
  } catch {
    // Silent fail — never block tool execution
    process.exit(0);
  }
});
