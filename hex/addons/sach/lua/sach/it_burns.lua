
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "It Burns"
local Desc		= "Be on fire for 60 seconds"
local AmtAmt	= "0/60"
local Amt		= 60
local IcoYes	= "killicons/env_fire_killicon"


if SERVER then
	function SACH.ACH_ItBurns()
		if not SACH.ServerLoaded then return end
		
		for k,v in pairs(player.GetAll()) do
			if IsValid(v) and v:Alive() and v:IsOnFire() then
				local prog, got = SACH.Get(v, ACHName)
				
				SACH.Update(v, ACHName, prog + 1)
			end
		end
	end
	timer.Create("SACH.ACH_ItBurns", 1, 0, SACH.ACH_ItBurns)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "It Burns"
local Desc		= "Be on fire for 60 seconds"
local AmtAmt	= "0/60"
local Amt		= 60
local IcoYes	= "killicons/env_fire_killicon"


if SERVER then
	function SACH.ACH_ItBurns()
		if not SACH.ServerLoaded then return end
		
		for k,v in pairs(player.GetAll()) do
			if IsValid(v) and v:Alive() and v:IsOnFire() then
				local prog, got = SACH.Get(v, ACHName)
				
				SACH.Update(v, ACHName, prog + 1)
			end
		end
	end
	timer.Create("SACH.ACH_ItBurns", 1, 0, SACH.ACH_ItBurns)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




