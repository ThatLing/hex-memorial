//steamworks.lua

require("steamworks")

steamClient007 = steamworks.ISteamClient(7)
if (!steamClient007) then return end
hSteamPipe = steamClient007:CreateSteamPipe()
if (!hSteamPipe) then return end
hSteamUser = steamClient007:ConnectToGlobalUser(hSteamPipe)
if (!hSteamUser) then return end
steamUser012 = steamClient007:GetISteamUser(hSteamUser, hSteamPipe, 12)
if (!steamUser012) then return end
if (!steamUser012:LoggedOn()) then return end
steamFriends005 = steamClient007:GetISteamFriends(hSteamUser, hSteamPipe, 5)
if (!steamFriends005) then return end
steamFriends002 = steamClient007:GetISteamFriends(hSteamUser, hSteamPipe, 2)

if (!steamFriends002) then return end

hook.Add("Think", "Steam_BGetCallback", function()
callbackMsg = steamworks.Steam_BGetCallback(hSteamPipe)

if (!callbackMsg) then return end

if (callbackMsg:GetCallback() == (300 + 31)) then
local gameOverlay = callbackMsg:GetPubParam():To(FindMetaTable("GameOv erlayActivated_t").MetaID)

hook.Call("GameOverlayActivated", nil, gameOverlay:IsActive())
elseif (callbackMsg:GetCallback() == (300 + 4)) then
local personaChange = callbackMsg:GetPubParam():To(FindMetaTable("Person aStateChange_t").MetaID)

local personaSID = personaChange:GetSteamID()

if (personaSID) then
local personaCSID = steamworks.CSteamID()

personaCSID:Set(personaSID, 1, 1)

if (personaChange:GetFlags() == 0x001) then
hook.Call("EPersonaChangeName", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x002) then
hook.Call("EPersonaChangeStatus", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x004) then
hook.Call("EPersonaChangeComeOnline", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x008) then
hook.Call("EPersonaChangeGoneOffline", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x010) then
hook.Call("EPersonaChangeGamePlayed", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x020) then
hook.Call("EPersonaChangeGameServer", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x040) then
hook.Call("EPersonaChangeAvatar", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x080) then
hook.Call("EPersonaChangeJoinedSource", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x100) then
hook.Call("EPersonaChangeLeftSource", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x200) then
hook.Call("EPersonaChangeRelationshipChanged", nil, personaCSID)
elseif (personaChange:GetFlags() == 0x400) then
hook.Call("EPersonaChangeNameFirstSet", nil, personaCSID)
end
end
end

steamworks.Steam_FreeLastCallback(hSteamPipe)
end )
[/lua]

[lua]
include("steamworks.lua")

local EPersonaStateStrings = {
"Offline",
"Online",
"Busy",
"Away",
"Snooze",
}

hook.Add("GameOverlayActivated", "SHook", function(state)
if (state) then
print(string.format("[%s] Opened game overlay", os.date()))
else
print(string.format("[%s] Closed game overlay", os.date()))
end
end )

hook.Add("EPersonaChangeName", "SHook", function(id)
print(string.format("[%s] The owner of %s changed their name to '%s'", os.date(), id:Render(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeStatus", "SHook", function(id)
print(string.format("[%s] '%s' is now %s", os.date(), steamFriends005:GetFriendPersonaName(id), EPersonaStateStrings[steamFriends005:GetFriendPersonaState(id)+1]))
end )

hook.Add("EPersonaChangeComeOnline", "SHook", function(id)
print(string.format("[%s] '%s' signed in", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeGoneOffline", "SHook", function(id)
print(string.format("[%s] '%s' signed out", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeGamePlayed", "SHook", function(id)
local gamePlayed = steamFriends005:GetFriendGamePlayed(id)

if (gamePlayed) then
print(string.format("[%s] '%s' is now playing {AppID:%d}", os.date(), steamFriends005:GetFriendPersonaName(id), gamePlayed:GetCGameID():AppID()))
else
print(string.format("[%s] '%s' is no longer playing anything", os.date(), steamFriends005:GetFriendPersonaName(id)))
end
end )

hook.Add("EPersonaChangeGameServer", "SHook", function(id)
print(string.format("[%s] '%s' is now playing on %s:%d", os.date(), steamFriends005:GetFriendPersonaName(id), steamFriends005:GetFriendGamePlayed(id):GetGameIP( ), steamFriends005:GetFriendGamePlayed(id):GetGamePort()))
end )

hook.Add("EPersonaChangeAvatar", "SHook", function(id)
print(string.format("[%s] '%s' changed their avatar", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeJoinedSource", "SHook", function(id)
print(string.format("[%s] '%s' joined source", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeLeftSource", "SHook", function(id)
print(string.format("[%s] '%s' left source", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeRelationshipChanged", "SHook", function(id)
print(string.format("[%s] Your relationship with '%s' changed", os.date(), steamFriends005:GetFriendPersonaName(id)))
end )

hook.Add("EPersonaChangeNameFirstSet", "SHook", function(id)
print(string.format("[%s] The owner of %s has just set his/her name for the first time", os.date(), id:Render()))
end )
[/lua]

[lua]
include("steamworks.lua")

local friendFlag = 4

for i=0, steamFriends005:GetFriendCount(friendFlag)-1 do
local targetFriend = steamFriends005:GetFriendByIndex(i, friendFlag)

if (steamFriends005:GetFriendPersonaName(targetFriend ) == "Chris") then
steamFriends002:SendMsgToFriend(targetFriend, 1, "Hi Chris")
steamFriends002:SendMsgToFriend(targetFriend, 3, "")
end
end
[/lua]

[lua]
include("steamworks.lua")

local communityBase = 103582791429521408 --(103582791430000000 - 478592)

local function ClanCommunityIDToClanAccountID(communityID)
return communityID - communityBase
end

local function ClanAccountIDToClanCommunityID(accountID)
return accountID + communityBase
end

local communityID = 103582791430354656

local groupCSID = steamworks.CSteamID()
groupCSID:InstancedSet(ClanCommunityIDToClanAccoun tID(communityID), 0, 1, 7)

print(groupCSID)

