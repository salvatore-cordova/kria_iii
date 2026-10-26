-- desktop heap figures (KB): after load, garbage made while playing, save and load. compare against v1.6.3
io.write=function() end gr=function() end grid_led_all=gr
midi_note_on=function() end midi_note_off=midi_note_on midi_out=midi_note_on
local function kb() return collectgarbage("count") end
local function during(f) collectgarbage() collectgarbage("stop") local a=kb() f() local d=kb()-a collectgarbage("restart") collectgarbage() return d end
collectgarbage() collectgarbage()
print(string.format("load %.1f",kb()))
print(string.format("play20s %.1f",during(function() pts() advance(20) end)))
print(string.format("save %.1f",during(function() svp(1) fsave(1) end)))
print(string.format("loadpat %.1f",during(function() ldp(1) end)))
print(string.format("steady %.1f",kb()))
