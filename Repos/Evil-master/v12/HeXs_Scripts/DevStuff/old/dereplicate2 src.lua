

local CVarToString = {
	[FCVAR_UNREGISTERED]			= "FCVAR_UNREGISTERED",
	[FCVAR_GAMEDLL] 				= "FCVAR_GAMEDLL",
	[FCVAR_CLIENTDLL]				= "FCVAR_CLIENTDLL",
	[FCVAR_PROTECTED]				= "FCVAR_PROTECTED",
	[FCVAR_SPONLY]					= "FCVAR_SPONLY",
	[FCVAR_ARCHIVE]					= "FCVAR_ARCHIVE",
	[FCVAR_NOTIFY]					= "FCVAR_NOTIFY",
	[FCVAR_USERINFO]				= "FCVAR_USERINFO",
	[FCVAR_PRINTABLEONLY]			= "FCVAR_PRINTABLEONLY",
	[FCVAR_UNLOGGED]				= "FCVAR_UNLOGGED",
	[FCVAR_NEVER_AS_STRING]			= "FCVAR_NEVER_AS_STRING",
	[FCVAR_REPLICATED]				= "FCVAR_REPLICATED",
	[FCVAR_CHEAT]					= "FCVAR_CHEAT",
	[FCVAR_DEMO]					= "FCVAR_DEMO",
	[FCVAR_DONTRECORD]				= "FCVAR_DONTRECORD",
	[FCVAR_NOT_CONNECTED]			= "FCVAR_NOT_CONNECTED",
	[FCVAR_ARCHIVE_XBOX]			= "FCVAR_ARCHIVE_XBOX",
	[FCVAR_SERVER_CAN_EXECUTE]		= "FCVAR_SERVER_CAN_EXECUTE",
	[FCVAR_SERVER_CANNOT_QUERY]		= "FCVAR_SERVER_CANNOT_QUERY",
	[FCVAR_CLIENTCMD_CAN_EXECUTE]	= "FCVAR_CLIENTCMD_CAN_EXECUTE",
}

	if flags == FCVAR_CHEAT + FCVAR_NOT_CONNECTED then
		flags = "FCVAR_CHEAT, FCVAR_NOT_CONNECTED"
	elseif flags == FCVAR_REPLICATED + FCVAR_NOT_CONNECTED then
		flags = "FCVAR_REPLICATED, FCVAR_NOT_CONNECTED"
	elseif CVarToString[flags] then
		flags = CVarToString[flags]
	else
		flags = tostring(flags)
	end

--[[
mat_wireframe 
 notconnected cheat server_can_execute clientcmd_can_execute
 
mat_fullbright 
 notconnected cheat

vcollide_wireframe 
 client notconnected cheat server_can_execute clientcmd_can_execute
]]

local function StripCVar(cvar,flag) --remove
	if hexcv and hexcv.IsFlagSet(cvar, flag) then
		print("! cv: ", cvar, " flag: ", flag)
		hexcv.SetFlags(cvar, hexcv.GetFlags(cvar) - flag)
		return true
		
	else
	print("! fuckup: ", cvar)
		
		
	end
	return false
end


local function StripCVarMulti(cvar,flags)
	for k,v in pairs(flags) do
		StripCVar(cvar,v)
	end
	return
end

	
	

	StripCVar("sv_cheats", FCVAR_REPLICATED)
	MsgDeReplicate("sv_cheats", FCVAR_REPLICATED)

	StripCVar("host_timescale", FCVAR_REPLICATED)
	MsgDeReplicate("host_timescale", FCVAR_REPLICATED)	
	
	StripCVar("host_framerate", FCVAR_CHEAT)
	MsgDeReplicate("host_framerate", FCVAR_CHEAT)





