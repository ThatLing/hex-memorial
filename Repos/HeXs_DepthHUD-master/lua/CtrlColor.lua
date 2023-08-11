//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//

local PANEL = {}

AccessorFunc( PANEL, "m_ConVarR", 				"ConVarR" )
AccessorFunc( PANEL, "m_ConVarG", 				"ConVarG" )
AccessorFunc( PANEL, "m_ConVarB", 				"ConVarB" )
AccessorFunc( PANEL, "m_ConVarA", 				"ConVarA" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Mixer = vgui.Create( "DColorMixer", self )
	
	self.txtR = vgui.Create( "DNumberWang", self )
	self.txtR:SetDecimals( 0 )
	self.txtR:SetMinMax( 0, 255 )
	self.txtG = vgui.Create( "DNumberWang", self )
	self.txtG:SetDecimals( 0 )
	self.txtG:SetMinMax( 0, 255 )
	self.txtB = vgui.Create( "DNumberWang", self )
	self.txtB:SetDecimals( 0 )
	self.txtB:SetMinMax( 0, 255 )
	self.txtA = vgui.Create( "DNumberWang", self )
	self.txtA:SetDecimals( 0 )
	self.txtA:SetMinMax( 0, 255 )
	self.txtA:SetVisible( false )
	
end

/*---------------------------------------------------------
   Name: ConVarR
---------------------------------------------------------*/
function PANEL:SetConVarR( cvar )
	self.Mixer:SetConVarR( cvar )
	self.txtR:SetConVar( cvar )
end

/*---------------------------------------------------------
   Name: ConVarG
---------------------------------------------------------*/
function PANEL:SetConVarG( cvar )
	self.Mixer:SetConVarG( cvar )
	self.txtG:SetConVar( cvar )
end

/*---------------------------------------------------------
   Name: ConVarB
---------------------------------------------------------*/
function PANEL:SetConVarB( cvar )
	self.Mixer:SetConVarB( cvar )
	self.txtB:SetConVar( cvar )
end

/*---------------------------------------------------------
   Name: ConVarA
---------------------------------------------------------*/
function PANEL:SetConVarA( cvar )

	if ( cvar ) then self.txtA:SetVisible( true ) end
	self.Mixer:SetConVarA( cvar )
	self.txtA:SetConVar( cvar )
	
end

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local y =  0 //self.Label1:GetTall() + 5

	self:SetTall( 110 )
	
	self.Mixer:SetSize( 150, 100 )
	self.Mixer:Center()
	self.Mixer:AlignLeft( 5 )
	
	self.txtR:SizeToContents()
	self.txtG:SizeToContents()
	self.txtB:SizeToContents()
	self.txtA:SizeToContents()
	
	self.txtR:AlignRight( 5 )
	self.txtR:AlignTop( 5 )
		self.txtG:CopyBounds( self.txtR )
		self.txtG:CenterVertical( 0.375 )
			self.txtB:CopyBounds( self.txtG )
			self.txtB:CenterVertical( 0.625 )
				self.txtA:CopyBounds( self.txtB )
				self.txtA:AlignBottom( 5 )

end



vgui.Register( "CtrlColor", PANEL, "DPanel" )