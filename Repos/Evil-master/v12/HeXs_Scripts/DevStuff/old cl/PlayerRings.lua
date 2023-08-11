
if UH_RINGS_INSTALLED then return end


local Enabled	= CreateClientConVar("hex_rings", 1, true, true)
local Alpha		= CreateClientConVar("hex_rings_alpha", 60, true, true)
local Mat		= Material("SGM/playercircle")

local TraceLine = {}
hook.Add("PrePlayerDraw", "PlayerRings", function(ply)
	if ValidEntity(ply) and Enabled:GetBool() and not ply:InVehicle() then
		TraceLine.start = ply:GetPos() + Vector(0,0,50)
			TraceLine.endpos = TraceLine.start + Vector(0,0,-300)
		TraceLine.filter = ply
		
		local trace = util.TraceLine(TraceLine)
		if not trace.HitWorld then
			trace.HitPos = ply:GetPos()
		end
		
		local col = team.GetColor( ply:Team() )
		render.SetMaterial(Mat)
		render.DrawQuadEasy( trace.HitPos + trace.HitNormal, trace.HitNormal, 48, 48, Color(col.r,col.g,col.b,Alpha:GetInt()) )
	end
end)


