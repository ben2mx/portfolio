#!/usr/bin/env bash
# Fails if anything this repo would publish contains a term that must not be public.
# This is a backstop. The real control is reading the post before it is pushed.
#
# Blocked terms come from .blocklist.local and/or the BLOCKLIST environment variable:
# one extended regular expression per line, matched case-insensitively, # for comments.
#
# Scans every file git tracks or would track (not just posts), plus commit messages.
# Binary files are searched too, since images carry text metadata.
# Anything that stops the scan from running counts as a failure.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0

# In CI the logs are public, so report where the hit is without repeating it.
show() { if [[ -n "${CI:-}" ]]; then cut -d: -f1,2; else cat; fi; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
terms=$work/terms files=$work/files log=$work/commit-messages

{ cat .blocklist.local 2>/dev/null || true; printf '%s\n' "${BLOCKLIST:-}"; } \
  | sed 's/\r$//' | grep -vE '^[[:space:]]*(#|$)' > "$terms" || true

if [[ ! -s "$terms" ]]; then
  echo "check-public: no blocklist found (.blocklist.local or BLOCKLIST). Refusing to pass." >&2
  exit 1
fi

# The theme is third-party code; the blocklist is ignored by git so it is never listed.
git ls-files -z --cached --others --exclude-standard -- . ':!themes' > "$files"
: > "$log"
if git rev-parse --verify -q HEAD >/dev/null; then   # no commits yet is fine
  git log --all --format='%an <%ae>%n%B' > "$log"
fi

private_ip='\b(10\.[0-9]{1,3}|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}\b'

# scan <label> <grep options...>: grep exits 0 on a hit, 1 on none, 2+ on error.
scan() {
  local label=$1 hits rc=0; shift
  hits=$( { xargs -0 -r -a "$files" grep -naH "$@" --; grep -naH "$@" -- "$log"; } 2>&1 ) || rc=$?
  if [[ -n "$hits" ]]; then
    echo "check-public: $label:" >&2
    sed "s|^$log|commit-messages|" <<<"$hits" | show >&2
    fail=1
  elif (( rc > 1 )); then
    echo "check-public: the $label scan could not run." >&2
    fail=1
  fi
}

scan "blocked term found" -iE -f "$terms"
scan "private IP address found" -E -e "$private_ip"

# Ticket keys (a project prefix, a dash, a number). Certification and standard codes look the same, so they are allowed.
ticket_key='\b[A-Z]{2,5}-[0-9]{2,6}\b'
allowed_codes='\b(AZ|SC|MS|PL|AI|DP|MD|ISO|RFC|CVE)-[0-9]+'
keys=$( { xargs -0 -r -a "$files" grep -noHE "$ticket_key" --; grep -noHE "$ticket_key" -- "$log"; } 2>/dev/null \
  | grep -vE ":$allowed_codes" || true )
if [[ -n "$keys" ]]; then
  echo "check-public: ticket key found:" >&2
  sed "s|^$log|commit-messages|" <<<"$keys" | show >&2
  fail=1
fi

if (( fail == 0 )); then echo "check-public: clean"; fi
exit $fail
