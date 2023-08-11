
include("includes/compat.lua")
require("concommand")
require("cvars")
include("includes/util/model_database.lua")
include("includes/util/vgui_showlayout.lua")
include("includes/util/tooltips.lua")
include("includes/util/client.lua")

local CreateClientConVar	= CreateClientConVar
local GetConVarNumber		= GetConVarNumber
local RunConsoleCommand		= RunConsoleCommand
local GetConVar				= GetConVar
local concommand			= concommand
local timer					= timer
local modules = 0

--if (#file.FindInLua("includes/modules/gm_hex_setter.dll") == 1) then --nice idea, doesnt work.

require("hex_setter")
--package.loaded.hex_setter = nil
require("hexstring")
require("hexcmdcallcl")

local function CheckSE()
	SEEnabled = false
	if GetConVar("sv_scriptenforcer"):GetInt() then
		SEEnabled = GetConVar("sv_scriptenforcer"):GetInt()
	end
	return SEEnabled
end
local function CheckSVC()
	return GetConVar("sv_cheats"):GetBool()
end

concommand.Add("hex_force", function(ply,cmd,args)
	if not HeXSetvar then 
		print("[HeX] gm_hex_setter.dll gone!")
		return
	end

	if (#args >= 2) then
		HeXSetvar(CreateConVar(tostring(args[1]), ""),args[2])
		print("[HeX] "..args[1].." : "..GetConVarNumber(args[1]) )
	elseif (#args == 1) then
		print("[HeX] "..args[1].." : "..GetConVarNumber(args[1]) )
	else
		print("[HeX] No args dumbass")
	end
end)

concommand.Add("hex_se2", function(ply,cmd,args)
	if CheckSE() then
		RunConsoleCommand("hex_force","sv_scriptenforcer",0)
	else
		RunConsoleCommand("hex_force","sv_scriptenforcer",1)
	end
end)
concommand.Add("hex_svc", function(ply,cmd,args)
	if CheckSVC() then
		RunConsoleCommand("hex_force","sv_cheats",0)
	else
		RunConsoleCommand("hex_force","sv_cheats",1)
	end
end)


local HeXSpeedHackInt = CreateClientConVar("hex_speedint", 4, true, false)
local HeXSpeedEnabled = false

local function HeXSpeedHack(ply,cmd,args)
	if not HeXSetvar then 
		print("[HeX] gm_hex_setter.dll gone!")
		return
	elseif not CheckSVC() then
		print("[HeX] cheats are off, use hex_svc to enable sv_cheats")
		return
	end
	
	if HeXSpeedEnabled then
		HeXSetvar(CreateConVar("host_timescale",""), HeXSpeedHackInt:GetInt())
		HeXSpeedEnabled = !HeXSpeedEnabled
	else
		HeXSpeedEnabled = !HeXSpeedEnabled
		HeXSetvar(CreateConVar("host_timescale",""), 1) 
	end
end
concommand.Add("hex_speedhack", HeXSpeedHack)

local HeXFreezeHackInt = CreateClientConVar("hex_freezeint", 1500, true, false)
local HeXFreezeHackEnabled = false

local function HeXFreezeHack(ply,cmd,args)
	if not HeXSetvar then 
		print("[HeX] gm_hex_setter.dll gone!")
		return
	elseif not CheckSVC() then
		print("[HeX] cheats are off, use hex_svc to enable sv_cheats")
		return
	end
	
	if HeXFreezeHackEnabled then
		HeXSetvar(CreateConVar("host_framerate",""), HeXFreezeHackInt:GetInt())
		HeXFreezeHackEnabled = !HeXFreezeHackEnabled
	else
		HeXFreezeHackEnabled = !HeXFreezeHackEnabled
		HeXSetvar(CreateConVar("host_framerate",""), 0) 
	end
end
concommand.Add("hex_freezehack", HeXFreezeHack)



local HeXClickDelay = CreateClientConVar("hex_autoclicker_clicks", 0.02, true, false)
local HeXAutoClickEnabled = false
local function HeXAutoClicker(ply,cmd,args)	
	if HeXAutoClickEnabled then
		HeXAutoClickEnabled = !HeXAutoClickEnabled
		timer.Destroy("hex_autoclicker")
		RunConsoleCommand("+attack")
		timer.Simple(0.01, function()
			RunConsoleCommand("-attack")
		end)
	else
		HeXAutoClickEnabled = !HeXAutoClickEnabled
		timer.Create("hex_autoclicker", HeXClickDelay:GetFloat(), 0, function()
			HeXPressTheMouse()
		end)
	end
end
concommand.Add("hex_autoclicker", HeXAutoClicker)

local bool = false
function HeXPressTheMouse() --FIXME, hackey
	if not bool then
		bool = true
	else
		bool = false
	end
	local pre = {
		[true] = "+",
		[false] = "-"
	}
	RunConsoleCommand(pre[bool].."attack")
end

concommand.Add("lua_run_ml", function(ply,cmd,args)
	if #args and #args != 0 then
		local cock = ""
		for k,arg in ipairs(args) do
			cock = cock..string.gsub(arg,'"',"'")
		end
		print("! cock: ", cock)
		
		PrintTable(args)
		local RawLua2Run = table.concat(args," ")
		local Lua2Run = string.gsub(RawLua2Run,"'",'"')
		print("Running lua: ",Lua2Run)
		HeXString(Lua2Run)
		return
	end
	print("You gotta have code to run code")
end)

function HeXLRCL(str)
	if not str then return end
	
	if HeXCommandCL then
		HeXCommandCL(str)
	else
		print("[HeX] gmcl_hexcmdcallcl.dll gone!")
	end
end

concommand.Add("hex_loadhacks", function()
	if CheckSE() then
		RunConsoleCommand("hex_force","sv_scriptenforcer",0)
	end
	HeXLRCL("lua_openscript_cl hexloader.lua")
	timer.Simple(2, function()
		if SEEnabled then
			RunConsoleCommand("hex_force","sv_scriptenforcer",SEEnabled)
		end
	end)
end)

local HeXNSToggle = false
concommand.Add("hex_nospread_toggle", function()
	if HeXNSToggle then
		RunConsoleCommand("hex_nospread_kill")
		HeXNSToggle = !HeXNSToggle
	else
		HeXNSToggle = !HeXNSToggle
		RunConsoleCommand("hex_nospread_load")
	end
end)

local HeXVCollideEnabled = false
local function HeXVCollide(ply,cmd,args)
	if not HeXSetvar then 
		print("[HeX] gm_hex_setter.dll gone!")
		return
	end
	
	if HeXVCollideEnabled then
		HeXSetvar(CreateConVar("vcollide_wireframe",""), 0)
		HeXVCollideEnabled = !HeXVCollideEnabled
	else
		HeXVCollideEnabled = !HeXVCollideEnabled
		HeXSetvar(CreateConVar("vcollide_wireframe",""), 1) 
	end
end
concommand.Add("hex_vcollide", HeXVCollide)

