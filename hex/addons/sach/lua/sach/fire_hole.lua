
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Fire in the hole"
local Desc		= "Throw 1000 grenades of any kind"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "vgui/gfx/vgui/hegrenade_square"


if SERVER then
	function SACH.ACH_FireHole(ply)
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


local ACHName	= "Fire in the hole"
local Desc		= "Throw 1000 grenades of any kind"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "vgui/gfx/vgui/hegrenade_square"


if SERVER then
	function SACH.ACH_FireHole(ply)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




