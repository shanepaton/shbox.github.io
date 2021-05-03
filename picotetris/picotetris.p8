pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--pico tetris
--by vanessa♥

version={1,1}
cartdata("pico_tetris_v1_0")

effects={
 --yeah sorry, these are the only
 --ones that survived
 clear_swoosh=true,
 clear_crush=true,
 drop_push=true,
 title_bg=true
}

sfxplay=sfx
sfx=function(...)
 if(not mute)sfxplay(...)
end

function _init()
 clrs,ocamx,ocamy,camx,camy,game,tetroms,debugstr,start,do_update,mute={},0,0,0,0,{kick=unp("2212112414221213201022323124342232332030223231243422121320102212112414223233203022320230032202320134221242144122421243102242124310223202300322023201342212421441")},{all="ijlostz"},"",true,true,false
 for i=1,#tetroms.all do
  tetroms[sub(tetroms.all,i,i)]=init_tetrom(15+i)
 end
 menuitem(3,"toggle mute",function()mute=not mute end)
 init_menu()
end

function _update60()
 cls()
 camera()
 bg.draw()
 camera(camx,camy)
 ocamx,ocamy,camx,camy=camx,camy,0,0
 anim.update()
 if in_menu then 
  update_menu()
  draw_menu()
 elseif in_options then 
  update_options()
  draw_options()
 elseif in_scores then 
  update_scoremenu()
  draw_scoremenu()
 else 
  update_game()
  draw_game()
 end

 anim.draw()
 --[[debug
 print(debugstr,4,4,10)
 print("mem:"..flr(stat(0)/2048*100).."%",4,11,10)
 print("cpu:"..flr(stat(1)*100).."%",4,18,10)
 print("fps:"..stat(7),4,25,10)
 --]]
end

--helper functions, data

