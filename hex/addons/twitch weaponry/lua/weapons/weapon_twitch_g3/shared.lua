
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_sniper"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end

if ( CLIENT ) then 
	killicon.AddFont ("weapon_twitch_g3", "CSKillIcons", "i", Color (150, 150, 255, 255))
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch G3 SG1"

SWEP.Slot					= 1
SWEP.IconLetter				= "i"

SWEP.ViewModel				= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_g3sg1.mdl"
--SWEP.ViewModelAimPos		= Vector (1.2486, -2.5577, 1.3717)
SWEP.ViewModelAimPos		= Vector (1.7331, -1.2591, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_G3SG1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.007
SWEP.Primary.Delay			= 0.2

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base_sniper"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end

if ( CLIENT ) then 
	killicon.AddFont ("weapon_twitch_g3", "CSKillIcons", "i", Color (150, 150, 255, 255))
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch G3 SG1"

SWEP.Slot					= 1
SWEP.IconLetter				= "i"

SWEP.ViewModel				= "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_g3sg1.mdl"
--SWEP.ViewModelAimPos		= Vector (1.2486, -2.5577, 1.3717)
SWEP.ViewModelAimPos		= Vector (1.7331, -1.2591, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_G3SG1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.007
SWEP.Primary.Delay			= 0.2

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

