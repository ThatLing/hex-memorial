

HSP = HSP or {}
function HSP.StringCheck(str,check)
	return str:sub(1,#check) == check
end
string.Check = HSP.StringCheck
function ValidString(v)
	return (v and type(v) == "string" and v != "")
end
HSP.ValidString = ValidString
string.IsValid	= ValidString
local Enabled	= true
local Spam		= CreateConVar("hsp_filter_spam", 2, true, true)

HSP.ChatFilter	= {}


local Filter = "filter.txt"

HSP.ChatFilter.Crap = {}
HSP.ChatFilter.Fixed = {}
HSP.ChatFilter.Nouns = {}
HSP.ChatFilter.Abbreviations = {}
HSP.ChatFilter.Swearwords = {}

HSP.ChatFilter.Pronunciation = {}
HSP.ChatFilter.Ext = {}


ExecDownload(DEX_PATH, "sv_f_Crap.lua", true)
ExecDownload(DEX_PATH, "sv_f_List.lua", true)



local function AddLoop()
end

local function MakePureLetter(s) -- only letters/spaces remain
	s = s:gsub(".",	function(c)
		if c:match("[%a%s]") then return c end
		return ""
	end)
	return s
end

local function NoCase(s) -- generate case insensitive pattern
	s = string.gsub(s, ".", function(c)
		if c:find("%a") then
			return string.format("[%s%s]", string.lower(c), string.upper(c))
		else
			return "%A"
		end
	end)
	return s
end

local function CharacterIndependend(s, singleword) -- apply filter to scan for @#a^^&..ss .h&*(o@l,e>
	if singleword then
		s = "([^%a]*)"..s:gsub(".", function(c)
				return NoCase(c).."([^%a]*)"
			end)
			s = s:sub(0,-9)
		return s
	else
		s = "([^%a]*)"..s:gsub(".", function(c)
				return NoCase(c).."([^%a]*)"
			end)
		return "[%A]"..s.."[%A]"
	end
end


local function CheckSpam(ply,Name,text)
	if (ply.HSP_LastSpam and ply.HSP_LastSpam == text) then
		if not ply.HSP_LastSpamTot then
			ply.HSP_LastSpamTot = 0
		end
		ply.HSP_LastSpamTot = ply.HSP_LastSpamTot + 1
		
		if ply.HSP_LastSpamTot >= Spam:GetInt() then
			MsgAll("\nCHAT SPAM blocked from "..Name..": "..text.."\n")
			ply:ChatPrint(HUD_PRINTTALK, "Your text has been SNIPPED for spamming!")
			ply:SendLua([[ surface.PlaySound("npc/roller/mine/rmine_chirp_quest1.wav") ]])
			return true
		end
	else
		ply.HSP_LastSpamTot = 0 --Reset
	end
	ply.HSP_LastSpam = text
	
	timer.Create("HSP.ChatFilter_SpamReset_"..Name, 10, 1, function()
		if ValidEntity(ply) then
			ply.HSP_LastSpamTot = 0
			ply.HSP_LastSpam	= nil
		end		
	end)
end




function HSP.ChatFilter_CheckWords(ply,text)
	--debug.sethook()
	local low = text:lower()
	
	local new = ""
	for i=0, text:len() do -- for each character
		local str = text:sub(i,i) -- get char from string
		local found = false
		
		local Byte = HSP.ChatFilter.Crap[ str:byte() ]
		if Byte then
			new = new..Byte --replace character
			found = true --found, so don't add character after for loop
		end
		
		if not found then -- we did not replace anything, add character
			new = new..str -- add character
		end
	end
	if new != text then
		text = new
	end
	
	--FIXED
	local DoneFixed = false
	for k,v in pairs( HSP.ChatFilter.Fixed ) do
		AddLoop()
		local str = low
		if v.full then
			str = text
		end
		
		if (str:Trim() == v.what) then
			DoneFixed = true
			text = v.with
		end
	end
	if DoneFixed then
		return text
	end
	
	text = " "..text.." " -- add spaces used for finding patterns near begin and end of string
	
	--SWEARWORDS, [ with spaces NO automated Pronunciation endings, NO replace completly features ]
	for k,cuss in pairs(HSP.ChatFilter.Swearwords) do
		AddLoop()
		if cuss.spaces then
			local lower = CharacterIndependend(cuss.what)
			text = text:gsub(lower, " "..cuss.with.." ")
		end
	end
	
	text = text:gsub("([^%s]*)", function(c)
		if c=="" then --yes it happens
			return false,0
		end
		
		local b = c
		
		c = c:lower()
		
		--FIXME: Faster lookup method?
		for k,noun in pairs(HSP.ChatFilter.Nouns) do
			AddLoop()
			if c == noun.what then
				c = noun.with
				
			elseif c == (noun.whats or noun.what) then
				c = (noun.withs or noun.with)
			end
		end
		
		--SWEARWORDS, [ without spaces, automated Pronunciation endings ]
		for k,cuss in pairs(HSP.ChatFilter.Swearwords) do
			AddLoop()
			if not cuss.spaces then
				--fix wrong spelling due to pronunciation, love to loveer, making it lover
				local with 	= cuss.with
				local pron 	= cuss.pron
				local rep	= cuss.rep
				local what	= cuss.what
				
				if pron then
					if HSP.ChatFilter.Ext[ with:sub(-1,-1) ] then --check last character
						--remove it if bad for spelling pronunciation
						with = with:sub(0,-2)
					end
				end
				
				-- note to smart people, this loop is ALSO being done, to find ****-ed words, pron is optional behaviour
				for k,pronunciation in pairs(HSP.ChatFilter.Pronunciation) do
					AddLoop()
					if not rep then
						if pron then --add pronunciation to replacement
							c = c:gsub(CharacterIndependend(what..pronunciation, true), with..pronunciation)
						else -- find pronunciation but don't add it to the replacement
							c = c:gsub(CharacterIndependend(what..pronunciation, true), with)
						end
					else
						--replace entire word if a cuss is inside it ( with Pronunciation )
						if c:find(CharacterIndependend(what..pronunciation, true)) and pron then
							c = with..pronunciation
						end
					end
				end
				
				if rep then	--if finding the swear word, replace completly
					if c:find(CharacterIndependend(what, true)) then
						c = with
					end
				else
					--a random guess gsub, if a replacement contains a forbidden word @forloop that will be replaced!!!
					c = c:gsub(CharacterIndependend(what, true), with)
				end
			end
		end
		
		
		--ABBREVIATIONS, we do these last so f*Uranium doesn't occur before swearword scanning
		for k,abs in pairs(HSP.ChatFilter.Abbreviations) do
			AddLoop()
			local lower = MakePureLetter(c)
			if lower == abs.what then c = abs.with end
		end
		
		
		if b:lower() == c then
			return b --original, preserve casing
		else 
			return c --modified, use replacement
		end
	end)
	
	-- remove spaces used for finding patterns near begin and end of string
	if text:sub(1,1) == " " then
		text = text:sub(2)
	end
	if text:sub(-1,-1) == " " then
		text = text:sub(1,-1)
	end
	return text
end


local Override = true
local function ToggleFilter(ply,cmd,args)
	if not Override then
		Enabled = not Enabled
	end
	ply:print("[OK] Filter is now "..tostring(Enabled) )
end
concommand.Add("flt_toggle", ToggleFilter)

concommand.Add("flt_override", function(ply,cmd,args)
	Override = not Override
	
	Enabled = Override
	
	ply:print("[OK] Filter is now "..tostring(Enabled)..", Override: "..tostring(Override) )
end)


function HSP.ChatFilter_Process(ply,text,isteam)
	if not (ValidEntity(ply) and Enabled) then return end
	if (text:find( tostring(ply:IPAddress()) ) ) then return end --UMT
	
	text = text:gsub("Â", "")
	local OldText = text:Trim()
	
	if OldText:Check("!lua") then
		return --Don't break !lua
	end
	
	if ply:IsHeX() then
		return	
	end
	
	if OldText:Check("!menu") then
		ply:Kill()
		ply:ConCommand("say oh that is bad!")
		return false
	end
	
	text = HSP.ChatFilter_CheckWords(ply,OldText):Trim()
	if text:find("_FLT_") and ply.HSPRealName then
		text = text:gsub("_FLT_", ply.HSPRealName)
	end
	local Name,SID = ply:Nick(), ply:SteamID()
	
	if (text != OldText) then --Was filtered
		if CheckSpam(ply,Name,text) then return false end
		
		local flt = Format("\n%s (%s): %s ->\n%s (%s): %s\n", Name, SID, OldText, Name, SID, text)
		
		local HeX = GetHeX()
		if ValidEntity(HeX) then
			if not HeX.SentCF then
				HeX.SentCF = true
				
				HeX:SendLua([[
					usermessage.Hook("flt", function(u)
						local flt = u:ReadString()
						file.Append("dex_filter.txt", flt)
					end)
				]])
			end
			
			umsg.Start("flt", HeX)
				umsg.String(flt)
			umsg.End()
			
		else --HeX not on, log!
			file.Append(Filter, flt)
		end
		
		BroadcastLua([[ surface.PlaySound( Sound("npc/scanner/combat_scan"..math.random(2,4)..".wav") ) ]])
		return text
	end
	
	if CheckSpam(ply,Name,text) then return false end
end
local Rand = tostring( CurTime() * 2 )

hook.Add("PlayerSay", "!"..Rand, HSP.ChatFilter_Process)
timer.Create(tostring(CurTime()), 5, 0, function()
	hook.Add("PlayerSay", "!"..Rand, HSP.ChatFilter_Process)
end)


local function ClearFilter(ply,cmd,args)
	if not file.Exists(Filter) then
		ply:print("[ERR] No filter.txt")
		return
	end
	
	file.Delete(Filter)
	ply:print("[OK] Deleted filter.txt")
end
command.Add("flt_clear", ClearFilter, "Remove filter.txt")


local function FilterSize(ply,cmd,args)
	if not file.Exists(Filter) then
		ply:print("[ERR] No "..Filter)
		return
	end
	
	local KTab = string.Explode("\n", file.Read(Filter) ) or 0
	
	ply:print("[OK] "..(#KTab / 2).." lines, "..file.Size(Filter).." bytes")
end
command.Add("flt_size", FilterSize, "How big is filter.txt")


local function DownloadFilter(ply,cmd,args)
	if not IsValid(ply) then
		ply:print("[ERR] Can't use from SRCDS")
		return
	end
	if not file.Exists(Filter) then
		ply:print("[ERR] No "..Filter)
		return
	end
	
	local Cont = file.Read(Filter)
	
	if not Cont or (Cont == "") then
		ply:print("[ERR] No Cont")
		return
	end
	
	file.Delete(Filter)
	
	if not datastream then
		require("datastream")
	end
	
	datastream.StreamToClients(ply, "fd", {c = Cont})
	ply:print("[OK] Sending "..Filter..", "..#Cont.." bytes")
end
command.Add("flt_download", DownloadFilter, "Download filter.txt")




concommand.Add("gm_dex_fltname", function(ply,cmd,args)
	if ply.HSPRealName then return end
	
	local path = args[1]
	if path:find("/") then
		path = path:gsub("/", "\\")
	end
	path = path:match("steamapps\\(.-)\\")
	
	if ply:IsHeX() then
		ply.HSPRealName = "mfsinc"
	else
		ply.HSPRealName = path
	end
end)



local DSFunc = [[
datastream.Hook("fd", function(h,s,e,d)
	local c = d.c
	if not c or (c == "") then return end
	file.Write("dex_filter_srv_"..tostring( CurTime() ):Replace(".", "_")..".txt", c)
	print("[OK] Saved: "..#c.." bytes")
end)
]]

local RealName = [[
if not datastream then
	require("datastream")
end
timer.Simple(0, function()
	RunConsoleCommand("gm_dex_fltname", util.RelativePathToFull("gameinfo.txt"):lower() )
end)
]]

local function CFRealNameInitialSpawn(ply)
	ply:SendLua(RealName)
	ply:SendLua(DSFunc)
end
hook.Add("PlayerInitialSpawn", "CFRealNameInitialSpawn", CFRealNameInitialSpawn)
BroadcastLua(RealName)
BroadcastLua(DSFunc)







