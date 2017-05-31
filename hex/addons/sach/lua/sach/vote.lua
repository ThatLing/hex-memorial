
----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Ones and Twos"
local Desc		= "Start a vote"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vote/checkLarge"

local ACHName2	= "Oh yes!"
local Desc2		= "Vote YES in a vote!"

local ACHName3	= "Fuck that"
local Desc3		= "Vote NO in a vote!"
local IcoYes3	= "vote/crossLarge"

local ACHName4	= "This map sucks"
local Desc4		= "Open the /maps menu!"
local IcoYes4	= "vote/crossLarge"

if SERVER then
	resource.AddFile("materials/vote/checkLarge.vmt")
	resource.AddFile("materials/vote/checkLarge.vtf")
	
	resource.AddFile("materials/vote/crossLarge.vmt")
	resource.AddFile("materials/vote/crossLarge.vtf")
	
	function SACH.ACH_StartVote(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName)
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	
	function SACH.ACH_Vote(ply,vote)
		if IsValid(ply) then
			if vote == true then
				local prog, got = SACH.Get(ply, ACHName2)
				SACH.Update(ply, ACHName2, prog + 1)
			else
				local prog, got = SACH.Get(ply, ACHName3)
				SACH.Update(ply, ACHName3, prog + 1)
			end
		end
	end
	
	function SACH.ACH_MapMenu(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName4)
			SACH.Update(ply, ACHName4, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt, Amt)

SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)













----------------------------------------
--         2014-07-12 20:33:19          --
------------------------------------------


local ACHName	= "Ones and Twos"
local Desc		= "Start a vote"
local AmtAmt	= ""
local Amt		= 1
local IcoYes	= "vote/checkLarge"

local ACHName2	= "Oh yes!"
local Desc2		= "Vote YES in a vote!"

local ACHName3	= "Fuck that"
local Desc3		= "Vote NO in a vote!"
local IcoYes3	= "vote/crossLarge"

local ACHName4	= "This map sucks"
local Desc4		= "Open the /maps menu!"
local IcoYes4	= "vote/crossLarge"

if SERVER then
	resource.AddFile("materials/vote/checkLarge.vmt")
	resource.AddFile("materials/vote/checkLarge.vtf")
	
	resource.AddFile("materials/vote/crossLarge.vmt")
	resource.AddFile("materials/vote/crossLarge.vtf")
	
	function SACH.ACH_StartVote(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName)
			SACH.Update(ply, ACHName, prog + 1)
		end
	end
	
	function SACH.ACH_Vote(ply,vote)
		if IsValid(ply) then
			if vote == true then
				local prog, got = SACH.Get(ply, ACHName2)
				SACH.Update(ply, ACHName2, prog + 1)
			else
				local prog, got = SACH.Get(ply, ACHName3)
				SACH.Update(ply, ACHName3, prog + 1)
			end
		end
	end
	
	function SACH.ACH_MapMenu(ply)
		if IsValid(ply) then
			local prog, got = SACH.Get(ply, ACHName4)
			SACH.Update(ply, ACHName4, prog + 1)
		end
	end
end

SACH.Register(ACHName, Desc, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName2, Desc2, IcoYes, AmtAmt, Amt)
SACH.Register(ACHName3, Desc3, IcoYes3, AmtAmt, Amt)

SACH.Register(ACHName4, Desc4, IcoYes4, AmtAmt, Amt)












