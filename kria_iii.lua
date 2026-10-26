-- kria iii v1.7.0
collectgarbage("collect")
STEPS=16
tro=6 tfi=0 cpd=0.125
TCH={1,2,3,4}
MC8={0xF8} MCA={0xFA} MCC={0xFC} gcc=0
DV="\1\2\3\4\5\6\7\8\10\12\14\16\20\24\28\32"
SDF="2212221212221212221222221221221221221221221221222"
function gSDR(s) local t={} for i=1,7 do local c=SDF:byte((s-1)*7+i) t[i]=c and c-48 or 1 end return t end
SD={} for i=1,7 do SD[i]=gSDR(i) end
local _c=gSDR(8) for i=8,16 do SD[i]=_c end
F=0 D=5 M=9 H=13 BF=15
ODR=7
NP=16
DM={16,14,12,10,8,4,2,1,.75,.625,.5,.375,.25,.187,.125,.0625}
VL="\20\40\60\80\95\112\127"
PP="00001000101011101111"
WK="\0\2\4\5\7\9\11"
SH="\0\1\4\7\10\13\16\21\24" MKS="\1\7\7\7\7\7\31\7\7"
STD=1<<1|7<<4|5<<7|5<<10|1<<13|1<<16|6<<24
MTC=1|7<<13|31<<16 VTC=1<<13|1<<16
st={}
function gf(f,t,s) return (st[t*16+s-16]>>SH:byte(f))&MKS:byte(f) end
function sf(f,t,s,v) local k=t*16+s-16 local m=MKS:byte(f) local h=SH:byte(f) st[k]=(st[k]&~(m<<h))|((v&m)<<h) end
function cpm(m,a,b) for s=1,STEPS do local k=a*16+s-16 st[k]=(st[k]&~m)|(st[b*16+s-16]&m) end end
function clm(m,v,t) for s=1,STEPS do local k=t*16+s-16 st[k]=(st[k]&~m)|v end end
function nst(f,x,v)
local k=at*16+x-16
if nsyn then
if gf(f,at,x)==v and st[k]&1==1 then st[k]=st[k]&~MTC|VTC
else sf(f,at,x,v) st[k]=st[k]|1 end
else sf(f,at,x,v) end
end
sr=48 si={2,2,1,2,2,2,1} asd=1 cs={}
sadj={0,0,0,0,0,0,0}
shk=nil
gl=grid_led gr=grid_refresh cg=collectgarbage mr=math.random tu=table.unpack SC=string.char mx=math.max

