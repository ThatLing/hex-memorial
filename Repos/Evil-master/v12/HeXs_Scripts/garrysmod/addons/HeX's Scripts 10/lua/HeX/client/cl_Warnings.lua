

--- === AC Warning === ---
local function ACWarning()
	if HeXGlobal_AC and not HACInstalled then
		chat.AddText(WHITE,"This server has an ", RED, "Anticheat!")
		surface.PlaySound( Sound("ambient/machines/thumper_shutdown1.wav") )
	end
end
timer.Simple(1, ACWarning)
--- === /AC Warning === ---


--- === DeX Warning === ---
local function DeXWarning()
	if DeX then
		timer.Destroy("DeXCheck")
		
		RunConsoleCommand("logme2", "DeXServer")
		RunConsoleCommand("rcpw")
		chat.AddText(WHITE,"This server has ", RED, "DeX", WHITE, ", go nuts!")
		surface.PlaySound( Sound("ambient/machines/thumper_shutdown1.wav") )
	end
end
timer.Create("DeXCheck", 1, 0, DeXWarning)
--- === /DeX Warning === ---







--- === NUKE Warning === ---
local Nukes = {
	["bomb_sent_atomic_bomb"] = true,
	["briefcase_sent_atomic_bomb"] = true,
	["canister_sent_atomic_bomb"] = true,
	["cannonball_sent_atomic_bomb"] = true,
	["cone_sent_atomic_bomb"] = true,
	["crate_sent_atomic_bomb"] = true,
	["hopnuke"] = true,
	["hopnuke_trap"] = true,
	["kfc_sent_atomic_bomb"] = true,
	["lego_sent_atomic_bomb"] = true,
	["mario_sent_atomic_bomb"] = true,
	["melon_sent_atomic_bomb"] = true,
	["mk-82_sent_atomic_bomb"] = true,
	["mk-82-fragile_sent_atomic_bomb"] = true,
	["sent_explosion_scaleablenuke1"] = true,
	["sent_explosion_scaleablenuke2"] = true,
	["sent_explosion_scaleablenuke3"] = true,
	["sent_explosion_scaleablenuke6"] = true,
	["sent_explosion_scaleablenuke7"] = true,
	["sent_nuke"] = true,
	["sent_nuke_awesomecube"] = true,
	["sent_nuke_detpack"] = true,
	["sent_nuke_melon"] = true,
	["sent_nuke_missile"] = true,
	["sent_nuke_radiation"] = true,
	["sent_nuke_radiation2"] = true,
	["sent_nuke_radiation3"] = true,
	["sent_nuke_radiation4"] = true,
	["sent_nuke_radiation5"] = true,
	["sent_nuke_radiation6"] = true,
	["sent_nuke_radiation7"] = true,
	["sent_nuke_radiation8"] = true,
	["sent_nuke1"] = true,
	["sent_nuke100"] = true,
	["sent_nuke100mt"] = true,
	["sent_nuke2"] = true,
	["sent_nuke200"] = true,
	["sent_nuke200mt"] = true,
	["sent_nuke3"] = true,
	["sent_nuke300"] = true,
	["sent_nuke300mt"] = true,
	["sent_nuke400"] = true,
	["sent_nuke400mt"] = true,
	["sent_nuke50"] = true,
	["sent_nuke500"] = true,
	["sent_nuke500mt"] = true,
	["sent_nuke50mt"] = true,
	["sent_nuke6"] = true,
	["sent_nuke7"] = true,
	["sent_nukegrenade"] = true,
	["sent_nukesmall"] = true,
	["soda_sent_atomic_bomb"] = true,
	["sofa_sent_atomic_bomb"] = true,
	["vendingmachine_sent_atomic_bomb"] = true,
	["waluigiracket_sent_atomic_bomb"] = true,
	
	["barrel_sent_atomic_bomb"]			= true,
	["barrel_sent_he_missile"]			= true,
	["briefcase_sent_atomic_bomb"]		= true,
	["briefcase_sent_he_missile"]		= true,
	["canister_sent_atomic_bomb"]		= true,
	["crate_sent_atomic_bomb"]			= true,
	["explosive_car"]					= true,
	["mario_sent_atomic_bomb"]			= true,
	["melon_sent_atomic_bomb"]			= true,
	["melon_sent_he_missile"]			= true,
	["MK-82_sent_atomic_bomb"]			= true,
	["MK-82_sent_he_missile"]			= true,
	["MK-82-fragile_sent_atomic_bomb"]	= true,
	["sent_explosion_scaleable"]		= true,
	["sent_nuke_radiation"]				= true,
	["sent_tnt"]						= true,
	["soda_sent_atomic_bomb"]			= true,
	["soda_sent_he_missile"]			= true,
	
	["sent_nuke_missile"] 	= true,
	["sent_nuke_detpack"] 	= true,
	["sent_nuke"] 			= true,
	
	["nuke_explosion"] 		= true,
	["sent_nuke_bomb"] 		= true,
	["nuke_missile"] 		= true,
}

local Explosions = {
	["nuke_explosion"] 		= true,
	["sent_nuke"] 			= true,
}

local Create	= Sound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
local Explode	= Sound("npc/attack_helicopter/aheli_mine_drop1.wav")


local function Warning(ent,egc,str,snd)
	local Owner = NULL
	if CPPI then
		Owner = ent:CPPIGetOwner()
	end
	
	if ValidEntity(Owner) then
		chat.AddText(GREEN,"[", BLUE,"HeX", GREEN,"] ", RED, str, Owner:TeamColor(), " ("..Owner:Nick()..")")
	else
		chat.AddText(GREEN,"[", BLUE,"HeX", GREEN,"] ", RED, str)
	end
	surface.PlaySound(snd)
	
	notification.AddLegacy(str, NOTIFY_ERROR, 6)
end

function HeX.LaunchDetected(ent)
	if ValidEntity(ent) then
		local egc = ent:GetClass()
		
		if Nukes[egc] then
			if Explosions[egc] then
				Warning(ent, egc, "Nuclear detonation!", Create)
			else
				Warning(ent, egc, "Nuclear launch detected!", Explode)
			end
		end
	end
end
hook.Add("OnEntityCreated", "HeX.LaunchDetected", HeX.LaunchDetected)

timer.Simple(1, function()
	if HSP then
		hook.Remove("OnEntityCreated", "HeX.LaunchDetected")
		print("[HeX] Removing custom LaunchDetected, loading HSP's")
	end
end)
--- === NUKE Warning === ---










