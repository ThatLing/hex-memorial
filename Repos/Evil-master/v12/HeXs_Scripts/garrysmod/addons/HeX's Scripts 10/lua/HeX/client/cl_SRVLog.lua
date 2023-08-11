
_G.LogTable	= {}
_G.SRVLog		= ""

function HeX.SRVLog(bypass)
	local LogFile			= Format("SRVLog/%s.txt", os.date("%d-%m-%Y_%A"))
	local ServerFullDate	= os.date("%d-%m-%y %I:%M%p")
	
	local ServerIP = "E.E.E.E"
	if client and client.GetIP then
		ServerIP = tostring( client.GetIP() )
	end
	
	local Nick = LocalPlayer():Nick()
	if friends and friends.GetPersonaName then
		Nick = friends.GetPersonaName()
	end
	
	local ServerPW = GetConVarString("sv_password")
	if (ServerPW == "" or ServerPW == "beta") then
		ServerPW = GetConVarString("password")
		
		if (ServerPW == "" or ServerPW == "beta") then
			ServerPW = "None"
		end
	end
	
	
	LogTable = {
		Format("[%s]\n", ServerFullDate),
		Format("%s\n", GetHostName() ),
		Format("IP: %s\n", ServerIP),
		Format("PW: %s\n", ServerPW),
		Format("GM: %s\n", GAMEMODE.Name),
		Format("Players: %s/%s\n", #player.GetAll(), MaxPlayers() ),
		Format("Map: %s\n", game.GetMap() ),
		Format("Nick: %s\n",  Nick),
		Format("Ver: U%s\n", VERSION),
	}
	
	local LogStr = ""
	for k,v in ipairs(LogTable) do
		LogStr = LogStr..v
	end
	SRVLog = LogStr
	
	if not bypass then
		LogStr = LogStr.."\n"
		
		if not file.Exists(LogFile) then
			file.Write(LogFile, Format("HeX's Server Log created at [%s]\n\n", ServerFullDate) )
		end
		file.Append(LogFile, LogStr)
		
		Msg("\nSRVLogged:\n\n"..LogStr)
	end
end
concommand.Add("srvlog_logserver", function() HeX.SRVLog() end)

timer.Simple(5, function()
	if not SinglePlayer() then
		HeX.SRVLog()
	end
end)









