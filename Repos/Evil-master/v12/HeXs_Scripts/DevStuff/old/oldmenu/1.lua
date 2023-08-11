/*__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 */

language.Add( "SingleplayerGame", "Singleplayer Game" )

local PANEL = {}

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self:SetDeleteOnClose( false )
	
	self:SetTitle( "#SingleplayerGame" )
	
	self:CreateControls()
	
end


/*---------------------------------------------------------
	CreateControls
---------------------------------------------------------*/
function PANEL:CreateControls()

	self.StartGame = vgui.Create( "StartGame", self )
	self.MapSheet = vgui.Create( "DPropertySheet", self )
	self.MapSheet:SetFadeTime( 0.3 )
	
	self.MapIcons = vgui.Create( "MapListIcons" )
	self.MapIcons:SetController( self.StartGame )
	self.MapIcons:Setup()
	
	local MapList = vgui.Create( "MapListList" )
	MapList:SetController( self.StartGame )
	
	local Options = vgui.Create( "MapListOptions", self )
	Options:SetupSinglePlayer()
	
	local ToyBox = vgui.Create( "ToyboxMap", self )
		
	self.MapSheet:AddSheet( "Icons", self.MapIcons, "gui/silkicons/application_view_tile" )
	self.MapSheet:AddSheet( "List", MapList, "gui/silkicons/application_view_detail" )
	self.MapSheet:AddSheet( "Options", Options, "gui/silkicons/application_view_detail" )
	self.MapSheet:AddSheet( "Toybox", ToyBox, "gui/silkicons/toybox" )

end

/*---------------------------------------------------------
	PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	self:SetSize( 450, ScrH() * 0.8 )
	
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

concommand.Add( "menu_singleplayer", menu_singleplayer )

local function CloseSinglePlayerMenu()

	if ( SinglePlayerMenu ) then
		SinglePlayerMenu:Close()
	end

end

hook.Add( "StartGame", "CloseSinglePlayerMenu", CloseSinglePlayerMenu )