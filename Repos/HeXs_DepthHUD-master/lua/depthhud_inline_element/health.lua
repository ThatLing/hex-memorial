ELEMENT.Name = "Health"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 0
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.xRelPosEvo = 0
ELEMENT.yRelPosEvo = -1

ELEMENT.EvoLagMul   = 2.5
ELEMENT.EvoDuration = 2
ELEMENT.EvoPower = 4

ELEMENT.LastHealth = 0

ELEMENT.color = nil
ELEMENT.accumPositive    = Color(0,255,0,255)
ELEMENT.accumNegative    = Color(255,0,0,255)
ELEMENT.healthColor = nil
ELEMENT.colorBad     = Color(255,0,0,192)
ELEMENT.colorBadLesser = Color(255,0,0,128)

function ELEMENT:Initialize( )

end

function ELEMENT:DrawFunction( )
	//self:DrawGenericContentbox(512, math.floor(32 * 1.4), 128, "aaa")

	if LocalPlayer():Alive() then
		self.healthColor = nil
		local rate = LocalPlayer():Health() / 100
		if (rate > 0.25) then
			self.healthColor = nil
		else
			self.healthColor = self.colorBad
		end
		
		if (LocalPlayer():Health() != self.LastHealth) then
			local accum = dhinline_GetVolatileStorage("health_evolution") or 0
			self.color = nil
			local text = ""
			accum = accum + (LocalPlayer():Health() - self.LastHealth)
			
			if (accum > 0) then
				self.color = self.accumPositive
				text = "+" .. accum
			else
				self.color = self.accumNegative
				text = "" .. accum
			end
			
			
			self:UpdateVolatile(
/*Vola   */ "health_evolution"
/*xRelOff*/ ,self.xRelPosEvo
/*yRelOff*/ ,self.yRelPosEvo
/*Text   */ ,text
/*Color  */ ,self.color
/*LagMul */ ,self.EvoLagMul
/*Font   */ ,nil
/*Time   */ ,self.EvoDuration
/*FadePow*/ ,self.EvoPower
/*Storage*/ ,accum
			)
		end
		
		self:DrawGenericInfobox(
/*Text   */ LocalPlayer():Health()
/*Subtxt */ ,""
/* %     */ ,rate
/*atRight*/ ,false
/*0.0 col*/ ,self.colorBadLesser
/*1.0 col*/ ,nil
/*minSize*/ ,1.0
/*maxSize*/ ,1.0
/*blink< */ ,0.05
/*blinkSz*/ ,1.0
/*Font   */ ,nil
/*bStatic*/ ,true
/*stCol  */ ,self.healthColor
/*stColSm*/ ,nil
		)
	end
	
	self.LastHealth = LocalPlayer():Health()
	
	return true
end
