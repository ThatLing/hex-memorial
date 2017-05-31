
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Defusus Interruptus"
local Desc		= "Fail to defuse the bomb"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/t_victories_bomb-detonated"

local ACHName2	= "Blast Will and Testament"
local Desc2		= "C4 yourself"


if SERVER then
	function SACH.ACH_Defusus(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (inf:GetClass() == "ent_mad_c4") then
				local Defusing = vic.SACHFailDefuse
				
				local prog, got = SACH.Get(vic, ACHName) --Defusus
				local prog2, got2 = SACH.Get(vic, ACHName2) --Blast
				
				if Defusing then --Defusus
					if not got then
						SACH.Update(vic, ACHName, prog + 1) --Defusus
					else
						if (vic == attacker) then
							SACH.Update(vic, ACHName2, prog2 + 1) --Blast
						end
					end
					
				elseif not Defusing and (vic == attacker) then --Blast
					SACH.Update(vic, ACHName2, prog2 + 1) --Blast
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Defusus", SACH.ACH_Defusus)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Defusus Interruptus"
local Desc		= "Fail to defuse the bomb"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "hud/t_victories_bomb-detonated"

local ACHName2	= "Blast Will and Testament"
local Desc2		= "C4 yourself"


if SERVER then
	function SACH.ACH_Defusus(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if (inf:GetClass() == "ent_mad_c4") then
				local Defusing = vic.SACHFailDefuse
				
				local prog, got = SACH.Get(vic, ACHName) --Defusus
				local prog2, got2 = SACH.Get(vic, ACHName2) --Blast
				
				if Defusing then --Defusus
					if not got then
						SACH.Update(vic, ACHName, prog + 1) --Defusus
					else
						if (vic == attacker) then
							SACH.Update(vic, ACHName2, prog2 + 1) --Blast
						end
					end
					
				elseif not Defusing and (vic == attacker) then --Blast
					SACH.Update(vic, ACHName2, prog2 + 1) --Blast
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Defusus", SACH.ACH_Defusus)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)




