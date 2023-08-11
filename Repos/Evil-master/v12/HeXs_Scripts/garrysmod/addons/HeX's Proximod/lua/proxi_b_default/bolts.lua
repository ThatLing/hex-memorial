local BEACON = {}
BEACON.Name         = "Bolts"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

BEACON.Description = "Shows Crossbow bolts, their travel direction and a rough hit prediction."

function BEACON:Load()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
end

function BEACON:ShouldTag( entity )
	return entity:GetClass() == "crossbow_bolt"
	
end

function BEACON:PerformMath( ent )
	if not self.myMathPool[ ent ] then
		self.myMathPool[ ent ] = {}
	end
	local thisMathPool = self.myMathPool[ ent ]
	
	proxi:ProjectPosition( thisMathPool, ent:GetPos() )		
	proxi:GetFalloff( thisMathPool, 256 )
	proxi:GetConeProjectedPosition( thisMathPool )
	
end

function BEACON:DrawUnderCircle( ent )
	local thisMathPool = self.myMathPool[ ent ]
	local cfP, cfAP = thisMathPool.closeFalloff ^ 2, proxi_util.PercentCharge( thisMathPool.closeFalloff )
	
	if not thisMathPool.tracedata then
		thisMathPool.tracedata = {}
		thisMathPool.tracedata.filter = ent
		
		thisMathPool.traceres = {}
		
	end
	
	thisMathPool.tracedata.start = thisMathPool.posToProj
	thisMathPool.tracedata.endpos = thisMathPool.posToProj + ent:GetVelocity():Normalize() * 16384
	thisMathPool.traceres = util.TraceLine( thisMathPool.tracedata )
	
	render.SetMaterial( self.myMaterial )
	--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + ent:GetVelocity() * 2, 32, 0.5, 1, Color( 255, 255, 0, 255 ) )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj - ent:GetVelocity() * 0.5, 32, 0.5, 1, Color( 255, 0, 0, 128 ) )
	render.DrawSprite( thisMathPool.conePos, 128, 128, Color( 255, 255, 0, 255 ) ) ////
	
	render.DrawSprite( thisMathPool.traceres.HitPos, 256, 256, Color( 255, 255, 255, 255 ) ) ////
	
end

proxi.RegisterBeacon( BEACON, "bolts" )
