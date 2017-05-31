
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

function EFFECT:Init(d)
	self.Pos 	= d:GetOrigin()
	self.Size 	= 500
	
	local dist = LocalPlayer():GetPos():Distance( self.Pos )
	
	if dist < 500 then
		local scale = 1 - ( dist / 500 )
		
		ViewWobble = math.Clamp( scale * 1.0, 0.5, 1.0 )
		MotionBlur = math.Clamp( scale * 1.0, 0.5, 1.0 )
		Sharpen = scale * 5.5
		--ColorModify[ "$pp_colour_mulb" ] = scale * 3.5
		--ColorModify[ "$pp_colour_brightness" ] = scale 
	end
	
	self.Refract = 0
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,60 do
		local particle = emitter:Add( "effects/blueflare1", self.Pos )
		particle:SetStartSize( math.Rand(3,5) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(1,5) )
		particle:SetVelocity( VectorRand( ) * 300 )
		
		particle:SetAirResistance( 0 )
		particle:SetBounce(1.0)
		particle:SetGravity( Vector( 0, 0, math.random(-150,0) ) )
		particle:SetCollide(true)
	end
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self:EntIndex() )
	
	if dlight then
		dlight.Pos = self:GetPos()
		dlight.r = 200
		dlight.g = 200
		dlight.b = 220
		dlight.Brightness = 4 * math.Rand( 1.0, 1.2 )
		dlight.Decay = 1024
		dlight.size = 1024 * math.Rand( 0.8, 1.0 )
		dlight.DieTime = CurTime() + 1
	end
end

function EFFECT:Think()
	self.Refract = self.Refract + 1.5 * FrameTime()
	self.Size = 500 * self.Refract ^ 0.2
	
	if self.Refract >= 1 then 
		return false 
	end
	
	return true
end



--Material("effects/yellowflare")
local matRefraction	= CreateMaterial("yellowflare2", "UnlitGeneric", {
		["$basetexture"] 	= "effects/yellowflare",
		["$additive"] 		= 1,
		["$vertexcolor"] 	= 1,
		["$vertexalpha"] 	= 1,
	}
)



function EFFECT:Render()
	local Distance = EyePos():Distance( self:GetPos() )
	local Pos = self:GetPos() + (EyePos()-self:GetPos()):GetNormal() * Distance * (self.Refract^(0.3)) * 0.8
	
	matRefraction:SetFloat("$refractamount", math.sin(self.Refract * math.pi) * 0.1)
	
	render.SetMaterial(matRefraction)
		render.UpdateRefractTexture()
	render.DrawSprite(Pos, self.Size, self.Size, color_white)
end













----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------

function EFFECT:Init(d)
	self.Pos 	= d:GetOrigin()
	self.Size 	= 500
	
	local dist = LocalPlayer():GetPos():Distance( self.Pos )
	
	if dist < 500 then
		local scale = 1 - ( dist / 500 )
		
		ViewWobble = math.Clamp( scale * 1.0, 0.5, 1.0 )
		MotionBlur = math.Clamp( scale * 1.0, 0.5, 1.0 )
		Sharpen = scale * 5.5
		--ColorModify[ "$pp_colour_mulb" ] = scale * 3.5
		--ColorModify[ "$pp_colour_brightness" ] = scale 
	end
	
	self.Refract = 0
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,60 do
		local particle = emitter:Add( "effects/blueflare1", self.Pos )
		particle:SetStartSize( math.Rand(3,5) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(1,5) )
		particle:SetVelocity( VectorRand( ) * 300 )
		
		particle:SetAirResistance( 0 )
		particle:SetBounce(1.0)
		particle:SetGravity( Vector( 0, 0, math.random(-150,0) ) )
		particle:SetCollide(true)
	end
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self:EntIndex() )
	
	if dlight then
		dlight.Pos = self:GetPos()
		dlight.r = 200
		dlight.g = 200
		dlight.b = 220
		dlight.Brightness = 4 * math.Rand( 1.0, 1.2 )
		dlight.Decay = 1024
		dlight.size = 1024 * math.Rand( 0.8, 1.0 )
		dlight.DieTime = CurTime() + 1
	end
end

function EFFECT:Think()
	self.Refract = self.Refract + 1.5 * FrameTime()
	self.Size = 500 * self.Refract ^ 0.2
	
	if self.Refract >= 1 then 
		return false 
	end
	
	return true
end



--Material("effects/yellowflare")
local matRefraction	= CreateMaterial("yellowflare2", "UnlitGeneric", {
		["$basetexture"] 	= "effects/yellowflare",
		["$additive"] 		= 1,
		["$vertexcolor"] 	= 1,
		["$vertexalpha"] 	= 1,
	}
)



function EFFECT:Render()
	local Distance = EyePos():Distance( self:GetPos() )
	local Pos = self:GetPos() + (EyePos()-self:GetPos()):GetNormal() * Distance * (self.Refract^(0.3)) * 0.8
	
	matRefraction:SetFloat("$refractamount", math.sin(self.Refract * math.pi) * 0.1)
	
	render.SetMaterial(matRefraction)
		render.UpdateRefractTexture()
	render.DrawSprite(Pos, self.Size, self.Size, color_white)
end












