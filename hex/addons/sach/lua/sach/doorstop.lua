
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Door Stop"
local Desc		= "Get killed by 10 doors"
local AmtAmt	= "0/10"
local Amt		= 10
local IcoYes	= "vgui/gfx/vgui/shield"


if SERVER then
	function SACH.ACH_Door(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) and SACH.ServerLoaded then
			if (attacker:GetClass():find("func_door")) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Door", SACH.ACH_Door)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Door Stop"
local Desc		= "Get killed by 10 doors"
local AmtAmt	= "0/10"
local Amt		= 10
local IcoYes	= "vgui/gfx/vgui/shield"


if SERVER then
	function SACH.ACH_Door(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (not attacker:IsPlayer()) and SACH.ServerLoaded then
			if (attacker:GetClass():find("func_door")) then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Door", SACH.ACH_Door)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




