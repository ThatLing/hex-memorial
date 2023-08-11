local BEACON = {}
BEACON.HOOK = {}
BEACON.Name         = "Chat"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = true

BEACON.CanBypassDistance     = false
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myTriangle    = surface.GetTextureID( "proxi/beacon_bigcircle_antinoy_add" )
	
	self.myThread = {}
	self.beaconTime = 5
	
end

function BEACON.HOOK:OnPlayerChat( ply, sText, bIsTeam, bIsDead )
	table.insert( self.myThread, { {}, ply:GetPos(), team.GetColor( ply:Team() ), bIsTeam, CurTime() } )
	
end

function BEACON:PerformMath( )
	local i = 1
	while i <= #self.myThread do
		local obj = self.myThread[ i ]
		if CurTime() > (obj[ 5 ] + self.beaconTime) then
			table.remove( self.myThread, i )
			
		else
			local thisMathPool = obj[ 1 ]
			
			proxi:ProjectPosition( thisMathPool, obj[ 2 ] )		
			proxi:GetFalloff( thisMathPool, 256 )
			proxi:GetConeProjectedPosition( thisMathPool )
			
		end
		i = i + 1
		
	end
	
end

function BEACON:DrawUnderCircle2D( ent )	
	for k,obj in pairs( self.myThread ) do
		local thisMathPool = obj[ 1 ]
		
		local x, y       = proxi:ConvertPosToScreen( thisMathPool.conePos )
		
		obj[ 3 ].a = (1 - ((CurTime() - obj[ 5 ]) / self.beaconTime) ^ 2) * 128
		
		local iSize = 24 * proxi:GetPinScale() * (1 + ((CurTime() - obj[ 5 ]) * 1.5) % 1)
		surface.SetTexture( self.myTriangle )
		surface.SetDrawColor( obj[ 3 ] )
		surface.DrawTexturedRectRotated( x, y, iSize, iSize, 0 )
		
	end
	
end

proxi.RegisterBeacon( BEACON, "chat" )
