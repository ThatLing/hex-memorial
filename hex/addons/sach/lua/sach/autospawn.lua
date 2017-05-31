
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sleeping on the job"
local Desc		= "Stay dead for 30s"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/pod.png"

local ACHName2	= "Barbed Wire"
local Desc2		= "Get autospawned 10 times"
local AmtAmt2	= "0/10"
local Amt2		= 10



if SERVER then
	function SACH.ACH_AutoSpawn(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog, got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)






----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Sleeping on the job"
local Desc		= "Stay dead for 30s"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/pod.png"

local ACHName2	= "Barbed Wire"
local Desc2		= "Get autospawned 10 times"
local AmtAmt2	= "0/10"
local Amt2		= 10



if SERVER then
	function SACH.ACH_AutoSpawn(ply)
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog, got = SACH.Get(ply, ACHName2)
		SACH.Update(ply, ACHName2, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)





