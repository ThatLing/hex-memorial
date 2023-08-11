

local function ServerInfo(ply,cmd,args)
	console.PrintColor( Color( 153, 217, 234 ), "\nMaxPlayers", Color( 255, 255, 255 ), ": " .. client.GetMaxPlayers() )
	console.PrintColor( Color( 153, 217, 234 ), "IP", Color( 255, 255, 255 ), ": " .. client.GetIP() )
	
	for k,v in ipairs( player.GetAll() ) do
		print( v, type( v ) )
	end
	console.PrintColor( Color( 153, 217, 234 ), "\nLocalPlayer", Color( 255, 255, 255 ), ": " .. tostring( LocalPlayer() ) )
end
concommand.Add("ServerInfo", ServerInfo)


local function Status2(ply,cmd,args)
	print( "IP      : " .. client.GetIP() )
	print( "Map     : " .. client.GetMapName() )
	print( "Players : " .. table.maxn( player.GetAll() ) .. " (" .. client.GetMaxPlayers() .. " max)\n" )
	print( "# userid\tindex\tname\t\t\tsteamid\t\t\tcommunityid" )
	for k, v in pairs( player.GetAll() ) do
		print( "# " .. v:UserID() .. "\t\t" .. v:EntIndex() .. "\t" .. v:Nick() .. "\t\t" .. v:SteamID() .. "\t" .. v:CommunityID() )
	end
end
concommand.Add("status2", Status2)


if IsMainGMod or IsKida then
	hook.Add("ConsoleOpen", "lol", function()
		if client.IsInGame() and (#player.GetHumans() > 1) then
			Status2()
		end
	end)
end


concommand.Add("ServerPlayers", function( ply, cmd, args )
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( ScrW()*0.55, ScrH()*0.45 )
	Frame:Center()
	Frame:SetTitle( "Player List" )
	Frame:MakePopup()
	
	local List = vgui.Create( "DListView", Frame )
	List:SetPos( 5, 30 )
	List:SetSize( Frame:GetWide() - 10, Frame:GetTall() - 35 )
	List:SetMultiSelect( false )
	
	List.IsPlayerOnList = function( self, ply )
		for k,v in pairs( self:GetLines() ) do
			if v.PlayerEnt == ply then
				return true
			end
		end
		return false
	end
	
	List.ThinkDelay = RealTime()
	
	List.Think = function( self ) -- Constantly update the menu to remove or add any new or old players
		if !client.IsDrawingLoadingImage() and self.ThinkDelay <= RealTime() then --Never think while loading, tis bad
			for k,v in pairs( self:GetLines() ) do
				if !IsValid( v.PlayerEnt ) then
					self:RemoveLine( k )
				else
					v:SetColumnText( 4, v.PlayerEnt:SteamID() )
					v:SetColumnText( 7, tostring( v.PlayerEnt:IsMuted() ) )
				end
			end
			
			for k,v in ipairs( player.GetAll() ) do
				if !self:IsPlayerOnList( v ) then
					local line = self:AddLine( v:Nick(), v:UserID(), v:EntIndex(), v:SteamID(), v:CommunityID(), tostring( v:IsBot() ), tostring( v:IsMuted() ) )
					line.PlayerEnt = v
					if v == LocalPlayer() then
						self:SelectItem( line )
					end
				end
			end
			self.ThinkDelay = RealTime() + 1
		end
	end
	
	List:AddColumn("Name")
	List:AddColumn("UserID"):SetFixedWidth( 50 )
	List:AddColumn("EntIndex"):SetFixedWidth( 50 )
	List:AddColumn("SteamID"):SetFixedWidth( 125 )
	List:AddColumn("Community ID"):SetFixedWidth( 125 )
	List:AddColumn("Bot"):SetFixedWidth( 35 )
	List:AddColumn("Muted"):SetFixedWidth( 40 )
	List.OnRowRightClick = function()
	
		local SelectedPlayer = List:GetLine( List:GetSelectedLine() ).PlayerEnt
		
		if IsValid( SelectedPlayer ) then
			local Menu = DermaMenu()
			Menu:SetParent( Frame )
			Menu:SetPos( Frame:CursorPos() )
			if SelectedPlayer:IsMuted() then
				Menu:AddOption("Unmute", function()
					SelectedPlayer:SetMuted( false )
				end )
			else
				Menu:AddOption("Mute", function()
					SelectedPlayer:SetMuted( true )
				end )
			end
			Menu:AddOption("Copy Name", function()
				SetClipboardText( SelectedPlayer:Nick() )
			end )
			Menu:AddOption("Copy SteamID", function()
				SetClipboardText( SelectedPlayer:SteamID() )
			end )
			Menu:AddOption("Copy CommunityID", function()
				SetClipboardText( SelectedPlayer:CommunityID() )
			end )
			Menu:AddOption("Go To Steam Page", function()
				gui.OpenURL( "http://www.steamcommunity.com/profiles/" .. SelectedPlayer:CommunityID() )
			end )
		end
	end
end)