

local CVar 	= "hsp_filter_sound" --"flt_sound"
local CanDo = false

hook.Add("OnLoadingStopped", "CheckFilter", function()
	timer.Simple(8, function()
		if CanDo and (ConVarExists(CVar) and GetConVarString(CVar)) then
			surface.PlaySound("ambient/machines/thumper_shutdown1.wav")
			
			print("\n\nSimpleFilter is on this server, getting log..\n")
			console.Command("flt_download")
			
			timer.Simple(10, function()
				--console.Command("flt_clear")
				surface.PlaySound("ambient/machines/thumper_shutdown1.wav")
				print("\n\nSimpleFilter up to date\n")
			end)
		end
	end)
end)

hook.Add("OnLoadingStarted", "CheckFilter", function()
	CanDo = true
end)

hook.Add("OnDisconnectFromServer", "CheckFilter", function()
	CanDo = false
end)





