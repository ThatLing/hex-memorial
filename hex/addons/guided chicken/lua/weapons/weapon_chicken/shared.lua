
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")


local sndTabAttack =  {
	Sound("chicken/attack1.wav"),
	Sound("chicken/attack2.wav"),
}


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.HoldType			= "rpg"


SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModelFOV		= 64
SWEP.ViewModelFlip		= false
SWEP.CSMuzzleFlashes	= false

SWEP.PrintName			= "Cluckshot"			
SWEP.Author				= "HeX + Teta_Bonita"
SWEP.Category			= "United Hosts"
SWEP.Slot				= 4
SWEP.SlotPos			= 10


SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= "Aim away from face"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.5
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "RPG_Round"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.05
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.Rocket = SWEP.Rocket or NULL

SWEP.IsGuidingChicken = false
SWEP.DrawReticle = false
SWEP.LastAng = Vector(0,0,0)


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end


function SWEP:Deploy()
	self.Owner:SetNWBool("DrawChicken",false)
end


function SWEP:Reload()
	if self.Rocket and self.Rocket:IsValid() then return false end
	self:DefaultReload( ACT_VM_RELOAD )
end



function SWEP:Think()
	if self.IsGuidingChicken and IsValid(self.Rocket) and not self.Rocket.NoSteer then
		local PlayerAng = self.Owner:GetAimVector()
		
		self.Rocket:SetAngles( PlayerAng:Angle() )
		--self.RocketPhysObj:SetVelocity(PlayerAng * 600)
		
		local ViewEnt = self.Owner:GetViewEntity()
		
		if self.DrawReticle and ViewEnt ~= self.Rocket then
			self.DrawReticle = false
			self.Owner:SetNWBool("DrawChicken",false)
		end
		
		if not self.DrawReticle and ViewEnt == self.Rocket then
			self.DrawReticle = true
			self.Owner:SetNWBool("DrawChicken",true)
		end
		
		if ViewEnt == self.Owner or ViewEnt == NULL then
			self.Owner:SetViewEntity(self.Rocket) 
		end
		
	else
		self:StopGuiding()
	end
end


function SWEP:PrimaryAttack()
	if self.Primary.NextFire > CurTime() then 
		return
	end
	self.Primary.NextFire = CurTime() + self.Primary.Delay
	
	
	if self.IsGuidingChicken and self.Rocket and self.Rocket:IsValid() then
		self:StopGuiding()
		
		self.Rocket.StartAirburst = true
		return
	end
	
	
	if self.Owner:GetAmmoCount("RPG_Round") < 1 then return end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER and IsFirstTimePredicted() then
		self.Owner:EmitSound("chicken/chicken_tube.mp3")
		self.Owner:EmitSound( table.Random(sndTabAttack) )
	end
	
	self:TakePrimaryAmmo(1)
	
	
	if SERVER then
		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAng = self.Owner:GetAimVector()
		
		--the muzzle attachement for the rocket launcher is fucked, so we need to adjust the missile's position by hand
		local PlayerForward = self.Owner:GetForward()
		local PlayerRight = self.Owner:GetRight()
		local SpawnPos = PlayerPos + 32*PlayerForward + 32*PlayerRight
		
		local trace = {}
			trace.start 	= PlayerPos + PlayerAng*32
			trace.endpos 	= PlayerPos + PlayerAng*16384
			trace.filter 	= {self.Owner}
		local traceRes = util.TraceLine(trace)
		
		self.Rocket = ents.Create("guided_chicken")
			self.Rocket:SetPos(SpawnPos)
			self.Rocket:SetAngles( PlayerAng:Angle() )
			self.Rocket:SetPhysicsAttacker(self.Owner)
			self.Rocket:SetOwner(self.Owner)
			self.Rocket.Owner = self.Owner
			self.Rocket:Spawn()
		self.Rocket:Activate()
		
		local phys = self.Rocket:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity(PlayerAng*512 - 16*PlayerRight + Vector(0,0,256))
		end
		
		timer.Simple(0.5, function()
			if not IsValid(self.Rocket) then return end
			
			local NewAng = (traceRes.HitPos - self.Rocket:GetPos()):GetNormalized()
			self.Rocket:SetAngles( NewAng:Angle() )
		end)
	end
end


function SWEP:SecondaryAttack()
	if self.Secondary.NextFire > CurTime() then 
		return
	end
	self.Secondary.NextFire = CurTime() + self.Secondary.Delay
	
	if self.IsGuidingChicken then
		self:StopGuiding()
	else
		self:StartGuiding()
	end
end


function SWEP:StartGuiding()
	if not IsValid(self.Rocket) then return end
	if self.Rocket.NoSteer then return end
	
	
	if not self.Rocket.BeenShot then
		self.Rocket.Armed = true
	end
	
	self.LastAng = self.Owner:EyeAngles()
	self.Owner:SetEyeAngles(self.Rocket:GetAngles())
	
	self.IsGuidingChicken = true
	self.DrawReticle = true
	self.Owner:SetNWBool("DrawChicken",true)
	
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
	if not self.IsGuidingChicken then return end
	
	self.IsGuidingChicken = false
	self.DrawReticle = false
	self.Owner:SetNWBool("DrawChicken",false)
	
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


function SWEP:Holster()
	self:StopGuiding()
	return true
end


function SWEP:OnRemove()
	self:StopGuiding()
	return true
