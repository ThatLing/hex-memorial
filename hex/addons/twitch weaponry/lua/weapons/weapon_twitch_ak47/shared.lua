
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AK47"

SWEP.Slot					= 2
SWEP.IconLetter				= "b"

SWEP.ViewModel				= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelAimPos		= Vector (4.1774, -2.0709, 2.355)
--SWEP.ViewModelAimPos		= Vector (6.0774, 0, 1.9644) -- real ironsights; totally does not work
--SWEP.ViewModelAimAng		= Vector (2.8406, -0.0088, -0.4718)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AK47.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/ak47/ak47-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.004
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 31
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_ak47", "CSKillIcons", "b", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "ar2"
end


function SWEP:Initialize()  
	self:SetWeaponHoldType("ar2")  
end


SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch AK47"

SWEP.Slot					= 2
SWEP.IconLetter				= "b"

SWEP.ViewModel				= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_ak47.mdl"
SWEP.ViewModelAimPos		= Vector (4.1774, -2.0709, 2.355)
--SWEP.ViewModelAimPos		= Vector (6.0774, 0, 1.9644) -- real ironsights; totally does not work
--SWEP.ViewModelAimAng		= Vector (2.8406, -0.0088, -0.4718)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AK47.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/ak47/ak47-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.004
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 31
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1.3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_ak47", "CSKillIcons", "b", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})
