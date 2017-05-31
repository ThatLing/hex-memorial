
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

local REDEEMER = {}

if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	local function NukePickupFix(ply,wep)
		if IsValid(ply) and IsValid(wep) then
			if wep:GetClass() == "weapon_nuke" then
				ply:SelectWeapon("weapon_nuke")
			end
		end
	end
	hook.Add("PlayerCanPickupWeapon", "NukePickupFix", NukePickupFix)
	
	
	local function NukeViewFix(ply)
		ply:SetViewEntity(ply) 
	end
	hook.Add("PlayerSpawn", "NukeViewFix", NukeViewFix)
	concommand.Add("hsp_fixnuke", NukeViewFix)
	concommand.Add("hsp_nukefix", NukeViewFix)
	concommand.Add("nukefix", NukeViewFix)
	concommand.Add("fixnuke", NukeViewFix)
end

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.HoldType			= "rpg"

if CLIENT then
	language.Add("AlyxGun", "Nuclear missile")
	
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.PrintName			= "One-shot wonder"			
	SWEP.Author				= "Teta_Bonita + HeX"
	SWEP.Category			= "DEBUG"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 10
end

SWEP.Author			= "Teta_Bonita + HeX"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Aim away from face"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false --false

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 2

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AlyxGun"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.Rocket = SWEP.Rocket or NULL

SWEP.IsGuidingNuke = false
SWEP.DrawReticle = false
SWEP.LastAng = Vector(0,0,0)


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end


function SWEP:Deploy()
	self.Owner:SetNWBool("DrawReticle",false)
end


function SWEP:Reload()
	if self.Rocket and self.Rocket:IsValid() then return false end
	self:DefaultReload( ACT_VM_RELOAD )
end

function SWEP:Think()
	if self.IsGuidingNuke and self.Rocket and self.Rocket:IsValid() then		
		local PlayerAng = self.Owner:GetAimVector()
		
		self.Rocket:SetAngles(PlayerAng:Angle())
		self.RocketPhysObj:SetVelocity(PlayerAng*1200)
		
		local ViewEnt = self.Owner:GetViewEntity() -- we should be able to do this client-side, but for some fucking reason GetViewEntity() is server only
		
		if self.DrawReticle and ViewEnt ~= self.Rocket then
			self.DrawReticle = false
			self.Owner:SetNWBool("DrawReticle",false)
		end
		
		if not self.DrawReticle and ViewEnt == self.Rocket then
			self.DrawReticle = true
			self.Owner:SetNWBool("DrawReticle",true)
		end
		
		if ViewEnt == self.Owner or ViewEnt == NULL then
			self.Owner:SetViewEntity(self.Rocket) 
		end
		
	else
		self:StopGuiding()
	end
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	if self.Primary.NextFire > CurTime() or self.Owner:GetAmmoCount("AlyxGun") < 1 then 
		return
	end
	self.Primary.NextFire = CurTime() + self.Primary.Delay
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self:EmitSound( Sound("Weapon_RPG.Single") )
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	if self.IsGuidingNuke and self.Rocket and self.Rocket:IsValid() then
		self:StopGuiding()
		
		local nuke = ents.Create("nuke_explosion")
			nuke:SetPos( self.Rocket:GetPos() )
			nuke:SetOwner(self.Owner)
			nuke.Owner = self.Owner
			if CPPI then
				nuke:CPPISetOwner(self.Owner)
			end
			nuke:Spawn()
		nuke:Activate()
		
		self.Rocket:Remove()
		return
	end
	
	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAng = self.Owner:GetAimVector()
	
	--the muzzle attachement for the rocket launcher is fucked, so we need to adjust the missile's position by hand
	local PlayerForward = self.Owner:GetForward()
	local PlayerRight = self.Owner:GetRight()
	local SpawnPos = PlayerPos + 32*PlayerForward + 32*PlayerRight
	
	local trace = {}
		trace.start = PlayerPos + PlayerAng*32
		trace.endpos = PlayerPos + PlayerAng*16384
		trace.filter = {self.Owner}
	local traceRes = util.TraceLine(trace)
	
	if SERVER then
		self:TakePrimaryAmmo(1)
		
		self.Rocket = ents.Create("nuke_missile")
			self.Rocket:SetPos(SpawnPos)
			self.Rocket:SetAngles(PlayerAng:Angle())
			
			self.Rocket:SetPhysicsAttacker(self.Owner)
			self.Rocket:SetOwner(self.Owner)
			self.Rocket.Owner = self.Owner
			
			self.Rocket:Spawn()
		self.Rocket:Activate()
		
		if HSP and HSP.Nuke_LaunchDetected then
			HSP.Nuke_LaunchDetected(self.Owner, self.Rocket)
		end
		
		self.RocketPhysObj = self.Rocket:GetPhysicsObject()
		self.RocketPhysObj:SetVelocity(PlayerAng*512 - 16*PlayerRight + Vector(0,0,256))		
		timer.Simple(0.5, function()
			REDEEMER.AimRocket(self.Rocket, traceRes.HitPos)
		end)
	end
