
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Piece Treaty"
local Desc		= "Kill a sniper with a pistol"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/kill_sniper_with_sniper"


if SERVER then
	local IsPistol = {
		["weapon_pistol"]			= true,
		["weapon_357"]				= true,
		["weapon_deagle"]			= true,
		["cse_elites"]				= true,
		["weapon_fiveseven"]		= true,
		["weapon_glock"]			= true,
		["suicide_deagle"]			= true,
		["weapon_twitch_deagle"]	= true,
		["weapon_twitch_fiveseven"]	= true,
		["weapon_twitch_glock"]		= true,
		["weapon_twitch_hl2357"]	= true,
		["weapon_twitch_hl2pistol"]	= true,
		["weapon_twitch_p228"]		= true,
		["weapon_twitch_usp"]		= true,
	}
	
	local IsSniper = {
		["weapon_sniper"]			= true,
		["weapon_twitch_awp"]		= true,
		["weapon_twitch_scout"]		= true,
	}
	
	
	function SACH.ACH_Piece(attacker,weapon, vic,vicWep)
		if attacker:IsPlayer() and (vic != attacker) then
			if IsValid(weapon) and IsValid(vicWep) then
				if IsSniper[ vicWep:GetClass() ] and IsPistol[ weapon:GetClass() ] then
					local prog, got = SACH.Get(attacker, ACHName)
					
					SACH.Update(attacker, ACHName, prog + 1)
				end
			end
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_Piece", SACH.ACH_Piece)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)









----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Piece Treaty"
local Desc		= "Kill a sniper with a pistol"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/achievements/kill_sniper_with_sniper"


if SERVER then
	local IsPistol = {
		["weapon_pistol"]			= true,
		["weapon_357"]				= true,
		["weapon_deagle"]			= true,
		["cse_elites"]				= true,
		["weapon_fiveseven"]		= true,
		["weapon_glock"]			= true,
		["suicide_deagle"]			= true,
		["weapon_twitch_deagle"]	= true,
		["weapon_twitch_fiveseven"]	= true,
		["weapon_twitch_glock"]		= true,
		["weapon_twitch_hl2357"]	= true,
		["weapon_twitch_hl2pistol"]	= true,
		["weapon_twitch_p228"]		= true,
		["weapon_twitch_usp"]		= true,
	}
	
	local IsSniper = {
		["weapon_sniper"]			= true,
		["weapon_twitch_awp"]		= true,
		["weapon_twitch_scout"]		= true,
	}
	
	
	function SACH.ACH_Piece(attacker,weapon, vic,vicWep)
		if attacker:IsPlayer() and (vic != attacker) then
			if IsValid(weapon) and IsValid(vicWep) then
				if IsSniper[ vicWep:GetClass() ] and IsPistol[ weapon:GetClass() ] then
					local prog, got = SACH.Get(attacker, ACHName)
					
					SACH.Update(attacker, ACHName, prog + 1)
				end
			end
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_Piece", SACH.ACH_Piece)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)








