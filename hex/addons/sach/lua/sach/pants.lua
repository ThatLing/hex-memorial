
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Shot with their pants down"
local Desc		= "Get killed while typing!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/kill_enemy_reloading"

local ACHName2	= "Potty break"
local Desc2		= "Kill somone who's typing"
local IcoYes2	= "VGUI/achievements/snipe_two_from_same_spot"


if SERVER then
	function SACH.ACH_Pants(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded and (vic != attacker) then
			if vic:IsTyping() then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Pants", SACH.ACH_Pants)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)






----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Shot with their pants down"
local Desc		= "Get killed while typing!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "VGUI/achievements/kill_enemy_reloading"

local ACHName2	= "Potty break"
local Desc2		= "Kill somone who's typing"
local IcoYes2	= "VGUI/achievements/snipe_two_from_same_spot"


if SERVER then
	function SACH.ACH_Pants(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded and (vic != attacker) then
			if vic:IsTyping() then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Pants", SACH.ACH_Pants)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)





