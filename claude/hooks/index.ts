import type { HookJSONOutput } from "@anthropic-ai/claude-agent-sdk";

const output: HookJSONOutput = {
  decision: "block",
  reason: "Use the AskUserQuestion tool to continue refining what to do next",
};

console.log(JSON.stringify(output));