end


function SWEP:SecondaryAttack()
	if self.Secondary.NextFire > CurTime() then 
		return
	end
	
	self.Secondary.NextFire = CurTime() + self.Secondary.Delay

	if self.IsGuidingNuke then
		self:StopGuiding()
	else
		self:StartGuiding()
	end
end


function SWEP:StartGuiding()
	if not self.Rocket or self.Rocket == NULL then return end
	
	self.LastAng = self.Owner:EyeAngles()
	self.Owner:SetEyeAngles(self.Rocket:GetAngles())
	
	self.IsGuidingNuke = true
	self.DrawReticle = true
	self.Owner:SetNWBool("DrawReticle",true)
	
	if SERVER then
		if IsValid(self.Owner) then
			if IsValid(self.Rocket) then
				self.Owner:SetViewEntity(self.Rocket)
			end
			self.Owner:DrawViewModel(false)
		end
	end
end

function SWEP:StopGuiding()
	if not self.IsGuidingNuke then return end
	
	self.IsGuidingNuke = false
	self.DrawReticle = false
	self.Owner:SetNWBool("DrawReticle",false)
	
	if SERVER then
		if IsValid(self.Owner) then
			self.Owner:SetViewEntity(self.Owner)
			self.Owner:DrawViewModel(true)
		end
	end
	if IsValid(self.Owner) and self.LastAng then
		self.Owner:SetEyeAngles(self.LastAng)
	end
end


function REDEEMER.AimRocket(rocket,pos)
	if not rocket then return end
	local NewAng = (pos - rocket:GetPos()):GetNormalized()
	rocket:SetAngles(NewAng:Angle())
end


function SWEP:Holster()
	self:StopGuiding()
	return true
end


function SWEP:OnRemove()
	self:StopGuiding()
	return true
end





----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------

local REDEEMER = {}

if SERVER then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	local function NukePickupFix(ply,wep)
		if IsValid(ply) and IsValid(wep) then
			if wep:GetClass() == "weapon_nuke" then
				ply:SelectWeapon("weapon_nuke")
			end
		end
	end
	hook.Add("PlayerCanPickupWeapon", "NukePickupFix", NukePickupFix)
	
	
	local function NukeViewFix(ply)
		ply:SetViewEntity(ply) 
	end
	hook.Add("PlayerSpawn", "NukeViewFix", NukeViewFix)
	concommand.Add("hsp_fixnuke", NukeViewFix)
	concommand.Add("hsp_nukefix", NukeViewFix)
	concommand.Add("nukefix", NukeViewFix)
	concommand.Add("fixnuke", NukeViewFix)
end

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.HoldType			= "rpg"

if CLIENT then
	language.Add("AlyxGun", "Nuclear missile")
	
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.PrintName			= "One-shot wonder"			
	SWEP.Author				= "Teta_Bonita + HeX"
	SWEP.Category			= "DEBUG"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 10
end

SWEP.Author			= "Teta_Bonita + HeX"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Aim away from face"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false --false

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 2

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AlyxGun"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.Rocket = SWEP.Rocket or NULL

SWEP.IsGuidingNuke = false
SWEP.DrawReticle = false
SWEP.LastAng = Vector(0,0,0)


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end


function SWEP:Deploy()
	self.Owner:SetNWBool("DrawReticle",false)
end


function SWEP:Reload()
	if self.Rocket and self.Rocket:IsValid() then return false end
	self:DefaultReload( ACT_VM_RELOAD )
end

