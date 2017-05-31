
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


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AWP"

SWEP.Slot					= 1
SWEP.IconLetter				= "r"

SWEP.ViewModel				= "models/weapons/v_snip_AWP.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_AWP.mdl"
--SWEP.ViewModelAimPos		= Vector (2.3852, -3.5028, 1.4292)
SWEP.ViewModelAimPos		= Vector (1.2358, 2.4621, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AWP.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 85
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ConeZoomed		= 0.0045
SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_awp", "CSKillIcons", "r", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

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


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AWP"

SWEP.Slot					= 1
SWEP.IconLetter				= "r"

SWEP.ViewModel				= "models/weapons/v_snip_AWP.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_AWP.mdl"
--SWEP.ViewModelAimPos		= Vector (2.3852, -3.5028, 1.4292)
SWEP.ViewModelAimPos		= Vector (1.2358, 2.4621, 0)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AWP.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 85
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ConeZoomed		= 0.0045
SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_awp", "CSKillIcons", "r", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
