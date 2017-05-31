
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------

include("player_row.lua")
include("player_frame.lua")

surface.CreateFont("ScoreboardHeader", 		{font = "coolvetica", size = 32} )
surface.CreateFont("ScoreboardSubtitle", 	{font = "coolvetica", size = 22} )
surface.CreateFont("DefaultSmall2", 		{font = "coolvetica", size = 17, weight = 350} )

local texGradient 	= surface.GetTextureID("gui/center_gradient")
local texLogo 		= surface.GetTextureID("gui/gmod_logo")



local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self
	
	self.Hostname = vgui.Create("DLabel", self)
	self.Hostname:SetText( GetHostName() )
	self.Hostname.m_colText = Color(20,20,20,255)
	
	self.Description = vgui.Create("DLabel", self)
	self.Description:SetText("UHDM - Coded by HeX,Fangli,Henry00")
	self.Description.m_colText = Color(20,20,20,255)
	
	self.PlayerFrame = vgui.Create("PlayerFrame", self)
	
	self.PlayerRows = {}

	self:UpdateScoreboard()
	
	//Update the scoreboard every 1 second
	timer.Create("ScoreboardUpdater", 1, 0, function()
		self.UpdateScoreboard(self)
	end)
	
	self.lblPing = vgui.Create("DLabel", self)
	self.lblPing:SetText("Ping")
	
	
	self.lblTKills = vgui.Create("DLabel", self)
	self.lblTKills:SetText("Total")
	
	
	self.lblDeaths = vgui.Create("DLabel", self)
	self.lblDeaths:SetText("Deaths")
	
	self.lblKills = vgui.Create("DLabel", self)
	self.lblKills:SetText("Kills")
	
	self.lblTeam = vgui.Create("DLabel", self)
	self.lblTeam:SetText("Rank")
	
	self.lblTitle = vgui.Create("DLabel", self)
	self.lblTitle:SetText("Title")
end


function PANEL:AddPlayerRow(ply)
	local button = vgui.Create("ScorePlayerRow", self.PlayerFrame:GetCanvas() )
	
	button:SetPlayer(ply)
	self.PlayerRows[ ply ] = button
end


function PANEL:GetPlayerRow(ply)
	return self.PlayerRows[ ply ]
end


function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 170, 170, 170, 50 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() ) 
	
	// White Inner Box
	/*draw.RoundedBox( 4, 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4, Color( 230, 230, 230, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4 )*/
	
	// Sub Header
	draw.RoundedBox( 4, 5, self.Description.y - 3, self:GetWide() - 10, self.Description:GetTall() + 5, Color( 150, 200, 50, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self.Description:GetTall() + 8 ) 
	
	// Logo!
	surface.SetTexture( texLogo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 128, 128 ) 
	
	//draw.RoundedBox( 4, 10, self.Description.y + self.Description:GetTall() + 6, self:GetWide() - 20, 12, Color( 0, 0, 0, 50 ) )
end


local COLUMN_SIZE	= 50


function PANEL:PerformLayout()
	local Hight = ScrH()
	local Width = ScrW()
	self.Hostname:SizeToContents()
	self.Hostname:SetPos( 115, 16 )
	
	self.Description:SizeToContents()
	self.Description:SetPos( 128, 64 )
	
	local iTall = self.PlayerFrame:GetCanvas():GetTall() + self.Description.y + self.Description:GetTall() + 30
	
	iTall = math.Clamp(iTall, 100, Hight * 0.9)
	--local iWide = math.Clamp(Width * 0.8, 700, Width * 0.6)
	local iWide = math.Clamp(Width * 1, 800, Width * 0.8)
	
	self:SetSize(iWide, iTall)
	self:SetPos( (Width - self:GetWide()) / 2, (Hight - self:GetTall()) / 4 )
	
	self.PlayerFrame:SetPos(5, self.Description.y + self.Description:GetTall() + 20)
	self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	
	local PlayerSorted = {}
	
	for k, v in pairs(self.PlayerRows) do
		table.insert(PlayerSorted, v)
	end
	
	table.sort(PlayerSorted, function(a,b)
		return a:HigherOrLower(b)
	end)
	
	
	local y = 0
	for k, v in ipairs(PlayerSorted) do
		v:SetPos(0, y)	
		v:SetSize( self.PlayerFrame:GetWide(), v:GetTall() )
		
		self.PlayerFrame:GetCanvas():SetSize( self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall() )
		
		y = y + v:GetTall() + 1
	end
	
	self.Hostname:SetText( GetHostName() )
	
	self.lblPing:SizeToContents()
	self.lblTKills:SizeToContents()
	self.lblDeaths:SizeToContents()
	self.lblKills:SizeToContents()
	self.lblTeam:SizeToContents()
	self.lblTitle:SizeToContents()
	
	
	
	local PingTall = (self.PlayerFrame.y - self.lblPing:GetTall() - 0)
	
	self.lblPing:SetPos( 	self:GetWide() - COLUMN_SIZE 		- self.lblPing:GetWide()/2, 	PingTall)
	self.lblTKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 2 	- self.lblTKills:GetWide()/2, 	PingTall)
	self.lblDeaths:SetPos( 	self:GetWide() - COLUMN_SIZE * 3 	- self.lblDeaths:GetWide()/2,	PingTall)
	self.lblKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 4 	- self.lblKills:GetWide()/2, 	PingTall)
	self.lblTeam:SetPos( 	self:GetWide() - COLUMN_SIZE * 7 	- self.lblTeam:GetWide()/2, 	PingTall) --self.lblKills:GetWide()
	self.lblTitle:SetPos( 	self:GetWide() - COLUMN_SIZE * 12 	- self.lblTitle:GetWide()/2, 	PingTall)
