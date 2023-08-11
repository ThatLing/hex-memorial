

local convar3 = CreateClientConVar("hex_showballs", 0, true, true)

local function showspwans()
	if not convar3:GetBool() then return end
	
	for k,v in pairs(ents.FindByClass("sent_ball")) do
		local pos = v:GetPos():ToScreen()
		draw.RoundedBox( 4, pos.x-5, pos.y-5, 10, 10, Color( 66, 255, 96, 255 ) )
	end
end
--hook.Add("HUDPaint", "ShowBalls", showspwans)


	