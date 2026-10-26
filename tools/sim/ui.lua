dofile((arg[0]:match("^(.*)/[^/]*$") or ".").."/common.lua")
cfg(function() tap(11,6) end)           -- loop sync None
-- loop mod on a parameter page edits that page's loop for the selected track, from any row
gp(3) tap(2,8)                          -- octave page, track 2
press(11,8) press(4,6) press(9,6) rel(9,6) rel(4,6)
check(same("oct",2,4,9) and same("oct",1,1,6) and same("trig",2,1,6) and same("note",2,1,6),"octave page: loop 4..9 on track 2 only")
check(ledat(2,3)<=2 and ledat(12,3)<=2,"out-of-loop columns dimmed while loop mod held")
check(ledat(5,1)>=1,"in-loop columns shown")
press(3,7) press(15,7) rel(15,7) rel(3,7)
check(same("oct",2,3,15) and not tr2,"row 7 sets the loop (no transport) on parameter pages")
rel(11,8)
gp(2) press(11,8) press(2,1) press(5,1) rel(5,1) rel(2,1) rel(11,8)
check(same("note",2,2,5) and same("oct",2,3,15),"note page: loop 2..5 on track 2")
gp(1) press(11,8) press(7,3) press(8,3) rel(8,3) rel(7,3) rel(11,8)
check(same("trig",3,7,8) and same("trig",2,1,6),"trigger page: rows are still tracks")
-- holding time division / probability mod and pressing a track button selects that track
gp(2) tap(1,8)
press(12,8) tap(3,8) check(at==3,"time div mod + track 3 selects track 3") rel(12,8)
press(13,8) tap(4,8) check(at==4,"probability mod + track 4 selects track 4") rel(13,8)
check(not mute[3] and not mute[4],"no mutes toggled")
io.write(fails==0 and "ALL PASS\n" or ("FAILS: "..fails.."\n"))
