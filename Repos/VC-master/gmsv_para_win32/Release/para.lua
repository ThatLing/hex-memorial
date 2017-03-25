concommand.Add("fuck", function() include("autorun/server/para.lua") end)
if not para then require("para") end

WRITE_ADDR 	= 0x378
READ_ADDR 	= 0x379
LAST_BYTE	= 0

--- Writing ---
local Order = {
	--[[
	DP0 | DP7,
	DP1 | DP6,
	DP2 | DP5,
	DP3 | DP4,
	DP2 | DP5,
	DP1 | DP6,
	]]
	DP0,
	DP1,
	DP2,
	DP1,
}


local CharOn 	= "*"
local CharOff 	= " "

function UpdateVars(Byte)
	return
	(Byte & DP0 > 0) and CharOn or CharOff,
	(Byte & DP1 > 0) and CharOn or CharOff,
	(Byte & DP2 > 0) and CharOn or CharOff,
	(Byte & DP3 > 0) and CharOn or CharOff,
	(Byte & DP4 > 0) and CharOn or CharOff,
	(Byte & DP5 > 0) and CharOn or CharOff,
	(Byte & DP6 > 0) and CharOn or CharOff,
	(Byte & DP7 > 0) and CharOn or CharOff
end

local Count = 0
local function DoFlash()
	Count = Count + 1
	if Count > #Order then
		Count = 1
	end
	local Byte = Order[Count]
	
	MsgN("============================")
	MsgN( Format("|  %s  %s  %s  %s  %s  %s  %s  %s  |", UpdateVars(Byte) ) )
	MsgN("============================\n")
	
	LAST_BYTE = Byte
	para.Write(WRITE_ADDR, Byte)
	--para.Beep(500,10)
end
--- /Writing ---


--- Reading ---
local Lookup = {
	[3] = {Pin = SP3, DoneOne = false, DoneTwo = true},
	[4] = {Pin = SP4, DoneOne = false, DoneTwo = true},
	[5] = {Pin = SP5, DoneOne = false, DoneTwo = true},
	[6] = {Pin = SP6, DoneOne = false, DoneTwo = true},
	[7] = {Pin = SP7, DoneOne = false, DoneTwo = true},
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
		local v = Lookup[k]
		
		if Buttons[k] then
			if not v.DoneOne then
				v.DoneOne = true
				v.DoneTwo = false
				hook.Call("StatusPinChanged", nil, true, v.Pin, k)
			end
		else
			if not v.DoneTwo then
				v.DoneTwo = true
				v.DoneOne = false
				hook.Call("StatusPinChanged", nil, false, v.Pin, k)
			end
		end
	end
end


local function TestHook(down,pin,k)
	if down then
		print("! Down pin,k: ", pin,k)
	else
		print("! Up pin,k: ", pin,k)
	end
end
hook.Add("StatusPinChanged", "TestHook", TestHook)
--- /Reading ---



local Flashing = false
local function StartFlash(pin)
	Flashing = not Flashing
	
	
	local Byte = 0
	if Flashing then
		Byte = LAST_BYTE | pin
	else
		Byte = LAST_BYTE & DP_ALL - pin
	end
	
	para.Write(WRITE_ADDR, Byte)
end

timer.Create("Flash", 0.5, 0, function()
	StartFlash(DP7)
end)




When 	= 0
Speed	= 1
IsRunning = true

local function BeepCount()
	DoRead()
	
	if IsRunning then
		When = When + 0.1
		
		if When > Speed then
			When = 0

			DoFlash()
		end
	end
end
hook.Add("Think", "Slow", BeepCount)


concommand.Add("shit", function()
	IsRunning = not IsRunning
end)







