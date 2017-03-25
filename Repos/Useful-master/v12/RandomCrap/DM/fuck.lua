








NotFFIL	= NotFFIL 	or file.FindInLua
ACTable = {}
ACTable = {
	["CheatBlocker"] = "autorun/CB.lua",
	["RoTF"] = "includes/enum/!!!.lua",
	["FAC"] = "includes/enum/fac.lua",
	["GBPS/Frenga"] = "includes/enum/!.lua",
	["HAC"] = "includes/enum/!!!!!!!!!!.lua",
	["OldHAC"] = "includes/enum/0.lua",
	["test"] = "arse.lua",
}

local TotalACs = 0
for k,v in pairs(ACTable) do --can't just to #ACTable when the keys are strings not numbers.
	TotalACs = TotalACs + 1
end

print("[HeX] ["..TotalACs.."] Anti-Cheats detectable")

function lolpoo(anticheat)
	if not anticheat then return false end
	if not ACTable[anticheat] then return false end
	return tobool(#NotFFIL( ACTable[anticheat] ) >= 1)
end

function HeXAntiCheatMsg()
	for AC,DC in pairs(ACTable) do 
		if lolpoo(AC) then
			print("[HeX] Server uses", AC)
		end
	end
end

HeXAntiCheatMsg()
