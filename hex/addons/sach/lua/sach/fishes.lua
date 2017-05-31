
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sleeping with the fishes"
local Desc		= "Get killed while underwater"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/boating_accident.png"

local ACHNameB	= "Boating Accident"
local DescB		= "Get killed 10 times in water"
local AmtAmtB	= "0/10"
local AmtB		= 10


local ACHName2	= "Fishing rod"
local Desc2		= "Kill a swimming player"

local ACHNameC	= "Coastguard"
local DescC		= "Kill 10 players in the water"
local AmtAmtC	= "0/10"
local AmtC		= 10


if SERVER then
	function SACH.ACH_Fishes(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and attacker:IsPlayer() then		
			if (vic:WaterLevel() == 3) then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)

				local prog, got = SACH.Get(vic, ACHNameB)
				SACH.Update(vic, ACHNameB, prog + 1)
				
				
				local prog2, got2 = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog2 + 1)
				
				local prog2, got2 = SACH.Get(attacker, ACHNameC)
				SACH.Update(attacker, ACHNameC, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Fishes", SACH.ACH_Fishes)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameB, DescB, IcoYes, AmtAmtB, AmtB)

SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameC, DescC, IcoYes, AmtAmtC, AmtC)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sleeping with the fishes"
local Desc		= "Get killed while underwater"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "sach/boating_accident.png"

local ACHNameB	= "Boating Accident"
local DescB		= "Get killed 10 times in water"
local AmtAmtB	= "0/10"
local AmtB		= 10


local ACHName2	= "Fishing rod"
local Desc2		= "Kill a swimming player"

local ACHNameC	= "Coastguard"
local DescC		= "Kill 10 players in the water"
local AmtAmtC	= "0/10"
local AmtC		= 10


if SERVER then
	function SACH.ACH_Fishes(vic,inf,attacker)
		if IsValid(vic) and IsValid(attacker) and (vic != attacker) and attacker:IsPlayer() then		
			if (vic:WaterLevel() == 3) then
				local prog, got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)

				local prog, got = SACH.Get(vic, ACHNameB)
				SACH.Update(vic, ACHNameB, prog + 1)
				
				
				local prog2, got2 = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog2 + 1)
				
				local prog2, got2 = SACH.Get(attacker, ACHNameC)
				SACH.Update(attacker, ACHNameC, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Fishes", SACH.ACH_Fishes)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameB, DescB, IcoYes, AmtAmtB, AmtB)

SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameC, DescC, IcoYes, AmtAmtC, AmtC)




