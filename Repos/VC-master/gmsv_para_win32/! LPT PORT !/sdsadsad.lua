



local Lookup = {
	[3] = SP3,
	[4] = SP4,
	[5] = SP5,
	[6] = SP6,
	[7] = SP7,
}


local Done = {
	[3] = {DoneOne = false, DoneTwo = false},
	[4] = {DoneOne = false, DoneTwo = false},
	[5] = {DoneOne = false, DoneTwo = false},
	[6] = {DoneOne = false, DoneTwo = false},
	[7] = {DoneOne = false, DoneTwo = false},
}

Buttons = {}
local function DoRead()
	local Byte = para.Read(READ_ADDR)
	
	Buttons = {
		[3] = not	(Byte & SP3 > 0),
		[4] = not	(Byte & SP4 > 0),
		[5] = not	(Byte & SP5 > 0),
		[6] = not	(Byte & SP6 > 0),
		[7] =		(Byte & SP7 > 0) --This one is inverted!
	}
	
	
	for k=3,7 do
		if Buttons[k] then
			if not Done[k].DoneOne then
				Done[k].DoneOne = true
				Done[k].DoneTwo = false
				hook.Call("StatusPinChanged", nil, Lookup[k], k)
			end
		else
			if not Done[k].DoneTwo then
				Done[k].DoneTwo = true
				Done[k].DoneOne = false
				hook.Call("StatusPinChanged", nil, Lookup[k], k)
			end
		end
	end
	
	--print("! Byte: ", Byte)
end





