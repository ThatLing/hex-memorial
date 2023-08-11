////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu                                       //
////////////////////////////////////////////////
local proxi = proxi

local PROXI_MENU = nil

function proxi:GetMenu()
	return PROXI_MENU or self:BuildMenu()
	
end

function proxi:UpdateMenuPosition()
	local pos = self:GetVar( "menu_position" )
	if pos > 0 then
		PROXI_MENU:SetPos( ScrW() - PROXI_MENU:GetWide(), 0 )
		PROXI_MENU:GetContents()._p_topPanel._p_positionBox:SetType( "left" )
		
	else
		PROXI_MENU:SetPos( 0, 0 )
		PROXI_MENU:GetContents()._p_topPanel._p_positionBox:SetType( "right" )
		
	end
	
end

function proxi:BuildMenuContainer()
	self:RemoveMenu()
	
	local WIDTH = 230
	PROXI_MENU = vgui.Create( PROXI_SHORT .. "_ContextContainer" )
	PROXI_MENU:SetSize( WIDTH, ScrH() )
	PROXI_MENU:GetCanvas( ):SetDrawBackground( false )
	
	local mainPanel = vgui.Create( "DPanel" )
	PROXI_MENU:SetContents( mainPanel )
	
	///
	
	//mainPanel:SetDrawBackground( false )
	/*mainPanel.Paint = function (self)
		surface.SetDrawColor( 255, 0, 0, 96 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end*/
	
	PROXI_MENU.Paint = function (self)
		surface.SetDrawColor( 0, 0, 0, 96 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	
	mainPanel.Paint = function (self)
		surface.SetDrawColor( 0, 0, 0, 96 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	
	return PROXI_MENU
	
end

function proxi:BuildMenu()
	if not ValidPanel( PROXI_MENU ) then
		self:BuildMenuContainer()
		
	end
	
	local mainPanel = PROXI_MENU:GetContents()
	
	////
	local topPanel = proxi:BuildHeader( mainPanel, PROXI_NAME )
	
	////
	local tabMaster = vgui.Create( "DPropertySheet", mainPanel )
	do
		local formBeacons = vgui.Create( "DPanelList" )
		formBeacons:AddItem( self:BuildParamPanel( "global_finderdistance", { Type = "range", Text = "Global Finder : Distance limit", Min = 256, Max = 16384, Decimals = 0 } ) )
		
		do
			local beacons = proxi:GetAllBeacons()
			for _,sName in pairs( proxi:GetBeaconOrderTable() ) do
				local objBeacon = beacons[ sName ]
				
				local category = vgui.Create("ProxiCollapsibleCheckbox", refPanel)
				category:SetExpanded( false )
				category:SetText( objBeacon:GetDisplayName() )
				category:SetConVar( self:GetVarName( "beacons_enable_" .. sName ) )
				
				category.List  = vgui.Create("DPanelList", category )
				category.List:EnableHorizontal( false )
				category.List:EnableVerticalScrollbar( false )
				
				if objBeacon:HasBypassDistance() then
					category.List:AddItem( self:BuildParamPanel( "beacons_settings_" .. sName .. "__bypassdistance", { Type = "bool", Text = "Bypass distance limit" } ) )
				
				else
					category.Paint = function ( self )
						surface.SetDrawColor( 0, 0, 0 )
						surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
						
					end
				
				end
				
				category:SetContents( category.List )
				
				formBeacons:AddItem( category )
				
			end
			
		end
		
		local formOptions = vgui.Create( "DPanelList" )
		do
			formOptions:AddItem( self:BuildParamPanel( "regmod_xrel", { Type = "range", Text = "X Relative Position", Min = 0, Max = 1, Decimals = 2 } ) )
			formOptions:AddItem( self:BuildParamPanel( "regmod_yrel", { Type = "range", Text = "Y Relative Position", Min = 0, Max = 1, Decimals = 2 } ) )
			
			formOptions:AddItem( self:BuildParamPanel( "regmod_size", { Type = "range", Text = "Circle Size", Min = 0, Max = 1024, Decimals = 0 } ) )
			formOptions:AddItem( self:BuildParamPanel( "regmod_pinscale", { Type = "range", Text = "Pin Scale", Min = 0, Max = 10, Decimals = 0 } ) )
			formOptions:AddItem( self:BuildParamPanel( "noconvars", { Type = "panel_label", Text = "WARNING : The greater the Radius is, the more perspective should you set it up, otherwise 3D beacons won't dislay at all.", Wrap = true } ) )
			
			formOptions:AddItem( self:BuildParamPanel( "regmod_fov", { Type = "range", Text = "Isometric < > Perspective", Min = 2, Max = 100, Decimals = 0 } ) )
			formOptions:AddItem( self:BuildParamPanel( "regmod_radius", { Type = "range", Text = "In-world Radius", Min = 128, Max = 4096, Decimals = 0 } ) )
			formOptions:AddItem( self:BuildParamPanel( "regmod_angle", { Type = "range", Text = "Pitch Angle", Min = -90, Max = 90, Decimals = 0 } ) )
			formOptions:AddItem( self:BuildParamPanel( "regmod_pitchdyn", { Type = "range", Text = "Pitch Dynamism", Min = 0, Max = 10, Decimals = 0 } ) )
			
			formOptions:AddItem( self:BuildParamPanel( "eyemod_override", { Type = "bool", Text = "Enable Eye Mod (Debug mode)" } ) )
			
		end
		
		local formDesign = vgui.Create( "DPanelList" )
		do
			formDesign:AddItem( self:BuildParamPanel( "noconvars", { Type = "panel_label", Text = "Ring color" } ) )
			formDesign:AddItem( self:BuildParamPanel( "uidesign_ringcolor", { Type = "color" } ) )
			formDesign:AddItem( self:BuildParamPanel( "noconvars", { Type = "panel_label", Text = "Background color" } ) )
			formDesign:AddItem( self:BuildParamPanel( "uidesign_backcolor", { Type = "color" } ) )
			
		end
		
		formBeacons:EnableVerticalScrollbar( true )
		formOptions:EnableVerticalScrollbar( true )
		formDesign:EnableVerticalScrollbar( true )
		
		tabMaster:AddSheet( "Beacons", formBeacons, "gui/silkicons/application_view_detail", false, false, "All your scripts." )
		tabMaster:AddSheet( "Options", formOptions, "gui/silkicons/wrench", false, false, "Settings." )
		tabMaster:AddSheet( "UI", formDesign, "gui/silkicons/palette", false, false, "Appearance." )
		
	end
	
	////
	local optionsForm = vgui.Create( "DForm", mainPanel )
	do
		optionsForm:SetName( "Status" )
		
		local label = vgui.Create( "DLabel" )
		label:SetText( "None." )
		optionsForm:AddItem( label )
		
	end
	
	////
	mainPanel._p_topPanel = topPanel
	mainPanel._p_tabMaster = tabMaster
	mainPanel._p_optionsForm = optionsForm
	
	mainPanel._n_Spacing = 5
	mainPanel.PerformLayout = function (self)
		self:GetParent():StretchToParent( 0, 0, 0, 0 )
		self:StretchToParent( self._n_Spacing, self._n_Spacing, self._n_Spacing, self._n_Spacing )
		self._p_topPanel:PerformLayout()
		self._p_tabMaster:PerformLayout()
		self._p_optionsForm:PerformLayout()
		self._p_topPanel:Dock( TOP )
		self._p_optionsForm:Dock( BOTTOM )
		self._p_tabMaster:Dock( FILL )
	end
	
	PROXI_MENU:UpdateContents()
	self:UpdateMenuPosition()
	
	return PROXI_MENU
	
end

function proxi:RemoveMenu()
	if ValidPanel( PROXI_MENU ) then
		PROXI_MENU:Remove()
		PROXI_MENU = nil
	
	end
	
end

function proxi:MountMenu()
	self:CreateVarParam( "bool", "menu_position", "1", { callback = function ( a, b, c ) proxi:UpdateMenuPosition() end } )
	-- do nothing
	
end

function proxi:UnmountMenu()
	self:RemoveMenu()
	
end

function proxi:OpenMenu()
	self:GetMenu():Open()
	
end

function proxi:CloseMenu()
	self:GetMenu():Close()
	
end



function proxi:BuildHeader( mainPanel, sHeaderName )
	////
	local topPanel = vgui.Create( "DPanel", mainPanel )
	do
		local title = self:BuildParamPanel( "noconvar", { Type = "panel_label", Text = sHeaderName, ContentAlignment = 5, Font = "DefaultBold" } )
		title.Paint = function (self)
			surface.SetDrawColor( 0, 0, 0, 96 )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end
		title:SetParent( topPanel )
		
		local subTitle = nil
		do
			local MY_VERSION, ONLINE_VERSION = proxi_internal.GetVersionData()
			MY_VERSION = "v" .. tostring(MY_VERSION)
			ONLINE_VERSION = (ONLINE_VERSION == -1) and "(?)" or ("v" .. tostring( ONLINE_VERSION ))
			subTitle = self:BuildParamPanel( "noconvar", { Type = "panel_label", Text = "Using " .. (proxi_cloud:IsUsingCloud() and "Cloud " .. ONLINE_VERSION or "Locale " .. MY_VERSION), ContentAlignment = 4 } )
		end
		subTitle:SetParent( topPanel )
		
		local MY_VERSION, ONLINE_VERSION = proxi_internal.GetVersionData()
		if ((MY_VERSION < ONLINE_VERSION) and proxi_cloud:IsUsingCloud()) then
			subTitle:SetToolTip( "There is an update ! You're currently using a temporary copy of the new version (You have v" .. tostring( MY_VERSION ) .. " installed)." )
			subTitle.Think = function (self)
				local blink = 127 + (math.sin( math.pi * CurTime() * 0.5 ) + 1 ) * 64
				self:SetColor( Color( 255, 255, 255, blink ) ) // TODO : ?
				
			end
			
		end
		
		local enableBox = self:BuildParamPanel( "core_enable", { Type = "bool_nolabel", Style = "grip" } )
		enableBox:SetParent( title )
		enableBox:SetToolTip( "Toggle " .. tostring( sHeaderName ) .. "." )
		enableBox.Paint = function (self)
			local isEnabled = self:GetChecked()
			if isEnabled then
				--local blink = (math.sin( math.pi * CurTime() ) + 1 ) / 2 * 64
				local blink = 222 + (math.sin( math.pi * CurTime() ) + 1 ) * 16
				surface.SetDrawColor( blink, blink, blink, 255 )
				
			else
				surface.SetDrawColor( 192, 192, 192, 255 )
				
			end
			
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
			
			if not isEnabled and ( CurTime() % 1 > 0.5 ) then
				surface.DrawOutlinedRect( 2, 2, self:GetWide() - 4, self:GetTall() - 4 )
				
			end
			
		end
		
		local closeBox = self:BuildParamPanel( "noconvar", { Type = "panel_sysbutton", Style = "close", DoClick = function ( self ) proxi:CallCmd("-menu") end } )
		closeBox:SetParent( title )
		
		local positionBox = self:BuildParamPanel( "noconvar", { Type = "panel_sysbutton", Style = "left", DoClick = function ( self ) proxi:SetVar( "menu_position", (proxi:GetVar( "menu_position" ) > 0) and 0 or 1 ) end } )
		positionBox:SetParent( title )
		positionBox:SetToolTip( "Change menu dock position." )
		
		local reloadCloud = self:BuildParamPanel( "noconvar", { Type = "panel_imagebutton", Material = "gui/silkicons/toybox", DoClick = function() proxi:CallCmd("-menu") proxi:ReloadFromCloud() end } )
		reloadCloud:SetParent( subTitle )
		reloadCloud:SetToolTip( "Press to use the latest version from the Cloud." )
		
		local reloadLocale = self:BuildParamPanel( "noconvar", { Type = "panel_imagebutton", Material = "gui/silkicons/application_put", DoClick = function() proxi:CallCmd("-menu") proxi:ReloadFromLocale() end } )
		reloadLocale:SetParent( subTitle )
		reloadLocale:SetToolTip( "Press to use your Locale installed version." )
		
		local loadChangelog = self:BuildParamPanel( "noconvar", { Type = "panel_button", Text = "Changelog", DoClick = function() proxi:CallCmd("call_changelog") end } )
		loadChangelog:SetParent( subTitle )
		loadChangelog:SetToolTip( "Press to view the changelog." )
		
		if MY_VERSION < ONLINE_VERSION then
			loadChangelog.PaintOver = function ( self )
				local blink = (math.sin( math.pi * CurTime() * 0.5 ) + 1 ) * 64
				surface.SetDrawColor( 255, 255, 255, blink )
				draw.RoundedBoxEx( 2, 0, 0, self:GetWide(), self:GetTall(), Color( 255, 255, 255, blink ), true, true, true, true  )
				
			end
			loadChangelog:SetToolTip( "There are updates ! You should update your Locale." )
			
		else
			loadChangelog:SetToolTip( "Press to view the changelog." )
			
		end
		
		
		topPanel._p_title = title
		topPanel._p_subTitle = subTitle
		topPanel._p_enableBox = enableBox
		topPanel._p_closeBox = closeBox
		topPanel._p_positionBox = positionBox
		
		topPanel._p_reloadCloud = reloadCloud
		topPanel._p_reloadLocale = reloadLocale
		topPanel._p_loadChangelog = loadChangelog
	
	end
	topPanel.Paint = function (self)
		surface.SetDrawColor( 0, 0, 0, 96 )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	end
	topPanel.PerformLayout = function (self)
		self:SetWide( self:GetParent():GetWide() )
		self._p_title:SetWide( self:GetWide() )
		self._p_subTitle:SetWide( self:GetWide() )
		
		self._p_title:PerformLayout( )
		self._p_subTitle:PerformLayout( )
		self._p_enableBox:PerformLayout( )
		self._p_positionBox:PerformLayout( )
		self._p_closeBox:PerformLayout( )
		
		self._p_reloadCloud:PerformLayout( )
		self._p_reloadLocale:PerformLayout( )
		self._p_loadChangelog:PerformLayout( )
		
		self._p_title:CenterHorizontal( )
		self._p_subTitle:CenterHorizontal( )
		
		self:SetTall( self._p_title:GetTall() + self._p_subTitle:GetTall() )
		
		self._p_title:AlignTop( 0 )
		self._p_subTitle:SetWide( self._p_subTitle:GetWide() - 4 )
		self._p_subTitle:AlignLeft( 4 )
		self._p_subTitle:MoveBelow( self._p_title, 0 )
		
		local boxSize = self._p_title:GetTall()
		self._p_enableBox:SetSize( boxSize * 0.8, boxSize * 0.8 )
		self._p_positionBox:SetSize( boxSize * 0.8, boxSize * 0.8 )
		self._p_closeBox:SetSize( boxSize * 0.8, boxSize * 0.8 )
		self._p_enableBox:CenterVertical( )
		self._p_positionBox:CenterVertical( )
		self._p_closeBox:CenterVertical( )
		self._p_enableBox:AlignLeft( boxSize * 0.1 )
		self._p_closeBox:AlignRight( boxSize * 0.1 )
		self._p_positionBox:MoveLeftOf( self._p_closeBox, boxSize * 0.1 )
		
		local buttonSize = self._p_subTitle:GetTall()
		self._p_reloadCloud:SetSize( buttonSize * 0.8, buttonSize * 0.8 )
		self._p_reloadLocale:SetSize( buttonSize * 0.8, buttonSize * 0.8 )
		self._p_loadChangelog:SizeToContents( )
		self._p_loadChangelog:SetSize( self._p_loadChangelog:GetWide() + 6, buttonSize * 0.8 )
		self._p_reloadCloud:CenterVertical( )
		self._p_reloadLocale:CenterVertical( )
		self._p_loadChangelog:CenterVertical( )
		self._p_reloadCloud:AlignRight( boxSize * 0.1 )
		self._p_reloadLocale:MoveLeftOf( self._p_reloadCloud, boxSize * 0.1 )
		self._p_loadChangelog:MoveLeftOf( self._p_reloadLocale, boxSize * 0.3 )
	end
	
	return topPanel
	
end
