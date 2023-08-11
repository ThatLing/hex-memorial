-- SaitoHUD
-- Copyright (c) 2009-2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ``
-- $Id$

local menus = {}

local function AddMenu(Filename)
	local data = file.Read("saitohud/sandbox/"..Filename, "DATA")
	local newMenu = {}
	
	if data ~= nil and data ~= "" then
		data = SaitoHUD.ParseCSV(data)
		
		if #data > 0 then
			-- Remove the header
			if data[1][1] == "Title" then
				table.remove(data, 1)
			end
			
			for _, v in pairs(data) do
				table.insert(newMenu, {text = v[1], action = v[2]})
			end
		end
	else
		-- Default menu
		--table.insert(newMenu, {text = "Easy Precision Tool", action = "tool_easy_precision"})
		table.insert(newMenu, {text = "Weld", action = "tool_weld"})
		table.insert(newMenu, {text = "Remover", action = "tool_remover"})
		table.insert(newMenu, {text = "Color", action = "tool_colour"})
		table.insert(newMenu, {text = "No Collide", action = "tool_nocollide"})
		table.insert(newMenu, {text = "Adv Duplicator", action = "tool_adv_duplicator"})
		--table.insert(newMenu, {text = "Expression 2 Tool", action = "tool_wire_expression2"})
		--table.insert(newMenu, {text = "Improved Wire Tool", action = "tool_wire_improved"})	
		--table.insert(newMenu, {text = "Wire Debugger Tool", action = "tool_wire_debugger"})
	end
	menus[Filename] = newMenu
end
--- Loads the sandbox menu from file.
-- A default one will be used if the file does not exist.
function SaitoHUD.LoadSandboxMenu()
	local files = file.Find("saitohud/sandbox/*.txt", "DATA")
	print("Loading Sandbox Menu")
	
	print("Creating Menu: menu.txt");
	AddMenu("menu.txt")
	for k, v in pairs(files) do
		if string.sub(v,1,5) == "menu_" then
			print("Creating Menu: "..v);
			AddMenu(v)
		end
	end
end

function SaitoHUD.isGestMenu(Menu)
	for k,v in pairs(menus) do
		if k == Menu then return true end
	end
	
	return false
end

-- Hook for the menu
local function SandboxMenu(numItems, menu)
	 -- We only want this gesture menu to appear if there's nothing else
	if numItems > 1 then
		return {}
	end
	
	if menu == "" or menu == nil then menu = "menu.txt" end
	return menus[menu]
end

hook.Add("SaitoHUDProvideMenu", "SaitoHUD.Sandbox", SandboxMenu)

-- Load the menu!
SaitoHUD.LoadSandboxMenu()