
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

SWEP.PrintName				= "Twitch HL2 Shotgun"

SWEP.Slot					= 2
SWEP.IconLetter				= "0"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_shotgun.mdl"
SWEP.ViewModelAimPos		= Vector (-7.2043, -3.4132, 1.8321)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Shotgun.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay			= 0.9

SWEP.Primary.ClipSize		= 6
SWEP.NoChamberingRounds		= true
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

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
	
	if (self.FireTime or 0) + 0.7 > CurTime() then return end
	
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
			self:EmitSound ("Weapon_Shotgun.Reload")
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self:SetClip1 (self:Clip1()+1)
			
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.nextReload = CurTime() + self.ReloadDelay
				self:SetNextPrimaryFire (CurTime() + 0.8)
				self:SetNWBool ("reloading", false)
			end
		end
	elseif self.Reloading and ((self.nextReload or 0) < CurTime()) then
		self.Reloading = false
		self.Pumped = true
		self.FireTime = CurTime() - 0.3
	end
	
	if self.AnimFired and ((self.FireTime or 0) + 0.01 < CurTime()) then
		--Msg ("FIRE2\n")
		self:SendWeaponAnim (ACT_VM_PRIMARYATTACK)
		self.AnimFired = false
		if self:Clip1() > 0 then
			self.Pumped = true
		else
			self:SetNextPrimaryFire (CurTime() + 0.01)
		end
	elseif self.Pumped and ((self.FireTime or 0) + 0.3 < CurTime()) then
		--Msg ("PUMP\n")
		self:SendWeaponAnim (ACT_SHOTGUN_PUMP)
		if not (SERVER) then
			if GetConVar("twitch_aim_bullettime"):GetBool() and (self.DegreeOfZoom or 0) > 0 then
				local pitch = 100 - self.DegreeOfZoom * (100 - (40 or self.Primary.BullettimeSoundPitch) / (1 - GetConVar("twitch_aim_bullettime_timescale"):GetFloat()))
				self:EmitSound ("weapons/shotgun/shotgun_cock.wav", 100, pitch)
			else
				self:EmitSound ("weapons/shotgun/shotgun_cock.wav")
			end
		end
		self.Pumped = false
		self.Idled = true
	elseif self.Idled and ((self.FireTime or 0) + 0.7 < CurTime()) then
		--Msg ("IDLE\n")
		self:SendWeaponAnim (ACT_VM_IDLE)
		self.Idled = false
	end
end

function SWEP:CustomPrimaryAttack()
	--if SERVER and SinglePlayer() then 
	--	self.Owner:SendLua("LocalPlayer():GetActiveWeapon():CustomPrimaryAttack()")
	--	return
	--end
	--Msg ("FIRE\n")
	self.FireTime = CurTime()
	self.AnimFired = true
end

if CLIENT then killicon.AddFont ("weapon_twitch_hl2shotgun", "HL2MPTypeDeath", "0", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})

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

SWEP.PrintName				= "Twitch HL2 Shotgun"

SWEP.Slot					= 2
SWEP.IconLetter				= "0"
SWEP.IconLetterFont			= "HL2SelectIcons"

SWEP.ViewModel				= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_shotgun.mdl"
SWEP.ViewModelAimPos		= Vector (-7.2043, -3.4132, 1.8321)
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 65

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.Primary.Sound			= Sound ("Weapon_Shotgun.Single")
SWEP.Primary.BullettimeSound		= Sound ("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.BullettimeSoundPitch	= 70
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 14
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay			= 0.9

SWEP.Primary.ClipSize		= 6
SWEP.NoChamberingRounds		= true
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

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
	
	if (self.FireTime or 0) + 0.7 > CurTime() then return end
	
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
			self:EmitSound ("Weapon_Shotgun.Reload")
			
			self.Owner:RemoveAmmo (1, self.Primary.Ammo, false)
			self:SetClip1 (self:Clip1()+1)
			
			if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
				self:SendWeaponAnim (ACT_SHOTGUN_RELOAD_FINISH)
				self.nextReload = CurTime() + self.ReloadDelay
				self:SetNextPrimaryFire (CurTime() + 0.8)
				self:SetNWBool ("reloading", false)
			end
		end
	elseif self.Reloading and ((self.nextReload or 0) < CurTime()) then
		self.Reloading = false
		self.Pumped = true
		self.FireTime = CurTime() - 0.3
	end
	
	if self.AnimFired and ((self.FireTime or 0) + 0.01 < CurTime()) then
		--Msg ("FIRE2\n")
		self:SendWeaponAnim (ACT_VM_PRIMARYATTACK)
		self.AnimFired = false
		if self:Clip1() > 0 then
			self.Pumped = true
		else
			self:SetNextPrimaryFire (CurTime() + 0.01)
		end
	elseif self.Pumped and ((self.FireTime or 0) + 0.3 < CurTime()) then
		--Msg ("PUMP\n")
		self:SendWeaponAnim (ACT_SHOTGUN_PUMP)
		if not (SERVER) then
			if GetConVar("twitch_aim_bullettime"):GetBool() and (self.DegreeOfZoom or 0) > 0 then
				local pitch = 100 - self.DegreeOfZoom * (100 - (40 or self.Primary.BullettimeSoundPitch) / (1 - GetConVar("twitch_aim_bullettime_timescale"):GetFloat()))
				self:EmitSound ("weapons/shotgun/shotgun_cock.wav", 100, pitch)
			else
				self:EmitSound ("weapons/shotgun/shotgun_cock.wav")
			end
		end
		self.Pumped = false
		self.Idled = true
	elseif self.Idled and ((self.FireTime or 0) + 0.7 < CurTime()) then
		--Msg ("IDLE\n")
		self:SendWeaponAnim (ACT_VM_IDLE)
		self.Idled = false
	end
end

function SWEP:CustomPrimaryAttack()
	--if SERVER and SinglePlayer() then 
	--	self.Owner:SendLua("LocalPlayer():GetActiveWeapon():CustomPrimaryAttack()")
	--	return
	--end
	--Msg ("FIRE\n")
	self.FireTime = CurTime()
	self.AnimFired = true
end

if CLIENT then killicon.AddFont ("weapon_twitch_hl2shotgun", "HL2MPTypeDeath", "0", Color (150, 150, 255, 255)) end

--GAMEMODE:RegisterWeapon ("weapon_twitch_ak47", {{typ = "text", text = "b", font = "CSSWeapons80", x = 6, y = 10}}, {})
