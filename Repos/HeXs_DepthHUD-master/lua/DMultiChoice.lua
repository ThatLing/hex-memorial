/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DMultiChoice

*/

PANEL = {}

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self.DropButton = vgui.Create( "DSysButton", self )
	self.DropButton:SetType( "down" )
	self.DropButton.OnMousePressed = function( button, mcode ) self:OpenMenu( self.DropButton ) end
	
	self.TextEntry = vgui.Create( "DTextEntry", self )
	self.TextEntry.OnMousePressed = function( button, mcode ) self:OpenMenu( self.TextEntry ) end
	
	// Nicer default height
	self:SetTall( 20 )
	
	self.Choices = {}
	self.Data = {}

end

/*---------------------------------------------------------
   Name: Clear
---------------------------------------------------------*/
function PANEL:Clear()

	self.TextEntry:SetText( "" )
	self.Choices = {}
	self.Data = {}

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end
	
end

/*---------------------------------------------------------
   Name: SetText
---------------------------------------------------------*/
function PANEL:SetText( text )

	self.TextEntry:SetText( text )

end

/*---------------------------------------------------------
   Name: GetOptionText
---------------------------------------------------------*/
function PANEL:GetOptionText( id )

	return self.Choices[ id ]

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	derma.SkinHook( "Layout", "MultiChoice", self )

end

/*---------------------------------------------------------
   Name: ChooseOption
---------------------------------------------------------*/
function PANEL:ChooseOption( value, index )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self:SetText( value )
	self.TextEntry:ConVarChanged( value )

	self:OnSelect( index, value, self.Data[index] )
	
end

/*---------------------------------------------------------
   Name: ChooseOptionID
---------------------------------------------------------*/
function PANEL:ChooseOptionID( index )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	local value = self:GetOptionText( index )
	self:SetText( value )
	self.TextEntry:ConVarChanged( value )

	self:OnSelect( index, value, self.Data[index] )
	
end



/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:OnSelect( index, value, data )

	// For override

end

/*---------------------------------------------------------
   Name: AddChoice
---------------------------------------------------------*/
function PANEL:AddChoice( value, data )

	local i = table.insert( self.Choices, value )
	
	if ( data ) then
		self.Data[ i ] = data
	end
	
	return i

end

/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener ) then
		if ( pControlOpener == self.TextEntry ) then
			return
		end
	end

	// Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end
	
	// If the menu still exists and hasn't been deleted
	// then just close it and don't open a new one.
	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
		return		
	end

	self.Menu = DermaMenu()
	
		for k, v in pairs( self.Choices ) do
			self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
		end
		
		local x, y = self:LocalToScreen( 0, self:GetTall() )
		
		self.Menu:SetMinimumWidth( self:GetWide() )
		self.Menu:Open( x, y, false, self )		
		

end

/*---------------------------------------------------------
   Name: SetConVar
---------------------------------------------------------*/
function PANEL:SetConVar( cvar )

	self.TextEntry:SetConVar( cvar )

end

/*---------------------------------------------------------
   Name: SetEditable
---------------------------------------------------------*/
function PANEL:SetEditable( b )

	self.TextEntry:SetEditable( b )

end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( button, mcode )

	self:OpenMenu()

end

/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:AddChoice( "Some Choice" )
		ctrl:AddChoice( "Another Choice" )
		ctrl:SetWide( 150 )
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DMultiChoice", "", PANEL, "Panel" )
