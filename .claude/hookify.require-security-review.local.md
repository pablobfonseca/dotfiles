---
name: require-security-review
enabled: true
event: stop
action: block
pattern: .*
---

**Security review required before completing this task.**

Files matching security-sensitive patterns were likely edited in this session. Before stopping, verify:

1. **Check if any edited files touch auth, API, middleware, or sensitive data:**
   - Paths matching: `**/auth/**`, `**/api/**`, `**/middleware/**`, `**/routes/**`, `**/controllers/**`
   - Files containing: password, token, session, login, signup, credential, secret, cookie, jwt, oauth, permission, role, encryption, hash, sanitize

2. **If yes** — you MUST run the `security-reviewer` agent before committing or completing work. Do not skip this step.

3. **If no security-sensitive files were touched** — you may proceed without a security review.

Run `git diff --name-only` to check which files changed, then evaluate whether they match the patterns above.
