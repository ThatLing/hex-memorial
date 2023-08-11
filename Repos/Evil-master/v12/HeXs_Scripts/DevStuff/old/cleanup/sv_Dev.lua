


function DevGAN(p,c,a)
	timer.Simple(a[1] or 0, function()
		GAMEMODE:AddNotify("Test Lol", 1, 8)
		surface.PlaySound("npc/roller/mine/rmine_predetonate.wav")
	end)
end
concommand.Add("gan_dev", DevGAN)



--[[
local function dupe(p,c,a)
	AdvDupeClient.LoadListDirs["/.."] = dupeshare.BaseDir
	
	AdvDupeClient.LoadListDirs["/.."] = "ulx_logs"
	AdvDupeClient.LoadListFiles = {}
	print(dupeshare.ParsePath("ULib"))
	
	AdvDuplicator_UpdateControlPanel()
end
concommand.Add("dupe_1", dupe)
]]