end


local Trans180 = Color(0,0,0,180)
local Trans200 = Color(0,0,0,200)

function PANEL:ApplySchemeSettings()
	self.Hostname:SetFont("ScoreboardHeader")
	self.Description:SetFont("ScoreboardSubtitle")
	
	self.Hostname.m_colText = Trans200
	self.Description.m_colText = color_white 
	
	self.lblPing:SetFont("DefaultSmall2")
	self.lblTKills:SetFont("DefaultSmall2")
	self.lblDeaths:SetFont("DefaultSmall2")
	self.lblKills:SetFont("DefaultSmall2")
	self.lblTeam:SetFont("DefaultSmall2")
	self.lblTitle:SetFont("DefaultSmall2")
	
	
	
	self.lblPing.m_colText 		= Trans180
	self.lblTKills.m_colText 	= Trans180
	self.lblDeaths.m_colText 	= Trans180
	self.lblKills.m_colText 	= Trans180
	self.lblTeam.m_colText	 	= Trans180
	self.lblTitle.m_colText	 	= Trans180
end



local function Stats()
	local Str = ""
	
	local Spawning		= GetGlobalInt("HSP.CM_Times") or 0
	local Total 		= #player.GetAll() + Spawning
	local Active 		= #player.GetHumans()
	local Bots			= #player.GetBots()
	local Max			= game.MaxPlayers()
	local TotalHumans	= Active + Spawning
	local Slots 		= (Max - Bots - Active) - Spawning
	
	Str = Format("Players: %s, Bots: %s, Spawning: %s, Slots: %s", Active, Bots, Spawning, Slots)
	
	if Total == Max then
		Str = Str.." - FULL SERVER!"
	end
	
	return Str
end


function PANEL:UpdateScoreboard(force)
	if ( !force && !self:IsVisible() ) then return end
	
	for k, v in pairs(self.PlayerRows) do
		if not k:IsValid() then
			v:Remove()
			self.PlayerRows[ k ] = nil
		end
	end
	
	for k, v in pairs( player.GetAll() ) do
		if not self:GetPlayerRow(v) then
			self:AddPlayerRow(v)
		end
	end
	
	self.Description:SetText("UHDM - Coded by HeX,Fangli,Henry00 - "..Stats() )
	
	self:InvalidateLayout() --Always invalidate the layout so the order gets updated
end


vgui.Register("ScoreBoard", PANEL, "Panel")














----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------

