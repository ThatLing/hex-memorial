
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

include("shared.lua")

SWEP.IconLetter	= "3"


killicon.AddFont("love_missile", "HL2MPTypeDeath", SWEP.IconLetter, Color(80,170,255) )
killicon.AddFont("uh_bb_missile", "HL2MPTypeDeath", SWEP.IconLetter, Color(80,170,255) )

function SWEP:PrintWeaponInfo(x, y, alpha)
	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 255, 0, 0, 255>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=HudSelectionText>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180
	
	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)
	
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end


function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color(80,170,255), TEXT_ALIGN_CENTER)
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end




----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

include("shared.lua")

SWEP.IconLetter	= "3"


killicon.AddFont("love_missile", "HL2MPTypeDeath", SWEP.IconLetter, Color(80,170,255) )
killicon.AddFont("uh_bb_missile", "HL2MPTypeDeath", SWEP.IconLetter, Color(80,170,255) )

function SWEP:PrintWeaponInfo(x, y, alpha)
	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 255, 0, 0, 255>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=HudSelectionText>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180
	
	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)
	
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end


function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color(80,170,255), TEXT_ALIGN_CENTER)
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end



