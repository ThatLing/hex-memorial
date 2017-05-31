
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Noob tube"
local Desc		= "Make 1000 RPG kills"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/npc_kleiner.png"


if SERVER then
	function SACH.ACH_Noob(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (inf:GetClass() == "rpg_missile") then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Noob", SACH.ACH_Noob)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Noob tube"
local Desc		= "Make 1000 RPG kills"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/npc_kleiner.png"


if SERVER then
	function SACH.ACH_Noob(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and (vic != attacker) and SACH.ServerLoaded then		
			if (inf:GetClass() == "rpg_missile") then
				local prog, got = SACH.Get(attacker, ACHName)
				
				SACH.Update(attacker, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Noob", SACH.ACH_Noob)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




