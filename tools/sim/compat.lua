-- compat exercise: everything linked, behaviour must match v1.6.3
local NEW = (tsyn ~= nil)
if NEW then tsyn=1 end            -- track-wide division like the old script
local function fixdiv() end
local function nav(x) tap(x,8) end
local function loop(a,b,y) press(11,8) press(a,y) press(b,y) rel(b,y) rel(a,y) rel(11,8) end
local function tdiv(d,y) press(12,8) tap(d,y) rel(12,8) fixdiv() end
local function sel(t) tap(t,8) end

note("trigs")
nav(6)
loop(1,16,1)
for t=1,4 do for s=1,16 do if (s+t)%3~=0 then tap(s,t) end end end
note("notes")
nav(7)
for t=1,4 do sel(t) for s=1,16 do tap(s,((s*t)%7)+1) end end
note("oct")
nav(8)
for t=1,4 do sel(t) for s=1,16 do tap(s,2+((s+t)%6)) end tap(t+2,1) end
note("dur")
nav(9)
for t=1,4 do sel(t) for s=1,16 do tap(s,2+((s*2+t)%6)) end end
note("ratchet")
nav(6) nav(6)
for t=1,4 do sel(t) for s=1,16 do if s%2==0 then tap(s,2) tap(s,3+(s%3)) end end end
note("alt")
nav(7) nav(7)
for t=1,4 do sel(t) for s=1,16 do tap(s,1+((s+t)%7)) end end
note("vel")
nav(8) nav(8)
for t=1,4 do sel(t) for s=1,16 do tap(s,1+((s+2*t)%7)) end end
note("prob")
nav(6)
for t=1,4 do sel(t) press(13,8) for s=1,16 do tap(s,1+((s+t)%5)) end rel(13,8) end
sel(1)
note("divisions")
tdiv(2,2) tdiv(3,3) tdiv(1,1) tdiv(4,4)
note("run1")
tap(15,7)
advance(6)
note("loops shorten")
loop(3,9,1) 
advance(4)
loop(5,5,2)
advance(2)
loop(1,12,1)
advance(2)
note("mute")
press(11,8) tap(2,8) rel(11,8)
advance(2)
press(11,8) tap(2,8) rel(11,8)
note("pages while running")
nav(7) advance(1) nav(7) advance(1) nav(8) advance(1) nav(8) advance(1) nav(9) advance(1) nav(6) advance(1) nav(6) advance(1) nav(6)
note("directions")
tap(15,8)
for d=2,3 do for t=1,4 do tap(3+d,t) end advance(4) end
for t=1,4 do tap(4,t) end
note("tclk")
for t=1,4 do tap(2,t) end
advance(6)
for t=1,4 do tap(2,t) end
tap(15,8)
note("config nsyn off")
tap(7,7) tap(3,4) tap(7,7)
nav(7) tap(4,3) tap(5,3) nav(7) advance(2)
nav(6) 
tap(7,7) tap(3,4) tap(7,7)
note("tie")
tap(7,7) press(9,8) rel(9,8) tap(7,7)
advance(2)
note("stop")
tap(15,7)
advance(1)
note("save/load")
tap(16,8) 
press(1,1) advance(1.2) rel(1,1)
press(2,1) advance(1.2) rel(2,1)
tap(1,1) tap(2,1) advance(1)
press(3,7) advance(2.2) rel(3,7)
press(1,7) advance(2.2) rel(1,7)
note("start from pattern")
tap(15,7) advance(4) tap(15,7)
note("cue")
press(16,8) tap(2,1) rel(16,8)
tap(15,7) advance(8) tap(15,7)
note("ext clock")
event_midi(0xFA)
for i=1,24*8 do event_midi(0xF8) end
event_midi(0xFC)
note("state")
local d=cap()
io.write("S ",(d:sub(1,753):gsub(".",function(c) return string.format("%02x",c:byte()) end)),"\n")
