

if not replicator then
	require("replicator")
end
if not replicator then
	COLCON(RED, "Replicator2", WHITE, ": Error 404, replicator not found!")
	return
end



CVar_Prefix = "hex_"

local AlwaysBypass = {
	--moved
}

local NowBypass = {
	"vcollide_wireframe",
	"fog_override",
	"showtriggers",
	"snd_show",
	
	"sv_cheats",
	"host_timescale",
	"host_framerate",
	
	"r_drawparticles",
	"r_drawothermodels",
	"mat_fullbright",
	"mat_wireframe",
}




function RenameCVar(OldName)
	local NewName = CVar_Prefix..OldName
	
	if ( ConVarExists(OldName) and not ConVarExists(NewName) ) then
		local Old	= GetConVar(OldName)
		
		local Default 	= Old:GetDefault()
		local Flags 	= Old:GetFlags()
		local Help		= Old:GetHelpText() or false
		local Value		= Old:GetString()
		
		Old:SetName(NewName)
		Old:SetFlags(FCVAR_NONE)
		
		local New = nil
		if Help then
			New = CreateConVar(OldName, Default, Flags, Help)
		else
			New = CreateConVar(OldName, Default, Flags)
		end
		
		New:SetValue(Value)
	end
	
	return OldName, NewName
end



local function MsgDeReplicate(cvar,newname)
	COLCON(RED, "Replicator: ", BROWN, cvar, WHITE, " -> ", GREEN, newname)
end

local function ManualDeReplicate(ply,cmd,args)
	if (#args > 0) then
		local name = args[1]
		
		MsgDeReplicate( RenameCVar(name) ) --So easy!
		return
	end
	
	if ReplicatorDone then
		COLCON(RED, "Replicator", WHITE, ": Already used ManualDeReplicate!")
		return
	end
	ReplicatorDone = true
	
	local Total = 0
	for k,v in pairs(NowBypass) do
		Total = Total + 1
		MsgDeReplicate( RenameCVar(v) )
	end
	
	COLCON(RED, "Replicator", WHITE, ": Renamed ", GREEN, "["..Total.."]", WHITE, " more CVars\n")
end
concommand.Add("hex_dereplicate", ManualDeReplicate)


local function AlwaysDeReplicate()
	local Total = 0
	
	for k,v in pairs(AlwaysBypass) do
		Total = Total + 1
		MsgDeReplicate( RenameCVar(v) )
	end
	
	if (Total > 0) then
		COLCON(RED, "Replicator:", WHITE, " Renamed ", GREEN, "["..Total.."]", WHITE, " CVars\n")
	end
end
timer.Simple(0, AlwaysDeReplicate)




