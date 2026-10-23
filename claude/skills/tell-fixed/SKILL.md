---
name: tell-fixed
description: Use when the user says "tell <name> that this issue was fixed" (or similar) while working on an issue. Sends <name> a Slack DM with a short non-technical brief of how it works now, after the user approves the draft.
argument-hint: "<name>"
---

Close the loop with whoever reported or cares about the issue in this session, through the Slack MCP (`plugin:slack:slack`, user token: messages post as the user with a "Sent using Claude" footer). If its tools are missing or unauthenticated, tell the user to run `/mcp` and authenticate `plugin:slack:slack`, then stop.

1. **Find the person.** `slack_search_users` with the name as keyword. One match: use its user id. Several: ask which. None: say so and stop.
2. **Gather the issue.** "This issue" is the queue item, issue or PR worked on in this session. Read its queue text and plan for what was wrong and what changed. Note whether it is merged only or deployed.
3. **Draft the message.** Short, plain language:
   - what was wrong, in the reporter's own words when the item quotes them
   - that it's fixed, and whether it's live yet
   - 2-3 sentences on how it works now: what they will see or do
   No file names, PR numbers, code or jargon. If the repo has a copy canon (e.g. `COPYWRITING.md`), follow its voice and rules.
4. **Pick the channel.** Default is a DM (user id as `channel_id`). If the item links a Slack thread (`.../archives/<channel>/p<digits>`) that <name> started, offer to reply there instead: `thread_ts` is the digits with a dot before the last six (`p1792488642959059` -> `1792488642959.059`).
5. **Approve, then send.** Show the draft and where it goes. Send with `slack_send_message` only on the user's OK, then return the message link.
