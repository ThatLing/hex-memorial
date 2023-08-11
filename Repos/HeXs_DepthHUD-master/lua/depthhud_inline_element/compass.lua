ELEMENT.Name = "Compass"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 1
ELEMENT.SizeX = -2.0
ELEMENT.SizeY = -0.75

ELEMENT.text = ""
ELEMENT.textColor = nil
ELEMENT.textColorCalc = Color(0,255,255,255)
ELEMENT.textSmall = ""
ELEMENT.textSmallColor = nil
ELEMENT.textSmallColorCalc = Color(0,255,255,255)
ELEMENT.textColorBaseAlpha = 0
ELEMENT.MaxFramerate = 100
ELEMENT.colorXcoords = Color(255,0,0,192)
ELEMENT.colorYcoords = Color(0,255,0,192)
ELEMENT.EyeAng = nil
ELEMENT.yaw = nil

ELEMENT.myXEquirel = 0
ELEMENT.myYEquirel = 0
ELEMENT.myAlphaAlter = 0

ELEMENT.baseColor = dhinline_GetStyleData("color_base")

ELEMENT.tvars = {}
ELEMENT.pointsCard = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
}
ELEMENT.pointsSmall = {
	[0] = {"Y+", ELEMENT.colorYcoords},
	[45] = "|",
	[90] = {"X+", ELEMENT.colorXcoords},
	[135] = "|",
	[180] = {"Y-", ELEMENT.colorYcoords},
	[225] = "|",
	[270] = {"X-", ELEMENT.colorXcoords},
	[315] = "|",
}

function ELEMENT:Initialize( )
	for i = 0,359,15 do
		if not self.pointsCard[i] then
			self.pointsCard[i] = "."
		end
	end
end

function ELEMENT:DrawFunction( )
	self.EyeAng = EyeAngles()
	self.yaw = self.EyeAng.y
	
	self:DrawGenericContentbox(
/*Text   */ ""
/*Subtxt */ ,""
/*Txtcol */ ,nil
/*Stxtcol*/ ,nil
/*FontN  */ ,0
	)
	
	self.textColorBaseAlpha = self.baseColor.a
	for k,v in pairs(self.pointsCard) do
		if math.sin((self.yaw + k)/180*math.pi) > 0 then
			self.myXEquirel = math.sin((self.yaw + k)/180*math.pi)
			self.myYEquirel = math.cos((self.yaw+k)/180*math.pi)
			
			self.myAlphaAlter =  (1 - (1 - math.Clamp(math.abs( self.myXEquirel ), 0, 1)^2) )
			
			if type(v) != "table" then
				self.textColorCalc.r = self.baseColor.r
				self.textColorCalc.g = self.baseColor.g
				self.textColorCalc.b = self.baseColor.b
				self.textColorCalc.a = self.textColorBaseAlpha  * self.myAlphaAlter
				self.textColor = self.textColorCalc
				
				self.text = v
			else
				self.textColorCalc.r = v[2].r
				self.textColorCalc.g = v[2].g
				self.textColorCalc.b = v[2].b
				self.textColorCalc.a = v[2].a  * self.myAlphaAlter
				
				self.textColor = self.textColorCalc
				self.text      = v[1]
			end
			
			if (self.pointsSmall[k])  then
				if (type(self.pointsSmall[k]) != "table") then
					self.textSmallColorCalc.r = self.baseColor.r
					self.textSmallColorCalc.g = self.baseColor.g
					self.textSmallColorCalc.b = self.baseColor.b
					self.textSmallColorCalc.a = self.textColorBaseAlpha * self.myAlphaAlter
					
					self.textSmallColor = self.textSmallColorCalc
					self.textSmall = self.pointsSmall[k]
				else
					self.textSmallColorCalc.r = self.pointsSmall[k][2].r
					self.textSmallColorCalc.g = self.pointsSmall[k][2].g
					self.textSmallColorCalc.b = self.pointsSmall[k][2].b
					self.textSmallColorCalc.a = self.pointsSmall[k][2].a  * self.myAlphaAlter
					
					self.textSmallColor = self.textSmallColorCalc
					self.textSmall      = self.pointsSmall[k][1]
				end
			else
				self.textSmall = ""
				self.textSmallColor = nil
			end
			

			self:DrawGenericText(tostring(self.text), tostring(self.textSmall), self.textColor, self.textSmallColor, -1, self.myXEquirel * 0.6, self.myYEquirel * 0.9, -0.3 )
		end
	end
	
	return true
end
