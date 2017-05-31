
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local AmtAmt	= ""
local Amt		= 1

local ACHName	= "Hole in One"
local Desc		= "Pop dat head!"
local IcoYes	= "VGUI/achievements/domination_overkills_low"

local ACHNameB	= "Bye Bye Brains"
local DescB		= "Take a headshot!"
local IcoYesB	= "VGUI/achievements/domination_overkills_low"

local ACHNameH2	= "Magic Bullet"
local DescH2	= "Pop 100 heads!"
local IcoYesH2	= "VGUI/achievements/kill_snipers"
local AmtAmtH2	= "0/100"
local AmtH2		= 100

local ACHNameH3	= "IOU"
local DescH3	= "Kill your killer!"
local IcoYesH3	= "VGUI/achievements/revenges_low"

local ACHNameH4	= "Return to sender"
local DescH4	= "Get killed by your last victim!"
local IcoYesH4	= "VGUI/achievements/revenges_low"

local ACHName2	= "Core2 Duo"
local Desc2		= "kill 2 players at once!"
local IcoYes2	= "VGUI/achievements/kill_two_with_one_shot"

local ACHName3	= "Threesome!"
local Desc3		= "kill 3 players at once!"
local IcoYes3	= "VGUI/achievements/kill_bomb_pickup"

local ACHName4	= "Core2 Quad"
local Desc4		= "kill 4 players at once!"
local IcoYes4	= "VGUI/achievements/rescue_all_hostages"

local ACHName5	= "Core i5"
local Desc5		= "kill 5 players at once!"
local IcoYes5	= "VGUI/achievements/meta_smg"

local ACHName6	= "Phenom X6"
local Desc6		= "kill 6 players at once!"
local IcoYes6	= "VGUI/achievements/meta_pistol"

local ACHName7	= "Core i7"
local Desc7		= "kill 7 players at once!"
local IcoYes7	= "VGUI/achievements/meta_weaponmaster"

local ACHName8	= "Toilet paper"
local Desc8		= "kill 8 players at once!"
local IcoYes8	= "VGUI/achievements/last_player_alive"

local ACHName9	= "Ultrakill"
local Desc9		= "kill 9 players at once!"
local IcoYes9	= "VGUI/achievements/flawless_victory"

local ACHName10	= "Ludicrous Kill"
local Desc10	= "kill 10 players at once!"
local IcoYes10	= "VGUI/achievements/domination_overkills_match"

local ACHName11	= "Unstoppable"
local Desc11	= "kill 11 players at once!"
local IcoYes11	= "VGUI/achievements/lossless_extermination"

local ACHName12	= "Godlike!"
local Desc12	= "kill 12 players at once!"
local IcoYes12	= "VGUI/achievements/immovable_object"


if SERVER then
	function SACH.ACH_Quake(ply,tot)
		if (tot >= 12) then --godlike
			local prog, got = SACH.Get(ply, ACHName12)
			SACH.Update(ply, ACHName12, prog + 1)
			
		elseif (tot == 11) then --unstoppable
			local prog, got = SACH.Get(ply, ACHName11)
			SACH.Update(ply, ACHName11, prog + 1)
			
		elseif (tot == 10) then --ludicrouskill
			local prog, got = SACH.Get(ply, ACHName10)
			SACH.Update(ply, ACHName10, prog + 1)
			
		elseif (tot == 9) then --ultrakill
			local prog, got = SACH.Get(ply, ACHName9)
			SACH.Update(ply, ACHName9, prog + 1)
			
		elseif (tot == 8) then --holyshit
			local prog, got = SACH.Get(ply, ACHName8)
			SACH.Update(ply, ACHName8, prog + 1)
			
		elseif (tot == 7) then --monsterkill
			local prog, got = SACH.Get(ply, ACHName7)
			SACH.Update(ply, ACHName7, prog + 1)
			
		elseif (tot == 6) then --killingspree
			local prog, got = SACH.Get(ply, ACHName6)
			SACH.Update(ply, ACHName6, prog + 1)
			
		elseif (tot == 5) then --multikill
			local prog, got = SACH.Get(ply, ACHName5)
			SACH.Update(ply, ACHName5, prog + 1)
			
		elseif (tot == 4) then --rampage
			local prog, got = SACH.Get(ply, ACHName4)
			SACH.Update(ply, ACHName4, prog + 1)
			
		elseif (tot == 3) then --triplekill
			local prog, got = SACH.Get(ply, ACHName3)
			SACH.Update(ply, ACHName3, prog + 1)
			
		elseif (tot == 2) then --doublekill
			local prog, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog + 1)
		end
	end
	
	function SACH.ACH_HoleInOne(ply,vic)
		if not (IsValid(ply) and IsValid(vic)) then return end
		local prog,got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog,got = SACH.Get(vic, ACHNameB)
		SACH.Update(vic, ACHNameB, prog + 1)
		
		
		local prog,got = SACH.Get(ply, ACHNameH2)
		SACH.Update(ply, ACHNameH2, prog + 1)
	end
	
	function SACH.ACH_IOU(killer,vic)
		local prog,got = SACH.Get(killer, ACHNameH3)
		SACH.Update(killer, ACHNameH3, prog + 1)
		
		local prog,got = SACH.Get(vic, ACHNameH4)
		SACH.Update(vic, ACHNameH4, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameB, DescB, IcoYesB, AmtAmt, Amt)
