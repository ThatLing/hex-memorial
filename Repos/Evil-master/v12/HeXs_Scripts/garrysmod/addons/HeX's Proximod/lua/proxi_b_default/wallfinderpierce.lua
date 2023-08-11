local BEACON = {}
BEACON.Name         = "Wallfinder with Piercer"
BEACON.DefaultOn    = false
BEACON.IsStandAlone = true

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	
	self.iPierceTimes  = 2
	self.iTracesPerFrame  = 3
	self.iGap  = 1/3
	
	self.iRevAngle  = 0
	self.iRevolution = 120
	
	self.tWalls = {}
	self.iWall  = 1
	self.iMaxWalls = self.iRevolution * 3
	
	for i = 1, self.iMaxWalls do
		self.tWalls[ i ] = {}
		
	end
	
	self.traceData = {}
	self.traceData.mask = CONTENTS_SOLID
	self.traceData.filter = nil
	self.traceangle = Angle( 0, 0, 0 )
	self.radius = 0
	
	self.traceRes = {}
	
	self.upNorm = Vector( 0, 0, 1 )
	
end

function BEACON:PerformMath( )
	local numTracesPerformed = 0
	for iTraceNum = 1, self.iTracesPerFrame do
		local CVD = proxi:GetCurrentViewData()
		
		self.radius = CVD.radiuseval * 1.5
		self.traceData.start = CVD.referencepos
		self.traceangle.y = ( self.iRevAngle / self.iRevolution ) * 360
		self.traceData.endpos = self.traceData.start + self.traceangle:Forward() * self.radius
		
		self.traceRes = util.TraceLine( self.traceData )
		numTracesPerformed = numTracesPerformed + 1
		if self.traceRes.Hit then
			local crossMul = self.traceRes.HitNormal:Cross( self.upNorm ) * self.radius * 0.1
			self.tWalls[ self.iWall ][1] = self.traceRes.HitPos + crossMul
			self.tWalls[ self.iWall ][2] = self.traceRes.HitPos - crossMul
			self.tWalls[ self.iWall ][3] = false
			
			-- Keep the following when something gets hit.
			//self.iWall = self.iWall + 1
			//self.iWall = ((self.iWall - 1) % self.iMaxWalls) + 1
			// is equivalent to
			self.iWall = (self.iWall % self.iMaxWalls) + 1
			
			local pierceTime = 1
			while (pierceTime <= self.iPierceTimes) and self.traceRes.Hit do
				self.traceData.start = self.traceRes.HitPos + self.traceangle:Forward()
				self.traceRes = util.TraceLine( self.traceData )
				numTracesPerformed = numTracesPerformed + 1
				if self.traceRes.Hit then
					local crossMul = self.traceRes.HitNormal:Cross( self.upNorm ) * self.radius * 0.1
					self.tWalls[ self.iWall ][1] = self.traceRes.HitPos + crossMul
					self.tWalls[ self.iWall ][2] = self.traceRes.HitPos - crossMul
					self.tWalls[ self.iWall ][3] = true
				
					self.iWall = (self.iWall % self.iMaxWalls) + 1
				end
				
				pierceTime = pierceTime + 1
				
			end
			
		end
		
		//print( "Performed ".. numTracesPerformed .." traces this frame." )
		
		--Keep the following at the end.
		self.iRevAngle = self.iRevAngle + self.iRevolution * self.iGap
		
	end
	
	self.iRevAngle = (self.iRevAngle + 1) % self.iRevolution
	
end

function BEACON:DrawUnderCircle( )
	/*for i = 1, self.iTracesPerFrame do
		render.DrawBeam( self.traceData.start, self.traceData.start + self.traceangle:Forward() * self.radius, 64, 0.5, 1, Color( 192, 128, 255, 64 ) )
		self.traceangle.y = self.traceangle.y - (1 / self.iRevolution) - self.iGap * 360
		
	end*/
	
	render.SetMaterial( self.myMaterial )
	for i = 1, self.iMaxWalls do
		if self.tWalls[ i ][1] ~= nil then
			render.DrawBeam( self.tWalls[ i ][1], self.tWalls[ i ][2], 64, 0, 1, self.tWalls[ i ][3] and Color( 255, 128, 192, 128 ) or Color( 192, 128, 255, 128 ) )
			
		end
		
	end
	
end

proxi.RegisterBeacon( BEACON, "wallfinderpierce" )
