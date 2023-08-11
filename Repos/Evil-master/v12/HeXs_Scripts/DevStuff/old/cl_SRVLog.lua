if SERVER then return end
--HeX's "WTF was that server i played on!" script

local SRVLogEnabled = CreateClientConVar("srv_log_enabled", 1, true, false)
local SRVLogFile = "SRVLog/SRVLog.txt"

local ServerFullDate = os.date("%d-%m-%y %I:%M%p")
local ServerTime = os.date("%I-%M%p")
local ServerName = GetHostName()
local ServerIP = "0.0.0.0"
local ServerMap = game.GetMap()
local ServerPlayers = "0/0"
local SRVLogString = "SRVLogString"
local GModVersion = "U"..VERSION

function SRVLogLog()
	SRVLogFile = "SRVLog/"..os.date("%d-%m-%Y_%A")..".txt"
	ServerFullDate = os.date("%d-%m-%y %I:%M%p")

	ServerTime = os.date("%I-%M%p")
	ServerName = GetHostName()
	ServerIP = "0.0.0.0" --there is no way to get the current server's IP that i know of
	ServerMap = game.GetMap()
	ServerPlayers = string.format("%s/%s", #player.GetAll(), MaxPlayers())
	
	SRVLogString = string.format("[%s]\nName: %s\nPlayers: %s\nMap: %s\nV: %s\n\n", ServerFullDate, ServerName, ServerPlayers, ServerMap, GModVersion)
	--SRVLogString = string.format("[%s]\nName: %s\nIP: %s\n Players: %s\nMap: %s\n\n", ServerFullDate, ServerName, ServerIP, ServerPlayers, ServerMap)
	
	if not file.Exists(SRVLogFile) then
		file.Write(SRVLogFile, string.format("HeX's Server Log created at [%s]\n\n", ServerFullDate))
	end
	filex.Append(SRVLogFile, SRVLogString)
	Msg("\n"..SRVLogString)
end
concommand.Add("logserver", SRVLogLog)

local function SRVLogInit()
	timer.Create("SRVLogInit", 5, 1, function()
		if not SinglePlayer() and SRVLogEnabled:GetBool() and (#player.GetAll() > 1) then
			SRVLogLog()
		end
	end)
end
hook.Add("InitPostEntity", "SRVLog", SRVLogInit)








