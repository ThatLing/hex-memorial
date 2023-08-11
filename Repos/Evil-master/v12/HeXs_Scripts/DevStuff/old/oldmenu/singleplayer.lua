/*__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 */

local PANEL = {}

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self:SetDeleteOnClose( false )
	
	self:SetTitle( "Start New Game" )
	
	self:CreateControls()
	
end


/*---------------------------------------------------------
	CreateControls
---------------------------------------------------------*/
function PANEL:CreateControls()

	self.StartGame = vgui.Create( "StartGame", self )
	self.MapSheet = vgui.Create( "DPropertySheet", self )
	self.MapSheet:SetFadeTime( 0.0 )
	
	self.MapIcons = vgui.Create( "MapListIcons" )
	self.MapIcons:SetController( self.StartGame )
	self.MapIcons:Setup()
	self.MapIcons:Dock( FILL )
	
	local Options = vgui.Create( "MapListOptions", MapSheet )
	Options:SetupMultiPlayer()
	Options:Dock( FILL )
	
	self.MapList = vgui.Create( "MapListList" )
	self.MapList:SetController( self.StartGame )
	self.MapList:Dock( FILL )
		
	self.ToyBox = vgui.Create( "ToyboxMap", self )
		
	MapSheet = vgui.Create( "DColumnSheet", self )
	MapSheet:UseButtonOnlyStyle()
		MapSheet.Navigation:Dock( RIGHT )
		MapSheet.Navigation:SetWidth( 16 )
		MapSheet.Navigation:DockMargin( 3, 0, 0, 0 )
	
		MapSheet:AddSheet( "", self.MapIcons, "gui/silkicons/application_view_tile" )
		MapSheet:AddSheet( "", self.MapList, "gui/silkicons/application_view_detail" )
		MapSheet:AddSheet( "", Options, "gui/silkicons/wrench" )
			
	self.MapSheet:AddSheet( "Maps", MapSheet, "gui/silkicons/world" );
	self.MapSheet:AddSheet( "Toybox", self.ToyBox, "gui/silkicons/toybox" )

end

function PANEL:ReloadMaps()

	g_MapList = nil
	include( 'menu/getmaps.lua' )

	self.MapIcons:Reload()
	self.MapList:Reload()	

end

/*---------------------------------------------------------
	PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( 735, ScrH() * 0.8 )
	
	self.MapSheet:SetPos( 8, 25 )
	self.MapSheet:SetSize( self:GetWide() - 16, self:GetTall() - 25 - 8 - 60 - 8 )
	self.MapSheet:InvalidateLayout()
	
	self.StartGame:SetPos( 8, self:GetTall() - 60 - 8 )
	self.StartGame:SetSize( self:GetWide() - 16, 60 )
	
	self.BaseClass.PerformLayout( self )
	
end

function PANEL:RebuildFavourites()

	self.MapIcons:RebuildFavourites()

end

vgui.Register( "StartSinglePlayerGame", PANEL, "DFrame" )

SinglePlayerMenu = vgui.Create( "StartSinglePlayerGame" )
SinglePlayerMenu:SetVisible( false )

local function menu_singleplayer()

	if ( SinglePlayerMenu ) then
	
		SinglePlayerMenu:SetVisible( true )
		SinglePlayerMenu:Center()
		SinglePlayerMenu:MakePopup()
	
	end

end

concommand.Add( "menu_startgame", menu_singleplayer )

local function CloseSinglePlayerMenu()

	if ( SinglePlayerMenu ) then
		SinglePlayerMenu:Close()
	end

end

hook.Add( "StartGame", "CloseSinglePlayerMenu", CloseSinglePlayerMenu )

function OnMapDownloaded( )

	if ( !IsValid(SinglePlayerMenu) ) then return end
	
	SinglePlayerMenu:ReloadMaps()

end

function OnMapSelected( name )

	if ( !IsValid(SinglePlayerMenu) ) then return end
	if ( !IsValid( SinglePlayerMenu.ToyBox.HTML ) ) then return end
	
	SinglePlayerMenu.ToyBox.HTML:RunJavascript( "OnMapSelected( '"..name.."' );" );
	SinglePlayerMenu.StartGame:SetMap( name )

end