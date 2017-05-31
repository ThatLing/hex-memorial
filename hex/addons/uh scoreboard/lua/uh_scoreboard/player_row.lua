
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------



surface.CreateFont("ScoreboardPlayerName", 		{font = "coolvetica", size = 19} )
surface.CreateFont("ScoreboardPlayerNameBig", 	{font = "coolvetica", size = 22} )

local texGradient = surface.GetTextureID("gui/center_gradient")


local PANEL = {}


function PANEL:Init()
	self.Size = 36
	self.TargetSize = 36
	
	self.lblName 	= vgui.Create("DLabel", self)
	self.lblTitle 	= vgui.Create("DLabel", self)
	self.lblTeam 	= vgui.Create("DLabel", self)
	self.lblFrags 	= vgui.Create("DLabel", self)
	self.lblDeaths 	= vgui.Create("DLabel", self)
	self.lblTKills 	= vgui.Create("DLabel", self)
	self.lblPing 	= vgui.Create("DLabel", self)
	
	
	//If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled(false)
	self.lblTitle:SetMouseInputEnabled(false)
	self.lblTeam:SetMouseInputEnabled(false)
	self.lblFrags:SetMouseInputEnabled(false)
	self.lblDeaths:SetMouseInputEnabled(false)
	self.lblTKills:SetMouseInputEnabled(false)
	self.lblPing:SetMouseInputEnabled(false)
	
	
	
	self.AvatarButton = self:Add("DButton")
	self.AvatarButton.DoClick = function()
		if not self.Player:IsBot() then
			self.Player:ShowProfile()
		end
	end
	
	self.Avatar = vgui.Create("AvatarImage", self) --self self.AvatarButton
	self.Avatar:SetMouseInputEnabled(false)
	
	self:SetCursor("hand")
end




function PANEL:Paint()
	if ( !IsValid( self.Player ) ) then return end
	
	local color = team.GetColor( self.Player:Team() )
	
	if self.Player:IsMuted() then --More alpha
		color.a = 100
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	
	--surface.SetDrawColor( 255, 255, 255, 50 )
	if (self.Player == LocalPlayer()) then
		surface.SetDrawColor(255, 255, 255, 120 + math.sin(RealTime() * 7) * 255)
	else
		surface.SetDrawColor(255, 255, 255, 50)
	end
	
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 ) 
	
	return true
end



function PANEL:SetPlayer(ply)
	self.Player = ply
	
	self.Avatar:SetPlayer(ply)
	
	self:UpdatePlayerData()
end




local function FixNumber(num)
    num = tostring(num)
    for i=#num-3, 1, -3 do
        num = num:sub(1, i)..","..num:sub(i+1, #num)
    end
    return num
end


function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end
	local ply = self.Player
	
	local Nick = ply:Nick()
	if ply:IsTyping() then
		Nick = "*Typing*  "..Nick
	end
	if not ply:Alive() then
		Nick = "*DEAD*  "..Nick
	end
	if ply:IsMuted() then
		Nick = "[MUTED]  "..Nick
	end
	
	local Rank = ""
	if ply:IsBot() then
		Rank = "[BOT] "
	end
	
	self.lblPing:SetText( ply:Ping() )
	self.lblTKills:SetText( FixNumber(ply:GetNWInt("TotalKills", "")) )
	self.lblDeaths:SetText( ply:Deaths() )
	self.lblFrags:SetText( ply:Frags() )
	self.lblTeam:SetText( Rank..team.GetName( ply:Team() ) )
	self.lblTitle:SetText( ply:GetNWString("Title", "") )
	self.lblName:SetText(Nick)
end



function PANEL:ApplySchemeSettings()
	self.lblName:SetFont("ScoreboardPlayerNameBig")
	self.lblTitle:SetFont("ScoreboardPlayerName")
	self.lblTeam:SetFont("ScoreboardPlayerName")
	self.lblFrags:SetFont("ScoreboardPlayerName")
	self.lblDeaths:SetFont("ScoreboardPlayerName")
	self.lblTKills:SetFont("ScoreboardPlayerName")
	self.lblPing:SetFont("ScoreboardPlayerName")
	
	self.lblName.m_colText		= color_black
	self.lblTitle.m_colText		= color_black
	self.lblTeam.m_colText		= color_black
	self.lblFrags.m_colText		= color_black
	self.lblDeaths.m_colText 	= color_black
	self.lblTKills.m_colText 	= color_black
	self.lblPing.m_colText 		= color_black
end



function PANEL:DoClick(x,y)
	local ply = self.Player
	
	local Bad = false
	if ply == LocalPlayer() then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Clicking with yourself again?")
		
	elseif ply:IsBot() then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Don't listen to anything the bot says..")
		
	elseif ply:SteamID() == "STEAM_0:0:17809124" then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Am I that annoying?")
		
		timer.Simple(1.3, function()
			RunConsoleCommand("say", "I love HeX's voice <3")
		end)
	end
	
	if Bad then
		surface.PlaySound("buttons/button8.wav")
		return
	end
	
	
	if ply:IsMuted() then
		surface.PlaySound("ui/buttonclickrelease.wav")
		ply:SetMuted(false)
	else
		surface.PlaySound("ui/buttonclick.wav")
		ply:SetMuted(true)
	end
	
	self:UpdatePlayerData()
end



function PANEL:Think()
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		self.lblTeam:SizeToContents()
		self.lblTitle:SizeToContents()
	end
end


local COLUMN_SIZE = 50

function PANEL:PerformLayout()
	self.Avatar:SetPos(2,2)
	self.Avatar:SetSize(32,32)
	
	self.AvatarButton:SetPos(2,2)
	self.AvatarButton:SetSize(32,32)
	
	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 2 )
	self.lblName:MoveRightOf(self.Avatar, 8)
	
	self.lblTeam:SizeToContents()
	self.lblTitle:SizeToContents()
	
	
	self.lblPing:SetPos( 	self:GetWide() - COLUMN_SIZE * 1, 2)
	self.lblTKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 2.25, 2)
	self.lblDeaths:SetPos( 	self:GetWide() - COLUMN_SIZE * 3, 2)
	self.lblFrags:SetPos( 	self:GetWide() - COLUMN_SIZE * 4, 2)
	self.lblTeam:SetPos( 	self:GetWide() - COLUMN_SIZE * 7, 2)
	self.lblTitle:SetPos( 	self:GetWide() - COLUMN_SIZE * 12, 2)
