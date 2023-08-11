local BEACON = {}
BEACON.Name         = "Helper Square"
BEACON.DefaultOn    = false
BEACON.IsStandAlone = true

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	local baseAngle = Angle(0, 0, 0)

	self.myRelatives = {
		Vector(1, 1, 0):Normalize(),
		Vector(1, -1, 0):Normalize(),
		Vector(-1, -1, 0):Normalize(),
		Vector(-1, 1, 0):Normalize()
	}
	
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
	self.myMathPos = {}
	self.myMathBackoff = {}
	self.myMathFalloff = {}
	
end

---- StandAlone beacons don't need tagging.
-- function BEACON:ShouldTag(  )
-- end

---- StandAlone beacons don't need ents.
function BEACON:PerformMath( )
	local CVD = proxi:GetCurrentViewData()
	local refPos = EyePos() + EyeAngles():Forward() * CVD.radiuseval / CVD.baseratio_nomargin
	self.radius = CVD.radiuseval * 0.3
	
	local reference = LocalPlayer():GetPos()
	
	for k,vNormal in pairs( self.myRelatives ) do
		self.myMathPos[k] = reference + vNormal * self.radius
		
	end
	
end

function BEACON:DrawUnderCircle( )
	render.SetMaterial( self.myMaterial )
	for i = 1, #self.myRelatives do
		local a = self.myMathPos[ i ]
		local b = self.myMathPos[ (i == #self.myRelatives) and 1 or (i + 1) ]
		render.DrawBeam( a, b, self.radius / 8, 0.4, 0.6, Color( 255, 255, 255, 128 ) )
		
	end
	
end

proxi.RegisterBeacon( BEACON, "helpersquare" )
