
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Backstabber"
local Desc		= "Kill 10 people by backstabbing"
local AmtAmt	= "0/10"
local Amt		= 10
local IcoYes	= "vgui/achievements/kill_enemy_knife"

local ACHName2	= "Let me introduce you to my KNIFE"
local Desc2		= "You CAN bring a knife to a gunfight!"
local AmtAmt2	= ""
local Amt2		= 1
local IcoYes2	= "vgui/achievements/kill_sniper_with_knife"


local ACHName3	= "Knife to a gunfight"
local Desc3		= "Get killed while using the knife"
local IcoYes3	= "vgui/achievements/win_knife_fights_low"


if SERVER then
	function SACH.ACH_Stab(attacker,weapon,vic,vicWep)
		if vic == attacker then return end
		
		if weapon:GetClass() == "weapon_knife" then --killer's weapon
			local prog, got = SACH.Get(attacker, ACHName2)
			SACH.Update(attacker, ACHName2, prog + 1)
			
			local prog, got = SACH.Get(attacker, ACHName)
			SACH.Update(attacker, ACHName, prog + 1)
		end
		
		
		if vicWep and vicWep:GetClass() == "weapon_knife" then
			local prog, got = SACH.Get(vic, ACHName3)
			SACH.Update(vic, ACHName3, prog + 1)
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_Stab", SACH.ACH_Stab)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt2, Amt2)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Backstabber"
local Desc		= "Kill 10 people by backstabbing"
local AmtAmt	= "0/10"
local Amt		= 10
local IcoYes	= "vgui/achievements/kill_enemy_knife"

local ACHName2	= "Let me introduce you to my KNIFE"
local Desc2		= "You CAN bring a knife to a gunfight!"
local AmtAmt2	= ""
local Amt2		= 1
local IcoYes2	= "vgui/achievements/kill_sniper_with_knife"


local ACHName3	= "Knife to a gunfight"
local Desc3		= "Get killed while using the knife"
local IcoYes3	= "vgui/achievements/win_knife_fights_low"


if SERVER then
	function SACH.ACH_Stab(attacker,weapon,vic,vicWep)
		if vic == attacker then return end
		
		if weapon:GetClass() == "weapon_knife" then --killer's weapon
			local prog, got = SACH.Get(attacker, ACHName2)
			SACH.Update(attacker, ACHName2, prog + 1)
			
			local prog, got = SACH.Get(attacker, ACHName)
			SACH.Update(attacker, ACHName, prog + 1)
		end
		
		
		if vicWep and vicWep:GetClass() == "weapon_knife" then
			local prog, got = SACH.Get(vic, ACHName3)
			SACH.Update(vic, ACHName3, prog + 1)
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_Stab", SACH.ACH_Stab)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt2, Amt2)




