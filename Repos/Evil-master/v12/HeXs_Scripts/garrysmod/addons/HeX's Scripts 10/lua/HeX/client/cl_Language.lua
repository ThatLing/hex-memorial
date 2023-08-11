


local function AddKillicon(class, material)
	killicon.Add(class,material,KIRED)
end

timer.Simple(0.3, function()
	killicon.AddFont("prop_physics", "HL2MPTypeDeath", ",", KIRED)
	killicon.AddFont("prop_physics_multiplayer", "HL2MPTypeDeath", ",", KIRED)
	killicon.AddFont("prop_physics_override", "HL2MPTypeDeath", ",", KIRED)
	
	killicon.AddFont("weapon_deagle", "CSKillIcons", "f", KIRED)
	killicon.AddFont("weapon_m4", "CSKillIcons", "w", KIRED)
end)


//NPCs

//Combine robots
killicon.Add("npc_rollermine", "HUD/killicons/npc_rollermine", color_white) --Done
killicon.Add("npc_manhack", "HUD/killicons/npc_manhack", color_white) --Done
killicon.Add("npc_cscanner", "HUD/killicons/npc_cscanner", color_white) --Done

//Headcrabs
killicon.Add("npc_headcrab", "HUD/killicons/npc_headcrab", color_white) --Done
killicon.Add("npc_headcrab_fast", "HUD/killicons/npc_headcrab_fast", color_white) --Done

//Zombies
killicon.Add("npc_zombie", "HUD/killicons/npc_zombie", color_white) --Done
killicon.Add("npc_zombie_torso", "HUD/killicons/npc_zombie_torso", color_white) --Done
killicon.Add("npc_fastzombie", "HUD/killicons/npc_fastzombie", color_white) --Done
killicon.Add("npc_poisonzombie", "HUD/killicons/npc_poisonzombie", color_white) --Done

//Antlions
killicon.Add("npc_antlion", "HUD/killicons/npc_antlion", color_white) --Done
killicon.Add("npc_antlionguard", "HUD/killicons/npc_antlionguard", color_white)  --Done
 
//Others
killicon.Add("npc_barnacle", "HUD/killicons/npc_barnacle", color_white) --Done
killicon.Add("npc_vortigaunt", "HUD/killicons/npc_vortigaunt", color_white) --Unused

//Non-Default NPCs
killicon.Add("npc_strider", "HUD/killicons/npc_strider", color_white) --Done
killicon.Add("npc_helicopter", "HUD/killicons/npc_helicopter", color_white) --Unused
killicon.Add("npc_combinegunship", "HUD/killicons/npc_combinegunship", color_white) --Done
killicon.Add("npc_turret_floor", "HUD/killicons/npc_turret_floor", color_white) --Done
killicon.Add("npc_stalker", "HUD/killicons/npc_stalker", color_white) --Unused
--killicon.Add("combine_mine", "HUD/killicons/combine_mine", color_white) --Unused

//Not NPCs

//Weapons
killicon.Add("weapon_alyxgun", "HUD/killicons/weapon_alyxgun", color_white) --Done
killicon.Add("weapon_annabelle", "HUD/killicons/weapon_annabelle", color_white) --Squashed
killicon.Add("weapon_citizenpackage", "HUD/killicons/weapon_citizenpackage", color_white) --Done
killicon.Add("weapon_citizensuitcase", "HUD/killicons/weapon_citizensuitcase", color_white)--Done

//Props
killicon.Add("prop_ragdoll", "HUD/killicons/prop_ragdoll", color_white) --Done

//Damaging
--killicon.Add("env_explosion", "HUD/killicons/env_explosion", color_white) --Done
killicon.Add("gmod_dynamite", "HUD/killicons/env_explosion" , color_white) --Dynamite
--killicon.Add("entityflame", "HUD/killicons/entityflame", color_white) --Done

//Vehicles
killicon.Add("prop_vehicle_jeep", "HUD/killicons/prop_vehicle_jeep", color_white) --Done
killicon.Add("prop_vehicle_airboat", "HUD/killicons/prop_vehicle_airboat", color_white) --Done
killicon.Add("prop_vehicle_prisoner_pod", "HUD/killicons/prop_vehicle_prisoner_pod", color_white) --Small


killicon.AddFont("trigger_hurt", "HL2MPTypeDeath", "5", KIRED)

--gravgun killicon
killicon.AddFont("weapon_physcannon", "HL2MPTypeDeath", ",", KIRED)
killicon.AddFont("func_physbox", "HL2MPTypeDeath", ",", KIRED)
killicon.AddFont("func_physbox_multiplayer", "HL2MPTypeDeath", ",", KIRED)


killicon.AddFont("gmod_turret", "HL2MPTypeDeath", "/", Color(192, 0, 192, 255)) --purple

--acid
killicon.Add("grenade_spit", "killicons/grenade_spit_killicon", GREEN2) --green
killicon.Add("AcidGrenade", "killicons/grenade_spit_killicon", GREEN2) --green


