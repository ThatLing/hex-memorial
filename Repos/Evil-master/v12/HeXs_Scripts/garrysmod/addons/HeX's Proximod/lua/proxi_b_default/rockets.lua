local BEACON = {}
BEACON.Name         = "Rockets"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = true
BEACON.DefaultBypassDistance = true

function BEACON:Load()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
end

function BEACON:ShouldTag( entity )
	return entity:GetClass() == "rpg_missile"
	
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
	thisMathPool.tracedata.endpos = thisMathPool.posToProj + ent:GetVelocity():Normalize() * 1024
	thisMathPool.traceres = util.TraceLine( thisMathPool.tracedata )
	
	render.SetMaterial( self.myMaterial )
	--render.DrawSprite( thisMathPool.posToProj, 32, 32, Color( 255, 255, 255, 255 ) )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + ent:GetVelocity() * 2, 64, 0.5, 1, Color( 255, 255, 255, 255 ) )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj - ent:GetVelocity() * 0.5, 64, 0.5, 1, Color( 255, 0, 0, 128 ) )
	render.DrawSprite( thisMathPool.conePos, 256, 256, Color( 255, 0, 0, 255 ) ) ////
	
	for i=1,10 do
		render.DrawBeam( thisMathPool.traceres.HitPos, thisMathPool.traceres.HitPos + VectorRand() * 256 + thisMathPool.traceres.HitNormal * 512, 32, 0.5, 1, Color( 255, 255, 0, 128 ) )
	end
	render.DrawSprite( thisMathPool.traceres.HitPos, 256, 256, Color( 255, 255, 0, 255 ) ) ////
	
end

/*
function BEACON:DrawUnderCircle2D( ent )
	local thisMathPool = self.myMathPool[ ent ]
	if thisMathPool.ratioClamped == 1 then return end
	
	local pos = ent:GetPos()	
	local x,y = proxi:ConvertPosToScreen( pos, 0, 0.1 )
	draw.SimpleText(  "  " .. ent:GetClass(), "ScoreboardText", x, y, Color( 255, 255, 255, 255 * (1 - thisMathPool.ratioClamped ^ 5) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	x,y = proxi:ConvertPosToScreen( thisMathPool.traceres.HitPos, 0, 0 )
	draw.SimpleText(  "  < EXPLOSION", "ScoreboardText", x, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end*/

proxi.RegisterBeacon( BEACON, "rockets" )
