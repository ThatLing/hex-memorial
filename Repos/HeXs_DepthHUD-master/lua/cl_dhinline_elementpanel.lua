////////////////////////////////////////////////
// -- Depth HUD : Inline                      //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// The Menu                                   //
////////////////////////////////////////////////

HeXInclude( 'DSysButton.lua' )
HeXInclude( 'DMultiChoice.lua' )
HeXInclude( 'CtrlColor.lua' )
HeXInclude( 'DhCheckPos.lua' )
HeXInclude( 'control_presets.lua' )

local MY_VERSION = 1337--tonumber(string.Explode( "\n", file.Read("depthhud_inline.txt", "DATA"))[1])
local SVN_VERSION = 1337
local DOWNLOAD_LINK = "Gone"

////
// Condefs/convars code taken from SmartSnap
local style_condefs = {
	dhinline_col_base_r = 255,
	dhinline_col_base_g = 220,
	dhinline_col_base_b = 0,
	dhinline_col_base_a = 192,

	dhinline_col_back_r = 0,
	dhinline_col_back_g = 0,
	dhinline_col_back_b = 0,
	dhinline_col_back_a = 92,
	
	dhinline_ui_blendfonts = "1",
	dhinline_ui_drawglow = "0",
	dhinline_ui_dynamicbackground = "0",
	
	dhinline_ui_spacing = 1
}

local style_convars = {}

