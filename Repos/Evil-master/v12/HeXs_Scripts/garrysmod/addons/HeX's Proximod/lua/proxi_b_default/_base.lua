local BEACON = {}
BEACON.Name         = "<Base friendly name>"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

function BEACON:Load()
end

function BEACON:ShouldTag( entity )
	return false
	
end

function BEACON:PerformMath( ent )
end

function BEACON:DrawUnderCircle( ent )
end

function BEACON:DrawOverCircle( ent )
end

function BEACON:DrawOverEverything( ent, fDist, fAngle )
end

proxi.RegisterBeacon( BEACON, "base" )
