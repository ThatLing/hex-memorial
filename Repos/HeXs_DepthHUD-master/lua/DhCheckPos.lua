

local PANEL = {}

AccessorFunc( PANEL, "m_ConVar", 				"ConVar" )
AccessorFunc( PANEL, "m_Text", 					"Text" )
AccessorFunc( PANEL, "m_ConVarX", 				"ConVarX" )
AccessorFunc( PANEL, "m_ConVarY", 				"ConVarY" )
AccessorFunc( PANEL, "m_MinMax", 				"MinMax" )
//AccessorFunc( PANEL, "m_NumWide", 				"NumWide" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.clabel = vgui.Create( "DCheckBoxLabel", self )
	
	self.configX = vgui.Create( "DNumberWang", self )
	self.configX:SetDecimals( 0 )
	self.configX:SetMinMax( 0, ScrW() )
	self.configY = vgui.Create( "DNumberWang", self )
	self.configY:SetDecimals( 0 )
	self.configY:SetMinMax( 0, ScrH() )
	
	self.button = vgui.Create("DButton", self )
	self.button:SetText("R")
	
	/*self.options = vgui.Create( "DPanelList" , self )
	self.options:EnableHorizontal( false )
	self.options:EnableVerticalScrollbar( false )*/
	
	//self:SetPaintBackground( false )
	
end

/*---------------------------------------------------------
   Name: ConVarEnabled
---------------------------------------------------------*/
/*function PANEL:GetOptionsPanelList()
	return self.options
end*/

/*---------------------------------------------------------
   Name: ConVarEnabled
---------------------------------------------------------*/
function PANEL:SetConVar( cvar )
	self.clabel:SetConVar( cvar )
end

/*---------------------------------------------------------
   Name: Text
---------------------------------------------------------*/
function PANEL:SetText( text )
	self.clabel:SetText( text )
	self.clabel.Label:SetTextColor(Color(0,0,0))
end

/*---------------------------------------------------------
   Name: ConVarX
---------------------------------------------------------*/
function PANEL:SetConVarX( cvar )
	local myPRNum = GetConVarNumber( cvar )
	if (myPRNum - math.floor(myPRNum)) != 0 then
		self.configX:SetDecimals( 2 )
	end
	self.configX:SetConVar( cvar )
	self.configX:SetFloatValue( myPRNum )
end

/*---------------------------------------------------------
   Name: ConVarY
---------------------------------------------------------*/
function PANEL:SetConVarY( cvar )
	local myPRNum = GetConVarNumber( cvar )
	if (myPRNum - math.floor(myPRNum)) != 0 then
		self.configY:SetDecimals( 2 )
	end
	self.configY:SetConVar( cvar )
	self.configY:SetFloatValue( myPRNum )
end

/*---------------------------------------------------------
   Name: Text
---------------------------------------------------------*/
function PANEL:SetMinMax( min, max )
	self.configX:SetMinMax( min, max )
	self.configY:SetMinMax( min, max )
end

/*---------------------------------------------------------
   Name: NumWidth
---------------------------------------------------------*/
/*function PANEL:SetNumWide( width )
	self.configX:SetWide( width )
	self.configY:SetWide( width )
end*/


/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetTall( 18 )
	
	self.configX:SetTall( 18 )
	self.configY:SetTall( 18 )
	self.button:SetTall( 18 )
	self.button:SetWide( 18 )
	
	self.clabel:SizeToContents()
	self.clabel:AlignLeft( 5 )
	self.clabel:CenterVertical( )
	
	self.configX:SizeToContents()
	self.configY:SizeToContents()
	
	--self.clabel:AlignTop( 0 )
	self.configX:AlignTop( 0 )
	self.configY:AlignTop( 0 )
	
	
	local x,y = self.configY:GetSize( )
	local xA,yA = self.configX:GetSize( )
	self.button:AlignRight( 3 + xA + 3 + x + 3 )
	self.configX:AlignRight( 3 + x + 3 )
	self.configY:AlignRight( 3 )
	
	/*
	self.options:SizeToContents( )
	self.options:SetSpacing( 5 )
	self.options:EnableHorizontal( false )
	self.options:EnableVerticalScrollbar( false )
	self.options:CenterHorizontal( )
	self.options:AlignBottom( 0 )
	self.options:PerformLayout()
	*/
end



vgui.Register( "DhCheckPos", PANEL, "DPanel" )