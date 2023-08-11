
local Addons	= {}

local function GetAddons()
	if (#Addons != 0) then return Addons end
	
	for k,v in pairs( file.Find("addons/*", true) ) do
		table.insert(Addons, v)
	end
	return Addons
end

local function VFSPath(path)
	path = "lua/"..path
	if file.Exists(path,true) then return path end
	
	for k,v in pairs( GetAddons() ) do
		local APath = "addons/"..v.."/"..path
		if file.Exists(APath,true) then
			return APath
		end
	end
	
	return false
end
local function FindWithAddons(str)
	local tab = file.FindInLua(str)
	
	for k,v in pairs( GetAddons() ) do
		table.Add(tab, file.Find("addons/"..v.."/lua/"..str, true) )
	end
	
	return tab
end


local CMIFiles	= {}
for k,v in pairs( FindWithAddons("menu_plugins/*.lua") ) do
	local path = VFSPath(v)
	if path then
		table.insert(CMIFiles, path)
	end
end


local function Load(path)
	
end


for k,v in pairs(CMIFiles) do
	if HAC.StringCheck(v, "ml_B_") then
		COLCON(CMIColor, " Loading ", PINK, "Base", WHITE, ": "..v)
		Load("custom_menu/"..v)
		
	elseif HAC.StringCheck(v, "sh_") then
		Load("HAC/"..v)
		AddCSLuaFile("HAC/"..v)
	end
end

