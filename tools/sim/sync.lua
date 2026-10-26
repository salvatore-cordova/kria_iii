dofile((arg[0]:match("^(.*)/[^/]*$") or ".").."/common.lua")
check(lsyn==2 and tsyn==0 and ndsy==false,"defaults: loop sync All, division sync None, note-div-sync off")

gp(1) loop(2,7,1)
local ok=true for k=1,24 do if ls[k]~=2 or le[k]~=7 then ok=false end end
check(ok,"loop sync All: one edit moved all 24 (param,track) loops to 2..7")

cfg(function() tap(11,6) end)
check(lsyn==0,"config: loop sync -> None")
gp(3) loop(1,3,1)
check(same("oct",1,1,3),"None: octave loop of track 1 = 1..3")
check(same("trig",1,2,7) and same("note",1,2,7) and same("dur",1,2,7) and same("rpt",1,2,7) and same("alt",1,2,7),"None: other parameters of track 1 untouched")
check(same("oct",2,2,7),"None: octave of track 2 untouched")
gp(4) loop(5,6,3)
check(same("dur",3,5,6) and same("oct",3,2,7) and same("trig",3,2,7),"None: duration loop independent")
gp(11) loop(4,9,2)
check(same("rpt",2,4,9) and same("trig",2,2,7) and same("note",2,2,7),"None: ratchet loop independent")
gp(12) loop(8,12,4)
check(same("alt",4,8,12) and same("note",4,2,7),"None: alt-note loop independent")
gp(2) loop(10,14,2)
check(same("note",2,10,14) and same("trig",2,2,7) and same("alt",2,2,7),"None: note loop independent")
gp(13) loop(6,8,1)
check(same("note",1,6,8) and same("oct",1,1,3),"velocity page edits the note loop")
gp(1) loop(1,16,1)
check(same("trig",1,1,16) and same("note",1,6,8),"None: trigger page edits trigger only")

cfg(function() tap(12,3) end)
check(lsyn==1,"config: loop sync -> Track")
gp(3) loop(3,5,2)
local ok2=true for p=0,20,4 do if ls[p+2]~=3 or le[p+2]~=5 then ok2=false end end
check(ok2,"Track: every parameter of track 2 = 3..5")
check(same("oct",1,1,3) and same("trig",3,2,7),"Track: other tracks untouched")
cfg(function() tap(12,3) end)
check(lsyn==0,"config: loop sync Track toggles off to None")
cfg(function() tap(13,6) end)
check(lsyn==2,"config: loop sync -> All")
gp(4) loop(4,4,4)
ok=true for k=1,24 do if ls[k]~=4 or le[k]~=4 then ok=false end end
check(ok,"All again: single-step loop everywhere")

-- ===== division sync
gp(1)
cfg(function() tap(11,6) end)  -- loop sync none so loops don't interfere
gp(3) tdiv(3,1)
check(dv2[9]==3 and dv2[1]==1 and dv2[5]==1 and dv2[13]==1,"div sync None: octave division only")
gp(1) tdiv(5,2)
check(dv2[2]==5 and dv2[6]==1 and dv2[10]==1,"div sync None: trigger division only")
gp(12) tdiv(4,3)
check(dv2[23]==4 and dv2[3]==1,"div sync None: alt division only")
gp(11) tdiv(2,4)
check(dv2[20]==2,"div sync None: ratchet division only")

cfg(function() tap(8,3) end)
check(tsyn==1,"config: division sync -> Track")
gp(4) tdiv(6,1)
local d=true for p=0,20,4 do if dv2[p+1]~=6 then d=false end end
check(d and dv2[2]==5,"Track: all parameters of track 1 = 6, other tracks untouched")
cfg(function() tap(9,6) end)
check(tsyn==2,"config: division sync -> All")
gp(2) tdiv(8,4)
d=true for k=1,24 do if dv2[k]~=8 then d=false end end
check(d,"All: every parameter of every track = 8")
cfg(function() tap(7,6) end)
check(tsyn==0,"config: division sync All toggles off")

-- note division sync pairs trigger+note, and the rest together
cfg(function() tap(8,4) end)
check(ndsy==true,"config: note division sync on")
gp(1) tdiv(2,1)
check(dv2[1]==2 and dv2[5]==2 and dv2[9]~=2 and dv2[13]~=2 and dv2[17]~=2 and dv2[21]~=2,"NDS on, sync None: trigger edit also sets note, nothing else")
gp(2) tdiv(3,1)
check(dv2[1]==3 and dv2[5]==3 and dv2[9]~=3,"NDS on, sync None: note edit also sets trigger")
gp(3) tdiv(4,1)
check(dv2[9]==4 and dv2[13]==4 and dv2[17]==4 and dv2[21]==4 and dv2[1]==3,"NDS on, sync None: octave edit sets oct/dur/rpt/alt together")
cfg(function() tap(8,3) end)
gp(1) tdiv(7,2)
check(dv2[2]==7 and dv2[6]==7 and dv2[10]~=7 and dv2[1]==3,"NDS on, sync Track: trigger+note of the track only")
gp(11) tdiv(9,2)
check(dv2[10]==9 and dv2[14]==9 and dv2[18]==9 and dv2[22]==9 and dv2[2]==7,"NDS on, sync Track: other group of the track")
cfg(function() tap(8,4) end)
check(ndsy==false,"note division sync toggles off")

-- ===== time page shows the division of the current page's parameter
gp(3) press(12,8) rd()
check(ledat(dv2[9],1)>=10,"time page highlights track 1 octave division on the octave page")
check(ledat(dv2[1],1)<10,"time page does not highlight trigger division there")
gp(1) rd()
check(ledat(dv2[1],1)>=10,"time page highlights track 1 trigger division on the trigger page")
rel(12,8)

-- ===== config page draws the new buttons
tap(7,7) rd()
check(ledat(8,3)>0 and ledat(8,4)>0 and ledat(7,6)>0 and ledat(10,6)>0,"config page draws division-sync controls")
tap(7,7)

-- ===== clear track (hold track key on trig page) resets every parameter's loop/div
gp(1)
cfg(function() tap(11,6) end)
loop(3,5,1)
press(1,8) advance(2.1) rel(1,8)
d=true for k=1,21,4 do if ls[k]~=1 or le[k]~=6 or dv2[k]~=1 then d=false end end
check(d,"clear track resets loop+division of all 6 parameters")

io.write(fails==0 and "ALL PASS\n" or ("FAILS: "..fails.."\n"))
