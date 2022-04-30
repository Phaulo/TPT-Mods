if (not tpt.registered_rule_elements) and (not tpt.resgister_rule_element) and (not tpt.unregister_rule_element) then
 print("The Game has no Rule Elements mod.")
 return
end

function string.get(str,index)
    return string.sub(str,index,-(#str)+(index-1))
end

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

local code = ""
function ruleTable_to_binary_code(table)
 result = ""
 if type(table) == "table" then
  for i = 1,#table do
   for j = 1,#table[i] do
    result = result..tostring(table[i][j])
   end
  end
 else
  return table
 end
 return result
end
function binary_code_to_ruleTable(binary_code,width)
 result = {}
 if type(binary_code) == "string" then
  for i = 1,#binary_code/width do
   result[i] = {}
   for j = 1,width do
    result[i][j] = tonumber(string.get(binary_code,(((i-1)*width)+1)+j-1))
   end
  end
 else
  return binary_code
 end
 return result
end
function binary_code_to_ruleTable_text(binary_code,width)
 result = [[{
]]
  for i = 1,#binary_code/width do
   result = result.."{"
   for j = 1,width do
     if j > 1 then
    result = result..","
    	end
    result = result..(string.get(binary_code,(((i-1)*width)+1)+j-1))
   end
   result = result..[[},
]]
  end
 result = result.."}"
 return result
end

function tpt.register_custom_rule_element(name,def)
tpt.register_rule_element(name,def)
code = code..[[ tpt.register_custom_rule_element("]]..name..[[",{
  	allocate = {
  		group = "]]..def.allocate.group..[[",
  		name = "]]..def.allocate.name..[["
  	},
  	rule = {
  		width = ]]..def.rule.width..[[,
  		height = ]]..def.rule.height..[[,
  		table = ]]..binary_code_to_ruleTable_text(ruleTable_to_binary_code(def.rule.table),def.rule.width)..[[
  	},
  	description = "]]..def.description..[[",
  	color = ]].."0x"..bit.tohex(def.color)..[[,
  	menu = {
  		visible = 1,
  		section = elem.DEFAULT_PT_HRSE and elem.SC_CRACKER2 or elem.SC_SPECIAL
  }
 })
]]
 
    file = io.open("Custom Rule Elements.lua", "w")
    file:write(code)
    file:close()
end

local encoded_rule_table = ruleTable_to_binary_code(lolz_rule_table)
local width = 300
local height = 160
 
local window = Window:new(-1, -1, width, height)
 
local namelabel = Label:new(4, 4, 32, 16, "Name:")
window:addComponent(namelabel)
local nametext = Textbox:new(4+32, 8, 50, 16, "LOLZ", "")
window:addComponent(nametext)
local colorlabel = Label:new(4, 24, 32, 16, "Color:")
window:addComponent(colorlabel)
local colortext = Textbox:new(4+32, 24+4, 50, 16, "569212", "")
window:addComponent(colortext)
local widthlabel = Label:new(4, 24+16+8, 32, 16, "Width:")
window:addComponent(widthlabel)
local widthtext = Textbox:new(4+32, 32+16, 50, 16, "9", "")
window:addComponent(widthtext)
local heightlabel = Label:new(4+32+50, 24+16+8, 32, 16, "Height:")
window:addComponent(heightlabel)
local heighttext = Textbox:new(4+64+50, 32+16, 50, 16, "9", "")
window:addComponent(heighttext)
local descriptionlabel = Label:new(4+(tpt.textwidth("Description:")/4), 24+32+8, 32, 16, "Description:")
window:addComponent(descriptionlabel)
local descriptiontext = Textbox:new(4+32+(tpt.textwidth("Description:")/2), 32*2+4, 200, 16, "Lolz", "")
window:addComponent(descriptiontext)
local tablelabel = Label:new(4, 24+(16*3)+8, 32, 16, "Table:")
window:addComponent(tablelabel)
local tabletext = Label:new(4+32+(tpt.textwidth(encoded_rule_table)/3.5), 32*2.4+4, 200, 16, encoded_rule_table)
window:addComponent(tabletext)
local importbutton = Button:new(width/2-(tpt.textwidth("Import Unencoded Rule Table")/2), 147-32, tpt.textwidth("Import Unencoded Rule Table")+8, 16, "Import Unencoded Rule Table")
importbutton:action(
	function(sender)
    encoded_rule_table = ruleTable_to_binary_code(dofile("unencoded rule tables/"..tpt.input("Rule Element Creator")..".lua") or lolz_rule_table)
    tabletext:text(encoded_rule_table)
 	end
)
window:addComponent(importbutton)
local cancelbutton = Button:new(width/2-64, height-16, tpt.textwidth("Cancel")+8, 16, "Cancel")
cancelbutton:action(
	function(sender)
    ui.closeWindow(window)
	end
)
window:addComponent(cancelbutton)
local createbutton = Button:new(width/2+64, height-16, tpt.textwidth("Create")+8, 16, "Create")
createbutton:action(
	function(sender)
 tpt.register_custom_rule_element(nametext:text(),{
  	allocate = {
  		group = "CUSTOMRULE",
  		name = nametext:text()
  	},
  	rule = {
  		width = tonumber(widthtext:text()),
  		height = tonumber(heighttext:text()),
  		table = binary_code_to_ruleTable(encoded_rule_table,tonumber(widthtext:text()))
  	},
  	description = descriptiontext:text(),
  	color = tonumber("0x"..colortext:text()),
  	menu = {
  		visible = 1,
  		section = elem.DEFAULT_PT_HRSE and elem.SC_CRACKER2 or elem.SC_SPECIAL
  }
 })
    ui.closeWindow(window)
	end
)
window:addComponent(createbutton)

dofile("Custom Rule Elements.lua") -- Custom Rule Elements Data
 
local last_selectedl = tpt.selectedl
local last_selectedr = tpt.selectedr
local last_selecteda = tpt.selecteda
local function tick()
	if tpt.selectedl == "CUSTOMRULE_PT_ADD" then
		ui.showWindow(window)
		tpt.selectedl = last_selectedl
	end
	if tpt.selectedr == "CUSTOMRULE_PT_ADD" then
		ui.showWindow(window)
		tpt.selectedr = last_selectedr
	end
	if tpt.selecteda == "CUSTOMRULE_PT_ADD" then
		ui.showWindow(window)
		tpt.selecteda = last_selecteda
	end
	last_selectedl = tpt.selectedl
	last_selectedr = tpt.selectedr
	last_selecteda = tpt.selecteda
end
event.register(event.tick, tick)

local la_plus = elem.CUSTOMRULE_PT_ADD or elem.allocate("customrule", "add")
elem.element(la_plus, elem.element(elem.DEFAULT_PT_DMND))
elem.property(la_plus, "Name", "RLE+")
elem.property(la_plus, "Description", "Select to add a Rule Element")
elem.property(la_plus, "MenuSection", elem.SC_SPECIAL)
elem.property(la_plus, "Color", 0x7F7F7F)