--fire
AddKillicon("env_fire","killicons/env_fire_killicon")
AddKillicon("entityflame","killicons/env_fire_killicon")

--floor
AddKillicon("worldspawn","killicons/worldspawn_killicon")
AddKillicon("World","killicons/worldspawn_killicon")

--boom
AddKillicon("env_explosion","killicons/env_explosion_killicon")
AddKillicon("env_physexplosion","killicons/env_explosion_killicon")

--doors
AddKillicon("func_door","killicons/func_door_killicon")
AddKillicon("func_door_rotating","killicons/func_door_killicon")
AddKillicon("prop_door_rotating","killicons/func_door_killicon")
AddKillicon("func_rotating","killicons/func_door_killicon")
AddKillicon("func_rotate","killicons/func_door_killicon")

--gravestone
AddKillicon("gravestone","killicons/gravestone_killicon")
AddKillicon("player","killicons/gravestone_killicon")

--suicide
AddKillicon("suicide","killicons/suicide_killicon")


--weapons
killicon.Add("ent_mad_c4", "vgui/entities/weapon_mad_c4", color_white) --white
killicon.Add("hunter_flechette", "killicons/hunter_flechette_killicon", GREEN2) --green
killicon.AddFont("weapon_sniper","CSKillIcons","r", GREEN2) --green
killicon.AddFont("suicide_deagle", "CSKillIcons", "f", GREEN2) --green
killicon.AddFont("weapon_stridercannon", "HL2MPTypeDeath", "3", GREEN2) --green
killicon.AddFont("flechette_awp","CSKillIcons","r",GREEN2) --green
killicon.Add("weapon_acidshotgun", "killicons/grenade_spit_killicon", GREEN2) --green
killicon.AddFont("weapon_bulletnade", "HL2MPTypeDeath", "5", GREEN2) --green
killicon.AddFont("bullet_grenade", "HL2MPTypeDeath", "5", GREEN2) --green
--KH
killicon.AddFont("boomstick", "HL2MPTypeDeath", "0", GREEN2) --green
killicon.AddFont("kh_smg", "HL2MPTypeDeath", "/", GREEN2) --green
killicon.AddFont("plasma_rifle", "HL2MPTypeDeath", "2", GREEN2) --green
killicon.AddFont("sent_plasma", "HL2MPTypeDeath", "8", GREEN2) --green
--tripmines
killicon.AddFont("npc_tripmine", "HL2MPTypeDeath", "*", KIRED)
killicon.AddFont("npc_satchel", "HL2MPTypeDeath", "*", KIRED)


	
language.Add("trigger_hurt", "God")
language.Add("World", "Gravity")
language.Add("worldspawn", "Gravity")

language.Add("plasma_rifle", "Plasma Rifle")
language.Add("sent_plasma", "Plasma Bomb")

language.Add("cycler_actor", "NPC")
language.Add("point_hurt", "NPC")
language.Add("npc_antlion_worker", "AcidLiON")
language.Add("grenade_spit", "Acid Spit")
language.Add("hunter_flechette", "Flechettes")
language.Add("item_item_crate", "Item Crate")
language.Add("env_explosion", "Dat Blast")
language.Add("env_physexplosion", "Dat Blast")
language.Add("entityflame", "Fire")
language.Add("env_fire", "Fire")
language.Add("env_laser", "Laz0r")
language.Add("env_beam", "Laz0r")
language.Add("func_door", "The Door")
language.Add("func_door_rotating", "The Door")
language.Add("prop_door_rotating", "The Door")
language.Add("func_rotating", "The Door")
language.Add("func_rotate", "The Door")
language.Add("func_tracktrain", "Fuckin' Railway")
language.Add("gmod_balloon", "Fuckin' Balloon")
language.Add("gmod_spawner", "Prop Spawner")
language.Add("gmod_thruster", "Rocket Engine")
language.Add("gmod_turret", "GMod Gun Turret")
language.Add("item_healthvial", "Health Vial (?!)")
language.Add("npc_bullseye", "Some Kinda Trigger")
language.Add("npc_clawscanner", "Claw Scanner")
language.Add("npc_grenade_frag", "Frag Grenade")
language.Add("npc_helicopter", "Combine Choppa")
language.Add("phys_magnet", "Fuckin' Magnet")
language.Add("prop_combine_ball", "Combine Energy Ball")
language.Add("prop_physics_multiplayer", "Multiplayer Physics Prop")
language.Add("prop_ragdoll_attached", "Ragdoll")
language.Add("prop_vehicle_apc", "Combine APC")
language.Add("prop_vehicle_jeep", "Jeep")
language.Add("prop_vehicle_pod", "The Chair")
language.Add("prop_vehicle_prisoner_pod", "The Chair")
language.Add("weapon_striderbuster", "Magnusson Device")
language.Add("func_physbox", "Physbox")
language.Add("func_physbox_multiplayer", "Physbox")






