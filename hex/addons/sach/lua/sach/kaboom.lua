
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Where's the kaboom?"
local Desc		= "Taste the explosion!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"


if SERVER then
	function SACH.ACH_Kaboom(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then		
			if (attacker:GetClass() == "env_explosion") or (inf:GetClass() == "env_explosion") then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Kaboom", SACH.ACH_Kaboom)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)










----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Where's the kaboom?"
local Desc		= "Taste the explosion!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"


if SERVER then
	function SACH.ACH_Kaboom(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then		
			if (attacker:GetClass() == "env_explosion") or (inf:GetClass() == "env_explosion") then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Kaboom", SACH.ACH_Kaboom)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)









