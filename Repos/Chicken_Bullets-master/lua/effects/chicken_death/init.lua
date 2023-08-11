-- Chicken explosion effect
-- By Teta_Bonita

function EFFECT:Init( data )
	
	local Pos = data:GetOrigin()
	--Pos.z = Pos.z + 10

	local emitter3D = ParticleEmitter( Pos, true )
	local emitter2D = ParticleEmitter( Pos, false )

	-- Make an expanding blood puff facing the player
	local particle = emitter2D:Add( "effects/blood_core", Pos )
	particle:SetDieTime( math.Rand( 0.5, 0.6 ) )
	particle:SetStartSize( 25 )
	particle:SetEndSize( math.Rand( 60, 80 ) )
	particle:SetStartAlpha( math.Rand( 200, 230 ) )
	particle:SetColor( 220, 20, 30 )

	-- Shoot blood drops
	for i = 1,8 do
		
		local norm = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -0.3, 1 ) ):GetNormalized()
		
		local particle = emitter2D:Add( "effects/blood2", Pos + norm * 5 )
		particle:SetDieTime( math.Rand( 0.8, 1 ) )
		particle:SetVelocity( norm * math.Rand( 150, 200 ) )
		particle:SetAirResistance( 80 )
		particle:SetGravity( Vector( 0, 0, -400 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.7 )
		particle:SetStartSize( 1 )
		particle:SetEndSize( 2 )
		particle:SetStartLength( math.Rand( 8, 14 ) )
		particle:SetEndLength( math.Rand( 12, 18 ) )
		particle:SetStartAlpha( math.Rand( 200, 230 ) )
		particle:SetColor( 220, 20, 30 )
			
	end

	-- Emit feathers
	for i = 1,32 do
		
		local norm = Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -0.3, 1 ) ):GetNormalized()
		local size = math.Rand( 3, 5 )
		
		local particle = emitter3D:Add( "particles/feather", Pos + norm * 3 )
		particle:SetDieTime( math.Rand( 3.5, 4.5 ) )
		particle:SetVelocity( norm * math.Rand( 250, 500 ) )
		particle:SetAirResistance( 350 )
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