end



function PANEL:HigherOrLower(row)
	if not (IsValid(self.Player) and IsValid(row.Player)) then return end
	
	if ( self.Player:Frags() == row.Player:Frags() ) then
		return self.Player:Deaths() < row.Player:Deaths()
	end

	return self.Player:Frags() > row.Player:Frags()
end


vgui.Register("ScorePlayerRow", PANEL, "Button")





















----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------



surface.CreateFont("ScoreboardPlayerName", 		{font = "coolvetica", size = 19} )
surface.CreateFont("ScoreboardPlayerNameBig", 	{font = "coolvetica", size = 22} )

local texGradient = surface.GetTextureID("gui/center_gradient")


local PANEL = {}


function PANEL:Init()
	self.Size = 36
	self.TargetSize = 36
	
	self.lblName 	= vgui.Create("DLabel", self)
	self.lblTitle 	= vgui.Create("DLabel", self)
	self.lblTeam 	= vgui.Create("DLabel", self)
	self.lblFrags 	= vgui.Create("DLabel", self)
	self.lblDeaths 	= vgui.Create("DLabel", self)
	self.lblTKills 	= vgui.Create("DLabel", self)
	self.lblPing 	= vgui.Create("DLabel", self)
	
	
	//If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled(false)
	self.lblTitle:SetMouseInputEnabled(false)
	self.lblTeam:SetMouseInputEnabled(false)
	self.lblFrags:SetMouseInputEnabled(false)
	self.lblDeaths:SetMouseInputEnabled(false)
	self.lblTKills:SetMouseInputEnabled(false)
	self.lblPing:SetMouseInputEnabled(false)
	
	
	
	self.AvatarButton = self:Add("DButton")
	self.AvatarButton.DoClick = function()
		if not self.Player:IsBot() then
			self.Player:ShowProfile()
		end
	end
	
	self.Avatar = vgui.Create("AvatarImage", self) --self self.AvatarButton
	self.Avatar:SetMouseInputEnabled(false)
	
	self:SetCursor("hand")
end




function PANEL:Paint()
	if ( !IsValid( self.Player ) ) then return end
	
	local color = team.GetColor( self.Player:Team() )
	
	if self.Player:IsMuted() then --More alpha
		color.a = 100
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	
	--surface.SetDrawColor( 255, 255, 255, 50 )
	if (self.Player == LocalPlayer()) then
		surface.SetDrawColor(255, 255, 255, 120 + math.sin(RealTime() * 7) * 255)
	else
		surface.SetDrawColor(255, 255, 255, 50)
	end
	
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 ) 
	
	return true
end



