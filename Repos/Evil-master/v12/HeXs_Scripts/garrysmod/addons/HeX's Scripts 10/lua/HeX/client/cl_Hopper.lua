

local ChatOpen	= false
local BadMove	= {
	[MOVETYPE_NONE]			= true,
	[MOVETYPE_FLY]			= true,
	[MOVETYPE_FLYGRAVITY]	= true,
	[MOVETYPE_PUSH]			= true,
	[MOVETYPE_NOCLIP]		= true,
	[MOVETYPE_LADDER] 		= true,
	[MOVETYPE_OBSERVER]		= true,
}


local Key = input.IsKeyDown
local function Hopper(cmd)
	if ChatOpen then return end
	if not (Key(KEY_SPACE) and (Key(KEY_LSHIFT) or Key(KEY_LCONTROL))) then return end
	
	local ply = LocalPlayer()
	if (ply:WaterLevel() > 0) or BadMove[ ply:GetMoveType() ] then return end
	
	local butt = cmd:GetButtons()
	if ply:OnGround() then
		cmd:SetButtons(butt | IN_JUMP)
	else
		cmd:SetButtons(butt - IN_JUMP)
	end
end
hook.Add("CreateMove", "Hopper", Hopper)


hook.Add("StartChat", "Hopper_ChatOpen", function() ChatOpen = true end)
hook.Add("FinishChat", "Hopper_ChatClose", function() ChatOpen = false end)







