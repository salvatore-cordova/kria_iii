fails=0
function check(c,msg) if c then io.write("PASS ",msg,"\n") else fails=fails+1 io.write("FAIL ",msg,"\n") end end
function gp(n)  -- go to page n through the nav keys
 local k={[1]=6,[11]=6,[2]=7,[12]=7,[3]=8,[13]=8,[4]=9}
 if n==1 or n==2 or n==3 or n==4 then if vm~=n then tap(k[n],8) if vm~=n then tap(k[n],8) end end
 else -- extended page: first the base page, then second press
  local base=(n==11) and 1 or (n==12) and 2 or 3
  gp(base) tap(k[n],8)
 end
 assert(vm==n,"gp "..n.." got "..tostring(vm))
end
function loop(a,b,y) press(11,8) press(a,y) press(b,y) rel(b,y) rel(a,y) rel(11,8) end
function tdiv(d,y) press(12,8) tap(d,y) rel(12,8) end
P={trig=0,note=4,oct=8,dur=12,rpt=16,alt=20}
function same(name,t,a,b,d) local k=P[name]+t return ls[k]==a and le[k]==b and (d==nil or dv2[k]==d) end
function cfg(f) gp(1) tap(7,7) f() tap(7,7) end
