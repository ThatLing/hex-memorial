-- SaitoHUD
-- Copyright (c) 2009-2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$

local useSteamFriends = CreateClientConVar("friends_use_steam", "1", true, false)
local friendColor = CreateClientConVar("friend_color", "255,255,0", true, false)

local friendIDs = {}
local lastFriendColor = ""
local friendColorObj = Color(255, 255, 0)

--- Load the list of friends from disk.
function SaitoHUD.LoadFriends()
    friendIDs = {}
    
    local data = SaitoHUD.LoadCSV("saitohud/friends.txt", {"Nickname", "SteamID"})
    
    for _, v in pairs(data) do
        local id = "STEAM_" .. v[2]:gsub("(STEAM_)", ""):upper():Trim()
        friendIDs[id] = {
            Nickname = v[1],
            Color = Color(tonumber(v[3]), tonumber(v[4]), tonumber(v[5]), 255),
        }
    end
end

--- Write the list of friends to disk.
function SaitoHUD.WriteFriends()
    local data = {{"Nickname", "SteamID", "R", "G", "B"}}
    
    for steamID, info in pairs(friendIDs) do
        table.insert(data, {info.Nickname, steamID, info.Color.r, info.Color.g, info.Color.b})
    end
    
    return file.Write("saitohud/friends.txt", SaitoHUD.WriteCSV(data), "DATA")
end

--- Add a friend to the friends list.
-- @param ply Player or Steam ID
-- @param nickname Nickname
-- @param color Color
function SaitoHUD.AddFriend(ply, nickname, color)
    if type(ply) == "Player" then
        ply = ply:SteamID()
    end
    
    color.a = 255
    
    friendIDs[ply] = {
        Nickname = nickname,
        Color = color,
    }
end

--- Remove a friend from the friends list.
-- @param ply Player or Steam ID
function SaitoHUD.RemoveFriend(ply)
    if type(ply) == "Player" then
        ply = ply:SteamID()
    end
    
    friendIDs[ply] = nil
end

--- Returns whether a user is a friend. This may return true if the player is
-- a steam friend, depending on the user's settings.
-- @param ply Player
-- @return Boolean
function SaitoHUD.IsFriend(ply)
    if friendIDs[ply:SteamID()] then return true end
    return useSteamFriends:GetBool() and ply:GetFriendStatus() == "friend"
end

--- Used to get the generic friend color for Steam friends.
-- @return Color
local function GetGenericFriendColor()
    if lastFriendColor ~= friendColor:GetString() then
        local c = string.Explode(",", friendColor:GetString())
        friendColorObj = Color(tonumber(c[1]) or 0, tonumber(c[2]) or 0, tonumber(c[3]) or 0)
        lastFriendColor = friendColor:GetString()
    end
    
    return friendColorObj
end

--- Get a friend's color. May return generic color for Steam friends.
-- @param ply Player
-- @return Color
function SaitoHUD.GetFriendColor(ply)
    if friendIDs[ply:SteamID()] then return friendIDs[ply:SteamID()].Color end
    return GetGenericFriendColor()
end

SaitoHUD.LoadFriends()