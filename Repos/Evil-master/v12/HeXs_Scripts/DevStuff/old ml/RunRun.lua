
function RunRun(tab)
	local TotalRun	= 0
	local Total		= #tab
	
	for k,v in ipairs(tab) do
		timer.Simple(k/8, function()
			HeXLRCL( Format([[replay_tip %s]], v) )
			
			TotalRun = TotalRun + 1
			if (TotalRun == Total) then
				print("\n! RunRun sent all #"..Total.." commands!\n")
			else
				print("! RunRun: Sending cmd #"..TotalRun.."/"..Total.."..")
			end
		end)
	end
end


