// NOTE : This is ONLY a REMINDER. It doesn't check for updates
// periodically while in the middle of a game.
// Updates are checked when map loads.
// This element ONLY displays a message 45 seconds after map loading,
// for 15 seconds, ONCE a map, and does not display if up to date.

ELEMENT.Name = "On-screen Update Reminder"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 15
ELEMENT.SizeX = nil
ELEMENT.SizeY = -0.7

ELEMENT.baseColor = dhinline_GetStyleData("color_base")

ELEMENT.PersistTime    = 15.0 //How long the message displays
ELEMENT.CheckAfterLoadingDelay = 45.0 //The delay before message appears


ELEMENT.GetVersionRealTime = RealTime() + ELEMENT.CheckAfterLoadingDelay

ELEMENT.SafeEndDraw = 5.0
ELEMENT.StoredName = ""
ELEMENT.StoredSub = ""
ELEMENT.Blinkcap = -1

ELEMENT.HeightStartWaitup = -640.0
ELEMENT.HeightRateDispell = 0.4

ELEMENT.WarningColor     = Color(64,192,64,192)

ELEMENT.AlreadyChecked = false
ELEMENT.IsDisplayingPopup = false

ELEMENT.textColor = Color(ELEMENT.baseColor.r, ELEMENT.baseColor.g, ELEMENT.baseColor.b, 255)

function ELEMENT:Initialize( )
	self:CreateSmoother("width", 0, 0.7)
	self:CreateSmoother("height", 1.0, 0.7)
end

function ELEMENT:DrawFunction()
	if not self.IsDisplayingPopup then
		if self.AlreadyChecked then return end
		if RealTime() < self.GetVersionRealTime then return end
	end
	
	self.AlreadyChecked = true
	
	local myVer,svnVer,dlLink = dhinline_GetVersionData()
	
	if not self.IsDisplayingPopup and ((svnVer == nil) or (svnVer == -1) or (myVer >= svnVer)) then
		self.IsDisplayingPopup = false
		return
	else
		self.IsDisplayingPopup = true
		
		self.StoredName = "DepthHUD Inline Update : v".. myVer .." to v".. svnVer..". "
		if (math.floor(svnVer*10) - math.floor(myVer*10)) > 0 then
			self.StoredName = self.StoredName .. "(Feature update)"
		elseif (math.floor(svnVer*100) - math.floor(myVer*100)) > 0 then
			self.StoredName = self.StoredName .. "(Fix update)"
		elseif (math.floor(svnVer*1000) - math.floor(myVer*1000)) > 0 then
			self.StoredName = self.StoredName .. "(Betatesting update)"
		end
		self.StoredSub = "Please open the DepthHUD Inline menu for more information."
		
		local blinkSize = 1
		//Should disappear ?
		
		if (RealTime() > (self.PersistTime + self.GetVersionRealTime + self.SafeEndDraw)) then
			self.IsDisplayingPopup = false
		end
		
		if (RealTime() > (self.PersistTime + self.GetVersionRealTime)) then
			self.StoredName = ""
			self.StoredSub = ""
			
			self:ChangeSmootherTarget("width", 0)
			self:ChangeSmootherTarget("height", 1.0)
			self:ChangeSmootherRate("width", 0.1)
			self:ChangeSmootherRate("height", self.HeightRateDispell)
			self.Blinkcap = -1.0
			
		else
			self.Blinkcap = 1.0
			
			if self.StoredName == nil then self.StoredName = "ERROR" end
			if self.StoredSub == nil then self.StoredSub = "ERROR" end
		
			surface.SetFont( dhinline_GetAppropriateFont(self.StoredName, 1) )
			local wB, hB = surface.GetTextSize( self.StoredName )
			
			surface.SetFont( dhinline_GetAppropriateFont(self.StoredSub, 0) )
			local wS, hS = surface.GetTextSize( self.StoredSub )
			
			local w = math.Max(wB,wS)
			local x, y = self:GetMySizes()
			
			self:ChangeSmootherTarget("width", 44 + w)
			self:ChangeSmootherTarget("height", self.HeightStartWaitup)
			self:ChangeSmootherRate("width", 0.7)
			self:ChangeSmootherRate("height", 0.7)
		end
		self.SizeX = self:GetSmootherCurrent("width")
		if self:GetSmootherCurrent("height") > 0 then
			blinkSize = 1.0 + math.Clamp(self:GetSmootherCurrent("height"), 0, 1)
		end
		//self.SizeY = (1-(1-math.Clamp(self:GetSmootherCurrent("height"),0,1))^8)*-0.7
		
		local rate = 1
		
		local mX,mY = self:GetMySizes()
		
		self.textColor.r = self.baseColor.r
		self.textColor.g = self.baseColor.g
		self.textColor.b = self.baseColor.b
		
		self.textColor.a = ( 1 - ((RealTime() - self.GetVersionRealTime)/self.PersistTime)^8 ) * 255
		
		self:DrawGenericInfobox(
	/*Text   */ self.StoredName
	/*Subtxt */ ,self.StoredSub
	/* %     */ ,rate
	/*atRight*/ ,false
	/*0.0 col*/ ,self.WarningColor
	/*1.0 col*/ ,self.WarningColor
	/*minSize*/ ,0.2
	/*maxSize*/ ,1.0
	/*blink< */ ,self.Blinkcap
	/*blinkSz*/ ,blinkSize
	/*Font   */ ,1
	/*bStatic*/ ,true
	/*stCol  */ ,self.textColor
	/*stColSm*/ ,nil
		)
		return true
	end
end
