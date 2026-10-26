#!/bin/sh
# Runs the kria_iii simulation tests on a desktop (needs lua5.4).
# usage: tools/sim/run.sh [path/to/kria_iii.lua]
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
K=${1:-$ROOT/kria_iii.lua}
T=$(mktemp -d)
cd "$HERE"

# 1. compatibility: MIDI output must match v1.6.3 (commit b30ec0a) exactly
git -C "$ROOT" show b30ec0a:kria_iii.lua > "$T/base.lua"
lua5.4 harness.lua "$T/base.lua" compat.lua | grep -v '^[LPS] ' > "$T/base.txt"
lua5.4 harness.lua "$K" compat.lua | grep -v '^[LPS] ' > "$T/new.txt"
if diff -q "$T/base.txt" "$T/new.txt" >/dev/null; then echo "PASS compat: MIDI identical to v1.6.3"
else echo "FAIL compat: MIDI differs from v1.6.3"; diff "$T/base.txt" "$T/new.txt" | head; fi

# 2. feature tests
for t in sync playback persist ui; do
  printf "%s: " "$t"
  lua5.4 harness.lua "$K" "$t.lua" | grep -E '^(ALL PASS|FAILS|FAIL )' | tr '\n' ' '
  echo
done

# 3. random key mashing must not raise a Lua error
printf "fuzz: "; lua5.4 harness.lua "$K" fuzz.lua | grep -E '^(ALL PASS|FAILS|FAIL )' | tr '\n' ' '; echo
# 4. desktop heap, v1.6.3 vs this script (no device heap model; see III_LUA_MEMORY_GUIDE.md)
git -C "$ROOT" show b30ec0a:kria_iii.lua > "$T/base.lua"
echo "mem v1.6.3: $(lua5.4 harness.lua "$T/base.lua" mem.lua | grep -v '^L ' | tr '\n' ' ')"
echo "mem new:    $(lua5.4 harness.lua "$K" mem.lua | grep -v '^L ' | tr '\n' ' ')"
rm -rf "$T"
