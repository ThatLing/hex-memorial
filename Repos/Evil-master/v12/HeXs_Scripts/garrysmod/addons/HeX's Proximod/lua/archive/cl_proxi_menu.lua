////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu                                       //
////////////////////////////////////////////////

function proxi.MenuCall_ReloadFromCloud()
	if proxi_cloud then
		proxi_cloud:Ask()
	end
	
end

function proxi.MenuCall_ReloadFromLocale()
	if proxi_cloud then
		proxi_cloud:LoadLocale()
	end
	
end

function proxi.BuildMenu( opt_tExpand )
	if proxi.DermaPanel then proxi.DermaPanel:Remove() end
	
	local bCanGetVersion = proxi_internal ~= nil
	local MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK
	local ONLINE_VERSION_READ = -1
	if bCanGetVersion then
		MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK = proxi_internal.GetVersionData()
		
		if ONLINE_VERSION == -1 then
			ONLINE_VERSION_READ = "<offline>"
		else
			ONLINE_VERSION_READ = tostring( ONLINE_VERSION )
		end
		
	end
	
	proxi.DermaPanel = proxi.Util_MakeFrame( 280, ScrH() * 0.80 )
	local refPanel = proxi.DermaPanel
	
	proxi.Util_MakeCategory( refPanel, "General", 1 )
	proxi.Util_AppendCheckBox( refPanel, "Enable" , "proxi_core_enable" )
	
	--Helper label
	do
		local GeneralTextLabelMessage = "The command \"proxi_menu\" calls this menu.\n"
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Example : To assign " .. PROXI_NAME .. " menu to F10, type in the console :"
		
		proxi.Util_AppendLabel( refPanel, GeneralTextLabelMessage, 50, true )
		
		local GeneralCommandLabel = vgui.Create("DTextEntry")
		GeneralCommandLabel:SetText( "bind \"F10\" \"proxi_menu\"" )
		GeneralCommandLabel:SetEditable( false )

		proxi.Util_AppendPanel( refPanel, GeneralCommandLabel )
		
	end
	
	
	--Update label
	do
		if bCanGetVersion and (MY_VERSION and ONLINE_VERSION and (MY_VERSION < ONLINE_VERSION)) then
			GeneralTextLabelMessage = "Your version is "..MY_VERSION.." and the updated one is "..ONLINE_VERSION.." ! You should update !"
			proxi.Util_AppendLabel( refPanel, GeneralTextLabelMessage, 50, true )
			
			local CReload = vgui.Create("DButton")
			CReload:SetText( "Open full Changelog" )
			CReload.DoClick = proxi.ShowChangelog
			proxi.Util_AppendPanel( refPanel, CReload )
			
			proxi.Util_AppendLabel( refPanel, "" )
			
			if ONLINE_VERSION and ONLINE_VERSION ~= -1 then
				local myVer = MY_VERSION or 0
				
				local contents = proxi_internal.GetReplicate() or ( tostring( MY_VERSION or 0 ) .. "\n<Nothing to show>" )
				local split = string.Explode( "\n", contents )
				if (#split % 2) == 0 then
					local dList = vgui.Create("DListView")
					dList:SetMultiSelect( false )
					dList:SetTall( 150 )
					dList:AddColumn( "Ver." ):SetMaxWidth( 45 ) -- Add column
					dList:AddColumn( "Log" )
					
					local gotMyVer = false
					local i = 1
					while (i <= #split) and not gotMyVer do
						local iVer = tonumber( split[i] or 0 ) or 0
						if not gotMyVer and iVer ~= 0 and iVer <= myVer and (split[i+2] ~= "&") then
							dList:AddLine( "*" .. myVer .. "*", "< Locale version >" )
							gotMyVer = true
							
						else
							local myLine = dList:AddLine( (split[i] ~= "&") and split[i] or "", split[i+1] or "" )
							myLine:SizeToContents()
							
						end
						
						i = i + 2
						
					end
					
					proxi.Util_AppendPanel( refPanel, dList )
					
				end
				
			end
			
		end
		
	end
	
	-- Style
	proxi.Util_MakeCategory( refPanel, "Regular Mode", 1 )
	proxi.Util_AppendSlider( refPanel, "X Relative Position", "proxi_regmod_xrel", 0, 1, 2)
	proxi.Util_AppendSlider( refPanel, "Y Relative Position", "proxi_regmod_yrel", 0, 1, 2)
	proxi.Util_AppendSlider( refPanel, "Circle Size", "proxi_regmod_size", 32, 1024, 0)
	proxi.Util_AppendSlider( refPanel, "Pin Scale", "proxi_regmod_pinscale", 0, 10, 0)
	proxi.Util_AppendLabel( refPanel, "WARNING : The greater the Radius is, the more perspective should you set it up, otherwise 3D beacons won't dislay at all.", 50 )
	proxi.Util_AppendSlider( refPanel, "Isometric < > Perspective", "proxi_regmod_fov", 2, 100, 0)
	proxi.Util_AppendSlider( refPanel, "In-world Radius", "proxi_regmod_radius", 128, 4096, 0)
	proxi.Util_AppendSlider( refPanel, "Pitch Angle", "proxi_regmod_angle", -90, 90, 0)
	proxi.Util_AppendSlider( refPanel, "Pitch Dynamism", "proxi_regmod_pitchdyn", 0, 10, 0)
	
	-- EyeMod
	proxi.Util_MakeCategory( refPanel, "Eye Mode", 1 )
	proxi.Util_AppendCheckBox( refPanel, "Debug" , "proxi_eyemod_override" )
	
	
	-- UI Design
	proxi.Util_MakeCategory( refPanel, "UI Design", 0 )
	proxi.Util_AppendLabel( refPanel, "Ring color" )
	proxi.Util_AppendColor( refPanel, "proxi_uidesign_ringcolor")
	proxi.Util_AppendLabel( refPanel, "Background color" )
	proxi.Util_AppendColor( refPanel, "proxi_uidesign_backcolor")
	
	-- Global Beacons parameters
	proxi.Util_MakeCategory( refPanel, "Global Finder", 1 )
	proxi.Util_AppendLabel( refPanel, "NOTE : Beacons are able to bypass this distance using a checkbox.", 50 )
	proxi.Util_AppendSlider( refPanel, "Beacon finder distance", "proxi_global_finderdistance", 1024, 16384, 0)
	
	-- Beacons
	proxi.Util_MakeCategory( refPanel, "Beacons", 1 )
	do
		local cat = proxi.Util_CatchCurrentCategory( refPanel )
		cat.List:SetSpacing( 5 )
		
	end
	
	do
		local beacons = proxi:GetAllBeacons()
		for _,sName in pairs( proxi:GetBeaconOrderTable() ) do
			local objBeacon = beacons[ sName ]
			
			local category = vgui.Create("ProxiCollapsibleCheckbox", refPanel)
			category:SetExpanded( false )
			category:SetText( objBeacon:GetDisplayName() )
			category:SetConVar( "proxi_beacons_enable_" .. sName )
			
			category.List  = vgui.Create("DPanelList", category )
			category.List:EnableHorizontal( false )
			category.List:EnableVerticalScrollbar( false )
			
			/*local label = vgui.Create( "DLabel", category )
			label:SetText( objBeacon:GetDescription() or "No description" )
			category.List:AddItem( label )*/
			
			if objBeacon:HasBypassDistance() then
				category.List:AddItem( proxi.Util_CreateCheckBox( "Bypass distance limit" , "proxi_beacons_settings_" .. sName .. "__bypassdistance") )
				
			end
			
			category:SetContents( category.List )
			
			proxi.Util_AppendPanel( refPanel, category )
			
		end
		
	end
	
	
	
	if proxi_internal.IsUsingCloud then
		if proxi_internal.IsUsingCloud() then
			proxi.Util_MakeCategory( refPanel, "Using Cloud" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
		
		else
			proxi.Util_MakeCategory( refPanel, "Using Locale" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
			
		end
		
	else
		proxi.Util_MakeCategory( refPanel, "Cloud" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
		
	end
	
	-- Reload from Cloud Button
	do
		local CReload = vgui.Create("DButton")
		CReload:SetText( "Reload from Cloud" )
		CReload.DoClick = proxi.MenuCall_ReloadFromCloud
		proxi.Util_AppendPanel( refPanel, CReload )
	end
	
	-- Reload from Locale Button
	if proxi_internal then
		local CReload = vgui.Create("DButton")
		CReload:SetText( "Reload from Locale" )
		CReload.DoClick = proxi.MenuCall_ReloadFromLocale
		proxi.Util_AppendPanel( refPanel, CReload )
	end
	
	-- Changelog Button
	if proxi_internal and proxi_internal.GetReplicate then
		proxi.Util_AppendLabel( refPanel, "" )
		
		local CChangelog = vgui.Create("DButton")
		CChangelog:SetText( "Open Changelog" )
		CChangelog.DoClick = proxi.ShowChangelog
		proxi.Util_AppendPanel( refPanel, CChangelog )
	end
	
	proxi.Util_ApplyCategories( refPanel )
	
end


function proxi.ShowMenuNoOverride( )
	proxi.ShowMenu( true )
end

function proxi.ShowMenu( optbKeyboardShouldNotOverride )
	if not proxi.DermaPanel then
		proxi.BuildMenu()
	end
	--proxi.DermaPanel:Center()
	proxi.DermaPanel:MakePopup()
	proxi.DermaPanel:SetKeyboardInputEnabled( not optbKeyboardShouldNotOverride )
	proxi.DermaPanel:SetVisible( true )
end

function proxi.HideMenu()
	if not proxi.DermaPanel then
		return
	end
	proxi.DermaPanel:SetVisible( false )
end

function proxi.DestroyMenu()
	if proxi.DermaPanel then
		proxi.DermaPanel:Remove()
		proxi.DermaPanel = nil
	end
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// SANDBOX PANEL .

function proxi.Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "proxi_core_enable" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (proxi_menu)", 
			Description = "Open Menu (proxi_menu)", 
			Command = "proxi_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type proxi_menu in the console, or bind this command to any key.")
end

function proxi.AddPanel()
	spawnmenu.AddToolMenuOption("Options", "Player", PROXI_NAME, PROXI_NAME, "", "", proxi.Panel, {SwitchConVar = 'proxi_core_enable'})
	
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// MOUNT FCTS.

function proxi.MountMenu()
	concommand.Add( "proxi_menu", proxi.ShowMenuNoOverride )
	concommand.Add( "proxi_call_menu", proxi.ShowMenuNoOverride )
	concommand.Add( "+proxi_menu", proxi.ShowMenu )
	concommand.Add( "-proxi_menu", proxi.HideMenu )
	
end

function proxi.UnmountMenu()
	proxi.DestroyMenu()

	concommand.Remove( "proxi_call_menu" )
	concommand.Remove( "proxi_menu" )
	concommand.Remove( "+proxi_menu" )
	concommand.Remove( "-proxi_menu" )
	
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////