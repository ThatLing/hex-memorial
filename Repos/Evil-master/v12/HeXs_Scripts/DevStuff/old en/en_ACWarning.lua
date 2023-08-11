

AAH = {}
AAH.Found = {}
AAH.DoneMsg = false

local NotFFIL	= NotFFIL 	or file.FindInLua
local NotFE		= NotFE 	or file.Exists
local NotCCA	= NotCCA 	or concommand.Add
local NotFF		= NotFF 	or file.Find
local NotFD		= NotFD 	or file.Delete
local NotGCV	= NotGCV 	or GetConVar

local NotDGU	= debug.getupvalue
local NotDGI	= debug.getinfo
local NotCCR	= concommand.Remove


AAH.ACTable = {
	["CheatBlocker"]	= "autorun/CB.lua",
	["FAC"]				= "includes/enum/fac.lua",
	["AC_OB"]			= "includes/enum/ac_*.lua",
	["OldHAC"]			= "includes/enum/0.lua",
	["quicksnap"]		= "sh_quicksnap.lua",
	["RoTF"]			= "rot/*.lua",
	["RoTF_Alt"]		= "rotf_pak1.lua",
	["BananaLord"]		= "autorun/client/anti_cheat_derma.lua",
	["azu_anticheat"]	= "autorun/azu_anticheat.lua",
	["XAC"]				= "includes/enum/xac.lua",
	["CheckAC"]			= "includes/extensions/a.lua",
	["rcon"]			= "autorun/rcon.lua",
	--["GBPS/Frenga"] = "includes/enum/!.lua", --add "\33" fucking "!" char, can't search for it
	--["HAC"] = "includes/enum/!!!!!!!!!!.lua",
}


function HeXAntiCheatCheck(ac)
	if not AAH.ACTable[ ac ] then return false end
	return NotFE("lua/"..AAH.ACTable[ ac ], true)
end

local Total = 0
for AC,DC in pairs(AAH.ACTable) do
	Total = Total + 1
	if HeXAntiCheatCheck(AC) then
		print("[HeX] Server has: ", AC)
	end
end
print("[HeX] ACWarning ["..Total.."]")


local function AAHBypass()
	if (HeXAntiCheatCheck("FAC") or (string.Random)) and not (AAH.FAC) then
		table.insert(AAH.Found, "Flapadar's Anticheat")
		AAH.FAC = true
		
		print("[HeX] FAC!")
		
	elseif (HeXAntiCheatCheck("RoTF") or HeXAntiCheatCheck("RoTF_Alt") or Realm or RoTF_Hooks or (hook.GetTable()["Think"]["RealmChatboxMarkupTick"])
	or (hook.GetTable()["Think"]["nope_avi"])) and not (AAH.RoTF) then
		table.insert(AAH.Found, "RoTF Anticheat")
		AAH.RoTF = true
		
		print("[HeX] RoTF Anticheat")
		
	elseif (HeXAntiCheatCheck("CheatBlocker") or CBCheck or BannableCommands or timer.IsTimer("refreshConsoleCommands")) and not (AAH.CheatBlocker) then
		table.insert(AAH.Found, "CheatBlocker")
		AAH.CheatBlocker = true
		
		BannableCommands = {}
		timer.Destroy("refreshConsoleCommands")
		print("[HeX] CheatBlocker Anticheat")
		
		
	elseif (HeXAntiCheatCheck("BananaLord") or ShowAntiCheatInfo) and not (AAH.BananaLord) then
		table.insert(AAH.Found, "BananaLord")
		AAH.BananaLord = true
		
		ShowAntiCheatInfo = function() end
		LocalPlayer():SetNWInt("WarningLevel", 0)
		print("[HeX] BananaLord Anticheat")
		
		
	elseif (HeXAntiCheatCheck("CheckAC") or WE_NOT_HAVE_HAX) and not (AAH.CheckAC) then
		table.insert(AAH.Found, "CheckAC")
		AAH.CheckAC = true
		
		print("[HeX] CheckAC Anticheat")
		
		
	elseif HeXAntiCheatCheck("GBPS/Frenga") and not (AAH.GBPS) then
		table.insert(AAH.Found, "GBPS/Frenga Anticheat")
		AAH.GBPS = true
		
		print("[HeX] GBPS/Frenga Anticheat")
		
		
	elseif query_hacks and not (AAH.query_hacks) then
		table.insert(AAH.Found, "query_hacks")
		AAH.query_hacks = true
		
		HeXLRCL('alias "~sendhackreport" "echo [HeX] CheckAC: ~sendhackreport"')
		concommand.Remove("~sendhackreport")
		
		HeXLRCL('alias "_sendhackreport" "echo [HeX] CheckAC: _sendhackreport"')
		concommand.Remove("_sendhackreport")
		
		HeXLRCL('alias "query_hacks" "echo [HeX] CheckAC: query_hacks"')
		concommand.Remove("query_hacks")
		print("[HeX] query_hacks")
		
		
	elseif (CheckStolenGoods or MadeThisShit) and not (AAH.PERP) then
		table.insert(AAH.Found, "PERP")
		AAH.PERP = true
		
		print("[HeX] PERP")
		
		
	elseif HeXAntiCheatCheck("quicksnap") and not (AAH.quicksnap) then
		table.insert(AAH.Found, "quicksnap")
		AAH.quicksnap = true
		
		HeXLRCL('alias "quicksnap" "echo [HeX] quicksnap"')
		print("[HeX] quicksnap")
		
		
	elseif HeXAntiCheatCheck("azu_anticheat") and not (AAH.azu) then
		table.insert(AAH.Found, "Azu's Anticheat")
		AAH.azu = true
		
		concommand.Remove = NotCCR
		print("[HeX] Azu's Anticheat")
		
		
	elseif HeXAntiCheatCheck("rcon") and not (AAH.rcon) then
		table.insert(AAH.Found, "RCON stealer")
		AAH.rcon = true
		
		usermessage.Hook("herpderpin", function(um) --Shitty RCon stealer
			RunConsoleCommand("sendshit", "you dun goofed", "And the consequences will never be the same")
			print("Shitty RCon stealer blocked!")
		end)
		print("[HeX] RCon stealer")
		
		
	elseif ( HeXAntiCheatCheck("XAC") or oldRCC or xac or (NotDGU(RunConsoleCommand,1) ~= nil) and not (HeXAntiCheatCheck("HAC") or HACInstalled) ) and not (AAH.XAC) then
		table.insert(AAH.Found, "Xana Anticheat")
		
		print("[HeX] Xana Anticheat")
		
		
	elseif HeXGlobal_AC and (#AAH.Found == 0) and not (HeXAntiCheatCheck("HAC") or HACInstalled) and not (AAH.Generic) then
		table.insert(AAH.Found, "A Generic Anticheat")

		AAH.Generic = true
		
		print("[HeX] Generic Anticheat")
	end
end


AAHBypass()
timer.Create("AAH", 1, 0, function()
	AAHBypass()
end)



