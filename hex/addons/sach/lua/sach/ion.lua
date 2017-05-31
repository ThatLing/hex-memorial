
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Forced Entry"
local Desc		= "Open 150 doors with the ion cannon"
local AmtAmt	= "0/150"
local Amt		= 150
local IcoYes	= "vgui/entities/weapon_ioncannon"


if SERVER then
	function SACH.ACH_Ion(ply)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Forced Entry"
local Desc		= "Open 150 doors with the ion cannon"
local AmtAmt	= "0/150"
local Amt		= 150
local IcoYes	= "vgui/entities/weapon_ioncannon"


if SERVER then
	function SACH.ACH_Ion(ply)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




