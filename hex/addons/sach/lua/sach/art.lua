
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "The Art of War"
local Desc		= "Spray 100 sprays"
local AmtAmt	= "0/100"
local Amt		= 100
local IcoYes	= "vgui/achievements/decal_sprays"


if SERVER then
	function SACH.ACH_Art(ply)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerSpray", "SACH.ACH_Art", SACH.ACH_Art)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "The Art of War"
local Desc		= "Spray 100 sprays"
local AmtAmt	= "0/100"
local Amt		= 100
local IcoYes	= "vgui/achievements/decal_sprays"


if SERVER then
	function SACH.ACH_Art(ply)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerSpray", "SACH.ACH_Art", SACH.ACH_Art)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




