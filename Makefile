.PHONY: check

check:
	@set -e; for f in claude/hooks/*.sh git/hooks/pre-push; do bash -n "$$f"; done
	HOOKS=$(CURDIR)/claude/hooks claude/hooks/check-guards.sh
	jq . gemini/settings.json >/dev/null
