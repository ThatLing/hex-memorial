
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	if self.Ent == nil or self.Ent == NULL or not self.Ent:IsValid() then return end
	self.Emitter = ParticleEmitter(self.Ent:GetPos())
	self.CreationTime = CurTime()

end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think()
	if self.Emitter then
		if not self.Ent or not self.Ent:IsValid() then
			self.Emitter:Finish()
			return false
		end
		
		for i=0, 5 do
			local particle = self.Emitter:Add("effects/spark", self.Ent:GetPos() + VectorRand() * 30 + Vector(0,0,math.random(5,90)) )
			particle:SetVelocity( VectorRand() * 80 )
			particle:SetColor( math.random(10,250), math.random(10,250), math.random(10,250), 250 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetStartAlpha( math.Rand( 150, 250 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(1,3) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
					
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, -500 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )
		end
		
		if( self.CreationTime + 10 <= CurTime() ) then
			return false
		end
		
		return true
	end
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end


----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	if self.Ent == nil or self.Ent == NULL or not self.Ent:IsValid() then return end
	self.Emitter = ParticleEmitter(self.Ent:GetPos())
	self.CreationTime = CurTime()

end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think()
	if self.Emitter then
		if not self.Ent or not self.Ent:IsValid() then
			self.Emitter:Finish()
			return false
		end
		
		for i=0, 5 do
			local particle = self.Emitter:Add("effects/spark", self.Ent:GetPos() + VectorRand() * 30 + Vector(0,0,math.random(5,90)) )
			particle:SetVelocity( VectorRand() * 80 )
			particle:SetColor( math.random(10,250), math.random(10,250), math.random(10,250), 250 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetStartAlpha( math.Rand( 150, 250 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(1,3) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )
					
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, -500 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )
		end
		
		if( self.CreationTime + 10 <= CurTime() ) then
			return false
		end
		
		return true
	end
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

