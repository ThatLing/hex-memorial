
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sir Killalot"
local Desc		= "Make 5000 total kills"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "hud/t_victories_terrorist-win"


if SERVER then
	function SACH.ACH_Killalot(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(attacker, ACHName)
			
			SACH.Update(attacker, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Killalot", SACH.ACH_Killalot)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sir Killalot"
local Desc		= "Make 5000 total kills"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "hud/t_victories_terrorist-win"


if SERVER then
	function SACH.ACH_Killalot(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(attacker, ACHName)
			
			SACH.Update(attacker, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Killalot", SACH.ACH_Killalot)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




