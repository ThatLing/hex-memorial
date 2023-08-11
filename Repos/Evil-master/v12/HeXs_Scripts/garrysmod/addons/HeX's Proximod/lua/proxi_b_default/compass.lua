local BEACON = {}
BEACON.Name         = "Compass"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = true

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	local baseAngle = Angle(0, 0, 0)

	self.myNormals = {}
	self.myMathPos = {}
	self.myMathBackoff = {}
	self.myMathFalloff = {}
	for i = 0, 359, 45 do
		baseAngle.y = i
		self.myNormals[i] = baseAngle:Forward()
		self.myMathPos[i] = Vector(0,0,0)
		self.myMathBackoff[i] = Vector(0,0,0)
		self.myMathFalloff[i] = 0
		
	end
	
	self.myMathPool = {}
	
	
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
	self.Names = {}
	self.Names[0] = "E"
	self.Names[90] = "N"
	self.Names[180] = "W"
	self.Names[270] = "S"
end

---- StandAlone beacons don't need tagging.
-- function BEACON:ShouldTag(  )
-- end

---- StandAlone beacons don't need ents.
function BEACON:PerformMath( )
	local CVD = proxi:GetCurrentViewData()
	local refPos = EyePos() + EyeAngles():Forward() * CVD.radiuseval / CVD.baseratio_nomargin
	self.radius = CVD.radiuseval * 0.7
	
	for iAng,vNorm in pairs( self.myNormals ) do
		proxi:ProjectPosition( self.myMathPool, refPos + vNorm * self.radius )
		self.myMathPos[iAng]     = proxi:GetConeProjectedPosition( self.myMathPool )
		self.myMathBackoff[iAng] = self.myMathPos[iAng] - vNorm * self.radius * 0.1
		self.myMathFalloff[iAng]    = proxi:GetFalloff( self.myMathPool, 128 ) ^ 4
		
	end
	
end

function BEACON:DrawUnderCircle( )
	render.SetMaterial( self.myMaterial )
	for iAng,vNorm in pairs( self.myNormals ) do
		render.DrawBeam( self.myMathPos[iAng], self.myMathBackoff[iAng], self.radius / 64, 0.5, 1, Color( 255, 255, 255, 255 * self.myMathFalloff[iAng] ) )
		
	end
	
end


function BEACON:DrawUnderCircle2D( )
	for iAng,sName in pairs( self.Names ) do
		local x, y = proxi:ConvertPosToScreen( self.myMathBackoff[iAng] )
		draw.SimpleText( sName, "DefaultSmall", x+1, y+1, Color( 0, 0, 0, 255 * self.myMathFalloff[iAng] ^ 2 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( sName, "DefaultSmall", x, y, Color( 255, 255, 255, 255 * self.myMathFalloff[iAng] ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
end

proxi.RegisterBeacon( BEACON, "compass" )
