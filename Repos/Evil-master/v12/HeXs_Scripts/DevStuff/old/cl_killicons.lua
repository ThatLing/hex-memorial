killicons_color = Color( 255, 80, 0, 255 )

local function AddKillicon(class, material)
	killicon.Add(class,material,killicons_color)
end

-- Source entities

killicon.Add( "ent_mad_c4", "vgui/entities/weapon_mad_c4", Color( 255, 255, 255, 255 ) )

killicon.AddFont( "npc_tripmine", "HL2MPTypeDeath", "*", Color( 255, 80, 0, 255 ) )
killicon.AddFont( "npc_satchel", "HL2MPTypeDeath", "*", Color( 255, 80, 0, 255 ) )

killicon.AddFont( "weapon_bulletnade", "HL2MPTypeDeath", "5", Color( 255, 80, 0, 255 ) )
killicon.AddFont( "bullet_grenade", "HL2MPTypeDeath", "5", Color( 255, 80, 0, 255 ) )

killicon.AddFont( "boomstick", "HL2MPTypeDeath", "0", Color( 15, 20, 200, 255 ) )




--my end only
--killicon.Add( "weapon_sniper", "vgui/entities/weapon_sniper", Color( 255, 255, 255, 255 ) )

killicon.AddFont("weapon_sniper","CSKillIcons","r",Color( 15, 20, 200, 255 ))


AddKillicon("env_fire","killicons/env_fire_killicon")
AddKillicon("entityflame","killicons/env_fire_killicon")

AddKillicon("worldspawn","killicons/worldspawn_killicon")

AddKillicon("env_explosion","killicons/env_explosion_killicon")
AddKillicon("env_physexplosion","killicons/env_explosion_killicon")

AddKillicon("env_laser","killicons/env_laser_killicon")
AddKillicon("env_beam","killicons/env_laser_killicon")

AddKillicon("combine_mine","killicons/combine_mine_killicon")
--AddKillicon("npc_antlion","killicons/npc_antlion_killicon")
--AddKillicon("npc_antlionguard","killicons/npc_antlionguard_killicon")
--AddKillicon("npc_manhack","killicons/npc_manhack_killicon")
--AddKillicon("npc_rollermine","killicons/npc_rollermine_killicon")
--AddKillicon("npc_barnacle","killicons/npc_barnacle_killicon")
--AddKillicon("npc_strider","killicons/npc_strider_gun_killicon")
AddKillicon("concussiveblast","killicons/npc_strider_cannon_killicon")

AddKillicon("func_physbox","killicons/func_physbox_killicon")
AddKillicon("func_physbox_multiplayer","killicons/func_physbox_killicon")

--AddKillicon("prop_ragdoll","killicons/prop_ragdoll_killicon")

AddKillicon("point_hurt","killicons/point_hurt_killicon")
AddKillicon("trigger_hurt","killicons/point_hurt_killicon")

AddKillicon("func_door","killicons/func_door_killicon")
AddKillicon("func_door_rotating","killicons/func_door_killicon")
AddKillicon("prop_door_rotating","killicons/func_door_killicon")

AddKillicon("env_headcrabcanister","killicons/env_headcrabcanister_killicon")

-- GMod 2007
AddKillicon("npc_antlion_worker","killicons/npc_antlion_killicon")
AddKillicon("grenade_spit","killicons/grenade_spit_killicon")
AddKillicon("hunter_flechette","killicons/hunter_flechette_killicon")
AddKillicon("weapon_striderbuster","killicons/weapon_striderbuster_killicon")

-- Nuke
AddKillicon("sent_nuke","killicons/sent_nuke_killicon")
AddKillicon("sent_nuke_radiation","killicons/sent_nuke_killicon")

-- _Kilburn's SWEPs
AddKillicon("weapon_weldball","killicons/weldball_killicon")
AddKillicon("npc_weldball_proj","killicons/weldball_killicon")
AddKillicon("npc_weldball_proj_dead","killicons/weldball_killicon")
AddKillicon("weapon_spazzernade","killicons/spazzernade_killicon")
AddKillicon("npc_spazzenade_proj","killicons/spazzernade_killicon")

usermessage.Hook( "PlayerKilled", function ( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
	
	if (attacker == "#combine_mine") then inflictor = "combine_mine" end
	
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end )

usermessage.Hook( "NPCKilledNPC", function ( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local tmp = message:ReadString();
	local attacker 	= "#" .. tmp;
	
	if (tmp == "combine_mine"         or
		tmp == "npc_antlion"          or
		tmp == "npc_antlionguard"     or
		tmp == "npc_barnacle"     or
	   (tmp == "npc_antlion_worker" and inflictor ~= "grenade_spit") or
	   (tmp == "npc_hunter" and inflictor ~= "hunter_flechette") or
	   (tmp == "npc_strider" and inflictor ~= "concussiveblast") or
		tmp == "npc_rollermine"       or
		tmp == "weapon_striderbuster" or
		tmp == "npc_manhack") then inflictor = tmp
	end
	
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1 )

end )