
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


local pEntity 	= FindMetaTable("Entity")
local pMeta 	= FindMetaTable("Player")

FSA.PBLUE	= Color(155,205,248)	--printall blue
FSA.GREY	= Color(175,175,175)	--blackops grey

--Color(51,50,153) Incompetent
FSA.Ranks = {
	[1] 	= {Name = "Owner", 				Color = Color(51,153,255), 	IsSuperAdmin = true },
	[2] 	= {Name = "Administrator", 		Color = Color(255,50,50),	IsSuperAdmin = true	},
	[3] 	= {Name = "Moderator", 			Color = Color(0,255,0),		IsAdmin = true		},
	[4] 	= {Name = "Respected", 			Color = Color(255,153,0) 	},
	[5] 	= {Name = "New", 				Color = Color(255,255,100) 	},
	[6] 	= {Name = "Donator", 			Color = Color(29,106,132) 	},
	[7] 	= {Name = "Cheater", 			Color = Color(255,0,153) 	},
	[8] 	= {Name = "Arse", 				Color = Color(81,0,66)		},
	[9] 	= {Name = "Regular", 			Color = Color(255,211,129) 	},
	[10] 	= {Name = "Previous Cheater", 	Color = Color(249,199,255) 	},
	[11] 	= {Name = "Incompetent", 		Color = Color(180,100,67) 	},
	[12] 	= {Name = "VIP", 				Color = Color(129,108,255) 	},
	[13] 	= {Name = "Gold Member", 		Color = Color(199,163,23) 	},
	[14] 	= {Name = "Idiot", 				Color = Color(135,75,50) 	},
	[15] 	= {Name = "Princess", 			Color = Color(255,102,255) 	},
	[16] 	= {Name = "Cool Dude", 			Color = Color(162,210,164) 	},
	[17] 	= {Name = "Horse Manure", 		Color = Color(135,75,0)		},
	[18] 	= {Name = "Ex", 				Color = Color(104,50,101)	},
	[19] 	= {Name = "A Better Rank", 		Color = Color(194,199,116)	},
	[20]	= {Name = "DuckAutoCucumber", 	Color = Color(255,211,201) 	},
	[21]	= {Name = "Russian", 			Color = Color(153,165,51) 	},
	[22]	= {Name = "12 Year Old", 		Color = Color(102,0,255) 	},
	[23]	= {Name = "Turd Burglar", 		Color = Color(153,102,0) 	},
	[24]	= {Name = "Dipshit", 			Color = Color(153,102,0) 	},
	[25]	= {Name = "Stupid", 			Color = Color(105,0,51) 	},
	[26]	= {Name = "Sausage", 			Color = Color(255,204,180) 	},
	[27]	= {Name = "Target", 			Color = Color(255,0,102) 	},
	[28]	= {Name = "Buttocks", 			Color = Color(153,102,20) 	},
	[29] 	= {Name = "Known Cheater", 		Color = Color(249,199,255) 	},
	[30] 	= {Name = "Developer", 			Color = Color(136,69,69) 	},
	[31] 	= {Name = "Melon", 				Color = Color(60,149,71) 	},
	[32]	= {Name = "Can't Spell!", 		Color = Color(255,211,201) 	},
	[33]	= {Name = "Balls of Steel", 	Color = Color(15,21,63) 	},
	[34]	= {Name = "Baby Russian!",		Color = Color(207,165,51) 	},
	[35]	= {Name = "VAC BANNED",			Color = Color(249,199,255) 	},
	[36]	= {Name = "Troll", 				Color = Color(153,102,50) 	},
}


for k,v in pairs(FSA.Ranks) do
	local Name = v.Name
	
	_G["RANK_"..Name:gsub(" ", "_"):gsub("'", ""):gsub("!", ""):upper() ] = k 	--RANK_OWNER, RANK_IDIOT etc
	_G["RANK_"..tostring(k) ] = k 												--Backup, RANK_1, RANK_14
	
	team.SetUp(k, Name, v.Color)
end


function pMeta:GetLevel(opt)
	local rID = self:Team()
	
	if opt then
		return FSA.Ranks[ rID ], rID
	end
	
	local Rank 	= team.GetName(rID)
	local rCol 	= team.GetColor(rID)
	
	return rID,Rank,rCol
end

function pMeta:IsUserGroup(str)
	return self:GetNetworkedString("FSAGroup") == str
end


