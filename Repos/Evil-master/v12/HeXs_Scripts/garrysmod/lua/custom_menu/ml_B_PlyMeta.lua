player = {}

function player.GetAll()
	local AllPlayers = {}
	for k,v in ipairs( client.GetAllPlayers() ) do
		table.insert( AllPlayers, Player( client.GetPlayerIndex( v ) ) )
	end
	return AllPlayers
end

function player.GetHumans()
	local AllHumans = {}
	for k,v in ipairs( client.GetAllPlayers() ) do
		if !client.IsFakePlayer( v ) then
			table.insert( AllHumans, Player( client.GetPlayerIndex( v ) ) )
		end
	end
	return AllHumans
end

function player.GetBots()
	local AllBots = {}
	for k,v in ipairs( client.GetAllPlayers() ) do
		if client.IsFakePlayer( v ) then
			table.insert( AllBots, Player( client.GetPlayerIndex( v ) ) )
		end
	end
	return AllBots
end

function player.GetByUserID( uid )
	for k,v in ipairs( client.GetAllPlayers() ) do
		if v == uid then
			return Player( client.GetPlayerIndex( uid ) )
		end
	end
	return nil
end

function player.GetByEntIndex( entindex )
	for k,v in ipairs( client.GetAllPlayers() ) do
		if client.GetPlayerIndex( v ) == entindex then
			return Player( entindex )
		end
	end
	return nil
end

function player.GetEntIndexFromUserID( uid )
	return client.GetPlayerIndex( uid )
end

function player.GetUserIDFromEntIndex( entindex )
	for k,v in ipairs( client.GetAllPlayers() ) do
		if client.GetPlayerIndex( v ) == entindex then
			return v
		end
	end
	return nil
end

function LocalPlayer()
	return player.GetByUserID( client.LocalPlayerUserID() ) or nil
end

Player = {}
Player.__index = Player
if !_R.Player then
	_R.Player = Player -- Allows FindMetaTable to work :O
end

setmetatable( Player, {
    __call = function( self, entindex )
        return setmetatable( { userid = player.GetUserIDFromEntIndex( entindex ), entindex = entindex }, Player )
    end
} )

function Player:__tostring()
    return "Player [" .. self:EntIndex() .. "][" .. self:GetName() .. "]"
end

function Player:__eq( ply )
	return self.userid == ply.userid
end

function Player:IsValid()
	for k,v in ipairs( player.GetAll() ) do
		if self == v then
			return true
		end
	end
	return false
end

function Player:IsPlayer()
	return true
end

function Player:IsNPC()
	return false
end

function Player:UserID()
	return self.userid
end

function Player:EntIndex()
	return self.entindex
end

function Player:Alive()
	return client.IsPlayerAlive( self.entindex )
end

--[[function Player:Ping()
	return client.GetPlayerPing( self.entindex )
end

function Player:Frags()
	return client.GetPlayerFrags( self.entindex )
end

function Player:Deaths()
	return client.GetPlayerDeaths( self.entindex )
end
]]

function Player:IsMuted()
	return client.IsPlayerMuted( self.entindex )
end

--[[
function Player:Team()
	return client.GetPlayerTeam( self.entindex )
end
]]

function Player:Health()
	return client.GetPlayerHealth( self.entindex )
end

function Player:SetMuted( mute )
	return client.SetPlayerMuted( self.entindex, mute )
end

function Player:IsBot()
	return client.IsFakePlayer( self.userid )
end

function Player:GetSprayMaterialPath()
	return client.GetPlayerLogo( self.userid )
end

function Player:GetName()
	return client.GetPlayerName( self.userid )
end

function Player:Nick()
	return self:GetName()
end

function Player:Name()
	return self:GetName()
end

function Player:GetClass()
	return "player"
end

function Player:SteamID()
	local SteamID = client.GetPlayerSteamID( self.userid )
	if self:IsBot() then
		return "BOT"
	elseif SteamID == "STEAM_0:0:0" then -- The client doesn't actually know it yet, so we return the pending id
		return "STEAM_ID_PENDING"
	else
		return SteamID
	end
end

function Player:CommunityID()
	local FriendID = client.GetFriendID( self.userid ) -- The players friend ID number
	local AuthNum = FriendID / 2 % 2 == 1 and 1 or 0 -- The auth server they use
	return string.format( "765%0.f", FriendID + 61197960265728 + AuthNum )
end

function Player:FriendID()
	return client.GetFriendID( self.userid )
end

Player.__type = "Entity"

local oldtype = type

function type( ob )
    local meta = getmetatable( ob )
    if oldtype( meta ) == "table" then
        local __type = rawget( meta, "__type" )
        if !__type then
            return oldtype( ob )
        elseif __type == "function" then
            return __type( ob )
        else
            return __type
        end
    else
		return oldtype( ob )
	end
end