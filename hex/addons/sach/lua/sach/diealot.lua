
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Fuck it"
local Desc		= "Die 5000 times"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "hud/t_victories_counter-terrorist-eliminated" --"vgui/achievements/win_rounds_high"


if SERVER then
	function SACH.ACH_Diealot(vic,inf,attacker)
		if IsValid(vic) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(vic, ACHName)
			
			SACH.Update(vic, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Diealot", SACH.ACH_Diealot)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Fuck it"
local Desc		= "Die 5000 times"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "hud/t_victories_counter-terrorist-eliminated" --"vgui/achievements/win_rounds_high"


if SERVER then
	function SACH.ACH_Diealot(vic,inf,attacker)
		if IsValid(vic) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(vic, ACHName)
			
			SACH.Update(vic, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Diealot", SACH.ACH_Diealot)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




