

require("sdef3")

local Bypass = true

hook.Add("ScriptEnforcer", "Bypass", function()
	return not Bypass
end)

hook.Add("ShouldAllowScript", "Bypass", function()
	return Bypass
end)






