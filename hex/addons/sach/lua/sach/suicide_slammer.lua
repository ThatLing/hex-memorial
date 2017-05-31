
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Slammer!"
local Desc		= "Kill yourself with a SLAM!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"


if SERVER then
	function SACH.ACH_SuicideSlammer(ply)
		if not IsValid(ply) then return end
		
		local prog, got = SACH.Get(ply, ACHName)		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide Slammer!"
local Desc		= "Kill yourself with a SLAM!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/env_explosion_killicon"


if SERVER then
	function SACH.ACH_SuicideSlammer(ply)
		if not IsValid(ply) then return end
		
		local prog, got = SACH.Get(ply, ACHName)		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




