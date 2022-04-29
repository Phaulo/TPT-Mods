function clamp(value,min,max)

if value>max then

return max

end

if value<min then

return min

end

return value

end

local function solid(posx,posy,elemtype)
    local x = posx or 0
    local y = posy or 0
    x = clamp(x,4,sim.XRES-5)
    y = clamp(y,4,sim.YRES-5)
    elemtype = elemtype or 0
    local index = sim.pmap(x,y)
    if index and index >= 0 then
        local part = tpt.parts[index]
        if part then
            local kind = bit.band(elem.property(part.type, "Properties"), 0x1F)
            if kind == elem.TYPE_SOLID or kind == elem.TYPE_PART then
                return true
            end
        end
    end
    local x = posx or 0
    local y = posy or 0
    x = clamp(x,3,sim.XRES-4)
    y = clamp(y,3,sim.YRES-4)
    local wallx, wally = math.floor((x)/sim.CELL),math.floor((y)/sim.CELL)
    local walltype, wallflag = tpt.get_wallmap(wallx, wally), tpt.get_elecmap(wallx, wally)
    if walltype == 1 then
        return true
    end
    if walltype == 2 then
        return wallflag <= 0
    end
    if walltype == 6 then
        return elemtype ~= elem.TYPE_LIQUID
    end
    if walltype == 8 then
        return true
    end
    if walltype == 9 then
        return true
    end
    if walltype == 10 then
        return elemtype ~= elem.TYPE_PART
    end
    if walltype == 13 then
        return elemtype ~= elem.TYPE_GAS
    end
    if walltype == 15 then
        return elemtype ~= elem.TYPE_ENERGY
    end
    return false
end

if ball then
pcall(event.unregister(event.mousedown,ball.mousedown))
else
ball = {}
end

local color = elem.property(tpt.el.stkm.id,"Color")
tpt.balls = {}
local element1 = elem.SPECIAL_PT_BALL or elem.allocate("SPECIAL","BALL")
elem.property(element1,"MenuVisible",1)
elem.property(element1,"MenuSection",elem.SC_SPECIAL)
elem.property(element1,"Color",color)
elem.property(element1,"Name","BALL")
elem.property(element1,"Description","a ball. Balls roll and bounce at great speed. Balls come in many varieties, each with different properties.")
elem.property(element1,"Properties",elem.PROP_NOCTYPEDRAW)
elem.property(element1,"Create",sim.partKill)

local element1 = elem.SUBSPECIAL_PT_BALL or elem.allocate("SUBSPECIAL","BALL")
elem.property(element1,"MenuVisible",0)
elem.property(element1,"MenuSection",elem.SC_CRACKER)
elem.property(element1,"Color",color)
elem.property(element1,"Name","BALL")
elem.property(element1,"Description","a ball. Balls roll and bounce at great speed. Balls come in many varieties, each with different properties.")
elem.property(element1,"Properties",elem.TYPE_PART)
elem.property(element1,"Falldown",1)
local function create(i)
 if not tpt.balls[i] then
  tpt.balls[i] = i
 end
end
elem.property(element1,"Create",create)
local function update(index,x,y,s,n)
 local vx,vy = tpt.parts[index].vx,tpt.parts[index].vy+0.25
 tpt.parts[index].vy=vy
 local slope,slope2 = false,false
 for i = 1,3 do
  if solid(x+i,y+3) then
   vx = vx-0.25
   slope = true
  end
  if solid(x-i,y+3) then
   vx = vx+0.25
   slope = true
  end
  if solid(x+i,y+3) and solid(x-i,y+3) then
   slope = false
  end
  if solid(x+i,y-3) then
   vx = vx-0.25
   slope = true
  end
  if solid(x-i,y-3) then
   vx = vx+0.25
   slope = true
  end
  if solid(x+i,y-3) and solid(x-i,y-3) then
   slope = false
  end
  if solid(x+3,y+i) then
   vy = vy-0.25
   slope2 = true
  end
  if solid(x+3,y-i) then
   vy = vy+0.25
   slope2 = true
  end
  if solid(x+3,y+i) and solid(x+3,y-i) then
   slope2 = false
  end
  if solid(x-3,y+i) then
   vy = vy-0.25
   slope2 = true
  end
  if solid(x-3,y-i) then
   vy = vy+0.25
   slope2 = true
  end
  if solid(x+3,y+i) and solid(x+3,y-i) then
   slope2 = false
  end
 end
 for i = -2,2,1 do
  for j = -2,2,1 do
   if ((math.abs(i)+math.abs(j)) < 4) and (i ~= 0 and j ~= 0) then
    if solid(x,y-i) then
     tpt.parts[index].y = y-j
     vy = vy-0.25
     tpt.parts[index].vy = math.abs(vy)*math.sign(j*(slope and 1 or -1))*0.75
    end
    if solid(x+i,y) then
     tpt.parts[index].x = x-i
     tpt.parts[index].vx = math.abs(vx)*math.sign(i*(slope2 and 1 or -1))*0.75
    end
   end
  end
 end
