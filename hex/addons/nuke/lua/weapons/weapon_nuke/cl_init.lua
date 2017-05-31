
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
include('shared.lua')

local iScreenWidth = surface.ScreenWidth()
local iScreenHeight = surface.ScreenHeight()

local iRecHeight = 1.7*iScreenHeight
local iRecWidth = 1.275*iScreenWidth

--code riped off directly from Night Eagle (hopefully he doesn't find out...  ;-)
SWEP.QuadTable = {}
SWEP.QuadTable.w = iScreenHeight
SWEP.QuadTable.h = iScreenHeight
SWEP.QuadTable.x = (iScreenWidth - iScreenHeight) * .5
SWEP.QuadTable.y = 0

SWEP.ScopeTable = {}
SWEP.ScopeTable.x = SWEP.QuadTable.h * .25 + SWEP.QuadTable.x
SWEP.ScopeTable.y = SWEP.QuadTable.h * .25
SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
SWEP.ScopeTable.h = SWEP.QuadTable.h * .5

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
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end


function SWEP:DrawHUD()
	if not self.Owner:GetNWBool("DrawReticle") then return end
	
	--Draw the Reticle
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(surface.GetTextureID("sprites/reticle1"))
	
	surface.DrawTexturedRect(-0.5*(iRecWidth - iScreenWidth), -0.5*(iRecHeight - iScreenHeight), iRecWidth, iRecHeight )
	
	--Draw the Scope
	surface.SetDrawColor(0,0,0,255)
	
	surface.DrawRect(0,0,self.QuadTable.x,self.QuadTable.h)
	surface.DrawRect(surface.ScreenWidth() - self.QuadTable.x,0,self.QuadTable.x,self.QuadTable.h)
	
	surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
	surface.DrawTexturedRectRotated(self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,0)
	surface.DrawTexturedRectRotated(self.ScopeTable.x,iScreenHeight - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,90)
	surface.DrawTexturedRectRotated(iScreenWidth - self.ScopeTable.x,iScreenHeight - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,180)
	surface.DrawTexturedRectRotated(iScreenWidth - self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,270)
end


----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
include('shared.lua')

local iScreenWidth = surface.ScreenWidth()
local iScreenHeight = surface.ScreenHeight()

local iRecHeight = 1.7*iScreenHeight
local iRecWidth = 1.275*iScreenWidth

--code riped off directly from Night Eagle (hopefully he doesn't find out...  ;-)
SWEP.QuadTable = {}
SWEP.QuadTable.w = iScreenHeight
SWEP.QuadTable.h = iScreenHeight
SWEP.QuadTable.x = (iScreenWidth - iScreenHeight) * .5
SWEP.QuadTable.y = 0

SWEP.ScopeTable = {}
SWEP.ScopeTable.x = SWEP.QuadTable.h * .25 + SWEP.QuadTable.x
SWEP.ScopeTable.y = SWEP.QuadTable.h * .25
SWEP.ScopeTable.w = SWEP.QuadTable.w * .5
SWEP.ScopeTable.h = SWEP.QuadTable.h * .5

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
	draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
end


function SWEP:DrawHUD()
	if not self.Owner:GetNWBool("DrawReticle") then return end
	
	--Draw the Reticle
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(surface.GetTextureID("sprites/reticle1"))
	
	surface.DrawTexturedRect(-0.5*(iRecWidth - iScreenWidth), -0.5*(iRecHeight - iScreenHeight), iRecWidth, iRecHeight )
	
	--Draw the Scope
	surface.SetDrawColor(0,0,0,255)
	
	surface.DrawRect(0,0,self.QuadTable.x,self.QuadTable.h)
	surface.DrawRect(surface.ScreenWidth() - self.QuadTable.x,0,self.QuadTable.x,self.QuadTable.h)
	
	surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
	surface.DrawTexturedRectRotated(self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,0)
	surface.DrawTexturedRectRotated(self.ScopeTable.x,iScreenHeight - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,90)
	surface.DrawTexturedRectRotated(iScreenWidth - self.ScopeTable.x,iScreenHeight - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,180)
	surface.DrawTexturedRectRotated(iScreenWidth - self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,270)
end

