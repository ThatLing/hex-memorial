
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Dead Man Stalking"
local Desc		= "Kill a player while at 1 health"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/kill_when_at_low_health"


if SERVER then
	function SACH.ACH_DeadMan(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if (attacker:Health() == 1) then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_DeadMan", SACH.ACH_DeadMan)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Dead Man Stalking"
local Desc		= "Kill a player while at 1 health"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/kill_when_at_low_health"


if SERVER then
	function SACH.ACH_DeadMan(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if (attacker:Health() == 1) then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_DeadMan", SACH.ACH_DeadMan)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




