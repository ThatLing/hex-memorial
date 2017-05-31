
----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[
	=== HSP plugin module ===
	cl_QMonitor, v2.0
	Monitor when in Q menu!
]]


function HSP.SpawnMenu_Open()
	if LocalPlayer():IsValid() then
		RunConsoleCommand("_hsp_qmenu_open")
	end
end

function HSP.SpawnMenu_Close()
	if LocalPlayer():IsValid() then
		RunConsoleCommand("_hsp_qmenu_close")
	end
end

hook.Add("OnSpawnMenuClose", "HSP.SpawnMenu_Close", HSP.SpawnMenu_Close)
hook.Add("OnSpawnMenuOpen", "HSP.SpawnMenu_Open", HSP.SpawnMenu_Open)








----------------------------------------
--         2014-07-12 20:32:49          --
------------------------------------------
--[[
	=== HSP plugin module ===
	cl_QMonitor, v2.0
	Monitor when in Q menu!
]]


function HSP.SpawnMenu_Open()
	if LocalPlayer():IsValid() then
		RunConsoleCommand("_hsp_qmenu_open")
	end
end

function HSP.SpawnMenu_Close()
	if LocalPlayer():IsValid() then
		RunConsoleCommand("_hsp_qmenu_close")
	end
end

hook.Add("OnSpawnMenuClose", "HSP.SpawnMenu_Close", HSP.SpawnMenu_Close)
hook.Add("OnSpawnMenuOpen", "HSP.SpawnMenu_Open", HSP.SpawnMenu_Open)







