//
//  ___  ___   _   _   _    __   _   ___ ___ __ __
// |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
//  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
//  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
//										 
//

HeXInclude( 'preset_editor.lua' )

local PANEL = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()

	self.DropDown = vgui.Create( "DMultiChoice", self )
	self.DropDown.OnSelect = function( dropdown, index, value, data ) self:OnSelect( index, value, data ) end
	self.DropDown:SetText( "Presets" )
	self.DropDown:SetEditable( false )
	
	self.Button = vgui.Create( "DSysButton", self )
	self.Button:SetType( "right" )
	self.Button.DoClick = function() self:OpenPresetEditor() end
	
	self:SetTall( 20 )
	
	self.ConVars = {}
	
end


/*---------------------------------------------------------
   Name: SetLabel
---------------------------------------------------------*/
function PANEL:SetLabel( strName )

	self.Label:SetText( strName )

end


/*---------------------------------------------------------
   Name: SetLabel
---------------------------------------------------------*/
function PANEL:AddOption( strName, data )

	self.DropDown:AddChoice( strName, data )

end


/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.Button:SetSize( self:GetTall(), self:GetTall() )
	self.Button:SetPos( self:GetWide() - self.Button:GetWide(), 0 )
	
	self.DropDown:SetPos( 0, 0 )
	self.DropDown:SetWide( self:GetWide() - self.Button:GetWide() - 5 )

end


/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:OnSelect( index, value, data )

	if ( !data ) then return end
	
	for k, v in pairs( data ) do
		RunConsoleCommand( k, v )
	end

end


/*---------------------------------------------------------
   Name: OpenPresetEditor
---------------------------------------------------------*/
function PANEL:OpenPresetEditor()

	if (!self.m_strPreset) then return end

	self.Window = vgui.Create( "PresetEditor" )
	self.Window:MakePopup()
	self.Window:Center()
	self.Window:SetType( self.m_strPreset )
	self.Window:SetConVars( self.ConVars )
	self.Window:SetPresetControl( self )

end

/*---------------------------------------------------------
   Add A ConVar to store
---------------------------------------------------------*/
function PANEL:AddConVar( convar )

	table.insert( self.ConVars, convar )

end


/*---------------------------------------------------------
   Name: GetConVars
---------------------------------------------------------*/
function PANEL:GetConVars( convar )

	return self.ConVars

end


/*---------------------------------------------------------
   Name: OpenPresetEditor
---------------------------------------------------------*/
function PANEL:SetPreset( strName )

	self.m_strPreset = strName
	self:ReloadPresets()

end


/*---------------------------------------------------------
   Name: ReloadPresets
---------------------------------------------------------*/
function PANEL:ReloadPresets()

	self:Clear()

	local t = presets.GetTable( self.m_strPreset )
	
	for k, v in pairs( t ) do
		self:AddOption( k, v )
	end

end

/*---------------------------------------------------------
   Name: Update
---------------------------------------------------------*/
function PANEL:Update()

	self:ReloadPresets()

end

/*---------------------------------------------------------
   Name: Clear
---------------------------------------------------------*/
function PANEL:Clear()

	self.DropDown:Clear()

end



vgui.Register( "ControlPresets", PANEL, "Panel" )