

if not replicator then
	COLCON(RED, "Bypass", WHITE, ": Error 404, replicator not found!")
	COLCON(RED, "Bypass", WHITE, ": Loading old version..")
	
	include("custom_menu/old/ml_H_DeReplicate_cvar2.lua")
	return
end



local Prefix = "hex_"

local AlwaysBypass = {
	["r_drawparticles"]			 = {"1", FCVAR_CLIENTDLL | FCVAR_CHEAT, "Enable/disable particle rendering"},
	["r_drawothermodels"] 		 = {"1", FCVAR_CLIENTDLL | FCVAR_CHEAT, "0=Off, 1=Normal, 2=Wireframe"},
	["vcollide_wireframe"] 		 = {"0", FCVAR_CLIENTDLL | FCVAR_CHEAT, "Render physics collision models in wireframe"},
	["fog_override"] 			 = {"0", FCVAR_CLIENTDLL | FCVAR_CHEAT},
	["showtriggers"] 			 = {"0", FCVAR_GAMEDLL | FCVAR_CHEAT},
	["mat_fullbright"]			 = {"0", FCVAR_CHEAT},
	["mat_wireframe"]			 = {"0", FCVAR_CHEAT},
	["snd_show"]				 = {"0", FCVAR_CHEAT, "Show sounds info"},
}

local NowBypass = {
	["sv_cheats"]				 = {"0", FCVAR_NOTIFY | FCVAR_REPLICATED | FCVAR_CHEAT, "Allow cheats on server"},
	["host_timescale"]			 = {"1.0", FCVAR_NOTIFY | FCVAR_REPLICATED | FCVAR_CHEAT, "Prescale the clock by this ammount."},
}



local function RenameCVar(cvar,tab)
	local NewName = Prefix..cvar
	
	if ( ConVarExists(cvar) and not ConVarExists(NewName) ) then
		local Value = tab[1]
		local Flags = tab[2]
		local Help	= tab[3] or false
		
		local Done = replicator.Replicate(cvar, NewName, Flags, Value)
		
		if not Done then
			COLCON(RED, "Bypass", WHITE, ": ! FUCKUP, replicator error")
			return
		end
		
		if Help then
			CreateConVar(cvar, Value, Flags, Help)
		else
			CreateConVar(cvar, Value, Flags)
		end
		
		return NewName
	end
end



local function MsgDeReplicate(cvar,newname)
	COLCON(RED, "Bypass:", WHITE, " Renamed ", BROWN, cvar, WHITE, " to ", GREEN, newname)
end

local function ManualDeReplicate(ply,cmd,args)
	if (#args > 0) then
		local name = args[1]
		local CVar = GetConVar(name):GetDefault()
		
		local Tab = {
			CVar:GetDefault(),
			replicator.GetFlags(name),
			CVar:GetHelpText(),
		}
		
		MsgDeReplicate(name, RenameCVar(name,Tab) )
		return
	end
	
	local Total = 0
	for CVar,Tab in pairs(NowBypass) do
		local NewName = RenameCVar(CVar,Tab)
		
		Total = Total + 1
		MsgDeReplicate(CVar,NewName)
	end
	COLCON(RED, "Bypass", WHITE, ": Renamed ", GREEN, "["..Total.."]", WHITE, " more CVars\n")
end
concommand.Add("hex_dereplicate", ManualDeReplicate)


local function AlwaysDeReplicate()
	local Total = 0
	
	for CVar,Tab in pairs(AlwaysBypass) do
		local NewName = RenameCVar(CVar,Tab)
		
		Total = Total + 1
		MsgDeReplicate(CVar,NewName)
	end
	
	COLCON(RED, "Bypass:", WHITE, " Renamed ", GREEN, "["..Total.."]", WHITE, " CVars\n")
end
timer.Simple(0, AlwaysDeReplicate)




