local BEACON = {}
BEACON.HOOK = {}
BEACON.Name         = "Voice Chat"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMaterial    = surface.GetTextureID( "proxi/beacon_circle_add" )	
	self.beaconTime = 1
	
	self.myPlayerBase = {}
	
end


function BEACON:ShouldTag( entity )
	return entity:IsPlayer()
	
end

function BEACON:PerformMath( entity )
	if entity:IsSpeaking() then
		if self.myPlayerBase[ entity ] == nil then
			self.myPlayerBase[ entity ] = { false, {}, nil, nil, 0}
		end
		
		if self.myPlayerBase[ entity ][ 5 ] < CurTime() then
			self.myPlayerBase[ entity ][ 1 ] = true			
			self.myPlayerBase[ entity ][ 3 ] = entity:GetPos()
			self.myPlayerBase[ entity ][ 4 ] = team.GetColor( entity:Team() )
			self.myPlayerBase[ entity ][ 5 ] = CurTime() + self.beaconTime
			
		end
		
	end
	
	local obj = self.myPlayerBase[ entity ]
	if obj and obj[ 1 ] then
		local thisMathPool = obj[ 2 ]
				
		proxi:ProjectPosition( thisMathPool, obj[ 3 ] )		
		proxi:GetFalloff( thisMathPool, 256 )
		proxi:GetConeProjectedPosition( thisMathPool )
		
		if obj[ 5 ] < CurTime() then
			obj[ 1 ] = false
			
		end
		
	end
	
end

function BEACON:DrawUnderCircle2D( ent )	
	local obj = self.myPlayerBase[ ent ]
	if obj and obj[ 1 ] then
		local thisMathPool = obj[ 2 ]
		
		local x, y       = proxi:ConvertPosToScreen( thisMathPool.conePos )
		
		obj[ 4 ].a = (1 - ((CurTime() - obj[ 5 ] + self.beaconTime) / self.beaconTime) ^ 2) * 128
		
		local iSize = 24 * proxi:GetPinScale() * (1 + ((CurTime() - obj[ 5 ]) * 2) % 1)
		surface.SetTexture( self.myMaterial )
		surface.SetDrawColor( obj[ 4 ] )
		surface.DrawTexturedRectRotated( x, y, iSize, iSize, 0 )
		
	end
	
end

proxi.RegisterBeacon( BEACON, "voicechat" )
