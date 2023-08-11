HeX.Detour = {
	Saved = {}
}

local function Source(func)
	return debug.getinfo(func).short_src
end

function HeX.Detour.Player(func,new)
	if _R.Player[func.."Old"] then
		ErrorNoHalt( Format("Tried to detour 'Player.%s' from: %s\n", func, Source(new)) )
	else
		_R.Player[func.."Old"] = _R.Player[func]
		
		table.insert(HeX.Detour.Saved, {name = "Player."..func, old = _R.Player[func], new = new, src = Source(new)} )
		
		_R.Player[func] = new
	end
end

function HeX.Detour.Dump(ply,cmd,args)
	if not ply:IsSuperAdmin() then return end
	
	for k,v in pairs( HeX.Detour.Saved ) do
		print("! func,old,new: ", v.name, Source(v.old), Source(v.new) )
	end
end
concommand.Add("hex_detours_dump", HeX.Detour.Dump)