




local Hight = ScrH() - 20

local function ScreenLogger()
	if client.IsTakingScreenshot() then
		if not _G.SRVLog then return end
		
		local LogStr = _G.SRVLog:gsub("\n", " | ")
		
		draw.SimpleText(LogStr, "TabLarge", 10, Hight, RED)
	end
end
hook.Add("HUDPaint", "ScreenLogger", ScreenLogger)




