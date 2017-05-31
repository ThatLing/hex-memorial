
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

SWEP.PrintName				= "Twitch Desert Eagle"

SWEP.Slot					= 1
SWEP.IconLetter				= "f"

SWEP.ViewModel				= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"
--SWEP.ViewModelAimPos		= Vector (3.1733, -2.4169, 2.6926)
SWEP.ViewModelAimPos		= Vector (4.2564, 0, 2.2219)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Deagle.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/deagle/deagle-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.26

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_deagle", "CSKillIcons", "f", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

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

SWEP.PrintName				= "Twitch Desert Eagle"

SWEP.Slot					= 1
SWEP.IconLetter				= "f"

SWEP.ViewModel				= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"
--SWEP.ViewModelAimPos		= Vector (3.1733, -2.4169, 2.6926)
SWEP.ViewModelAimPos		= Vector (4.2564, 0, 2.2219)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Deagle.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/deagle/deagle-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.26

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_deagle", "CSKillIcons", "f", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
