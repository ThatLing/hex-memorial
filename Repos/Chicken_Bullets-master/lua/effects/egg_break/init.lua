-- Egg break effect
-- By Teta_Bonita

function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()

	local emitter3D = ParticleEmitter( Pos, true )
	local emitter2D = ParticleEmitter( Pos, false )

	-- Make an expanding smoke puff facing the player
	local particle = emitter2D:Add( "particle/particle_smokegrenade", Pos )
	particle:SetDieTime( math.Rand( 0.3, 0.4 ) )
	particle:SetStartSize( 10 )
	particle:SetEndSize( math.Rand( 30, 40 ) )
	particle:SetStartAlpha( 255 )
	particle:SetColor( 200, 200, 200 )

	-- Emit egg (balloon) bits
	for i = 1,32 do
		
		local norm = Norm + VectorRand()
		norm:Normalize()
		local size = math.Rand( 1, 2.5 )
		
		local particle = emitter3D:Add( "particles/balloon_bit", Pos + norm * 3 )
		particle:SetDieTime( math.Rand( 2.5, 3.5 ) )
		particle:SetVelocity( norm * math.Rand( 150, 450 ) )
		particle:SetAirResistance( 80 )
		particle:SetGravity( Vector( 0, 0, -400 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 )
		particle:SetAngles( norm:Angle() )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( size )
		particle:SetEndSize( size )
		particle:SetColor( 255, 242, 236 )
	
	end
			
	emitter3D:Finish()
	emitter2D:Finish()

end


function EFFECT:Think()

	-- Kill instantly... this effect is only used to spawn particles on init.
	return false
	
end


function EFFECT:Render()

end

