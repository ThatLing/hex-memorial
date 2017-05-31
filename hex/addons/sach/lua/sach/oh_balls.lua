
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Oh Balls"
local Desc		= "Get killed by a hoverball"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/sent_ball.png"


if SERVER then
	function SACH.ACH_OhBalls(vic,inf,attacker)
		if IsValid(vic) and SACH.ServerLoaded then		
			if attacker:GetClass() == "gmod_hoverball" then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_OhBalls", SACH.ACH_OhBalls)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)





----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Oh Balls"
local Desc		= "Get killed by a hoverball"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "entities/sent_ball.png"


if SERVER then
	function SACH.ACH_OhBalls(vic,inf,attacker)
		if IsValid(vic) and SACH.ServerLoaded then		
			if attacker:GetClass() == "gmod_hoverball" then
				local prog, got = SACH.Get(vic, ACHName)
				
				SACH.Update(vic, ACHName, prog + 1)
			end
		end
	end
	hook.Add("PlayerDeath", "SACH.ACH_OhBalls", SACH.ACH_OhBalls)
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)




