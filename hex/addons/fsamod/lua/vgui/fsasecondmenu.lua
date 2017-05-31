
----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------
local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 500, 443 )
	self.PanelOffset = 0
	self.PanelOffsetNeeded = 0
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	
	self.btnClose = vgui.Create( "DSysButton", self )
	self.btnClose:SetType( "close" )
	self.btnClose:SetCursor("hand")
	self.btnClose:SetPos(self:GetWide()-272, 3)
	self.btnClose:SetSize(19, 19)
	self.btnClose.DoClick = function() self:Remove() end
	self.btnClose:SetDrawBorder( false )
	self.btnClose:SetDrawBackground( true )
	
	self.backbutton = vgui.Create( "DButton", self )
	self.backbutton:SetText( "Back" )
	self.backbutton:SetCursor("hand")
	self.backbutton:SetPos(3, 3)
	self.backbutton:SetSize(40, 19)
	self.backbutton.DoClick = function() FSA_OpenMainMenu(); self:Remove() end
	self.backbutton:SetDrawBorder( false )
	self.backbutton:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self.PluginData = nil
	self.Title = ""
end

function PANEL:SetPlugin( plugindata )
	self.PluginData = plugindata
	self:PopulateMainMenu()
end

function PANEL:SetTitle( str )
	self.Title = str
end

function PANEL:Think()
	if self.PanelOffsetNeeded > self.PanelOffset and self.PanelOffset + 10 < self.PanelOffsetNeeded then
		self.PanelOffset = self.PanelOffset +10
	elseif self.PanelOffset > self.PanelOffsetNeeded and self.PanelOffset - 10 > self.PanelOffsetNeeded  then
		self.PanelOffset = self.PanelOffset - 10
	end
	self:SetPos( (self.ScrW/2 - 125)-(self.PanelOffset+5), (self.ScrH/2 - self:GetTall()/2) )
	self.SidePanel:SetPos( ((self.PanelOffset+5)*2)-2, 80 )
end