function FSA.PrintRanks(ply,cmd,args,str)
	print("\n")
	
	for k,v in pairs( player.GetAll() ) do
		local rTab,rID = v:GetLevel(true)
		if not rTab then continue end
		
		local Name 	= rTab.Name
		local Col	= rTab.Color
		
		local str = Format("%s\t\t\t%s - %s\t", Name,rID, v:Nick() )
		
		print(str)
	end	
end
if SERVER then
	concommand.Add("ranks", FSA.PrintRanks)
end




local function IsAdmin(ply)
	return (!ply:IsValid())
end
local function SRCDS(ply)
	if (!ply:IsValid()) then
		return "SRCDS"
	end
end

pEntity.IsSuperAdmin	= IsAdmin
pEntity.IsAdmin			= IsAdmin

pEntity.SteamID			= SRCDS
pEntity.IPAddress		= SRCDS
pEntity.Nick			= SRCDS
pEntity.Name			= SRCDS

function pEntity:PrintMessage(LOC,MSG)
	if (LOC == HUD_PRINTCONSOLE || LOC == HUD_PRINTNOTIFY) then
		Msg(MSG)
	end
end


function util.Color(col,no_a)
	return col.r, col.g, col.b, no_a and (col.a or 255)
end





function FSA.SetPlugin(PLUGIN)
	table.insert(FSA.Plugins, PLUGIN)
	
	if SERVER then
		Msg("[FSA][SV] Loaded Core Plugin "..PLUGIN.Name.."\n")
	elseif CLIENT then
		Msg("[FSA][CL] Loaded Core Plugin "..PLUGIN.Name.."\n")
	end
end

--Hacky, define func then load them
include("FSA/coreplugins.lua")


function FSA.LoadPlugin(PLUGIN)
	if SERVER then
		if PLUGIN.Client then
			AddCSLuaFile("FSA/Plugins/"..PLUGIN.File)
		end
		if PLUGIN.Server then
			table.insert(FSA.Plugins, PLUGIN)
		end
	elseif CLIENT then
		table.insert(FSA.Plugins, PLUGIN)
	end
end


local Folder = file.Find("FSA/Plugins/*.lua", "LUA")
for k,v in ipairs(Folder) do
	include("FSA/Plugins/"..v)
end



























----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


local pEntity 	= FindMetaTable("Entity")
local pMeta 	= FindMetaTable("Player")

FSA.PBLUE	= Color(155,205,248)	--printall blue
FSA.GREY	= Color(175,175,175)	--blackops grey

--Color(51,50,153) Incompetent
FSA.Ranks = {
	[1] 	= {Name = "Owner", 				Color = Color(51,153,255), 	IsSuperAdmin = true },
	[2] 	= {Name = "Administrator", 		Color = Color(255,50,50),	IsSuperAdmin = true	},
	[3] 	= {Name = "Moderator", 			Color = Color(0,255,0),		IsAdmin = true		},
	[4] 	= {Name = "Respected", 			Color = Color(255,153,0) 	},
	[5] 	= {Name = "New", 				Color = Color(255,255,100) 	},
	[6] 	= {Name = "Donator", 			Color = Color(29,106,132) 	},
	[7] 	= {Name = "Cheater", 			Color = Color(255,0,153) 	},
	[8] 	= {Name = "Arse", 				Color = Color(81,0,66)		},
	[9] 	= {Name = "Regular", 			Color = Color(255,211,129) 	},
	[10] 	= {Name = "Previous Cheater", 	Color = Color(249,199,255) 	},
	[11] 	= {Name = "Incompetent", 		Color = Color(180,100,67) 	},
	[12] 	= {Name = "VIP", 				Color = Color(129,108,255) 	},
	[13] 	= {Name = "Gold Member", 		Color = Color(199,163,23) 	},
	[14] 	= {Name = "Idiot", 				Color = Color(135,75,50) 	},
	[15] 	= {Name = "Princess", 			Color = Color(255,102,255) 	},
	[16] 	= {Name = "Cool Dude", 			Color = Color(162,210,164) 	},
	[17] 	= {Name = "Horse Manure", 		Color = Color(135,75,0)		},
	[18] 	= {Name = "Ex", 				Color = Color(104,50,101)	},
	[19] 	= {Name = "A Better Rank", 		Color = Color(194,199,116)	},
	[20]	= {Name = "DuckAutoCucumber", 	Color = Color(255,211,201) 	},
	[21]	= {Name = "Russian", 			Color = Color(153,165,51) 	},
	[22]	= {Name = "12 Year Old", 		Color = Color(102,0,255) 	},
	[23]	= {Name = "Turd Burglar", 		Color = Color(153,102,0) 	},
	[24]	= {Name = "Dipshit", 			Color = Color(153,102,0) 	},
	[25]	= {Name = "Stupid", 			Color = Color(105,0,51) 	},
	[26]	= {Name = "Sausage", 			Color = Color(255,204,180) 	},
	[27]	= {Name = "Target", 			Color = Color(255,0,102) 	},
	[28]	= {Name = "Buttocks", 			Color = Color(153,102,20) 	},
	[29] 	= {Name = "Known Cheater", 		Color = Color(249,199,255) 	},
	[30] 	= {Name = "Developer", 			Color = Color(136,69,69) 	},
	[31] 	= {Name = "Melon", 				Color = Color(60,149,71) 	},
	[32]	= {Name = "Can't Spell!", 		Color = Color(255,211,201) 	},
	[33]	= {Name = "Balls of Steel", 	Color = Color(15,21,63) 	},
	[34]	= {Name = "Baby Russian!",		Color = Color(207,165,51) 	},
	[35]	= {Name = "VAC BANNED",			Color = Color(249,199,255) 	},
	[36]	= {Name = "Troll", 				Color = Color(153,102,50) 	},
}


