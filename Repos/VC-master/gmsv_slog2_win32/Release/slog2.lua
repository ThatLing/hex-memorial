

require("slog2")


local function S2_AddHook(ply)
	if ply:IsBot() then return end
	
	local Done,err = slog2.Add( ply:EntIndex() ) --Needs a player, any player, to start the hook
	
	if err or not Done then
		ErrorNoHalt("Slog2, can't hook: "..tostring(err).."\n")
		return
	end
	
	hook.Remove("PlayerInitialSpawn", "S2_AddHook")
end
hook.Add("PlayerInitialSpawn", "S2_AddHook", S2_AddHook)

local function S2_OnCommand(cmd,sid)
	--command,steamid, return bool to block
end
hook.Add("ExecuteStringCommand", "S2_OnCommand", S2_OnCommand)