function PANEL:Paint()
	draw.RoundedBoxEx( 8, 0, 0, self:GetWide()-250, 59, Color(38,38,38,255), true, true, false, false )
	surface.SetDrawColor( 2, 2, 2, 255 )
	surface.SetTexture( surface.GetTextureID("gui/gradient_up") )
	surface.DrawTexturedRect( 0, 0, self:GetWide()-250, 59 )
	draw.SimpleText( self.Title, "TargetID", (self:GetWide()/2)-125, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( "::Frosty Server Administration", "TargetIDSmall", (self:GetWide()/2)-125, 50, Color(150,150,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:PopulateMainMenu()
	self.SidePanel = vgui.Create( "DPanelList", self )
	self.SidePanel:SetSize( 150, 300 )
	self.SidePanel:SetPos( 3, 80 )
	self.SidePanel.MouseFollow = false
	self.SidePanel:SetSpacing( 2 )
	self.SidePanel:EnableHorizontal( false )
	self.SidePanel:EnableVerticalScrollbar( true )
	self.SidePanel.Paint = function()
				draw.RoundedBoxEx( 8, 0, 0, 150, 300, Color(38,38,38,255), false, true, false, true )
				draw.RoundedBoxEx( 8, 0, 3, 147, 294, Color(237,237,237,255), false, true, false, true )
			end
			
	self.MainPanel = vgui.Create( "DPanelList", self )
	self.MainPanel:SetSize( self:GetWide()-250, 384 )
	self.MainPanel:SetPos( 0, 59 )
	self.MainPanel.MouseFollow = false
	self.MainPanel.ButtonSelection = -1
	self.MainPanel:EnableHorizontal( false )
	self.MainPanel:EnableVerticalScrollbar( true )
	self.MainPanel.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
	self.MainPanel.OnCursorExited = function() self.MainPanel.MouseFollow = false end
	self.MainPanel.Paint = function()
				draw.RoundedBoxEx( 8, 0, 0, self:GetWide()-250, 384, Color(38,38,38,255), false, false, true, true )
				draw.RoundedBoxEx( 8, 3, 0, self:GetWide()-256, 381, Color(237,237,237,255), false, false, true, true )
				if self.MainPanel.MouseFollow then
					draw.RoundedBox( 0, 3, math.Clamp((gui.MouseY()-self.y)-70,0,351), self:GetWide()-256, 25, Color(200,200,200,255))
				end
				if self.MainPanel.ButtonSelection != -1 then
					draw.RoundedBox( 0, 3, self.MainPanel.ButtonSelection*25, self:GetWide()-256, 25, Color(156,156,156,255))
					surface.SetDrawColor( 194,194,194,255 )
					surface.SetTexture( surface.GetTextureID("gui/gradient_down") )
					surface.DrawTexturedRect( 3, self.MainPanel.ButtonSelection*25, self:GetWide()-256, 25 )
				end
			end
	local PlayerList = {}
	if self.PluginData.AllowSelf then
		for k, ply in ipairs(player.GetAll()) do
			local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
			table.insert(PlayerList, plyinfo)
		end
	else
		for k, ply in ipairs(player.GetAll()) do
			if ply != LocalPlayer() then
				local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
				table.insert(PlayerList, plyinfo)
			end
		end
	end
	if table.Count(PlayerList) == 0 then
		self.backbutton.DoClick()
	end
	table.SortByMember(PlayerList, "Name")

	for k, ply in ipairs(PlayerList) do
		local button = vgui.Create("DButton", self.MainPanel)
		button:SetSize( self:GetWide(), 25 )
		button:SetText("")
		button:SetCursor("hand")
		button.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
		button.OnCursorExited = function() self.MainPanel.MouseFollow = false end
		button.Paint = function()
					draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
		button.DoClick = function()
					self.MainPanel.ButtonSelection = k-1
					self.PanelOffsetNeeded = 125
					self:PopulateSideMenu( ply.ID )
				end
		self.MainPanel:AddItem(button)
	end
end

function PANEL:PopulateSideMenu( plyID )
	self.SidePanel:Clear()
	
	function CloseAll()
		if FSA_ExtraInfo then
			FSA_ExtraInfo:Remove()
		end
		if FSA_ExtraInfo2 then
			FSA_ExtraInfo2:Remove()
		end
		self:Remove()
	end
	
	for k, data in pairs(self.PluginData.SubMenu) do
		local button = vgui.Create("DButton", self.SidePanel)
		button:SetSize( self:GetWide(), 25 )
		button:SetText("")
		button:SetCursor("hand")
		button.Paint = function()
					draw.SimpleText( data, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
		button.DoClick = function()
					if data == "(Custom)" then
						if self.PluginData.ExtraInfo then
							local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
							FSA_ExtraInfo:SetTitle( "" )
							FSA_ExtraInfo:SetTitle2( self.PluginData.ExtraInfoTitle )
							FSA_ExtraInfo:SetLabel( self.PluginData.ExtraInfoLabel )
							FSA_ExtraInfo:SetFunction(function()
											local FSA_ExtraInfo2 = vgui.Create( "fsaTextInput" )
											FSA_ExtraInfo2:SetTitle( "" )
											FSA_ExtraInfo2:SetTitle2( self.PluginData.CustomInfoTitle )
											FSA_ExtraInfo2:SetLabel( self.PluginData.CustomInfoLabel )
											FSA_ExtraInfo2:SetStoreData( FSA_ExtraInfo.TextObject:GetValue() )
											FSA_ExtraInfo2:SetFunction(function()
															RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, FSA_ExtraInfo2.TextObject:GetValue(), plyID, FSA_ExtraInfo2.StoreData )
															CloseAll()
														end)
										end)
							
						else
							local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
							FSA_ExtraInfo:SetTitle( "" )
							FSA_ExtraInfo:SetTitle2( self.PluginData.CustomInfoTitle )
							FSA_ExtraInfo:SetLabel( self.PluginData.CustomInfoLabel )
							FSA_ExtraInfo:SetFunction(function()
											RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, FSA_ExtraInfo.TextObject:GetValue() )
											CloseAll()
										end)
						end
					elseif self.PluginData.ExtraInfo then
						local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
						FSA_ExtraInfo:SetTitle( "" )
						FSA_ExtraInfo:SetTitle2( self.PluginData.ExtraInfoTitle )
						FSA_ExtraInfo:SetLabel( self.PluginData.ExtraInfoLabel )
						FSA_ExtraInfo:SetFunction(function()
										RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, FSA_ExtraInfo.TextObject:GetValue() )
										CloseAll()
									end)
					else
						RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, data)
						CloseAll()
					end
				end
		self.SidePanel:AddItem(button)
	end
end

vgui.Register( "fsaSecondMenu", PANEL )

function FSA_CreateSecondMenu( plugindata )
	local FSA_SecondMenu = vgui.Create( "fsaSecondMenu" )
	FSA_SecondMenu:SetPlugin( plugindata )
	FSA_SecondMenu:SetTitle( plugindata.Name )
end

