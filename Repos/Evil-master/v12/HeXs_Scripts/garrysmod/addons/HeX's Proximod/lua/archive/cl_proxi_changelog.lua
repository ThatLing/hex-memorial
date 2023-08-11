////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Changelog                                  //
////////////////////////////////////////////////

function proxi.BuildChangelog( opt_tExpand )
	if proxi.ChangelogPanel then proxi.ChangelogPanel:Remove() end
	
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
	
	proxi.ChangelogPanel = proxi.Util_MakeFrame( ScrW() * 0.95, ScrH() * 0.75, " - Changelog" )
	local refPanel = proxi.ChangelogPanel
	
	proxi.Util_MakeCategory( refPanel, "Changelog", 1 )
	
	if ONLINE_VERSION and ONLINE_VERSION ~= -1 and proxi_internal.GetReplicate then
		local myVer = MY_VERSION or 0
		
		local contents = proxi_internal.GetReplicate() or ( tostring( MY_VERSION or 0 ) .. "\n<Nothing to show>" )
		local split = string.Explode( "\n", contents )
		if (#split % 2) == 0 then
			local dList = vgui.Create("DListView")
			dList:SetMultiSelect( false )
			dList:SetTall( refPanel.W_HEIGHT - 40 )
			dList:AddColumn( "Ver." ):SetMaxWidth( 45 ) -- Add column
			dList:AddColumn( "Type" ):SetMaxWidth( 60 ) -- Add column
			dList:AddColumn( "Log" )
			
			local gotMyVer = false
			for i=1, #split, 2 do
				local iVer = tonumber( split[i] or 0 ) or 0
				if not gotMyVer and iVer ~= 0 and iVer <= myVer and (split[i+2] ~= "&") then
					dList:AddLine( "*" .. myVer .. "*", "Locale", "< Currently installed version >" )
					gotMyVer = true
					
				end
				local nature = tonumber( split[i] )
				nature = (nature == nil) and "" or math.floor(nature*1000) % 10 > 0 and "Fix" or math.floor(nature*100) % 10 > 0 and "Feature" or "Release"
				local myLine = dList:AddLine( (split[i] ~= "&") and split[i] or "", tostring(nature), split[i+1] or "" )
				myLine:SizeToContents()
				
			end
			
			proxi.Util_AppendPanel( refPanel, dList )
			--dList:SizeToContents()
			
		else
			proxi.Util_AppendLabel( refPanel, "<Changelog data is corrupted>", 70, true )
			
		end
		
	elseif not proxi_internal.GetReplicate then
		proxi.Util_AppendLabel( refPanel, "Couldn't load changelog because your Locale version is too old.", 70, true )
		
	else
		proxi.Util_AppendLabel( refPanel, "Couldn't load changelog because ".. PROXI_NAME .." failed to pickup information from the Cloud.", 70, true )
	
	end
	
	proxi.Util_ApplyCategories( refPanel )

end

function proxi.ShowChangelog( optbKeyboardShouldNotOverride )
	if not proxi.ChangelogPanel then
		proxi.BuildChangelog()
	end
	proxi.ChangelogPanel:MakePopup()
	proxi.ChangelogPanel:SetKeyboardInputEnabled( not optbKeyboardShouldNotOverride )
	proxi.ChangelogPanel:SetVisible( true )
end

function proxi.HideChangelog()
	if not proxi.ChangelogPanel then
		return
	end
	proxi.ChangelogPanel:SetVisible( false )
end

function proxi.DestroyChangelog()
	if proxi.ChangelogPanel then
		proxi.ChangelogPanel:Remove()
		proxi.ChangelogPanel = nil
	end
end
