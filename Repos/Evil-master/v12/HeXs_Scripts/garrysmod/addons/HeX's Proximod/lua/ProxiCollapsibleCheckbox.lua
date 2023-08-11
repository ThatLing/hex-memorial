-- CollapsibleCheckbox Panel

local PANEL = {}

function PANEL:Init( ... )
	--self.BaseClass.Init( self, ... )
	self.categoryCheckbox = vgui.Create( "DCheckBox", self )
	self.categoryLabel    = vgui.Create( "DLabel", self )
	self:SetLabel("")
	
end

function PANEL:SetConVar( ... )
	self.categoryCheckbox:SetConVar( ... )
	
end

function PANEL:SetText( ... )
	self.categoryLabel:SetText( ... )
	
end

function PANEL:PerformLayout( ... )
	self.BaseClass.PerformLayout( self, ... )
	
	--self.categoryCheckbox:SetSize( self:GetWide(), self:GetTall() )
	self.categoryCheckbox:AlignTop( 4 )
	self.categoryCheckbox:AlignLeft( 3 )
	self.categoryLabel:AlignTop( 1 )
	self.categoryLabel:MoveRightOf( self.categoryCheckbox, 8 )
	self.categoryLabel:SetWide( self:GetWide() )
	
end

vgui.Register( "ProxiCollapsibleCheckbox", PANEL, "DCollapsibleCategory" )