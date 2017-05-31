
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Own Goal"
local Desc		= "Take your own life!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/COLLECT_GIFTS"

local ACHName2	= "Code 187"
local Desc2		= "Murder, Death, Kill"
local IcoYes2	= "VGUI/achievements/avenge_friend"


if SERVER then
	function SACH.ACH_OwnGoal(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic == attacker) then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			else
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_OwnGoal", SACH.ACH_OwnGoal)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)






----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Own Goal"
local Desc		= "Take your own life!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/COLLECT_GIFTS"

local ACHName2	= "Code 187"
local Desc2		= "Murder, Death, Kill"
local IcoYes2	= "VGUI/achievements/avenge_friend"


if SERVER then
	function SACH.ACH_OwnGoal(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic == attacker) then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			else
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_OwnGoal", SACH.ACH_OwnGoal)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)





