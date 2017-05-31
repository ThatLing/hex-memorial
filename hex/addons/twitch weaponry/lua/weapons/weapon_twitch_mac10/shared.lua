
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

SWEP.PrintName				= "Twitch MAC-10"

SWEP.Slot					= 1
SWEP.IconLetter				= "l"

SWEP.ViewModel				= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_mac10.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.6152, 0, 0.9695)
SWEP.ViewModelAimAng		= Vector (3.5009, 0.31, 6.6686)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_MAC10.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/mac10/mac10-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.ConeZoomed		= 0.05
SWEP.Primary.Delay			= 0.06

SWEP.Primary.ClipSize		= 33
SWEP.Primary.DefaultClip	= 288
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_mac10", "CSKillIcons", "l", Color (150, 150, 255, 255)) end


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

SWEP.PrintName				= "Twitch MAC-10"

SWEP.Slot					= 1
SWEP.IconLetter				= "l"

SWEP.ViewModel				= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_mac10.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.6152, 0, 0.9695)
SWEP.ViewModelAimAng		= Vector (3.5009, 0.31, 6.6686)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_MAC10.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/mac10/mac10-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.ConeZoomed		= 0.05
SWEP.Primary.Delay			= 0.06

SWEP.Primary.ClipSize		= 33
SWEP.Primary.DefaultClip	= 288
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_mac10", "CSKillIcons", "l", Color (150, 150, 255, 255)) end

