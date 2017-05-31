
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Laws of Physics"
local Desc		= "Get killed by a prop"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/weapon_physgun.png"

local ACHName2	= "Newton's Law"
local Desc2		= "Kill someone with a prop"
local IcoYes2	= "entities/seat_airboat.png"


if SERVER then
	local Props = {
		["prop_physics"] = true,
		["prop_physics_override"] = true,
	}
	
	function SACH.ACH_Physics(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			if Props[ inf:GetClass() ] then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				if attacker:IsPlayer() then
					local prog,got = SACH.Get(attacker, ACHName2)
					SACH.Update(attacker, ACHName2, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Physics", SACH.ACH_Physics)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Laws of Physics"
local Desc		= "Get killed by a prop"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/weapon_physgun.png"

local ACHName2	= "Newton's Law"
local Desc2		= "Kill someone with a prop"
local IcoYes2	= "entities/seat_airboat.png"


if SERVER then
	local Props = {
		["prop_physics"] = true,
		["prop_physics_override"] = true,
	}
	
	function SACH.ACH_Physics(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			if Props[ inf:GetClass() ] then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				if attacker:IsPlayer() then
					local prog,got = SACH.Get(attacker, ACHName2)
					SACH.Update(attacker, ACHName2, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Physics", SACH.ACH_Physics)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)




