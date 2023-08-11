
--[[
local HeXSpeedHackSpeed = CreateClientConVar("hex_speed", 3)
local function HeXSpeedHack(ply,cmd,args) --old toggle way
	if GetConVar("sv_cheats"):GetBool() then
		if cmd == "+speedhack" then
			HeXSetvar(CreateConVar("host_timescale",""), HeXSpeedHackSpeed:GetInt())
		elseif cmd == "-speedhack" then
			HeXSetvar(CreateConVar("host_timescale",""), 1) 
		end
	else
		print("[HeX] cheats are off, use hex_svc to enable sv_cheats")
	end
end
concommand.Add("+speedhack", HeXSpeedHack)
concommand.Add("-speedhack", HeXSpeedHack)
]]
