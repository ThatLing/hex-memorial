ELEMENT.Name = "Team"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 14
ELEMENT.SizeX = nil
ELEMENT.SizeY = -0.6

ELEMENT.MyTeamID = nil
ELEMENT.MyTeamColor = color_white
ELEMENT.StoredName = ""
ELEMENT.StoredSub = ""

function ELEMENT:Initialize( )
	self:CreateSmoother("width", 0, 0.3)
	self:CreateSmoother("color" , self.MyTeamColor, 0.1)
end

function ELEMENT:DrawFunction( )
	if game.SinglePlayer() then return end
	//if (table.Count(team.GetAllTeams()) == 3) then return end
	
	//Team Name and Color
	if (LocalPlayer():Team() != self.MyTeamID) or (LocalPlayer().dhradar_communitycolor and (self.MyTeamColor != LocalPlayer().dhradar_communitycolor)) then
		self.MyTeamID = LocalPlayer():Team()
		self.MyTeamColor = LocalPlayer().dhradar_communitycolor or team.GetColor(self.MyTeamID)
		
		self.StoredSub = team.GetName(self.MyTeamID)
		self.StoredSub = (self.StoredSub == "Unassigned") and "Community" or self.StoredSub
		
		self:ChangeSmootherTarget("color", self.MyTeamColor)
	end
	
	
	//Number of players
	self.StoredName = team.NumPlayers(self.MyTeamID) .. " player"
	if (team.NumPlayers(self.MyTeamID) > 1) then
		self.StoredName = self.StoredName .. "s"
	end

	surface.SetFont( dhinline_GetAppropriateFont(self.StoredName, 1) )
	local wB, hB = surface.GetTextSize( self.StoredName )
	
	surface.SetFont( dhinline_GetAppropriateFont(self.StoredSub, 0) )
	local wS, hS = surface.GetTextSize( self.StoredSub )
	
	local w = math.Max(wB,wS)
	
	self:ChangeSmootherTarget("width", 38 + w)
	
	
	
	self.SizeX = self:GetSmootherCurrent("width")
	local color = self:GetSmootherCurrent("color")
	
	self:DrawGenericInfobox(
/*Text   */ self.StoredName
/*Subtxt */ ,self.StoredSub
/* %     */ ,1.0
/*atRight*/ ,false
/*0.0 col*/ ,color
/*1.0 col*/ ,color
/*minSize*/ ,0
/*maxSize*/ ,1.0
/*blink< */ ,-1
/*blinkSz*/ ,1
/*Font   */ ,1
/*bStatic*/ ,true
/*stCol  */ ,nil
/*stColSm*/ ,nil
	)
	return false
end

