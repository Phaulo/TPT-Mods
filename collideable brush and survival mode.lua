
function math.sign(number)
if number == 0 then
return 0
end
return number/math.abs(number)
end

function clamp(value,min,max)
if value>max then
return max
end
if value<min then
return min
end
return value
end
collideable_brush = true
survival_mode = false
if collide_brush then
	pcall(event.unregister, event.tick, collide_brush.tick)
else
	collide_brush = {}
end

function collideable_brush_toggle()
 collideable_brush = not collideable_brush
end

function collideable_brush_set(boolean)
 collideable_brush = boolean
end

function survival_mode_toggle()
 survival_mode = not survival_mode
end

function survival_mode_set(boolean)
 survival_mode = boolean
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

life = 100
tpt.mousevx, tpt.mousevy = 0, 0
local button_down
local function add_noise(mousexU, mouseyU)
local descrease = 0
	if mousexU < sim.XRES-1 and mouseyU < sim.YRES-1 and tpt.set_pause() == 0 then
		local mousex, mousey = sim.adjustCoords(mousexU, mouseyU)
		for x, y in sim.brush(mousex, mousey, tpt.brushx, tpt.brushy) do
			local id = sim.partID(x, y)
			if id and id >= 0 then
				local vx = sim.partProperty(id, sim.FIELD_VX) or 0
				local vy = sim.partProperty(id, sim.FIELD_VY) or 0
				local type = sim.partProperty(id, sim.FIELD_TYPE) or tpt.el.dmnd.id
				local temp = sim.partProperty(id, sim.FIELD_TEMP) or 295.15
    local elem_type = bit.band(elem.property(type,"Properties"),0x1F)

if (type ~= tpt.el.spng.id and type ~= tpt.el.goo.id) and collideable_brush then
if (elem_type ~= elem.TYPE_SOLID and elem_type ~= elem.TYPE_ENERGY) then
				sim.partProperty(id, sim.FIELD_VX, vx+(math.min(tpt.mousevx/8,tpt.brushx/8)))
				sim.partProperty(id, sim.FIELD_VY, vy+(math.min(tpt.mousevy/8,tpt.brushy/8)))
-- Disabled due it lags
--[[
local time = 0
 for i = math.sign(tpt.mousevx),tpt.mousevx do
 for j = math.sign(tpt.mousevy),tpt.mousevy do
  if not solid(clamp(x+i,3,sim.XRES-4), clamp(y+j,3,sim.YRES-4),bit.band(elem.property(type,"Properties"),0x1F)) then
   tpt.parts[id].x = clamp(x+i,3,sim.XRES-4)
   tpt.parts[id].y = clamp(y+j,3,sim.YRES-4)
  end
  time = time+1
  if time > 50 then
   return
  end
 end
 end]]
end
end
if survival_mode then
if (type == tpt.el.plnt.id) then
    if life < 100 then
     descrease = math.max(life-100,-5)
    end
end
end
local property = bit.band(elem.property(type,"Properties"),0xFFFF20) or 0
if (type == tpt.el.ligh.id or type == tpt.el.neut.id
                        or property == elem.PROP_DEADLY or property == elem.PROP_RADIOACTIVE
                        or temp >= 323 or temp <= 243) then
if type == tpt.el.acid.id then
descrease = math.max(descrease,5)
else
descrease = math.max(descrease,1)
end
end
			end
		end
	end
if survival_mode then
life = life-descrease
if life <= 0 then
tpt.message_box("Survival Mode", "You Died. :(")
tpt.selectedl = "DEFAULT_PT_DUST"
tpt.selectedr = "DEFAULT_PT_NONE"
tpt.selecteda = "DEFAULT_PT_NONE"
life = 100
tpt.mousex = sim.XRES/2
tpt.mousey = sim.YRES/2
end
tpt.drawtext(clamp(tpt.mousex-(tpt.textwidth(life)/2),tpt.textwidth(life)/4,sim.XRES-(tpt.textwidth(life))),clamp(tpt.mousey-tpt.brushy-12,6,sim.YRES-12),life,255,255,255,255)
end
end
local last_mousex, last_mousey = tpt.mousex, tpt.mousey
local function booleantonumber(boolean)
 if type(boolean) == "boolean" then
  return boolean and 1 or 0
 end
 return boolean
end
function collide_brush.tick()
	add_noise(tpt.mousex-tpt.mousevx, tpt.mousey-tpt.mousevy)
