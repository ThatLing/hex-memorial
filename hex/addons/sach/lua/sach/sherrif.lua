
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Shoot the Sherrif"
local Desc		= "Kill an Administrator"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_deagle"

local ACHName2	= "Arm of the Law"
local Desc2		= "Get killed by the Administrator"

if SERVER then
	local function IsStone(ent)
		return ent:GetClass():lower() == "gravestone"
	end
	
	function SACH.ACH_Sherrif(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if not (IsStone(inf) or IsStone(attacker)) then
				if vic:IsAdmin() then
					local prog, got = SACH.Get(attacker, ACHName)
					SACH.Update(attacker, ACHName, prog + 1)
				end
				
				if attacker:IsAdmin() then
					local prog, got = SACH.Get(vic, ACHName2)
					SACH.Update(vic, ACHName2, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Sherrif", SACH.ACH_Sherrif)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)













----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Shoot the Sherrif"
local Desc		= "Kill an Administrator"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_deagle"

local ACHName2	= "Arm of the Law"
local Desc2		= "Get killed by the Administrator"

if SERVER then
	local function IsStone(ent)
		return ent:GetClass():lower() == "gravestone"
	end
	
	function SACH.ACH_Sherrif(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if not (IsStone(inf) or IsStone(attacker)) then
				if vic:IsAdmin() then
					local prog, got = SACH.Get(attacker, ACHName)
					SACH.Update(attacker, ACHName, prog + 1)
				end
				
				if attacker:IsAdmin() then
					local prog, got = SACH.Get(vic, ACHName2)
					SACH.Update(vic, ACHName2, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Sherrif", SACH.ACH_Sherrif)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)












