
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_sniper"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "crossbow"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("crossbow")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch Scout"

SWEP.Slot					= 1
SWEP.IconLetter				= "n"

SWEP.ViewModel				= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_scout.mdl"
--SWEP.ViewModelAimPos		= Vector (0.517, -0.914, 0.8888)
SWEP.ViewModelAimPos		= Vector (1.809, -1.2016, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_scout.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 65
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ConeZoomed		= 0.005
SWEP.Primary.Delay			= 0.7
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_scout", "CSKillIcons", "n", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_sniper"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "crossbow"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("crossbow")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch Scout"

SWEP.Slot					= 1
SWEP.IconLetter				= "n"

SWEP.ViewModel				= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_scout.mdl"
--SWEP.ViewModelAimPos		= Vector (0.517, -0.914, 0.8888)
SWEP.ViewModelAimPos		= Vector (1.809, -1.2016, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_scout.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 65
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ConeZoomed		= 0.005
SWEP.Primary.Delay			= 0.7
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_scout", "CSKillIcons", "n", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
