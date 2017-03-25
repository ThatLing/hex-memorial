
if not iface3 then --Don't re-require it!
	require("iface3")
end

if file.Exists("lua/ml_Interface3_Dump.lua", true) then
	include("ml_Interface3_Dump.lua")
end

local Fake	= "gamemodes\\base\\gamemode\\cl_init.lua"
local First = 0
local Show	= false

concommand.Add("show", function()
	Show = not Show
	print("! Show: ", Show)
end)


local Addons = {}
local function GetAddons()
	if (#Addons != 0) then return Addons end
	
	for k,v in pairs( file.Find("addons/*", true) ) do
		table.insert(Addons, v)
	end
	return Addons
end
local function VFSPath(path)
	path = "lua/"..path
	if iface3.Exists(path) then return path end
	
	for k,v in pairs( GetAddons() ) do
		local APath = "addons/"..v.."/"..path
		if iface3.Exists(APath) then
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


function RunFromVFS(path,name)
	path = VFSPath(path)
	
	if not path then return end --No file exists!
	
	local set = path:gsub("/", "\\")
	if name then set = name end
	
	iface3.SetRunString(set)
	iface3.RunString( iface3.Read(path) )
end


hook.Add("CanRunString", "has", function(name,path,stuff)
	if Show then
		local name2 = name:gsub("\\", "/")
		
		if name2 == "LuaCmd" or path == "LuaCmd" then
			name2 = "LuaCmd_"..tostring( CurTime() ):Replace(".", "_")
			
			print("! SendLua: ", name2)
		else
			print("! load: ", name2)
		end
	end
	
	if DPackSave and DumpDatPack then
		DumpDatPack(name,path,stuff)
	end
	
	First = First + 1
	if First == 1 then
		RunFromVFS("hex_iface_setup.lua", name) --Setup
		--RunFromVFS("interface.lua") --Test script
	end
end)
hook.Add("LoadingComplete", "poop", function()
	print("! game loaded")
	/*
	timer.Simple(5, function()
		iface3.RunString(
			[[
				if not lol then
					RunConsoleCommand("hex_loadme")
				end
			]]
		)
	end)
	*/
end)
hook.Add("DisconnectFromServer", "Reset", function()
	First = 0
end)


local function LoadMe(ply,cmd,args)
	iface3.SetGlobals()
	
	print("! trying manual load")
	RunFromVFS("hex_iface_loader.lua", Fake)
end
concommand.Add("hex_loadme", LoadMe)




if input_box then
	input_box:Remove()
end

input_box = vgui.Create("DFrame")
	input_box:SetTitle("ILuaInterface::RunString")
	input_box:SetSize(400,55)
	input_box:SetPos( ScrW()-400-15, ScrH()-55-15 )
input_box:MakePopup()

text_box = vgui.Create("DTextEntry", input_box)
	text_box:SetPos(5,28)
text_box:SetWide(390)
function text_box:OnEnter()
	local lua = self:GetValue()
	
	print("> ", lua)
	iface3.RunString( lua )
	
	self:SetText("")
	self:SetCaretPos(0)
end


local function SearchScript(cmd,str)
	str = (str or ""):Trim()
	if str == "" then return end
	
	local path = ""
	if str:find("/") then  
		path = str:gsub("/[^/]+$","").."/"  
	end  
	
	local files = {}
	for _,v in pairs( FindWithAddons(str.."*") ) do  
		if not (v == "." or v == "..") and (v:find("%.lua") or not v:find("%.")) then  
			local new = cmd.." "..(path..v):gsub("[/\\]+","/")
			
			if not table.HasValue(files,new) then
				table.insert(files,new)
			end
		end
	end
	table.insert(files,"")
	
	return files
end
local function OpenScript(ply,cmd,args)
	args = table.concat(args," ")
	local path = VFSPath(args)
	if not path then
		print("! gone: ", args)
		return
	end
	
	iface3.SetRunString(path)
	iface3.RunString( iface3.Read(path) )
end
concommand.Add("lua_openscript_i", OpenScript, SearchScript)










