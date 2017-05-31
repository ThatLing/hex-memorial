
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

SWEP.PrintName				= "Twitch P90"

SWEP.Slot					= 2
SWEP.IconLetter				= "m"

SWEP.ViewModel				= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_p90.mdl"
--SWEP.ViewModelAimPos		= Vector (1.4479, -3.7031, 2.545)
SWEP.ViewModelAimPos		= Vector (3.5741, -1.8043, 1.5858)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_P90.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/p90/p90-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.009
SWEP.Primary.Delay			= 0.06

SWEP.Primary.ClipSize		= 51
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_p90", "CSKillIcons", "m", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_p90", {{typ = "text", text = "m", font = "CSSWeapons70", x = 14, y = 10}}, {})

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

SWEP.PrintName				= "Twitch P90"

SWEP.Slot					= 2
SWEP.IconLetter				= "m"

SWEP.ViewModel				= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_p90.mdl"
--SWEP.ViewModelAimPos		= Vector (1.4479, -3.7031, 2.545)
SWEP.ViewModelAimPos		= Vector (3.5741, -1.8043, 1.5858)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_P90.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/p90/p90-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.009
SWEP.Primary.Delay			= 0.06

SWEP.Primary.ClipSize		= 51
SWEP.Primary.DefaultClip	= 300
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_p90", "CSKillIcons", "m", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_p90", {{typ = "text", text = "m", font = "CSSWeapons70", x = 14, y = 10}}, {})
