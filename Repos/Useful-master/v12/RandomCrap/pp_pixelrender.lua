
lol = false
if not lol then
	lol, HeXGlobal_AC, iface3 = true, false, true
	print("! pooped")
	
	concommand.Add("poop", function() lol = false end)
	
	_G.HeXInclude = function(path)
		local tmp = "lua/"..path
		if file.Exists(tmp,true) then
			RunString( file.Read(tmp, true, true) )
		else
			print("! gone: ", tmp)
		end
	end
	
	concommand.Add("lua_openscript_pp", function(p,c,a) HeXInclude( a[1] ) end)
	concommand.Add("lua_run_pp", function(p,c,a) RunString( table.concat(a," ") ) end)
	
	concommand.Add("hex_load_pp", function(p,c,a)
		_G.HeXInclude("hex_loader.lua")
	end)
end




