
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------


if (SERVER) then
	AddCSLuaFile("autorun/sh_ScoreBoard.lua")
	
	AddCSLuaFile("UH_ScoreBoard/player_frame.lua")
	AddCSLuaFile("UH_ScoreBoard/player_row.lua")
	AddCSLuaFile("UH_ScoreBoard/scoreboard.lua")
end



if (CLIENT) then
	include("UH_ScoreBoard/scoreboard.lua")
	UH_ScoreBoard = nil
	
	
	local function UH_ScoreBoard_Show()
		if not UH_ScoreBoard then
			--UH_ScoreBoard:Remove()
			UH_ScoreBoard = vgui.Create("ScoreBoard")
		end
		
		gui.EnableScreenClicker(true)
		UH_ScoreBoard:SetVisible(true)
		UH_ScoreBoard:UpdateScoreboard(true)
		
		return true
	end
	hook.Add("ScoreboardShow", "UH_ScoreBoard_Show", UH_ScoreBoard_Show)
	
	
	local function UH_ScoreBoard_Hide()
		if not UH_ScoreBoard then
			UH_ScoreBoard = vgui.Create("ScoreBoard")
		end
		
		gui.EnableScreenClicker(false)
		UH_ScoreBoard:SetVisible(false)
		
		return true
	end
	hook.Add("ScoreboardHide", "UH_ScoreBoard_Hide", UH_ScoreBoard_Hide)
	
	
	
	
	function FixScoreBoard()
		hook.Add("ScoreboardShow", "UH_ScoreBoard_Show", UH_ScoreBoard_Show)
		hook.Add("ScoreboardHide", "UH_ScoreBoard_Hide", UH_ScoreBoard_Hide)
	end
	
	timer.Create("FixScoreBoard", 1, 2, function()
		FixScoreBoard() --Why does this not work unless i load it twice!?
	end)
	
	print("[UH ScoreBoard] Crap scoreboard replaced!")
end






















----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------


if (SERVER) then
	AddCSLuaFile("autorun/sh_ScoreBoard.lua")
	
	AddCSLuaFile("UH_ScoreBoard/player_frame.lua")
	AddCSLuaFile("UH_ScoreBoard/player_row.lua")
	AddCSLuaFile("UH_ScoreBoard/scoreboard.lua")
end



if (CLIENT) then
	include("UH_ScoreBoard/scoreboard.lua")
	UH_ScoreBoard = nil
	
	
	local function UH_ScoreBoard_Show()
		if not UH_ScoreBoard then
			--UH_ScoreBoard:Remove()
			UH_ScoreBoard = vgui.Create("ScoreBoard")
		end
		
		gui.EnableScreenClicker(true)
		UH_ScoreBoard:SetVisible(true)
		UH_ScoreBoard:UpdateScoreboard(true)
		
		return true
	end
	hook.Add("ScoreboardShow", "UH_ScoreBoard_Show", UH_ScoreBoard_Show)
	
	
	local function UH_ScoreBoard_Hide()
		if not UH_ScoreBoard then
			UH_ScoreBoard = vgui.Create("ScoreBoard")
		end
		
		gui.EnableScreenClicker(false)
		UH_ScoreBoard:SetVisible(false)
		
		return true
	end
	hook.Add("ScoreboardHide", "UH_ScoreBoard_Hide", UH_ScoreBoard_Hide)
	
	
	
	
	function FixScoreBoard()
		hook.Add("ScoreboardShow", "UH_ScoreBoard_Show", UH_ScoreBoard_Show)
		hook.Add("ScoreboardHide", "UH_ScoreBoard_Hide", UH_ScoreBoard_Hide)
	end
	
	timer.Create("FixScoreBoard", 1, 2, function()
		FixScoreBoard() --Why does this not work unless i load it twice!?
	end)
	
	print("[UH ScoreBoard] Crap scoreboard replaced!")
end





















