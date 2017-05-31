
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

SWEP.PrintName				= "Twitch M249"

SWEP.Slot					= 2
SWEP.IconLetter				= "z"

SWEP.ViewModel				= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m249para.mdl"
SWEP.ViewModelAimPos		= Vector (-3.5969, 0, 1.7273)
SWEP.ViewModelFlip			= false

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M249.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m249/m249-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.044
SWEP.Primary.ConeZoomed		= 0.0045
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 101
SWEP.Primary.DefaultClip	= 400
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_m249", "CSKillIcons", "z", Color (150, 150, 255, 255)) end


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

SWEP.PrintName				= "Twitch M249"

SWEP.Slot					= 2
SWEP.IconLetter				= "z"

SWEP.ViewModel				= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m249para.mdl"
SWEP.ViewModelAimPos		= Vector (-3.5969, 0, 1.7273)
SWEP.ViewModelFlip			= false

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M249.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m249/m249-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.044
SWEP.Primary.ConeZoomed		= 0.0045
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 101
SWEP.Primary.DefaultClip	= 400
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_m249", "CSKillIcons", "z", Color (150, 150, 255, 255)) end

