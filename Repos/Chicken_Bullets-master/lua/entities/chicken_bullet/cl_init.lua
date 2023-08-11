

include("shared.lua")


local MIN_EMIT_SPEED = 1 

function ENT:Initialize()
	self.Emitter = ParticleEmitter( self:GetPos(), true )
	self.NextEmit = CurTime()
end

function ENT:Draw()
	self:DrawModel()
	
	-- Emit feathers
	local speed = self:GetVelocity():Length()
	if speed <= MIN_EMIT_SPEED then return end
	
	
	-- The emission rate is based on how fast we are going
	if not self.Emitter or self.NextEmit > CurTime() then return end
	self.NextEmit = CurTime() + 0.05
	
	
	local mypos = self:GetPos()
	mypos.z = mypos.z + 10
	
	self.Emitter:SetPos( mypos )
	
	local size = math.Rand(3,5)
	
	
	local particle = self.Emitter:Add("particles/feather", mypos)
		particle:SetDieTime( math.Rand(2,3) )
		particle:SetVelocity(VectorRand() * 15)
		particle:SetAirResistance(400)
		particle:SetGravity( Vector( math.Rand(-25,25), math.Rand(-25,25), -300) )
		particle:SetCollide(true)
		particle:SetBounce(0.1)
		particle:SetAngles( AngleRand() )
		particle:SetAngleVelocity(AngleRand() * 150)
		particle:SetStartAlpha(255)
		particle:SetStartSize(size)
		particle:SetEndSize(size)
	particle:SetColor(255,255,255)
end


function ENT:OnRemove()
	if self.Emitter then self.Emitter:Finish() end
end




