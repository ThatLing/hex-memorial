--[[
	=== HeX's T toggle script, for Sykranos ==
]]


local function LongDick(bool)
	if bool then
		RunConsoleCommand("host_framerate", 10)
	else
		RunConsoleCommand("host_framerate", 0)
	end
end


local PressOn	= nil
local PressOff	= nil
local function Boobies()
	local Down = input.IsKeyDown(KEY_T)
	
	if Down then
		if not PressOn then
			PressOn  = true
			PressOff = false
			
			LongDick(true)
		end
	else
		if not PressOff then
			PressOff = true
			PressOn  = false
			
			LongDick(false)
		end
	end
end
hook.Add("Think", "Boobies", Boobies)