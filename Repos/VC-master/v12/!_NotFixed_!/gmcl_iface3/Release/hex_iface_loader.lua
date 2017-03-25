

print("! CLIENT: ", CLIENT, ", MENU: ", MENU, " iface3: ", iface3)


function _G.HeXInclude(path)
	local tmp = "lua/"..path
	if file.Exists(tmp,true) then
		iface3.SetRunString( path:gsub("/", "\\") )
		
		iface3.RunString( file.Read(tmp, true, true) )
		--RunString( file.Read(tmp, true, true) )
	else
		print("! gone: ", tmp)
	end
end


print("! here goes..")
timer.Simple(1.5, function()
	print("! load now!")
	_G.HeXInclude("hex_loader.lua")
end)