for key,value in pairs(style_condefs) do
	style_convars[#style_convars + 1] = key
end

/*local my_preset_opts = {
		options = { ["default"] = style_condefs },
		cvars = style_convars,
		folder = "dhinline_style"
	}*/

////

function dhinline_RevertStyle()
	for k,v in pairs(style_condefs) do
		RunConsoleCommand(k, v)
	end
end
concommand.Add("dhinline_revertstyle", dhinline_RevertStyle)

function dhinline_GetVersionData()
	return MY_VERSION, SVN_VERSION, DOWNLOAD_LINK
end

--[[
local function dhinline_GetVersion( contents , size )
	//Taken from RabidToaster Achievements mod.
	local split = string.Explode( "\n", contents )
	local version = tonumber( split[ 1 ] or "" )
	
	if ( !version ) then
		SVN_VERSION = -1
		return
	end
	
	SVN_VERSION = version
	
	if ( split[ 2 ] ) then
		DOWNLOAD_LINK = split[ 2 ]
	end
end

http.Get( "http://depthhudinfo.googlecode.com/svn/trunk/data/depthhud_inline.txt", "", dhinline_GetVersion )
]]

function dhinline_MakePresetPanel( data )
	local ctrl = vgui.Create("ControlPresets")
	
	ctrl:SetPreset( data.folder )
	
	if ( data.options ) then
		for k, v in pairs( data.options ) do
			if ( k != "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( data.cvars ) then
		for k, v in pairs( data.cvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	return ctrl
end

function dhinline_ShowMenu()
	local DermaPanel = vgui.Create( "DFrame" )
	//local w,h = 288,288
	local w,h = 288,ScrH()*0.6
	local border = 4
	local W_WIDTH = w - 2*border
	
	////// // // THE FRAME
	DermaPanel:SetPos( ScrW()*0.5 - w*0.5 , ScrH()*0.5 - h*0.5 )
	DermaPanel:SetSize( w, h )
	DermaPanel:SetTitle( "DepthHUD Inline" )
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( true )
	DermaPanel:MakePopup()
	
	local PanelList = vgui.Create( "DPanelList", DermaPanel )
	PanelList:SetPos( border , 22 + border )
	PanelList:SetSize( W_WIDTH, h - 2*border - 22 )
	//PanelList:SetAutoSize( true )
	PanelList:SetSpacing( 5 )
	PanelList:EnableHorizontal( false )
	PanelList:EnableVerticalScrollbar( true )
	
	////// CATEGORY : GENERAL
	local GeneralCategory = vgui.Create("DCollapsibleCategory", PanelList)
	GeneralCategory:SetSize( W_WIDTH, 50 )
	GeneralCategory:SetExpanded( 1 ) -- Expanded when popped up
	GeneralCategory:SetLabel( "General" )
	
	local GeneralCatList = vgui.Create( "DPanelList" )
	GeneralCatList:SetSize(W_WIDTH, h - 160 )
	GeneralCatList:SetAutoSize( true )
	GeneralCatList:EnableHorizontal( false )
	GeneralCatList:EnableVerticalScrollbar( false )
	
	// ENABLE CHECK
	local GeneralEnableCheck = vgui.Create( "DCheckBoxLabel" )
	GeneralEnableCheck:SetText( "Enable" )
	GeneralEnableCheck:SetConVar( "dhinline_enable" )
	GeneralEnableCheck:SetValue( GetConVarNumber( "dhinline_enable" ) )
	
	// DISABLE BASE HUD CHECK
	local GeneralDefaultCheck = vgui.Create( "DCheckBoxLabel" )
	GeneralDefaultCheck:SetText( "Disable Base HUD" )
	GeneralDefaultCheck:SetConVar( "dhinline_disabledefault" )
	GeneralDefaultCheck:SetValue( GetConVarNumber( "dhinline_disabledefault" ) )
	
	// DHDIV
	local GeneralTextLabel = vgui.Create("DLabel")
	local GeneralTextLabelMessage = "The command \"dhinline_menu\" calls this menu.\n"
	if not (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION)) then
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Example : To assign inline menu to F7, type in the console :"
	else
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Your version is "..MY_VERSION.." and the updated one is "..SVN_VERSION.." ! You should update !"
	end
	GeneralTextLabel:SetWrap( true )
	GeneralTextLabel:SetText( GeneralTextLabelMessage )
	GeneralTextLabel:SetContentAlignment( 7 )
	GeneralTextLabel:SetSize( W_WIDTH, 40 )
	
	// DHMENU BUTTON
	local GeneralCommandLabel = vgui.Create("DTextEntry")
	if not (MY_VERSION and SVN_VERSION and (MY_VERSION < SVN_VERSION) and DOWNLOAD_LINK) then
		GeneralCommandLabel:SetText( "bind \"F7\" \"dhinline_menu\"" )
	else
		GeneralCommandLabel:SetText( DOWNLOAD_LINK )
	end
	GeneralCommandLabel:SetEditable( false )
	
	// HUDLAG MUL
	local GeneralHudlagMulSlider = vgui.Create("DNumSlider")
	GeneralHudlagMulSlider:SetText( "HUD Lag : Dispersion" )
	GeneralHudlagMulSlider:SetMin( 0 )
	GeneralHudlagMulSlider:SetMax( 4 )
	GeneralHudlagMulSlider:SetDecimals( 2 )
	GeneralHudlagMulSlider:SetConVar("dhinline_ui_hudlag_mul")
	
	// HUDLAG RETAB
	local GeneralHudlagRetabSlider = vgui.Create("DNumSlider")
	GeneralHudlagRetabSlider:SetText( "HUD Lag : Repel (0.2 Recommended)" )
	GeneralHudlagRetabSlider:SetMin( 0.1 )
	GeneralHudlagRetabSlider:SetMax( 0.4 )
	GeneralHudlagRetabSlider:SetDecimals( 2 )
	GeneralHudlagRetabSlider:SetConVar("dhinline_ui_hudlag_retab")
	
	// MAKE: GENERAL
	GeneralCatList:AddItem( GeneralEnableCheck )         //Adds the ENABLE CHECK
	GeneralCatList:AddItem( GeneralDefaultCheck )        //Adds the DEFAULT CHECK
	GeneralCatList:AddItem( GeneralHudlagMulSlider )     //Adds the HUD LAG MUL SLIDER 
	GeneralCatList:AddItem( GeneralHudlagRetabSlider )   //Adds the HUD LAG RETAB SLIDER 
	GeneralCatList:AddItem( GeneralTextLabel )           //Adds the DHDIV
	GeneralCatList:AddItem( GeneralCommandLabel )        //Adds the DHMENU
	GeneralCatList:InvalidateLayout(true)
	//GeneralCatList:SizeToContents()
	GeneralCategory:SetContents( GeneralCatList )        //CATEGORY GENERAL FILLED
	
	
	
	////// CATEGORY : ELEMENTS
	local ElementsCategory = vgui.Create("DCollapsibleCategory", PanelList)
	ElementsCategory:SetSize( W_WIDTH, 50 )
	ElementsCategory:SetExpanded( 0 ) -- Expanded when popped up
	ElementsCategory:SetLabel( "Elements" )
	
	local ElementsCatList = vgui.Create( "DPanelList" )
	ElementsCatList:SetAutoSize( true )
	ElementsCatList:SetSize(W_WIDTH, h - 70 )
	ElementsCatList:EnableHorizontal( false )
	ElementsCatList:EnableVerticalScrollbar( false )
	
	// PRESETS : ELEMENTS
	local ElementsCompoSaver = dhinline_MakePresetPanel( {
		options = { ["default"] = dhinline.GetAllDefaultsTable() },
		cvars = dhinline.GetConVarTable(),
		folder = "dhinline_elements"
	} )
	
	// MAIN ELEMENT LIST
	local ElementsList = vgui.Create( "DPanelList" )
	ElementsList:SetAutoSize( true )
	ElementsList:SetSize( W_WIDTH, h - 150 )
	ElementsList:SetSpacing( 5 )
	ElementsList:EnableHorizontal( false )
	ElementsList:EnableVerticalScrollbar( true )
	local names = dhinline.GetNamesTable()
	for k,name in pairs(names) do
		local element_name = dhinline.Get(name).Name or name
		
		local ListCheck = vgui.Create( "DhCheckPos" )
		ListCheck:SetText( element_name )
		ListCheck:SetConVar( "dhinline_element_" .. name )
		ListCheck:SetConVarX( "dhinline_element_" .. name .. "_x" )
		ListCheck:SetConVarY( "dhinline_element_" .. name .. "_y" )
		ListCheck:SetMinMax( 0 , dhinline_GetGridDivideMax() )
		/*dhinline.Get(name):CreateMyPanel( ListCheck:GetOptionsPanelList() )
		ListCheck:SizeToContents()
		ListCheck:PerformLayout()*/
		ListCheck.button.DoClick = function()
			RunConsoleCommand( "dhinline_element_" .. name .. "_x", dhinline.Get(name).DefaultGridPosX )
			RunConsoleCommand( "dhinline_element_" .. name .. "_y", dhinline.Get(name).DefaultGridPosY )
			//dhinline.Get(name):ResetMyConVars( )
		end
		ElementsList:AddItem( ListCheck ) -- Add the item above
	end
	
	// RELOAD BUTTON
	local ElementReloadButton = vgui.Create("DButton")
	ElementReloadButton:SetText( "Reload Element Files" )
	ElementReloadButton.DoClick = function()
		RunConsoleCommand("dhinline_reloadelements")
		DermaPanel:Close()
		RunConsoleCommand("dhinline_menu")
	end
	
	// MAKE: ELEMENTS
	ElementsCatList:AddItem( ElementsCompoSaver )   //Adds ELEMENT PRESETS
	ElementsCatList:AddItem( ElementsList )         //Adds the ELEMENT LIST
	ElementsCatList:AddItem( ElementReloadButton )  //Adds the RELOAD BUTTON
	ElementsCatList:PerformLayout()
	ElementsCatList:SizeToContents()
	ElementsCategory:SetContents( ElementsCatList ) //CATEGORY ELEMENTS FILLED
	
	
	////// CATEGORY : UIStyle
	local UIStyleCategory = vgui.Create("DCollapsibleCategory", PanelList)
	UIStyleCategory:SetSize( W_WIDTH, 50 )
	UIStyleCategory:SetExpanded( 0 ) -- Expanded when popped up
	UIStyleCategory:SetLabel( "UI Design" )
	
	local UIStyleCatList = vgui.Create( "DPanelList" )
	UIStyleCatList:SetAutoSize( true )
	UIStyleCatList:SetSize(W_WIDTH, 128 )
	UIStyleCatList:EnableHorizontal( false )
	UIStyleCatList:EnableVerticalScrollbar( false )
	
	// REVERT BUTTON
	local UIStyleRevertButton = vgui.Create("DButton")
	UIStyleRevertButton:SetText( "Revert Style back to Defaults" )
	UIStyleRevertButton.DoClick = function()
		RunConsoleCommand("dhinline_revertstyle")
	end
	
	// PRESETS : STYLE
	local UIStyleSaver = dhinline_MakePresetPanel( {
		options = { ["default"] = style_condefs },
		cvars = style_convars,
		folder = "dhinline_style"
	} )
	
	// DYNAMIC BACK
	local UIStyleDynamicbackCheck = vgui.Create( "DCheckBoxLabel" )
	UIStyleDynamicbackCheck:SetText( "Enable Dynamic Background" )
	UIStyleDynamicbackCheck:SetConVar( "dhinline_ui_dynamicbackground" )
	UIStyleDynamicbackCheck:SetValue( GetConVarNumber( "dhinline_ui_dynamicbackground" ) )
	
	// DRAWGLOW BACK
	local UIStyleDrawglowCheck = vgui.Create( "DCheckBoxLabel" )
	UIStyleDrawglowCheck:SetText( "Enable Glow" )
	UIStyleDrawglowCheck:SetConVar( "dhinline_ui_drawglow" )
	UIStyleDrawglowCheck:SetValue( GetConVarNumber( "dhinline_ui_drawglow" ) )
	
	// BLENDFONT
	local UIStyleBlendfontsCheck = vgui.Create( "DCheckBoxLabel" )
	UIStyleBlendfontsCheck:SetText( "Fonts use Additive Mode" )
	UIStyleBlendfontsCheck:SetConVar( "dhinline_ui_blendfonts" )
	UIStyleBlendfontsCheck:SetValue( GetConVarNumber( "dhinline_ui_blendfonts" ) )
	
	// SIZE XREL
	local UIStyleSpacingSlider = vgui.Create("DNumSlider")
	UIStyleSpacingSlider:SetText( "Spacing" )
	UIStyleSpacingSlider:SetMin( 0 )
	UIStyleSpacingSlider:SetMax( 2 )
	UIStyleSpacingSlider:SetDecimals( 1 )
	UIStyleSpacingSlider:SetConVar("dhinline_ui_spacing")
	
	// COLOR BASE
	local UIBaseCLabel = vgui.Create("DLabel")
	UIBaseCLabel:SetText( "Base Color" )
	local UIBaseColor = vgui.Create("CtrlColor")
	UIBaseColor:SetSize( W_WIDTH, 108 )
	UIBaseColor:SetConVarR("dhinline_col_base_r")
	UIBaseColor:SetConVarG("dhinline_col_base_g")
	UIBaseColor:SetConVarB("dhinline_col_base_b")
	UIBaseColor:SetConVarA("dhinline_col_base_a")
	
	// COLOR BACK
	local UIBackCLabel = vgui.Create("DLabel")
	UIBackCLabel:SetText( "Back Color" )
	local UIBackColor = vgui.Create("CtrlColor")
	UIBackColor:SetSize( W_WIDTH, 108 )
	UIBackColor:SetConVarR("dhinline_col_back_r")
	UIBackColor:SetConVarG("dhinline_col_back_g")
	UIBackColor:SetConVarB("dhinline_col_back_b")
	UIBackColor:SetConVarA("dhinline_col_back_a")
	
	// MAKE: UIStyle
	UIStyleCatList:AddItem( UIStyleRevertButton )       //Adds the REVERT BUTTON
	UIStyleCatList:AddItem( UIStyleSaver )              //Adds PRESETS
	UIStyleCatList:AddItem( UIStyleDynamicbackCheck )
	UIStyleCatList:AddItem( UIStyleDrawglowCheck )
	UIStyleCatList:AddItem( UIStyleBlendfontsCheck )
	UIStyleCatList:AddItem( UIStyleSpacingSlider )       //Adds the SPACING SLIDER
	UIStyleCatList:AddItem( UIBaseCLabel )               //Adds the BASE LBL
	UIStyleCatList:AddItem( UIBaseColor )                //Adds the BASE COLOR
	UIStyleCatList:AddItem( UIBackCLabel )               //Adds the BACK LBL
	UIStyleCatList:AddItem( UIBackColor )                //Adds the BACK COLOR
	UIStyleCatList:PerformLayout()
	UIStyleCatList:SizeToContents()
	UIStyleCategory:SetContents( UIStyleCatList )        //CATEGORY GENERAL FILLED
	
	
	
	
	
	
	//FINISHING THE PANEL
	PanelList:AddItem( GeneralCategory )	      //CATEGORY GENERAL CREATED
	PanelList:AddItem( ElementsCategory )	      //CATEGORY ELEMENTS CREATED
	PanelList:AddItem( UIStyleCategory )	      //CATEGORY UIStyle CREATED

end
concommand.Add("dhinline_menu",dhinline_ShowMenu)

