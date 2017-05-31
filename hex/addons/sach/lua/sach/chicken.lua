
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Clucking brilliant"
local Desc		= "Discover the power of the chicken"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_chicken"

local ACHName2	= "Oh cluck"
local Desc2		= "Bang!"


local ACHName3	= "Cluck off"
local Desc3		= "Eat some chicken"

local ACHName4	= "Finger lickin' good"
local Desc4		= "Get your chicken eaten"



local ACHName5	= "Cock a doodle DOOM"
local Desc5		= "Mmmm, eggs"

local ACHName6	= "How do you like them apples"
local Desc6		= "Kill somone with a dropped egg"


local ACHName7	= "Kentucky Fried Chicken"
local Desc7		= "Get your chicken shot down"


local ACHName8	= "Clucked in action"
local Desc8		= "Get killed while guiding a chicken"

local ACHName9	= "Cock a doodle DON'T"
local Desc9		= "Kill someone guiding a chicken"

local ACHName10	= "Clucking Hell!"
local Desc10	= "Fly your chicken too long!"

local ACHName11		= "ClusterCluck"
local Desc11		= "FUCKING CHICKENS"
local MaxChickens	= 5


if SERVER then
	function SACH.ACH_ChickenDeath(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and vic != attacker then
			local KWC = inf:GetClass()
			
			if KWC == "guided_chicken" then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
				
			end
			if KWC == "npc_grenade_frag" and inf.IsChicken then --Lay grenade
				local prog, got = SACH.Get(vic, ACHName5)
				SACH.Update(vic, ACHName5, prog + 1)
				
				local prog, got = SACH.Get(attacker, ACHName6)
				SACH.Update(attacker, ACHName6, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_ChickenDeath", SACH.ACH_ChickenDeath)
	
	
	function SACH.ACH_EatChicken(owner,eater)
		if not (IsValid(owner) and IsValid(eater)) then return end
		
		local prog, got = SACH.Get(owner, ACHName4)
		SACH.Update(owner, ACHName4, prog + 1)
		
		local prog2, got2 = SACH.Get(eater, ACHName3)
		SACH.Update(eater, ACHName3, prog2 + 1)
	end
	
	function SACH.ACH_ShootChicken(owner)
		if not IsValid(owner) then return end
		
		local prog, got = SACH.Get(owner, ACHName7)
		SACH.Update(owner, ACHName7, prog + 1)
	end
	
	function SACH.ACH_ChickenTimeout(owner)
		if not IsValid(owner) then return end
		
		local prog, got = SACH.Get(owner, ACHName10)
		SACH.Update(owner, ACHName10, prog + 1)
	end
	
	
	function SACH.ACH_ChickenGuiding(attacker,weapon,vic,vicWep)
		if vic != attacker and vic:GetNWBool("DrawChicken") then
			local prog, got = SACH.Get(vic, ACHName8)
			SACH.Update(vic, ACHName8, prog + 1)
			
			if attacker:IsPlayer() then
				local prog, got = SACH.Get(attacker, ACHName9)
				SACH.Update(attacker, ACHName9, prog + 1)
			end
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_ChickenGuiding", SACH.ACH_ChickenGuiding)
	
	
	local Chickens = 0
	
	function SACH.ACH_ChickenSpawn(ent)
		if ent:GetClass() != "guided_chicken" then return end
		
		Chickens = Chickens + 1
		
		if Chickens > MaxChickens then
			for k,v in pairs( player.GetHumans() ) do
				local prog,got = SACH.Get(v, ACHName11)
				
				SACH.Update(v, ACHName11, prog + 1)
			end
		end
	end
	hook.Add("OnEntityCreated", "SACH.ACH_ChickenSpawn", SACH.ACH_ChickenSpawn)
	
	function SACH.ACH_ChickenRemove(ent)
		if ent:GetClass() != "guided_chicken" then return end
		
		Chickens = Chickens - 1
		if Chickens < 0 then
			Chickens = 0
		end
	end
	hook.Add("EntityRemoved", "SACH.ACH_ChickenRemove", SACH.ACH_ChickenRemove)
end


SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName5, Desc5, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName6, Desc6, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName7, Desc7, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName8, Desc8, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName9, Desc9, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName10, Desc10, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName11, Desc11, IcoYes, AmtAmt, Amt)









----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Clucking brilliant"
local Desc		= "Discover the power of the chicken"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/entities/weapon_chicken"

local ACHName2	= "Oh cluck"
local Desc2		= "Bang!"


local ACHName3	= "Cluck off"
local Desc3		= "Eat some chicken"

local ACHName4	= "Finger lickin' good"
local Desc4		= "Get your chicken eaten"



local ACHName5	= "Cock a doodle DOOM"
local Desc5		= "Mmmm, eggs"

local ACHName6	= "How do you like them apples"
local Desc6		= "Kill somone with a dropped egg"


local ACHName7	= "Kentucky Fried Chicken"
local Desc7		= "Get your chicken shot down"


local ACHName8	= "Clucked in action"
local Desc8		= "Get killed while guiding a chicken"

local ACHName9	= "Cock a doodle DON'T"
local Desc9		= "Kill someone guiding a chicken"

local ACHName10	= "Clucking Hell!"
local Desc10	= "Fly your chicken too long!"

local ACHName11		= "ClusterCluck"
local Desc11		= "FUCKING CHICKENS"
local MaxChickens	= 5


if SERVER then
	function SACH.ACH_ChickenDeath(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() and vic != attacker then
			local KWC = inf:GetClass()
			
			if KWC == "guided_chicken" then
				local prog, got = SACH.Get(attacker, ACHName)
				SACH.Update(attacker, ACHName, prog + 1)
				
				local prog2, got2 = SACH.Get(vic, ACHName2)
				SACH.Update(vic, ACHName2, prog2 + 1)
				
			end
			if KWC == "npc_grenade_frag" and inf.IsChicken then --Lay grenade
				local prog, got = SACH.Get(vic, ACHName5)
				SACH.Update(vic, ACHName5, prog + 1)
				
				local prog, got = SACH.Get(attacker, ACHName6)
				SACH.Update(attacker, ACHName6, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_ChickenDeath", SACH.ACH_ChickenDeath)
	
	
	function SACH.ACH_EatChicken(owner,eater)
		if not (IsValid(owner) and IsValid(eater)) then return end
		
		local prog, got = SACH.Get(owner, ACHName4)
		SACH.Update(owner, ACHName4, prog + 1)
		
		local prog2, got2 = SACH.Get(eater, ACHName3)
		SACH.Update(eater, ACHName3, prog2 + 1)
	end
	
	function SACH.ACH_ShootChicken(owner)
		if not IsValid(owner) then return end
		
		local prog, got = SACH.Get(owner, ACHName7)
		SACH.Update(owner, ACHName7, prog + 1)
	end
	
	function SACH.ACH_ChickenTimeout(owner)
		if not IsValid(owner) then return end
		
		local prog, got = SACH.Get(owner, ACHName10)
		SACH.Update(owner, ACHName10, prog + 1)
	end
	
	
	function SACH.ACH_ChickenGuiding(attacker,weapon,vic,vicWep)
		if vic != attacker and vic:GetNWBool("DrawChicken") then
			local prog, got = SACH.Get(vic, ACHName8)
			SACH.Update(vic, ACHName8, prog + 1)
			
			if attacker:IsPlayer() then
				local prog, got = SACH.Get(attacker, ACHName9)
				SACH.Update(attacker, ACHName9, prog + 1)
			end
		end
	end
	hook.Add("BeforePlayerDeath", "SACH.ACH_ChickenGuiding", SACH.ACH_ChickenGuiding)
	
	
	local Chickens = 0
	
	function SACH.ACH_ChickenSpawn(ent)
		if ent:GetClass() != "guided_chicken" then return end
		
		Chickens = Chickens + 1
		
		if Chickens > MaxChickens then
			for k,v in pairs( player.GetHumans() ) do
				local prog,got = SACH.Get(v, ACHName11)
				
				SACH.Update(v, ACHName11, prog + 1)
			end
		end
	end
	hook.Add("OnEntityCreated", "SACH.ACH_ChickenSpawn", SACH.ACH_ChickenSpawn)
	
	function SACH.ACH_ChickenRemove(ent)
		if ent:GetClass() != "guided_chicken" then return end
		
		Chickens = Chickens - 1
		if Chickens < 0 then
			Chickens = 0
		end
	end
	hook.Add("EntityRemoved", "SACH.ACH_ChickenRemove", SACH.ACH_ChickenRemove)
end


SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName5, Desc5, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName6, Desc6, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName7, Desc7, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName8, Desc8, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName9, Desc9, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName10, Desc10, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName11, Desc11, IcoYes, AmtAmt, Amt)








