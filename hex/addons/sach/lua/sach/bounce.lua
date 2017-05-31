
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "They bounce!"
local Desc		= "Make 1000 combine ball kills"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/item_ammo_ar2_altfire.png"


if SERVER then
	function SACH.ACH_Bounce(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if (inf:GetClass() == "prop_combine_ball") then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bounce", SACH.ACH_Bounce)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "They bounce!"
local Desc		= "Make 1000 combine ball kills"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/item_ammo_ar2_altfire.png"


if SERVER then
	function SACH.ACH_Bounce(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if (inf:GetClass() == "prop_combine_ball") then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bounce", SACH.ACH_Bounce)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




