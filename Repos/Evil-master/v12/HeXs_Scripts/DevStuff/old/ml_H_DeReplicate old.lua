
if not hexcv then
	if not require("hexcv") then
		hexcv = {}
		hexcv.NotInstalled = true
		hexcv.SetFlags = function() print("[HeX] gm_hexcv.dll gone! (SetFlags)") end
		hexcv.GetFlags = function() print("[HeX] gm_hexcv.dll gone! (GetFlags)") return 1 end
	end
end

local RED = Color(237,16,29)
local WHITE = Color(255,255,255)
local GREEN = Color(182,231,18)
local PINK = Color(255,175,202)
local BROWN = Color(128,128,0)

local NiceCVarName = ""
local TotalCVars = 0
local SrippedCVars = {}

local CVarsToRemove = {
	["sv_cheats"]			= FCVAR_REPLICATED,
	["host_timescale"]		= FCVAR_REPLICATED,
	["mat_wireframe"]		= FCVAR_CHEAT,
	["mat_fullbright"]		= FCVAR_CHEAT,
	["host_framerate"]		= FCVAR_CHEAT,
	["vcollide_wireframe"]	= FCVAR_CHEAT,
}


local function RemoveCVarFlag(cvar,flag)
	if hexcv then
		hexcv.SetFlags(cvar, hexcv.GetFlags(cvar) - flag)
		return true
	end
	return false
end

local function MsgDeReplicate()
	if hexcv.NotInstalled then
		COLCON( RED, "Bypass", WHITE, ": ERROR! hexcv not found!")
		return
	end
	
	if TotalCVars > 0 then
		for k,v in pairs(SrippedCVars) do
			COLCON( RED, "Bypass", WHITE, ": Stripped "..v.." on ", GREEN, k )
		end
		COLCON( RED, "Bypass", WHITE, ": Stripped ", GREEN, TotalCVars, WHITE, " CVars" )
		Msg("\n")
		return
	end
	return true
end
timer.Simple(0, MsgDeReplicate)


local function RunDeReplicate()
	TotalCVars = 0
	SrippedCVars = {}
	
	for k,v in pairs(CVarsToRemove) do
		TotalCVars = TotalCVars + 1
		RemoveCVarFlag(k,v)
		
		NiceCVarName = ""
		if v == FCVAR_CHEAT then
			NiceCVarName = "FCVAR_CHEAT"
		elseif v == FCVAR_REPLICATED then
			NiceCVarName = "FCVAR_REPLICATED"
		end
		SrippedCVars[k] = NiceCVarName
	end
	MsgDeReplicate()
	return true
end
concommand.Add("hex_dereplicate", RunDeReplicate)















