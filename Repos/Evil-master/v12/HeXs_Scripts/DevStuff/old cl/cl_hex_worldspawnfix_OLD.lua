

if ( CLIENT ) then 

local killicons_color = Color( 255, 80, 0, 255 )

	local function AddKillicon(class, material)
		killicon.Add(class,material,killicons_color)
	end


--gmod turret
--killicon.AddFont( "gmod_turret", "HL2MPTypeDeath", "/", Color( 255, 80, 0, 255 ) ) --red
--killicon.AddFont( "gmod_turret", "HL2MPTypeDeath", "/", Color( 255, 174, 0, 255 ) ) --orange
killicon.AddFont( "gmod_turret", "HL2MPTypeDeath", "/", Color( 192, 0, 192, 255 ) ) --purple


--gmod thruster
--AddKillicon("gmod_thruster","killicons/worldspawn_killicon")

	
--from cl_killicons
AddKillicon("env_laser","killicons/env_laser_killicon")
AddKillicon("env_beam","killicons/env_laser_killicon")
AddKillicon("combine_mine","killicons/combine_mine_killicon")
AddKillicon("concussiveblast","killicons/npc_strider_cannon_killicon")
AddKillicon("func_physbox","killicons/func_physbox_killicon")
AddKillicon("func_physbox_multiplayer","killicons/func_physbox_killicon")
AddKillicon("func_door","killicons/func_door_killicon")
AddKillicon("func_door_rotating","killicons/func_door_killicon")
AddKillicon("prop_door_rotating","killicons/func_door_killicon")
AddKillicon("env_headcrabcanister","killicons/env_headcrabcanister_killicon")
AddKillicon("npc_antlion_worker","killicons/npc_antlion_killicon")
AddKillicon("weapon_striderbuster","killicons/weapon_striderbuster_killicon")
AddKillicon("sent_nuke","killicons/sent_nuke_killicon")
AddKillicon("sent_nuke_radiation","killicons/sent_nuke_killicon")







	
--fire
AddKillicon("env_fire","killicons/env_fire_killicon")
AddKillicon("entityflame","killicons/env_fire_killicon")

--floor
AddKillicon("worldspawn","killicons/worldspawn_killicon")

--boom
AddKillicon("env_explosion","killicons/env_explosion_killicon")
AddKillicon("env_physexplosion","killicons/env_explosion_killicon")

--doors
AddKillicon("func_door","killicons/func_door_killicon")
AddKillicon("func_door_rotating","killicons/func_door_killicon")
AddKillicon("prop_door_rotating","killicons/func_door_killicon")

--gravestone
AddKillicon("gravestone","killicons/gravestone_killicon")
AddKillicon("player","killicons/gravestone_killicon")

--suicide
AddKillicon("suicide","killicons/suicide_killicon")

--acid
killicon.Add( "grenade_spit", "killicons/grenade_spit_killicon", Color( 0, 255, 0, 255 ) ) --green
killicon.Add( "weapon_acidshotgun", "killicons/grenade_spit_killicon", Color( 0, 255, 0, 255 ) ) --green
killicon.Add( "AcidGrenade", "killicons/grenade_spit_killicon", Color( 0, 255, 0, 255 ) ) --green

--others
killicon.Add( "ent_mad_c4", "vgui/entities/weapon_mad_c4", Color( 255, 255, 255, 255 ) ) --white
killicon.Add( "hunter_flechette", "killicons/hunter_flechette_killicon", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont("weapon_sniper","CSKillIcons","r", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont("suicide_deagle", "CSKillIcons", "f", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont("weapon_stridercannon", "HL2MPTypeDeath", "3", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont("flechette_awp","CSKillIcons","r",Color( 0, 255, 0, 255 ) ) --green



--bulletnade
killicon.AddFont( "weapon_bulletnade", "HL2MPTypeDeath", "5", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont( "bullet_grenade", "HL2MPTypeDeath", "5", Color( 0, 255, 0, 255 ) ) --green

--tripmines
killicon.AddFont( "npc_tripmine", "HL2MPTypeDeath", "*", Color( 255, 80, 0, 255 ) )
killicon.AddFont( "npc_satchel", "HL2MPTypeDeath", "*", Color( 255, 80, 0, 255 ) )

--KH
killicon.AddFont( "boomstick", "HL2MPTypeDeath", "0", Color( 0, 255, 0, 255 ) ) --green
killicon.AddFont( "kh_smg", "HL2MPTypeDeath", "/", Color( 0, 255, 0, 255 ) ) --green


--[[
not needed

killicon.AddFont( "npc_grenade_frag", "CSKillIcons", "p", Color( 255, 80, 0, 255 ) )
--killicon.AddFont( "BOOMSTICK", "HL2MPTypeDeath", "0", Color( 15, 20, 200, 255 ) )
--Color( 15, 20, 200, 255 ) --boomstick blue

]]

--[[
--new 357
language.Add( "HL2_357Handgun", ".357 Magnum" )
language.Add( "#HL2_357Handgun", ".357 Magnum" )
language.Add( "weapon_357", ".357 Magnum" )
]]

language.Add( "cycler_actor", "NPC" )
language.Add( "point_hurt", "NPC" )

language.Add( "npc_antlion_worker", "AcidLiON" )
language.Add( "grenade_spit", "Acid Spit" )
language.Add( "hunter_flechette", "Flechettes" )
language.Add( "item_item_crate", "Item Crate" )


language.Add( "entityflame", "Fire" )
language.Add( "env_explosion", "Kaboom" )
language.Add( "env_physexplosion", "Kaboom" )
language.Add( "env_fire", "Fire" )
language.Add( "env_laser", "Laz0r" )
language.Add( "env_beam", "Laz0r" )
language.Add( "func_door", "The Door" )
language.Add( "func_door_rotating", "The Door" )
language.Add( "prop_door_rotating", "The Door" )
language.Add( "func_tracktrain", "Railway" )
language.Add( "gmod_balloon", "Balloon" )
language.Add( "gmod_spawner", "Prop Spawner" )
language.Add( "gmod_thruster", "Thruster" )
--language.Add( "gmod_thruster_old", "Thruster" )
language.Add( "gmod_turret", "GMod Turret" )
language.Add( "item_healthvial", "Health Vial" )
language.Add( "npc_bullseye", "Fort Door" )
language.Add( "npc_clawscanner", "Claw Scanner" )
language.Add( "npc_grenade_frag", "Frag Grenade" )
language.Add( "npc_helicopter", "Combine Choppa" )
language.Add( "phys_magnet", "Magnet" )
language.Add( "prop_combine_ball", "Combine Energy Ball" )
language.Add( "prop_physics_multiplayer", "Multiplayer Physics Prop" )
language.Add( "prop_ragdoll_attached", "Ragdoll" )
language.Add( "prop_vehicle_apc", "Combine APC" )
language.Add( "prop_vehicle_jeep", "Jeep" )
language.Add( "prop_vehicle_pod", "Seat" )
language.Add( "trigger_hurt", "The Map" )
language.Add( "weapon_striderbuster", "Magnusson Device" )
language.Add( "World", "Gravity" )
language.Add( "worldspawn", "Gravity" )

language.Add( "func_physbox", "Physbox" )
language.Add( "func_physbox_multiplayer", "Physbox" )

end


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
