

if (HeXGlobal_AC or HACInstalled) then
	printDelay("[WRN] Not loading PissOff, AC!")
	return
end

--0 block, 1 allow, 2 log and allow
local EnabledPCC = CreateClientConVar("hex_pcc", 1, false, false)
local EnabledRCC = CreateClientConVar("hex_rcc", 1, false, false)


local function ConCommand(self,str)
	local Lev = EnabledPCC:GetInt()
	
	if (Lev == 0) then --Block
		print("! BLOCKED PCC: ", str)
		return
		
	elseif (Lev == 2) then
		print("! PCC: ", str)
	end
	
	return self:ConCommandOld(str)
end
HeX.Detour.Meta("Player", "ConCommand", ConCommand)


local function ConsoleCommand(...)
	local Lev 	= EnabledRCC:GetInt()
	
	if (Lev == 0) then --Block
		print("! BLOCKED RCC: ", ...)
		return
		
	elseif (Lev == 2) then
		print("! RCC: ", ...)
	end
	
	return RunConsoleCommandOld(...)
end
HeX.Detour.Global("_G", "RunConsoleCommand", ConsoleCommand)









