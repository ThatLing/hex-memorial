
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "What a bargin!"
local Desc		= "Kill a player with the Bargin Bazooka"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/bargin_bazooka"

local ACHName2	= "The price is right"
local Desc2		= "Get killed by the Bargin Bazooka"


local ACHName3	= "Deal"
local Desc3		= "Eat the Bargin Bazooka missile"

local ACHName4	= "No Deal"
local Desc4		= "Get your Bargin Bazooka missile eaten!"



if SERVER then
	function SACH.ACH_Bargin2(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic != attacker) and (inf:GetClass() == "uh_bb_missile") then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bargin2", SACH.ACH_Bargin2)
	
	function SACH.EatBargin(owner,eater)
		if not (IsValid(owner) and IsValid(eater)) then return end
		
		local prog, got = SACH.Get(owner, ACHName4)
		SACH.Update(owner, ACHName4, prog + 1)
		
		local prog2, got2 = SACH.Get(eater, ACHName3)
		SACH.Update(eater, ACHName3, prog2 + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "What a bargin!"
local Desc		= "Kill a player with the Bargin Bazooka"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/bargin_bazooka"

local ACHName2	= "The price is right"
local Desc2		= "Get killed by the Bargin Bazooka"


local ACHName3	= "Deal"
local Desc3		= "Eat the Bargin Bazooka missile"

local ACHName4	= "No Deal"
local Desc4		= "Get your Bargin Bazooka missile eaten!"



if SERVER then
	function SACH.ACH_Bargin2(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (vic != attacker) and (inf:GetClass() == "uh_bb_missile") then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bargin2", SACH.ACH_Bargin2)
	
	function SACH.EatBargin(owner,eater)
		if not (IsValid(owner) and IsValid(eater)) then return end
		
		local prog, got = SACH.Get(owner, ACHName4)
		SACH.Update(owner, ACHName4, prog + 1)
		
		local prog2, got2 = SACH.Get(eater, ACHName3)
		SACH.Update(eater, ACHName3, prog2 + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)




