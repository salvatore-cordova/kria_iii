# kria_iii desktop simulation

Runs `kria_iii.lua` on a desktop Lua 5.4 against stubbed iii functions (grid LEDs, MIDI, metros, pset), so changes can be tested without a grid. It does **not** model the RP2040 heap or its Lua build, so a script can pass here and still run out of memory on the device (see `III_LUA_MEMORY_GUIDE.md`).

Run everything: `tools/sim/run.sh` (needs `lua5.4`).

- `harness.lua` - stubs + virtual clock. Usage: `lua5.4 harness.lua script.lua exercise.lua`. Logs LED frames (`L`), MIDI (`M`), pset writes (`P`), markers (`#`).
- `compat.lua` - scripted session; MIDI output must match v1.6.3 byte for byte.
- `sync.lua` - loop sync / division sync / note division sync and per-page editing.
- `playback.lua` - independent playheads per parameter, plus a random-edit stress run.
- `persist.lua` - old-format pattern loading, flash round trip, loop snap.
- `common.lua` - shared test helpers.
