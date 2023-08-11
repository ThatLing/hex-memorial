

local Enabled = CreateClientConVar("hex_givesweps", 1, true, false)

local function HCallPlayerSpawn()
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) then
			local Alive = v:Alive()
			
			if Alive then
				if not v.DoneOne then
					v.DoneOne = true
					v.DoneTwo = false
					hook.Call("LocalPlayerSpawn", nil, v)
				end
			else
				if not v.DoneTwo then
					v.DoneTwo = true
					v.DoneOne = false
					hook.Call("LocalPlayerDeath", nil, v)
				end
			end
		end
	end
end
hook.Add("Think", "HCallPlayerSpawn", HCallPlayerSpawn)


local meta = FindMetaTable("Player")
function meta:SelectWeapon(kwc)
	if not self == LocalPlayer() then
		ErrorNoHalt("Can't call meta:SelectWeapon on non-LocalPlayer!\n", 2)
		return
	end
	
	RunConsoleCommand("use", kwc)
end
function meta:Give(kwc)
	if not self == LocalPlayer() then
		ErrorNoHalt("Can't call meta:Give on non-LocalPlayer!\n", 2)
		return
	end
	
	RunConsoleCommand("gm_giveswep", kwc)
end
function meta:Spawn(kwc)
	if not self == LocalPlayer() then
		ErrorNoHalt("Can't call meta:Spawn on non-LocalPlayer!\n", 2)
		return
	end
	
	RunConsoleCommand("+jump")
	timer.Simple(0.1, RunConsoleCommand, "-jump")
end


local function GiveAK47(ply)
	if Enabled:GetBool() and ply == LocalPlayer() then
		ply:Give("weapon_tmp")
		ply:Give("weapon_ak47")
		ply:SelectWeapon("weapon_physgun")
	end
end
hook.Add("LocalPlayerSpawn", "GiveAK47", GiveAK47)


--[[
local function LocalPlayerDeath(ply)
	print("! dead: ", ply)
end
hook.Add("LocalPlayerDeath", "LocalPlayerDeath", LocalPlayerDeath)
]]






