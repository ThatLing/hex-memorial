
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Fightin' Words"
local Desc		= "Say 5000 words"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "entities/npc_gman.png"

local ACHName2	= "He can talk!"
local Desc2		= "Use the ingame chat!"
local IcoYes2	= "entities/npc_pigeon.png"
local AmtAmt2	= ""
local Amt2		= 1

local ACHName3	= "Raging Boner!"
local Desc3		= "Chat when dead"

if SERVER then
	function SACH.ACH_Words(ply,text,isteam)
		if not IsValid(ply) then return end
		
		if ply:Alive() then
			local prog2,got2 = SACH.Get(ply, ACHName2)
			if not got2 then
				SACH.Update(ply, ACHName2, prog2 + 1)
			end
		else
			local prog3,got3 = SACH.Get(ply, ACHName3)
			if not got3 then
				SACH.Update(ply, ACHName3, prog3 + 1)
			end
		end
		
		local prog,got = SACH.Get(ply, ACHName)
		if not got then
			if (text == "5000 words") then		
				SACH.Update(ply, ACHName, 5000)
			else
				SACH.Update(ply, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerSay", "SACH.ACH_Words", SACH.ACH_Words)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt2, Amt2)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Fightin' Words"
local Desc		= "Say 5000 words"
local AmtAmt	= "0/5000"
local Amt		= 5000
local IcoYes	= "entities/npc_gman.png"

local ACHName2	= "He can talk!"
local Desc2		= "Use the ingame chat!"
local IcoYes2	= "entities/npc_pigeon.png"
local AmtAmt2	= ""
local Amt2		= 1

local ACHName3	= "Raging Boner!"
local Desc3		= "Chat when dead"

if SERVER then
	function SACH.ACH_Words(ply,text,isteam)
		if not IsValid(ply) then return end
		
		if ply:Alive() then
			local prog2,got2 = SACH.Get(ply, ACHName2)
			if not got2 then
				SACH.Update(ply, ACHName2, prog2 + 1)
			end
		else
			local prog3,got3 = SACH.Get(ply, ACHName3)
			if not got3 then
				SACH.Update(ply, ACHName3, prog3 + 1)
			end
		end
		
		local prog,got = SACH.Get(ply, ACHName)
		if not got then
			if (text == "5000 words") then		
				SACH.Update(ply, ACHName, 5000)
			else
				SACH.Update(ply, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerSay", "SACH.ACH_Words", SACH.ACH_Words)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt2, Amt2)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt2, Amt2)




