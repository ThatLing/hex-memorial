
----------------------------------------
--         2014-07-12 20:33:15          --
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

SWEP.PrintName				= "Twitch SG550"

SWEP.Slot					= 1
SWEP.IconLetter				= "o"

SWEP.ViewModel				= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_sg550.mdl"
--SWEP.ViewModelAimPos		= Vector (1.5592, -2.142, 1.9292)
SWEP.ViewModelAimPos		= Vector (1.646, -1.4623, -0.955)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_sg550.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.007
SWEP.Primary.Delay			= 0.2 --0.11

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_sg550", "CSKillIcons", "o", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:15          --
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

SWEP.PrintName				= "Twitch SG550"

SWEP.Slot					= 1
SWEP.IconLetter				= "o"

SWEP.ViewModel				= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_sg550.mdl"
--SWEP.ViewModelAimPos		= Vector (1.5592, -2.142, 1.9292)
SWEP.ViewModelAimPos		= Vector (1.646, -1.4623, -0.955)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_sg550.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m4a1/m4a1_unsil-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0175
SWEP.Primary.ConeZoomed		= 0.007
SWEP.Primary.Delay			= 0.2 --0.11

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 84
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "ar2"

SWEP.Recoil					= 2.2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_sg550", "CSKillIcons", "o", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_deagle", {{typ = "text", text = "f", font = "CSSWeapons60", x = 25, y = 10}}, {})
