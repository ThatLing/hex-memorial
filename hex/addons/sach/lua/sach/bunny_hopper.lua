
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bunny Hopper"
local Desc		= "Jump 1000 times"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/npc_antlion_grub.png"


if SERVER then
	function SACH.ACH_Bunny(ply,key)
		if (key == IN_JUMP) and IsValid(ply) and ply:IsOnGround() then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Bunny", SACH.ACH_Bunny)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Bunny Hopper"
local Desc		= "Jump 1000 times"
local AmtAmt	= "0/1000"
local Amt		= 1000
local IcoYes	= "entities/npc_antlion_grub.png"


if SERVER then
	function SACH.ACH_Bunny(ply,key)
		if (key == IN_JUMP) and IsValid(ply) and ply:IsOnGround() then		
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("KeyPress", "SACH.ACH_Bunny", SACH.ACH_Bunny)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




