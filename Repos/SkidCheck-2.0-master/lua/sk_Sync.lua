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

--Update module idea & some code by GGG KILLER

//Run the list files here
Skid.Sync = {
	//List of files to download
	Index 			= {},
	
	//List version, changed when list structure is changed / merged
	VERSION			= "2.1",
	
	//Env
	HAC 			= {
		Skiddies	= {},
		SK_ListVer	= "0"
	},
	
	pairs			= pairs,
}



//Messages
local function MsgN(str, err)
	MsgC(Skid.GREY, 	"[")
	MsgC(Skid.WHITE2, 	"Skid")
	MsgC(Skid.BLUE, 	"Check")
	MsgC(Skid.PINK, 	"Sync")
	MsgC(Skid.GREY, 	"] ")
	if err then
		MsgC(Skid.RED,	"ERROR: ")
	end
	MsgC(Skid.ORANGE, 	str.."\n")
end

local function Error(str,Bad)
	MsgN(str, true)
	if Bad then
		MsgN("Please re-download this addon from https://github.com/MFSiNC/SkidCheck-2.0", true)
	end
end


//Selector
local selector = {}
selector.__index = selector

function selector:Select()
	local Idx  	= nil
	local This 	= nil
	for k,v in pairs(self.Tab) do
		Idx  = k
		This = v
		
		self._Upto = self._Upto + 1
		break
	end
	
	if Idx then
		self.Tab[ Idx ] = nil
		self.OnSelect(self, This)
	end
	
	if self._Upto == self._Size then
		self.Tab = nil
		self	 = nil
	end
end



//Download this list
function Skid.Sync.Download(self, v)
	MsgN("Downloading list "..self._Upto.."/"..self._Size)
	
	local Name = v.Name
	
	http.Fetch(v.URL, function(body)
		//body
		if not ( isstring(body) and #body > 9 ) then
			Error("HTTP Body error (Got "..tostring(body)..")")
			return
		end
		
		
		//Compile
		local List = CompileString(body, Name)
		if not List then
			Error("Can't compile "..Name)
			return
		end
		
		//Call
		setfenv(List, Skid.Sync)
		local ret,err = pcall(List)
		if err or not ret then
			Error("Can't load "..Name..": ["..tostring(err).."]\n")
			return
		end
		
		
		//Select next
		timer.Simple(0.2, function()
			//Next & Finish
			if self._Upto != self._Size then
				self:Select()
				return
			end
			
			
			//Version
			local vGit = tostring( Skid.Sync.HAC.Skiddies.VERSION ) --Remote
			local vLoc = tostring( Skid.HAC_DB.VERSION )			--Local
			if vGit != vLoc then
				Error("LIST FORMAT VERSION CHANGE, Can't sync lists! (doesn't happen often)")
				Error("(vGit: "..vGit.." != vLoc: "..vLoc..")", true)
				
				Skid.IsReady 			= false
				Skid.Sync.HAC.Skiddies 	= {}
				timer.Destroy("Skid.Sync.GetIndex")
				return
			end
			
			//Count
			local Git	= table.Count(Skid.Sync.HAC.Skiddies)
			local Old	= table.Count(Skid.HAC_DB)
			local Diff	= Git - Old
			local sDiff	= tostring(Diff):Comma()
			
			if Git < 100000 then
				Error("Got list size error! ("..tostring(Git):Comma()..", less than "..tostring(Old):Comma().." in local lists!)", true)
				return
			end
			
			//Override local lists
			Skid.HAC_DB 			= Skid.Sync.HAC.Skiddies
			Skid.Sync.HAC.Skiddies	= {}
			MsgN("Download complete, lists up to date."..(Diff > 0 and " "..sDiff.." new IDs :)" or "") )
			
			//Large additions, prompt re-download
			if Diff > 2000 then
				Error(":\n\nLocal lists differ by more than "..sDiff.." IDs!\n", true)
			end
			
			//Done
			Skid.CanSync = " Sync complete :)"
			Skid.Ready()
		end)
		
	end, function(err)
		Error("GitHub HTTP error: "..(err == "unsuccessful" and "http.Fetch not functioning, blame Garry" or err)..")")
	end)
end



//Download index
function Skid.Sync.GetIndex()
	if not Skid.IsReady then return end
	
	MsgN("Fetching index..")
	local Index = {}
	
	http.Fetch("https://api.github.com/repositories/22792657/contents/lua/skidcheck", function(body)
		//body
		if not ( isstring(body) and #body > 9 ) then
			Error("GetIndex HTTP error (Got "..tostring(body)..")")
			return
		end
		
		//JSON
		body = util.JSONToTable(body)
		if not ( istable(body) and #body >= 9 ) then
			Error("GetIndex JSON decode error (Got "..type(body)..")")
			return
		end
		
		
		//Files
		for k,v in pairs(body) do
			if not v.name or not v.name:StartWith("sv_SkidList") then continue end
			
			table.insert(Index,
				{
					URL		= v.download_url,
					Name 	= v.name,
				}
			)
		end
		//Sort
		table.sort(Index, function(k,v)
			return v.Name < k.Name
		end)
		
		//Make sure they're all there
		local Have	= #Skid.Lists
		local Git	= #Index
		if Git < Have then
			Error("List re-shuffle! large changes to lists @ GitHub (Git: "..Git..", Have: "..Have..")", true)
			return
		end
		
		//Start the download
		local This = setmetatable(
			{
				OnSelect	= Skid.Sync.Download,
				Tab			= Index,
				_Size		= #Index,
				_Upto		= 0,
			},
			selector
		)
		
		//Go!
		This:Select()
		
	end, function(err)
		Error("GitHub GetIndex error "..(err == "unsuccessful" and "http.Fetch not functioning, blame Garry" or err)..")")
	end)
end


//Slight delay, to wait for everything to become ready
timer.Simple(3, Skid.Sync.GetIndex)

//Update every
timer.Create("Skid.Sync.GetIndex", (Skid.sk_sync:GetInt() * 60 * 60), 0, Skid.Sync.GetIndex)

//Manual sync
function Skid.Sync.Command(self,cmd,args)
	if IsValid(self) and not self:IsAdmin() then return end
	if not Skid.IsReady then
		Error("Not ready, sk_update can't be used in server.cfg, please wait for the map to load!")
		return
	end
	
	Skid.Sync.GetIndex()
end
concommand.Add("sk_update", Skid.Sync.Command)