for k,v in pairs(FSA.Ranks) do
	local Name = v.Name
	
	_G["RANK_"..Name:gsub(" ", "_"):gsub("'", ""):gsub("!", ""):upper() ] = k 	--RANK_OWNER, RANK_IDIOT etc
	_G["RANK_"..tostring(k) ] = k 												--Backup, RANK_1, RANK_14
	
	team.SetUp(k, Name, v.Color)
end


function pMeta:GetLevel(opt)
	local rID = self:Team()
	
	if opt then
		return FSA.Ranks[ rID ], rID
	end
	
	local Rank 	= team.GetName(rID)
	local rCol 	= team.GetColor(rID)
	
	return rID,Rank,rCol
end

function pMeta:IsUserGroup(str)
	return self:GetNetworkedString("FSAGroup") == str
end


function FSA.PrintRanks(ply,cmd,args,str)
	print("\n")
	
	for k,v in pairs( player.GetAll() ) do
		local rTab,rID = v:GetLevel(true)
		if not rTab then continue end
		
		local Name 	= rTab.Name
		local Col	= rTab.Color
		
		local str = Format("%s\t\t\t%s - %s\t", Name,rID, v:Nick() )
		
		print(str)
	end	
end
if SERVER then
	concommand.Add("ranks", FSA.PrintRanks)
end




local function IsAdmin(ply)
	return (!ply:IsValid())
end
local function SRCDS(ply)
	if (!ply:IsValid()) then
		return "SRCDS"
	end
end

pEntity.IsSuperAdmin	= IsAdmin
pEntity.IsAdmin			= IsAdmin

pEntity.SteamID			= SRCDS
pEntity.IPAddress		= SRCDS
pEntity.Nick			= SRCDS
pEntity.Name			= SRCDS

function pEntity:PrintMessage(LOC,MSG)
	if (LOC == HUD_PRINTCONSOLE || LOC == HUD_PRINTNOTIFY) then
		Msg(MSG)
	end
end


function util.Color(col,no_a)
	return col.r, col.g, col.b, no_a and (col.a or 255)
end





function FSA.SetPlugin(PLUGIN)
	table.insert(FSA.Plugins, PLUGIN)
	
	if SERVER then
		Msg("[FSA][SV] Loaded Core Plugin "..PLUGIN.Name.."\n")
	elseif CLIENT then
		Msg("[FSA][CL] Loaded Core Plugin "..PLUGIN.Name.."\n")
	end
end

--Hacky, define func then load them
include("FSA/coreplugins.lua")


function FSA.LoadPlugin(PLUGIN)
	if SERVER then
		if PLUGIN.Client then
			AddCSLuaFile("FSA/Plugins/"..PLUGIN.File)
		end
		if PLUGIN.Server then
			table.insert(FSA.Plugins, PLUGIN)
		end
	elseif CLIENT then
		table.insert(FSA.Plugins, PLUGIN)
	end
end


local Folder = file.Find("FSA/Plugins/*.lua", "LUA")
for k,v in ipairs(Folder) do
	include("FSA/Plugins/"..v)
end


























