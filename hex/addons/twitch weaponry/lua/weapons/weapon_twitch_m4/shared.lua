
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

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

SWEP.PrintName				= "Twitch M4A1"

SWEP.Slot					= 2
SWEP.IconLetter				= "w"

SWEP.ViewModel				= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelAimPos		= Vector (4.9601, -0.8142, 0.206)
SWEP.ViewModelAimAng		= Vector (2.9663, 1.616, 3.3092)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M4A1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.026
SWEP.Primary.ConeZoomed		= 0.0035
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 31
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_m4", "CSKillIcons", "w", Color (150, 150, 255, 255)) end


----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

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

SWEP.PrintName				= "Twitch M4A1"

SWEP.Slot					= 2
SWEP.IconLetter				= "w"

SWEP.ViewModel				= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelAimPos		= Vector (4.9601, -0.8142, 0.206)
SWEP.ViewModelAimAng		= Vector (2.9663, 1.616, 3.3092)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M4A1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 27
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.026
SWEP.Primary.ConeZoomed		= 0.0035
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 31
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_m4", "CSKillIcons", "w", Color (150, 150, 255, 255)) end

