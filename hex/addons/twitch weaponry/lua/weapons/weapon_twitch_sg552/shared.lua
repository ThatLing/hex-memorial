
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_subsnip"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch SG552"

SWEP.Slot					= 1
SWEP.IconLetter				= "n"

SWEP.ViewModel				= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_sg552.mdl"
--SWEP.ViewModelAimPos		= Vector (2.3078, -4.5494, 2.828)
SWEP.ViewModelAimPos		= Vector (2.3122, -1.2382, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_sg552.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 26
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0178
SWEP.Primary.ConeZoomed		= 0.0048
SWEP.Primary.Delay			= 0.085

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_sg552", "CSKillIcons", "n", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_subsnip"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch SG552"

SWEP.Slot					= 1
SWEP.IconLetter				= "n"

SWEP.ViewModel				= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_sg552.mdl"
--SWEP.ViewModelAimPos		= Vector (2.3078, -4.5494, 2.828)
SWEP.ViewModelAimPos		= Vector (2.3122, -1.2382, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_sg552.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 26
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0178
SWEP.Primary.ConeZoomed		= 0.0048
SWEP.Primary.Delay			= 0.085

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_sg552", "CSKillIcons", "n", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
