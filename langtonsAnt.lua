function tpt.delete_create(x,y,elem)
 local part = sim.pmap(x,y)
 if part then
  tpt.delete(part)
 end
 return tpt.create(x,y,elem)
end

local element1 = elements.allocate("LANGTON","SOLID")
elements.element(element1, elements.element(elements.DEFAULT_PT_DMND))
elements.property(element1, "Name", "LAS")
elements.property(element1, "Description", "Langton's Ant Solid.")
elements.property(element1, "Colour", 0xCCCCCC)
elements.property(element1, "MenuVisible", 1)
elements.property(element1, "MenuSection", elem.SC_LIFE)

local element1 = elements.allocate("LANGTON","ANT")
elements.element(element1, elements.element(elements.DEFAULT_PT_DMND))
elements.property(element1, "Name", "LA")
elements.property(element1, "Description", "Langton's Ant.")
elements.property(element1, "Colour", 0xFFFFFF)
elements.property(element1, "MenuSection", elem.SC_LIFE)
elements.property(element1, "Create", function(i)
 tpt.parts[i].tmp = math.random(0,3) -- direction
 tpt.parts[i].ctype = elem.LANGTON_PT_SOLID -- special solid
end)
elements.property(element1, "Update", function(i,x,y,s,n)
 local ctype = tpt.parts[i].ctype
 if tpt.parts[i].life > 0 then
  tpt.parts[i].life = tpt.parts[i].life-1
  return
 end
 local dir = tpt.parts[i].tmp
 local dx,dy = 0,0
 if dir == 0 then
  dx,dy = 0,-1
 elseif dir == 1 then
  dx,dy = -1,0
 elseif dir == 2 then
  dx,dy = 0,1
 elseif dir == 3 then
  dx,dy = 1,0
 end
 if tpt.parts[i].tmp2 == 1 then
  tpt.parts[i].tmp = tpt.parts[i].tmp-1
  if tpt.parts[i].tmp < 0 then
   tpt.parts[i].tmp = 3
  end
 else
  tpt.parts[i].tmp = tpt.parts[i].tmp+1
  if tpt.parts[i].tmp > 3 then
   tpt.parts[i].tmp = 0
  end
 end
  dir = tpt.parts[i].tmp
  if dir == 0 then
   dx,dy = 0,-1
  elseif dir == 1 then
   dx,dy = -1,0
  elseif dir == 2 then
   dx,dy = 0,1
  elseif dir == 3 then
   dx,dy = 1,0
  end
 local tmp2 = tpt.parts[i].tmp2
 tpt.parts[i].tmp = 0
 tpt.parts[i].ctype = 0
 tpt.parts[i].tmp2 = 0
 tpt.set_property("type",tmp2 ~= 1 and ctype or 0,i)
 local solid_detected = 0
 local itype = tpt.get_property("type",x+dx,y+dy)
 if itype == ctype then
  solid_detected = 1
 end
 local part = -1
 if itype == 0 or itype == ctype then
  part = tpt.delete_create(x+dx,y+dy,element1)
 end
 if part and part > -1 then
  tpt.parts[part].ctype = ctype
  tpt.parts[part].life = 1
  tpt.parts[part].tmp = dir
  tpt.parts[part].tmp2 = solid_detected
 end
end)
