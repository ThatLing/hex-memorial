
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide SPAMMER"
local Desc		= "Kill yourself 1000 times"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "killicons/suicide_killicon"


if SERVER then
	function SACH.ACH_SuicideSpammer(ply)
		if not IsValid(ply) then return end
		if not SACH.ServerLoaded then return end
		
		local prog, got = SACH.Get(ply, ACHName)
		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Suicide SPAMMER"
local Desc		= "Kill yourself 1000 times"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "killicons/suicide_killicon"


if SERVER then
	function SACH.ACH_SuicideSpammer(ply)
		if not IsValid(ply) then return end
		if not SACH.ServerLoaded then return end
		
		local prog, got = SACH.Get(ply, ACHName)
		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




