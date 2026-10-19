.PHONY: check

check:
	@set -e; for f in claude/hooks/*.sh; do bash -n "$$f"; done
	HOOKS=$(CURDIR)/claude/hooks claude/hooks/check-guards.sh
	jq . claude/settings.json >/dev/null
	jq . gemini/settings.json >/dev/null
