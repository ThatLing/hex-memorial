
local Enabled = CreateClientConVar("hex_givesweps", 1, true, false)

local DoneOne	= nil
local DoneTwo	= nil
local function CallPlayerSpawn()
	if Enabled:GetBool() then
		local Alive = LocalPlayer():Alive()
		
		if Alive then
			if not DoneOne then
				DoneOne = true
				DoneTwo = false
				hook.Call("LocalPlayerSpawn", nil, LocalPlayer() )
			end
		else
			if not DoneTwo then
				DoneTwo = true
				DoneOne = false
			end
		end
	end
end
hook.Add("Think", "CallPlayerSpawn", CallPlayerSpawn)


local meta = FindMetaTable("Player")
function meta:SelectWeapon(kwc)
	RunConsoleCommand("use", kwc)
end
function meta:Give(kwc)
	RunConsoleCommand("gm_giveswep", kwc)
end

local function GiveMeAK47(ply)
	ply:Give("weapon_ak47")
	ply:SelectWeapon("weapon_physgun")
end
hook.Add("LocalPlayerSpawn", "GiveMeAK47", GiveMeAK47)







