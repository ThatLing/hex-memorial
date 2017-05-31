
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Frag Supprize"
local Desc		= "Kill a player with a grenade after you've died"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/dead_grenade_kill"

local ACHName2	= "FragCore"
local Desc2		= "Eat the grenade"

local ACHName3	= "GRENADE!"
local Desc3		= "Roll a grenade in there"


if SERVER then
	function SACH.ACH_Frag(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) then	
			local EGC = inf:GetClass()
			if (EGC:find("frag") or EGC:find("grenade")) then
				if not attacker:Alive() then
					local prog, got = SACH.Get(attacker, ACHName)
					SACH.Update(attacker, ACHName, prog + 1)
				end
				
				if (EGC == "npc_grenade_frag") then
					local prog, got = SACH.Get(vic, ACHName2)
					SACH.Update(vic, ACHName2, prog + 1)
					
					local prog, got = SACH.Get(attacker, ACHName3)
					SACH.Update(attacker, ACHName3, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Frag", SACH.ACH_Frag)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Frag Supprize"
local Desc		= "Kill a player with a grenade after you've died"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/dead_grenade_kill"

local ACHName2	= "FragCore"
local Desc2		= "Eat the grenade"

local ACHName3	= "GRENADE!"
local Desc3		= "Roll a grenade in there"


if SERVER then
	function SACH.ACH_Frag(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) then	
			local EGC = inf:GetClass()
			if (EGC:find("frag") or EGC:find("grenade")) then
				if not attacker:Alive() then
					local prog, got = SACH.Get(attacker, ACHName)
					SACH.Update(attacker, ACHName, prog + 1)
				end
				
				if (EGC == "npc_grenade_frag") then
					local prog, got = SACH.Get(vic, ACHName2)
					SACH.Update(vic, ACHName2, prog + 1)
					
					local prog, got = SACH.Get(attacker, ACHName3)
					SACH.Update(attacker, ACHName3, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Frag", SACH.ACH_Frag)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)




