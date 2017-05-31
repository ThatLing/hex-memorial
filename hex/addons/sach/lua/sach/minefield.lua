
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Minefield Disco"
local Desc		= "Get killed by an enemy SLAM!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/killed_defuser_with_grenade"

local ACHName2	= "Minefield DJ"
local Desc2		= "Kill someone with a SLAM"
local IcoYes2	= "vgui/achievements/killed_defuser_with_grenade"

if SERVER then
	function SACH.ACH_Minefield(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			if (vic != attacker) and (inf:GetClass() == "npc_tripmine" or inf:GetClass() == "npc_satchel") then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Minefield", SACH.ACH_Minefield)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Minefield Disco"
local Desc		= "Get killed by an enemy SLAM!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/killed_defuser_with_grenade"

local ACHName2	= "Minefield DJ"
local Desc2		= "Kill someone with a SLAM"
local IcoYes2	= "vgui/achievements/killed_defuser_with_grenade"

if SERVER then
	function SACH.ACH_Minefield(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and SACH.ServerLoaded then
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			if (vic != attacker) and (inf:GetClass() == "npc_tripmine" or inf:GetClass() == "npc_satchel") then
				local prog,got = SACH.Get(vic, ACHName)
				SACH.Update(vic, ACHName, prog + 1)
				
				local prog,got = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Minefield", SACH.ACH_Minefield)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)




