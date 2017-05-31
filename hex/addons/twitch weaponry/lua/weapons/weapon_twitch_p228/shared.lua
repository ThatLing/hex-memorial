
----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "pistol"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("pistol")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch P228"

SWEP.Slot					= 1
SWEP.IconLetter				= "y"

SWEP.ViewModel				= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.1195, 0, 2.2197)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_P228.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/p228/p228-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.019
SWEP.Primary.ConeZoomed		= 0.009
SWEP.Primary.Delay			= 0.14

SWEP.Primary.ClipSize		= 13
SWEP.Primary.DefaultClip	= 144
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_p228", "CSKillIcons", "a", Color (150, 150, 255, 255)) end


----------------------------------------
--         2014-07-12 20:33:15          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "pistol"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("pistol")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch P228"

SWEP.Slot					= 1
SWEP.IconLetter				= "y"

SWEP.ViewModel				= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.1195, 0, 2.2197)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_P228.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/p228/p228-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.019
SWEP.Primary.ConeZoomed		= 0.009
SWEP.Primary.Delay			= 0.14

SWEP.Primary.ClipSize		= 13
SWEP.Primary.DefaultClip	= 144
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_p228", "CSKillIcons", "a", Color (150, 150, 255, 255)) end

