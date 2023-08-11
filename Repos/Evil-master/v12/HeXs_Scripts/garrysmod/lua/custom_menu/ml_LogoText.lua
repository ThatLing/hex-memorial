
if not IsKida then return end


local PANEL = {}
local Logo = Material( "console/logo_text" )

function PANEL:Init()

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
end

function PANEL:Paint()

	surface.SetMaterial( Logo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )

	return true

end

function PANEL:PerformLayout()
	
	local w = ScrW() * 0.5
	
	self:SetPos( 0, ScrH() * 0.1 )
	self:SetSize( w, w / 4 )
	self:CenterHorizontal()
	
end

local GLogo = vgui.CreateFromTable( vgui.RegisterTable( PANEL, "Panel" ) )