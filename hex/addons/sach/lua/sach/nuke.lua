
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName0	= "Oh this is bad"
local Desc0		= "Earn your first nuke!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"


local ACHName	= "Red button"
local Desc		= "Get killed by a nuke"



local ACHName2	= "Duck and Cover"
local Desc2		= "Maybe it'll help.."

local ACHName3	= "Suck and Cover!"
local Desc3		= "Oooh!"


local ACHName4	= "Wham"
local Desc4		= "Nuke to the face"

local ACHName5	= "Roadkill"
local Desc5		= "Here, catch"

local ACHName6	= "Double Trouble"
local Desc6		= "Earn another nuke without fireing the first one!"



if SERVER then
	function SACH.ACH_Nuke2(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() then
			local egc = inf:GetClass()
			
			if (egc == "nuke_explosion" or egc == "nuke_missile" or egc == "nuke_radiation") then
				if (vic != attacker) then
					local prog,got = SACH.Get(vic, ACHName)
					SACH.Update(vic, ACHName, prog + 1)
				end
				
				if vic:Crouching() then
					if (vic != attacker) then
						local prog, got = SACH.Get(vic, ACHName2)
						SACH.Update(vic, ACHName2, prog + 1)
					else
						local prog, got = SACH.Get(vic, ACHName3)
						SACH.Update(vic, ACHName3, prog + 1)
					end
				end
				
				
				if egc == "nuke_missile" then --Squash
					local prog, got = SACH.Get(vic, ACHName4)
					SACH.Update(vic, ACHName4, prog + 1)
					
					local prog, got = SACH.Get(attacker, ACHName5)
					SACH.Update(attacker, ACHName5, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Nuke2", SACH.ACH_Nuke2)
	
	
	function SACH.ACH_EarnNuke(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName0)
			SACH.Update(ply, ACHName0, prog + 1)
		end
	end
	
	function SACH.ACH_NukeAmmo(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName6)
			SACH.Update(ply, ACHName6, prog + 1)
		end
	end
end

SACH.Register(ACHName0, Desc0, IcoYes, AmtAmt, Amt)



SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName5, Desc5, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName6, Desc6, IcoYes, AmtAmt, Amt)











----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName0	= "Oh this is bad"
local Desc0		= "Earn your first nuke!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"


local ACHName	= "Red button"
local Desc		= "Get killed by a nuke"



local ACHName2	= "Duck and Cover"
local Desc2		= "Maybe it'll help.."

local ACHName3	= "Suck and Cover!"
local Desc3		= "Oooh!"


local ACHName4	= "Wham"
local Desc4		= "Nuke to the face"

local ACHName5	= "Roadkill"
local Desc5		= "Here, catch"

local ACHName6	= "Double Trouble"
local Desc6		= "Earn another nuke without fireing the first one!"



if SERVER then
	function SACH.ACH_Nuke2(vic,inf,attacker)
		if IsValid(vic) and IsValid(inf) and IsValid(attacker) and attacker:IsPlayer() then
			local egc = inf:GetClass()
			
			if (egc == "nuke_explosion" or egc == "nuke_missile" or egc == "nuke_radiation") then
				if (vic != attacker) then
					local prog,got = SACH.Get(vic, ACHName)
					SACH.Update(vic, ACHName, prog + 1)
				end
				
				if vic:Crouching() then
					if (vic != attacker) then
						local prog, got = SACH.Get(vic, ACHName2)
						SACH.Update(vic, ACHName2, prog + 1)
					else
						local prog, got = SACH.Get(vic, ACHName3)
						SACH.Update(vic, ACHName3, prog + 1)
					end
				end
				
				
				if egc == "nuke_missile" then --Squash
					local prog, got = SACH.Get(vic, ACHName4)
					SACH.Update(vic, ACHName4, prog + 1)
					
					local prog, got = SACH.Get(attacker, ACHName5)
					SACH.Update(attacker, ACHName5, prog + 1)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_Nuke2", SACH.ACH_Nuke2)
	
	
	function SACH.ACH_EarnNuke(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName0)
			SACH.Update(ply, ACHName0, prog + 1)
		end
	end
	
	function SACH.ACH_NukeAmmo(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName6)
			SACH.Update(ply, ACHName6, prog + 1)
		end
	end
end

SACH.Register(ACHName0, Desc0, IcoYes, AmtAmt, Amt)



SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName4, Desc4, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName5, Desc5, IcoYes, AmtAmt, Amt)

SACH.Register(ACHName6, Desc6, IcoYes, AmtAmt, Amt)










