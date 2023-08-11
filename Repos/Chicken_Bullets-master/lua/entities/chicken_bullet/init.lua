
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local sndTabPain =  {
	Sound("chicken/pain1.wav"),
	Sound("chicken/pain2.wav"),
	Sound("chicken/pain3.wav"),
}


local sndTabIdle = {
	Sound("chicken/idle1.wav"),
	Sound("chicken/idle2.wav"),
	Sound("chicken/idle3.wav"),
}


function ENT:Initialize()
	self:SetModel("models/lduke/chicken/chicken3.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)	
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetGravity(0.005)
	
	self.PhysObj = self:GetPhysicsObject()
	if self.PhysObj:IsValid() then
		self.PhysObj:SetMass(1)
		self.PhysObj:SetDamping(0,0)
		self.PhysObj:Wake()
		self.PhysObj:EnableGravity(true)
	end
	
	self.IsChicken = true
	self.ChickenHealth	= 10
	self.NextEmitIdle 	= self.NextEmitIdle or CurTime()
	
	timer.Simple(10, function()
		if self and self.Detonate then
			self:Detonate()
		end
	end)
end



function ENT:Detonate()
	if not IsValid(self) then return end
	self.ChickenHealth = 100
	
	local effect = EffectData()
		effect:SetOrigin( self:GetPos() )
	util.Effect("chicken_death", effect)
	
	--[[local boom = ents.Create("env_explosion")
		boom:SetPos( self:GetPos() )
		boom:SetOwner( self.Owner )
		boom:Spawn()
		boom:SetKeyValue("iMagnitude", "0")
	boom:Fire("Explode",0,0)]]
	
	self:EmitSound( Sound("chicken/death.wav") )
	
	//Random chance of egg!
	if self.Eggs and math.random(0,1) == 1 then
		local Nade = ents.Create("prop_physics")
			Nade:SetModel("models/props_phx/misc/egg.mdl")
			local Pos = self:GetPos()
			Pos.z = Pos.z - 4
			
			Nade.IsChicken = true
			Nade:SetPos(Pos)
			Nade:SetAngles( self:GetAngles() )
			Nade:SetMaterial("models/shiny")
			Nade:SetHealth(200)
			
			if IsValid(self.Owner) then
				Nade:SetOwner(self.Owner)
				Nade.Owner = self.Owner
				Nade:SetPhysicsAttacker(self.Owner)
			end
		Nade:Spawn()
		
		//Break
		Nade:CallOnRemove("EggBreak", function()
			if not IsValid(Nade) then return end
			
			Nade:EmitSound("phx/eggcrack.wav", 500, math.random(100,150) )
			
			local effect = EffectData()
				effect:SetOrigin( Nade:GetPos() )
				effect:SetNormal( Vector(0,0,1) )
			util.Effect("egg_break", effect)
		end)
		
		//Remove egg if not broken
		timer.Simple(10, function()
			if IsValid(Nade) then
				Nade:Remove()
			end
		end)
		
		//Cluck!
		self:EmitSound( Sound("chicken/alert.wav") )
	end
	
	self:StopSounds()
	self:Remove()
end


function ENT:PhysicsCollide(data,physobj)
	if not IsValid(self) then return end
	if IsValid(data.HitEntity) and data.HitEntity.IsChicken then return end
	if not self.Bullet then return end
	
	local Owner = self.Owner
	self:Detonate()
	
	if IsValid(Owner) then
		local Bul = {
			Src			= self:GetPos(),
			Dir			= self:GetForward(),
			Damage 		= self.Bullet.Damage,
			Force 		= self.Bullet.Force,
			Callback 	= self.Bullet.Callback,
			Spread		= 0,
			Num			= 1,
			Tracer		= 0,
			TracerName	= "Pistol",
		}
		
		self:Remove()
		Owner.CanFireChickenBullet 	= true
		Owner:FireBullets(Bul)
		return
	end
	
	self:Remove()
end



function ENT:OnTakeDamage(info)
	self.IsTakingDamage = true
	timer.Create(tostring(self), 0.56, 1, function()
		if IsValid(self) then
			self.IsTakingDamage = false
		end
	end)
	
	self.ChickenHealth = self.ChickenHealth - info:GetDamage()
	
	
	local dmgpos = info:GetDamagePosition()
	
	if dmgpos == Vector(0,0,0) then 
		dmgpos = self:GetPos()
		dmgpos.z = dmgpos.z + 10
	end
	local effect = EffectData()
		effect:SetOrigin(dmgpos)
	util.Effect("chicken_pain", effect)
	
	self:EmitSound( table.Random(sndTabPain) )
	
	
	if self.ChickenHealth > 0 then return end --Still has health
	self.ChickenHealth	= 100
	
	
	if IsValid(self.PhysObj) then
		self.PhysObj:SetMass(1400)
		self.PhysObj:EnableGravity(true)
		
		local OldVel = self.PhysObj:GetVelocity()
		self.PhysObj:AddVelocity(OldVel / 2)
		self.PhysObj:SetVelocity(OldVel / 2)
	end
	
	self:TakePhysicsDamage(info)
end



function ENT:Think()
	if not IsValid(self) then return end
	if self:WaterLevel() > 0 and not self.WaterExploding then
		self.WaterExploding = true
		
		timer.Simple(0.7, function()
			if IsValid(self) then
				self:Detonate()
			end
		end)
		
		return
	end
	
	
	if CurTime() > self.NextEmitIdle then
		self.NextEmitIdle = CurTime() + 1
		
		if not self.IsTakingDamage then
			self:EmitSound(table.Random(sndTabIdle), 120, 100)
		end
	end
end


function ENT:OnRemove()
	if not IsValid(self) then return end
	self:StopSounds()
end


function ENT:StopSounds()
	for k,v in pairs(sndTabIdle) do
		self:StopSound(v)
	end
	
	self:EmitSound( Sound("ambient/_period.wav") )
end

















