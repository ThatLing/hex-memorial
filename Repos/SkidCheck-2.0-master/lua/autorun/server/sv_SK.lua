/*
    SkidCheck 2.0 - Keep bad players off your server.
    Copyright (C) 2015  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

Skid.WaitFor 	= 35 --Seconds to wait before message
Skid.sk_sync	= CreateConVar("sk_sync",	8, FCVAR_ARCHIVE, "Allow list sync from GitHub? value = hours to check for updates (0 to disable)")

Skid.sk_silent	= CreateConVar("sk_silent",	0, FCVAR_ARCHIVE, "Disable all SK messages? (WILL STILL KICK if sk_kick is 1)")
Skid.sk_kick 	= CreateConVar("sk_kick",	0, FCVAR_ARCHIVE, "Prevent players on the database from joining")
Skid.sk_admin	= CreateConVar("sk_admin",	0, FCVAR_ARCHIVE, "ONLY send SK messages to admins, no one else (Useless if sk_kick or sk_omit is 1)")
Skid.sk_omit 	= CreateConVar("sk_omit",	1, FCVAR_ARCHIVE, "Send SK message to everyone BUT the cheater (Useless if sk_kick or sk_admin is 1)")


AddCSLuaFile("autorun/sh_SK.lua")
AddCSLuaFile("autorun/client/cl_SK.lua")

util.AddNetworkString("Skid.Msg")



//Load lists, must load in reverse order! 9 > 1
Skid.Lists = file.Find("lua/skidcheck/sv_skidlist*.lua", "GAME", "namedesc")
HAC = { Skiddies = {} }	
	for k,v in pairs(Skid.Lists) do
		include("skidcheck/"..v)
	end
	
	Skid.HAC_DB = HAC.Skiddies
HAC = nil




local function GetAdmins()
	local Admins = {}
	for k,v in pairs( player.GetHumans() ) do
		if v:IsAdmin() then
			table.insert(Admins, v)
		end
	end
	return #Admins != 0 and Admins or false
end

//Check
function Skid.Check(server_only)
	//Get admins, used for sk_admin
	local Admins = GetAdmins()
	
	//Go!
	for k,v in pairs( player.GetHumans() ) do
		local SID		= v:SteamID()
		local Reason 	= Skid.HAC_DB[ SID ]
		if not Reason then continue end
		
		//Log
		file.Append("sk_encounters.txt", Format("\r\n[%s]: %s (%s) - %s", os.date("%d.%m.%y %I:%M:%S%p"), v:Nick(), SID, Reason) )
		
		//Tell server
		MsgC(Skid.GREY, "\n[")
		MsgC(Skid.WHITE2, "Skid")
		MsgC(Skid.BLUE, "Check")
		MsgC(Skid.GREY, "] ")
		MsgC(Skid.RED, v:Nick() )
		MsgC(Skid.GREY, " (")
		MsgC(Skid.GREEN, SID)
		MsgC(Skid.GREY, ")")
		MsgC(Skid.GREY, " <")
		MsgC(Skid.RED, Reason)
		MsgC(Skid.GREY, "> ")
		MsgC(Skid.GREY, "has been ")
		MsgC(Skid.ORANGE, "NAUGHTY\n\n")
		
		//Hook
		if hook.Run("OnSkid", v, Reason, (not server_only) ) then continue end
		if server_only then continue end
		
		
		//Tell
		local sk_admin = Skid.sk_admin:GetBool()
		if Skid.sk_silent:GetBool() or ( sk_admin and not Admins ) then
			continue --If silent, or sk_admin is 1 and no admins are online, DON'T SEND TO ANYONE
		end
		
		net.Start("Skid.Msg")
			net.WriteBit(true)
			net.WriteEntity(v)
			net.WriteString(Reason)
			
		if sk_admin then
			//Admins
			net.Send(Admins)
			
		elseif Skid.sk_omit:GetBool() then
			//Everyone BUT cheater
			net.SendOmit(v)
			
		else
			//Everyone
			net.Broadcast()
		end
	end
end

function Skid.Command(self,cmd,args)
	if IsValid(self) and not self:IsAdmin() then return end
	Skid.Check()
end
concommand.Add("sk", Skid.Command)

//Spawn
function Skid.Spawn(self)
	//Server
	Skid.Check(true)
	
	//Clients
	timer.Simple(Skid.WaitFor, function()
		Skid.Check()
	end)
end
hook.Add("PlayerInitialSpawn", "Skid.Spawn", Skid.Spawn)



//Auth check
function Skid.CheckPassword(SID64, ipaddr, sv_pass, pass, user)
	//Invalid
	local SID = util.SteamIDFrom64(SID64)
	if not SID or SID == "" then
		return false, "Invalid SteamID"
	end
	
	//Lookup
	local Reason = Skid.HAC_DB[ SID ]
	if not Reason then return end
	
	//Log
	file.Append("sk_connect.txt", Format("\r\n[%s]: %s (%s) - %s", os.date("%d.%m.%y %I:%M:%S%p"), user, SID, Reason) )
	
	//Message
	MsgC(Skid.GREY, "\n[")
	MsgC(Skid.WHITE2, "Skid")
	MsgC(Skid.BLUE, "Check")
	MsgC(Skid.ORANGE, "Connect")
	MsgC(Skid.GREY, "] ")
	MsgC(Skid.RED, user)
	MsgC(Skid.GREY, " (")
	MsgC(Skid.GREEN, SID)
	MsgC(Skid.GREY, ")")
	MsgC(Skid.GREY, " <")
	MsgC(Skid.RED, Reason)
	MsgC(Skid.GREY, ">\n")
	
	
	//Hook
	local Block,Res = hook.Run("BlockSkidConnect", user,SID, Reason)
	
	//Block if sk_kick or BlockSkidConnect true
	if Block or Skid.sk_kick:GetBool() then
		return false, Res or "You've popped it!\nYou're on the naughty list: "..SID.."\n\n<"..Reason..">"
		
	else
		//Sound, to admins. Will match up with the server's join message in the chat
		local Admins = GetAdmins()
		if Admins and not Skid.sk_silent:GetBool() then
			net.Start("Skid.Msg")
				net.WriteBit(false)
			net.Send(Admins)
		end
	end
end
hook.Add("CheckPassword", "Skid.CheckPassword", Skid.CheckPassword)


//IsOnSK, for easy checking in other addons etc
local Player = FindMetaTable("Player")
function Player:IsOnSK()
	return Skid.HAC_DB[ self:SteamID() ]
end



//List sync from GitHub
Skid.CanSync = ""
if Skid.sk_sync:GetBool() then
	Skid.CanSync = " (Will sync on 1st join)"
	
	include("sk_Sync.lua")
end

//Loaded
function Skid.Ready()
	//List load error?
	local Tot 	= table.Count(Skid.HAC_DB)
	local sTot 	= tostring(Tot):Comma()
	if Tot < 5000 then
		ErrorNoHalt("\n[SkidCheck] Error loading local lists, this should never happen! (Got "..sTot.."!)\n")
		ErrorNoHalt("\n[SkidCheck] Please re-download this addon from https://github.com/MFSiNC/SkidCheck-2.0\n")
		return
	end
	
	Skid.IsReady = true
	
	MsgC(Skid.GREY, 	"\n[")
	MsgC(Skid.WHITE2, 	"Skid")
	MsgC(Skid.BLUE, 	"Check")
	MsgC(Skid.GREY, 	"] ")
	MsgC(Skid.GREEN, 	"Ready, "..Skid.VERSION..". ")
	MsgC(Skid.RED,		 sTot)
	MsgC(Skid.GREEN, 	" IDs in memory!"..Skid.CanSync.."\n\n")
end
timer.Simple(1, Skid.Ready)





--[[
	Falco, it's up to server owners to choose who joins their server (and whether or not to run this addon)
	
	SkidCheck is the list of people who I don't want playing on my server. Not "malicious code".
	It was originally the HAC database, and was released here for anyone to use for any reason. Not to cause drama.
	
	I'm not going to bypass your disabling of SkidCheck in DarkRP, all that will now happen is the following messages.
]]
local Check = Skid.Check
timer.Simple(6, function()
	if Skid.Check == Check then return end
	ErrorNoHalt("\n[SkidCheck] Disabled due to DarkRP update. Please see console for details\n\n")
	
	MsgC(Skid.GREY, 	"\n\n  [")
	MsgC(Skid.WHITE2, 	"Skid")
	MsgC(Skid.BLUE, 	"Check")
	MsgC(Skid.GREY, 	"] ")
	MsgC(Skid.RED, 		"Disabled due to DarkRP update.\n\n")
	
	MsgC(Skid.BLUE, 	"  SkidCheck is now ")
	MsgC(Skid.PINK, 	"no longer protecting ")
	MsgC(Skid.BLUE, 	"this server.\n")
	
	MsgC(Skid.BLUE, 	"  Falco has chosen to disable SkidCheck in current versions of DarkRP.\n")
	MsgC(Skid.BLUE, 	"  Please delete this addon.\n\n")
	
	MsgC(Skid.BLUE, 	"  If you want to continue to use SkidCheck, ")
	MsgC(Skid.RED, 		"blame falco.\n\n")
end)













