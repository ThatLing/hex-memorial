

GREEN	= Color(66,255,96)		--HSP green
SGREEN	= Color(180,250,160)	--source green
GREEN2	= Color(0,255,0)
LtGreen	= Color(174,255,0)
WHITE	= Color(255,255,255)	--white
RED		= Color(255,0,11)		--red
RED2	= Color(255,0,0)		--More red
KIRED	= Color(255,80,0,255)
BLUE	= Color(51,153,255)		--HeX Blue
LPBLUE	= Color(80,170, 255)	--Laser pistol blue
YELLOW	= Color(255,200,0,255)	--yellow
YELLOW2	= Color(255,220,0,200)	--HEV yellow
PINK	= Color(255,0, 153)		--faggot pink
PBLUE	= Color(155,205,248)	--printall blue
PURPLE	= Color(149,102,255)	--ASK2 purple
ORANGE	= Color(255,153,0)		--respected orange
GREY	= Color(175,175,175)	--blackops grey
KCHEAT	= Color(249,199,255)

TRUE	= function() return true end
FALSE 	= function() return false end
Useless	= function() end

local ToSet = {
	NotCCC	= CreateClientConVar,
	NotRCC	= RunConsoleCommand,
	NotGCV	= GetConVar,
	NotFFIL	= file.FindInLua,
	NotFF	= file.Find,
	NotFD	= file.Delete,
	NotDGI	= debug.getinfo,
	NotCCA	= concommand.Add,
}
for k,v in pairs(ToSet) do
	if not _G[k] then
		_G[k] = v
	end
end


function HeX.MyCall(lev)
	local DGI = NotDGI(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
function HeX.FPath(func)
	local What = type(func)
	if not (What == "function") then return What,0 end
	local DGI = NotDGI(func)
	if not DGI then return "Gone",0 end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end


--- === If anyone ever reads this, these are NOT for hacking since it's pointless. They are for idiot servers and garry's fuckups === ---
HeX.Detour = {
	Saved = {}
}

function HeX.Detour.Meta(lib,func,new)
	if not (lib and func and new) then
		error("Missing args from HeX.Detour.Meta(lib,func,new)", 2)
	end
	
	if not _R[lib][func] then
		error("Missing table, '_R."..lib.."."..func.."' doesn't exist", 2)
	end
	
	if _R[lib][func.."Old"] then
		_R[lib][func] = _R[lib][func.."Old"]
		_R[lib][func.."Old"] = nil
		HeX.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HeX.FPath(new)) )
	end
	
	HeX.Detour.Saved[lib.."."..func] = {old = _R[lib][func], new = new}
	_R[lib][func.."Old"] = _R[lib][func]
	_R[lib][func] = new
end
--[[
HeX.Detour.Meta("Player", "PrintMessage", function(new) end)

HeX.Detour.Meta("bf_read", "ReadString", function(new) end)
]]

function HeX.Detour.Global(lib,func,new)
	if not (lib and func and new) then
		error("Missing args from HeX.Detour.Global(lib,func,new)", 2)
	end
	
	local where = lib
	if where == "_G" then
		where = _G
	else
		where = _G[where]
	end
	
	if not where then --Table doesn't exists in _G
		error("Missing table, '_G."..lib.."."..func.."' doesn't exist", 2)
	end
	
	if where[func.."Old"] then
		where[func] = where[func.."Old"]
		where[func.."Old"] = nil
		HeX.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HeX.FPath(new)) )
	end
	
	HeX.Detour.Saved[lib.."."..func] = {old = where[func], new = new}
	where[func.."Old"] = where[func]
	where[func] = new
end

--[[
HeX.Detour.Global("os", "date", function(new) end)

HeX.Detour.Global("_G", "PrintMessage", function(new) end)
]]


if (SERVER) then
	function HeX.Detour.DumpSV(ply,cmd,args)
		for k,v in pairs( HeX.Detour.Saved ) do
			print("! func,old,new: ", k, HeX.FPath(v.old), HeX.FPath(v.new) )
		end
	end
	concommand.Add("hex_dump_detours_sv", HeX.Detour.DumpSV)
end

if (CLIENT) then
	function HeX.Detour.DumpCL(ply,cmd,args)
		for k,v in pairs( HeX.Detour.Saved ) do
			print("! func,old,new: ", k, HeX.FPath(v.old), HeX.FPath(v.new) )
		end
	end
	concommand.Add("hex_dump_detours_cl", HeX.Detour.DumpCL)
	
	
	function COLCON(...)
		if fuckup then
			for k,v in pairs( {...} ) do
				if ( type(v) == "string" ) then
					Msg(v)
				end
			end
			Msg("\n")
			return
		end
		
		local color = color_white
		for k,v in pairs( {...} ) do
			local typ = type(v)
			
			if (typ == "table" && v["b"] && v["g"] && v["r"]) then
				color = v
			elseif (typ == "Player" and IsValid(v)) then
				console.PrintColor(team.GetColor(v:Team()), v:GetName())
			elseif ((typ == "Entity" or typ == "Weapon" or typ == "Vehicle" or typ == "NPC") and IsValid(v)) then
				console.PrintColor(EntityColor, v:GetClass())
			else
				console.PrintColor(color, tostring(v))
			end
		end
		console.PrintColor(color, "\n")
	end
	
	function HeXLRCL(str)
		if fuckup then
			print("! HeXLRCL compat: ", str)
			LocalPlayer():ConCommand(str)
			return
		end
		
		console.Command(str)
	end
	
	function HeX.SetupGlobals()
		RunConsoleCommand("hostname", GetHostName() )
		RunConsoleCommand("hostip", client.GetIP() )
	end
	hook.Add("InitPostEntity", "!HeX.SetupGlobals", HeX.SetupGlobals)
	if iface3 then
		timer.Simple(0.1, HeX.SetupGlobals)
	end
	
	
	
	local ToPrint	= {}
	local Done		= false
	function printDelay(what)
		if Done then
			return print(what)
		end
		ToPrint[what] = true
	end
	
	local function PrintSaved()
		Done = true
		for k,v in pairs(ToPrint) do
			print(k)
		end
	end
	timer.Simple(0.1, PrintSaved)
end





