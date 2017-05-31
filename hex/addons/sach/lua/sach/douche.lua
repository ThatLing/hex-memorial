
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Royal Douche"
local Desc		= "Kill someone on their first spawn"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/monster_barney.png"


if SERVER then
	local function IsStone(ent)
		return ent:GetClass():lower() == "gravestone"
	end
	
	function SACH.ACH_Douche(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if not vic.SACHSpawned and not (IsStone(inf) or IsStone(attacker)) then
				vic.SACHSpawned = true
				
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Douche", SACH.ACH_Douche)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Royal Douche"
local Desc		= "Kill someone on their first spawn"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/monster_barney.png"


if SERVER then
	local function IsStone(ent)
		return ent:GetClass():lower() == "gravestone"
	end
	
	function SACH.ACH_Douche(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if not vic.SACHSpawned and not (IsStone(inf) or IsStone(attacker)) then
				vic.SACHSpawned = true
				
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Douche", SACH.ACH_Douche)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




