#!/usr/bin/env bash
# Tests for check-public.sh. Each case runs the script in a throwaway git repo.
set -uo pipefail
here=$(cd "$(dirname "$0")" && pwd)
pass=0 failed=0

run_case() { # run_case <name> <expected exit> <file content> [expected stderr substring]
  local name=$1 want=$2 content=$3 needle=${4:-} t rc
  t=$(mktemp -d)
  mkdir -p "$t/scripts"; cp "$here/check-public.sh" "$t/scripts/"
  ( cd "$t" && git init -q && printf 'zzz-placeholder\n' > .blocklist.local \
      && printf '.blocklist.local\n' > .gitignore && printf '%s\n' "$content" > post.md \
      && scripts/check-public.sh >out 2>err ); rc=$?
  if [[ $rc -ne $want ]] || { [[ -n $needle ]] && ! grep -q "$needle" "$t/err"; }; then
    echo "FAIL $name (exit $rc, want $want)"; sed 's/^/  /' "$t/err"; failed=$((failed+1))
  else echo "ok   $name"; pass=$((pass+1)); fi
  rm -rf "$t"
}

# Keys are split in two so this file does not trip the scan itself.
run_case "ticket key blocked"      1 "See ABCD""-13596 for details." "ticket key found"
run_case "short key blocked"         1 "Change XYZ""-198 went in." "ticket key found"
run_case "cert and standard codes" 0 "AZ-104, SC-300, ISO-27001, CVE-2024-3400, RFC-5321 and MS-900."
run_case "clean post"              0 "Patched the backup platform."
echo "$pass passed, $failed failed"; exit $(( failed > 0 ))
