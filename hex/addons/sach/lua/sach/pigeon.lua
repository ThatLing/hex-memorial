
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Lead Pigeon"
local Desc		= "Kill a player in who's in mid-air"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_pigeon.png"

local ACHName2	= "Death From Above"
local Desc2		= "Kill a player while in mid-air"
local IcoYes2	= "entities/npc_seagull.png"

if SERVER then
	local function IsInAir(ply)
		if not IsValid(ply) then return end
		
		if (not ply:IsOnGround() and not (ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_FLY or ply:GetMoveType() == MOVETYPE_LADDER)) then
			if (ply.InVehicle and not ply:InVehicle()) then
				return true
			end
		end
		
		return false
	end
	
	local function KeyDown(ply,key)
		if key == IN_JUMP then
			if not ply.SACHJump then
				ply.SACHJump = true
				
				timer.Simple(1.1, function()
					if IsValid(ply) then
						ply.SACHJump = false
					end
				end)
			end
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Pigeon", KeyDown)
	
	
	function SACH.ACH_Pigeon(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			--print("! IsInAir(vic): ", IsInAir(vic), " IsInAir(attacker): ", IsInAir(attacker))
			
			if not vic.SACHJump then
				vic.SACHJump = false
			end
			if not attacker.SACHJump then
				attacker.SACHJump = false
			end
			
			
			
			if IsInAir(vic) and (not vic.SACHJump) then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
			end
			
			if IsInAir(attacker) and (not attacker.SACHJump) then
				local prog2, got2 = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Pigeon", SACH.ACH_Pigeon)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)















----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Lead Pigeon"
local Desc		= "Kill a player in who's in mid-air"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/npc_pigeon.png"

local ACHName2	= "Death From Above"
local Desc2		= "Kill a player while in mid-air"
local IcoYes2	= "entities/npc_seagull.png"

if SERVER then
	local function IsInAir(ply)
		if not IsValid(ply) then return end
		
		if (not ply:IsOnGround() and not (ply:GetMoveType() == MOVETYPE_NOCLIP or ply:GetMoveType() == MOVETYPE_FLY or ply:GetMoveType() == MOVETYPE_LADDER)) then
			if (ply.InVehicle and not ply:InVehicle()) then
				return true
			end
		end
		
		return false
	end
	
	local function KeyDown(ply,key)
		if key == IN_JUMP then
			if not ply.SACHJump then
				ply.SACHJump = true
				
				timer.Simple(1.1, function()
					if IsValid(ply) then
						ply.SACHJump = false
					end
				end)
			end
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Pigeon", KeyDown)
	
	
	function SACH.ACH_Pigeon(vic,inf,attacker)
		if IsValid(vic) and vic:IsPlayer() and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			--print("! IsInAir(vic): ", IsInAir(vic), " IsInAir(attacker): ", IsInAir(attacker))
			
			if not vic.SACHJump then
				vic.SACHJump = false
			end
			if not attacker.SACHJump then
				attacker.SACHJump = false
			end
			
			
			
			if IsInAir(vic) and (not vic.SACHJump) then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
			end
			
			if IsInAir(attacker) and (not attacker.SACHJump) then
				local prog2, got2 = SACH.Get(attacker, ACHName2)
				SACH.Update(attacker, ACHName2, prog2 + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Pigeon", SACH.ACH_Pigeon)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)














