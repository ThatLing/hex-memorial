local BEACON = {}
BEACON.Name         = "Players"
BEACON.DefaultOn    = true
BEACON.IsStandAlone = false

BEACON.CanBypassDistance     = true
BEACON.DefaultBypassDistance = true

function BEACON:Load()
	self.myMathPool = {}
	self.myMaterial = Material( "proxi/beacon_flare_add" )
	self.myTexture  = surface.GetTextureID( "proxi/beacon_square_8" )
	self.myTriangle    = surface.GetTextureID( "proxi/beacon_triangle" )
	
end

function BEACON:ShouldTag( entity )
	return entity:IsPlayer()
	
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

function BEACON:DrawUnderCircle( ent )
	local thisMathPool = self.myMathPool[ ent ]
	local cfP, cfAP = thisMathPool.closeFalloff ^ 2, proxi_util.PercentCharge( thisMathPool.closeFalloff )
	
	render.SetMaterial( self.myMaterial )
	render.DrawBeam( thisMathPool.posToProj, thisMathPool.posToProj + Vector( 0, 0, 92 ), 10, 0.3, 1, Color( 255, 255, 255, 255 * cfP ) )
	render.DrawSprite( thisMathPool.conePos, 32, 32, Color( 255, 255, 255, 255 * cfAP ) ) ////
	
	if thisMathPool.ratioClamped < 1 then
		render.SetBlend( 1 - thisMathPool.ratioClamped ^ 5 )
		if ValidEntity( ent:GetRagdollEntity() ) then
			render.DrawBeam( thisMathPool.posToProj, ent:GetRagdollEntity():GetPos(), 10, 0.2, 0.8, Color( 255, 255, 255, 255 * cfP ) )
			ent:GetRagdollEntity():DrawModel()
			
		else
			ent:DrawModel()
			
		end
		render.SetBlend( 1 )
		
	end
	
end

function BEACON:DrawUnderCircle2D( ent )	
	local thisMathPool = self.myMathPool[ ent ]
	
	local xRel, yRel = proxi:ConvertPosToRelative( thisMathPool.conePos )
	local x, y       = proxi:ConvertRelativeToScreen( xRel, yRel )
	
	local teamColor = team.GetColor( ent:Team() )
	local ratio = 1
	
	local relZ = (ent:GetPos().z - self.zLocalPos)
	local isShift = math.abs( relZ ) > 100
	local iSize = (isShift and 20 or 14) * proxi:GetPinScale()
	if isShift then
		surface.SetTexture( self.myTriangle )
		
	else
		surface.SetTexture( self.myTexture )
		
	end
	surface.SetDrawColor( teamColor )
	surface.DrawTexturedRectRotated( x, y, iSize, iSize, isShift and ((relZ > 0) and 0 or 180) or 45) ////
	
	
	local text = tostring( ent:Nick() )
	surface.SetFont( "DefaultSmall" )
	
	if (thisMathPool.ratioClamped ~= 1) or (ent:GetFriendStatus() == "friend") then
		local wB, hB = surface.GetTextSize( text )
		x = x - xRel * wB / 2
		y = y - yRel * hB / 2 + hB - (yRel > 0 and (yRel ^ 4 * hB * 2) or 0)
		
		if ent == LocalPlayer() then
			ratio = 1 - (1 - thisMathPool.ratioClamped) ^ 3
			teamColor.a = 255 * ratio
		end
		
	else
		text = string.sub( text, 1, 1 )
		
	end
	draw.SimpleText( text, "DefaultSmall", x + 1, y + 1, Color( 0, 0, 0, 128 * ratio ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( text, "DefaultSmall", x, y, teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	

end

proxi.RegisterBeacon( BEACON, "players" )
