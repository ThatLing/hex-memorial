
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Hot Bullets"
local Desc		= "Kill 4 players without letting go of the trigger"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_ak47"


if SERVER then
	local WepOK = {
		["weapon_crowbar"]				= true,
		["weapon_stunstick"]			= true,
		["weapon_ar2"]					= true,
		["weapon_smg1"]					= true,
		["weapon_shotgun"]				= true,
		["weapon_pistol"]				= true,
		["weapon_357"]					= true,
		["weapon_bulletnade"]			= true,
		["plasma_grenade"]				= true,
		["weapon_knife"]				= true,
		["weapon_ak47"]					= true,
		["weapon_deagle"]				= true,
		["cse_elites"]					= true,
		["weapon_famas"]				= true,
		["weapon_fiveseven"]			= true,
		["weapon_galil"]				= true,
		["weapon_glock"]				= true,
		["weapon_mp5"]					= true,
		["weapon_p90"]					= true,
		["weapon_para"]					= true,
		["weapon_pumpshotgun"]			= true,
		["weapon_tmp"]					= true,
		["weapon_mac10"]				= true,
		["boomstick"]					= true,
		["kh_smg"]						= true,
		["plasma_rifle"]				= true,
		["weapon_stridercannon"]		= true,
		["suicide_deagle"]				= true,
		["weapon_acidshotgun"]			= true,
		["weapon_sniper"]				= true,
		["weapon_ioncannon"]			= true,
		["plasma_smg"]					= true,
		["weapon_m4"]					= true,
		["flechette_awp"]				= true,
		["weapon_twitch_ak47"]			= true,
		["weapon_twitch_aug"]			= true,
		["weapon_twitch_awp"]			= true,
		["weapon_twitch_deagle"]		= true,
		["weapon_twitch_fiveseven"]		= true,
		["weapon_twitch_g3"]			= true,
		["weapon_twitch_glock"]			= true,
		["weapon_twitch_hl2357"]		= true,
		["weapon_twitch_hl2mp7"]		= true,
		["weapon_twitch_hl2pistol"]		= true,
		["weapon_twitch_hl2pulserifle"]	= true,
		["weapon_twitch_hl2shotgun"]	= true,
		["weapon_twitch_p228"]			= true,
		["weapon_twitch_m1014"]			= true,
		["weapon_twitch_m249"]			= true,
		["weapon_twitch_m3"]			= true,
		["weapon_twitch_m4"]			= true,
		["weapon_twitch_mac10"]			= true,
		["weapon_twitch_mp5"]			= true,
		["weapon_twitch_p90"]			= true,
		["weapon_twitch_sg550"]			= true,
		["weapon_twitch_sg552"]			= true,
		["weapon_twitch_scout"]			= true,
		["weapon_twitch_tmp"]			= true,
		["weapon_twitch_ump45"]			= true,
		["weapon_twitch_usp"]			= true,
	}
	
	local function KeyDown(ply,key)
		if key == IN_ATTACK then
			ply.SACHBullets = 0
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Bullets", KeyDown)
	local function KeyUp(ply,key)
		if key == IN_ATTACK then
			ply.SACHBullets = 0
		end
	end
	hook.Add("KeyRelease", "SACH.ACH_Bullets", KeyUp)
	
	
	function SACH.ACH_Bullets(vic,inf,attacker)
		if IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then
			
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			
			if IsValid(inf) and WepOK[ inf:GetClass() ] then
				if not attacker.SACHBullets then
					attacker.SACHBullets = 0
				end
				
				attacker.SACHBullets = attacker.SACHBullets + 1
				
				if attacker.SACHBullets >= 4 then
					local prog, got = SACH.Get(attacker, ACHName)
					
					SACH.Update(attacker, ACHName, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bullets", SACH.ACH_Bullets)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Hot Bullets"
local Desc		= "Kill 4 players without letting go of the trigger"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_ak47"


if SERVER then
	local WepOK = {
		["weapon_crowbar"]				= true,
		["weapon_stunstick"]			= true,
		["weapon_ar2"]					= true,
		["weapon_smg1"]					= true,
		["weapon_shotgun"]				= true,
		["weapon_pistol"]				= true,
		["weapon_357"]					= true,
		["weapon_bulletnade"]			= true,
		["plasma_grenade"]				= true,
		["weapon_knife"]				= true,
		["weapon_ak47"]					= true,
		["weapon_deagle"]				= true,
		["cse_elites"]					= true,
		["weapon_famas"]				= true,
		["weapon_fiveseven"]			= true,
		["weapon_galil"]				= true,
		["weapon_glock"]				= true,
		["weapon_mp5"]					= true,
		["weapon_p90"]					= true,
		["weapon_para"]					= true,
		["weapon_pumpshotgun"]			= true,
		["weapon_tmp"]					= true,
		["weapon_mac10"]				= true,
		["boomstick"]					= true,
		["kh_smg"]						= true,
		["plasma_rifle"]				= true,
		["weapon_stridercannon"]		= true,
		["suicide_deagle"]				= true,
		["weapon_acidshotgun"]			= true,
		["weapon_sniper"]				= true,
		["weapon_ioncannon"]			= true,
		["plasma_smg"]					= true,
		["weapon_m4"]					= true,
		["flechette_awp"]				= true,
		["weapon_twitch_ak47"]			= true,
		["weapon_twitch_aug"]			= true,
		["weapon_twitch_awp"]			= true,
		["weapon_twitch_deagle"]		= true,
		["weapon_twitch_fiveseven"]		= true,
		["weapon_twitch_g3"]			= true,
		["weapon_twitch_glock"]			= true,
		["weapon_twitch_hl2357"]		= true,
		["weapon_twitch_hl2mp7"]		= true,
		["weapon_twitch_hl2pistol"]		= true,
		["weapon_twitch_hl2pulserifle"]	= true,
		["weapon_twitch_hl2shotgun"]	= true,
		["weapon_twitch_p228"]			= true,
		["weapon_twitch_m1014"]			= true,
		["weapon_twitch_m249"]			= true,
		["weapon_twitch_m3"]			= true,
		["weapon_twitch_m4"]			= true,
		["weapon_twitch_mac10"]			= true,
		["weapon_twitch_mp5"]			= true,
		["weapon_twitch_p90"]			= true,
		["weapon_twitch_sg550"]			= true,
		["weapon_twitch_sg552"]			= true,
		["weapon_twitch_scout"]			= true,
		["weapon_twitch_tmp"]			= true,
		["weapon_twitch_ump45"]			= true,
		["weapon_twitch_usp"]			= true,
	}
	
	local function KeyDown(ply,key)
		if key == IN_ATTACK then
			ply.SACHBullets = 0
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Bullets", KeyDown)
	local function KeyUp(ply,key)
		if key == IN_ATTACK then
			ply.SACHBullets = 0
		end
	end
	hook.Add("KeyRelease", "SACH.ACH_Bullets", KeyUp)
	
	
	function SACH.ACH_Bullets(vic,inf,attacker)
		if IsValid(inf) and IsValid(attacker) and SACH.ServerLoaded then
			
			if ( inf && inf == attacker && (inf:IsPlayer() || inf:IsNPC()) ) then
				inf = inf:GetActiveWeapon()
				if ( !inf || inf == NULL ) then inf = attacker end
			end
			
			
			if IsValid(inf) and WepOK[ inf:GetClass() ] then
				if not attacker.SACHBullets then
					attacker.SACHBullets = 0
				end
				
				attacker.SACHBullets = attacker.SACHBullets + 1
				
				if attacker.SACHBullets >= 4 then
					local prog, got = SACH.Get(attacker, ACHName)
					
					SACH.Update(attacker, ACHName, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Bullets", SACH.ACH_Bullets)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




