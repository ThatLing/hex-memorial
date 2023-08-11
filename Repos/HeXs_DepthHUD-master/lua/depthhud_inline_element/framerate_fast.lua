ELEMENT.Name = "Framerate (Fast)"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.MaxFramerate = 100
ELEMENT.colorBadLesser = Color(255,0,0,92)
ELEMENT.colorSlight = Color(0,0,0,92)

ELEMENT.FPShi_table = {}
ELEMENT.FPShi_max   = 5 // Must be > 1
ELEMENT.FPShi_alphamin = 16
ELEMENT.FPShi_alphamax = -1


function ELEMENT:Initialize( )
	self:CreateSmoother("framerate", 25, 0.05)
	
	for i=1,self.FPShi_max do
		self.FPShi_table[i] = 25
	end
end

function ELEMENT:DrawFunction( )
	local framerate_smooth = math.floor(self:GetSmootherCurrent("framerate"))
	
	local framerate = nil
	if (FrameTime() != 0) then
		framerate = math.ceil(1 /FrameTime())
	else
		framerate = 0
	end
	table.remove(self.FPShi_table,1)
	table.insert(self.FPShi_table,framerate)
	local smallText = "FPS"
	self:ChangeSmootherTarget("framerate", framerate)
	
	rate = 1 - (1 - math.Clamp(framerate_smooth / self.MaxFramerate,0,1))^2
	
	
	self:DrawGenericInfobox(
/*Text   */ "" //framerate_smooth
/*Subtxt */ ,smallText
/* %     */ ,rate
/*atRight*/ ,false
/*0.0 col*/ ,self.colorBadLesser
/*1.0 col*/ ,nil
/*minSize*/ ,0.5
/*maxSize*/ ,1.0
/*blink< */ ,-1
/*blinkSz*/ ,1.0
/*Font   */ ,nil
/*bStatic*/ ,true
/*stCol  */ ,nil
/*stColSm*/ ,nil
	)
	
	local styleColor = dhinline_GetStyleData("color_base")
	self.colorSlight.r = styleColor.r
	self.colorSlight.g = styleColor.g
	self.colorSlight.b = styleColor.b
	self.FPShi_alphamax = styleColor.a / (self.FPShi_max-1)
	
	for i=self.FPShi_max,1,-1 do
		self.colorSlight.a = self.FPShi_alphamax * (1-(1-(i / self.FPShi_max))^2)  +  self.FPShi_alphamin * (1-(i / self.FPShi_max)^2)
		self:DrawGenericText(self.FPShi_table[i], "", self.colorSlight, nil, 2, 1, 0.45, 0 )
	end
	
	return true
end