end
elem.property(element1,"Update",update)
local function elem_graphics(i)
 if not tpt.balls[i] then
  tpt.balls[i] = i
 end
 return 0,0, 0,0,0
end
elem.property(element1,"Graphics",elem_graphics)
tpt.register_step(function()
 for _,index in pairs(tpt.balls) do
  local part = tpt.parts[index]
  if part and part.type == elem.SUBSPECIAL_PT_BALL then
   local x,y = part.x,part.y
   local r,g,b = gfx.getColors(color)
   tpt.drawline(x-1,y+2,x+1,y+2,r,g,b,255)
   tpt.drawline(x-1,y-2,x+1,y-2,r,g,b,255)
   tpt.drawline(x-2,y-1,x-2,y+1,r,g,b,255)
   tpt.drawline(x+2,y-1,x+2,y+1,r,g,b,255)
   if tpt.version.jacob1s_mod or tpt.version.mobilemajor then -- Jacob1's Mod and Mobile Only
    local vx,vy = part.vx,part.vy
    for stkm = 1,102 do
     local legx,legy = sim.stickman(stkm,"legs",nil,4), sim.stickman(stkm,"legs",nil,5)
     local legvx,legvy = sim.stickman(stkm,"accs",nil,2), sim.stickman(stkm,"accs",nil,3)
     if legx >= x-4 and legy >= y-4 and legx <= x+4 and legy <= y+4 then
      if legvx > 0 then
       tpt.parts[index].vx = math.max(vx,legvx)
      elseif legvx < 0 then
       tpt.parts[index].vx = math.min(vx,legvx)
      end
      if legvy > 0 then
       tpt.parts[index].vy = math.max(vy,legvy)
      elseif legvy < 0 then
       tpt.parts[index].vy = math.min(vy,legvy)
      end
     end
     local legx,legy = sim.stickman(stkm,"legs",nil,12), sim.stickman(stkm,"legs",nil,13)
     local legvx,legvy = sim.stickman(stkm,"accs",nil,6), sim.stickman(stkm,"accs",nil,7)
     if legx >= x-4 and legy >= y-4 and legx <= x+4 and legy <= y+4 then
      if legvx > 0 then
       tpt.parts[index].vx = math.max(vx,legvx)
      elseif legvx < 0 then
       tpt.parts[index].vx = math.min(vx,legvx)
      end
      if legvy > 0 then
       tpt.parts[index].vy = math.max(vy,legvy)
      elseif legvy < 0 then
       tpt.parts[index].vy = math.min(vy,legvy)
      end
     end
    end
   end
  else
   tpt.balls[index] = nil
  end
 end
end)
function ball.mousedown(x,y,b)
 x,y = sim.adjustCoords(x,y)
 if not (x >= 4 and y >= 4 and x < sim.XRES-4 and y < sim.YRES-4) then
  return
 end
 if b == 1 and tpt.selectedl == "SPECIAL_PT_BALL" then
  tpt.create(x,y,elem.SUBSPECIAL_PT_BALL)
 end
 if b == 4 and tpt.selectedr == "SPECIAL_PT_BALL" then
  tpt.create(x,y,elem.SUBSPECIAL_PT_BALL)
 end
 if b == 2 and tpt.selecteda == "SPECIAL_PT_BALL" then
  tpt.create(x,y,elem.SUBSPECIAL_PT_BALL)
 end
end
event.register(event.mousedown,ball.mousedown)
