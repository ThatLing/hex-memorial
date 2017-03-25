

button = {}
local function DoRead()
	local Byte = para.Read(READ_ADDR)
	
	button = {
		[3] = not	(Byte & SP3 > 0),
		[4] = not	(Byte & SP4 > 0),
		[5] = not	(Byte & SP5 > 0),
		[6] = not	(Byte & SP6 > 0),
		[7] =		(Byte & SP7 > 0) --This one is inverted!
	}
	
	for k=3,7 do
		if button[k] then
			print("! button: ", k)
		end
	end
	--print("! Byte: ", Byte)
end
