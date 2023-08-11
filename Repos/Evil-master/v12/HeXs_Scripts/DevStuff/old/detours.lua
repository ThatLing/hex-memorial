



function HeX.Detour.Meta(lib,func,new)
	if _R[lib][func.."Old"] then
		_R[lib][func] = _R[lib][func.."Old"]
		_R[lib][func.."Old"] = nil
		HeX.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HeX.FPath(new)) )
	end
	
	HeX.Detour.Saved[lib.."."..func] = {old = _R[lib][func], new = new, src = HeX.FPath(new)}
	_R[lib][func.."Old"] = _R[lib][func]
	_R[lib][func] = new
end

HeX.Detour.Meta("Player", "PrintMessage", function(new) end)

HeX.Detour.Meta("bf_read", "ReadString", function(new) end)



function HeX.Detour.Global(lib,func,new)
	local where = lib
	if where == "_G" then
		where = _G
	else
		where = _G[where]
	end
	
	if where[func.."Old"] then
		where[func] = where[func.."Old"]
		where[func.."Old"] = nil
		HeX.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HeX.FPath(new)) )
	end
	
	HeX.Detour.Saved[lib.."."..func] = {old = where[func], new = new, src = HeX.FPath(new)}
	where[func.."Old"] = where[func]
	where[func] = new
end


HeX.Detour.Global("os", "date", function(new) end)

HeX.Detour.Global("_G", "PrintMessage", function(new) end)






