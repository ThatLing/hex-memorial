////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Changelog                                  //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

do
	local PANEL = {}

	function PANEL:Init( )

	end

	function PANEL:Compose( bToLocale )
		bToLocale = bToLocale or false
		
		local bCanGetVersion = HAY_INTERNAL ~= nil
		local MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK
		local ONLINE_VERSION_READ = -1
		if bCanGetVersion then
			MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK = HAY_INTERNAL.GetVersionData()
			
			if ONLINE_VERSION == -1 then
				ONLINE_VERSION_READ = "<offline>"
				
			else
				ONLINE_VERSION_READ = tostring( ONLINE_VERSION )
				
			end
			
		end
		
		if ONLINE_VERSION and ONLINE_VERSION ~= -1 and HAY_INTERNAL.GetReplicate then
			local myVer = MY_VERSION or 0
			
			local contents = HAY_INTERNAL.GetReplicate() or ( tostring( MY_VERSION or 0 ) .. "\n<Nothing to show>" )
			local split = string.Explode( "\n", contents )
			if (#split % 2) == 0 then
				local dList = vgui.Create("DListView", self)
				self.Contents = dList
				dList:SetMultiSelect( false )
				dList:AddColumn( "Ver." ):SetMaxWidth( 45 ) -- Add column
				dList:AddColumn( "Type" ):SetMaxWidth( 60 ) -- Add column
				dList:AddColumn( "Log" )
				
				local gotMyVer = false
				local i = 1
				while (i <= #split) and not (bToLocale and gotMyVer) do
					local iVer = tonumber( split[i] or 0 ) or 0
					if not gotMyVer and iVer ~= 0 and iVer <= myVer and (split[i+2] ~= "&") then
						dList:AddLine( "*" .. myVer .. "*", "Locale", "< Currently installed version >" )
						gotMyVer = true
						
					end
					local nature = tonumber( split[i] )
					nature = (nature == nil) and "" or math.floor(nature*1000) % 10 > 0 and "Fix" or math.floor(nature*100) % 10 > 0 and "Feature" or "Release"
					local myLine = dList:AddLine( (split[i] ~= "&") and split[i] or "", tostring(nature), split[i+1] or "" )
					myLine:SizeToContents()
					
					i = i + 2
					
				end
				
			else
				local dLabel = vgui.Create( "DLabel", self )
				self.Contents = dLabel
				dLabel:SetText( "<Changelog data is corrupted>" )
				
			end
			
		elseif not HAY_INTERNAL.GetReplicate then
			local dLabel = vgui.Create( "DLabel", self )
			self.Contents = dLabel
			dLabel:SetText( "Couldn't load changelog because your Locale version is too old." )
			
		else
			local dLabel = vgui.Create( "DLabel", self )
			self.Contents = dLabel
			dLabel:SetText( "Couldn't load changelog because ".. tostring(HAY_NAME) .." failed to pickup information from the Cloud." )
		
		end
	end

	function PANEL:PerformLayout()
		self.Contents:StretchToParent( 0, 0, 0, 0 )
		self.Contents:Center()
		
	end

	vgui.Register( HAY_SHORT .. "_ChangelogPanel", PANEL, "Panel" )

end


function HAY_MAIN:BuildChangelogWindow( )
	self:DestroyChangelog( )
	self.ChangelogPanel = vgui.Create( "DFrame" )
	
	local window = self.ChangelogPanel
	window:SetSize( ScrW() * 0.7, ScrH() * 0.7 )
	window:Center()
	window:SetTitle( tostring(HAY_NAME) .. " - Changelog" )
	window:SetVisible( false )
	window:SetDraggable( true )
	window:ShowCloseButton( true )
	window:SetDeleteOnClose( false )
	window:SetSizable( true )
	
	window.PerformLayout = function( self )
		self.Contents:StretchToParent( 4, 24, 4, 4 )
		self.Contents:AlignBottom( 4 )
		self.Contents:InvalidateLayout()
		
	end
	
	window.Contents = vgui.Create( HAY_SHORT .. "_ChangelogPanel", window )
	window.Contents:Compose( false ) 
	window:InvalidateLayout( true )
	
	return window
	
end

function HAY_MAIN:ShowChangelog( )
	if not ValidPanel( self.ChangelogPanel ) then
		self:BuildChangelogWindow( )
		
	end
	self.ChangelogPanel:MakePopup()
	self.ChangelogPanel:SetVisible( true )
	
end

function HAY_MAIN:HideChangelog( )
	if not ValidPanel( self.ChangelogPanel ) then	return end
	self.ChangelogPanel:SetVisible( false )
	
end

function HAY_MAIN:DestroyChangelog( )
	if ValidPanel( self.ChangelogPanel ) then
		self.ChangelogPanel:Remove()
		self.ChangelogPanel = nil
		
	end
	
end