include("player_row.lua")
include("player_frame.lua")

surface.CreateFont("ScoreboardHeader", 		{font = "coolvetica", size = 32} )
surface.CreateFont("ScoreboardSubtitle", 	{font = "coolvetica", size = 22} )
surface.CreateFont("DefaultSmall2", 		{font = "coolvetica", size = 17, weight = 350} )

local texGradient 	= surface.GetTextureID("gui/center_gradient")
local texLogo 		= surface.GetTextureID("gui/gmod_logo")



local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self
	
	self.Hostname = vgui.Create("DLabel", self)
	self.Hostname:SetText( GetHostName() )
	self.Hostname.m_colText = Color(20,20,20,255)
	
	self.Description = vgui.Create("DLabel", self)
	self.Description:SetText("UHDM - Coded by HeX,Fangli,Henry00")
	self.Description.m_colText = Color(20,20,20,255)
	
	self.PlayerFrame = vgui.Create("PlayerFrame", self)
	
	self.PlayerRows = {}

	self:UpdateScoreboard()
	
	//Update the scoreboard every 1 second
	timer.Create("ScoreboardUpdater", 1, 0, function()
		self.UpdateScoreboard(self)
	end)
	
	self.lblPing = vgui.Create("DLabel", self)
	self.lblPing:SetText("Ping")
	
	
	self.lblTKills = vgui.Create("DLabel", self)
	self.lblTKills:SetText("Total")
	
	
	self.lblDeaths = vgui.Create("DLabel", self)
	self.lblDeaths:SetText("Deaths")
	
	self.lblKills = vgui.Create("DLabel", self)
	self.lblKills:SetText("Kills")
	
	self.lblTeam = vgui.Create("DLabel", self)
	self.lblTeam:SetText("Rank")
	
	self.lblTitle = vgui.Create("DLabel", self)
	self.lblTitle:SetText("Title")
end


function PANEL:AddPlayerRow(ply)
	local button = vgui.Create("ScorePlayerRow", self.PlayerFrame:GetCanvas() )
	
	button:SetPlayer(ply)
	self.PlayerRows[ ply ] = button
end


function PANEL:GetPlayerRow(ply)
	return self.PlayerRows[ ply ]
end


function PANEL:Paint()
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 170, 170, 170, 50 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() ) 
	
	// White Inner Box
	/*draw.RoundedBox( 4, 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4, Color( 230, 230, 230, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4 )*/
	
	// Sub Header
	draw.RoundedBox( 4, 5, self.Description.y - 3, self:GetWide() - 10, self.Description:GetTall() + 5, Color( 150, 200, 50, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self.Description:GetTall() + 8 ) 
	
	// Logo!
	surface.SetTexture( texLogo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 128, 128 ) 
	
	//draw.RoundedBox( 4, 10, self.Description.y + self.Description:GetTall() + 6, self:GetWide() - 20, 12, Color( 0, 0, 0, 50 ) )
end


local COLUMN_SIZE	= 50


function PANEL:PerformLayout()
	local Hight = ScrH()
	local Width = ScrW()
	self.Hostname:SizeToContents()
	self.Hostname:SetPos( 115, 16 )
	
	self.Description:SizeToContents()
	self.Description:SetPos( 128, 64 )
	
	local iTall = self.PlayerFrame:GetCanvas():GetTall() + self.Description.y + self.Description:GetTall() + 30
	
	iTall = math.Clamp(iTall, 100, Hight * 0.9)
	--local iWide = math.Clamp(Width * 0.8, 700, Width * 0.6)
	local iWide = math.Clamp(Width * 1, 800, Width * 0.8)
	
	self:SetSize(iWide, iTall)
	self:SetPos( (Width - self:GetWide()) / 2, (Hight - self:GetTall()) / 4 )
	
	self.PlayerFrame:SetPos(5, self.Description.y + self.Description:GetTall() + 20)
	self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	
	local PlayerSorted = {}
	
	for k, v in pairs(self.PlayerRows) do
		table.insert(PlayerSorted, v)
	end
	
	table.sort(PlayerSorted, function(a,b)
		return a:HigherOrLower(b)
	end)
	
	
	local y = 0
	for k, v in ipairs(PlayerSorted) do
		v:SetPos(0, y)	
		v:SetSize( self.PlayerFrame:GetWide(), v:GetTall() )
		
		self.PlayerFrame:GetCanvas():SetSize( self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall() )
		
		y = y + v:GetTall() + 1
	end
	
	self.Hostname:SetText( GetHostName() )
	
	self.lblPing:SizeToContents()
	self.lblTKills:SizeToContents()
	self.lblDeaths:SizeToContents()
	self.lblKills:SizeToContents()
	self.lblTeam:SizeToContents()
	self.lblTitle:SizeToContents()
	
	
	
	local PingTall = (self.PlayerFrame.y - self.lblPing:GetTall() - 0)
	
	self.lblPing:SetPos( 	self:GetWide() - COLUMN_SIZE 		- self.lblPing:GetWide()/2, 	PingTall)
	self.lblTKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 2 	- self.lblTKills:GetWide()/2, 	PingTall)
	self.lblDeaths:SetPos( 	self:GetWide() - COLUMN_SIZE * 3 	- self.lblDeaths:GetWide()/2,	PingTall)
	self.lblKills:SetPos( 	self:GetWide() - COLUMN_SIZE * 4 	- self.lblKills:GetWide()/2, 	PingTall)
	self.lblTeam:SetPos( 	self:GetWide() - COLUMN_SIZE * 7 	- self.lblTeam:GetWide()/2, 	PingTall) --self.lblKills:GetWide()
	self.lblTitle:SetPos( 	self:GetWide() - COLUMN_SIZE * 12 	- self.lblTitle:GetWide()/2, 	PingTall)
