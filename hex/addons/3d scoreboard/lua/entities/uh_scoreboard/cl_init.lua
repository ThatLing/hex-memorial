
----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include("shared.lua")


surface.CreateFont("HostFont", {
	font		= "Trebuchet22",
	size 		= 50,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("PlayerFont", {
	font		= "Trebuchet22",
	size 		= 40,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)



local Slots = {
	[1]		= 145,
	[2]		= 200,
	[3]		= 255,
	[4]		= 310,
	[5]		= 365,
	[6]		= 420,
	[7]		= 475,
	[8]		= 530,
	[9]		= 585,
	[10]	= 640,
	[11]	= 695,
	[12]	= 750,
	[13]	= 805,
	[14]	= 860,
	[15]	= 915,
	[16]	= 970,
	[17]	= 1025,
	[18]	= 1080,
	[19]	= 1135,
	[20]	= 1190,
	[21]	= 1245,
	[22]	= 1300,
	[23]	= 1355,
	[24]	= 1410,
	[25]	= 1465,
	[26]	= 1520,
	[27]	= 1575,
	[28]	= 1630,
	[29]	= 1685,
	[30]	= 1740,
	[31]	= 1795,
	[32]	= 1850,
	[33]	= 1905,
	[34]	= 1960,
	[35]	= 2015,
	[36]	= 2070,
	[37]	= 2125,
	[38]	= 2180,
	[39]	= 2235,
	[40]	= 2290,
	[41]	= 2345,
	[42]	= 2400,
	[43]	= 2455,
	[44]	= 2510,
	[45]	= 2565,
	[46]	= 2620,
	[47]	= 2675,
	[48]	= 2730,
	[49]	= 2785,
	[50]	= 2840,
	[51]	= 2895,
	[52]	= 2950,
	[53]	= 3005,
	[54]	= 3060,
	[55]	= 3115,
	[56]	= 3170,
	[57]	= 3225,
	[58]	= 3280,
	[59]	= 3335,
	[60]	= 3390,
	[61]	= 3445,
	[62]	= 3500,
	[63]	= 3555,
	[64]	= 3610,
}


local MapColor = Color(51, 102, 255, 255)

function ENT:Draw()
	cam.Start3D2D(self:GetPos() - self:GetAngles():Forward() * 190 + self:GetAngles():Right() * 190, self:GetAngles() + Angle(90, 90, 90), 0.3)
		draw.RoundedBox(3, 0, 0, 1270, 50, MapColor)
		draw.RoundedBox(3, 0, 70, 1270, 50, MapColor)
		draw.DrawText(GetHostName(), "HostFont", 5, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw.DrawText(
			"Name                                                                   Kills          Ping",
			"HostFont", 5, 70, color_white,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
		)
		
		for k,v in pairs( player.GetAll() ) do
			if IsValid(v) then
				draw.RoundedBox(3, 0, Slots[k], 875, 50, MapColor)
				draw.RoundedBox(3, 885, Slots[k], 195, 50, MapColor)
				draw.RoundedBox(3, 1090, Slots[k], 180, 50, MapColor)
				
				draw.DrawText(v:Name(), "PlayerFont", 5, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.DrawText(v:Frags(), "PlayerFont", 935, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.DrawText(v:Ping(), "PlayerFont", 1200, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()
end



























----------------------------------------
--         2014-07-12 20:33:16          --
------------------------------------------

include("shared.lua")


surface.CreateFont("HostFont", {
	font		= "Trebuchet22",
	size 		= 50,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)

surface.CreateFont("PlayerFont", {
	font		= "Trebuchet22",
	size 		= 40,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)



local Slots = {
	[1]		= 145,
	[2]		= 200,
	[3]		= 255,
	[4]		= 310,
	[5]		= 365,
	[6]		= 420,
	[7]		= 475,
	[8]		= 530,
	[9]		= 585,
	[10]	= 640,
	[11]	= 695,
	[12]	= 750,
	[13]	= 805,
	[14]	= 860,
	[15]	= 915,
	[16]	= 970,
	[17]	= 1025,
	[18]	= 1080,
	[19]	= 1135,
	[20]	= 1190,
	[21]	= 1245,
	[22]	= 1300,
	[23]	= 1355,
	[24]	= 1410,
	[25]	= 1465,
	[26]	= 1520,
	[27]	= 1575,
	[28]	= 1630,
	[29]	= 1685,
	[30]	= 1740,
	[31]	= 1795,
	[32]	= 1850,
	[33]	= 1905,
	[34]	= 1960,
	[35]	= 2015,
	[36]	= 2070,
	[37]	= 2125,
	[38]	= 2180,
	[39]	= 2235,
	[40]	= 2290,
	[41]	= 2345,
	[42]	= 2400,
	[43]	= 2455,
	[44]	= 2510,
	[45]	= 2565,
	[46]	= 2620,
	[47]	= 2675,
	[48]	= 2730,
	[49]	= 2785,
	[50]	= 2840,
	[51]	= 2895,
	[52]	= 2950,
	[53]	= 3005,
	[54]	= 3060,
	[55]	= 3115,
	[56]	= 3170,
	[57]	= 3225,
	[58]	= 3280,
	[59]	= 3335,
	[60]	= 3390,
	[61]	= 3445,
	[62]	= 3500,
	[63]	= 3555,
	[64]	= 3610,
}


local MapColor = Color(51, 102, 255, 255)

function ENT:Draw()
	cam.Start3D2D(self:GetPos() - self:GetAngles():Forward() * 190 + self:GetAngles():Right() * 190, self:GetAngles() + Angle(90, 90, 90), 0.3)
		draw.RoundedBox(3, 0, 0, 1270, 50, MapColor)
		draw.RoundedBox(3, 0, 70, 1270, 50, MapColor)
		draw.DrawText(GetHostName(), "HostFont", 5, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw.DrawText(
			"Name                                                                   Kills          Ping",
			"HostFont", 5, 70, color_white,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
		)
		
		for k,v in pairs( player.GetAll() ) do
			if IsValid(v) then
				draw.RoundedBox(3, 0, Slots[k], 875, 50, MapColor)
				draw.RoundedBox(3, 885, Slots[k], 195, 50, MapColor)
				draw.RoundedBox(3, 1090, Slots[k], 180, 50, MapColor)
				
				draw.DrawText(v:Name(), "PlayerFont", 5, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.DrawText(v:Frags(), "PlayerFont", 935, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.DrawText(v:Ping(), "PlayerFont", 1200, Slots[k], color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
	cam.End3D2D()
end


























