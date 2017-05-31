
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Reload Dr Freeman!"
local Desc		= "Make 500 kills with HL2 weapons"
local AmtAmt	= "0/500"
local Amt		= 500
local IcoYes	= "entities/rebel.png"

local HL2Guns = {
	["weapon_crowbar"]				= true,
	["weapon_stunstick"]			= true,
	["weapon_ar2"]					= true,
	["weapon_smg1"]					= true,
	["weapon_shotgun"]				= true,
	["weapon_pistol"]				= true,
	["weapon_357"]					= true,
	["weapon_frag"]					= true,
	["weapon_rpg"]					= true,
	
	["rpg_round"]					= true,
	["npc_grenade_frag"]			= true,
	["crossbow_bolt"]				= true,
	["grenade_ar2"]					= true,
	["prop_combine_ball"]			= true,
}


if SERVER then
	function SACH.ACH_Freeman(vic,inf,attacker)
		if IsValid(inf) and attacker:IsPlayer() and (vic != attacker) and HL2Guns[ inf:GetClass() ] then		
			local prog, got = SACH.Get(attacker, ACHName)
			
			SACH.Update(attacker, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Freeman", SACH.ACH_Freeman)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)










----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Reload Dr Freeman!"
local Desc		= "Make 500 kills with HL2 weapons"
local AmtAmt	= "0/500"
local Amt		= 500
local IcoYes	= "entities/rebel.png"

local HL2Guns = {
	["weapon_crowbar"]				= true,
	["weapon_stunstick"]			= true,
	["weapon_ar2"]					= true,
	["weapon_smg1"]					= true,
	["weapon_shotgun"]				= true,
	["weapon_pistol"]				= true,
	["weapon_357"]					= true,
	["weapon_frag"]					= true,
	["weapon_rpg"]					= true,
	
	["rpg_round"]					= true,
	["npc_grenade_frag"]			= true,
	["crossbow_bolt"]				= true,
	["grenade_ar2"]					= true,
	["prop_combine_ball"]			= true,
}


if SERVER then
	function SACH.ACH_Freeman(vic,inf,attacker)
		if IsValid(inf) and attacker:IsPlayer() and (vic != attacker) and HL2Guns[ inf:GetClass() ] then		
			local prog, got = SACH.Get(attacker, ACHName)
			
			SACH.Update(attacker, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Freeman", SACH.ACH_Freeman)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)









