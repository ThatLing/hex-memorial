/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSysWindow
	
	A system button. A button using the marlett font to show a graphic.

*/

PANEL = {}


AccessorFunc( PANEL, "m_strType", 		"Type" )
AccessorFunc( PANEL, "m_Character", 	"Char" )



/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetTextInset( 0, 0 )

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetType( strType )

	self.m_strType = strType
	
	if ( strType == "close" ) then self:SetChar( "r" ) 
	elseif ( strType == "grip" ) then self:SetChar( "p" ) 
	elseif ( strType == "down" ) then self:SetChar( "u" ) 
	elseif ( strType == "up" ) then self:SetChar( "t" ) 
	elseif ( strType == "updown" ) then self:SetChar( "v" ) 
	elseif ( strType == "tick" ) then self:SetChar( "a" ) 
	elseif ( strType == "right" ) then self:SetChar( "4" ) 
	elseif ( strType == "left" ) then self:SetChar( "3" ) 
	elseif ( strType == "question" ) then self:SetChar( "s" ) 
	elseif ( strType == "none" ) then self:SetChar( "" ) 
	end

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:SetChar( strChar )

	self.m_Character = strChar
	self:SetText( strChar )

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Paint()

	derma.SkinHook( "Paint", "SysButton", self )
	return false

end


/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	derma.SkinHook( "Scheme", "SysButton", self )

end

derma.DefineControl( "DSysButton", "System Button", PANEL, "DButton" )
