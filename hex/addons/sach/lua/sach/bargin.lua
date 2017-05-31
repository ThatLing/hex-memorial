
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bargin Bazooka"
local Desc		= "Discover the secondary fire"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/goose_chase"


if SERVER then
	function SACH.ACH_Bargin(ply)
		if IsValid(ply) then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bargin Bazooka"
local Desc		= "Discover the secondary fire"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/goose_chase"


if SERVER then
	function SACH.ACH_Bargin(ply)
		if IsValid(ply) then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




