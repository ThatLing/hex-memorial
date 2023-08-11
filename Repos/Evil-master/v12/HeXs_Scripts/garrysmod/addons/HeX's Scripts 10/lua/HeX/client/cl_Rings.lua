


local Enabled	= CreateClientConVar("hex_rings", 1, true, true)
local Alpha		= CreateClientConVar("hex_rings_alpha", 60, true, true)
local Mat		= Material("SGM/playercircle")

local StartOffset	= Vector(0,0,50)
local EndOffset		= Vector(0,0,-300)
local TraceLine 	= {}

function HeX.ShowPlayerRings(ply)
	if ValidEntity(ply) and Enabled:GetBool() and not ply:InVehicle() then
		TraceLine.start = ply:GetPos() + StartOffset
			TraceLine.endpos = TraceLine.start + EndOffset
		TraceLine.filter = ply
		
		local trace = util.TraceLine(TraceLine)
		if not trace.HitWorld then
			trace.HitPos = ply:GetPos()
		end
		
		local col = ply:TeamColor()
		render.SetMaterial(Mat)
		render.DrawQuadEasy( trace.HitPos + trace.HitNormal, trace.HitNormal, 48, 48, Color(col.r,col.g,col.b,Alpha:GetInt()) )
	end
end


timer.Simple(1, function()
	if (HSP and HSP.ShowPlayerRings) then
		hook.Remove("PrePlayerDraw", "HSP.ShowPlayerRings")
		print("[HeX] Removed HSP.ShowPlayerRings, loading custom")
	end
	
	hook.Add("PrePlayerDraw", "HeX.ShowPlayerRings", HeX.ShowPlayerRings)
end)





