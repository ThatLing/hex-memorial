
concommand.Add( "spray_menu", function( ply, cmd, args )
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( ScrH() / 2, ScrH() * 0.9 )
	Frame:SetTitle( "Player Sprays" )
	
	local List = vgui.Create( "DPanelList", Frame )
	List:Dock( FILL )
	List:DockMargin( 2, 2, 2, 2 )
	List:EnableHorizontal( false )
	List:EnableVerticalScrollbar( true )
	List:SetPadding( 4 )
	List:SetSpacing( 4 )
	
	for _,ply in ipairs( player.GetAll() ) do
		local Row = vgui.Create( "SprayIcon", List )
		Row:SetPlayer( ply )
		List:AddItem( Row )
	end
	
	Frame:MakePopup()
	Frame:Center()
end )

local PANEL = {}

function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( false )
	
	self.Name = vgui.Create( "DLabel", self )
	self.Name:SetFont( "Trebuchet22" )
	self.Name:SetColor( Color( 170, 240, 90 ) )
	self.Name:SetText( ""  )
	self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 100 ) )
	
	self.Desc = vgui.Create( "DLabel", self )
	self.Desc:SetFont( "DefaultBold" )
	self.Desc:SetColor( Color( 255, 255, 255, 200 ) )
	self.Desc:SetText( ""  )
	
	self.Icon = vgui.Create( "DImage", self )
	self.Icon:SetImage( "vgui/logos/spray_bullseye" )
	self.Icon:SetBGColor( Color( 255, 0, 0, 255 ) )
	
	self:SetBackgroundColor( Color( 100, 100, 100, 255 ) )
	
end

function PANEL:SetPlayer( ply )

	local TempLogoPath = ply:GetSprayMaterialPath()
	
	self.Name:SetText( ply:Nick() )
	self:SetSize( 74, 74 )
	
	if TempLogoPath then
	
		local new_material = TempLogoPath and CreateMaterial( TempLogoPath, "UnlitGeneric", {
			["$translucent"] = 1,
			["$basetexture"] = TempLogoPath,
			["$decal"] = 1,
			["Proxies"] = {
				["AnimatedTexture"] = {
					["animatedtexturevar"] = "$basetexture",
					["animatedtextureframenumvar"] = "$frame",
					["animatedtextureframerate"] = 5,
				}
			},
		} )
	
		self.Icon:SetMaterial( new_material )
		self.Desc:SetText( TempLogoPath )
	end
	
end

function PANEL:PerformLayout()

	self.Icon:SetPos( 5, 5 )
	self.Icon:SetSize( 64, 64 )
	
	self.Name:SizeToContents()
	self.Name:AlignTop( 5 )
	self.Name:MoveRightOf( self.Icon, 10 )
	self.Name:SetZPos( 100 )
	
	self.Desc:SizeToContents()
	self.Desc:CopyPos( self.Name )
	self.Desc:MoveBelow( self.Name, 0 )
	
	
end

vgui.Register( "SprayIcon", PANEL, "DPanel" )