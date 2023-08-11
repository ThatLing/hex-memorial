

HeX.GetTable = {}
function HeX.Add(what,name,func)
	local GAME = GAMEMODE
	if not GAME then
		print("! oops, GAMEMODE")
		GAME = GM
	end
	if not GAME then
		print("! oops, no GM")
		hook.Add(what,name,func)
		return
	end
	
	local OldHook = GAME[what]
	function GAME[what](self,...)
		if OldHook then
			OldHook(self,...)
		end
		func(...)
	end
	
	if not HeX.GetTable[what] then
		HeX.GetTable[what] = {}
	end
	HeX.GetTable[what][name] = func
end





function HeX.Add(what,name,func)
    local ogm = GAMEMODE[what]
    function GAMEMODE[what](gm,...)
        local a,b,c, = hook.Call(what, nil , ...)
        if a ~= nil or b~= nil or c~= nil then
            return a,b,c,
        else
            return ogm(gm,...)
        end
    end
end


HeX.Add("HUDPaint", "loool", function() ESP() end)





