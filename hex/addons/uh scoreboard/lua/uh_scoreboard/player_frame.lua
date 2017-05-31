
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------

local PANEL = {}


function PANEL:Init()
	self.pnlCanvas 	= vgui.Create("Panel", self)
	self.YOffset = 0
end


function PANEL:GetCanvas()
	return self.pnlCanvas
end


function PANEL:OnMouseWheeled( dlta )
	local MaxOffset = self.pnlCanvas:GetTall() - self:GetTall()
	
	if ( MaxOffset > 0 ) then
		self.YOffset = math.Clamp( self.YOffset + dlta * -100, 0, MaxOffset )
	else
		self.YOffset = 0
	end
	
	self:InvalidateLayout()
end


function PANEL:PerformLayout()
	self.pnlCanvas:SetPos( 0, self.YOffset * -1 )
	self.pnlCanvas:SetSize( self:GetWide(), self.pnlCanvas:GetTall() )
end


vgui.Register("PlayerFrame", PANEL, "Panel")



















----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------

local PANEL = {}


function PANEL:Init()
	self.pnlCanvas 	= vgui.Create("Panel", self)
	self.YOffset = 0
end


function PANEL:GetCanvas()
	return self.pnlCanvas
end


function PANEL:OnMouseWheeled( dlta )
	local MaxOffset = self.pnlCanvas:GetTall() - self:GetTall()
	
	if ( MaxOffset > 0 ) then
		self.YOffset = math.Clamp( self.YOffset + dlta * -100, 0, MaxOffset )
	else
		self.YOffset = 0
	end
	
	self:InvalidateLayout()
end


function PANEL:PerformLayout()
	self.pnlCanvas:SetPos( 0, self.YOffset * -1 )
	self.pnlCanvas:SetSize( self:GetWide(), self.pnlCanvas:GetTall() )
end


vgui.Register("PlayerFrame", PANEL, "Panel")


