tpt.mousevx, tpt.mousevy = tpt.mousex-last_mousex, tpt.mousey-last_mousey
last_mousex, last_mousey = tpt.mousex, tpt.mousey
local jacobsmod = tpt.version.jacob1s_mod or tpt.version.mobilemajor
if survival_mode and jacobsmod then
local annoying_member_x = tpt.mousex
local annoying_member_y = tpt.mousey
    for stkm = 3,102,1 do
        local flying = false
        local control = 0
        if tpt.set_pause() == 0 and sim.stickman(stkm,"spwn") >= 1 then
                    local function create_exact(x,y,id)
                        if id ~= nil and (id > 0 and id < 512) then
                            return tpt.create(clamp(x,4,sim.XRES-4),clamp(y,4,sim.YRES-4),id)
                        else
                            return -1
                        end
                    end
            if true then
                local facing = 0
                sim.stickman(stkm,"comm",0)
                sim.stickman(stkm,"pcomm",0)
                local x, y = sim.stickman(stkm,"legs",nil,0), sim.stickman(stkm,"legs",nil,1)
                local footx, footy = sim.stickman(stkm,"legs",nil,4), sim.stickman(stkm,"legs",nil,5)
                local footx2, footy2 = sim.stickman(stkm,"legs",nil,12), sim.stickman(stkm,"legs",nil,13)
                if sim.stickman(stkm,"rocketBoots") >= 1 then
                    local create_plasma = function(id)
                        create_exact(sim.stickman(id,"legs",nil,6),sim.stickman(id,"legs",nil,7),tpt.el.plsm.id)
                        create_exact(sim.stickman(id,"legs",nil,14),sim.stickman(id,"legs",nil,15),tpt.el.plsm.id)
                    end
                    facing = booleantonumber(x<annoying_member_x)
                    if (x>annoying_member_x) then
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,0)-0.1,0)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,2)-0.1,2)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,4)-0.1,4)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,6)-0.1,6)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,1)-0.125,1)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,3)-0.125,3)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,5)-0.125,5)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,7)-0.125,7)
                        create_plasma(stkm)
                        flying = true
                        control = 1
                    end
                    if (x<annoying_member_x) then
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,0)+0.1,0)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,2)+0.1,2)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,4)+0.1,4)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,6)+0.1,6)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,1)-0.125,1)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,3)-0.125,3)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,5)-0.125,5)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,7)-0.125,7)
                        create_plasma(stkm)
                        flying = true
                        control = 2
                    end
                    if (y>annoying_member_y) then
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,1)-0.25,1)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,3)-0.25,3)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,5)-0.25,5)
                        sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,7)-0.25,7)
                        create_plasma(stkm)
                        flying = true
                        control = 4
                    end
                else
                    for rx = -1,1 do
                        for ry = -1,1 do
                            if (footx and footy) and solid(clamp(footx,4,sim.XRES-4)+rx,clamp(footy,4,sim.XRES-4)+ry) then
                                local velocity = ((booleantonumber(x>annoying_member_x)*2)-1)*-0.25
                                local acceleration = sim.stickman(stkm,"accs",nil,2)
                                if acceleration > 0 and velocity < 0 then
                                    velocity = velocity*16
                                end
                                if acceleration < 0 and velocity > 0 then
                                    velocity = velocity*16
                                end
                                sim.stickman(stkm,"accs",acceleration+velocity,2)
                                sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,3)+(math.random(1,2)/-2),3)
                            end
                            if (footx2 and footy2) and solid(clamp(footx2,4,sim.XRES-4)+ry,clamp(footy2,4,sim.XRES-4)+ry) then
                                local velocity = ((booleantonumber(x>annoying_member_x)*2)-1)*-0.25
                                local acceleration = sim.stickman(stkm,"accs",nil,6)
                                if acceleration > 0 and velocity < 0 then
                                    velocity = velocity*16
                                end
                                if acceleration < 0 and velocity > 0 then
                                    velocity = velocity*16
                                end
                                sim.stickman(stkm,"accs",acceleration+velocity,6)
                                sim.stickman(stkm,"accs",sim.stickman(stkm,"accs",nil,7)+(math.random(1,2)/-2),7)
                            end
                        end
                    end
                end
                if (x>(annoying_member_x-24) and x<(annoying_member_x+24))  then
                    local property = bit.band(elem.property(sim.stickman(stkm,"elem"),"Properties"),0xFFFF20)
                    if (sim.stickman(stkm,"elem") == elem.DEFAULT_PT_LIGH or sim.stickman(stkm,"elem") == elem.DEFAULT_PT_NEUT
                        or property == elem.PROP_DEADLY or property == elem.PROP_RADIOACTIVE
                        or elem.property(sim.stickman(stkm,"elem"),"Temperature") >= 323 or elem.property(sim.stickman(stkm,"elem"),"Temperature") <= 243) then
                        local particle = create_exact(x+3+((facing*4)-2),y-6+math.random(-1,1),sim.stickman(stkm,"elem"))
                        --print(particle)
                        if particle then
                            pcall(function() tpt.parts[particle].vx = ((facing*8)-4) end)
                        end
                    end
                    --sim.stickman(stkm,"comm",8)
                    --[[print("Gotta")]]
                else
                    sim.stickman(stkm,"comm",0)
                end
            end
        end
        if flying then
            if control == 1 or control == 4 then
                tpt.drawpixel(math.floor(sim.stickman(stkm,"legs",nil,4)),math.floor(sim.stickman(stkm,"legs",nil,5)),0,255,0,255)
            end
            if control == 2 or control == 4 then
                tpt.drawpixel(math.floor(sim.stickman(stkm,"legs",nil,12)),math.floor(sim.stickman(stkm,"legs",nil,13)),0,255,0,255)
            end
        end
    end
    --[[for stkm = 102,3,-1 do
        print(tostring(figh_timer[stkm] > 20))
        print(figh_timer[stkm])
    end]]
end

end
event.register(event.tick, collide_brush.tick)
