
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

SWEP.PrintName				= "Twitch HL2 .357"

SWEP.Slot					= 1
SWEP.IconLetter				= "."
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_357.mdl"
SWEP.WorldModel				= "models/weapons/w_357.mdl"
SWEP.ViewModelAimPos		= Vector (-4.213, -2.7352, 1.7144)
SWEP.ViewModelAimAng		= Vector (0, 0, 1.3341)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_357.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/357/357_fire2.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ConeZoomed		= 0.00 --heh
SWEP.Primary.Delay			= 0.4

SWEP.Primary.ClipSize		= 6
SWEP.NoChamberingRounds	= true
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2357", "HL2MPTypeDeath", ".", Color (150, 150, 255, 255)) end

function SWEP:CustomHolster()
	self.Holstered = true
end

function SWEP:CustomDeploy()
	self.Holstered = false
	self.LastThink = CurTime()
end

function SWEP:CustomThink()
	if ((self.LastThink or 100000) + 1 < CurTime()) and not self.Holstered then
		self:SendWeaponAnim (ACT_VM_IDLE)
	end
	self.LastThink = CurTime()
end

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

SWEP.PrintName				= "Twitch HL2 .357"

SWEP.Slot					= 1
SWEP.IconLetter				= "."
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_357.mdl"
SWEP.WorldModel				= "models/weapons/w_357.mdl"
SWEP.ViewModelAimPos		= Vector (-4.213, -2.7352, 1.7144)
SWEP.ViewModelAimAng		= Vector (0, 0, 1.3341)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_357.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/357/357_fire2.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ConeZoomed		= 0.00 --heh
SWEP.Primary.Delay			= 0.4

SWEP.Primary.ClipSize		= 6
SWEP.NoChamberingRounds	= true
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Recoil					= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_hl2357", "HL2MPTypeDeath", ".", Color (150, 150, 255, 255)) end

function SWEP:CustomHolster()
	self.Holstered = true
end

function SWEP:CustomDeploy()
	self.Holstered = false
	self.LastThink = CurTime()
end

function SWEP:CustomThink()
	if ((self.LastThink or 100000) + 1 < CurTime()) and not self.Holstered then
		self:SendWeaponAnim (ACT_VM_IDLE)
	end
	self.LastThink = CurTime()
end
