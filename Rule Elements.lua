function math.mod(value,value2)
 local result = 0
 result = value
 result = result-(math.floor(value/value2)*value2)
 return result
end
function tpt.delete_create(x,y,elem)
 local part = sim.pmap(x,y)
 if part then
  tpt.delete(part)
 end
 return tpt.create(x,y,elem)
end
function tpt.empty_create(x,y,elem)
 local part = sim.pmap(x,y)
 if part then
  return -1
 else
  return tpt.create(x,y,elem)
 end
end
local love_rule_table = {
	{0,0,1,1,0,1,1,0,0},
	{0,1,0,0,1,0,0,1,0},
	{1,0,0,0,0,0,0,0,1},
	{1,0,0,0,0,0,0,0,1},
	{0,1,0,0,0,0,0,1,0},
	{0,1,0,0,0,0,0,1,0},
	{0,0,1,0,0,0,1,0,0},
	{0,0,0,1,0,1,0,0,0},
	{0,0,0,0,1,0,0,0,0},
}
local lolz_rule_table = {
	{0,0,0,0,0,0,0,0,0},
	{1,0,0,0,0,0,1,0,0},
	{1,0,0,0,0,0,1,0,0},
	{1,0,0,1,1,0,0,1,0},
	{1,0,1,0,0,1,0,1,0},
	{1,0,1,0,0,1,0,1,0},
	{0,1,0,1,1,0,0,1,0},
	{0,1,0,0,0,0,0,1,0},
	{0,1,0,0,0,0,0,1,0},
}
tpt.registered_rule_elements = {}
function tpt.register_rule_element(name,def)
 name = name or "LOLZ"
 def = def or {
  	allocate = {
  		group = "RULE",
  		name = "LOLZ"
  	},
  	rule = {
  		width = 9,
  		height = 9,
  		table = lolz_rule_table
  	},
  	description = "Lolz",
  	color = 0xFF569212,
  	menu = {
  		visible = 1,
  		section = elem.DEFAULT_PT_HRSE and elem.SC_CRACKER2 or elem.SC_SPECIAL
  }
 }
 tpt.registered_rule_elements[name] = def
 tpt.registered_rule_elements[name].id = element1
local element1 = elem[def.allocate.group.."_PT_"..def.allocate.name] or elem.allocate(def.allocate.group,def.allocate.name)
elem.element(element1,elem.element(elem.DEFAULT_PT_DMND))
elem.property(element1,"MenuVisible",def.menu.visible)
elem.property(element1,"MenuSection",def.menu.section)
elem.property(element1,"Color",def.color)
elem.property(element1,"Name",name)
elem.property(element1,"Description",def.description)
elem.property(element1,"Properties",elem.TYPE_SOLID)
local update = function(i,x,y,s,w)
 --if tpt.parts[i].life <= 0 then
  if def.rule.table[math.mod(y,def.rule.height)+1][math.mod(x,def.rule.width)+1] == 0 then
   tpt.delete(i)
  end
  x = math.floor(x/def.rule.width)*def.rule.width
  y = math.floor(y/def.rule.height)*def.rule.height
  local ready = true
  for rx = 0,def.rule.width-1,1 do
   for ry = 0,def.rule.height-1,1 do
    if x+rx < 4 or x+rx >= sim.XRES-4 or y+ry < 4 or y+ry >= sim.YRES-4 then
     ready = false
    end
   end
  end
  if not ready then
   tpt.delete(i)
  end
  for rx = 0,def.rule.width-1,1 do
   for ry = 0,def.rule.height-1,1 do
    local element
    if ready then
     if tpt.get_property("type",x+rx,y+ry) == 0 then
      if def.rule.table[ry+1][rx+1] >= 1 then
       element = tpt.empty_create(x+rx,y+ry,element1)
      end
     end
    end
    --[[if element and element >= 0 then
     tpt.parts[element].life = 1
    end]]
   end
  end
 --[[else
  tpt.parts[i].life = tpt.parts[i].life-1
 end]]
end
elem.property(element1,"Update",update)
end
function tpt.unregister_rule_element(name,def)
 elem.free(tpt.registered_rule_elements[name].id)
 tpt.registered_rule_elements[name] = nil
end
tpt.register_rule_element() -- Basic Rule Element
tpt.register_rule_element("LOVE",{
  	allocate = {
  		group = "RULE",
  		name = "LOVE"
  	},
  	rule = {
  		width = 9,
  		height = 9,
  		table = love_rule_table
  	},
  	description = "Love...",
  	color = 0xFFFF30FF,
  	menu = {
  		visible = 1,
  		section = elem.DEFAULT_PT_HRSE and elem.SC_CRACKER2 or elem.SC_SPECIAL
  }
 })
tpt.register_rule_element("WALL",{
 	allocate = {
 		group = "BASIC",
  	name = "WALL"
 },
 	rule = {
  	width = 4,
  	height = 4,
 		table = {
   {1,1,1,1},
   {1,1,1,1},
   {1,1,1,1},
   {1,1,1,1}
  }
 	},
 	description = "Basic wall. a Rule Particle, Not a wall.",
 	color = 0xFF808080,
 	menu = {
 		visible = 1,
 		section = elem.SC_SPECIAL
 }
})
elem.property(elem.BASIC_PT_WALL,"Properties",elem.TYPE_SOLID+elem.PROP_NOCTYPEDRAW)
elem.property(elem.BASIC_PT_WALL,"HeatConduct",0)
local jacobsmod = tpt.version.jacob1s_mod or tpt.version.mobilemajor
if jacobsmod then
 tpt.indestructible(elem.BASIC_PT_WALL,1)
 elem.property(elem.BASIC_PT_WALL,"Properties",elem.TYPE_SOLID+elem.PROP_NOCTYPEDRAW+elem.PROP_INDESTRUCTIBLE)
end
tpt.register_rule_element("SMIL",{
 	allocate = {
 		group = "RULE",
  	name = "SMILE"
 },
 	rule = {
  	width = 9,
  	height = 9,
 		table = {
	{0,0,0,0,0,0,0,0,0},
	{0,1,1,0,0,1,1,0,0},
	{1,0,0,0,0,0,0,1,0},
	{0,0,1,0,0,1,0,0,0},
	{0,0,1,0,0,1,0,0,0},
	{0,0,1,0,0,1,0,0,0},
	{0,0,0,0,0,0,0,0,0},
	{0,1,0,0,0,0,1,0,0},
	{0,0,1,1,1,1,0,0,0},
  }
 	},
 	description = "Smile",
 	color = 0xFF80FFFF,
 	menu = {
 		visible = 1,
 		section = elem.DEFAULT_PT_HRSE and elem.SC_CRACKER2 or elem.SC_SPECIAL
 }
})