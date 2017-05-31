
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

local matGlow = CreateMaterial("glow", "UnlitGeneric", {["$basetexture"] = "sprites/light_glow02", ["$spriterendermode"] = 3, ["$additive"] = 1, ["$vertexcolor"] = 1, ["$vertexalpha"] = 1})

include('shared.lua')

function ENT:Initialize()
	self.ArmTime = CurTime() + 1
	self.LastEmit = 0
	self.LastState = true
	self.SpriteDrawTime = 0
end

function ENT:Draw()
	local CurrentTime = CurTime()
	local Pos = self:GetPos()
	local Ang = self:GetForward()
	
	if CurrentTime > self.LastEmit + 0.02 then
		self.Armed = self:GetNWBool("armed")
		
		if self.Armed then	
			if not self.LastState then
				self.SpriteDrawTime = CurrentTime + 0.3
			end
			
			local emitter = ParticleEmitter( Pos )
				local particle = emitter:Add( "particles/smokey", Pos - Ang*32)
					particle:SetVelocity(Vector(math.Rand(-8,8),math.Rand(-8,8),math.Rand(-8,8)))
					particle:SetLifeTime( math.Rand(-0.6,0.3) )
					particle:SetDieTime( math.Rand(7,8) )
					particle:SetStartAlpha( math.Rand(60,80) )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand(15,20) )
					particle:SetEndSize( math.Rand(50,60) )
					particle:SetRoll( math.Rand(480,540) )
					particle:SetRollDelta( math.random(-1,1) )
				particle:SetColor(250,250,250)
			emitter:Finish()
		end
		
		self.LastState = self.Armed
		self.LastEmit = CurrentTime
	end
	
	local SpriteDrawTimeLeft = self.SpriteDrawTime - CurrentTime
	
	if SpriteDrawTimeLeft > 0 then
		render.SetMaterial(matGlow)
		render.DrawSprite(Pos - Ang*6,
		4800*SpriteDrawTimeLeft,3600*SpriteDrawTimeLeft,
		Color(255,240,200,800*SpriteDrawTimeLeft))	
	end
	self:DrawModel()
end


function ENT:OnRemove()
end






----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

local matGlow = CreateMaterial("glow", "UnlitGeneric", {["$basetexture"] = "sprites/light_glow02", ["$spriterendermode"] = 3, ["$additive"] = 1, ["$vertexcolor"] = 1, ["$vertexalpha"] = 1})

include('shared.lua')

function ENT:Initialize()
	self.ArmTime = CurTime() + 1
	self.LastEmit = 0
	self.LastState = true
	self.SpriteDrawTime = 0
end

function ENT:Draw()
	local CurrentTime = CurTime()
	local Pos = self:GetPos()
	local Ang = self:GetForward()
	
	if CurrentTime > self.LastEmit + 0.02 then
		self.Armed = self:GetNWBool("armed")
		
		if self.Armed then	
			if not self.LastState then
				self.SpriteDrawTime = CurrentTime + 0.3
			end
			
			local emitter = ParticleEmitter( Pos )
				local particle = emitter:Add( "particles/smokey", Pos - Ang*32)
					particle:SetVelocity(Vector(math.Rand(-8,8),math.Rand(-8,8),math.Rand(-8,8)))
					particle:SetLifeTime( math.Rand(-0.6,0.3) )
					particle:SetDieTime( math.Rand(7,8) )
					particle:SetStartAlpha( math.Rand(60,80) )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand(15,20) )
					particle:SetEndSize( math.Rand(50,60) )
					particle:SetRoll( math.Rand(480,540) )
					particle:SetRollDelta( math.random(-1,1) )
				particle:SetColor(250,250,250)
			emitter:Finish()
		end
		
		self.LastState = self.Armed
		self.LastEmit = CurrentTime
	end
	
	local SpriteDrawTimeLeft = self.SpriteDrawTime - CurrentTime
	
	if SpriteDrawTimeLeft > 0 then
		render.SetMaterial(matGlow)
		render.DrawSprite(Pos - Ang*6,
		4800*SpriteDrawTimeLeft,3600*SpriteDrawTimeLeft,
		Color(255,240,200,800*SpriteDrawTimeLeft))	
	end
	self:DrawModel()
end


function ENT:OnRemove()
end





