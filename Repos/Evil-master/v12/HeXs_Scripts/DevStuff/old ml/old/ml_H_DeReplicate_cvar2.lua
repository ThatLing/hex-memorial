
if not hexcv then
	if not require("hexcv") then
		hexcv = {}
		hexcv.NotInstalled = true
		hexcv.SetFlags = function() print("[HeX] gm_hexcv.dll gone! (SetFlags)") end
		hexcv.GetFlags = function() print("[HeX] gm_hexcv.dll gone! (GetFlags)") return 1 end
		hexcv.IsFlagSet = function() print("[HeX] gm_hexcv.dll gone! (IsFlagSet)") return false end
	end
end

local RED = Color(237,16,29)
local WHITE = Color(255,255,255)
local GREEN = Color(182,231,18)
local PINK = Color(255,175,202)
local BROWN = Color(128,128,0)

local TotalCVars = 0

local BypassCVars = {
	["sv_cheats"]			= FCVAR_REPLICATED,
	["host_timescale"]		= FCVAR_REPLICATED,
	["host_framerate"]		= FCVAR_CHEAT,
}
local AlwaysBypass = {	
	["mat_wireframe"]		= FCVAR_CHEAT,
	["mat_fullbright"]		= FCVAR_CHEAT,
	["vcollide_wireframe"]	= FCVAR_CHEAT,
	["r_drawothermodels"]	= FCVAR_CHEAT,
	["thirdperson"]			= FCVAR_CHEAT,
	["firstperson"]			= FCVAR_CHEAT,
	["snd_show"]			= FCVAR_CHEAT,
	["showtriggers"]		= FCVAR_CHEAT,
	["showtriggers_toggle"]	= FCVAR_CHEAT,
	["mat_crosshair"]		= FCVAR_CHEAT,
	["fog_override"]		= FCVAR_CHEAT,
}


local function StripCVar(cvar)
	hexcv.SetFlags(cvar, FCVAR_NONE)
end

local function MsgDeReplicate(cvar,flags)
	if hexcv.NotInstalled then
		COLCON( RED, "Bypass", WHITE, ": ERROR! hexcv not found!")
		return false
	end
	
	
	if flags == FCVAR_CHEAT + FCVAR_NOT_CONNECTED then
		flags = "FCVAR_CHEAT, FCVAR_NOT_CONNECTED"
	elseif flags == FCVAR_REPLICATED + FCVAR_NOT_CONNECTED then
		flags = "FCVAR_REPLICATED, FCVAR_NOT_CONNECTED"
	--[[elseif CVarToString[flags] then
		flags = CVarToString[flags]]]
	else
		flags = tostring(flags)
	end
	
	COLCON( RED, "Bypass:", WHITE, " Stripped ", BROWN, flags, WHITE, " on ", GREEN, cvar )
	return true
end


local function ManuallyDeReplicate()
	TotalCVars = 0
	for k,v in pairs(BypassCVars) do
		TotalCVars = TotalCVars + 1
		StripCVar(k)
		MsgDeReplicate(k, v)
	end
	COLCON( RED, "Bypass", WHITE, ": Stripped ", GREEN, TotalCVars, WHITE, " more CVars\n" )
	--Msg("\n")
end
concommand.Add("hex_dereplicate", ManuallyDeReplicate)


local function AlwaysDeReplicate() --always bypass
	TotalCVars = 0
	for k,v in pairs(AlwaysBypass) do
		TotalCVars = TotalCVars + 1
		StripCVar(k)
		MsgDeReplicate(k, v)
	end
	COLCON( RED, "Bypass:", WHITE, " Stripped ", GREEN, TotalCVars, WHITE, " CVars\n" )
	--Msg("\n")
end
timer.Simple(0, AlwaysDeReplicate)