----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------
local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 500, 443 )
	self.PanelOffset = 0
	self.PanelOffsetNeeded = 0
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	
	self.btnClose = vgui.Create( "DSysButton", self )
	self.btnClose:SetType( "close" )
	self.btnClose:SetCursor("hand")
	self.btnClose:SetPos(self:GetWide()-272, 3)
	self.btnClose:SetSize(19, 19)
	self.btnClose.DoClick = function() self:Remove() end
	self.btnClose:SetDrawBorder( false )
	self.btnClose:SetDrawBackground( true )
	
	self.backbutton = vgui.Create( "DButton", self )
	self.backbutton:SetText( "Back" )
	self.backbutton:SetCursor("hand")
	self.backbutton:SetPos(3, 3)
	self.backbutton:SetSize(40, 19)
	self.backbutton.DoClick = function() FSA_OpenMainMenu(); self:Remove() end
	self.backbutton:SetDrawBorder( false )
	self.backbutton:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self.PluginData = nil
	self.Title = ""
end

function PANEL:SetPlugin( plugindata )
	self.PluginData = plugindata
	self:PopulateMainMenu()
end

function PANEL:SetTitle( str )
	self.Title = str
end

function PANEL:Think()
	if self.PanelOffsetNeeded > self.PanelOffset and self.PanelOffset + 10 < self.PanelOffsetNeeded then
		self.PanelOffset = self.PanelOffset +10
	elseif self.PanelOffset > self.PanelOffsetNeeded and self.PanelOffset - 10 > self.PanelOffsetNeeded  then
		self.PanelOffset = self.PanelOffset - 10
	end
	self:SetPos( (self.ScrW/2 - 125)-(self.PanelOffset+5), (self.ScrH/2 - self:GetTall()/2) )
	self.SidePanel:SetPos( ((self.PanelOffset+5)*2)-2, 80 )
end

