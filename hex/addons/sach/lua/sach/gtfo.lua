
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "GTFO"
local Desc		= "Get killed by a map trigger"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/gm_flatgrass.png"

local ACHName2	= "Oh god"
local Desc2		= "Get killed by 100 map triggers"
local AmtAmt2	= "0/100"
local Amt2		= 100


if SERVER then
	function SACH.ACH_GTFO(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (attacker:GetClass() == "trigger_hurt") then
			local prog, got = SACH.Get(vic, ACHName)
			SACH.Update(vic, ACHName, prog + 1)
			
			local prog, got = SACH.Get(vic, ACHName2)
			SACH.Update(vic, ACHName2, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_GTFO", SACH.ACH_GTFO)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "GTFO"
local Desc		= "Get killed by a map trigger"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/gm_flatgrass.png"

local ACHName2	= "Oh god"
local Desc2		= "Get killed by 100 map triggers"
local AmtAmt2	= "0/100"
local Amt2		= 100


if SERVER then
	function SACH.ACH_GTFO(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (attacker:GetClass() == "trigger_hurt") then
			local prog, got = SACH.Get(vic, ACHName)
			SACH.Update(vic, ACHName, prog + 1)
			
			local prog, got = SACH.Get(vic, ACHName2)
			SACH.Update(vic, ACHName2, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_GTFO", SACH.ACH_GTFO)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)




