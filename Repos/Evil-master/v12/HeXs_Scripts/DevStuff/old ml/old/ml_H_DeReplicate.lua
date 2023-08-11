


if not hexcv then
	require("hexcv")
end


local CVars = {
	["sv_cheats"]				 = {"0", FCVAR_NOTIFY | FCVAR_REPLICATED | FCVAR_CHEAT },
	["host_timescale"]			 = {"1.0", FCVAR_NOTIFY | FCVAR_REPLICATED | FCVAR_CHEAT },
	["r_drawparticles"]			 = {"1", FCVAR_CLIENTDLL | FCVAR_CHEAT },
	["r_drawothermodels"] 		 = {"1", FCVAR_CLIENTDLL | FCVAR_CHEAT },
	["mat_fullbright"]			 = {"0", FCVAR_CHEAT },

}


for k,v in pairs(CVars) do
	if ( ConVarExists(k) and not ConVarExists("hex_"..k) ) then
		local value = v[1]
		local flags = v[2]
		
		hex.ReplicateConVar(k, "hex_"..k, flags, value)
		CreateConVar(k, value, flags)
		
		print("! done: ", "hex_"..k, value, flags)
	end
end




if not hexcv then
	if not require("hexcv") then
		hexcv = {}
		hexcv.NotInstalled = true
		hexcv.SetFlags = function() print("[HeX] gm_hexcv.dll gone!") end
		hexcv.GetFlags = function() print("[HeX] gm_hexcv.dll gone!") return 1 end
		hexcv.IsFlagSet = function() print("[HeX] gm_hexcv.dll gone!") return false end
	end
end


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
	elseif CVarToString[flags] then
		flags = CVarToString[flags]
	else
		flags = tostring(flags)
	end
	
	COLCON( RED, "Bypass:", WHITE, " Stripped ", BROWN, flags, WHITE, " on ", GREEN, cvar )
	return true
end


local function ManuallyDeReplicate(ply,cmd,args)
	if (#args > 0) then
		local CVar = v
		StripCVar(CVar)
		MsgDeReplicate(CVar, FCVAR_CHEAT)
	end
	
	
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
--timer.Simple(0, AlwaysDeReplicate)




