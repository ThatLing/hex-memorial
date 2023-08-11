local BEACON = {}
BEACON.Name         = "Player LOS"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = true
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_cone_rev" )
	self.myOtherMaterial = Material( "proxi/beacon_circle" )
	self.myBeamMaterial = Material( "proxi/beacon_flare_add" )
	
end

function BEACON:ShouldTag( entity )
	return entity:IsPlayer()
	
end
function BEACON:DrawUnderCircle( ent )
	local CVD = proxi:GetCurrentViewData()
	local refValue = math.Clamp( CVD.radiuseval / CVD.baseratio_nomargin, 1, 2 )

	local cute = ent:GetAimVector():Dot( EyeAngles():Forward() )
	local acute = math.abs( cute )
	local acutePA = 1 - acute ^ 2
	local acutePP = acute ^ 4
	
	render.SetMaterial( self.myMaterial )
	render.DrawBeam( ent:GetShootPos(), ent:GetShootPos() + ent:GetAimVector() * 256 * refValue, 256 * refValue, 0.5, 1, Color( 255, 255, 255, 128 * acutePA ) )

	render.SetMaterial( self.myOtherMaterial )
	render.DrawSprite( ent:GetShootPos() + ent:GetAimVector() * 256 * refValue, 192 * refValue, 192 * refValue, Color( 255, 255, 255, 64 * acutePP ) )
	
	render.SetMaterial( self.myBeamMaterial )
	render.DrawBeam( ent:GetShootPos(), ent:GetShootPos() + ent:GetAimVector() * 512 * refValue, 32 * refValue, 0.5, 1, Color( 255, 255, 255, 128 * acutePP ) )
	
	if cute < 0 then
		render.DrawSprite( ent:GetShootPos(), 192 * refValue, 192 * refValue, Color( 255, 255, 255, 128 * acutePP ) )
	end
		
	
end

proxi.RegisterBeacon( BEACON, "playerlos" )
