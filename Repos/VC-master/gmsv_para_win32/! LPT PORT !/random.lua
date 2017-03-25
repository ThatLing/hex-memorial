
if not para then
	require("para")
end

local function DoFlash()
	local Byte = math.random(0,255)
	print("! byte: ", Byte)
	
	para.WriteByte(Byte)
end


Speed 	= 0
When	= 0.9
hook.Add("Think", "Slow", function()
	Speed = Speed + 0.1
	
	if Speed > When then
		Speed = 0
		DoFlash()
	end
end)














