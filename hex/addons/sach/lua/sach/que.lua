
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Long Que"
local Desc		= "Get killed while in the Q menu!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/kill_enemy_reloading"

local ACHName2	= "Line break"
local Desc2		= "Kill somone who's in the Q menu!"
local IcoYes2	= "VGUI/achievements/snipe_two_from_same_spot"


if SERVER then
	function SACH.ACH_Que(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded and (vic != attacker) then
			if vic.HSP_QMonitor then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Que", SACH.ACH_Que)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)











----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Long Que"
local Desc		= "Get killed while in the Q menu!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/kill_enemy_reloading"

local ACHName2	= "Line break"
local Desc2		= "Kill somone who's in the Q menu!"
local IcoYes2	= "VGUI/achievements/snipe_two_from_same_spot"


if SERVER then
	function SACH.ACH_Que(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded and (vic != attacker) then
			if vic.HSP_QMonitor then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Que", SACH.ACH_Que)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)










