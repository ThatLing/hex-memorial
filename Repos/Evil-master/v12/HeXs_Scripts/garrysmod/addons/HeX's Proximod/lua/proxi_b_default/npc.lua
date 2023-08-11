local BEACON = {}
BEACON.Name         = "NPCs"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = true
BEACON.DefaultBypassDistance = false

function BEACON:Load()
	self.myMathPool = {}
	self.myTexture     = surface.GetTextureID( "proxi/beacon_square_8" )
	self.myTriangle    = surface.GetTextureID( "proxi/beacon_triangle" )
	self.myColor       = Color( 255, 0, 0, 255 )
	self.myCross       = surface.GetTextureID( "proxi/beacon_cross" )
	
end

function BEACON:ShouldTag( entity )
	return entity:IsNPC()
	
end

function BEACON:PerformMath( ent )
	if not self.myMathPool[ ent ] then
		self.myMathPool[ ent ] = {}
	end
	local thisMathPool = self.myMathPool[ ent ]
	
	proxi:ProjectPosition( thisMathPool, ent:GetPos() )		
	proxi:GetFalloff( thisMathPool, 256 )
	proxi:GetConeProjectedPosition( thisMathPool )
	
	self.zLocalPos = LocalPlayer():GetPos().z
	
end

/*function BEACON:DrawUnderCircle( ent )
	local thisMathPool = self.myMathPool[ ent ]
	
	if thisMathPool.ratioClamped < 1 then
		render.SetBlend( 1 - thisMathPool.ratioClamped ^ 5 )
		ent:DrawModel()
		render.SetBlend( 1 )
		
	end
	
end*/

function BEACON:DrawUnderCircle2D( ent )	
	local thisMathPool = self.myMathPool[ ent ]
	
	local xRel, yRel = proxi:ConvertPosToRelative( thisMathPool.conePos )
	local x, y       = proxi:ConvertRelativeToScreen( xRel, yRel )
	
	local relZ = (ent:GetPos().z - self.zLocalPos)
	local isShift = math.abs( relZ ) > 100
	local iSize = (isShift and 20 or 14) * proxi:GetPinScale()
	if isShift then
		surface.SetTexture( self.myTriangle )
		
	else
		surface.SetTexture( self.myTexture )
		
	end
	surface.SetDrawColor( self.myColor )
	surface.DrawTexturedRectRotated( x, y, iSize, iSize, isShift and ((relZ > 0) and 0 or 180) or 45)
	
	if false and "should be when thys dead" then
		surface.SetTexture( self.myCross )
		surface.DrawTexturedRectRotated( x, y, iSize, iSize, 0)
		
	end
	
	if thisMathPool.ratio < 1.5 then
		local text = proxi_util.FamiliarizeString( string.gsub( ent:GetClass(), "npc_", "" ) )
		
		surface.SetFont( "DefaultSmall" )
		local wB, hB = surface.GetTextSize( text )
		x = x - xRel * wB / 2
		y = y - yRel * hB / 2 + hB - (yRel > 0 and (yRel ^ 4 * hB * 2) or 0)
		
		draw.SimpleText( text, "DefaultSmall", x + 1, y + 1, Color( 0, 0, 0, 128 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "DefaultSmall", x, y, self.myColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
	end

end

proxi.RegisterBeacon( BEACON, "npcs" )
