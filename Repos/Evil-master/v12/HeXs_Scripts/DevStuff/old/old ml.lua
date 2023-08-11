

CVarToString = {
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




local HeXVCollideEnabled = false
local function HeXVCollide(ply,cmd,args)
	if HeXVCollideEnabled then
		HeXSetvar(CreateConVar("vcollide_wireframe",""), "0")
		HeXVCollideEnabled = !HeXVCollideEnabled
	else
		HeXVCollideEnabled = !HeXVCollideEnabled
		HeXSetvar(CreateConVar("vcollide_wireframe",""), "1") 
	end
end
concommand.Add("hex_vcollide", HeXVCollide)


concommand.Add("hex_force", function(ply,cmd,args)
	if (#args >= 2) then
		HeXSetvar(CreateConVar(tostring(args[1]), ""),args[2])
		print("[HeX] "..args[1].." : "..GetConVarNumber(args[1]) )
	elseif (#args == 1) then
		print("[HeX] "..args[1].." : "..GetConVarNumber(args[1]) )
	else
		print("[HeX] No args dumbass")
	end
end)




concommand.Add("hex_svc", function(ply,cmd,args)
	if CheckSVC() then
		RunConsoleCommand("hex_force","sv_cheats",0)
	else
		RunConsoleCommand("hex_force","sv_cheats",1)
	end
end)





