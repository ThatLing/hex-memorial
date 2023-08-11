local BEACON = {}
BEACON.Name         = "Nades"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = true
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
end

function BEACON:ShouldTag( entity )
	return entity:GetClass() == "npc_grenade_frag"
	
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
	
	render.SetMaterial( self.myMaterial )
	
	for i=1,10 do
		render.DrawBeam( thisMathPool.conePos, thisMathPool.conePos - ent:GetVelocity() + VectorRand() * 128, 32, 0.5, 1, Color( 255, 0, 0, 128 * cfP ) )
	end
	render.DrawSprite( thisMathPool.conePos, 256 + 128 * math.sin( CurTime() * math.pi * 2 * 3 ), 256 + 128 * math.sin( CurTime() * math.pi * 2 * 3 ), Color( 255, 0, 0, 255 * cfP ) ) ////
	
end

proxi.RegisterBeacon( BEACON, "nades" )
