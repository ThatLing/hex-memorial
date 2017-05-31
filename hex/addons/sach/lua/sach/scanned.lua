
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Scanned Alone"
local Desc		= "See a player get banned by HAC"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_manhack.png"

local ACHName2	= "HIGHWAY TO HELL"
local Desc2		= "Get autobanned for cheats!"


if SERVER then
	function SACH.ACH_ScannedAlone(ply)
		if not IsValid(ply) then return end
		
		for k,v in pairs(player.GetAll()) do
			if not IsValid(v) then continue end
			
			if v == ply then
				local prog,got = SACH.Get(v, ACHName2)
				SACH.Update(v, ACHName2, prog + 1)
			else
				local prog,got = SACH.Get(v, ACHName)
				SACH.Update(v, ACHName, prog + 1)
			end
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Scanned Alone"
local Desc		= "See a player get banned by HAC"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_manhack.png"

local ACHName2	= "HIGHWAY TO HELL"
local Desc2		= "Get autobanned for cheats!"


if SERVER then
	function SACH.ACH_ScannedAlone(ply)
		if not IsValid(ply) then return end
		
		for k,v in pairs(player.GetAll()) do
			if not IsValid(v) then continue end
			
			if v == ply then
				local prog,got = SACH.Get(v, ACHName2)
				SACH.Update(v, ACHName2, prog + 1)
			else
				local prog,got = SACH.Get(v, ACHName)
				SACH.Update(v, ACHName, prog + 1)
			end
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)




