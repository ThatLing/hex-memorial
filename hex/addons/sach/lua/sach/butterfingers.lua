
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Butterfingers"
local Desc		= "Drop an unfired One Shot Wonder!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"

local ACHName2	= "I Can't Believe It's Not Butter"
local Desc2		= "Drop 100 One Shot Wonders!"
local AmtAmt2	= "0/100"
local Amt2		= 100



if SERVER then
	function SACH.ACH_Butterfingers(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog2, got2 = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog2 + 1)
	end
end


SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)










----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Butterfingers"
local Desc		= "Drop an unfired One Shot Wonder!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"

local ACHName2	= "I Can't Believe It's Not Butter"
local Desc2		= "Drop 100 One Shot Wonders!"
local AmtAmt2	= "0/100"
local Amt2		= 100



if SERVER then
	function SACH.ACH_Butterfingers(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog2, got2 = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog2 + 1)
	end
end


SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)









