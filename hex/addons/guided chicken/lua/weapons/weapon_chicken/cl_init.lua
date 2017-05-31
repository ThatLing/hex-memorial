
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
include('shared.lua')


SWEP.IconLetter		= "3"

function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

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


-- Draw weapon info box
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color(80,170,255,255), TEXT_ALIGN_CENTER )
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end




surface.CreateFont("Cluckshot", {
	font		= "Trebuchet MS",
	size 		= 40,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)

function SWEP:DrawHUD()
	if not self.Owner:GetNWBool("DrawChicken") then return end
	
	surface.SetFont("Cluckshot")
	surface.SetTextColor(255,0,0,255)
	
	
	local Size = surface.GetTextSize("CHICKEN CAM")
	
	surface.SetTextPos( (ScrW() / 2) - 0.5*Size, ScrH() - 80)
	surface.DrawText("CHICKEN CAM")
end





















----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
include('shared.lua')


SWEP.IconLetter		= "3"

function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

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


-- Draw weapon info box
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color(80,170,255,255), TEXT_ALIGN_CENTER )
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end




surface.CreateFont("Cluckshot", {
	font		= "Trebuchet MS",
	size 		= 40,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)

function SWEP:DrawHUD()
	if not self.Owner:GetNWBool("DrawChicken") then return end
	
	surface.SetFont("Cluckshot")
	surface.SetTextColor(255,0,0,255)
	
	
	local Size = surface.GetTextSize("CHICKEN CAM")
	
	surface.SetTextPos( (ScrW() / 2) - 0.5*Size, ScrH() - 80)
	surface.DrawText("CHICKEN CAM")
end




















