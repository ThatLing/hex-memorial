--[[
	=== Simple BHop script by HeX ===
]]

local function DoHop()
	RunConsoleCommand((LocalPlayer():IsOnGround() and "+" or "-").."jump")
end


local Online = false

local function Toggle_On(ply,key)
	if key == IN_JUMP then
		Online = true
	else
		Online = false
	end
end
hook.Add("KeyPress", "Toggle_On", Toggle_On)

local function Toggle_Off(ply,key)


end
hook.Add("KeyRelease", "Toggle_Off", Toggle_Off)



local function CheckBHop()
	if Online then
		
	end
end
hook.Add("Think", "CheckBHop", CheckBHop)




KeyPress
KeyRelease


