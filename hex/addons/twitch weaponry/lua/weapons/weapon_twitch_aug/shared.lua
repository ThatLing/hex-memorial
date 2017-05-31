
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_subsnip"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


if ( CLIENT ) then 
	killicon.AddFont ("weapon_twitch_aug", "CSKillIcons", "e", Color (150, 150, 255, 255))
end

function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AUG"

SWEP.Slot					= 1
SWEP.IconLetter				= "e"

SWEP.ViewModel				= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_aug.mdl"
--SWEP.ViewModelAimPos		= Vector (0.6528, -1.8689, 0.5072)
SWEP.ViewModelAimPos		= Vector (2.0924, 2.8887, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_aug.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 31.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.004
SWEP.Primary.Delay			= 0.11

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.25

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_subsnip"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


if ( CLIENT ) then 
	killicon.AddFont ("weapon_twitch_aug", "CSKillIcons", "e", Color (150, 150, 255, 255))
end

function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AUG"

SWEP.Slot					= 1
SWEP.IconLetter				= "e"

SWEP.ViewModel				= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_aug.mdl"
--SWEP.ViewModelAimPos		= Vector (0.6528, -1.8689, 0.5072)
SWEP.ViewModelAimPos		= Vector (2.0924, 2.8887, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_aug.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 31.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.004
SWEP.Primary.Delay			= 0.11

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.25

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
