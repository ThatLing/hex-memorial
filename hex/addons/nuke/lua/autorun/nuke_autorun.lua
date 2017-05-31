
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------


if (SERVER) then
	AddCSLuaFile("autorun/nuke_autorun.lua")
	
	CreateConVar("nuke_yield", 25, false)
	CreateConVar("nuke_waveresolution", 0.2, false)
	CreateConVar("nuke_ignoreragdoll", 1, false)
	CreateConVar("nuke_breakconstraints", 1, false)
	CreateConVar("nuke_disintegration", 1, false)
	CreateConVar("nuke_damage", 100, false)
	CreateConVar("nuke_epic_blastwave", 1, false)
	CreateConVar("nuke_radiation_duration", 66, false) --100
	CreateConVar("nuke_radiation_damage", 66, false)
	
	resource.AddFile("materials/refract_ring.vtf") --Nuke
	resource.AddFile("materials/refract_ring.vmt")
	
	resource.AddFile("materials/killicons/sent_nuke_killicon.vtf") --Killicon
	resource.AddFile("materials/killicons/sent_nuke_killicon.vmt")
	
	resource.AddFile("models/player/charple01.dx80.vtx")
	resource.AddFile("models/player/charple01.dx90.vtx")
	resource.AddFile("models/player/charple01.mdl")
	resource.AddFile("models/player/charple01.phy")
	resource.AddFile("models/player/charple01.sw.vtx")
	resource.AddFile("models/player/charple01.vvd")
end


if (CLIENT) then
	local RED = Color(255,80,0,255)
	killicon.Add("nuke_missile","killicons/sent_nuke_killicon",RED)
	killicon.Add("nuke_explosion","killicons/sent_nuke_killicon",RED)
	killicon.Add("nuke_radiation","killicons/sent_nuke_killicon",RED)
	killicon.Add("weapon_nuke","killicons/sent_nuke_killicon",RED)
	
	language.Add("AlyxGun_ammo", "Nuclear missile")
	language.Add("weapon_nuke", "Nuclear missile")
	
	language.Add("nuke_missile", "Nuclear missile")
	language.Add("nuke_explosion", "Atomic bomb")
	language.Add("nuke_radiation", "Atomic bomb")
end



----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------


if (SERVER) then
	AddCSLuaFile("autorun/nuke_autorun.lua")
	
	CreateConVar("nuke_yield", 25, false)
	CreateConVar("nuke_waveresolution", 0.2, false)
	CreateConVar("nuke_ignoreragdoll", 1, false)
	CreateConVar("nuke_breakconstraints", 1, false)
	CreateConVar("nuke_disintegration", 1, false)
	CreateConVar("nuke_damage", 100, false)
	CreateConVar("nuke_epic_blastwave", 1, false)
	CreateConVar("nuke_radiation_duration", 66, false) --100
	CreateConVar("nuke_radiation_damage", 66, false)
	
	resource.AddFile("materials/refract_ring.vtf") --Nuke
	resource.AddFile("materials/refract_ring.vmt")
	
	resource.AddFile("materials/killicons/sent_nuke_killicon.vtf") --Killicon
	resource.AddFile("materials/killicons/sent_nuke_killicon.vmt")
	
	resource.AddFile("models/player/charple01.dx80.vtx")
	resource.AddFile("models/player/charple01.dx90.vtx")
	resource.AddFile("models/player/charple01.mdl")
	resource.AddFile("models/player/charple01.phy")
	resource.AddFile("models/player/charple01.sw.vtx")
	resource.AddFile("models/player/charple01.vvd")
end


if (CLIENT) then
	local RED = Color(255,80,0,255)
	killicon.Add("nuke_missile","killicons/sent_nuke_killicon",RED)
	killicon.Add("nuke_explosion","killicons/sent_nuke_killicon",RED)
	killicon.Add("nuke_radiation","killicons/sent_nuke_killicon",RED)
	killicon.Add("weapon_nuke","killicons/sent_nuke_killicon",RED)
	
	language.Add("AlyxGun_ammo", "Nuclear missile")
	language.Add("weapon_nuke", "Nuclear missile")
	
	language.Add("nuke_missile", "Nuclear missile")
	language.Add("nuke_explosion", "Atomic bomb")
	language.Add("nuke_radiation", "Atomic bomb")
end


