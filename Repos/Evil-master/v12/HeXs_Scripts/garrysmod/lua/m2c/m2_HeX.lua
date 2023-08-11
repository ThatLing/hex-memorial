

iface3 = true


function _G.HeXInclude(path)
	local tmp = "lua/"..path
	if file.Exists(tmp,true) then
		if m2c then
			m2c.RunString( file.Read(tmp, true) )
		else
			RunString( file.Read(tmp, true) )
		end
	else
		print("! gone: ", tmp)
	end
end

if not HeXLoaded then
	HeXLoaded = true
	_G.HeXInclude("hex_loader.lua")
end













