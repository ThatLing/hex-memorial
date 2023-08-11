////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu Utilities                             //
////////////////////////////////////////////////

function proxi.Util_FrameGetExpandTable( myPanel )
	local expandTable = {}
	
	for k,subtable in pairs( myPanel.Categories ) do
		table.insert(expandTable, subtable[1]:GetExpanded())
		
	end
	
	return expandTable
end

function proxi.Util_AppendPanel( myPanel, thisPanel )
	local toAppendIn = myPanel.Categories[#myPanel.Categories][1].List
	
	thisPanel:SetParent( toAppendIn )
	toAppendIn:AddItem( thisPanel )
	
end


function proxi.Util_CreateCheckBox( title, cvar )
	local checkbox = vgui.Create( "DCheckBoxLabel" )
	checkbox:SetText( title )
	checkbox:SetConVar( cvar )
	
	return checkbox
	
end

function proxi.Util_AppendCheckBox( myPanel, title, cvar )

	local checkbox = proxi.Util_CreateCheckBox( title, cvar )
	
	proxi.Util_AppendPanel( myPanel, checkbox )
	
end

function proxi.Util_AppendLabel( myPanel, sText, optiSize, optbWrap )

	local label = vgui.Create( "DLabel" )
	label:SetText( sText )
	
	if optiSize then
		label:SetWrap( true )
		label:SetContentAlignment( 2 )
		label:SetSize( myPanel.W_WIDTH, optiSize )
		
	end
	
	if optbWrap then
		label:SetWrap( true )
		
	end
	
	proxi.Util_AppendPanel( myPanel, label )
	
end

function proxi.Util_AppendSlider( myPanel, sText, sCvar, fMin, fMax, iDecimals)
	local slider = vgui.Create("DNumSlider")
	slider:SetText( sText )
	slider:SetMin( fMin )
	slider:SetMax( fMax )
	slider:SetDecimals( iDecimals )
	slider:SetConVar( sCvar )
	
	proxi.Util_AppendPanel( myPanel, slider )
end

function proxi.Util_AppendColor( myPanel, sCvar )
	local ctrl = vgui.Create("CtrlColor")
	ctrl.Prefix = sCvar
	ctrl:SetConVarR(ctrl.Prefix .."_r")
	ctrl:SetConVarG(ctrl.Prefix .."_g")
	ctrl:SetConVarB(ctrl.Prefix .."_b")
	ctrl:SetConVarA(ctrl.Prefix .."_a")
	proxi.Util_AppendPanel(myPanel, ctrl)
end

function proxi.Util_AppendPreset( myPanel, sFolder, tCvars, opttOptions )
	local ctrl = vgui.Create( "ControlPresets", self )
	
	ctrl:SetPreset( sFolder )
	
	if ( opttOptions ) then
		for k, v in pairs( opttOptions ) do
			if ( k != "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( tCvars ) then
		for k, v in pairs( tCvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	proxi.Util_AppendPanel( myPanel, ctrl )
	
end

function proxi.Util_MakeFrame( width, height, optsTitleAppend )
	local myPanel = vgui.Create( "DFrame" )
	local border = 4
	
	myPanel.W_HEIGHT = height - 20
	myPanel.W_WIDTH = width - 2 * border
	
	myPanel:SetPos( ScrW() * 0.5 - width * 0.5 , ScrH() * 0.5 - height * 0.5 )
	myPanel:SetSize( width, height )
	myPanel:SetTitle( PROXI_NAME .. (proxi_internal.IsUsingCloud and proxi_internal.IsUsingCloud() and " over Cloud" or "" ) .. (optsTitleAppend or "" ) )
	myPanel:SetVisible( false )
	myPanel:SetDraggable( true )
	myPanel:ShowCloseButton( true )
	myPanel:SetDeleteOnClose( false )
	
	myPanel.Contents = vgui.Create( "DPanelList", myPanel )
	myPanel.Contents:SetPos( border , 22 + border )
	myPanel.Contents:SetSize( myPanel.W_WIDTH, height - 2 * border - 22 )
	myPanel.Contents:SetSpacing( 5 )
	myPanel.Contents:EnableHorizontal( false )
	myPanel.Contents:EnableVerticalScrollbar( false )
	
	myPanel.Categories = {}
	
	return myPanel
end

function proxi.Util_MakeCategory( myPanel, sTitle, bExpandDefault )
	local category = vgui.Create("DCollapsibleCategory", myPanel.Contents)
	category.List  = vgui.Create("DPanelList", category )
	table.insert( myPanel.Categories, {category, bExpandDefault} )
	category:SetSize( myPanel.W_WIDTH, 50 )
	category:SetLabel( sTitle )
	
	category.List:EnableHorizontal( false )
	category.List:EnableVerticalScrollbar( false )
	
	return category
end

function proxi.Util_CatchCurrentCategory( myPanel )
	return myPanel.Categories[ #myPanel.Categories ][ 1 ]
	
end

function proxi.Util_ApplyCategories( myPanel )
	for k,subtable in pairs( myPanel.Categories ) do
		subtable[1]:SetExpanded( opt_tExpand and (opt_tExpand[k] and 1 or 0) or subtable[2] )
		subtable[1].List:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 - 10 )
		subtable[1]:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 )
		
		subtable[1].List:PerformLayout()
		subtable[1].List:SizeToContents()
		
		subtable[1]:SetContents( subtable[1].List )
		
		myPanel.Contents:AddItem( subtable[1] )
	end
	
end

