
----------------------------------------
--         2014-07-12 20:33:14          --
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

SWEP.PrintName				= "Twitch Fiveseven"

SWEP.Slot					= 1
SWEP.IconLetter				= "u"

SWEP.ViewModel				= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_fiveseven.mdl"
SWEP.ViewModelAimPos		= Vector (3.8657, -1.1468, 2.683)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Fiveseven.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/fiveseven/fiveseven-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.021
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.11

SWEP.Primary.ClipSize		= 21
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_fiveseven", "CSKillIcons", "u", Color (150, 150, 255, 255)) end


----------------------------------------
--         2014-07-12 20:33:14          --
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

SWEP.PrintName				= "Twitch Fiveseven"

SWEP.Slot					= 1
SWEP.IconLetter				= "u"

SWEP.ViewModel				= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_fiveseven.mdl"
SWEP.ViewModelAimPos		= Vector (3.8657, -1.1468, 2.683)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Fiveseven.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/fiveseven/fiveseven-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.021
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.11

SWEP.Primary.ClipSize		= 21
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_fiveseven", "CSKillIcons", "u", Color (150, 150, 255, 255)) end

