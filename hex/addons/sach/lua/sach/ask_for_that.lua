
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Didn't ASK for that"
local Desc		= "Get spawnkilled"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/sent_ball.png"

local ACHName2	= "ASKing for trouble"
local Desc2		= "Spawnkill someone"

if SERVER then
	function SACH.ACH_ASKForThat(killer,victim)
		local prog, got = SACH.Get(victim, ACHName)
		SACH.Update(victim, ACHName, prog + 1)
		
		local prog, got = SACH.Get(killer, ACHName2)
		SACH.Update(killer, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Didn't ASK for that"
local Desc		= "Get spawnkilled"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/sent_ball.png"

local ACHName2	= "ASKing for trouble"
local Desc2		= "Spawnkill someone"

if SERVER then
	function SACH.ACH_ASKForThat(killer,victim)
		local prog, got = SACH.Get(victim, ACHName)
		SACH.Update(victim, ACHName, prog + 1)
		
		local prog, got = SACH.Get(killer, ACHName2)
		SACH.Update(killer, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)