end





----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")


local sndTabAttack =  {
	Sound("chicken/attack1.wav"),
	Sound("chicken/attack2.wav"),
}


SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true
SWEP.HoldType			= "rpg"


SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModelFOV		= 64
SWEP.ViewModelFlip		= false
SWEP.CSMuzzleFlashes	= false

SWEP.PrintName			= "Cluckshot"			
SWEP.Author				= "HeX + Teta_Bonita"
SWEP.Category			= "United Hosts"
SWEP.Slot				= 4
SWEP.SlotPos			= 10


SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= "Aim away from face"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.5
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "RPG_Round"
SWEP.Primary.NextFire 		= 0

SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.05
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.NextFire 	= 0

SWEP.Rocket = SWEP.Rocket or NULL

SWEP.IsGuidingChicken = false
SWEP.DrawReticle = false
SWEP.LastAng = Vector(0,0,0)


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end


function SWEP:Deploy()
	self.Owner:SetNWBool("DrawChicken",false)
end


function SWEP:Reload()
	if self.Rocket and self.Rocket:IsValid() then return false end
	self:DefaultReload( ACT_VM_RELOAD )
end



function SWEP:Think()
	if self.IsGuidingChicken and IsValid(self.Rocket) and not self.Rocket.NoSteer then
		local PlayerAng = self.Owner:GetAimVector()
		
		self.Rocket:SetAngles( PlayerAng:Angle() )
		--self.RocketPhysObj:SetVelocity(PlayerAng * 600)
		
		local ViewEnt = self.Owner:GetViewEntity()
		
		if self.DrawReticle and ViewEnt ~= self.Rocket then
			self.DrawReticle = false
			self.Owner:SetNWBool("DrawChicken",false)
		end
		
		if not self.DrawReticle and ViewEnt == self.Rocket then
			self.DrawReticle = true
			self.Owner:SetNWBool("DrawChicken",true)
		end
		
		if ViewEnt == self.Owner or ViewEnt == NULL then
			self.Owner:SetViewEntity(self.Rocket) 
		end
		
	else
		self:StopGuiding()
	end
end


function SWEP:PrimaryAttack()
	if self.Primary.NextFire > CurTime() then 
		return
	end
	self.Primary.NextFire = CurTime() + self.Primary.Delay
	
	
	if self.IsGuidingChicken and self.Rocket and self.Rocket:IsValid() then
		self:StopGuiding()
		
		self.Rocket.StartAirburst = true
		return
	end
	
	
	if self.Owner:GetAmmoCount("RPG_Round") < 1 then return end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER and IsFirstTimePredicted() then
		self.Owner:EmitSound("chicken/chicken_tube.mp3")
		self.Owner:EmitSound( table.Random(sndTabAttack) )
	end
	
	self:TakePrimaryAmmo(1)
	
	
	if SERVER then
		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAng = self.Owner:GetAimVector()
		
		--the muzzle attachement for the rocket launcher is fucked, so we need to adjust the missile's position by hand
		local PlayerForward = self.Owner:GetForward()
		local PlayerRight = self.Owner:GetRight()
		local SpawnPos = PlayerPos + 32*PlayerForward + 32*PlayerRight
		
		local trace = {}
			trace.start 	= PlayerPos + PlayerAng*32
			trace.endpos 	= PlayerPos + PlayerAng*16384
			trace.filter 	= {self.Owner}
		local traceRes = util.TraceLine(trace)
		
		self.Rocket = ents.Create("guided_chicken")
			self.Rocket:SetPos(SpawnPos)
			self.Rocket:SetAngles( PlayerAng:Angle() )
			self.Rocket:SetPhysicsAttacker(self.Owner)
			self.Rocket:SetOwner(self.Owner)
			self.Rocket.Owner = self.Owner
			self.Rocket:Spawn()
		self.Rocket:Activate()
		
		local phys = self.Rocket:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity(PlayerAng*512 - 16*PlayerRight + Vector(0,0,256))
		end
		
		timer.Simple(0.5, function()
			if not IsValid(self.Rocket) then return end
			
			local NewAng = (traceRes.HitPos - self.Rocket:GetPos()):GetNormalized()
			self.Rocket:SetAngles( NewAng:Angle() )
		end)
	end
end


function SWEP:SecondaryAttack()
	if self.Secondary.NextFire > CurTime() then 
		return
	end
	self.Secondary.NextFire = CurTime() + self.Secondary.Delay
	
	if self.IsGuidingChicken then
		self:StopGuiding()
	else
		self:StartGuiding()
	end
end


function SWEP:StartGuiding()
	if not IsValid(self.Rocket) then return end
	if self.Rocket.NoSteer then return end
	
	
	if not self.Rocket.BeenShot then
		self.Rocket.Armed = true
	end
	
	self.LastAng = self.Owner:EyeAngles()
	self.Owner:SetEyeAngles(self.Rocket:GetAngles())
	
	self.IsGuidingChicken = true
	self.DrawReticle = true
	self.Owner:SetNWBool("DrawChicken",true)
	
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
	if not self.IsGuidingChicken then return end
	
	self.IsGuidingChicken = false
	self.DrawReticle = false
	self.Owner:SetNWBool("DrawChicken",false)
	
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


function SWEP:Holster()
	self:StopGuiding()
	return true
end


function SWEP:OnRemove()
	self:StopGuiding()
	return true
end




