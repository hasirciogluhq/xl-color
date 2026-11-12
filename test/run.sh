#!/usr/bin/env bash
# Builds and runs every test/*.test.xl, then builds examples/demo.xl and checks that a pipe gets no escape sequences.
#   test/run.sh [xlc] [stdlib dir]        (defaults: $XLC, else `xlc` on PATH; $XLANG_STD)
set -u
root=$(cd "$(dirname "$0")/.." && pwd)
# Git Bash on Windows: xlc is a Windows program and needs `D:/a/...`, not `/d/a/...`.
command -v cygpath >/dev/null 2>&1 && root=$(cygpath -m "$root")
xlc=${1:-${XLC:-xlc}}
std=${2:-${XLANG_STD:?the stdlib directory: test/run.sh <xlc> <std> or XLANG_STD}}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
exe=; case "$(uname -s)" in MINGW* | MSYS* | CYGWIN*) exe=.exe ;; esac
pass=0; fail=0
build() { "$xlc" "$1" -M "std=$std" --import std -M "github.com/hasirciogluhq/xl-color=$root" -DfeatureDefaultAllocator=true -o "$2"; }

for src in "$root"/test/*.test.xl; do
  name=$(basename "$src" .test.xl)
  if ! build "$src" "$work/$name$exe" 2>"$work/$name.err"; then
    echo "FAIL [$name] build"; cat "$work/$name.err"; fail=$((fail + 1)); continue
  fi
  if out=$("$work/$name$exe" 2>&1); then echo "ok   [$name]"; pass=$((pass + 1)); else echo "FAIL [$name]"; echo "$out"; fail=$((fail + 1)); fi
done

# Standard output is a pipe here, so detection switches the sequences off; FORCE_COLOR switches them back on.
if build "$root/examples/demo.xl" "$work/demo$exe" 2>"$work/demo.err"; then
  plain=$("$work/demo$exe"); forced=$(FORCE_COLOR=1 "$work/demo$exe")
  if [[ "$plain" != *$'\x1b'* && "$plain" == *"24-bit orange"* && "$forced" == *$'\x1b[38;2;255;136;0m'* ]]; then
    echo "ok   [demo]"; pass=$((pass + 1))
  else
    echo "FAIL [demo] plain: $plain / forced: $forced"; fail=$((fail + 1))
  fi
else
  echo "FAIL [demo] build"; cat "$work/demo.err"; fail=$((fail + 1))
fi

echo "$pass passed, $fail failed"
[ "$fail" = 0 ]
