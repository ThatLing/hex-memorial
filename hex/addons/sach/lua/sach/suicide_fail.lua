
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Failure"
local Desc		= "Get killed before your suicide bomb explodes"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/ct_victories_counter-terrorists-win"


if SERVER then
	function SACH.ACH_SuicideFail(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (vic.SACHSuicideWindow) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_SuicideFail", SACH.ACH_SuicideFail)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Failure"
local Desc		= "Get killed before your suicide bomb explodes"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/ct_victories_counter-terrorists-win"


if SERVER then
	function SACH.ACH_SuicideFail(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (vic.SACHSuicideWindow) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_SuicideFail", SACH.ACH_SuicideFail)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




