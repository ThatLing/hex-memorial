

local Enabled = CreateClientConVar("srvlog_enabled", 1, true, false)


local function SRVLogLog()
	local LogTable	= {}
	local LogStr	= ""
	
	local LogFile = Format("SRVLog/%s.txt", os.date("%d-%m-%Y_%A"))
	local ServerFullDate = os.date("%d-%m-%y %I:%M%p")
	local Players = Format("%s/%s", table.maxn( player.GetAll() ), client.GetMaxPlayers())
	
	local ServerPW = GetConVarString("sv_password")
	if (ServerPW == "" or ServerPW == "beta") then
		ServerPW = "none"
	end
	
	local ServerIP = "E.E.E.E"
	if client and client.GetIP then
		ServerIP = tostring(client.GetIP() or ServerIP)
	end
	
	LogTable = {
		Format("[%s]\n", ServerFullDate ),
		Format("Name: %s\n", GetHostName() ),
		Format("GM: %s\n", GAMEMODE.Name ),
		Format("IP: %s\n", ServerIP ),
		Format("Pass: %s\n", ServerPW ),
		Format("Players: %s\n", Players ),
		Format("Map: %s\n", client.GetMapName() ),
		Format("SVC: %s\n", GetConVarString("sv_cheats") ),
		"\n",
	}
	for k,v in ipairs(LogTable) do
		LogStr = LogStr..v
	end
	
	if not file.Exists(LogFile) then
		file.Write(LogFile, Format("HeX's Server Log created at [%s]\n\n", ServerFullDate))
	end
	file.Append(LogFile, LogStr)
	Msg("\nSRVLogged:\n\n"..LogStr)
end
concommand.Add("srvlog_logserver", SRVLogLog)


local function SRVLogInit()
	timer.Simple(6, function()
		if client.IsInGame() and (#player.GetHumans() > 1) and Enabled:GetBool() and not client.IsDedicatedServer() then
			SRVLogLog()
		end
	end)
end
hook.Add("OnLoadingStopped", "SRVLog", SRVLogInit)








