

local function GetVar(cvar)
	if replicator and ReplicatorDone then
		cvar = CVar_Prefix..cvar
	end
	return cvar
end

local function CheckSVC()
	return GetConVar( GetVar("sv_cheats") ):GetBool()
end



local Speed = CreateClientConVar("hex_speedint", 4, true, false)
local SpeedEnabled = false

local function HeXSpeedHack(ply,cmd,args)
	if not CheckSVC() then
		print("Enable sv_cheats to use this command!")
		return
	end
	
	if SpeedEnabled then
		SpeedEnabled = !SpeedEnabled
		
		HeXLRCL( GetVar("host_timescale").." "..Speed:GetInt() )
	else
		SpeedEnabled = !SpeedEnabled
		
		HeXLRCL( GetVar("host_timescale").." 1.0" )
	end
end
concommand.Add("hex_speedhack", HeXSpeedHack)


local Freeze = CreateClientConVar("hex_freezeint", 1500, true, false)
local FreezeEnabled = false

local function HeXFreezeHack(ply,cmd,args)
	if not CheckSVC() then
		print("Enable sv_cheats to use this command!")
		return
	end
	
	if FreezeEnabled then
		HeXLRCL(  GetVar("host_framerate").." "..Freeze:GetInt() )
		FreezeEnabled = !FreezeEnabled
	else
		FreezeEnabled = !FreezeEnabled
		HeXLRCL(  GetVar("host_framerate").." 0" )
	end
end
concommand.Add("hex_freeze", HeXFreezeHack)




