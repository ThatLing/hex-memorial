
function PANEL:CreateControls()
	self.StartGame = vgui.Create( "StartGame", self )
	self.MapSheet = vgui.Create( "DPropertySheet", self )
	self.MapSheet:SetFadeTime( 0.0 )
	
	self.MapIcons = vgui.Create( "MapListIcons" )
	self.MapIcons:SetController( self.StartGame )
	self.MapIcons:Setup()
	self.MapIcons:Dock( FILL )
	
	--[[
	local Options = vgui.Create( "MapListOptions", MapSheet )
	Options:SetupMultiPlayer()
	Options:Dock( FILL )
	]]
	
	self.MapList = vgui.Create( "MapListList" )
	self.MapList:SetController( self.StartGame )
	self.MapList:Dock( FILL )
	
	self.ToyBox = vgui.Create( "ToyboxMap", self )
	
	--[[
	MapSheet = vgui.Create( "DColumnSheet", self )
		MapSheet:UseButtonOnlyStyle()
		
		MapSheet.Navigation:Dock( RIGHT )
		MapSheet.Navigation:SetWidth( 16 )
		MapSheet.Navigation:DockMargin( 3, 0, 0, 0 )
		
		MapSheet:AddSheet( "", self.MapIcons, "gui/silkicons/application_view_tile" )
		MapSheet:AddSheet( "", self.MapList, "gui/silkicons/application_view_detail" )
	]]
	
	self.MapSheet:AddSheet( "Icons", self.MapIcons, "gui/silkicons/application_view_tile" )
	self.MapSheet:AddSheet( "List", MapList, "gui/silkicons/application_view_detail" )
	self.MapSheet:AddSheet( "Options", Options, "gui/silkicons/application_view_detail" )
	self.MapSheet:AddSheet( "Toybox", ToyBox, "gui/silkicons/toybox" )
end