SACH.Register(ACHNameH2, DescH2, IcoYesH2, AmtAmtH2, AmtH2)
SACH.Register(ACHNameH3, DescH3, IcoYesH3, AmtAmt, Amt)
SACH.Register(ACHNameH4, DescH4, IcoYesH4, AmtAmt, Amt)

SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)
SACH.Register(ACHName5, Desc5, IcoYes5, AmtAmt, Amt)
SACH.Register(ACHName6, Desc6, IcoYes6, AmtAmt, Amt)
SACH.Register(ACHName7, Desc7, IcoYes7, AmtAmt, Amt)
SACH.Register(ACHName8, Desc8, IcoYes8, AmtAmt, Amt)
SACH.Register(ACHName9, Desc9, IcoYes9, AmtAmt, Amt)
SACH.Register(ACHName10, Desc10, IcoYes10, AmtAmt, Amt)
SACH.Register(ACHName11, Desc11, IcoYes11, AmtAmt, Amt)
SACH.Register(ACHName12, Desc12, IcoYes12, AmtAmt, Amt)
















----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local AmtAmt	= ""
local Amt		= 1

local ACHName	= "Hole in One"
local Desc		= "Pop dat head!"
local IcoYes	= "VGUI/achievements/domination_overkills_low"

local ACHNameB	= "Bye Bye Brains"
local DescB		= "Take a headshot!"
local IcoYesB	= "VGUI/achievements/domination_overkills_low"

local ACHNameH2	= "Magic Bullet"
local DescH2	= "Pop 100 heads!"
local IcoYesH2	= "VGUI/achievements/kill_snipers"
local AmtAmtH2	= "0/100"
local AmtH2		= 100

local ACHNameH3	= "IOU"
local DescH3	= "Kill your killer!"
local IcoYesH3	= "VGUI/achievements/revenges_low"

local ACHNameH4	= "Return to sender"
local DescH4	= "Get killed by your last victim!"
local IcoYesH4	= "VGUI/achievements/revenges_low"

local ACHName2	= "Core2 Duo"
local Desc2		= "kill 2 players at once!"
local IcoYes2	= "VGUI/achievements/kill_two_with_one_shot"

local ACHName3	= "Threesome!"
local Desc3		= "kill 3 players at once!"
local IcoYes3	= "VGUI/achievements/kill_bomb_pickup"

local ACHName4	= "Core2 Quad"
local Desc4		= "kill 4 players at once!"
local IcoYes4	= "VGUI/achievements/rescue_all_hostages"

local ACHName5	= "Core i5"
local Desc5		= "kill 5 players at once!"
local IcoYes5	= "VGUI/achievements/meta_smg"

local ACHName6	= "Phenom X6"
local Desc6		= "kill 6 players at once!"
local IcoYes6	= "VGUI/achievements/meta_pistol"

local ACHName7	= "Core i7"
local Desc7		= "kill 7 players at once!"
local IcoYes7	= "VGUI/achievements/meta_weaponmaster"

local ACHName8	= "Toilet paper"
local Desc8		= "kill 8 players at once!"
local IcoYes8	= "VGUI/achievements/last_player_alive"

local ACHName9	= "Ultrakill"
local Desc9		= "kill 9 players at once!"
local IcoYes9	= "VGUI/achievements/flawless_victory"

local ACHName10	= "Ludicrous Kill"
local Desc10	= "kill 10 players at once!"
local IcoYes10	= "VGUI/achievements/domination_overkills_match"

