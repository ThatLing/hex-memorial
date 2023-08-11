ELEMENT.Name = "Witnesses"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = -1.3
ELEMENT.SizeY = -0.65

//ELEMENT.MaxWitnesses = 10
ELEMENT.colorBadLesser =  ELEMENT.Theme:GetColorReference( "badcolor" )

ELEMENT.myRealPos = nil
ELEMENT.myTrace = {}
ELEMENT.myTraceRes = {}
ELEMENT.myTraceRes.mask = MASK_SOLID_BRUSHONLY

ELEMENT.angleCap = math.cos(math.rad(45))
//print(ELEMENT.angleCap)

ELEMENT.lastWitnessCheck = 0
ELEMENT.witnessCheckDelay = 0.3

ELEMENT.counter = 0
ELEMENT.looking = 0

ELEMENT.TIME_LastPlayerFind = 0
ELEMENT.TIME_DELAY_PLY      = 2.0

ELEMENT.FINDER_Players = {}

ELEMENT.eyeOffs = Vector(0,0,32)


function ELEMENT:Initialize()
	self:CreateSmoother("area", 0, 0.1)
	self:CreateSmoother("looking", 0, 0.1)
	self:CreateSmoother("rate", 0, 0.2)
end

function ELEMENT:UseMyOwnFindPlayers()
	if (CurTime() < (self.TIME_LastPlayerFind + self.TIME_DELAY_PLY)) then return end
	
	self.FINDER_Players = {}
	self.FINDER_Players = player.GetAll()
	for k,ply in pairs(self.FINDER_Players) do
		if (ply:Team() == TEAM_SPECTATOR) then
			table.remove( self.FINDER_Players, k )
		end
	end
	self.TIME_LastPlayerFind = CurTime()
end

function ELEMENT:GetBestPlayerTable()
	if (dhradar_dat and dhradar_dat.FINDER_Players) and (dhinline.GetVar("dhradar_enable") > 0) then
		return dhradar_dat.FINDER_Players
	else
		self:UseMyOwnFindPlayers()
		return self.FINDER_Players
	end
end

function ELEMENT:DrawFunction()
	if SinglePlayer() then return end
	self:FadeIn()

	local area_smooth = nil
	local looking_smooth = nil
	local rate_smooth = nil
	local text = ""
	local smallText = ""
	local rate = 0
	
	local myBestPlayerTable = self:GetBestPlayerTable()		
	if (CurTime() > ( self.lastWitnessCheck + self.witnessCheckDelay )) then
		self.looking = 0
		self.counter = 0
		
		self.myRealPos = LocalPlayer():EyePos()
		for k,ply in pairs(myBestPlayerTable) do
			if ply:IsValid() and (ply ~= LocalPlayer()) then
				self.myTrace.start  = self.myRealPos + self.eyeOffs
				self.myTrace.endpos = ply:EyePos()   + self.eyeOffs
				self.myTrace.filter = { ply , LocalPlayer() }

				self.myTraceRes = util.TraceLine( self.myTrace )
				if (not self.myTraceRes.Hit) then
					self.counter = self.counter + 1
					if (ply:EyeAngles():Forward():DotProduct((self.myRealPos - ply:EyePos()):Normalize()) > self.angleCap) then
						self.looking = self.looking + 1
					end
				end
			end
		end
		self:ChangeSmootherTarget("area", self.counter)
		self:ChangeSmootherTarget("looking", self.looking)
		
		self.lastWitnessCheck = CurTime()
	end
	
	looking_smooth   = math.Round(self:GetSmootherCurrent("looking"))
	area_smooth = math.Round(self:GetSmootherCurrent("area"))
	
	rate = (1 - math.Clamp(looking_smooth / math.Clamp(area_smooth,1,128),0,1))^2
	self:ChangeSmootherTarget("rate", rate)
	
	text = looking_smooth .. " / " .. area_smooth
	smallText = "WITNESSES"
	
	rate_smooth = self:GetSmootherCurrent("rate")
	
	
	self:DrawGenericInfobox(
/*Text   */ text
/*Subtxt */ ,smallText
/* %     */ ,rate_smooth or rate
/*atRight*/ ,false
/*0.0 col*/ ,self.colorBadLesser
/*1.0 col*/ ,nil
/*minSize*/ ,1.0
/*maxSize*/ ,1.0
/*blink< */ ,-1
/*blinkSz*/ ,1.0
/*Font   */ ,1
/*bStatic*/ ,true
/*stCol  */ ,nil
/*stColSm*/ ,nil
	)
	
	return true
end
