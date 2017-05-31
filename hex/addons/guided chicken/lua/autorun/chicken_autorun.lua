
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


if SERVER then
	AddCSLuaFile("autorun/chicken_autorun.lua")
	
	resource.AddFile("materials/particles/feather.vtf") --Particle
	resource.AddFile("materials/particles/feather.vmt")
	
	resource.AddFile("materials/killicons/guided_chicken.vtf") --Killicon
	resource.AddFile("materials/killicons/guided_chicken.vmt")
	
	resource.AddFile("materials/vgui/entities/weapon_chicken.vtf") --Spawnicon
	resource.AddFile("materials/vgui/entities/weapon_chicken.vmt")
	
	
	
	resource.AddFile("materials/models/lduke/chicken/chicken2.vtf") --Materials
	resource.AddFile("materials/models/lduke/chicken/chicken2.vmt")
	
	resource.AddFile("models/lduke/chicken/chicken3.mdl") --Models
	resource.AddFile("models/lduke/chicken/chicken3.phy")
	resource.AddFile("models/lduke/chicken/chicken3.dx80.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.dx90.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.sw.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.vvd")
	
	resource.AddFile("sound/chicken/alert.wav") --Sounds
	resource.AddFile("sound/chicken/attack1.wav")
	resource.AddFile("sound/chicken/attack2.wav")
	resource.AddFile("sound/chicken/death.wav")
	resource.AddFile("sound/chicken/idle1.wav")
	resource.AddFile("sound/chicken/idle2.wav")
	resource.AddFile("sound/chicken/idle3.wav")
	resource.AddFile("sound/chicken/pain1.wav")
	resource.AddFile("sound/chicken/pain2.wav")
	resource.AddFile("sound/chicken/pain3.wav")
	resource.AddFile("sound/chicken/chicken_tube.mp3")
end


if CLIENT then
	local RED = Color(255,80,0,255)
	
	killicon.Add("guided_chicken", "killicons/guided_chicken", RED)
	killicon.Add("weapon_chicken", "killicons/guided_chicken", RED)
	
	language.Add("guided_chicken", "Guided Chicken")
	language.Add("weapon_chicken", "Guided Chicken")
end























----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


if SERVER then
	AddCSLuaFile("autorun/chicken_autorun.lua")
	
	resource.AddFile("materials/particles/feather.vtf") --Particle
	resource.AddFile("materials/particles/feather.vmt")
	
	resource.AddFile("materials/killicons/guided_chicken.vtf") --Killicon
	resource.AddFile("materials/killicons/guided_chicken.vmt")
	
	resource.AddFile("materials/vgui/entities/weapon_chicken.vtf") --Spawnicon
	resource.AddFile("materials/vgui/entities/weapon_chicken.vmt")
	
	
	
	resource.AddFile("materials/models/lduke/chicken/chicken2.vtf") --Materials
	resource.AddFile("materials/models/lduke/chicken/chicken2.vmt")
	
	resource.AddFile("models/lduke/chicken/chicken3.mdl") --Models
	resource.AddFile("models/lduke/chicken/chicken3.phy")
	resource.AddFile("models/lduke/chicken/chicken3.dx80.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.dx90.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.sw.vtx")
	resource.AddFile("models/lduke/chicken/chicken3.vvd")
	
	resource.AddFile("sound/chicken/alert.wav") --Sounds
	resource.AddFile("sound/chicken/attack1.wav")
	resource.AddFile("sound/chicken/attack2.wav")
	resource.AddFile("sound/chicken/death.wav")
	resource.AddFile("sound/chicken/idle1.wav")
	resource.AddFile("sound/chicken/idle2.wav")
	resource.AddFile("sound/chicken/idle3.wav")
	resource.AddFile("sound/chicken/pain1.wav")
	resource.AddFile("sound/chicken/pain2.wav")
	resource.AddFile("sound/chicken/pain3.wav")
	resource.AddFile("sound/chicken/chicken_tube.mp3")
end


if CLIENT then
	local RED = Color(255,80,0,255)
	
	killicon.Add("guided_chicken", "killicons/guided_chicken", RED)
	killicon.Add("weapon_chicken", "killicons/guided_chicken", RED)
	
	language.Add("guided_chicken", "Guided Chicken")
	language.Add("weapon_chicken", "Guided Chicken")
end






















