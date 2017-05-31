
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "shotgun"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("shotgun")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch M3"

SWEP.Slot					= 2
SWEP.IconLetter				= "k"

SWEP.ViewModel				= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel				= "models/weapons/w_shot_m3super90.mdl"
SWEP.ViewModelAimPos		= Vector (4.906, 0, 1.9543)
SWEP.ViewModelAimPosMax		= SWEP.ViewModelAimPos
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M3.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m3/m3-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay			= 1.1

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 64
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Recoil					= 4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadDelay			= 0.4
SWEP.CustomReload			= true

function SWEP:Reload()
	--if SERVER and SinglePlayer() then
	--	self.Owner:SendLua ("LocalPlayer():GetActiveWeapon():Reload()")
	--end
	
 	if self:GetNWBool ("reloading", false) then return end
	
 	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
 		self:SetNWBool ("reloading", true)
 		self.nextReload = CurTime() + self.ReloadDelay
		self:SetNextPrimaryFire (CurTime() + 9999)
 		self:SendWeaponAnim (ACT_VM_RELOAD)
 	end
end

function SWEP:CustomThink()
	if self:GetNWBool ("reloading", false) then
		self.Reloading = true
		if (self.nextReload or 0) < CurTime() then
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self:SetNWBool ("reloading", false)
				return
			end
			
			self.nextReload = CurTime() + self.ReloadDelay
			self:SendWeaponAnim (ACT_VM_RELOAD)
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self:SetClip1 (self:Clip1()+1)
			
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.nextReload = CurTime() + self.ReloadDelay + 0.5
				self:SetNextPrimaryFire (CurTime() + 0.8)
				self:SetNWBool ("reloading", false)
			end
		end
	elseif (self.nextReload or 0) + 0.1 < CurTime() then
		self.Reloading = false
	end
end

function SWEP:CustomPrimaryAttack()
	--if SERVER and SinglePlayer() then 
	--	self.Owner:SendLua("LocalPlayer():GetActiveWeapon().FireTime = CurTime()")
	--	return
	--end
	self.FireTime = CurTime()
end

if CLIENT then killicon.AddFont ("weapon_twitch_m3", "CSKillIcons", "k", Color (150, 150, 255, 255)) end


----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
SWEP.Base = "weapon_twitch_base"

if SERVER then
	AddCSLuaFile ("shared.lua")
	
	SWEP.HoldType			= "shotgun"
end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("shotgun")  
end

SWEP.Category				= "United Hosts"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.PrintName				= "Twitch M3"

SWEP.Slot					= 2
SWEP.IconLetter				= "k"

SWEP.ViewModel				= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel				= "models/weapons/w_shot_m3super90.mdl"
SWEP.ViewModelAimPos		= Vector (4.906, 0, 1.9543)
SWEP.ViewModelAimPosMax		= SWEP.ViewModelAimPos
SWEP.ViewModelFlip			= true

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_M3.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/m3/m3-1.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay			= 1.1

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 64
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Recoil					= 4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadDelay			= 0.4
SWEP.CustomReload			= true

function SWEP:Reload()
	--if SERVER and SinglePlayer() then
	--	self.Owner:SendLua ("LocalPlayer():GetActiveWeapon():Reload()")
	--end
	
 	if self:GetNWBool ("reloading", false) then return end
	
 	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
 		self:SetNWBool ("reloading", true)
 		self.nextReload = CurTime() + self.ReloadDelay
		self:SetNextPrimaryFire (CurTime() + 9999)
 		self:SendWeaponAnim (ACT_VM_RELOAD)
 	end
end

function SWEP:CustomThink()
	if self:GetNWBool ("reloading", false) then
		self.Reloading = true
		if (self.nextReload or 0) < CurTime() then
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self:SetNWBool ("reloading", false)
				return
			end
			
			self.nextReload = CurTime() + self.ReloadDelay
			self:SendWeaponAnim (ACT_VM_RELOAD)
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self:SetClip1 (self:Clip1()+1)
			
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.nextReload = CurTime() + self.ReloadDelay + 0.5
				self:SetNextPrimaryFire (CurTime() + 0.8)
				self:SetNWBool ("reloading", false)
			end
		end
	elseif (self.nextReload or 0) + 0.1 < CurTime() then
		self.Reloading = false
	end
end

function SWEP:CustomPrimaryAttack()
	--if SERVER and SinglePlayer() then 
	--	self.Owner:SendLua("LocalPlayer():GetActiveWeapon().FireTime = CurTime()")
	--	return
	--end
	self.FireTime = CurTime()
end

if CLIENT then killicon.AddFont ("weapon_twitch_m3", "CSKillIcons", "k", Color (150, 150, 255, 255)) end

