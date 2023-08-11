ELEMENT.Name = "Vehicle Speedometer (MPH)"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.Unit = "MPH"
ELEMENT.UNITLIST = {
	["MPH"] = {
		63360 / 3600,
		"MPH",
	},
	["KM/H"] = {
		39370.0787 / 3600,
		"KM/H",
	},
}

function ELEMENT:Initialize( )

end

function ELEMENT:DrawFunction( )
	//Vehicle Speed
	if LocalPlayer():InVehicle() then
		local unit = self.Unit
		local vehicleVel = LocalPlayer():GetVehicle():GetVelocity():Length()
		local vehicleConv = -1
		local terminal = 0
		
		if self.UNITLIST[unit] == nil then
			unit = "MPH"
		end
		terminal = math.Clamp(vehicleVel/2000, 0, 1)
		vehicleConv = math.Round(vehicleVel / self.UNITLIST[unit][1])
		
		self:DrawGenericInfobox(
/*Text   */ vehicleConv
/*Subtxt */ ,self.UNITLIST[unit][2]
/* %     */ ,terminal
/*atRight*/ ,true
/*0.0 col*/ ,nil
/*1.0 col*/ ,nil
/*minSize*/ ,0
/*maxSize*/ ,1.0
/*blink< */ ,-1
/*blinkSz*/ ,1.0
/*Font   */ ,nil
/*bStatic*/ ,true
/*stCol  */ ,nil
/*stColSm*/ ,nil
		)
	end
	
	return true
end