function PANEL:Paint()
	draw.RoundedBoxEx( 8, 0, 0, self:GetWide()-250, 59, Color(38,38,38,255), true, true, false, false )
	surface.SetDrawColor( 2, 2, 2, 255 )
	surface.SetTexture( surface.GetTextureID("gui/gradient_up") )
	surface.DrawTexturedRect( 0, 0, self:GetWide()-250, 59 )
	draw.SimpleText( self.Title, "TargetID", (self:GetWide()/2)-125, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( "::Frosty Server Administration", "TargetIDSmall", (self:GetWide()/2)-125, 50, Color(150,150,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:PopulateMainMenu()
	self.SidePanel = vgui.Create( "DPanelList", self )
	self.SidePanel:SetSize( 150, 300 )
	self.SidePanel:SetPos( 3, 80 )
	self.SidePanel.MouseFollow = false
	self.SidePanel:SetSpacing( 2 )
	self.SidePanel:EnableHorizontal( false )
	self.SidePanel:EnableVerticalScrollbar( true )
	self.SidePanel.Paint = function()
				draw.RoundedBoxEx( 8, 0, 0, 150, 300, Color(38,38,38,255), false, true, false, true )
				draw.RoundedBoxEx( 8, 0, 3, 147, 294, Color(237,237,237,255), false, true, false, true )
			end
			
	self.MainPanel = vgui.Create( "DPanelList", self )
	self.MainPanel:SetSize( self:GetWide()-250, 384 )
	self.MainPanel:SetPos( 0, 59 )
	self.MainPanel.MouseFollow = false
	self.MainPanel.ButtonSelection = -1
	self.MainPanel:EnableHorizontal( false )
	self.MainPanel:EnableVerticalScrollbar( true )
	self.MainPanel.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
	self.MainPanel.OnCursorExited = function() self.MainPanel.MouseFollow = false end
	self.MainPanel.Paint = function()
				draw.RoundedBoxEx( 8, 0, 0, self:GetWide()-250, 384, Color(38,38,38,255), false, false, true, true )
				draw.RoundedBoxEx( 8, 3, 0, self:GetWide()-256, 381, Color(237,237,237,255), false, false, true, true )
				if self.MainPanel.MouseFollow then
					draw.RoundedBox( 0, 3, math.Clamp((gui.MouseY()-self.y)-70,0,351), self:GetWide()-256, 25, Color(200,200,200,255))
				end
				if self.MainPanel.ButtonSelection != -1 then
					draw.RoundedBox( 0, 3, self.MainPanel.ButtonSelection*25, self:GetWide()-256, 25, Color(156,156,156,255))
					surface.SetDrawColor( 194,194,194,255 )
					surface.SetTexture( surface.GetTextureID("gui/gradient_down") )
					surface.DrawTexturedRect( 3, self.MainPanel.ButtonSelection*25, self:GetWide()-256, 25 )
				end
			end
	local PlayerList = {}
	if self.PluginData.AllowSelf then
		for k, ply in ipairs(player.GetAll()) do
			local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
			table.insert(PlayerList, plyinfo)
		end
	else
		for k, ply in ipairs(player.GetAll()) do
			if ply != LocalPlayer() then
				local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
				table.insert(PlayerList, plyinfo)
			end
		end
	end
	if table.Count(PlayerList) == 0 then
		self.backbutton.DoClick()
	end
	table.SortByMember(PlayerList, "Name")

	for k, ply in ipairs(PlayerList) do
		local button = vgui.Create("DButton", self.MainPanel)
		button:SetSize( self:GetWide(), 25 )
		button:SetText("")
		button:SetCursor("hand")
		button.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
		button.OnCursorExited = function() self.MainPanel.MouseFollow = false end
		button.Paint = function()
					draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
		button.DoClick = function()
					self.MainPanel.ButtonSelection = k-1
					self.PanelOffsetNeeded = 125
					self:PopulateSideMenu( ply.ID )
				end
		self.MainPanel:AddItem(button)
	end
end

function PANEL:PopulateSideMenu( plyID )
	self.SidePanel:Clear()
	
	function CloseAll()
		if FSA_ExtraInfo then
			FSA_ExtraInfo:Remove()
		end
		if FSA_ExtraInfo2 then
			FSA_ExtraInfo2:Remove()
		end
		self:Remove()
	end
	
	for k, data in pairs(self.PluginData.SubMenu) do
		local button = vgui.Create("DButton", self.SidePanel)
		button:SetSize( self:GetWide(), 25 )
		button:SetText("")
		button:SetCursor("hand")
		button.Paint = function()
					draw.SimpleText( data, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
		button.DoClick = function()
					if data == "(Custom)" then
						if self.PluginData.ExtraInfo then
							local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
							FSA_ExtraInfo:SetTitle( "" )
							FSA_ExtraInfo:SetTitle2( self.PluginData.ExtraInfoTitle )
							FSA_ExtraInfo:SetLabel( self.PluginData.ExtraInfoLabel )
							FSA_ExtraInfo:SetFunction(function()
											local FSA_ExtraInfo2 = vgui.Create( "fsaTextInput" )
											FSA_ExtraInfo2:SetTitle( "" )
											FSA_ExtraInfo2:SetTitle2( self.PluginData.CustomInfoTitle )
											FSA_ExtraInfo2:SetLabel( self.PluginData.CustomInfoLabel )
											FSA_ExtraInfo2:SetStoreData( FSA_ExtraInfo.TextObject:GetValue() )
											FSA_ExtraInfo2:SetFunction(function()
															RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, FSA_ExtraInfo2.TextObject:GetValue(), plyID, FSA_ExtraInfo2.StoreData )
															CloseAll()
														end)
										end)
							
						else
							local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
							FSA_ExtraInfo:SetTitle( "" )
							FSA_ExtraInfo:SetTitle2( self.PluginData.CustomInfoTitle )
							FSA_ExtraInfo:SetLabel( self.PluginData.CustomInfoLabel )
							FSA_ExtraInfo:SetFunction(function()
											RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, FSA_ExtraInfo.TextObject:GetValue() )
											CloseAll()
										end)
						end
					elseif self.PluginData.ExtraInfo then
						local FSA_ExtraInfo = vgui.Create( "fsaTextInput" )
						FSA_ExtraInfo:SetTitle( "" )
						FSA_ExtraInfo:SetTitle2( self.PluginData.ExtraInfoTitle )
						FSA_ExtraInfo:SetLabel( self.PluginData.ExtraInfoLabel )
						FSA_ExtraInfo:SetFunction(function()
										RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, FSA_ExtraInfo.TextObject:GetValue() )
										CloseAll()
									end)
					else
						RunConsoleCommand("fsa_cmdsubsub", self.PluginData.Name, data, plyID, data)
						CloseAll()
					end
				end
		self.SidePanel:AddItem(button)
	end
end

vgui.Register( "fsaSecondMenu", PANEL )

function FSA_CreateSecondMenu( plugindata )
	local FSA_SecondMenu = vgui.Create( "fsaSecondMenu" )
	FSA_SecondMenu:SetPlugin( plugindata )
	FSA_SecondMenu:SetTitle( plugindata.Name )
end
