-- usage: lua5.4 harness.lua script.lua exercise.lua
local script, ex = arg[1], arg[2]
now=0
local metros={}
metro={init=function(cb,t,c)
 local m={cb=cb,time=t or 1,running=false}
 function m:start(t) if t then self.time=t end self.running=true self.due=now+self.time end
 function m:stop() self.running=false end
 metros[#metros+1]=m return m end}
function advance(dt)
 local tend=now+dt
 while true do
  local best
  for _,m in ipairs(metros) do
   if m.running and m.due<=tend and (not best or m.due<best.due) then best=m end
  end
  if not best then break end
  now=best.due best.due=now+best.time
  best.cb()
 end
 now=tend
end
local buf={}
local function clr(z) for y=1,8 do buf[y]={} for x=1,16 do buf[y][x]=z end end end
clr(0)
function grid_led(x,y,z) if buf[y] and x>=1 and x<=16 then buf[y][x]=z end end
function grid_led_all(z) clr(z) end
function grid_refresh()
 local r={} for y=1,8 do for x=1,16 do r[#r+1]=string.format("%x",buf[y][x]) end end
 io.write("L ",table.concat(r),"\n")
end
function midi_out(t) io.write(string.format("M %.4f out %02x\n",now,t[1])) end
function midi_note_on(n,v,c) io.write(string.format("M %.4f on %d %d %d\n",now,n,v,c)) end
function midi_note_off(n,v,c) io.write(string.format("M %.4f off %d %d %d\n",now,n,v,c)) end
local ps={}
function pset_init(n) end
function pset_write(p,s) ps[p]=s io.write("P write ",p," ",#s," ",s:sub(1,1506),"\n") end
function pset_read(p) return ps[p] end
function get_time() return now*1000 end
function clamp(v,lo,hi) if v<lo then return lo elseif v>hi then return hi end return v end
function ledat(x,y) return buf[y][x] end
math.randomseed(1234)
function press(x,y) event_grid(x,y,1) end
function rel(x,y) event_grid(x,y,0) end
function tap(x,y) press(x,y) rel(x,y) end
function note(s) io.write("# ",s,"\n") end
dofile(script)
dofile(ex)