function PANEL:SetPlayer(ply)
	self.Player = ply
	
	self.Avatar:SetPlayer(ply)
	
	self:UpdatePlayerData()
end




local function FixNumber(num)
    num = tostring(num)
    for i=#num-3, 1, -3 do
        num = num:sub(1, i)..","..num:sub(i+1, #num)
    end
    return num
end


function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end
	local ply = self.Player
	
	local Nick = ply:Nick()
	if ply:IsTyping() then
		Nick = "*Typing*  "..Nick
	end
	if not ply:Alive() then
		Nick = "*DEAD*  "..Nick
	end
	if ply:IsMuted() then
		Nick = "[MUTED]  "..Nick
	end
	
	local Rank = ""
	if ply:IsBot() then
		Rank = "[BOT] "
	end
	
	self.lblPing:SetText( ply:Ping() )
	self.lblTKills:SetText( FixNumber(ply:GetNWInt("TotalKills", "")) )
	self.lblDeaths:SetText( ply:Deaths() )
	self.lblFrags:SetText( ply:Frags() )
	self.lblTeam:SetText( Rank..team.GetName( ply:Team() ) )
	self.lblTitle:SetText( ply:GetNWString("Title", "") )
	self.lblName:SetText(Nick)
end



function PANEL:ApplySchemeSettings()
	self.lblName:SetFont("ScoreboardPlayerNameBig")
	self.lblTitle:SetFont("ScoreboardPlayerName")
	self.lblTeam:SetFont("ScoreboardPlayerName")
	self.lblFrags:SetFont("ScoreboardPlayerName")
	self.lblDeaths:SetFont("ScoreboardPlayerName")
	self.lblTKills:SetFont("ScoreboardPlayerName")
	self.lblPing:SetFont("ScoreboardPlayerName")
	
	self.lblName.m_colText		= color_black
	self.lblTitle.m_colText		= color_black
	self.lblTeam.m_colText		= color_black
	self.lblFrags.m_colText		= color_black
	self.lblDeaths.m_colText 	= color_black
	self.lblTKills.m_colText 	= color_black
	self.lblPing.m_colText 		= color_black
end



function PANEL:DoClick(x,y)
	local ply = self.Player
	
	local Bad = false
	if ply == LocalPlayer() then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Clicking with yourself again?")
		
	elseif ply:IsBot() then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Don't listen to anything the bot says..")
		
	elseif ply:SteamID() == "STEAM_0:0:17809124" then
		Bad = true
		chat.AddText(HSP.GREEN, "[HSP] ", HSP.RED, "Am I that annoying?")
		
		timer.Simple(1.3, function()
			RunConsoleCommand("say", "I love HeX's voice <3")
		end)
	end
	
	if Bad then
		surface.PlaySound("buttons/button8.wav")
		return
	end
	
	
	if ply:IsMuted() then
		surface.PlaySound("ui/buttonclickrelease.wav")
		ply:SetMuted(false)
	else
		surface.PlaySound("ui/buttonclick.wav")
		ply:SetMuted(true)
	end
	
	self:UpdatePlayerData()
end



function PANEL:Think()
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		self.lblTeam:SizeToContents()
		self.lblTitle:SizeToContents()
	end
end


local COLUMN_SIZE = 50

function PANEL:PerformLayout()
	self.Avatar:SetPos(2,2)
	self.Avatar:SetSize(32,32)
	
	self.AvatarButton:SetPos(2,2)
	self.AvatarButton:SetSize(32,32)
	
	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 2 )
	self.lblName:MoveRightOf(self.Avatar, 8)
	
	self.lblTeam:SizeToContents()
	self.lblTitle:SizeToContents()
	
	
	self.lblPing:SetPos( 	self:GetWide() - COLUMN_SIZE * 1, 2)
	self.lblTKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 2.25, 2)
	self.lblDeaths:SetPos( 	self:GetWide() - COLUMN_SIZE * 3, 2)
	self.lblFrags:SetPos( 	self:GetWide() - COLUMN_SIZE * 4, 2)
	self.lblTeam:SetPos( 	self:GetWide() - COLUMN_SIZE * 7, 2)
	self.lblTitle:SetPos( 	self:GetWide() - COLUMN_SIZE * 12, 2)
end



function PANEL:HigherOrLower(row)
	if not (IsValid(self.Player) and IsValid(row.Player)) then return end
	
	if ( self.Player:Frags() == row.Player:Frags() ) then
		return self.Player:Deaths() < row.Player:Deaths()
	end

	return self.Player:Frags() > row.Player:Frags()
end


vgui.Register("ScorePlayerRow", PANEL, "Button")




















