
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Rule Reader"
local Desc		= "Read the !motd"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "models/weapons/v_toolgun/screen_bg"


if SERVER then
	function SACH.ACH_Motd(ply,text,isteam)
		if (text:lower() == "!motd") and IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerSay", "SACH.ACH_Motd", SACH.ACH_Motd)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Rule Reader"
local Desc		= "Read the !motd"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "models/weapons/v_toolgun/screen_bg"


if SERVER then
	function SACH.ACH_Motd(ply,text,isteam)
		if (text:lower() == "!motd") and IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName)
			
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	hook.Add("PlayerSay", "SACH.ACH_Motd", SACH.ACH_Motd)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




