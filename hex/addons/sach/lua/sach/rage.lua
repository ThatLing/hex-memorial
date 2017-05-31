
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "So long, and thanks for all the fish"
local Desc		= "See a player ragequit"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_manhack.png"

local ACHName2	= "R-R-R-RAGEQUIT!"
local Desc2		= "Fuck this"


if SERVER then
	function SACH.ACH_RageQuit(ply)
		if IsValid(ply) then
			for k,v in pairs( player.GetAll() ) do
				if IsValid(v) and (v != ply) then
					local prog, got = SACH.Get(v, ACHName)
					SACH.Update(v, ACHName, prog + 1)
				end
			end
			
			local prog, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "So long, and thanks for all the fish"
local Desc		= "See a player ragequit"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_manhack.png"

local ACHName2	= "R-R-R-RAGEQUIT!"
local Desc2		= "Fuck this"


if SERVER then
	function SACH.ACH_RageQuit(ply)
		if IsValid(ply) then
			for k,v in pairs( player.GetAll() ) do
				if IsValid(v) and (v != ply) then
					local prog, got = SACH.Get(v, ACHName)
					SACH.Update(v, ACHName, prog + 1)
				end
			end
			
			local prog, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)




