

local IFaceString	= "gamemodes\\base\\gamemode\\cl_init.lua"
IFaceString			= IFaceString:gsub("\\","/")

local NotDGE		= debug.getinfo
local NotDGU 		= debug.getupvalue
local NotFR 		= file.Read
local NotRPF		= util.RelativePathToFull
local NotPC			= pcall
local NotSMT		= setmetatable
local NotRQ			= require
local NotRS			= RunString
local NotECC		= engineConsoleCommand

local NotHook 			= nil
local NotCC				= nil


local function MyCall(lev)
	local DGI = NotDGE(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
local function HeXFile(path)
	path = path:lower()
	return (path:find("hex") or path:find("menu_plugins") or path:find("custom_menu"))
end




function file.Read(path,bool,bin)
	if not path then return end
	local call,line = MyCall()
	
	if HeXFile(path) and (call != IFaceString) then
		print("! NotFR: ", path, bool, call,line)
		return "print('Hax that hax you back!')"
	end
	
	return NotFR(path,bool,bin)
end

function util.RelativePathToFull(path)
	if not path then return end
	
	print("! NotRPF: ", MyCall() )
	
	return "C:\\steam\\steamapps\\Hax_That_Hax_You_Back\\garrysmod\\garrysmod\\"..path
end


local DoneHook	= false
local DoneCmd	= false
local DoneTimer	= false


function require(mod)
	if mod == "hook" or mod == "concommand" or mod == "timer" then
		if not hook and not DoneHook then
			DoneHook = true
			NotRQ("hook")
		end
		if not concommand and not DoneCmd then
			DoneCmd = true
			NotRQ("concommand")
		end
		if not timer and not DoneTimer then
			DoneTimer = true
			NotRQ("timer")
		end
		
		NotHook 		= hook
		NotCC			= concommand
	end
	
	return NotRQ(mod)
end



function setmetatable(tab,what)
	local call,line = MyCall()
	local low = call:lower()
	
	if (low:find("enum") or low:find("includes/init")) then
		print("! setmetatable, AC! returning nothing, re-adding globals: ", call)
		
		_G.hook					= NotHook
		_G.concommand			= NotCC
		_G.engineConsoleCommand	= NotECC
		_G.require				= NotRQ
	end
	
	return NotSMT(tab,what)
end


function debug.getupvalue(func,val)
	if not func then
		error("bad argument #2 to '?' (number expected, got no value)")
		--ErrorNoHalt("bad argument #2 to '?' (number expected, got no value)")
	end
	
	if (func == setmetatable or func == NotSMT) then
		print("! DGU: setmetatable, sending nil")
		return
	end
	if (func == debug.getinfo or func == NotDGE) then
		print("! DGU: debug.getinfo, sending nil")
		return
	end
	if (func == file.Read or func == NotFR) then
		print("! DGU: file.Read, sending nil")
		return
	end
	if (func == util.RelativePathToFull or func == NotRPF) then
		print("! DGU: util.RelativePathToFull, sending nil")
		return
	end
	if (func == debug.getupvalue or func == NotDGU) then
		print("! DGU: debug.getupvalue, sending nil")
		return
	end
	if (func == pcall or func == NotPC) then
		print("! DGU: pcall, sending nil")
		return
	end
	if (func == require or func == NotRQ) then
		print("! DGU: require, sending nil")
		return
	end
	
	return NotDGU(func,val)
end


function pcall(...)
	local newargs = {}
	
	for k,v in ipairs( {...} ) do
		if type(v) == "function" then
			if v == debug.getinfo then
				print("! pcall: debug.getinfo, switching")
				v = NotDGE
				
			elseif v == file.Read then
				print("! pcall: file.Read, switching")
				v = NotFR
				
			elseif v == setmetatable then
				print("! pcall: setmetatable, switching")
				v = NotSMT
				
			elseif v == util.RelativePathToFull then
				print("! pcall: util.RelativePathToFull, switching")
				v = NotRPF
				
			elseif v == debug.getupvalue then
				print("! pcall: debug.getupvalue, switching")
				v = NotDGU
				
			elseif v == require then
				print("! pcall: require, switching")
				v = NotRQ
			end
		end
		
		newargs[k] = v
	end
	
	if (#newargs == 0) then
		return NotPC(...)
	end
	return NotPC( unpack(newargs) )
end



function debug.getinfo(stuff,thing)
	if not stuff then
		error("bad argument #2 to '?' (number expected, got no value)")
		--ErrorNoHalt("bad argument #2 to '?' (number expected, got no value)")
	end
	
	local typ = type(stuff)
	if typ == "function" then
		if (stuff == debug.getinfo or stuff == NotDGE) then
			print("! debug.getinfo, debug.getinfo: ", MyCall() )
			return NotDGE( NotDGE )
			
		elseif (stuff == file.Read or stuff == NotFR) then
			print("! debug.getinfo, file.Read: ", MyCall() )
			return NotDGE( NotFR )
			
		elseif (stuff == util.RelativePathToFull or stuff == NotRPF) then
			print("! debug.getinfo, util.RelativePathToFull: ", MyCall() )
			return NotDGE( NotRPF )
			
		elseif (stuff == pcall or stuff == NotPC) then
			print("! debug.getinfo, pcall: ", MyCall() )
			return NotDGE( NotPC )
			
		elseif (stuff == setmetatable or stuff == NotSMT) then
			print("! debug.getinfo, setmetatable: ", MyCall() )
			return NotDGE( NotSMT )
			
		elseif (stuff == debug.getupvalue or stuff == NotDGU) then
			print("! debug.getinfo, debug.getupvalue: ", MyCall() )
			return NotDGE( NotDGU )
		end
		
		
	elseif typ == "number" then
		--print("! debug.getinfo, number: ", stuff, "sending: ", stuff + 1)
		stuff = stuff + 1
	end
	
	return NotDGE(stuff,thing)
end











