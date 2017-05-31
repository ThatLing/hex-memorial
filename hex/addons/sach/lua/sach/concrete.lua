
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Taste of Concrete"
local Desc		= "Splatter yourself"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/d3_c17_06a.png"


if SERVER then
	function SACH.ACH_Concrete(vic,attacker,info)
		if info:IsFallDamage() and IsValid(vic) and (attacker:GetClass() != "trigger_hurt") and SACH.ServerLoaded then		
			local prog, got = SACH.Get(vic, ACHName)
			
			SACH.Update(vic, ACHName, prog + 1)
		end
	end
	hook.Add("DoPlayerDeath", "SACH.ACH_Concrete", SACH.ACH_Concrete)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Taste of Concrete"
local Desc		= "Splatter yourself"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/d3_c17_06a.png"


if SERVER then
	function SACH.ACH_Concrete(vic,attacker,info)
		if info:IsFallDamage() and IsValid(vic) and (attacker:GetClass() != "trigger_hurt") and SACH.ServerLoaded then		
			local prog, got = SACH.Get(vic, ACHName)
			
			SACH.Update(vic, ACHName, prog + 1)
		end
	end
	hook.Add("DoPlayerDeath", "SACH.ACH_Concrete", SACH.ACH_Concrete)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




