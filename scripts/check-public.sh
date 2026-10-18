#!/usr/bin/env bash
# Fails if anything under content/ contains a term that must not be public.
# This is a backstop. The real control is reading the post before it is pushed.
#
# Blocked terms come from .blocklist.local (one per line, # for comments) and/or
# the BLOCKLIST environment variable. Matching is exact and case-sensitive.
set -euo pipefail
cd "$(dirname "$0")/.."

targets=(content hugo.toml)
fail=0

# In CI the logs are public, so report where the hit is without repeating it.
show() { if [[ -n "${CI:-}" ]]; then cut -d: -f1,2; else cat; fi; }

terms=$(mktemp)
trap 'rm -f "$terms"' EXIT
{ cat .blocklist.local 2>/dev/null || true; printf '%s\n' "${BLOCKLIST:-}"; } \
  | sed 's/\r$//' | grep -vE '^\s*(#|$)' > "$terms" || true

if [[ ! -s "$terms" ]]; then
  echo "check-public: no blocklist found (.blocklist.local or BLOCKLIST)." >&2
  # An empty list in CI would pass everything, so treat it as a failure there.
  [[ -n "${CI:-}" ]] && exit 1
elif hits=$(grep -rnF -f "$terms" "${targets[@]}"); then
  echo "check-public: blocked term found:" >&2
  show <<<"$hits" >&2
  fail=1
fi

if hits=$(grep -rnE '\b(10\.[0-9]{1,3}|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}\b' "${targets[@]}"); then
  echo "check-public: private IP address found:" >&2
  show <<<"$hits" >&2
  fail=1
fi

[[ $fail -eq 0 ]] && echo "check-public: clean"
exit $fail