--this little function saved me
--232 tokens on kick data! :)
function unp(s)
 local a,z1,z2={},{"x","i"},{"cw","ccw"}
 for k1 in all(z1)do
  a[k1]={}
  for k2 in all(z2)do
   local k={}
   
   for i=1,4 do
    k[i]={}
    for j=1,5 do
     k[i][j]={}
     for n=1,2 do
      k[i][j][n]=(tonum(sub(s,1,1))or 2)-2
      s=sub(s,2,#s)
   end end end
   
   a[k1][k2]=k
 end end
 
 return a
end

function confirm()
 return btnp(4)or btnp(5)
end

function index(list,elem)
 for i=1,#list do
  if(list[i]==elem)return i
end end

function getdigit(x,n,b)
 return flr(x/(b^n))%(b)
end

function setdigit(x,n,d,b)
 return x+(b^n)*(d-getdigit(x,n,b))
end

function get_num(d,m,n)
 if(0==n)return d%m
 return flr((d%(m^(n+1)))/(m^n))
end

function put_num(d,m,x)
 return d*m+x
end

function set_bit(num,n,v)
 return v and bor(num,2^n) or band(num,0xffff-2^n)
end

function get_bit(num,n)
 return 0!=band(num,2^n)
end

--i said dont look it up!!!
function secret_grade()
local h=fh(1)
if(not h)return 0
local l if h==1 then l=true elseif h==10 then l=false else return 0 end
for i=2,19 do if l then
if((10-abs(10-i))!=fh(i))break 
else 
if (abs(10-i)+1!=fh(i)) break end
h=i end return h end function  fh(row)
local r,h,n=field.matrix[row],false,0
for c=1,#r do if r[c]==0 then n+=1
if 0!=field.matrix[row+1][c]then h=c end end end
if(1!=n)return false
return h
end

function printc_multi(s,y,c,m)
 m=m or 30
 local from,to,found_space=0,0,false

 while to<#s do
  found_space,from=false,to
  to=min(#s,from+m)
  from+=1
    
  if to<#s then
   for i=to,from,-1 do
    if(" "==sub(s,i,i))then
     found_space=true
     to=i-1
     break
  end end end
  printc(sub(s,from,to),y,c)

  y+=7
  if(found_space)to+=1
end end

function print3(s,y,w)
 for i=2,0,-1 do
  printc(s,y+i,7-i,w)
 end
end

function cyclenum(n,low,up)
 low=low or 1
 up=up or low+1
 return((n-low)%(up-low+1))+low
end

function delshift(t,val)
 del(t,val)
 for k,v in pairs(t)do
  if(v>val)t[k]-=1
end end

function isin(table,val)
 for v in all(table)do
  if(v==val)return true
 end
 return false
end

function convert_time(t)
 return lpad(flr(flr(t)/60),"0",2)..":"..lpad(flr(t)%60,"0",2)
end

function printc(s,y,c,w)
 w=w or 0
 s=tostr(s)
 local len=max(0,(#s+w)*4-1)
 local x=flr((128-len)/2)
 print(s,x,y,c)
end

function btoi(b)
 return b and 1 or 0
end

function gr(n)
 if(0==n)return""
 if(19<=n)return"gm"
 if(10>n)return 10-n
 return"s"..(n-9)
end

function combine(t1,t2)
 local t={}
 cp_table(t1,t)
 cp_table(t2,t)
 return t
end

function cp_table(from,to)
 if(not from)return

 for k,v in pairs(from)do
  if type(from[k])=="table" then
   to[k]=to[k]or{}
   cp_table(from[k],to[k])
  else
   to[k]=v
end end end

function anot(b1,b2)
 return b1 and(not b2)
end

function get_sprite(n)
 local bytes,addr={},512*flr(n/16)+4*(n%16)

 for i=0,31 do
  bytes[i+1]=peek(addr+(i%4)+64*flr(i/4))
 end

 return bytes,fget(n)
end

function printr(str,x,y,clr)
 local xpos=128
 str=tostr(str)
 if(x)xpos=x-(#str*4-1)
 print(str,xpos,y,clr)
end

function lpad(str,char,len)
 char=char or "0"
 len=len or 2

 local res=""
 str=tostr(str)
 for i=1,(len-#str)do
  res=res..sub(char,1,1)
 end
 return res..str
end

function delchar(s,i)
 if((0>i)or(#s<i))return ""
 return sub(s,1,i-1)..sub(s,i+1,#s)
end

function arrlshift(a,x)
 if(#a<x)return a
 for i=x,#a-1 do
  a[i]=a[i+1]
 end
 a[#a]=nil
 return a
end
-->8
--globals, init

function init_tetrom(num)
 local t,bytes,flags={pattern={}},get_sprite(num)

 for a=1,4 do
  add(t.pattern,{{},{},{},{}})
 end

 for i=1,32 do
  local left,right,clm,tpat=bytes[i]%16,flr(bytes[i]/16),(2*i-1)%4,t.pattern[ceil(((i-1)%4+1)/2)+2*btoi(16<i)][4-((ceil(i/4)-1)%4)]
  if 0!=left then
   tpat[clm]=left
  end
  if 0!=right then
   tpat[clm+1]=right
 end end

 add(clrs,{flags%16,flr(flags/16)})
 t.color=#clrs

 return t
end

function init_matrix(rows,clms)
 local mtx,rr={},gamev.replacerow
 for r=1,rows do
  mtx[r]={}
  for c=1,clms do
   mtx[r][c]=rr and rr[c]*(flr(rnd(7))+1) or 0
 end end
 return mtx
end

function init_window(x,y,w,h,m)
 local win={
  x=x,y=y,w=w,h=h,matrix=m}
 return win
end

function init_game(gamev,dasv,arev,func)
 tetromsfx={
  i=8,o=9,t=7,j=6,l=5,s=3,z=4}

 --windows
 field=init_window(33,3,10,20,init_matrix(40,10))
 hold=init_window(2,14,4,4)
 preview=init_window(100,14,4,4)

 bg.set("grid")

 bufmtx=init_matrix(40,10)
 
 --delay after locking
 are={cnt=0,len=10,use=false,clearanim=false}

 --delayed auto shift
 --(also does soft drop,0 delay)
 das={
  --delay vars, not used for drop
  d={len=10,cnt=0,done=false,
   l=false,r=false
  },
  --left,right,down
  btn={false,false,false},
  h={speed=1,cnt=0},
  --used for soft drop
  v={speed=1,cnt=0}
 }

 --scores and stuff
 game={
  score=0,
  lines=0,
  linesneeded=150,
  level=1,
  drops=0,
  time=0,
  timegiven=0,
  --true makes game end after
  --<timeleft> seconds
  usetime=false,

  --set in _init(), keep it
  kick=game.kick,

  --higher is better,this inverses that
  invscr_ordering=false,

  pts={line={10,30,50,80}},
  name={line={
   "single","double","triple","tetris!"
  }},
  sprite={
   normal=1,
   active=2,
   hold=1,
   ghost=1,
   preview=1
  },
  
  gridspr=0,
  laser=false,
  progbar=true,
  bganim=true,
  
  usegrb=false,
  grbp=90,

  combo=0,
  maxcombo=0,
  secretgrade=0,
  invisible=false,
  darkghost=true,
  invrot=false,
  ssprmini=false,

  state={
   show=false,
   lns=0,
   pts=0
  },

  --game is over if true
  topout=false,
  justended=false,

  lv={
   progress=0,
   goal=30,
   --how much progess per
   --line clear
   vals={1,3,5,8}
  },

  --stats shown on the left
  --bottom-to-top
  stats={},

  --how many pieces in preview
  prevlen=6,

  spawn={3,18},

  --frames spent per row
  gravity=0,
  dropgrav=1,
  gravcnt=0,
  
  --extra frames of are after
  --line clear
  lnclr_delay=10,

  --when on floor, how many
  --frames before locking
  lockdelay=30,
  lockcnt=0,
  locking_harddrop=true,

  --how many moves allowed before
  --locking anyways
  lockmoves=15,
  lockmvcnt=0,

  --tetromino sequence
  seq="",

  ghost={
   y=0,draw=true,
   --color={1,13}
   color={13,1}
  },
  --{name,orientation,x,y}
  curtet={},
  hldtet={"",1},
  holdused=false,
  
  getscore=scr
 }

 --copy settings so they take
 --effect
 cp_table(gamev,game)
 cp_table(dasv,das)
 cp_table(arev,are)
 if(func)func()
 
 calc_grav()
 level_changes(game.level)
 game.hiscore=game.getscore(getscores(mode)[1],true)
 game.seq=rand_bag()
 next_tetrom(game.prevlen)

 menuitem(1,"retry",function()
  init_game(gamev,dasv,arev,modes[modes.list[mode]].func)
 end)
 menuitem(2,"back to title",init_menu)
end
-->8
--update routines, game logic

function das_delay()
 local d=das.d
 if(d.done)return true

 if d.cnt>=d.len then
  d.done=true
  d.cnt=0
  return true
 end

 d.cnt+=1
 return false
end

function handle_das()
 local bt,x,y={btn(0),btn(1),btn(3)},0,0
 local d,h,v=das.d,das.h,das.v

 --horizontal
 if not(bt[1]and bt[2])then
  if bt[1]then
   d.r=false
   if(not das.btn[1])or(not d.l)then
    x=-1
    d.done=false
    d.cnt=0
    d.l=true
   elseif das_delay() then
    h.cnt+=1
    while h.cnt>=h.speed do
     h.cnt-=h.speed
     x-=1        
   end end

  elseif bt[2]then
   d.l=false
   if(not das.btn[2])or(not d.r)then
    x=1
    d.done=false
    d.cnt=0
    d.r=true
   elseif das_delay() then
    h.cnt += 1
    while h.cnt>=h.speed do
     h.cnt-=h.speed
     x+=1
   end end

  else--neither pressed
   h.cnt=0
   d.done=false
   d.l=false
   d.r=false
  end

 else--both pressed
  d.done = false
  d.l = false
  d.r = false
 end

 --vertical
 if(bt[3]and not das.btn[3])then y=-1
 elseif(bt[3]and das.btn[3])then
  v.cnt+=1
  while(v.cnt>=v.speed)do
   v.cnt-=v.speed
   y-=1
  end
 else
  v.cnt=0
 end

 das.btn=bt
 return x,y  
end

function kick(iscw)
 local d=game.kick

 --choosing the right tests
 d=("i"==game.curtet[1])and d.i or d.x
 d=iscw and d.cw or d.ccw
 d=d[game.curtet[2]]

 --do tests
 for i=1,#d do
  if move(d[i][1],d[i][2])then
   return true
 end end
 return false
end

function legal_pos(t)
 local m=field.matrix
 for row=1,4 do
 for clm=1,4 do
  --current block
  local b=tetroms[t[1]].pattern[t[2]][row][clm]
  if(b)then
   local x,y=clm+t[3],row+t[4]

   --here come the checks
   if((1>x)or(#m[1]<x))return false
   if((1>y)or(#m<y))return false
   if(0!=m[y][x])return false
 end end end
 return true
end

function reset_lockdelay()
 if(game.curtet[4]==game.ghost.y)then
  game.lockmvcnt+=1
 end
 if(game.lockmvcnt<=game.lockmoves)then
  game.lockcnt=0
end end

function move_vert(dist)
 if(0==dist)return true
 game.curtet[4]+=dist

 --undo if illegal
 if(not legal_pos(game.curtet))then
  game.curtet[4]-=dist
  return false
 end

 --reset counters
 game.gravcnt=0
 reset_lockdelay()

 update_ghost()
 sfx(12)
 return true
end

function move_horiz(dist)
 if(0==dist)return true
 game.curtet[3]+=dist

 if(not legal_pos(game.curtet))then
  game.curtet[3]-=dist
  return false
 end

 reset_lockdelay()
 update_ghost()
 sfx(13)
 return true
end

function move(dx,dy)
 game.curtet[3]+=dx
 game.curtet[4]+=dy

 if(not legal_pos(game.curtet))then
  game.curtet[3]-=dx
  game.curtet[4]-=dy
  return false
 end

 update_ghost()
 return true
end

function rotate_curtet(iscw)
 local temp=game.curtet[2]
 if(not iscw)then
  game.curtet[2]-=2
 end
 game.curtet[2]%=4
 game.curtet[2]+=1

 --wallkick
 if(not kick(iscw))then
  game.curtet[2]=temp
  sfx(0)
  return false
 end

 reset_lockdelay()
 update_ghost()
 if(iscw)then sfx(1)else sfx(2)end
 return true
end

function tetrom_fall()
 game.curtet[4]-=1
end

function update_ghost()
 local c=game.curtet
 local t={c[1],c[2],c[3],c[4]}

 --try moving down
 while(legal_pos(t))do
  t[4]-=1
 end

 --illegal, undo last move
 t[4]+=1

 --move ghost
 game.ghost.y=t[4]
end

function rnd_row(r,h)
 local m=field.matrix
 m[r]={}
 for i=1,10 do
  m[r][i]=0
  if i!=h then
   m[r][i]=flr(rnd(7))+1
 end end
end

function counters()
 game.time+=1/60
 if game.usetime and game.time>=game.timegiven then
  game.topout=true
  game.justended=true
  return
 end

 --are, spawning tetromino
 if(are.use)then
  if(are.cnt>=are.len)then
   if(not are.clearanim)then
    --next_tetrom(game.prevlen)
    are.use=false
    are.cnt=0
   end
  else 
   are.cnt+=1 
  end
 else

  --gravity
  if(game.ghost.y<game.curtet[4])then
   if(not are.use)then
    local g=game.gravity

    while(game.gravcnt>=g)do
     if game.ghost.y==game.curtet[4]then
      game.gravcnt=0
      break
     end
     tetrom_fall()
     sfx(12)
     game.gravcnt=max(0,game.gravcnt-g)
     game.lockcnt=0
    end
    game.gravcnt+=1
   end
  end
  
  --lock delay
  if(game.ghost.y==game.curtet[4])then
   if(game.lockcnt>=game.lockdelay)then
    decay_tetrom(false)
    game.lockcnt=0
   else
    game.lockcnt+=1
end end end end

function btn_handler()
 local z=not are.use
 local x,y=handle_das()
 while(0!=x and z)do
  move_horiz(x/abs(x))
  x-=x/abs(x)
 end
 while(0!=y and z)do
  local b=move_vert(y/abs(y))
  if((not b)and(not game.locking_harddrop))decay_tetrom()
  y-=y/abs(y)
 end

 --hard drop,hold
 if(btnp(2) and z)hard_drop()
 if btn(4)and btn(5)then swap_hold()
 else
  --rotation
  local a,b=5,4
  if(game.invrot)a,b=b,a
  if(btnp(a))rotate_curtet(false)
  if(btnp(b))rotate_curtet(true)
 end
end

function update_game()
 if(not do_update)return

 if(not game.topout)and game.haswon and game.haswon()then
  game.topout=true
  game.justended=true
 end
 if game.topout then
  if game.justended then
   game.playerwon=true
   if game.haslost and game.haslost()then
    game.playerwon=false
   elseif game.haswon then
    game.playerwon=game.haswon()
   end
   game.justended=false
   if(game.playerwon)addscore(mode,1,game.getscore())
  end

  --reset game
  if confirm() then
   init_menu()
  end return
 end

 --normal game stuff
 btn_handler()
 counters()
end

function level_changes(n)
 game.grbp-=1
 if(0==n%5)bg.set("grid",{col=1+flr(n/5)})
 if 10<=n then 
  game.ghost.draw=false
  game.lockdelay=23
  if 15<=n then
   game.lockdelay=17
   are.len=6
   game.lnclr_delay=4
   if 20<=n then
    game.lockdelay=15
    are.len=4
end end end end

--how many frames per row
function calc_grav()
 local l=(game.level-1-5*btoi(game.level>=10))*2
 game.gravity=60*(0.8-(l*0.007))^l
end

function rand_bag()
 --dont want to mutate original
 local ta,seq=tetroms.all,game.seq
 
 for i=#ta,2,-1 do
  local n=flr(rnd(i))+1
  seq=seq..sub(ta,n,n)
  ta=delchar(ta,n)
 end
 
 --append last remaining char
 return seq..ta
end

function next_tetrom(len)
 local ltr,c=sub(game.seq,1,1),game.curtet
 --name,orientation,x,y
 c[1]=ltr
 c[2]=1
 c[3]=game.spawn[1]
 c[4]=game.spawn[2]

 --special treatment for i
 if game.spawnivert and "i"==ltr then
  c[2]+=1
  c[3]-=1
  c[4]+=2
 end
 --updating sequence
 game.seq=sub(game.seq,2,#game.seq)
 if (len or 0)>=#game.seq then
  game.seq=rand_bag()
 end

 --block out
 if not legal_pos(game.curtet)then
  game.topout=true
  game.justended=true
  return
 end

 --move 1 line down if possible
 move_vert(-1)
 update_ghost()
end

function update_lines(lines)
 if(0==lines)return
 local glv=game.lv

 game.lines+=lines
 glv.progress+=glv.vals[lines]
 
 --update level
 if(glv.progress>=glv.goal)then
  sfx(21)
  game.level+=1
  glv.progress-=glv.goal
  
  level_changes(game.level)
 end

 calc_grav()
end

function update_scores(lines)
 --should be impossible, but
 --making sure anyways
 lines=min(lines,4)
 if(1>lines)then
  game.combo=0
  return
 end

 game.combo+=1
 game.maxcombo=max(game.combo,game.maxcombo)

 local pts=flr(game.pts.line[lines]*(1+(game.level-1)/10))
 game.score+=pts

 --lines, process, level
 update_lines(lines)

 --sfx
 if(0!=lines)then
  if game.laser then
   sfx(26+(game.combo-1)%7)
  else
   if(1>=game.combo)then sfx(13+lines)
   else sfx(16+min(4,game.combo))
end end end end

function check_rows()
 local counter=0
 local m=field.matrix

 local row,arr=1,{}
 while row<=#m do
  --find out if full
  local full=true
  for clm=1,#m[row] do
   if 0==m[row][clm] then
    full=false
    break
  end end

  if full then
   if(0==counter)cp_table(m,bufmtx)
   counter+=1
   
   --anim
   local x,y=34,124-6*(row+counter-1)
   if effects.clear_crush then
    for i=0,9 do
     anim.new("crush",{x=x+6*i,y=y,c=clrs[m[row][i+1]]})
   end end
   if effects.clear_swoosh then
    anim.new("swoosh",{x=x,y=y,w=60,h=6})
    anim.update()--necessary for swoosh
   end

   if "table"==type(game.garbage) then
    delshift(game.garbage,row)
   end

   --delete row
   arrlshift(field.matrix,row)

   --add empty row
   --or predefined garbage
   local new={}
   local rr=game.replacerow
   if rr then
    for i=1,10 do
     if 0==rr[i] then new[i]=0
     else new[i]=flr(rnd(7))+1
    end end
   else
    for i=1,10 do new[i]=0
   end end
   add(field.matrix,new)
  else--not full
   row+=1
 end end
 
 return counter
end

function swap_hold()
 if (game.holdused) return

 local h,c=game.hldtet,game.curtet
 local tmp={h[1],h[2]}

 h[1]=c[1]
 h[2]=1

 c[1]=tmp[1]
 c[2]=tmp[2]
 c[3]=game.spawn[1]
 c[4]=game.spawn[2]

 --special treatment for i
 if game.spawnivert and "i"==game.curtet[1] then
  c[2]=2
  c[3]-=1
  c[4]+=2
 end

 if ""==c[1] then
  next_tetrom(game.prevlen)
 else
  --move 1 line down if possible
  move_vert(-1)
 end

 update_ghost()
 game.holdused = true
 sfx(22)
end

function decay_tetrom(hard)
 local t=game.curtet
 for row=1,4 do
 for clm=1,4 do
  local lockout = true

  --current block
  local b=tetroms[t[1]].pattern[t[2]][row][clm]
  if b then
   --copying block to
   --according pos in matrix
   local x=clm+t[3]
   local y=row+t[4]
   field.matrix[y][x]=tetroms[t[1]].color
   --at least one block
   --locked in visible
   --area, all ok!
   if(20>y)lockout=false
 end end end

 if lockout then
  game.topout=true
  game.justended=true
  return
 end

 game.drops+=1

 --reset counters for next tetrom
 game.gravcnt=0
 game.lockcnt=0
 game.lockmvcnt=0

 --removing any state messages
 game.state.show=false

 --check rows, award points
 local rcnt=check_rows()
 update_scores(rcnt)
 
 if game.usegrb then
  if(rnd(100)>99)push_stack(1)
  if(rnd(100)>game.grbp)push_stack(1)
 end

 next_tetrom(game.prevlen)
 
 are.use=true
 are.cnt=0
 if(0!=rcnt)are.cnt=-game.lnclr_delay
 if game.scr_grading then
  game.secretgrade=secret_grade()
 end

 sfx(tetromsfx[game.curtet[1]])
 if hard then sfx(11)
 else sfx(10)end

 game.holdused=false
end

function push_stack(l)
 local m=field.matrix
 for i=#m,l+1,-1 do
  m[i]=m[i-1]
 end
 m[l]={}
 rnd_row(l,flr(rnd(10))+1)
 update_ghost()
end

function hard_drop()
 --just to make sure
 update_ghost()

 --drop and decay
 game.curtet[4]=game.ghost.y
 if game.locking_harddrop then
  decay_tetrom(true)
  if effects.drop_push then
   anim.new("push")
end end end
-->8
--drawing routines

--x,y are grid coords
function draw_block(w,x,y,c1,c2,s)
 if((0>x)or(w.w-1<x)or(0>y)or(w.h-1<y))return
 
 pal(7,c1,0)
 pal(6,c2,0)
 spr(s or game.sprite.normal,w.x+1+6*x,w.y+(w.h-1)*6+1-6*y,0.75,0.75)
 pal()
end

--draws an entire tetromino
function draw_tetrom(t,p,w,x,y,ghost)
 if(not game.ghost.draw and ghost)return

 --iterate over all blocks
 for row=1,4 do
 for clm=1,4 do

  --any value means block exists
  if t.pattern[p][row][clm] then

   --this mess is worth 6 tokens, apparently
   local s,c=ghost and game.sprite.ghost or game.sprite.active,(ghost and game.darkghost)and game.ghost.color or clrs[t.color]

   if w==hold then
    s=game.sprite.hold
   elseif w==preview then
    s=game.sprite.preview
   end

   draw_block(w,clm-1+x,row-1+y,c[1],c[2],s)
end end end end

--3*3 px per block
function mini_tetrom(ltr,x,y,s)
 local t=tetroms[ltr]
 local c=clrs[t.color]

 for row=1,4 do
 for clm=1,4 do
  if t.pattern[1][row][clm] then
   local xpos,ypos=x+3*(clm-1),y+3*(4-(row-1))
   if s or game.ssprmini then
    s=s or game.sprite.preview
    pal(7,c[1],0)
    pal(6,c[2],0)
    sspr(8*s,0,6,6,xpos,ypos,3,3)
    pal()
   else
    rectfill(xpos,ypos,xpos+2,ypos+2,c[1])
    pset(xpos+1,ypos+1,c[2])
end end end end end

function draw_window(w,b,bg)
 local cornerx,cornery=w.x+1+6*w.w,w.y+1+6*w.h

 if bg then
  rectfill(w.x,w.y,cornerx,cornery,bg)
  if game.ghost.draw then
   for clm=9,0,-1 do
   for row=0,19 do
    spr(23+game.gridspr,w.x+6*clm,w.y+6*row)
 end end end end

 --borders
 if b then
  for i=0,2 do
   rect(w.x-i,w.y-i,cornerx+i,cornery+i,7-i)
  end
  
  if game.progbar then
   local c,h=progcols[min(#progcols,1+flr(game.level/5))],(6*w.h+6)*(game.lv.progress/game.lv.goal)
   
   clip(w.x-2-ocamx,cornery+4-ocamy-h,6*w.w+6,h)
   for i=0,2 do
    rect(w.x-i,w.y-i,cornerx+i,cornery+i,c[i+1])
   end
   clip()
 end end

 --matrix
 if w.matrix and(not game.invisible or game.topout)then
  local m=are.clearanim and bufmtx or w.matrix

  for row=1,#m do
  for clm=1,#m[1] do
  local blk=m[row][clm]
  if 0!=blk then
   local c=clrs[blk]
   draw_block(w,clm-1,row-1,c[1],c[2])
end end end end end

function draw_stats()
 for i=1,#game.stats do
  local s,c=game.stats[i],""
  print(s,3,127-17*i,6)

  if s=="score" then c=lpad(game.score,"0",5)
  elseif s=="time" then
   if game.usetime then
    c=convert_time(max(0,game.timegiven-game.time))
   else
    c=convert_time(game.time)
  end
  elseif s=="left"  then c=max(0,game.linesneeded-game.lines)
  elseif s=="combo" then c=game.maxcombo
  elseif s=="grade" then c=gr(game.secretgrade)
  else c=game[s] or "" end

  printr(c,29,134-17*i,7)
end end

function draw_game() 
 print("hold",3,5,6)
 draw_window(hold)
 local ht=game.hldtet
 if ""!=ht[1]then
  draw_tetrom(tetroms[ht[1]],ht[2],hold,0,0)
 else
  print("❎+🅾️",5,17,5)
 end

 draw_stats()

 print("next",101,5,6)
 draw_window(preview)
 if ""!=game.seq then
  local t=sub(game.seq,1,1)
  draw_tetrom(tetroms[t],1,preview,0,0)
 end
 for i=2,game.prevlen do
  local t=sub(game.seq,i,i)
  mini_tetrom(t,101,27+8*(i-2))
 end
 
 print("best",101,110,6)
 print(game.hiscore,101,117,7)

 draw_window(field,true,0)
 local ct=game.curtet
 if ""!=ct[1] and(not are.use)then
  draw_tetrom(tetroms[ct[1]],ct[2],field,ct[3],game.ghost.y,true)
  draw_tetrom(tetroms[ct[1]],ct[2],field,ct[3],ct[4])
 end
 
 if game.topout then
  if game.playerwon then
   rectfill(34,59,93,72,7)
   printc("well done!",60,12)
   if game.getscore then
    printc(game.getscore(nil,true),67,0)
   end
  else
   rectfill(34,59,93,65,7)
   print("game over",46,60,8)
  end return
end end
-->8
--menu

function init_menu()
 menuitem(2)
 menuitem(1)

 if(effects.title_bg)bg.set("falling")
 in_menu,in_options,in_scores=true,false,false
 gamev,dasv,arev,mode,slc={sprite={}},{d={},h={},v={}},{},mode or 1,1

 options=options or {
  gamev={},
  dasv={d={},h={},v={}},
  arev={},
  sprv={}
 }

 local spr_max=15

 --titles between option items
 opt_titles={[12]="tetromino sprites"}

 --items in option menu
 opt_strs=opt_strs or {
  {name="das delay",
  curr=10,min=0,max=31,
  set=function(self)    
   options.dasv.d.len=self.curr
  end},

  {name="das speed",
  vals={.1,.25,.5,1,2,3,4,5},
  curr=4,
  set=function(self)
   options.dasv.h.speed=self.vals[self.curr]
  end},

  {name="soft drop speed",
  vals={.1,.25,.5,1,2,3,4,5},
  curr=4,
  set=function(self)
   options.dasv.v.speed=self.vals[self.curr]
  end},

  {name="locking hard drop",
  curr=true,
  set=function(self)
   options.gamev.locking_harddrop=self.curr
  end},

  {name="inverse rotation",
  curr=false,
  set=function(self)
   options.gamev.invrot=self.curr
  end},

  {name="dark ghost palette",
  curr=true,
  set=function(self)
   options.gamev.darkghost=self.curr
  end},
  
  {name="sspr in preview",
  curr=false,
  set=function(self)
   options.gamev.ssprmini=self.curr
  end},
  
  {name="laser sfx",
  curr=false,set=function(self)
   options.gamev.laser=self.curr
  end},
  
  {name="animated bg",
  curr=true,set=function(self)
   options.gamev.bganim=self.curr
  end},
  
  {name="progress bar",
  curr=true,set=function(self)
   options.gamev.progbar=self.curr
  end},
  
  {name="well background",
  curr=0,min=0,max=8,set=function(self)
   options.gamev.gridspr=self.curr
  end},

  {name="normal",
  curr=1,min=0,max=spr_max,
  set=function(self)
   options.sprv.normal=self.curr
  end},

  {name="active",
  curr=2,min=0,max=spr_max,
  set=function(self)
   options.sprv.active=self.curr
  end},

  {name="ghost",
  curr=1,min=0,max=spr_max,
  set=function(self)
   options.sprv.ghost=self.curr
  end},

  {name="hold",
  curr=1,min=0,max=spr_max,
  set=function(self)
   options.sprv.hold=self.curr
  end},

  {name="preview",
  curr=1,min=0,max=spr_max,
  set=function(self)
   options.sprv.preview=self.curr
  end}}

 if(start)readdata()
 start=false
 
 for o in all(opt_strs)do
  o:set()
 end

 if options then
  cp_table(options.gamev,gamev)
  cp_table(options.dasv,dasv)
  cp_table(options.arev,arev)
  cp_table(options.sprv,gamev.sprite)
  writedata()
 end
end

function update_menu()
 if(not do_update)return
 if btnp(2)then
  slc=cyclenum(slc-1,1,4)
  sfx(12)
 end
 if btnp(3)then
  slc=cyclenum(slc+1,1,4)
  sfx(12)
 end
 --start game
 if 1==slc then
  if confirm()then
   in_menu=false
   local m=modes[modes.list[mode]]
   cp_table(m.gamev,gamev)
   cp_table(m.dasv,dasv)
   cp_table(m.arev,arev)
   init_game(gamev,dasv,arev,m.func)
  end
 --mode selection
 elseif 2==slc then
  if btnp(0)then
   sfx(13)
   mode-=1
   if(0==mode)mode=#modes.list
  elseif btnp(1)then
   sfx(13)
   mode%=#modes.list
   mode+=1
  end
 --option menu
 elseif 3==slc and confirm()then
  init_options()
 --highscore menu
 elseif 4==slc and confirm()then
  init_scoremenu()
end end

function draw_menu()
 --border
 for i=0,2 do
  rect(i,i,127-i,127-i,5+i)
 end

 print3("pico",18)
 print(version[1].."."..version[2],4,119,5)

 --logo
 map(0,0,21,27,11,3)
 
 printc("start!",65,btoi(1==slc)+6)

 local m=modes.list[mode]
 local s="mode: "..m
 if(2==slc)s="⬅️ "..s.." ➡️"
 printc(s,72,btoi(2==slc)+6,2*btoi(2==slc))

 printc("options",79,btoi(3==slc)+6)

 if (2==slc) then
  printc_multi(modes[m].desc,100,5,27)
 end

 printc("high scores",86,btoi(4==slc)+6)
end

function init_options()
 in_menu,in_options,in_scores,opt_slc=false,true,false,1
end

function update_options()
 if(not do_update)return
 if btnp(2)then
  sfx(12)
  opt_slc=cyclenum(opt_slc-1,1,#opt_strs+1)
 end
 if btnp(3)then
  sfx(12)
  opt_slc=cyclenum(opt_slc+1,1,#opt_strs+1)
 end

 --an option is selected
 if opt_slc<=#opt_strs then
  local o=opt_strs[opt_slc]

  --what to do when
  --⬅️ or ➡️ pressed
  if(btnp(0)or btnp(1)) then
   sfx(13)
   if "boolean"==type(o.curr)then
    o.curr=not o.curr
   else
    local minv=o.min or 1
    local maxv=o.max or#o.vals
    if(btnp(0))o.curr=cyclenum(o.curr-1,minv,maxv)
    if(btnp(1))o.curr=cyclenum(o.curr+1,minv,maxv)
  end end
    
 --back to title is selected
 else
  --❎/🅾️ confirm
  if confirm() then
   --set all options
   for o in all(opt_strs) do
    o:set()
   end
            
   --switch to title menu
   init_menu()
end end end

function draw_options()
 cls()
 for i=0,2 do
  rect(i,i,127-i,127-i,5+i)
 end
 print3("options",4)

 --tetroms at the bottom  
 for i=1,3 do drawt(opt_strs[11+i].curr,5,45+20*i,opt_strs[11+i].name)end
 for i=1,2 do drawt(opt_strs[14+i].curr,105,65+20*i,opt_strs[14+i].name,true)end
 
 local s=nil
 if(opt_strs[7].curr)s=opt_strs[13].curr
 mini_tetrom("t",100,100,s)

 --options
 local x=6
 for i=1,#opt_strs do
  local o=opt_strs[i]
  local s=o.name..": "
  x+=6

  if opt_titles[i] then
   print3(opt_titles[i],x+2)
   x+=10
  end

  if o.vals then
   s=s..o.vals[o.curr]
  elseif"boolean"==type(o.curr) then
   s=s..(o.curr and"yes"or"no")
  else
   s=s..o.curr
  end

  if(opt_slc==i)s="⬅️ "..s.." ➡️"
  printc(s,x,btoi(opt_slc==i)+6,2*btoi(opt_slc==i))
 end

 x+=7
 printc("back to title",x,btoi(opt_slc==#opt_strs+1)+6)
end

function drawt(s,x,y,name,r)
 if name=="ghost"and opt_strs[6].curr then
  pal(7,13)
  pal(6,1)
 else
  pal(7,14)
  pal(6,8)
 end

 for i=0,12,6 do
  spr(s,x+i,y+6)
 end
 spr(s,x+6,y)
 pal()
 if name then
  if(r)x-=max(0,4*#name-1)-18
  print(name,x,y+13,5)
end end

function init_scoremenu()
 mode_slc,opt_slc=1,1
 in_menu,in_options,in_scores=false,false,true
 highscores=getscores(mode_slc)
end

function update_scoremenu()
 if(not do_update)return
 if btnp(2)then
  sfx(12)
  opt_slc=cyclenum(opt_slc-1,1,3)
 end
 if btnp(3)then
  sfx(12)
  opt_slc=cyclenum(opt_slc+1,1,3)
 end

 local temp=mode_slc
 if 1==opt_slc then
  if btnp(0)or btnp(1)then
   sfx(13)
   if btnp(0)then 
    mode_slc=cyclenum(mode_slc-1,1,#modes.list)
   else
    mode_slc=cyclenum(mode_slc+1,1,#modes.list)
  end end
 elseif 2==opt_slc then
  if confirm()then
   for i=10,63 do dset(i,0)end
   sfx(23)
   highscores=nil
  end
 else
  if confirm()then
   init_menu()
  end
 end

 if(not highscores)or(temp!=mode_slc)then
  highscores=getscores(mode_slc)
end end

function draw_scoremenu()
 cls()
 rect(0,0, 127,127, 5)
 rect(1,1, 126,126, 6)
 rect(2,2, 125,125, 7)
 print3("scores",6)

 s=modes.list[mode_slc]
 if(opt_slc==1)s="⬅️ "..s.." ➡️"
 printc(s,20,btoi(opt_slc==1)+6,2*btoi(opt_slc==1))

 printc("reset scores",27,btoi(opt_slc==2)+6)
 printc("back to title",34,btoi(opt_slc==3)+6)

 for i=1,#highscores do
  spr(32+i,47,19+25*i,1,2)
  local s=highscores[i]
  local m=modes.list[mode_slc]
  m=modes[m].gamev.getscore or scr
  printc(m(s,true),32+25*i,7)
end end
-->8
--modes
function scr(s,b)
 if(b)return lpad(s or game.score,"0",5)
 return s or game.score end
function scr_t(s,b)
 if(b)return convert_time(s or game.time)
 return s or game.time end
function scr_l(s)
 return s or game.lines end
function scr_c(s)
 return s or game.maxcombo end

modes={
 list={
  "marathon","infinite","sprint",
  "garbage","combo","master",
  "invisible","secret_grade",
  "survival"},

 infinite={
  desc="let's see you overflow that score counter",
  gamev={stats={"score","level","lines","time"},
  getscore=scr}
 },

 marathon={
  desc="pretty standard, just clear 150 lines and you're done",
  gamev={invscr_ordering=true,
  haswon=function()
   return game.lines>=game.linesneeded
  end,stats={"level","left","time"},
  getscore=scr_t}
 },

 sprint={
  desc="tetris for when your battery is at 5%",
  gamev={usetime=true,
   timegiven=120,
   haslost=function()
    return game.time<game.timegiven
   end,stats={"lines","level","time"},
   getscore=scr_l}
 },

 survival={
  desc="clear or get cleared!",
  gamev={
   usegrb=true,
   getscore=scr_l,stats={"level","lines","time"}
  }
 },

 garbage={
  desc="clear your garbage already, it's filling up my screen!",
  func=function()
   --list to keep track of
   --garbage lines
   game.garbage={}
   local last,hole=0,0

   for l=1,15 do
    game.garbage[l]=l
    last=hole
    --prevents holes lining up
    while hole==last do
     hole=flr(rnd(10))+1
    end

    --put garbage blocks
    rnd_row(l,hole)
  end end,

  gamev={invscr_ordering=true,
  haswon=function()
   return 0==#game.garbage
  end,getscore=scr_t,
  stats={"lines","drops","time"}}
 },

 combo={
  desc="that combo is really sensitive, please don't drop it",
  func=function()
   game.garbage={}
   for l=1,#field.matrix do
    game.garbage[l]=l
   end
   --single overhanging block
   field.matrix[2][4]=flr(rnd(7))+1
  end,
   gamev={
    stats={
     "lines","combo","time"},
    haswon=function()
     return 0==game.combo and 0<game.lines
    end,getscore=scr_c,
    replacerow={1,1,1,0,0,0,1,1,1,1},
    spawnivert=true
 }},

 secret_grade={
  desc="...",
  gamev={
   invscr_ordering=true,
   scr_grading=true,
   stats={"lines","time","grade"},
   haswon=function()
    return 19<=game.secretgrade
   end,getscore=scr_t
 }}
}
--this trick saves me a single
--token, whoa!!! ☉.☉
local a={}
modes.invisible=a
cp_table(modes.marathon,a)
a.desc="there is no garbage... oh nononono not like that!"
a.gamev.linesneeded=40
a.gamev.invisible=true

modes.master={}
cp_table(modes.marathon,modes.master)
modes.master.desc="how tetris were played if we lived on a neutron star"
modes.master.gamev.level=20
-->8
--cartdata

function writedata()
 local o=opt_strs

 --version
 dset(0,1000*version[1]+version[2])

 --booleans, up to 16
 dset(1,set_bit(set_bit(set_bit(set_bit(set_bit(set_bit(set_bit(0,0,gamev.locking_harddrop),1,gamev.invrot),2,gamev.darkghost),3,gamev.ssprmini),4,gamev.laser),5,gamev.progbar),6,gamev.bganim))

 --options using vals, up to 5
 dset(2,(o[2].curr-1)+8*(o[3].curr-1))

 --sprite choices
 dset(3,put_num(put_num(o[14].curr,16,o[13].curr),16,o[12].curr))
 dset(4,put_num(o[16].curr,16,o[15].curr))

 --range options
 dset(5,o[1].curr)
 dset(6,o[11].curr)
end

function readdata()
 if(0==flr(dget(0)/1000))return false
 local o=opt_strs

 --bools
 for i=0,6 do
  o[4+i].curr=get_bit(dget(1),i)
 end

 --val options
 o[2].curr=dget(2)%8+1
 o[3].curr=flr((dget(2)%64)/8)+1
 
 --sprites
 for i=0,4 do
  o[12+i].curr=get_num(dget(3+flr(i/3)),16,i%3)
 end

 --ranges
 o[1].curr=dget(5)
 o[11].curr=dget(6)
end

function getscores(mode)
 mode-=1
 local scores={}
 for i=1,3 do
  scores[i]=dget(15+3*mode+i)
 end
 return scores
end

--mode,name is just index!
function addscore(mode,name,score)
 local s=getscores(mode)
 s[4]=score

 if(game.invscr_ordering)s=inv_scores(s)

 local i=3
 while 0<i do
  if s[i+1]>s[i]or 0==s[i]then
   s[i+1],s[i]=s[i],s[i+1]
  else break end
  i-=1
 end

 if(game.invscr_ordering)s=inv_scores(s)

 s[4]=nil
 
 mode-=1
 for i=1,min(3,#s)do
  dset(15+3*mode+i,s[i])
 end
 
 return i+1
end

function inv_scores(s)
 for i=1,#s do
  s[i]*=-1
 end
 --return s
end
-->8
--animations

anim={
 names={"crush","swoosh","push"},
 list={},

 new=function(t,a)
  if(t=="push")anim.delete("push")

  a=a or{}
  a.type,a.new=t,true

  add(anim.list,a)
 end,

 delete=function(t)
  for a in all(anim.list)do
   if(t==a.type)del(anim.list,a)
  end
 end,

 draw=function()
  pal()
  --drawing in correct order
  for t in all(anim.names)do
   for a in all(anim.list)do
    if(not a.wait and t==a.type)then
     if(not anim[a.type](a))del(anim.list,a)
  end end end end,
 
 update=function()
  if(are)are.clearanim=false
  for a in all(anim.list)do
   if a.type=="swoosh" then
    upd_swoosh(a)
   end
  end
 end,

 count=function(a,def)
  a.len=a.len or def
  if(0==a.len)return false
  a.len-=1
  return true
 end,
 
 swoosh=function(a)
  if(not anim.count(a,15))return false

  local n=#a.clrs
  if(#a.list<n)add(a.list,0)

  for i=1,#a.list do
   local b,c=a.list[i],a.list[i+1] or 0
   b=a.w*swoosh_parab(b/a.maxage)
   rectfill(a.x,a.y,a.x+b,a.y-1+a.h,a.clrs[i])
   a.list[i]+=1
  end
  return true
 end,
 
 crush=function(a)
  if(not anim.count(a,120))return false
  if(not a.list)then
   a.list={}
   a.grav=.1
   for i=0,3 do
    add(a.list,{x=3*(i%2),y=3*flr(i/2),
     dx=rnd(.6)-.3,dy=rnd(.6)-.4})
  end end
  
  for i=0,3 do
   local p=a.list[i+1]
   p.x+=p.dx
   p.y+=p.dy
   p.dy+=a.grav
   pal(7,a.c[1],0)
   pal(6,a.c[2],0)
   sspr(8*game.sprite.normal+3*(i%2),3*flr(i/2),3,3,a.x+p.x,a.y+p.y)
   pal()
  end
  return true
 end,

 push=function(a)
  if(not a.y)then
   a.y=0
   a.dy=3
   a.ay=2
  end

  a.y+=a.dy
  a.dy-=a.ay

  if(0>=a.y)return false
  camy-=a.y
  return true
 end
}

--[[function swoosh_exp(x)
 return 1-2^(-8*min(1,x))
end

function swoosh_sin(x)
 return sin(-.25*x)
end--]]

function swoosh_parab(x)
 return 1-(x-1)^2
end

function upd_swoosh(a)
 if(not a.list)then
  a.len=a.len or 14
  a.clrs={10,11,12,12,7}
  a.maxage=a.len-#a.clrs+1
  a.list={}
 end

 if(not(#a.list==n and a.list[#a.list].x==10))then
  are.clearanim=true
 end
end

function savebuf()
 local buf={}
 for i=0x6000,0x7fff do
  buf[i]=peek(i)
 end
 return buf
end

function restorebuf(buf)
 for i=0x6000,0x7fff do
  poke(i,buf[i])
 end
end

progcols={
 {12,13,1},--blue
 {11,3,5},--green
 {10,9,4},--yellow/orange
 {8,2,1},--red/purple
 {6,8,5}--grey with red
}

bgcols={
 {1,12},--blue
 {3,11},--green
 {4,9},--brown/orange
 {2,14},--purple
 {5,8},--grey with red
}

bg={data={},curr="",draw=function()
  if(bg.curr=="")return
  bg[bg.curr](bg.data)
 end,
 
 set=function(s,d)
  bg.data,bg.curr=d or{},s
 end,
 
 grid=function(d)
  if(not game.bganim)return
  d.list=d.list or {}
  d.col=min(#bgcols,d.col or 1)
  if(92<rnd(100))add(d.list,{a=4*flr(rnd(32))+1,b=0,vert=(rnd(2)>1),back=(rnd(2)>1)})
  for l in all(d.list)do
   if(228<=l.b)del(d.list,l)
   l.b+=1
   local x,y=l.b,l.a
   local p=x-100
   if(l.back)x,p=128-x,228-x

   local c=bgcols[d.col]
   if(l.vert)then
    x,y=y,x
    line(x,y,x,p,c[1])
   else
    line(x,y,p,y,c[1])
   end
   pset(x,y,c[2])
 end end,
 
 falling=function(d)
  d.list=d.list or{}
  if(20<rnd(100))add(d.list,{x=rnd(132)-2,y=-4,s=rnd(.5),t=16+flr(rnd(7))})
  for t in all(d.list)do
   if(128<t.y)del(d.list,t)
   t.y+=t.s
   t.s=min(3,t.s+.05)
   spr(t.t,t.x,t.y,.5,.5)
  end
 end
}
__gfx__
00000000777777006666660077777700777777007666660076666600777777006666660077777700777777007777770007777000077770000777700000770000
07007000766667006777760076666700777777006776660067777600766667006777760076666700777767007666670077666700766667007766770007777000
00770000767767006766760076777700776677006766660067777600766667006777760076667700777667007666760076667600767767007600770007767000
00770000767767006766760077776700776677006666660067777600766667006777760076677700776667007667760076677600767767007600760007767000
07007000766667006777760076666700777777006666660067777600766667006777760076777700766667007677760076777600766667007777760007667000
00000000777777006666660077777700777777006666660066666600777777006666660077777700777777007766660007666000077770000776600000770000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000070c0000cc0009009000aa00aa00bb00b000e000e0088000080000000000000000505050505550550555555555500000000000000000000000000055000
77770070ccc00c00999009000aa00aa0bb000bb0eee00ee008800880000000000000000000000000000000050000000500000000000000000000000000055000
0000007000000c000000099000000000000000b000000e0000000800000000000000000000000005000000000000000500000000000550000055550000055000
00000070000000000000000000000000000000000000000000000000000000000000000000000000000000050000000500055000005005000050050055500555
0000070000000c00000099000aa00aa00000b00000000e0000000800000000000000000000000005000000050000000500055000005005000050050055500555
00000700ccc00c00999009000aa00aa00bb0bb00eee0ee0088008800000000000000000000000000000000000000000500000000000550000055550000055000
7777070000c0cc009000090000000000bb000b000e000e0008808000000000000000000000000005000000050000000500000000000000000000000000055000
00000700000000000000000000000000000000000000000000000000000000000000000000000000000000050000000500000000000000000000000000055000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2100000000088880000cccc0000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
321000000080000800c0000c00d0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
421000000080000800c0000c00d0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
51000000080008800c000cc00d000dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6d100000080080000c00c0000d00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76d10000080800000c0c00000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
82100000080800000c0c00000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94210000080800000c0c00000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9421000088000000cc000000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3210000088000000cc000000dd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cd100000aaaa00006666000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1000000a99a00006556000094490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e2100000a9aa00006566000094990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6d51000aaaa00006666000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8888888888888800999999999999900aaaaaaaaaaaaaa00bbbbbbbbbbbbbbbbb0cccc00eeeeeeeeeeeeee0000000000000000000000000000000000000000000
8777777777777800977777777779900a777777777777a00b7777777777777bb00c77c00e777777777777e0000000000000000000000000000000000000000000
8788888888888800979999999999000a7aaaaaaaaaaaa00b7bbbbbbbbbbbbb000c7cc00e7eeeeeeeeeeee0000000000000000000000000000000000000000000
8888888888888800979999999999000aaaaaaaaaaaaaa00b7bbbbbbbbbbbb0000cccc00e7eeeeeeeeeeee0000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb00000b7bb000000000000e7eee000000000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb0000b7bb000000cccc000e7eee000000000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb000b7bb0000000c77c0000e7eee00000000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb00b7bb00000000c7cc0000eeeee00000000000000000000000000000000000000000000000000
000008788000000097999999990000000000a7aa0000000b7bb0b7bb000000000c7cc00000eeeee0000000000000000000000000000000000000000000000000
000008788000000097997777990000000000a7aa0000000b7bbb7bb0000000000c7cc00000eeeee0000000000000000000000000000000000000000000000000
000008788000000097999999900000000000a7aa0000000b7bbbbbb0000000000c7cc000000eeeee000000000000000000000000000000000000000000000000
000008788000000097999999900000000000a7aa0000000b7bbbbbbb000000000c7cc000000eeeee000000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb0bbbbb00000000c7cc0000000eeeee00000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb00bbbbb0000000c7cc0000000eeeee00000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb000bbbbb000000c7cc00000000eeeee0000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb0000bbbbb00000c7cc00000000eeeee0000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb00000bbbbb0000c7cc000000000eeeee000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb000000bbbbb000c7cc000000000eeeee000000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb0000000bbbbb00cccc0000000000eeeee00000000000000000000000000000000000000000000
000008788000000097990000000000000000a7aa0000000b7bb00000000bbbbb00ccc0000000000eeeee00000000000000000000000000000000000000000000
000008788000000097999999999999990000a7aa0000000b7bb000000000bbbbb00cc00eeeeeeeeeeeeee0000000000000000000000000000000000000000000
000008788000000097997777777777790000a7aa0000000b7bb0000000000bbbbb00c00e77777777eeeee0000000000000000000000000000000000000000000
000008788000000097999999999999999000a7aa0000000b7bb00000000000bbbbb0000e7eeeeeeeeeeee0000000000000000000000000000000000000000000
000008888000000099999999999999999000aaaa0000000bbbb000000000000bbbbb000eeeeeeeeeeeeee0000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665
56777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777765
567000000000000000099900000000000ccc99000000000000999000000000000000000000000000000000000008800000000000000000000000000000000765
56700000000000000000000000000000000000000000009000000000000000000000000000000000000000000000880000000000000000000000000000000765
56700000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
5670000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
567000000000000000000eee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000077770000000000000000000000000000000000000000000000000088800000765
56700000000000000000000000000000000000000000000000000000000000009990000000000000000000000000000000000000000000000000008880000765
56700000000000000000000000000000000000000000000000000000777077700770077000000000000000000000000000000000000000000000000000000765
567000000000000000000000000000000000000000000000000000007670676076607670000000000000000000000000000000000000000000000000000aa765
567000000000000000000000000000000000000000000000000000007770575075507570000000000000000000000000000000000000000000000000000aa765
56700000000000000000000000000000000000000000000000000000766007007000707000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000755077706770776000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000600066605660665000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000500055500550550000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000765
5670000000000000000008888888888888800999999999999900aaaaaaaaaaaaaa00bbbbbbbbbbbbbbbbb0cccc00eeeeeeeeeeeeee0000000000000000000765
5670000000000000000008777777777777800977777777779900a777777777777a00b7777777777777bb00c77c00e777777777777e0000000000000000000765
5670000777700000000008788888888888800979999999999000a7aaaaaaaaaaaa00b7bbbbbbbbbbbbb000c7cc00e7eeeeeeeeeeee0000000000000000000765
5670000000000000000008888888888888800979999999999000aaaaaaaaaaaaaa00b7bbbbbbbbbbbb0000cccc00e7eeeeeeeeeeee0000000000000000000765
567000000000000000000000008788000000097990000000000000008a7aa0000000b7bb00000b7bb000000000000e7eee000000000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa7000000b7bb0000b7bb000000cccc000e7eee000000000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb000b7bb0000000c77c0000e7eee00000000000000000000000000765
567000e00000000000000000008788000000097990000000000000000a7aa0000000b7bb00b7bb00000000c7cc0000eeeee00000000000000000000000000765
56700eee0000000000000000008788000000097999999990000000000a7aa0000000b7bb0b7bb000000000c7cc00000eeeee0000000000000000000000000765
567000000000000000000000008788000000097997777990000000000a7aa0000000b7bbb7bb0000000000c7cc00000eeeee0000000000000000000000000765
567777000000000000000000008788000000097999999900000000000a7aa0000000b7bbbbbb0000000000c7cc000000eeeee000000000000000000000000765
567000000000000000000000008788000000097999999900000000000a7aa0000000b7bbbbbbb000000000c7cc000000eeeee000000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb0bbbbb00000000c7cc0000000eeeee00000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb00bbbbb0000000c7cc0000000eeeee00000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb000bbbbb000000c7cc00000000eeeee0000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb0000bbbbb00000c7cc00000000eeeee0000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb00000bbbbb0000c7cc000000000eeeee000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb000000bbbbb000c7cc000000e00eeeee000000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb0000000bbbbb00cccc00000eee00eeeee00000000000000000000765
567000000000000000000000008788000000097990000000000000000a7aa0000000b7bb00000000bbbbb00ccc0000000000eeeee00000000000000000000765
56700000c000000000000000008788000000097999999999999990000a7aa0000000b7bb000000000bbbbb00cc00eeeeeeeeeeeeee0000000000000000000765
56700000ccc0000000000000008788000000097997777777777790000a7aa0000000b7bb0000000000bbbbb00c00e77777777eeeee0000000000000000000765
567000000000000000000000008788000000097999999999999999000a7aa0000000b7bb00000000000bbbbb0000e7eeeeeeeeeeee0000000000000000000765
567000000000000000000000008888000000099999999999999999800aaaa0000000bbbb000000000000bbbbb000eeeeeeeeeeeeee0000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000077770000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
5670000000000000000000000000e000000000000000000000000007777000000000000000000000000000000000000000000000000000000000000000000765
567000000000000000000000000eee00000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
5670000000000000000000000000000000eee00000000000000000000000000000bb000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000bb0000000000000000000000000000000000000000000000000000000000765
56700000000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
567000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000765
567000000000000000000000000000000000000000000000000007707770777077707770070000000000000000ccc00000000000000000000000000000000765
56700000000000000000000000000000000000000000000000007000070070707070070007000000000880000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000007770070077707700070007000000000088000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000070070070707070070000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000007700070070707070070007000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000007777000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000066600660660066600000000066606660666066606660606006606600000000000000000000000000000000c00765
56700000000000000000000000000000000066606060606060000600000066606060606060600600606060606060000000000000077770000000000000ccc765
56700000000000000000000000000000000060606060606066000000000060606660660066600600666060606060000000000000000000000000000000000765
56700000000000000000000000000000000060606060606060000600000060606060606060600600606060606060000000000000000000000000000000000765
5670000000000000000000000000000000006060660066606660000000006060606060606b600600606066006060000000000000000000000000000000000765
567000000000000000000000000000000000000000000000000000000000000000000000bb000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000066066606660666006606600066000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000090000000000000606069600600060060606060600000000000000000000000000000000000000000000000000765
56700000000000000000000000000000009990000000000000606966600600060060606060666000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000606060000600060060606060006000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000660060000600666066006060660000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56780000000000000000000000000000000000000060606660066060600000066006600660666066600660000000000000000000000000000000000000000765
56788000000000000000000000000000000000000060600600600060600000600060006060606060006000000000000000000000000000000000088000000765
56700000000000000000000000000000000000000066600600600066600000666060006060660066006660000000000000000000000000000000008800000765
56700000000000000000000000000000000000000060600600606060600000006060006060606060000060000000000000000000000000000000000000000765
56700000000000000000000000000000000000000060606660666060600000660006606600606066606600000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
567000000000000000000000000000000000000000000000000000aa000000000000000000000000000000000000000000000000000000000000000000000765
567000000000000000000000000000000000000000000000007777aa000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
5670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
5670bb00000000000000000000000000000000000000000000000000000000008800000000000000000000000000000000000000000000000000000000000765
567bb000000000000000000000000000000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56705500000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008765
56700500000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700500000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
567005000000050000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
567055500500555000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000765
56777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777765
56666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__gff__
00000000000000000000000000000000671c499a3b8e28000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
404142434445464748494a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
505152535455565758595a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
606162636465666768696a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000002a2b2a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002b2a2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001403014030130301203011030100300f0300c00008000020000100028000270002700028000280002800028000280002800027000270002700027000270002800028000290002a0002a0002a0002b000
000200001a0301e03022030260201b0001a000190001900018000180001800028000270002700028000280002800028000280002800027000270002700027000270002800028000290002a0002a0002a0002b000
000200002a03026030220301e0201b0001a000190001900018000180001800028000270002700028000280002800028000280002800027000270002700027000270002800028000290002a0002a0002a0002b000
00050000205502655020550265503050030500305003050030500335003350028500275002750028500285002850028500285002850027500275002750027500275002850028500295002a5002a5002a5002b500
00050000205501a550205501a5503050030500305003050030500335003350028500275002750028500285002850028500285002850027500275002750027500275002850028500295002a5002a5002a5002b500
00050000200402004026030260303000030000300003000030000330003300028000270002700028000280002800028000280002800027000270002700027000270002800028000290002a0002a0002a0002b000
0005000020030200301a0401a0403000030000300003000030000330003300028000270002700028000280002800028000280002800027000270002700027000270002800028000290002a0002a0002a0002b000
00050000257402075020750257403070030700307003070030700337003370028700277002770028700287002870028700287002870027700277002770027700277002870028700297002a7002a7002a7002b700
000500002874028740287402e7203070030700307003070030700337003370028700277002770028700287002870028700287002870027700277002770027700277002870028700297002a7002a7002a7002b700
00050000200301c040190401904000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000d05008040050300302002010010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000166100d050080400503003020020100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002b0102d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002502000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000130501305015040180301c02022000280002d0002f0003100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000130501305015050180401c03022020280002d0002f0003100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000130501305015050180501c04022030280202d0002f0003100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000130501305015050180501c05022040280302d0202f0103100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001705017050190401c0302002025010280002d0002f0003100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001b0501b0501d0501f04023030280202e0102d0002f0003100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001e0501e0502005022050260402b0303102033510345103100032000320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400001b0501e0502105024050240502105024050270502a0502d05030050300502d050300503305036040390303c0203e01000000000000000000000000000000000000000000000000000000000000000000
000300002175023750277402a72027730227002170022700267002a70000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
000100002f6603c6602f6603c6602f6603c6602e6603b6602966034660236502b6501c65024650176401c64010640126400a6400a640046300263001620016001260001600116000460010600076000d6000b600
001000002a05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003205000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500000d5200f1202a2212a2312a2212a231251212a2012a2012a2012a201250012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d520101202d2212d2312d2212d231281212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d520101202f2212f2312f2212f2312a1212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d52010120312213123131221312312c1212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d52010120342213423134221342312e1212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d5201012037221372313722137231311212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
000500000d520101203a2213a2313a2213a231341212a2012a2012a2012a2010f1012a2012a2012a2012a2012a2012a2012a2012a201111010000100001000010000100001000010000100001000010000100001
