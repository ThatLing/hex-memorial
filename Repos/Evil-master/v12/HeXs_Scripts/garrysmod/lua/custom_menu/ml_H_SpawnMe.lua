

local SwepToSpam = CreateClientConVar("hex_spam_swepclass", "weapon_para", true, false)
local SentToSpam = CreateClientConVar("hex_spam_sentclass", "sent_ball", true, false)
local SpamRate	 = CreateClientConVar("hex_spam_rate", 0.05, true, false)

local SwepSpam = false
local SentSpam = false


local function SpamReset()
	timer.Destroy("spam_sewps")
	timer.Destroy("spam_sents")
end
hook.Add("OnDisconnectFromServer", "SpamReset", SpamReset)
concommand.Add("hex_spam_stop", SpamReset)


local function SpamSweps()
	if SwepSpam then
		SwepSpam = false
		timer.Destroy("spam_sewps")
	else
		SwepSpam = true
		timer.Create("spam_sewps", SpamRate:GetFloat(), 0, function()
			RunConsoleCommand("gm_spawnswep", SwepToSpam:GetString() )
		end)
	end
end
concommand.Add("hex_spam_swep", SpamSweps)


local function SpamSents()
	if SentSpam then
		SentSpam = false
		timer.Destroy("spam_sents")
	else
		SentSpam = true
		timer.Create("spam_sents", SpamRate:GetFloat(), 0, function()
			RunConsoleCommand("gm_spawnsent", SentToSpam:GetString() )
		end)
	end
end
concommand.Add("hex_spam_sent", SpamSents)



