function bsc()
cs[1]=sr
for i=2,7 do cs[i]=cs[i-1]+si[i-1] end
for i=8,14 do cs[i]=cs[i-7]+12 end
for i=15,21 do cs[i]=cs[i-14]+24 end
end
function rget(t,s,i) return st[t*16+s-16] & (1 << (15+i)) ~= 0 end
function rset(t,s,i,v)
local k=t*16+s-16
if v then st[k] = st[k] | (1 << (15+i))
else st[k] = st[k] & ~(1 << (15+i)) end
end
function ucpd() local b=tro<7 and 30+tro*15 or 120+(tro-6)*20 cpd=15/(b+tfi) if tr2 and not ms then icl.time=cpd/sp end end
function nls(t)
local r=gf(4,t,ph[t+12]) or 0 local m=DM[17-gdu[t]] or 1
local frac=r==0 and 0.1 or r/5
return mx(cpd*DV:byte(dv2[t] or 1)*frac*m,.02)
end
function liw(k) return ls[k]>le[k] end
function lpg() return vm>=2 and vm<=4 or vm>=11 end
function glo(x,y,b) if y<8 then if not inl(lpk,x) then if b>2 then b=2 end elseif b<1 then b=1 end if lft and x==lfc then b=BF end end grid_led(x,y,b) end
function inl(k,s)
if liw(k) then return s>=ls[k] or s<=le[k] else return s>=ls[k] and s<=le[k] end
end
function llen(k)
if liw(k) then return STEPS-ls[k]+le[k]+1 else return le[k]-ls[k]+1 end
end
function nxs(k)
local s=ph[k] local d=sdir[(k-1)%4+1]
local w=liw(k) local sw=ls[k] local ew=le[k]
if d==1 then
s=s+1
if w then
if s>STEPS then s=1 end
if s>ew and s<sw then s=sw end
else
if s>ew or s>STEPS then s=sw end
end
elseif d==2 then
s=s-1 if s<1 then s=STEPS end
if w then if s>ew and s<sw then s=ew end
else if s<sw or s>ew then s=ew end end
elseif d==3 then
s=s+ddr[k]
if s>ew then s=ew ddr[k]=-1
elseif s<sw then s=sw ddr[k]=1 end
elseif d==4 then
ddr[k]=(mr(2)==1) and 1 or -1 s=s+ddr[k]
if w then
if s<1 then s=STEPS end if s>STEPS then s=1 end
if s>ew and s<sw then s=sw end
else
if s<sw then s=ew elseif s>ew then s=sw end
end
elseif d==5 then
s=sw+mr(llen(k))-1
if w and s>STEPS then s=s-STEPS end
end
return s
end
function mnf(t)
local ni=gf(2,t,ph[t+4]) or 1
ni=((ni-1)+(gf(8,t,ph[t+20]) or 0))%7+1
local adj=sadj[((ni-1)%7)+1] or 0
return clamp((cs[ni] or sr)+adj+(7-gf(3,t,ph[t+8])+go2[t]-1)*12,0,127)
end
function son(t)
if mute[t] then return end
local mn=mnf(t)
local prev=an[t] nom[t]:stop()
if not tie and prev>=0 then midi_note_off(prev,0,TCH[t]) end
midi_note_on(mn,VL:byte(gf(9,t,ph[t+4]) or 6),TCH[t]) an[t]=mn nom[t]:start(nls(t))
if tie and prev>=0 and prev~=mn then midi_note_off(prev,0,TCH[t]) end
if tclk[t] and not pld then for k=t+4,t+12,4 do ph[k]=nxs(k) end end
end
function sof(t)
if an[t]>=0 then midi_note_off(an[t],0,TCH[t]) an[t]=-1 nom[t]:stop() end
end
function ano() for t=1,4 do ram[t]:stop() rsc[t]=0 sof(t) end end
pld=false
function rph(t,c)
for k=t,t+20,4 do ph[k]=(sdir[t]==2 and le[k] or ls[k]) dc[k]=c and DV:byte(dv2[k])-1 or 0 end
end
function setlp(p,t,a,b)
for k=1,24 do
local tt=(k-1)%4+1
if lsyn==2 or (tt==t and (lsyn==1 or (k-1)//4+1==p)) then ls[k]=a le[k]=b end
end
end
function setdv(p,t,x)
for k=1,24 do
local tt=(k-1)%4+1 local q=(k-1)//4+1
local sg=(q<3)==(p<3)
local rp if tsyn==0 then rp=q==p or (ndsy and sg) else rp=not ndsy or sg end
if (tsyn==2 or tt==t) and rp then dv2[k]=x dc[k]=0 end
end
end
function adv(t)
local fr=false local up=false
for k=t,t+20,4 do
dc[k]=dc[k]+1
if dc[k]>=DV:byte(dv2[k]) then
dc[k]=0 up=true
if k==t then fr=true end
if not pld and not (tclk[t] and k>t+3 and k<t+16) then
ph[k]=nxs(k)
if k==t then
local d2=sdir[t]
if (d2==2 and ph[t]==le[t]) or (d2~=2 and ph[t]==ls[t]) then
lc[t]=(lc[t]+1)%4
local tl=llen(t) local ml=0 for i=1,4 do local l=llen(i) if l>ml then ml=l end end
for tt=1,4 do local q=psnap[tt] if q then local sl=(q[2]-q[1]+STEPS)%STEPS+1 if tl>=sl or tl>=ml then local k0=q[3]*4-4+tt setlp(q[3],tt,q[1],q[2]) ph[k0]=q[1] psnap[tt]=nil end end end
end
end
end
end
end
if not fr then return up end
if mute[t] then sof(t) return true end
local s=ph[t]
if gf(1,t,s)==1 then
if PP:byte((gf(5,t,s) or 5)*4+lc[t]-3)==49 then
local rs=ph[t+16]
local nd=gf(6,t,rs) or 1
if nd>1 then sof(t) rsc[t]=1 end
if rget(t,rs,1) then son(t) end
if nd>1 then ram[t]:start(mx(cpd/nd,.02)) end
end
end
return true
end
function tka()
if not tr2 then return end
if not ms then midi_out(MC8) cp=cp+1 if cp<sp then return end cp=0 end
cpls=not cpls
cbt=(cbt+1)%4
gcc=gcc+1
if gcc>=64 then gcc=0 cg("step",1) end
local upd=cbt==0
for t=1,4 do if adv(t) then upd=true end end
pld=false
if cman then
ccc=ccc+1
if ccc>=cclk then
if cued then ldp(cued,false) cued=nil end
ccc=0
end
else
local mx2=0
for k=1,24 do
local len=llen(k)*DV:byte(dv2[k])
if len>mx2 then mx2=len clt=k end
end
cclk=llen(clt)
cdc=cdc+1
if cdc>=DV:byte(dv2[clt]) then
cdc=0
ccc=ccc+1
if ccc>=cclk then
if cued then ldp(cued,false) cued=nil end
ccc=0
end
end
end
if upd then rd() end
end
function event_midi(b1,b2,b3)
if b1==0xF8 then
if not tr2 or not ms then return end
local now=get_time() table.insert(pt,now)
if #pt>PB then table.remove(pt,1) end
if not ms then ms=true icl:stop() cp=0 for k=1,24 do dc[k]=0 end end
if #pt>=2 then cpd=((pt[#pt]-pt[1])/(#pt-1))*sp end
cp=cp+1 if cp>=sp then cp=0 tka() end
elseif b1==0xFA or b1==0xFB then
if tr2 and not ms then return end
ms=true tr2=true icl:stop() idl:stop() cp=0 pt={} cbt=0 cpls=false ccc=0
for t=1,4 do lc[t]=0 end
for t=1,4 do
rph(t)
if gf(1,t,ph[t])==1 then son(t) else sof(t) end
end
rd()
elseif b1==0xFC then if not ms then return end tr2=false ms=false pt={} ucpd() ano() idl:start()
for t=1,4 do rph(t) lc[t]=0 end
rd()
end
end
function cap()
local b={} local r={}
for t=1,4 do
for s=1,STEPS do
local w=st[t*16+s-16]
r[s]=SC(w&1,w>>1&7,w>>4&7,w>>7&7,w>>10&7,w>>13&7,w>>16&31,(w>>21&7)+50)
end
r[17]=SC(ph[t],ls[t],le[t],dv2[t],ph[t+20],ls[t+20],le[t+20],dv2[t+20])
b[t]=table.concat(r,"",1,17)
end
b[5]=SC(sr,asd,si[1],si[2],si[3],si[4],si[5],si[6],si[7])
b[6]=SC(go2[1],go2[2],go2[3],go2[4],gdu[1],gdu[2],gdu[3],gdu[4],sdir[1],sdir[2],sdir[3],sdir[4],mute[1] and 1 or 0,mute[2] and 1 or 0,mute[3] and 1 or 0,mute[4] and 1 or 0)
local n=0
for t=1,4 do for s=1,STEPS do n=n+1 r[n]=SC(st[t*16+s-16]>>24&7) end end
b[7]=table.concat(r,"",1,n)
b[8]=SC(tclk[1] and 1 or 0,tclk[2] and 1 or 0,tclk[3] and 1 or 0,tclk[4] and 1 or 0,nsyn and 1 or 0,lsyn,lsnap and 1 or 0)
n=0
for p=1,16 do local sp=SD[p] for i=1,7 do n=n+1 r[n]=SC(sp[i] or 1) end end
b[9]=table.concat(r,"",1,n)
b[10]=SC(tie and 1 or 0,tsyn,ndsy and 1 or 0)
n=0
for k=5,20 do r[n+1]=SC(ph[k],ls[k],le[k],dv2[k]) n=n+1 end
b[11]=table.concat(r,"",1,n)
return table.concat(b,"",1,11)
end
function rst(d)
if type(d)~="string" then return end
local B=string.byte
for t=1,4 do
local tb=(t-1)*136
for s=1,STEPS do
local o=tb+(s-1)*8
local ov=B(d,o+3)
if ov<2 or ov>7 then ov=ODR end
local dv=B(d,o+4)
if dv>5 then dv=1 end
local k=t*16+s-16
st[k]=st[k]&(7<<24)|(B(d,o+1)==1 and 1 or 0)|(B(d,o+2)&7)<<1|ov<<4|dv<<7|clamp(B(d,o+5) or 5,1,5)<<10|clamp(B(d,o+6) or 1,1,5)<<13|((B(d,o+7) or 1)&31)<<16|clamp((B(d,o+8) or 50)-50,0,6)<<21
end
local b=tb+128
for q=0,5 do
local k=t+q*4 local o=q==5 and b+4 or b
if q==0 or q==5 then
ph[k]=clamp(B(d,o+1) or 1,1,STEPS)
ls[k]=clamp(B(d,o+2) or 1,1,STEPS)
le[k]=clamp(B(d,o+3) or STEPS,1,STEPS)
dv2[k]=clamp(B(d,o+4) or 1,1,16)
else
ph[k]=ph[t] ls[k]=ls[t] le[k]=le[t] dv2[k]=dv2[t]
end
end
for k=t,t+20,4 do ddr[k]=1 dc[k]=0 end
end
local g=544
sr=B(d,g+1) asd=B(d,g+2)
for i=1,7 do si[i]=B(d,g+2+i) end SD[asd]={tu(si)}
local q=g+9
for t=1,4 do go2[t]=clamp(B(d,q+t),1,6) gdu[t]=clamp(B(d,q+4+t),1,16) sdir[t]=clamp(B(d,q+8+t),1,5) mute[t]=B(d,q+12+t)==1 end
if #d>=633 then for t=1,4 do for s=1,STEPS do sf(9,t,s,clamp(B(d,570+(t-1)*16+(s-1)) or 6,1,7)) end end end
if #d>=637 then for t=1,4 do tclk[t]=B(d,633+t)==1 end end
if #d>=639 then nsyn=B(d,638)==1 lsyn=B(d,639) end
if #d>=640 then lsnap=B(d,640)==1 end
if #d>=752 then for p=1,16 do SD[p]={} for i=1,7 do SD[p][i]=B(d,640+(p-1)*7+i) end end si={tu(SD[asd])} end
if #d>=753 then tie=B(d,753)==1 end
if #d>=819 then
tsyn=clamp(B(d,754),0,2) ndsy=B(d,755)==1
for k=5,20 do
local o=756+(k-5)*4
ph[k]=clamp(B(d,o),1,STEPS) ls[k]=clamp(B(d,o+1),1,STEPS) le[k]=clamp(B(d,o+2),1,STEPS) dv2[k]=clamp(B(d,o+3),1,16)
end
end
if asd<1 or asd>16 then asd=1 end
bsc() crs() scph=nil shk=nil
end
function ldp(p,sync)
if pats[p] then rst(pats[p])
else
for t=1,4 do clm(-1,STD,t) tclk[t]=false end
for k=1,24 do ph[k]=1 ls[k]=1 le[k]=STEPS dv2[k]=1 dc[k]=0 ddr[k]=1 end
end
ap=p if sync~=false then ccc=0 end
if sync~=false then ano() end
for t=1,4 do ram[t]:stop() rsc[t]=0 end
for t=1,4 do rph(t,sync~=false)
if sync==false then sof(t) if gf(1,t,ph[t])==1 then son(t) end end end
if sync~=false then pld=true end
end
function svp(p)
pats[p]=nil cg("collect")
pats[p]=cap() psx[p]=true
cg("collect")
end
function crs() for i=1,7 do sadj[i]=0 end end
function pinit() if not psi then pset_init("ki") psi=true end end
function hx(s) return(s:gsub(".",function(c) return string.format("%02x",c:byte())end))end
function dhx(s) return(s:gsub("..",function(h) return SC(tonumber(h,16))end))end
function fsave(p)
pinit()
if pats[p] then pcall(pset_write,p,hx(pats[p])) end
end
function fload()
pinit()
for p=1,NP do
pats[p]=nil cg("collect")
local ok,d=pcall(pset_read,p)
if ok and d and type(d)=="string" and #d>=1138 then pats[p]=dhx(d) psx[p]=true end
end
cg("collect")
end
function fsaveall()
pinit()
pcall(svp,ap)
for p=1,NP do
if pats[p] then pcall(pset_write,p,hx(pats[p])) end
cg("collect")
end
end
function dnav()
for t=1,4 do gl(t,8,mute[t] and(t==at and M or 1)or(t==at and BF or 5)) end
for i=1,4 do gl(5+i,8,((vm==11 and i==1)or(vm==12 and i==2)or(vm==13 and i==3))and(blk and BF or D)or vm==i and BF or D) end
gl(11,8,mlh and BF or D)
gl(12,8,mth and BF or D)
gl(13,8,mph and BF or D)
gl(15,8,(vm==6) and BF or D)
gl(16,8,tr2 and(cbt==0 and BF or(cpls and M or D))or(vm==7 and BF or D))
end
function dtr()
for t=1,4 do
local mu=mute[t] local sel=(t==at)
for s=1,STEPS do
local b
if s==ph[t] and tr2 then b=mu and 9 or BF
elseif inl(t,s) then
if gf(1,t,s)==1 then b=mu and (sel and 7 or 4) or (sel and 12 or M)
else b=mu and (sel and 2 or 1) or (sel and D or 1) end
else b=gf(1,t,s)==1 and 2 or F end
gl(s,t,b)
end
end
dft()
end
function dft()
gl(6,7,D) gl(7,7,D)
gl(15,7,tr2 and BF or D) gl(16,7,D)
end
function dcm(f,p,r7)
local k=p*4-4+at local pp=ph[k] local df=ls[k]~=ls[at] or le[k]~=le[at]
for r=1,7 do
local tv=f==8 and 7-r or 8-r
for s=1,STEPS do
local b
local ht=gf(1,at,s)==1
local iph=tr2 and s==pp
if gf(f,at,s)==tv and (ht or df or (f==2 and not nsyn)) then
if iph then b=BF elseif inl(k,s) then b=ht and H or D else b=ht and M or D end
elseif iph then b=D
elseif r==7 and r7==1 then b=(not nsyn and ht) and D or 1
elseif r==7 and r7==2 and ht then b=1
else b=F end
gl(s,r,b)
end
end
end
function dano() dcm(8,6,2) end
function dve() dcm(9,2,3) end
function dno() dcm(2,2,1) end
function doc()
for c=1,6 do gl(c,1,(c==go2[at]) and BF or D) end
for s=1,STEPS do
local sel=gf(3,at,s) local iph=(tr2 and s==ph[at+8]) local itr=gf(1,at,s)==1
for r=2,7 do
local b
if r==sel then b=iph and BF or itr and H or r==7 and 1 or F
elseif r>sel then b=iph and M or itr and D or r==7 and 1 or F
else b=iph and D or F end
gl(s,r,b)
end
end
end
function ddu()
for s=1,STEPS do
local sel=gf(4,at,s) local iph=(tr2 and s==ph[at+12]) local itr=gf(1,at,s)==1
for r=1,7 do
local b
if r==1 then
if s==gdu[at] then b=BF else b=F end
else
if itr and r<=7-sel then
if iph then b=BF else b=M end
elseif iph and r==2 then b=BF
else b=F end
end
gl(s,r,b)
end
end
end
function drch()
for s=1,STEPS do
local nd=gf(6,at,s) or 1
local iph=(tr2 and s==ph[at+16]) local itr=gf(1,at,s)==1
gl(s,1,iph and M or D)
for r=2,6 do
local slot=7-r
local b
if slot<=nd then
if itr then
if rget(at,s,slot) then
if iph then b=BF else b=H end
else
if iph then b=BF else b=3 end
end
else b=F end
else b=iph and 1 or F end
gl(s,r,b)
end
gl(s,7,iph and M or D)
end
end
function dsc()
if sch then
for x=1,16 do gl(x,sch,(x==TCH[sch]) and BF or D) end
for t=1,4 do if t~=sch then gl(1,t,t==at and M or D) end end
else
for t=1,4 do gl(1,t,t==at and M or D) end
end
for t=1,4 do
if t~=sch then
gl(2,t,tclk[t] and BF or (t==at and M or D))
for c=4,8 do gl(c,t,(sdir[t]==c-3) and BF or (t==at and M or D)) end
end
end
for i=1,8 do gl(i,6,(i==asd or scfl==i) and BF or D) end
for i=1,8 do gl(i,7,(i+8==asd or scfl==i+8) and BF or D) end
local ro=(sr-48)%12
for i=1,7 do
local o=WK:byte(i) local c=8+i
if ro==o then gl(c,7,BF)
elseif ro==o+1 and i~=3 and i~=7 then gl(c,7,blk and BF or D)
else gl(c,7,F) end
end
gl(16,7,shphl and BF or D)
for r=1,6 do
if r~=sch then
local idx=7-r
local iv=si[idx]
local ni=8-r
local adj=sadj[ni] or 0
for c=9,16 do
local s2=c-9
if s2==iv then gl(c,r,BF)
elseif adj~=0 and s2==(iv+adj)%8 then gl(c,r,D)
elseif s2==0 then gl(c,r,1)
else gl(c,r,F) end
end
end
end
end
function dprb()
for s=1,STEPS do
local p=gf(5,at,s) or 5
local sel=6-p
local iph=tr2 and s==ph[at]
local itr=gf(1,at,s)==1
for r=1,5 do
local b
if r==sel then
if iph then b=BF elseif itr then b=H else b=D end
elseif r>sel then
if iph then b=M else b=D end
else b=iph and D or F end
gl(s,r,b)
end
end
end
function dpat()
if pflash>0 then pflash=pflash-1 end
for p=1,NP do
local b
if pflash>0 then b=BF
elseif p==ap then b=psx[p] and H or M
elseif cued and p==cued then b=9
elseif psx[p] then b=4 else b=1 end
gl(p,1,b)
end
if cclk<1 then cclk=1 end
local cpos=ccc%cclk
for x=1,16 do
local b=F
if tr2 and x==cpos+1 then b=13
elseif x==cclk then b=4
elseif x<=cclk then b=1 end
gl(x,2,b)
end
gl(1,7,D)
gl(2,7,pclh and H or 1)
gl(3,7,D)
dft()
end
function dcfg()
local nb=nsyn and H or D
for r=3,6 do for c=2,5 do
if r==3 or r==6 or c==2 or c==5 then gl(c,r,nb) end
end end
gl(7,7,blk and BF or D)
gl(12,3,lsyn==1 and BF or D)
gl(14,3,lsnap and BF or 1)
gl(8,3,tsyn==1 and BF or D) gl(8,4,ndsy and BF or D)
for c=7,10 do gl(c,6,tsyn==2 and BF or D) end
for c=11,14 do gl(c,6,lsyn==2 and BF or D) end
gl(9,8,tie and BF or D)
end
function dtim()
local pb=cbt==0 and BF or D
if ms then
gl(8,1,pb)
local db=clamp(math.floor(1+(60*sp/(cpd*24)-30)/270*15),1,16)
for x=1,16 do gl(x,2,x==db and BF or D) end
local dc=(sp==12 and 6 or sp==8 and 7 or sp==6 and 8 or sp==4 and 9 or sp==3 and 10 or sp==2 and 11 or 0)
for x=6,11 do gl(x,3,x==dc and BF or D) end
else
gl(8,1,pb)
for x=1,16 do gl(x,2,(x==tro+1) and BF or D) end
for x=1,16 do gl(x,3,(x==tfi+1) and BF or D) end
gl(7,4,D) gl(8,4,D) gl(9,4,D) gl(10,4,D)
end
gl(6,7,blk and BF or D)
end
function dlp()
local p=PM:byte(vm)
for t=1,4 do
local k=p*4-4+t
local lw=ls[k] local lx=le[k]
local wr=liw(k)
local sel=(t==at) local mu=mute[t]
for s=1,STEPS do
local b local iep=(s==lw or s==lx) local iin
if wr then iin=(s>lw or s<lx) else iin=(s>lw and s<lx) end
local sph=ph[k]
local itr=gf(1,t,s)==1
if tr2 and s==sph then b=mu and 9 or BF
elseif iep then
if mu then b=sel and (itr and 1 or 2) or 1
else b=itr and (sel and 13 or M) or (sel and D or 1) end
elseif iin then
if itr then b=mu and (sel and 7 or 4) or (sel and 13 or M)
else b=mu and (sel and 2 or 1) or (sel and D or 1) end
else
b=itr and 1 or F
end
if lft==t and lfc==s then b=BF end
gl(s,t,b)
end
if psnap[t] then local b=blk and D or F gl(psnap[t][1],t,b) gl(psnap[t][2],t,b) end
end
end
function dtm()
for t=1,4 do
local sel=(t==at)
local dv=dv2[PM:byte(vm)*4-4+t]
for x=1,16 do
local b=F
if x==dv then b=sel and BF or H
else b=sel and D or 1 end
gl(x,t,b)
end
end
end
function rd()
cg("step",1)
bct=bct+1
if bct==2 then blk=not blk end
if bct>=4 then bct=0 end
grid_led_all(F)
if cfh then dcfg()
elseif tmh then dtim()
else
dnav()
local f=mlh and lpg()
if f then lpk=PM:byte(vm)*4-4+at gl=glo end
if mlh and not f then dlp()
elseif mth then dtm()
elseif mph then dprb()
elseif vm==11 then drch()
elseif vm==12 then dano()
elseif vm==13 then dve()
elseif vm==1 then dtr()
elseif vm==2 then dno()
elseif vm==3 then doc()
elseif vm==4 then ddu()
elseif vm==6 then dsc()
elseif vm==7 then dpat()
end
gl=grid_led
if (mlh and not f) or mth or mph then dft() end
end
gr()
end
function pts()
if tr2 then tr2=false ano() idl:start()
if not ms then icl:stop() midi_out(MCC) end
for t=1,4 do rph(t) lc[t]=0 end
else tr2=true cbt=0 cpls=false ccc=0
for t=1,4 do rph(t,1) lc[t]=0 end
pld=true idl:stop()
if not ms then ucpd() icl:stop() cp=0 icl:start(cpd/sp) midi_out(MCA) end
end
rd()
end
function rts()
ccc=0
for t=1,4 do rph(t) lc[t]=0 end
if tr2 then
for t=1,4 do if not mute[t] and gf(1,t,ph[t])==1 then son(t) end end
cp=0 if not ms then icl:stop() icl:start(cpd/sp) end
end
rd()
end
function tadj(k)
local d=k==7 and -4 or k==8 and -1 or k==9 and 1 or 4
tfi=tfi+d
if tfi>15 then if tro<15 then tro=tro+1 tfi=0 else tfi=15 end
elseif tfi<0 then if tro>0 then tro=tro-1 tfi=15 else tfi=0 end end
ucpd() rd()
end
function event_grid(x,y,z)
if y==8 then
if x==11 then
mlh=(z==1)
if z==0 then lfc=nil lft=nil end
rd() return
end
if x==12 then mth=(z==1) rd() return end
if x==13 then mph=(z==1) rd() return end
if x==15 then
if z==1 then
blk=false
if vm~=6 then pvm=vm vm=6 else vm=pvm end
end
rd() return
end
if x==16 then
if z==1 then
blk=false
vm=7 pth=true
else pth=false end
rd() return
end
if z==0 then
if x>=1 and x<=4 then cpt=nil clrt=nil shm:stop() end
return
end
if mlh and x>=1 and x<=4 then
mute[x]=not mute[x]
if mute[x] then sof(x) end
rd() return
end
if (mth or mph) and x>=1 and x<=4 then at=x rd() return end
if x>=1 and x<=4 then
if cpt and cpt~=x then
if vm==1 then cpm(1,x,cpt)
elseif vm==11 then cpm(1|7<<13|31<<16,x,cpt)
elseif vm==2 then cpm(15,x,cpt)
elseif vm==12 then cpm(15|7<<21,x,cpt)
elseif vm==3 then cpm(7<<4,x,cpt)
elseif vm==13 then cpm(7<<24,x,cpt)
elseif vm==4 then cpm(7<<7,x,cpt)
end
at=x cpt=nil clrt=nil shm:stop() rd()
gl(x,8,BF) gr()
return
end
at=x cpt=x
if vm>=1 and vm<=4 or vm==11 or vm==12 or vm==13 then clrt=x shm:stop() shm:start(2.0) end
elseif x==6 then
if vm==1 then vm=11
elseif vm==11 then vm=1 blk=false
else blk=false vm=1 end
elseif x==7 then
if vm==2 then vm=12
elseif vm==12 then vm=2 blk=false
else blk=false vm=2 end
elseif x==8 then
if vm==3 then vm=13
elseif vm==13 then vm=3 blk=false
else blk=false vm=3 end
elseif x==9 then
if cfh then tie=not tie else blk=false vm=4 end
end
rd() return
end
if (mlh and not lpg() or mth or mph) and y==7 then
if x==7 then if z==1 then cfh=not cfh if cfh then tmh=false thk=nil shm:stop() end end rd() return end
if x==6 then if z==1 then tmh=not tmh if tmh then cfh=false else thk=nil shm:stop() end end rd() return end
if x==15 and z==1 then pts() return end
if x==16 and z==1 then rts() return end
end
if mlh then
local pg=lpg()
if y>=1 and y<=(pg and 7 or 4) and x>=1 and x<=STEPS then
local t=pg and at or y local p=PM:byte(vm)
if z==1 then
if lft==nil then
lft=t lfc=x
if not lsnap then setlp(p,t,x,x) end
else
local lf=lft
if lsnap then
psnap[lf]={lfc,x,p} lft=nil lfc=nil
else
setlp(p,lf,lfc,x)
for k=lf,lf+16,4 do if not inl(k,ph[k]) then ph[k]=lfc end end
end
end
else
if lft==t and lfc==x then if lsnap then psnap[lft]={x,x,p} end lft=nil lfc=nil end
end
rd()
end
return
end
if mth then
if z==0 then return end
if y>=1 and y<=4 and x>=1 and x<=16 then
setdv(PM:byte(vm),y,x)
rd()
end
return
end
if mph then
if z==0 then return end
if y>=1 and y<=5 and x>=1 and x<=STEPS then
sf(5,at,x,6-y)
rd()
end
return
end
if vm==11 then
if z==1 and (y==1 or y==7) then
if gf(1,at,x)==1 then rchy=y rchx=x shm:start(HT) end
return
end
if z==0 then
if (y==1 or y==7) and rchx==x and rchy==y then
shm:stop()
if gf(1,at,x)==1 then
if y==1 then
local nd=gf(6,at,x)+1
if nd>5 then nd=5 end
sf(6,at,x,nd) rset(at,x,nd,true)
elseif y==7 then
local nd=gf(6,at,x)-1
if nd<1 then nd=1 end
sf(6,at,x,nd)
rset(at,x,nd+1,false)
end
end
rchy=nil rchx=nil rd()
elseif rchy==y then
shm:stop() rchy=nil rchx=nil
end
return
end
if y>=2 and y<=6 and x>=1 and x<=STEPS and z==1 then
if gf(1,at,x)==0 then return end
local slot=7-y
local nd=gf(6,at,x)
if slot>nd then
for i=nd+1,slot-1 do rset(at,x,i,false) end
sf(6,at,x,slot)
rset(at,x,slot,true)
else
rset(at,x,slot,not rget(at,x,slot))
end
rd()
end
return
end
if vm==12 then
if z==0 then return end
if y>=1 and y<=7 and x>=1 and x<=STEPS then
sf(8,at,x,7-y)
rd()
end
return
end
if vm==13 then
if z==0 then return end
if y>=1 and y<=7 and x>=1 and x<=STEPS then
nst(9,x,8-y)
rd()
end
return
end
if vm==6 and z==0 then
if shk and shk[1]==y and shk[2]==x then shk=nil end
if scph and scph[1]==y and scph[2]==x then scph=nil end
if y==7 and x==16 then shphl=false rd() end
return
end
if y==7 and x==7 and (vm==1 or vm==7 or mlh or mth or mph or cfh) then
if z==1 then cfh=not cfh if cfh then tmh=false thk=nil shm:stop() end end
rd() return
end
if y==7 and x==6 and (vm==1 or vm==7 or mlh or mth or mph or tmh) then
if z==1 then tmh=not tmh if tmh then cfh=false else thk=nil shm:stop() end end
rd() return
end
if y==7 and x==15 and z==1 and (mlh or mth or mph) then pts() return end
if y==7 and x==16 and z==1 and (mlh or mth or mph) then rts() return end
if cfh then
if z==0 then return end
if y>=3 and y<=6 and x>=2 and x<=5 then
nsyn=not nsyn rd()
elseif y==3 and x==12 then
lsyn=(lsyn==1) and 0 or 1 rd()
elseif y==3 and x==8 then
tsyn=(tsyn==1) and 0 or 1 rd()
elseif y==4 and x==8 then
ndsy=not ndsy rd()
elseif y==6 and x>=7 and x<=10 then
tsyn=(tsyn==2) and 0 or 2 rd()
elseif y==3 and x==14 then
lsnap=not lsnap if lsnap and lsyn==2 then lsyn=0 end rd()
elseif y==6 and x>=11 and x<=14 then
lsyn=(lsyn==2) and 0 or 2 if lsyn==2 and lsnap then lsnap=false end rd()
end
return
end
if tmh then
if not ms then
if z==1 then
if y==2 and x>=1 and x<=16 then
tro=x-1 ucpd() rd()
elseif y==3 and x>=1 and x<=16 then
tfi=x-1 ucpd() rd()
elseif y==4 and x>=7 and x<=10 then
tadj(x) thk=x shm:start(0.4)
end
elseif z==0 then
if y==4 and thk then thk=nil shm:stop() end
end
else
if z==1 and y==3 and x>=6 and x<=11 then
sp=(x==6 and 12 or x==7 and 8 or x==8 and 6 or x==9 and 4 or x==10 and 3 or 2)
cp=0 rd()
end
end
return
end
if z==0 then
if vm==7 and y==1 and phl then
if phl==x then
shm:stop()
ccc=0 cdc=0 cman=false
ldp(x) rd()
end
phl=nil
end
if vm==7 and y==7 and x==1 and fld then
fld=nil shm:stop() rd()
end
if vm==7 and y==7 and x==2 then
pclh=false rd()
end
if vm==7 and y==7 and x==3 then fsa=nil shm:stop() end
return
end
if vm==1 then
if y>=1 and y<=4 and x>=1 and x<=STEPS then
local k=y*16+x-16
if st[k]&1==1 then st[k]=st[k]&~MTC|VTC else st[k]=st[k]|1 end
rd()
elseif y==7 and x==15 then pts()
elseif y==7 and x==16 then rts()
end
elseif vm==2 then
if y>=1 and y<=7 and x>=1 and x<=STEPS then
nst(2,x,(7-y)+1)
rd()
end
elseif vm==3 then
if y==1 and x>=1 and x<=6 then go2[at]=x rd()
elseif y>=2 and y<=7 and x>=1 and x<=STEPS then
nst(3,x,y)
rd() end
elseif vm==4 then
if y==1 and x>=1 and x<=16 then gdu[at]=x rd()
elseif y>=2 and y<=7 and x>=1 and x<=STEPS then
nst(4,x,7-y)
rd() end
elseif vm==6 then
if sch and y==sch and x>=1 and x<=16 then
TCH[sch]=x sch=nil rd()
elseif y>=1 and y<=4 and x==1 and not sch then
sch=y rd()
elseif y>=1 and y<=4 and x==2 and not sch then
tclk[y]=not tclk[y] for k=y+4,y+12,4 do ph[k]=tclk[y] and ls[k] or ph[y] end rd()
elseif (y==6 or y==7) and x>=1 and x<=8 then
local slot=y==6 and x or x+8
if shphl then
SD[slot]=gSDR(slot)
if asd==slot then si={tu(SD[slot])} crs() end
elseif scph then
local src=scph[1]==6 and scph[2] or scph[2]+8
SD[slot]={tu(SD[src])}
asd=slot si={tu(SD[slot])} crs()
scfl=slot scph=nil shm:stop() shm:start(0.4)
shk=nil bsc() rd()
return
else
SD[asd]={tu(si)}
if slot~=asd then asd=slot si={tu(SD[slot])} crs() end
scph={y,x}
end
shk=nil bsc() rd()
elseif x>=4 and x<=8 and y>=1 and y<=4 then
sdir[y]=x-3 ddr[y]=1 rd()
elseif y==7 and x==16 then
shphl=true rd()
elseif y==7 and x>=9 and x<=15 then
local o=WK:byte(x-8) local wk=48+o
if shphl then
if x~=11 and x~=15 then sr=(sr==wk+1) and wk or wk+1 else sr=wk end
else
if sr==wk and x~=11 and x~=15 then sr=wk+1 elseif sr==wk+1 then sr=wk else sr=wk end
end
bsc() rd()
elseif x>=9 and x<=16 and y>=1 and y<=6 then
local idx=7-y
local ni=8-y
local nv=x-9
if shk and shk[1]==y then
sadj[ni]=nv-si[idx]
bsc() rd()
elseif shphl and idx<6 then
local d=nv-si[idx] si[idx]=nv si[idx+1]=mx(si[idx+1]-d,0)
sadj[ni]=0 SD[asd]={tu(si)} bsc() rd()
else
si[idx]=nv sadj[ni]=0 SD[asd]={tu(si)} shk={y,x} bsc() rd()
end
end
elseif vm==7 then
if y==1 and x>=1 and x<=NP then
if pclh then
pats[x]=nil psx[x]=false pcall(pset_write,x,"")
if ap==x then ap=1 end
cg("collect")
rd()
elseif pth then
cued=x rd()
else
phl=x shm:start(1.0)
end
elseif y==2 and x>=1 and x<=16 then
cclk=x cman=true rd()
elseif y==7 and x==1 then
fld=get_time() shm:stop() shm:start(2.0)
elseif y==7 and x==2 then
pclh=true rd()
elseif y==7 and x==3 then
fsa=get_time() shm:stop() shm:start(2.0)
elseif y==7 and x==15 then pts()
elseif y==7 and x==16 then rts()
end
end
end
bsc()
ap=1 pats={} psx={}
vm=1 at=1
nsyn=true lsyn=2 tsyn=0 ndsy=false tie=false
mlh=false mth=false mph=false cfh=false tmh=false lfc=nil lft=nil
ph={} ls={} le={} dv2={} dc={} ddr={} an={}
go2={1,1,1,1} gdu={9,9,9,9} sdir={1,1,1,1}
mute={false,false,false,false}
tclk={false,false,false,false}
PM="\1\2\3\4\1\1\1\1\1\1\5\6\2"
blk=false bct=0 shphl=false
lsnap=false psnap={}
for i=1,64 do st[i]=STD end
for k=1,24 do ph[k]=1 ls[k]=1 le[k]=6 dv2[k]=1 dc[k]=0 ddr[k]=1 end
for t=1,4 do an[t]=-1 end
lc={0,0,0,0}
ms=false tr2=false cp=0 pt={} PB=8 sp=6 cpls=false cbt=0
thk=nil sch=nil cpt=nil clrt=nil fld=nil fsa=nil psi=false pclh=false
nom={}
for t=1,4 do
local tc=t
nom[t]=metro.init(function()
if an[tc]>=0 then midi_note_off(an[tc],0,TCH[tc]) an[tc]=-1 end
nom[tc]:stop()
end,0.1,1)
end
rsc={0,0,0,0}
ram={}
for t=1,4 do
local tc=t
ram[t]=metro.init(function()
local s=ph[tc+16]
rsc[tc]=rsc[tc]+1
if rsc[tc]>gf(6,tc,s) then ram[tc]:stop() return end
if rget(tc,s,rsc[tc]) then son(tc) end
end,.1)
end
icl=metro.init(tka,.125)
icl:stop()
idl=metro.init(rd,0.25)
idl:start()
phl=nil HT=0.8 scph=nil pvm=1 scfl=nil
cued=nil cclk=16 ccc=0 cdc=0 clt=1 cman=false pth=false pflash=0
rchy=nil rchx=nil
shm=metro.init(function()
if thk then
tadj(thk)
elseif rchy~=nil and rchx~=nil then
if rchy==1 then
for s=1,STEPS do
local nd=gf(6,at,s)
for i=1,nd do rset(at,s,i,true) end
end
elseif rchy==7 then
local k=at*16+rchx-16
st[k]=st[k]&~(7<<13|31<<16)|VTC
end
rchy=nil rchx=nil shm:stop() rd()
elseif clrt then
local t=clrt
if vm==1 or vm==11 then
clm(-1,STD,t)
go2[t]=1 gdu[t]=9
sdir[t]=1 tclk[t]=false
sof(t) ram[t]:stop() rsc[t]=0 lc[t]=0
for k=t,t+20,4 do ls[k]=1 le[k]=6 dv2[k]=1 ph[k]=1 dc[k]=0 ddr[k]=1 end
elseif vm==2 or vm==12 then
clm(15,1<<1,t)
elseif vm==3 then
clm(7<<4,7<<4,t) go2[t]=1
elseif vm==4 then
clm(7<<7,5<<7,t) gdu[t]=9
elseif vm==13 then
clm(7<<24,6<<24,t)
end
clrt=nil shm:stop() rd()
gl(t,8,BF) gr()
elseif phl and vm==7 then
local ok=pcall(svp,phl)
if ok then ap=phl pflash=3 end
shm:stop() phl=nil rd()
elseif fld or fsa then
if fld then fload() pflash=3 rd() end
if fsa then fsaveall() pflash=3 fsa=nil rd() end
shm:stop()
elseif scfl then scfl=nil shm:stop() rd()
else shm:stop() end
end,0.4)
shm:stop()
grid_led_all(F)
tr2=false
cg("collect")
rd()
function cleanup() ano() end
