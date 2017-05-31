
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Goodbye Insurance"
local Desc		= "Eject from your vehicle"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/seat_jalopy.png"


if SERVER then
	function SACH.ACH_EjectorSeat(ply)
		local prog, got = SACH.Get(ply, ACHName)
		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Goodbye Insurance"
local Desc		= "Eject from your vehicle"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/seat_jalopy.png"


if SERVER then
	function SACH.ACH_EjectorSeat(ply)
		local prog, got = SACH.Get(ply, ACHName)
		
		SACH.Update(ply, ACHName, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




