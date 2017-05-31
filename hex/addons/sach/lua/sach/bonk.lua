
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bonk"
local Desc		= "Get squashed by a gravestone"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/gravestone_killicon"


if SERVER then
	local Stone = "gravestone"
	
	function SACH.ACH_Bonk(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) and SACH.ServerLoaded then
			if (attacker:GetClass():lower() == Stone) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bonk", SACH.ACH_Bonk)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bonk"
local Desc		= "Get squashed by a gravestone"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/gravestone_killicon"


if SERVER then
	local Stone = "gravestone"
	
	function SACH.ACH_Bonk(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) and SACH.ServerLoaded then
			if (attacker:GetClass():lower() == Stone) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bonk", SACH.ACH_Bonk)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




