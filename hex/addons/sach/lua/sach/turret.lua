
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Uh oh, turrets"
local Desc		= "Get killed by an NPC turret"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_turret_floor.png"

local ACHName2	= "Shouldn't ASK again"
local Desc2		= "Fail to keep your turrets away from the spawnpoint"
local AmtAmt2	= "0/2"
local Amt2		= 2

if SERVER then
	function SACH.ACH_UhOhTurret(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) then
			if attacker:GetClass():find("npc_turret") then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_UhOhTurret", SACH.ACH_UhOhTurret)
	
	function SACH.ACH_ASKTurret(Owner)
		if not IsValid(Owner) then return end
		local prog, got = SACH.Get(Owner, ACHName2)
		SACH.Update(Owner, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)
















----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Uh oh, turrets"
local Desc		= "Get killed by an NPC turret"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_turret_floor.png"

local ACHName2	= "Shouldn't ASK again"
local Desc2		= "Fail to keep your turrets away from the spawnpoint"
local AmtAmt2	= "0/2"
local Amt2		= 2

if SERVER then
	function SACH.ACH_UhOhTurret(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) then
			if attacker:GetClass():find("npc_turret") then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_UhOhTurret", SACH.ACH_UhOhTurret)
	
	function SACH.ACH_ASKTurret(Owner)
		if not IsValid(Owner) then return end
		local prog, got = SACH.Get(Owner, ACHName2)
		SACH.Update(Owner, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)