end


local Trans180 = Color(0,0,0,180)
local Trans200 = Color(0,0,0,200)

function PANEL:ApplySchemeSettings()
	self.Hostname:SetFont("ScoreboardHeader")
	self.Description:SetFont("ScoreboardSubtitle")
	
	self.Hostname.m_colText = Trans200
	self.Description.m_colText = color_white 
	
	self.lblPing:SetFont("DefaultSmall2")
	self.lblTKills:SetFont("DefaultSmall2")
	self.lblDeaths:SetFont("DefaultSmall2")
	self.lblKills:SetFont("DefaultSmall2")
	self.lblTeam:SetFont("DefaultSmall2")
	self.lblTitle:SetFont("DefaultSmall2")
	
	
	
	self.lblPing.m_colText 		= Trans180
	self.lblTKills.m_colText 	= Trans180
	self.lblDeaths.m_colText 	= Trans180
	self.lblKills.m_colText 	= Trans180
	self.lblTeam.m_colText	 	= Trans180
	self.lblTitle.m_colText	 	= Trans180
end



local function Stats()
	local Str = ""
	
	local Spawning		= GetGlobalInt("HSP.CM_Times") or 0
	local Total 		= #player.GetAll() + Spawning
	local Active 		= #player.GetHumans()
	local Bots			= #player.GetBots()
	local Max			= game.MaxPlayers()
	local TotalHumans	= Active + Spawning
	local Slots 		= (Max - Bots - Active) - Spawning
	
	Str = Format("Players: %s, Bots: %s, Spawning: %s, Slots: %s", Active, Bots, Spawning, Slots)
	
	if Total == Max then
		Str = Str.." - FULL SERVER!"
	end
	
	return Str
end


function PANEL:UpdateScoreboard(force)
	if ( !force && !self:IsVisible() ) then return end
	
	for k, v in pairs(self.PlayerRows) do
		if not k:IsValid() then
			v:Remove()
			self.PlayerRows[ k ] = nil
		end
	end
	
	for k, v in pairs( player.GetAll() ) do
		if not self:GetPlayerRow(v) then
			self:AddPlayerRow(v)
		end
	end
	
	self.Description:SetText("UHDM - Coded by HeX,Fangli,Henry00 - "..Stats() )
	
	self:InvalidateLayout() --Always invalidate the layout so the order gets updated
end


vgui.Register("ScoreBoard", PANEL, "Panel")













