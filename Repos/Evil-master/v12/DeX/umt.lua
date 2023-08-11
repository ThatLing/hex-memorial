

local UMTCode = [[
if (_G.usermessage.__metatable != nil) then
	RunConsoleCommand("gm_dex_umt")
end
]]


local function StartSpam(ply,cmd,args)
	BroadcastLua(UMTCode)
	ply:print("[OK] Sent UMTCode")
end
command.Add("sh_start", StartSpam, "SH chat spam")


local SpamTab = {}
local function StopSpam(ply,cmd,args)
	local tot = 0
	for TID,v in pairs(SpamTab) do
		timer.Destroy(TID)
		tot = tot + 1
	end
	SpamTab = {}
	
	ply:print("[OK] Stopped "..tot.." timers")
end
command.Add("sh_stop", StopSpam, "Stop the SH chat spam")


local Enabled = true
local function ToggleSH(ply,cmd,args)
	Enabled = not Enabled
	
	if Enabled then
		BroadcastLua(UMTCode)
	else
		StopSpam(ply,cmd,args)
	end
	
	ply:print("[OK] SH spam is now: "..tostring(Enabled) )
end
command.Add("sh_toggle", ToggleSH, "Enable/Disable SH spammer")


local log 	= "sethhack_users_banthem.txt"
local Spam	= {
	"My IP is _MYIP_ and i bought sethhack, please ban my ass!",
	"My IP is _MYIP_ and i'm terrible, i paid $25 into seth's DDoS fund!",
	"My IP is _MYIP_ and i'd suck seth's cock for SH v5",
	"My IP is _MYIP_ and i love paying seth for stolen code!",
	"I use sethhack, DDoS me for a change, my IP is _MYIP_",
}


local Logged = {}
local function GetUMT(ply,cmd,args)
	if ply:IsHeX() then return end
	print("! SHer: ", ply)
	ply.SHer = true
	
	if (type(_G.SkidCheck) == "function") then
		_G.SkidCheck()
	end
	
	local TID = "umt_"..ply:SteamID()
	SpamTab[TID] = ply
	
	if Enabled then
		timer.Create(TID, 10, 5, function()
			if ValidEntity(ply) then
				local msg = table.Random(Spam)
				msg = msg:gsub("_MYIP_", tostring(ply:IPAddress()) )
				
				ply:ConCommand( Format("say %s", msg) )
			end
		end)
	end
	
	local HeX = GetHeX()
	if ValidEntity(HeX) then
		HeX:ConCommand( Format([[logme2 SHer "%s"]], ply:SteamID()) )
	end
	
	if not Logged[TID] then
		Logged[TID] = true
		if not file.Exists(log) then
			local str = "This file contains a list of SH users who've joined this server, please ban them\n\n"
			file.Write(log, str)
		end
		file.Append(log, Format('\t["%s"] = {Name = "%s", SH = true},\n', ply:SteamID(), ply:Nick() ) )
	end
end
concommand.Add("gm_dex_umt", GetUMT)



local function SendUMT(ply)
	timer.Simple(2, function()
		if ValidEntity(ply) then
			ply:SendLua(UMTCode)
		end
	end)
end
hook.Add("PlayerInitialSpawn", "SendUMT", SendUMT)

BroadcastLua(UMTCode)

