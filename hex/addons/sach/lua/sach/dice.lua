
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Dice Master"
local Desc		= "Roll the dice 2000 times"
local AmtAmt	= "0/2000"
local Amt		= 2000
local IcoYes	= "vgui/hand"

local ACHName2	= "Dice Roller"
local Desc2		= "Roll the dice!"
local AmtAmt2	= ""
local Amt2		= 1

local ACHName3	= "Dice Buster"
local Desc3		= "Roll the dice too much!"
local IcoYes3	= "entities/npc_kleiner.png"


if SERVER then
	function SACH.ACH_Dice(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog, got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
	
	function SACH.ACH_DiceSpam(ply)
		local prog, got = SACH.Get(ply, ACHName3)
		SACH.Update(ply, ACHName3, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt2, Amt2)










----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Dice Master"
local Desc		= "Roll the dice 2000 times"
local AmtAmt	= "0/2000"
local Amt		= 2000
local IcoYes	= "vgui/hand"

local ACHName2	= "Dice Roller"
local Desc2		= "Roll the dice!"
local AmtAmt2	= ""
local Amt2		= 1

local ACHName3	= "Dice Buster"
local Desc3		= "Roll the dice too much!"
local IcoYes3	= "entities/npc_kleiner.png"


if SERVER then
	function SACH.ACH_Dice(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog, got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
	
	function SACH.ACH_DiceSpam(ply)
		local prog, got = SACH.Get(ply, ACHName3)
		SACH.Update(ply, ACHName3, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt2, Amt2)









