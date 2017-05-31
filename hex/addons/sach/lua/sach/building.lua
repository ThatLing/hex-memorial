
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Hey i'm building!"
local Desc		= "Get killed while using the toolgun"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/gmod_tool"

local ACHName2	= "It's a Deathmatch"
local Desc2		= "Kill a player who's using the toolgun"

if SERVER then
	function SACH.ACH_Building(vic,attacker,info)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if IsValid(vic:GetActiveWeapon()) then
				local VWC = vic:GetActiveWeapon():GetClass()
				
				if VWC == "gmod_tool" then
					local prog, got = SACH.Get(vic, ACHName)
					SACH.Update(vic, ACHName, prog + 1)
					
					local prog2, got2 = SACH.Get(attacker, ACHName2)
					SACH.Update(attacker, ACHName2, prog2 + 1)
				end
			end
		end
	end
	hook.Add("DoPlayerDeath", "SACH.ACH_Building", SACH.ACH_Building)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)









----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Hey i'm building!"
local Desc		= "Get killed while using the toolgun"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vgui/gmod_tool"

local ACHName2	= "It's a Deathmatch"
local Desc2		= "Kill a player who's using the toolgun"

if SERVER then
	function SACH.ACH_Building(vic,attacker,info)
		if IsValid(vic) and IsValid(attacker) and attacker:IsPlayer() and (vic != attacker) and SACH.ServerLoaded then
			if IsValid(vic:GetActiveWeapon()) then
				local VWC = vic:GetActiveWeapon():GetClass()
				
				if VWC == "gmod_tool" then
					local prog, got = SACH.Get(vic, ACHName)
					SACH.Update(vic, ACHName, prog + 1)
					
					local prog2, got2 = SACH.Get(attacker, ACHName2)
					SACH.Update(attacker, ACHName2, prog2 + 1)
				end
			end
		end
	end
	hook.Add("DoPlayerDeath", "SACH.ACH_Building", SACH.ACH_Building)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)








