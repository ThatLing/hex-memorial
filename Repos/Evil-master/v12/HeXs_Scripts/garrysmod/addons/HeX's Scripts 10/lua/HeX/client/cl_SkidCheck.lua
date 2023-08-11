
local Skiddies = {}

--- Setup Skiddie lists ---
Bulk	= {}
SHers	= {}

HeX.include("HeX/hx_SkidList.lua")

local function Merge(tab)
	for k,v in pairs(tab) do
		Skiddies[k] = v
	end
	tab = nil
end
Merge(Bulk)
Merge(SHers)

Bulk 	= nil
SHers	= nil


local function SBCheckPlayer(ply)
	http.Get("http://sethblock.tk/api.php?user="..ply:SteamID(), "", function(what,size)
		if ValidEntity(ply) and what:find("SethHack") then
			ply.IsSethBlock = true
		end
	end)
end

local function SBEntityCreated(ent)
	if ValidEntity(ent) and ent:IsPlayer() and (ent != LocalPlayer()) then
		SBCheckPlayer(ent)
	end
end
hook.Add("OnEntityCreated", "SkidCheck", SBEntityCreated)




local StartSB	= nil
local Done 		= {}

local function SkidCheck()
	for k,v in pairs( player.GetHumans() ) do
		if not ValidEntity(v) then continue end
		
		if not StartSB then
			StartSB = true
			
			timer.Simple(k, function()
				if ValidEntity(v) then
					SBCheckPlayer(v)
				end
			end)
		end
		
		
		local SID 	= v:SteamID()
		local Tab 	= Skiddies[SID]
		
		if Tab and not Done[SID] then
			local Name		= (Tab.Name or v:Nick()).." ("..SID..")"
			local wSound	= Sound("npc/scanner/combat_scan"..math.random(1,3)..".wav")
			local bSound	= nil
			local DoTab		= nil
			
			if Tab.SH then
				DoTab	= true
				bSound	= true
				
				chat.AddText(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", v, GREY, " is a ", RED, "SETHHACKER! ", GREEN, Name)
				
			elseif v.IsSethBlock then
				v.IsSethBlock = nil
				DoTab	= true
				bSound	= true
				
				chat.AddText(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", v, GREY, " is on ", RED, "SethBlock! ", GREEN, Name)
				
			elseif Tab.Skid then
				DoTab = true
				chat.AddText(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", v, GREY, " is a ", KCHEAT, "Skiddie! ", GREEN, Name)
				
			else
				DoTab = true
				chat.AddText(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", v, GREY, " is ", PINK, Name)
			end
			
			if DoTab then	Done[SID] = true end
			if bSound then	wSound = Sound("ambient/machines/thumper_shutdown1.wav") end
			surface.PlaySound(wSound)
		end
	end
end
timer.Create("SkidCheck", 5, 0, SkidCheck)


local function ResetSkiddies(ply,cmd,args)
	StartSB = nil
	Done 	= {}
	
	print("[SkidCheck] Messages reset, expect spam in 5s!")
end
concommand.Add("sk_reset", ResetSkiddies)




--- === Parsers / Dumpers === ---
local function SKDumpForHAC(ply,cmd,args)
	for k,v in pairs(Skiddies) do
		local Name	= v.Name or "None"
		local IsSH	= v.SH
		
		if IsSH then
			file.Write("skiddies/"..k:gsub(":","_")..".txt", Format("SH\n%s\nSKDump", Name) )
		end
	end
	
	print("[SkidCheck] Dumped all SHers in HAC format to data/skiddies/")
end
concommand.Add("sk_dump_hac", SKDumpForHAC)


local THIS_RUN_NAME = "CrowBarGaming: "
local function ProcessLogOfIDS(ply,cmd,args)
	if (#args == 0) then
		print("! no args")
		return
	end
	
	local Kfile = args[1]:gsub(".txt", "")
	
	local Data = file.Read(Kfile..".txt")
	
	if not Data then
		print("! no file for "..Data)
		return
	end
	
	local KTab	= string.Explode("\n", Data)
	
	local Temp = {}
	for k,v in pairs(KTab) do
		if v:find("NoInit") then continue end --SSHD log
		
		local SID	= v:match("(STEAM_(%d+):(%d+):(%d+))")
		--local Name	= THIS_RUN_NAME
		local Name = Format("%s%s", THIS_RUN_NAME, v:match("Logged: (.+)STEAM") )
		--local Name = Format("%s%s", THIS_RUN_NAME, v:match(";(.+)") )
		
		Name = Name:Replace(" (", "")
		print("! SID,Name: ", SID, Name)
		
		if not (Name and SID) then continue end
		
		local Tab = {Name = Name, SID = SID}
		if not Temp[ SID ] then
			Temp[ SID ] = Tab
		end
	end
	
	local this	= 0
	local tot	= 0
	for k,v in pairs(Temp) do
		tot = tot + 1
		local Name	= v.Name
		local SID	= v.SID
		
		if not Skiddies[ SID ] then
		--if not SHers[ SID ] then
			this = this + 1
			--local str = Format('\t["%s"] = {Name = "%s", SH = true},\n', SID, Name)
			local str = Format('\t["%s"] = {Name = "%s", Skid = true},\n', SID, Name)
			file.Append("sk_processed_"..Kfile..".txt", str)
		end
	end
	
	print("! saved "..this.." new SHers! (out of "..tot.." total in: "..Kfile..")")
end
concommand.Add("sk_process", ProcessLogOfIDS)


--[[
for k,v in pairs(NewSkid) do
	local Tab 		= Skiddies[v]
	
	if Tab then
		/*
		local Name		= (Tab.Name or v).." ("..v..")"
		
		if Tab.SH then
			print(v, " is a SETHHACKER! ", Name)
		elseif Tab.Skid then
			print(v, " is a Known Cheater! ", Name)
		else
			print(v, " is ", Name)
		end
		*/
	else
		local Name	= "Blackops"
		local IsSH	= true
		
		local str = ""
		if Name then
			str = str..'Name = "'..Name..'", '
		end
		
		local log = "bulk.txt"
		if IsSH then
			log = "seth.txt"
			str = str.."SH = true"
		else
			str = str.."Skid = true"
		end
		
		local Skid = Format('\t["%s"] = {%s},\n', v, str)
		file.Append(log, Skid)
	end
end






local NewTot = {}

local i = 0
for k,v in pairs(NewTot) do
	i = i + 1
	local Name	= v.Name
	local IsSH	= v.SH
	
	local str = ""
	if Name then
		str = str..'Name = "'..Name..'", '
	end
	
	local log = "bulk.txt"
	if IsSH then
		log = "seth.txt"
		str = str.."SH = true"
	else
		str = str.."Skid = true"
	end
	
	local Skid = Format('\t["%s"] = {%s},\n', k, str)
	file.Append(log, Skid)
end

print("! saved "..i.." cheaters!")

]]











