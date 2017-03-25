


local function FuckTest(Byte)
	local P11 = 0
	local P10 = 1
	local P12 = 1
	local P13 = 1
	local P15 = 1


	if Byte > 127 then
		P11 = 1
		Byte = Byte - 128
	end
	
	if Byte > 63 then
		P10 = 0
		Byte = Byte - 64
	end
	
	if Byte > 31 then
		P12 = 0
		Byte = Byte - 32
	end
	
	if Byte > 15 then
		P13 = 0
		Byte = Byte - 16
	end
	
	if Byte > 7 then
		P15 = 0
	end
	
	print("! P11,P10,P12,P13,P15: ", P11,P10,P12,P13,P15)
end




