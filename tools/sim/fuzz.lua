-- random presses/releases on every key, transport, MIDI clock and time steps; any Lua error fails
io.write=function() end gr=function() end
local out=print
math.randomseed(tonumber(os.getenv("SEED") or 1))
local held,errs,ne={}, {}, 0
local function try(f,...) local ok,e=pcall(f,...) if not ok then ne=ne+1 errs[e]=(errs[e] or 0)+1 end end
for i=1,tonumber(os.getenv("N") or 50000) do
 local r=math.random(100)
 if r<=55 then
  local x,y=math.random(16),math.random(8)
  if math.random(3)==1 then x=({6,7,8,9,11,12,13,15,16})[math.random(9)] y=8 end
  local key=x..","..y
  if held[key] then held[key]=nil try(event_grid,x,y,0) else held[key]=true try(event_grid,x,y,1) end
 elseif r<=58 then try(event_midi,({0xFA,0xFC,0xFB})[math.random(3)],0,0)
 elseif r<=70 then for j=1,math.random(6) do try(event_midi,0xF8,0,0) end
 else try(advance,0.01*math.random(30)) end
end
for e,n in pairs(errs) do out("FAIL "..n.."x "..e) end
out(ne==0 and "ALL PASS" or ("FAILS: "..ne))
