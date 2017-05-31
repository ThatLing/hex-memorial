
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Grave Robber"
local Desc		= "Deactivate 1000 gravestones"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "vgui/gfx/vgui/defuser"

local ACHName2	= "So that's what these are for"
local AmtAmt2	= ""
local Amt2		= 1
local Desc2		= "Deactivate a gravestone!"

local ACHName3	= "Quickie"
local Desc3		= "Deactivate a gravestone before it touches anything!"


if SERVER then
	function SACH.ACH_Grave(ply,fresh)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			SACH.Update(ply, ACHName, prog + 1)
			
			if fresh then
				local prog, got = SACH.Get(ply, ACHName3)
				SACH.Update(ply, ACHName3, prog + 1)
			end
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt2, Amt2)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Grave Robber"
local Desc		= "Deactivate 1000 gravestones"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "vgui/gfx/vgui/defuser"

local ACHName2	= "So that's what these are for"
local AmtAmt2	= ""
local Amt2		= 1
local Desc2		= "Deactivate a gravestone!"

local ACHName3	= "Quickie"
local Desc3		= "Deactivate a gravestone before it touches anything!"


if SERVER then
	function SACH.ACH_Grave(ply,fresh)
		if IsValid(ply) and SACH.ServerLoaded then		
			local prog, got = SACH.Get(ply, ACHName)
			SACH.Update(ply, ACHName, prog + 1)
			
			if fresh then
				local prog, got = SACH.Get(ply, ACHName3)
				SACH.Update(ply, ACHName3, prog + 1)
			end
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt2, Amt2)




