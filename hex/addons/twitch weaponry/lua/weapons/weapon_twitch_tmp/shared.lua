
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

SWEP.PrintName				= "Twitch TMP"

SWEP.Slot					= 2
SWEP.IconLetter				= "l"

SWEP.ViewModel				= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_tmp.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.2691, 0, 2.1737)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_TMP.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/tmp/tmp-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.033
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.08

SWEP.Primary.ClipSize		= 26
SWEP.Primary.DefaultClip	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_tmp", "CSKillIcons", "d", Color (150, 150, 255, 255)) end

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

SWEP.PrintName				= "Twitch TMP"

SWEP.Slot					= 2
SWEP.IconLetter				= "l"

SWEP.ViewModel				= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_tmp.mdl"
--SWEP.ViewModelAimPos		= Vector (2.5364, -1.8409, 1.745)
SWEP.ViewModelAimPos		= Vector (4.2691, 0, 2.1737)
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_TMP.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/tmp/tmp-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.033
SWEP.Primary.ConeZoomed		= 0.008
SWEP.Primary.Delay			= 0.08

SWEP.Primary.ClipSize		= 26
SWEP.Primary.DefaultClip	= 250
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Recoil					= 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if CLIENT then killicon.AddFont ("weapon_twitch_tmp", "CSKillIcons", "d", Color (150, 150, 255, 255)) end

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
