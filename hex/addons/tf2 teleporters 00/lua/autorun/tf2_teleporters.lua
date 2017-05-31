
----------------------------------------
--         2014-07-12 20:32:51          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("autorun/TF2_Teleporters.lua")
	
	resource.AddFile("materials/vgui/entities/obj_teleporter_exit.vmt")
	resource.AddFile("materials/vgui/entities/obj_teleporter_entrance.vmt")
	
	resource.AddFile("materials/vgui/entities/obj_teleporter_base.vtf")
end



game.AddParticles("particles/teleport_status.pcf")
PrecacheParticleSystem("teleporter_blue_entrance")
PrecacheParticleSystem("teleporter_red_entrance")
PrecacheParticleSystem("teleporter_blue_charged")

game.AddParticles("particles/teleported_fx.pcf")
PrecacheParticleSystem("teleported_blue")

game.AddParticles("particles/buildingdamage.pcf")
PrecacheParticleSystem("tpdamage_1")
PrecacheParticleSystem("tpdamage_2")
PrecacheParticleSystem("tpdamage_3")
PrecacheParticleSystem("tpdamage_4")

game.AddParticles("particles/player_recent_teleport.pcf")
PrecacheParticleSystem("player_recent_teleport_blue")

game.AddParticles("particles/sparks.pcf")
PrecacheParticleSystem("spark_electric01")

game.AddParticles("particles/explosion.pcf")
PrecacheParticleSystem("ExplosionCore_buildings")




















----------------------------------------
--         2014-07-12 20:32:51          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("autorun/TF2_Teleporters.lua")
	
	resource.AddFile("materials/vgui/entities/obj_teleporter_exit.vmt")
	resource.AddFile("materials/vgui/entities/obj_teleporter_entrance.vmt")
	
	resource.AddFile("materials/vgui/entities/obj_teleporter_base.vtf")
end



game.AddParticles("particles/teleport_status.pcf")
PrecacheParticleSystem("teleporter_blue_entrance")
PrecacheParticleSystem("teleporter_red_entrance")
PrecacheParticleSystem("teleporter_blue_charged")

game.AddParticles("particles/teleported_fx.pcf")
PrecacheParticleSystem("teleported_blue")

game.AddParticles("particles/buildingdamage.pcf")
PrecacheParticleSystem("tpdamage_1")
PrecacheParticleSystem("tpdamage_2")
PrecacheParticleSystem("tpdamage_3")
PrecacheParticleSystem("tpdamage_4")

game.AddParticles("particles/player_recent_teleport.pcf")
PrecacheParticleSystem("player_recent_teleport_blue")

game.AddParticles("particles/sparks.pcf")
PrecacheParticleSystem("spark_electric01")

game.AddParticles("particles/explosion.pcf")
PrecacheParticleSystem("ExplosionCore_buildings")



















