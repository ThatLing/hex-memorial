


function GKFix(uid,str)
	RunConsoleCommand("kickid", uid, str)
end


hook.Add("Think", "GKFix", function()
	if gatekeeper then
		if (gatekeeper.Drop and (gatekeeper.Drop != GKFix) ) then
			gatekeeper.Drop = GKFix
			print("!\nGKFix loaded\n")
		end
	end
end)




