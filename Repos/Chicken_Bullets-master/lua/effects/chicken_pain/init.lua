-- Chicken pain effect
-- By Teta_Bonita

function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()

	local emitter3D = ParticleEmitter( Pos, true )
	local emitter2D = ParticleEmitter( Pos, false )

	-- Make an expanding blood puff facing the player
	local particle = emitter2D:Add( "effects/blood2", Pos )
	particle:SetDieTime( math.Rand( 0.2, 0.4 ) )
	particle:SetStartSize( 3 )
	particle:SetEndSize( math.Rand( 8, 12 ) )
	particle:SetStartAlpha( 255 )
	particle:SetColor( 220, 20, 30 )

	-- Emit feathers
	for i = 1,32 do
		
		local norm = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -0.3, 1 ) ):GetNormalized()
		local size = math.Rand( 3, 5 )
		
		local particle = emitter3D:Add( "particles/feather", Pos + norm * 3 )
		particle:SetDieTime( math.Rand( 2, 2.5 ) )
		particle:SetVelocity( norm * math.Rand( 150, 300 ) )
		particle:SetAirResistance( 400 )
		particle:SetGravity( Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), -300 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.1 )
		particle:SetAngles( AngleRand() )
		particle:SetAngleVelocity( AngleRand() * 150 )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( size )
		particle:SetEndSize( size )
		particle:SetColor( 255, 255, 255 )
	
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

