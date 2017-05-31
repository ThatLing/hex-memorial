
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "smg"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("smg")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch HL2 MP7"

SWEP.Slot					= 2
SWEP.IconLetter				= "/"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.ViewModelAimPos		= Vector (-4.391, -1.1411, 1.8545)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_SMG1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.006
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 46
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2mp7", "HL2MPTypeDeath", "/", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})

----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "smg"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("smg")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch HL2 MP7"

SWEP.Slot					= 2
SWEP.IconLetter				= "/"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.ViewModelAimPos		= Vector (-4.391, -1.1411, 1.8545)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_SMG1.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ConeZoomed		= 0.006
SWEP.Primary.Delay			= 0.075

SWEP.Primary.ClipSize		= 46
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2mp7", "HL2MPTypeDeath", "/", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})
