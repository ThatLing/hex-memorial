
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Barrel Roll"
local Desc		= "Kill a player with an explosive barrel"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"

local ACHName2	= "Z or R twice"
local Desc2		= "Do a barrel roll!"

if SERVER then
	function SACH.ACH_Barrel(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic != attacker) and (inf:GetModel() == "models/props_c17/oildrum001_explosive.mdl") then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Barrel", SACH.ACH_Barrel)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Barrel Roll"
local Desc		= "Kill a player with an explosive barrel"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"

local ACHName2	= "Z or R twice"
local Desc2		= "Do a barrel roll!"

if SERVER then
	function SACH.ACH_Barrel(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic != attacker) and (inf:GetModel() == "models/props_c17/oildrum001_explosive.mdl") then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Barrel", SACH.ACH_Barrel)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)