local ACHName11	= "Unstoppable"
local Desc11	= "kill 11 players at once!"
local IcoYes11	= "VGUI/achievements/lossless_extermination"

local ACHName12	= "Godlike!"
local Desc12	= "kill 12 players at once!"
local IcoYes12	= "VGUI/achievements/immovable_object"


if SERVER then
	function SACH.ACH_Quake(ply,tot)
		if (tot >= 12) then --godlike
			local prog, got = SACH.Get(ply, ACHName12)
			SACH.Update(ply, ACHName12, prog + 1)
			
		elseif (tot == 11) then --unstoppable
			local prog, got = SACH.Get(ply, ACHName11)
			SACH.Update(ply, ACHName11, prog + 1)
			
		elseif (tot == 10) then --ludicrouskill
			local prog, got = SACH.Get(ply, ACHName10)
			SACH.Update(ply, ACHName10, prog + 1)
			
		elseif (tot == 9) then --ultrakill
			local prog, got = SACH.Get(ply, ACHName9)
			SACH.Update(ply, ACHName9, prog + 1)
			
		elseif (tot == 8) then --holyshit
			local prog, got = SACH.Get(ply, ACHName8)
			SACH.Update(ply, ACHName8, prog + 1)
			
		elseif (tot == 7) then --monsterkill
			local prog, got = SACH.Get(ply, ACHName7)
			SACH.Update(ply, ACHName7, prog + 1)
			
		elseif (tot == 6) then --killingspree
			local prog, got = SACH.Get(ply, ACHName6)
			SACH.Update(ply, ACHName6, prog + 1)
			
		elseif (tot == 5) then --multikill
			local prog, got = SACH.Get(ply, ACHName5)
			SACH.Update(ply, ACHName5, prog + 1)
			
		elseif (tot == 4) then --rampage
			local prog, got = SACH.Get(ply, ACHName4)
			SACH.Update(ply, ACHName4, prog + 1)
			
		elseif (tot == 3) then --triplekill
			local prog, got = SACH.Get(ply, ACHName3)
			SACH.Update(ply, ACHName3, prog + 1)
			
		elseif (tot == 2) then --doublekill
			local prog, got = SACH.Get(ply, ACHName2)
			SACH.Update(ply, ACHName2, prog + 1)
		end
	end
	
	function SACH.ACH_HoleInOne(ply,vic)
		if not (IsValid(ply) and IsValid(vic)) then return end
		local prog,got = SACH.Get(ply, ACHName)
		SACH.Update(ply, ACHName, prog + 1)
		
		local prog,got = SACH.Get(vic, ACHNameB)
		SACH.Update(vic, ACHNameB, prog + 1)
		
		
		local prog,got = SACH.Get(ply, ACHNameH2)
		SACH.Update(ply, ACHNameH2, prog + 1)
	end
	
	function SACH.ACH_IOU(killer,vic)
		local prog,got = SACH.Get(killer, ACHNameH3)
		SACH.Update(killer, ACHNameH3, prog + 1)
		
		local prog,got = SACH.Get(vic, ACHNameH4)
		SACH.Update(vic, ACHNameH4, prog + 1)
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHNameB, DescB, IcoYesB, AmtAmt, Amt)
SACH.Register(ACHNameH2, DescH2, IcoYesH2, AmtAmtH2, AmtH2)
SACH.Register(ACHNameH3, DescH3, IcoYesH3, AmtAmt, Amt)
SACH.Register(ACHNameH4, DescH4, IcoYesH4, AmtAmt, Amt)

SACH.Register(ACHName2, Desc2, IcoYes2, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt, Amt)
SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)
SACH.Register(ACHName5, Desc5, IcoYes5, AmtAmt, Amt)
SACH.Register(ACHName6, Desc6, IcoYes6, AmtAmt, Amt)
SACH.Register(ACHName7, Desc7, IcoYes7, AmtAmt, Amt)
SACH.Register(ACHName8, Desc8, IcoYes8, AmtAmt, Amt)
SACH.Register(ACHName9, Desc9, IcoYes9, AmtAmt, Amt)
SACH.Register(ACHName10, Desc10, IcoYes10, AmtAmt, Amt)
SACH.Register(ACHName11, Desc11, IcoYes11, AmtAmt, Amt)
SACH.Register(ACHName12, Desc12, IcoYes12, AmtAmt, Amt)















