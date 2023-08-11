

local Enabled = CreateClientConVar("hex_nametags", 1, true, false)


surface.CreateFont("coolvetica", 40, 400, true, false, "CV20", true)
local offset = Vector(0,0,85)


function HeX.ShowNameTags(ply)
	if not (Enabled:GetBool() and ValidEntity(ply) and ply:Alive() and ply != LocalPlayer()) then return end
	
    local ang = LocalPlayer():EyeAngles()
    local pos = ply:GetPos() + offset + ang:Up()
	local col = team.GetColor(ply:Team())
	
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
	
    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
        draw.DrawText(ply:Nick(), "CV20", 2, 2, col, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end



timer.Simple(1, function()
	if (HSP and HSP.ShowNameTags) then
		hook.Remove("PostPlayerDraw", "HSP.ShowNameTags")
		print("[HeX] Removed HSP.ShowNameTags, loading custom")
	end
	
	hook.Add("PostPlayerDraw", "HeX.ShowNameTags", HeX.ShowNameTags)
end)




