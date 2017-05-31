
----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Crispy barbecue"
local Desc		= "Set off a nuke!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"

local ACHName2	= "Fresh Tasty Bombs"
local Desc2		= "Catch and disarm a nuke before it detonates"
local IcoYes2	= "hud/ct_victories_bomb-defused"

local ACHName3	= "World War Three"
local Desc3		= "Set off 100 nukes!"
local AmtAmt3	= "0/100"
local Amt3		= 100

local ACHName4	= "Stolen Goods"
local Desc4		= "Get your nuke disarmed and stolen!"
local IcoYes4	= "killicons/sent_nuke_killicon"


if SERVER then
	function SACH.ACH_Crispy(ply)
		if not IsValid(ply) then return end
		
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog3, got3 = SACH.Get(ply, ACHName3)
		SACH.Update(ply, ACHName3, prog3 + 1)
	end
	
	function SACH.ACH_CatchNuke(ply,nuke)
		if IsValid(ply) then
			local prog2, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog2 + 1)
		end
		
		if IsValid(nuke) and IsValid(nuke.Owner) then
			local prog, got = SACH.Get(nuke.Owner, ACHName4)
			SACH.Update(nuke.Owner, ACHName4, prog + 1)
		end
	end
end



SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt3, Amt3)
SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)











----------------------------------------
--         2014-07-12 20:33:18          --
------------------------------------------


local ACHName	= "Crispy barbecue"
local Desc		= "Set off a nuke!"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "killicons/sent_nuke_killicon"

local ACHName2	= "Fresh Tasty Bombs"
local Desc2		= "Catch and disarm a nuke before it detonates"
local IcoYes2	= "hud/ct_victories_bomb-defused"

local ACHName3	= "World War Three"
local Desc3		= "Set off 100 nukes!"
local AmtAmt3	= "0/100"
local Amt3		= 100

local ACHName4	= "Stolen Goods"
local Desc4		= "Get your nuke disarmed and stolen!"
local IcoYes4	= "killicons/sent_nuke_killicon"


if SERVER then
	function SACH.ACH_Crispy(ply)
		if not IsValid(ply) then return end
		
		local prog, got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog3, got3 = SACH.Get(ply, ACHName3)
		SACH.Update(ply, ACHName3, prog3 + 1)
	end
	
	function SACH.ACH_CatchNuke(ply,nuke)
		if IsValid(ply) then
			local prog2, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog2 + 1)
		end
		
		if IsValid(nuke) and IsValid(nuke.Owner) then
			local prog, got = SACH.Get(nuke.Owner, ACHName4)
			SACH.Update(nuke.Owner, ACHName4, prog + 1)
		end
	end
end



SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes, AmtAmt3, Amt3)
SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)










