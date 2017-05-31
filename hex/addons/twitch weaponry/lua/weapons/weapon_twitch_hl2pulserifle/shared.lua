
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

SWEP.PrintName				= "Twitch HL2 Pulse-Rifle"

SWEP.Slot					= 2
SWEP.IconLetter				= "2"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_irifle.mdl"
SWEP.WorldModel				= "models/weapons/w_irifle.mdl"
SWEP.ViewModelAimPos		= Vector (-4.4599, -1.5141, 1.7999)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AR2.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/ar2/fire1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.10
SWEP.Primary.ConeZoomed		= 0.07 --0.005
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 30
SWEP.NoChamberingRounds	= true
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.CustomTracerName		= "AR2Tracer"
SWEP.CustomTracerFreq		= 1

SWEP.CustomBulletCallback	= function (atk, trc, dmginfo)
	local effdata = EffectData()
	effdata:SetStart (trc.HitPos)
	effdata:SetOrigin (trc.HitPos)
	effdata:SetNormal (trc.HitNormal)
	util.Effect ("AR2Impact", effdata)
end

SWEP.Recoil					= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2pulserifle", "HL2MPTypeDeath", "2", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})

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

SWEP.PrintName				= "Twitch HL2 Pulse-Rifle"

SWEP.Slot					= 2
SWEP.IconLetter				= "2"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_irifle.mdl"
SWEP.WorldModel				= "models/weapons/w_irifle.mdl"
SWEP.ViewModelAimPos		= Vector (-4.4599, -1.5141, 1.7999)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_AR2.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/ar2/fire1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.10
SWEP.Primary.ConeZoomed		= 0.07 --0.005
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 30
SWEP.NoChamberingRounds	= true
SWEP.Primary.DefaultClip	= 270
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.CustomTracerName		= "AR2Tracer"
SWEP.CustomTracerFreq		= 1

SWEP.CustomBulletCallback	= function (atk, trc, dmginfo)
	local effdata = EffectData()
	effdata:SetStart (trc.HitPos)
	effdata:SetOrigin (trc.HitPos)
	effdata:SetNormal (trc.HitNormal)
	util.Effect ("AR2Impact", effdata)
end

SWEP.Recoil					= 1.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2pulserifle", "HL2MPTypeDeath", "2", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})
