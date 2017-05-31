
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Saviour"
local Desc		= "Kill a suicide bomber before they explode"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/ct_victories_bomb-failed"


if SERVER then
	function SACH.ACH_SuicideSave(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if (vic.SACHSuicideWindow) then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_SuicideSave", SACH.ACH_SuicideSave)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Saviour"
local Desc		= "Kill a suicide bomber before they explode"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/ct_victories_bomb-failed"


if SERVER then
	function SACH.ACH_SuicideSave(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then		
			if (vic.SACHSuicideWindow) then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_SuicideSave", SACH.ACH_SuicideSave)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




