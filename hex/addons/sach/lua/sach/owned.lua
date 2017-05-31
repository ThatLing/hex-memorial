
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "St0wned"
local Desc		= "Get killed by your own gravestone"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/gravestone_killicon"


if SERVER then
	local Stone = "gravestone"
	
	function SACH.ACH_Owned(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and (vic == attacker) and (not inf:IsPlayer()) and SACH.ServerLoaded then
			if (inf:GetClass():lower() == Stone) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Owned", SACH.ACH_Owned)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "St0wned"
local Desc		= "Get killed by your own gravestone"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/gravestone_killicon"


if SERVER then
	local Stone = "gravestone"
	
	function SACH.ACH_Owned(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and (vic == attacker) and (not inf:IsPlayer()) and SACH.ServerLoaded then
			if (inf:GetClass():lower() == Stone) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Owned", SACH.ACH_Owned)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




