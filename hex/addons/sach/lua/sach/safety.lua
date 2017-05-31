
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Safety Guide"
local Desc		= "Get killed while on a ladder"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/leaderboard_dead"


if SERVER then
	function SACH.ACH_Safety(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (vic:GetMoveType() == MOVETYPE_LADDER) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Safety", SACH.ACH_Safety)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Safety Guide"
local Desc		= "Get killed while on a ladder"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/leaderboard_dead"


if SERVER then
	function SACH.ACH_Safety(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (vic:GetMoveType() == MOVETYPE_LADDER) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Safety", SACH.ACH_Safety)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




