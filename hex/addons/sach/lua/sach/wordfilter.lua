
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Duck Auto Cucumber!"
local Desc		= "Trigger the wordfilter"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_mossman.png"

local ACHName0	= "National Bad Speling Day"
local Desc0		= "Trigger the wordfilter 5 times"
local AmtAmt0	= "0/5"
local Amt0		= 5

local ACHName1	= "Curse Box"
local Desc1		= "Trigger the wordfilter 10 times"
local AmtAmt1	= "0/10"
local Amt1		= 10

local ACHName2	= "I Can't Spell!"
local Desc2		= "Trigger the wordfilter 100 times"
local AmtAmt2	= "0/100"
local Amt2		= 100


if SERVER then
	function SACH.ACH_WordFilter(ply)
		if not IsValid(ply) then return end
		local prog,got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName0)
			if (not got) and HSP.Quake_Dispatch and ((prog + 1) >= Amt0) then --5!
				--HSP.SPS(nil, HSP.QuakeSounds.combowhore)
			end
		SACH.Update(ply, ACHName0, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName1)
		SACH.Update(ply, ACHName1, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName0, Desc0, IcoYes, AmtAmt0, Amt0)
SACH.Register(ACHName1, Desc1, IcoYes, AmtAmt1, Amt1)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)









----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Duck Auto Cucumber!"
local Desc		= "Trigger the wordfilter"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_mossman.png"

local ACHName0	= "National Bad Speling Day"
local Desc0		= "Trigger the wordfilter 5 times"
local AmtAmt0	= "0/5"
local Amt0		= 5

local ACHName1	= "Curse Box"
local Desc1		= "Trigger the wordfilter 10 times"
local AmtAmt1	= "0/10"
local Amt1		= 10

local ACHName2	= "I Can't Spell!"
local Desc2		= "Trigger the wordfilter 100 times"
local AmtAmt2	= "0/100"
local Amt2		= 100


if SERVER then
	function SACH.ACH_WordFilter(ply)
		if not IsValid(ply) then return end
		local prog,got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName0)
			if (not got) and HSP.Quake_Dispatch and ((prog + 1) >= Amt0) then --5!
				--HSP.SPS(nil, HSP.QuakeSounds.combowhore)
			end
		SACH.Update(ply, ACHName0, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName1)
		SACH.Update(ply, ACHName1, prog + 1)
		
		local prog,got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName0, Desc0, IcoYes, AmtAmt0, Amt0)
SACH.Register(ACHName1, Desc1, IcoYes, AmtAmt1, Amt1)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)








