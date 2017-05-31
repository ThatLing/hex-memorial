
----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------


surface.CreateFont("TargetID", {
	font		= "Trebuchet MS",
	size 		= 24,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)


surface.CreateFont("TargetIDSmall", {
	font		= "Trebuchet MS",
	size 		= 18,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)




local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 500, 443 )
	self.PanelOffset = 0
	self.PanelOffsetNeeded = 0
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	
	self.btnClose = vgui.Create( "DButton", self )
	self.btnClose:SetText( "X" )
	self.btnClose:SetCursor("hand")
	self.btnClose:SetPos(self:GetWide()-272, 3)
	self.btnClose:SetSize(19, 19)
	self.btnClose.DoClick = function() self:Remove() end
	self.btnClose:SetDrawBorder( false )
	self.btnClose:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self:PopulateMainMenu()
end

function PANEL:Think()
	if self.PanelOffsetNeeded > self.PanelOffset and self.PanelOffset + 10 < self.PanelOffsetNeeded then
		self.PanelOffset = self.PanelOffset + 10
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
	draw.SimpleText("FSAMod", "TargetID", (self:GetWide()/2)-125, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Version 1.0 HeX", "TargetIDSmall", (self:GetWide()/2)-125, 50, Color(150,150,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	local GotPlugins = FSA.Plugins
	if GotPlugins[1] then
		for k , v in ipairs(GotPlugins) do
			local button = vgui.Create("DButton", self.MainPanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			button.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
			button.OnCursorExited = function() self.MainPanel.MouseFollow = false end
			button.Paint = function()
						draw.SimpleText(v.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
			button.DoClick = function()
						self.MainPanel.ButtonSelection = k-1
						self.PanelOffsetNeeded = 125
						if GotPlugins[k].MenuFunction == "Other" then
							FSA_CreateSecondMenu( GotPlugins[k] )
							self:Remove()
						elseif GotPlugins[k].MenuFunction == "" then
							RunConsoleCommand("fsa_cmd", GotPlugins[k].Name)
							self:Remove()
						else
							self:PopulateSideMenu(GotPlugins[k])
						end
					end
			self.MainPanel:AddItem(button)
		end
	else
		ErrorNoHalt("\n----------------------------\n[FSA][CL] Plugins Not Loaded\n----------------------------\n")
	end
end

function PANEL:PopulateSideMenu( PluginData )
	self.SidePanel:Clear()
	if PluginData.MenuFunction == "AllPlayers" then
		local PlayerList = {}
		for k, ply in ipairs(player.GetAll()) do
			local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
			table.insert(PlayerList, plyinfo)
		end
		table.SortByMember(PlayerList, "Name")

		for k, ply in ipairs(PlayerList) do
			local button = vgui.Create("DButton", self.SidePanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			button.Paint = function()
						draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
			button.DoClick = function()
						if PluginData.SubMenu and PluginData.SubMenufunction then
							button.submenu = DermaMenu()
								for num, data in pairs(PluginData.SubMenu) do
									button.submenu:AddOption(data, function() RunConsoleCommand("fsa_cmdsub", PluginData.Name, num, ply.ID); if PluginData.CloseOnClick then self:Remove(); end; print("fsa_cmdsub", PluginData.Name, num, ply.ID); end )
								end
								button.submenu:Open()
						else
							RunConsoleCommand("fsa_cmd", PluginData.Name, ply.ID)
							if PluginData.CloseOnClick then self:Remove() end
						end
					end
			self.SidePanel:AddItem(button)
		end
	elseif PluginData.MenuFunction == "AllExceptLocal" then
		local PlayerList = {}
		for k, ply in ipairs(player.GetAll()) do
			if ply != LocalPlayer() then
				local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
				table.insert(PlayerList, plyinfo)
			end
		end
		if table.Count(PlayerList) == 0 then
			self.PanelOffsetNeeded = 0
			return
		end
		table.SortByMember(PlayerList, "Name")
		
		for k, ply in ipairs(PlayerList) do
			local button = vgui.Create("DButton", self.SidePanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			
			button.Paint = function()
				draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
			button.DoClick = function()
				if PluginData.SubMenu and PluginData.SubMenufunction then
					button.submenu = DermaMenu()
						for num,data in pairs(PluginData.SubMenu) do
							if PluginData.SubMenu == FSA.Ranks then
								data = data.Name --Ranks
							end
							
							button.submenu:AddOption(data, function()
								--Rank, 9, uid
								RunConsoleCommand("fsa_cmdsub", PluginData.Name, num, ply.ID)
								self:Remove()
							end)
						end
					button.submenu:Open()
				else
					RunConsoleCommand("fsa_cmd", PluginData.Name, ply.ID)
					if PluginData.CloseOnClick then self:Remove() end
				end
			end
			
			self.SidePanel:AddItem(button)
		end
	else
		ErrorNoHalt("[FSA][CL] Plugin " .. PluginData.Name .. " Has No Listing")
	end
end

vgui.Register( "fsaMainMenu", PANEL )

----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------


surface.CreateFont("TargetID", {
	font		= "Trebuchet MS",
	size 		= 24,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)


surface.CreateFont("TargetIDSmall", {
	font		= "Trebuchet MS",
	size 		= 18,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)




local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 500, 443 )
	self.PanelOffset = 0
	self.PanelOffsetNeeded = 0
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	
	self.btnClose = vgui.Create( "DButton", self )
	self.btnClose:SetText( "X" )
	self.btnClose:SetCursor("hand")
	self.btnClose:SetPos(self:GetWide()-272, 3)
	self.btnClose:SetSize(19, 19)
	self.btnClose.DoClick = function() self:Remove() end
	self.btnClose:SetDrawBorder( false )
	self.btnClose:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self:PopulateMainMenu()
end

function PANEL:Think()
	if self.PanelOffsetNeeded > self.PanelOffset and self.PanelOffset + 10 < self.PanelOffsetNeeded then
		self.PanelOffset = self.PanelOffset + 10
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
	draw.SimpleText("FSAMod", "TargetID", (self:GetWide()/2)-125, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Version 1.0 HeX", "TargetIDSmall", (self:GetWide()/2)-125, 50, Color(150,150,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
	local GotPlugins = FSA.Plugins
	if GotPlugins[1] then
		for k , v in ipairs(GotPlugins) do
			local button = vgui.Create("DButton", self.MainPanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			button.OnCursorEntered = function() self.MainPanel.MouseFollow = true end
			button.OnCursorExited = function() self.MainPanel.MouseFollow = false end
			button.Paint = function()
						draw.SimpleText(v.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
			button.DoClick = function()
						self.MainPanel.ButtonSelection = k-1
						self.PanelOffsetNeeded = 125
						if GotPlugins[k].MenuFunction == "Other" then
							FSA_CreateSecondMenu( GotPlugins[k] )
							self:Remove()
						elseif GotPlugins[k].MenuFunction == "" then
							RunConsoleCommand("fsa_cmd", GotPlugins[k].Name)
							self:Remove()
						else
							self:PopulateSideMenu(GotPlugins[k])
						end
					end
			self.MainPanel:AddItem(button)
		end
	else
		ErrorNoHalt("\n----------------------------\n[FSA][CL] Plugins Not Loaded\n----------------------------\n")
	end
end

function PANEL:PopulateSideMenu( PluginData )
	self.SidePanel:Clear()
	if PluginData.MenuFunction == "AllPlayers" then
		local PlayerList = {}
		for k, ply in ipairs(player.GetAll()) do
			local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
			table.insert(PlayerList, plyinfo)
		end
		table.SortByMember(PlayerList, "Name")

		for k, ply in ipairs(PlayerList) do
			local button = vgui.Create("DButton", self.SidePanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			button.Paint = function()
						draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
			button.DoClick = function()
						if PluginData.SubMenu and PluginData.SubMenufunction then
							button.submenu = DermaMenu()
								for num, data in pairs(PluginData.SubMenu) do
									button.submenu:AddOption(data, function() RunConsoleCommand("fsa_cmdsub", PluginData.Name, num, ply.ID); if PluginData.CloseOnClick then self:Remove(); end; print("fsa_cmdsub", PluginData.Name, num, ply.ID); end )
								end
								button.submenu:Open()
						else
							RunConsoleCommand("fsa_cmd", PluginData.Name, ply.ID)
							if PluginData.CloseOnClick then self:Remove() end
						end
					end
			self.SidePanel:AddItem(button)
		end
	elseif PluginData.MenuFunction == "AllExceptLocal" then
		local PlayerList = {}
		for k, ply in ipairs(player.GetAll()) do
			if ply != LocalPlayer() then
				local plyinfo = {Name = ply:Nick(), ID = ply:UniqueID()}
				table.insert(PlayerList, plyinfo)
			end
		end
		if table.Count(PlayerList) == 0 then
			self.PanelOffsetNeeded = 0
			return
		end
		table.SortByMember(PlayerList, "Name")
		
		for k, ply in ipairs(PlayerList) do
			local button = vgui.Create("DButton", self.SidePanel)
			button:SetSize( self:GetWide(), 25 )
			button:SetText("")
			button:SetCursor("hand")
			
			button.Paint = function()
				draw.SimpleText( ply.Name, "TargetIDSmall", 10, 12.5, Color(60,60,60,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
			button.DoClick = function()
				if PluginData.SubMenu and PluginData.SubMenufunction then
					button.submenu = DermaMenu()
						for num,data in pairs(PluginData.SubMenu) do
							if PluginData.SubMenu == FSA.Ranks then
								data = data.Name --Ranks
							end
							
							button.submenu:AddOption(data, function()
								--Rank, 9, uid
								RunConsoleCommand("fsa_cmdsub", PluginData.Name, num, ply.ID)
								self:Remove()
							end)
						end
					button.submenu:Open()
				else
					RunConsoleCommand("fsa_cmd", PluginData.Name, ply.ID)
					if PluginData.CloseOnClick then self:Remove() end
				end
			end
			
			self.SidePanel:AddItem(button)
		end
	else
		ErrorNoHalt("[FSA][CL] Plugin " .. PluginData.Name .. " Has No Listing")
	end
end

vgui.Register( "fsaMainMenu", PANEL )
