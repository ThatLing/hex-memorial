

local CVAR = CreateClientConVar("garbage_step",150,true,false)
local TURN_GC_OFF = CreateClientConVar("garbage_collection",1,true,false)


local function GarbageThink()
	if not (TURN_GC_OFF) then return end
	collectgarbage("step",CVAR:GetInt())
end
hook.Add("Think","GarbageThink",GarbageThink)


concommand.Add("garbage_kill", function()
	hook.Remove("Think","GarbageThink")
end)



