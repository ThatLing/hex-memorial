ELEMENT.Name = "Framerate (Smooth)"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.MaxFramerate = 100
ELEMENT.colorBadLesser = Color(255,0,0,92)

function ELEMENT:Initialize( )
	self:CreateSmoother("framerate", 25, 0.01)
end

function ELEMENT:DrawFunction( )
	local framerate_smooth = math.floor(self:GetSmootherCurrent("framerate"))
	
	local framerate = nil
	if (FrameTime() != 0) then
		framerate = math.ceil(1 /FrameTime())
	else
		framerate = 0
	end
	local smallText = "FPS"
	self:ChangeSmootherTarget("framerate", framerate)
	
	rate = 1 - (1 - math.Clamp(framerate_smooth / self.MaxFramerate,0,1))^2
	
	
	self:DrawGenericInfobox(
/*Text   */ framerate_smooth
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
	
	return true
end
