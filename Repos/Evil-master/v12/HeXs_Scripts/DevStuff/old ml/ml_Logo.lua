

if not IsKida then return end
if not IsMainGMod then return end

local PANEL = {}
local Logo = Material( "console/gmod_logo" )

function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
end

function PANEL:GetImage()
	return self.ImageName
end


function PANEL:Paint()
	surface.SetMaterial( Logo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )
	return true
end

function PANEL:PerformLayout()
	local w = ScrH() / 2.5
	local h = w
	
	self:SetPos( ScrW() - w - 20, 20 )
	self:SetSize( w, h )
end


vgui.Register("PoopImage", PANEL)

local logo = vgui.Create("PoopImage")

