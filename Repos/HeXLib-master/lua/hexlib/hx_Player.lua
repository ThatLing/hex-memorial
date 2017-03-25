
local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")


//Respawn if dead
function Player:RespawnIfDead(same_pos)
	if self:Alive() then return end
	local Pos = self:GetPos()
	
	self:Spawn()
	if same_pos then
		self:SetPos(Pos)
	end
	
	return true
end




local GoodFolderBytes = {
	[32] = " ",
	[45] = "-",
	[46] = ".",
	[95] = "_",
}

local BadNameChars = {
	[".."] 	= "_",
	["."]	= " ",
	["  "] 	= "_",
	["__"] 	= "_",
	["_."] 	= "_",
	["._"] 	= "_",
	["(."] 	= "_",
	[".)"] 	= "_",
	["%"]	= "_",
	["("]	= "-",
	[")"]	= "-",
}

function Player:SafeDirName()
	if self:IsBot() then return "BOT" end
	
	if self.HX_CacheSafeDir then
		return self.HX_CacheSafeDir
	end
	
	
	//SID folder
	local Dir = self:SID():Split("_")
	if Dir then
		Dir = Dir[4]
		if not Dir or #Dir < 4 then
			Dir = SID
		end
	else
		Dir = SID
	end
	
	//Nick - VERY SAFE
	local Nick = self:Nick():VerySafe(GoodFolderBytes):Trim() --VERY SAFE
	for k,v in pairs(BadNameChars) do
		if Nick:hFind(k) then
			Nick = Nick:Replace(k,v)
		end
	end
	
	//Too short?
	if #Nick >= 3 then
		Dir = Dir.." ("..Nick:Left(25)..")"
	end
	
	self.HX_CacheSafeDir = Dir
	return Dir
end




function Entity:PrintMessage(where,msg)
	if (where == HUD_PRINTCONSOLE or where == HUD_PRINTNOTIFY) then
		Msg(msg)
	end
end
function Entity:print(str, like_msg) --Has to be on entity
	if not IsValid(self) or not self:IsPlayer() then
		if like_msg then
			Msg(str)
		else
			print(str)
		end
		return
	end
	
	str = str:Left(210)
	if not like_msg then
		str = str.."\n"
	end
	self:PrintMessage(HUD_PRINTCONSOLE, str)
end


//Distance
function Entity:Distance(ent)
	return math.Round( self:GetPos():Distance( ent:GetPos() ) )
end


function Entity:VarSet(This)
	if not self[ This ] then
		self[ This ] = true
		return false
	end
	return true
end

function Player:CanUseThis(name, when)
	if not self[ name ] then
		self[ name ] = true
		
		self:timer(when, function()
			self[ name ] = nil
		end)
		
		return true
	end
	return false
end



function Player:URL()
	return "http://steamcommunity.com/profiles/"..self:SteamID64()
end

function Player:Info(show_url)
	return self:Nick().." ("..self:SteamID()..")"..(show_url and " "..self:URL() or "")
end

function Player:TeamColor()
	return IsValid(self) and team.GetColor( self:Team() ) or color_white
end

function Player:SID()
	return self:SteamID():SID()
end



function Humans()
    return pairs( player.GetHumans() )
end
function Everyone()
    return pairs( player.GetAll() )
end
function Bots()
    return pairs( player.GetBots() )
end


























