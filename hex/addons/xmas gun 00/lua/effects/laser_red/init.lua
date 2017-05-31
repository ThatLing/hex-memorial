
----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


EFFECT.Mat = Material("sprites/bluelaser1")

function EFFECT:Init(data)
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 12
	self.Divider = 1.11
	self.Dir = (self.EndPosition - self.StartPosition)
	self.Dir:Normalize()
	
	local owner = data:GetEntity().Owner
	local view = owner == LocalPlayer()
	
	-- If it's the local player we start at the viewmodel
	if ( view ) then
	
		local vm = owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment(1)
		if not attachment then return end
		self.StartPosition = attachment.Pos
	
	else
	-- If we're viewing another player we start at their weapon
	
		local vm = owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment(1)
		if not attachment then return end
		self.StartPosition = attachment.Pos

	end
	
	self:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,6 do
			
		local particle = self.Emitter:Add( "effects/blueflare1", self.StartPosition + self.Dir * i ) 
 		 
	 	particle:SetVelocity( Vector(0,0,0) ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( 1 ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( 6 - i ) 
	 	particle:SetEndSize( 0 ) 
	 	particle:SetColor( 255,0,0 ) 
			
		particle:SetAirResistance( 250 )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide( false )
		
		for i=1,3 do
			
			local particle = self.Emitter:Add( "effects/spark", self.EndPosition ) 
	 		 
		 	particle:SetVelocity( self.Dir * math.random(-200,-100) + VectorRand() * 50 ) 
		 	particle:SetLifeTime( 0 ) 
		 	particle:SetDieTime( math.Rand(2.2,2.8) ) 
		 	particle:SetStartAlpha( 255 ) 
		 	particle:SetEndAlpha( 0 ) 
		 	particle:SetStartSize( math.random(1,3) ) 
		 	particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-100, 100) )
		 	particle:SetColor( 255,0,0 ) 
				
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, -200 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.8 )
			
		end
			
	end
	
	self.Emitter:Finish()
	
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		return false
	end
	
	self.Thick = self.Thick / self.Divider

	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPosition, self.EndPosition, self.Thick, 0, 0, Color( 255, 0, 0, 255 ) )
end

----------------------------------------
--         2014-07-12 20:33:17          --
------------------------------------------


EFFECT.Mat = Material("sprites/bluelaser1")

function EFFECT:Init(data)
	self.StartPosition 	= data:GetStart()
	self.EndPosition	= data:GetOrigin()
	self.Thick = 12
	self.Divider = 1.11
	self.Dir = (self.EndPosition - self.StartPosition)
	self.Dir:Normalize()
	
	local owner = data:GetEntity().Owner
	local view = owner == LocalPlayer()
	
	-- If it's the local player we start at the viewmodel
	if ( view ) then
	
		local vm = owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment(1)
		if not attachment then return end
		self.StartPosition = attachment.Pos
	
	else
	-- If we're viewing another player we start at their weapon
	
		local vm = owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment(1)
		if not attachment then return end
		self.StartPosition = attachment.Pos

	end
	
	self:SetRenderBoundsWS( self.EndPosition, self.StartPosition )
	
	self.Emitter = ParticleEmitter( self.StartPosition )
	
	for i=1,6 do
			
		local particle = self.Emitter:Add( "effects/blueflare1", self.StartPosition + self.Dir * i ) 
 		 
	 	particle:SetVelocity( Vector(0,0,0) ) 
	 	particle:SetLifeTime( 0 ) 
	 	particle:SetDieTime( 1 ) 
	 	particle:SetStartAlpha( 255 ) 
	 	particle:SetEndAlpha( 0 ) 
	 	particle:SetStartSize( 6 - i ) 
	 	particle:SetEndSize( 0 ) 
	 	particle:SetColor( 255,0,0 ) 
			
		particle:SetAirResistance( 250 )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide( false )
		
		for i=1,3 do
			
			local particle = self.Emitter:Add( "effects/spark", self.EndPosition ) 
	 		 
		 	particle:SetVelocity( self.Dir * math.random(-200,-100) + VectorRand() * 50 ) 
		 	particle:SetLifeTime( 0 ) 
		 	particle:SetDieTime( math.Rand(2.2,2.8) ) 
		 	particle:SetStartAlpha( 255 ) 
		 	particle:SetEndAlpha( 0 ) 
		 	particle:SetStartSize( math.random(1,3) ) 
		 	particle:SetEndSize( 0 ) 
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-100, 100) )
		 	particle:SetColor( 255,0,0 ) 
				
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, -200 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.8 )
			
		end
			
	end
	
	self.Emitter:Finish()
	
end

function EFFECT:Think()
	if self.Thick < 0.05 then
		return false
	end
	
	self.Thick = self.Thick / self.Divider

	return true
end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPosition, self.EndPosition, self.Thick, 0, 0, Color( 255, 0, 0, 255 ) )
end
