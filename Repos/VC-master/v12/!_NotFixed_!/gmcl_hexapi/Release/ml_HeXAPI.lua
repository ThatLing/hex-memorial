

if not hexapi then
	require("hexapi")
end


local HeXInclude = [[
iface3 = true

function HeXInclude(path)
	local tmp = "lua/"..path
	
	if file.Exists(tmp,true) then
		local Cont = file.Read(tmp, true)
		if not Cont then
			return print("! no contents for: ", tmp)
		end
		
		if hexapi then
			hexapi.RunString(Cont)
		else
			RunString(Cont)
		end
	else
		print("! gone: ", tmp)
	end
end

timer.Simple(1, function()
	HeXInclude("hex_loader.lua")
end)
]]


local function HeXLoadAPI(ply,cmd,args)
	hexapi.SetGlobals()
	
	timer.Simple(1, function()
		hexapi.RunString([[require("extras")]]) --Wait!
		
		timer.Simple(1, function()
			hexapi.RunString(HeXInclude)
		end)
	end)
end
concommand.Add("hex_loadme", HeXLoadAPI)







