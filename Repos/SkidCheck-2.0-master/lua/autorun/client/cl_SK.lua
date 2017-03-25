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


//Message
function Skid.Msg()
	//Sound
	if net.ReadBit() == 0 then
		timer.Simple(1.8, function()
			surface.PlaySound("vo/npc/male01/herecomehacks0"..math.random(1,2)..".wav")
		end)
		return
	end
	
	
	//Message
	local self	 = net.ReadEntity()
	local Reason = net.ReadString()
	
	chat.AddText(
		Skid.GREY, "[",
		Skid.WHITE, "Skid",
		Skid.BLUE, "Check",
		Skid.GREY, "] ",
		(self.Team and team.GetColor( self:Team() ) or Skid.RED), self:Nick(),
		Skid.GREY, " (",
		Skid.GREEN, self:SteamID(),
		Skid.GREY, ")",
		Skid.GREY, " <",
		Skid.RED, Reason,
		Skid.GREY, "> ",
		Skid.GREY, "has been ",
		Skid.PINK, "NAUGHTY"
	)
	
	//Sound
	surface.PlaySound("ambient/machines/thumper_shutdown1.wav")
	
	//Log
	if self == LocalPlayer() then return end
	local Log = Format(
		"\r\n[%s]: %s - %s (%s) - %s",
		os.date("%d.%m.%y %I:%M:%S%p"), GetHostName(), self:Nick(), self:SteamID(), Reason
	)
	file.Append("cl_sk_encounters.txt", Log)
end
net.Receive("Skid.Msg", Skid.Msg)


//Console message
timer.Simple(1, function()
	MsgC(Skid.GREY, 	"\n[")
	MsgC(Skid.WHITE2, 	"Skid")
	MsgC(Skid.BLUE, 	"Check")
	MsgC(Skid.GREY, 	"] ")
	MsgC(Skid.GREEN, 	"Ready :)\n")
end)

















