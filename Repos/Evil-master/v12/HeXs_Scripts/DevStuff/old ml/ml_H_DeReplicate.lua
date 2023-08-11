if not ReplicatorLoaded then
	ReplicatorLoaded = true
	concommand.Add("hex_dereplicate_load", function() include("custom_menu/ml_H_DeReplicate.lua") end)
	return
end

if not replicator then
	require("replicator")
end
if not replicator then
	COLCON(RED, "Replicator", WHITE, ": Error 404, replicator not found!")
	
	require("hexcv")
	if hexcv then
		COLCON(RED, "Replicator", WHITE, ": Loading old version..")
		include("custom_menu/old/ml_H_DeReplicate_cvar2.lua")
	else
		COLCON(RED, "Replicator", WHITE, ": Can't load either version, fix yo module!")
	end
	return
end


CVar_Prefix = "hex_"

local AlwaysBypass = {
	"vcollide_wireframe",
	"fog_override",
	"showtriggers",
	"snd_show",
}

local NowBypass = {
	"sv_cheats",
	"host_timescale",
	"host_framerate",
	
	"r_drawparticles",
	"r_drawothermodels",
	"mat_fullbright",
	"mat_wireframe",
}




function RenameCVar(name)
	local NewName = CVar_Prefix..name
	
	if ( ConVarExists(name) and not ConVarExists(NewName) ) then
		local CVar	= GetConVar(name)
		
		local Value = CVar:GetDefault()
		local Flags = replicator.GetFlags(name)
		local Help	= CVar:GetHelpText() or false
		
		local Done = replicator.Replicate(name, NewName, Flags, Value)
		
		if not Done then
			COLCON(RED, "Replicator", WHITE, ": ! FUCKUP, replicator error")
			return
		end
		
		if Help then
			CreateConVar(name, Value, Flags, Help)
		else
			CreateConVar(name, Value, Flags)
		end
	end
	
	return name, NewName
end



local function MsgDeReplicate(cvar,newname)
	COLCON(RED, "Replicator: ", BROWN, cvar, WHITE, " -> ", GREEN, newname)
end

local function ManualDeReplicate(ply,cmd,args)
	if ReplicatorDone then
		COLCON(RED, "Replicator", WHITE, ": Already used ManualDeReplicate!")
		return
	end
	
	if (#args > 0) then
		local name = args[1]
		
		MsgDeReplicate( RenameCVar(name) ) --So easy!
		return
	end
	
	local Total = 0
	for k,v in pairs(NowBypass) do
		Total = Total + 1
		MsgDeReplicate( RenameCVar(v) )
	end
	
	COLCON(RED, "Replicator", WHITE, ": Renamed ", GREEN, "["..Total.."]", WHITE, " more CVars\n")
	ReplicatorDone = true
end
concommand.Add("hex_dereplicate", ManualDeReplicate)


local function AlwaysDeReplicate()
	local Total = 0
	
	for k,v in pairs(AlwaysBypass) do
		Total = Total + 1
		MsgDeReplicate( RenameCVar(v) )
	end
	
	COLCON(RED, "Replicator:", WHITE, " Renamed ", GREEN, "["..Total.."]", WHITE, " CVars\n")
end
timer.Simple(0, AlwaysDeReplicate)




