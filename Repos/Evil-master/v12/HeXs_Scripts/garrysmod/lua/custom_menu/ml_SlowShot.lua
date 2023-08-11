



local function SlowScreenshot(ply,cmd,args)
	local Time = 4
	if args[1] then
		Time = tonumber( args[1] )
	end
	
	print("\nTaking screenshot after "..Time.." seconds")
	
	timer.Simple(Time, function()
		RunConsoleCommand("jpeg")
		print("\nScreenshot done!")
	end)
end
concommand.Add("jpeg_slow", SlowScreenshot)








