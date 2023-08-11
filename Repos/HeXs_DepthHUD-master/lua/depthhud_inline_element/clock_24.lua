ELEMENT.Name = "Clock (24-hour format)"
ELEMENT.DefaultOff = true
ELEMENT.DefaultGridPosX = 8
ELEMENT.DefaultGridPosY = 0
ELEMENT.SizeX = -1.7
ELEMENT.SizeY = -0.65

function ELEMENT:Initialize( )

end

function ELEMENT:DrawFunction( )
	self:DrawGenericContentbox(
/*Text   */ os.date("%H:%M:%S")
/*Subtxt */ ,""
/*Txtcol */ ,nil
/*Stxtcol*/ ,nil
/*FontN  */ ,1
	)

	return false
end