function SWEP:Think()
	if self.IsGuidingNuke and self.Rocket and self.Rocket:IsValid() then		
		local PlayerAng = self.Owner:GetAimVector()
		
		self.Rocket:SetAngles(PlayerAng:Angle())
		self.RocketPhysObj:SetVelocity(PlayerAng*1200)
		
		local ViewEnt = self.Owner:GetViewEntity() -- we should be able to do this client-side, but for some fucking reason GetViewEntity() is server only
		
		if self.DrawReticle and ViewEnt ~= self.Rocket then
			self.DrawReticle = false
			self.Owner:SetNWBool("DrawReticle",false)
		end
		
		if not self.DrawReticle and ViewEnt == self.Rocket then
			self.DrawReticle = true
			self.Owner:SetNWBool("DrawReticle",true)
		end
		
		if ViewEnt == self.Owner or ViewEnt == NULL then
			self.Owner:SetViewEntity(self.Rocket) 
		end
		
	else
		self:StopGuiding()
	end
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	if self.Primary.NextFire > CurTime() or self.Owner:GetAmmoCount("AlyxGun") < 1 then 
		return
	end
	self.Primary.NextFire = CurTime() + self.Primary.Delay
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self:EmitSound( Sound("Weapon_RPG.Single") )
	
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	if self.IsGuidingNuke and self.Rocket and self.Rocket:IsValid() then
		self:StopGuiding()
		
		local nuke = ents.Create("nuke_explosion")
			nuke:SetPos( self.Rocket:GetPos() )
			nuke:SetOwner(self.Owner)
			nuke.Owner = self.Owner
			if CPPI then
				nuke:CPPISetOwner(self.Owner)
			end
			nuke:Spawn()
		nuke:Activate()
		
		self.Rocket:Remove()
		return
	end
	
	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAng = self.Owner:GetAimVector()
	
	--the muzzle attachement for the rocket launcher is fucked, so we need to adjust the missile's position by hand
	local PlayerForward = self.Owner:GetForward()
	local PlayerRight = self.Owner:GetRight()
	local SpawnPos = PlayerPos + 32*PlayerForward + 32*PlayerRight
	
	local trace = {}
		trace.start = PlayerPos + PlayerAng*32
		trace.endpos = PlayerPos + PlayerAng*16384
		trace.filter = {self.Owner}
	local traceRes = util.TraceLine(trace)
	
	if SERVER then
		self:TakePrimaryAmmo(1)
		
		self.Rocket = ents.Create("nuke_missile")
			self.Rocket:SetPos(SpawnPos)
			self.Rocket:SetAngles(PlayerAng:Angle())
			
			self.Rocket:SetPhysicsAttacker(self.Owner)
			self.Rocket:SetOwner(self.Owner)
			self.Rocket.Owner = self.Owner
			
			self.Rocket:Spawn()
		self.Rocket:Activate()
		
		if HSP and HSP.Nuke_LaunchDetected then
			HSP.Nuke_LaunchDetected(self.Owner, self.Rocket)
		end
		
		self.RocketPhysObj = self.Rocket:GetPhysicsObject()
		self.RocketPhysObj:SetVelocity(PlayerAng*512 - 16*PlayerRight + Vector(0,0,256))		
		timer.Simple(0.5, function()
			REDEEMER.AimRocket(self.Rocket, traceRes.HitPos)
		end)
	end
end


function SWEP:SecondaryAttack()
	if self.Secondary.NextFire > CurTime() then 
		return
	end
	
	self.Secondary.NextFire = CurTime() + self.Secondary.Delay

	if self.IsGuidingNuke then
		self:StopGuiding()
	else
		self:StartGuiding()
	end
end


function SWEP:StartGuiding()
	if not self.Rocket or self.Rocket == NULL then return end
	
	self.LastAng = self.Owner:EyeAngles()
	self.Owner:SetEyeAngles(self.Rocket:GetAngles())
	
	self.IsGuidingNuke = true
	self.DrawReticle = true
	self.Owner:SetNWBool("DrawReticle",true)
	
	if SERVER then
		if IsValid(self.Owner) then
			if IsValid(self.Rocket) then
				self.Owner:SetViewEntity(self.Rocket)
			end
			self.Owner:DrawViewModel(false)
		end
	end
end

function SWEP:StopGuiding()
	if not self.IsGuidingNuke then return end
	
	self.IsGuidingNuke = false
	self.DrawReticle = false
	self.Owner:SetNWBool("DrawReticle",false)
	
	if SERVER then
		if IsValid(self.Owner) then
			self.Owner:SetViewEntity(self.Owner)
			self.Owner:DrawViewModel(true)
		end
	end
	if IsValid(self.Owner) and self.LastAng then
		self.Owner:SetEyeAngles(self.LastAng)
	end
end


function REDEEMER.AimRocket(rocket,pos)
	if not rocket then return end
	local NewAng = (pos - rocket:GetPos()):GetNormalized()
	rocket:SetAngles(NewAng:Angle())
end


function SWEP:Holster()
	self:StopGuiding()
	return true
end


function SWEP:OnRemove()
	self:StopGuiding()
	return true
end




