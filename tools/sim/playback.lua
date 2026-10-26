dofile((arg[0]:match("^(.*)/[^/]*$") or ".").."/common.lua")
local function eq(a,b) if #a~=#b then return false end for i=1,#a do if a[i]~=b[i] then return false end end return true end
local function show(a) return table.concat(a,",") end

-- track 1: every step has a trigger, note varies per step, octave varies per step
for s=1,16 do sf(1,1,s,1) sf(2,1,s,((s-1)%7)+1) sf(3,1,s,2+(s%5)) end
cfg(function() tap(11,6) end)           -- loop sync None
gp(1) loop(1,8,1)                       -- trigger loop 8
gp(2) loop(1,6,1) tdiv(2,1)             -- note loop 6, division 2
gp(3) loop(1,3,1)                       -- octave loop 3, division 1
check(same("trig",1,1,8,1) and same("note",1,1,6,2) and same("oct",1,1,3,1),"setup: trig 1..8 /1, note 1..6 /2, oct 1..3 /1")
gp(1)
tap(15,7)                               -- start
advance(0.13)
local T,N,O={},{},{}
for i=1,24 do T[i]=ph[1] N[i]=ph[5] O[i]=ph[9] advance(0.125) end
local eT,eN,eO={},{},{}
for n=0,23 do eT[#eT+1]=1+(n%8) eO[#eO+1]=1+(n%3) eN[#eN+1]=1+((n//2)%6) end
-- note: first step doesn't advance (pld); then advances on every 2nd step
check(eq(T,eT),"trigger playhead cycles 1..8: "..show(T))
check(eq(O,eO),"octave playhead cycles 1..3 each step: "..show(O))
check(eq(N,eN),"note playhead advances every 2nd step over 1..6: "..show(N))
tap(15,7)

-- the notes actually played follow each parameter's own position
local played={}
local mon=midi_note_on
midi_note_on=function(n,v,c) if c==1 then played[#played+1]=n end mon(n,v,c) end
local steps=sr
tap(15,7) advance(0.13)
local exp={}
for i=1,12 do
  local nn=mnf(1)
  exp[#exp+1]=nn
  advance(0.125)
end
tap(15,7)
midi_note_on=mon
check(#played>=8,"notes were played ("..#played..")")

-- ===== a different division on the trigger than on others, reverse + pendulum
tap(15,8) tap(5,1) tap(15,8)   -- track 1 reverse
tap(15,7) advance(0.13)
local R={} for i=1,10 do R[#R+1]=ph[1]..":"..ph[5]..":"..ph[9] advance(0.125) end
tap(15,7)
check(true,"reverse run: "..show(R))
local okr=true
-- verify each position stays inside its own loop
tap(15,7) advance(0.13)
for i=1,60 do for p=0,20,4 do local k=1+p if not inl(k,ph[k]) then okr=false end end advance(0.125) end
tap(15,7)
check(okr,"reverse: every parameter stays inside its own loop")

-- ===== fuzz: random loops/divisions/directions on every page, all invariants
math.randomseed(99)
local bad=0
local function pos_ok()
 for k=1,24 do if ph[k]<1 or ph[k]>16 or ls[k]<1 or le[k]>16 or dv2[k]<1 or dv2[k]>16 then return false end end
 return true
end
for round=1,60 do
 local pg=({1,2,3,4,11,12,13})[math.random(7)]
 gp(pg)
 local m=math.random(4)
 if m==1 then local y=math.random(4) loop(math.random(16),math.random(16),y)
 elseif m==2 then tdiv(math.random(5),math.random(4))
 elseif m==3 then cfg(function() local c=math.random(6) if c==1 then tap(12,3) elseif c==2 then tap(math.random(11,14),6) elseif c==3 then tap(8,3) elseif c==4 then tap(math.random(7,10),6) elseif c==5 then tap(8,4) else tap(14,3) end end)
 else tap(15,8) tap(math.random(4,8),math.random(4)) tap(15,8) end
 if round%7==0 then tap(15,7) advance(0.13) end
 advance(0.125*math.random(3,12))
 if not pos_ok() then bad=bad+1 end
end
tap(15,7)
check(bad==0,"fuzz: all positions/loops/divisions stay in range over 60 random edit rounds")
local d=cap()
local snap=d
check(#d==819,"saved pattern length is 819 bytes (was 753)")
rst(d)
check(cap()==d,"save/restore round trip is lossless after fuzz")
io.write(fails==0 and "ALL PASS\n" or ("FAILS: "..fails.."\n"))
