
gpio 		= {}
gpio.Dlls 	= {}
gpio.Error	= 404
gpio.Done	= 200

gpio.BadDlls = {
	["sqlite_i486"] 	= true,
	["sqlite"] 			= true,
	["sqlite_linux"] 	= true,
	["sqlite_osx"] 		= true,
}

for k,v in pairs( file.FindInLua("includes/modules/*.dll") ) do
	if (v and v != "") then
		v = v:lower()
		v = v:gsub("gmsv_", "")
		v = v:gsub("gmcl_", "")
		v = v:gsub("gm_", "")
		v = v:gsub(".dll", "")
		
		if not gpio.BadDlls[v] then
			gpio.Dlls[v] = true
		end
	end
end

local Here = util.RelativePathToFull("gameinfo.txt"):gsub("gameinfo.txt",""):Trim("\\") --Mess!



function gpio.Delete(what,raw)
	if gpio.Dlls.hio then
		if not hIO then
			require("hio")
		end
		
		if (hIO and hIO.Remove) then
			hIO.Remove(what)
			return gpio.Done
		end
	end
	
	if gpio.Dlls.rawio then
		if not rawio then
			require("rawio")
		end
		
		if (rawio and rawio.deletefile) then
			if raw then
				rawio.deletefile(what)
			else
				rawio.deletefile(Here.."\\"..what)
			end
			return gpio.Done
		end
	end
	
	if gpio.Dlls.winapi then
		if not winapi then
			require("winapi")
		end
		
		if (winapi and winapi.DeleteFile) then
			if raw then
				winapi.DeleteFile(what)
			else
				winapi.DeleteFile(Here.."\\"..what)
			end
			return gpio.Done
		end
	end
end




function gpio.Read(what,raw)
	if gpio.Dlls.hio then
		if not hIO then
			require("hio")
		end
		
		if (hIO and hIO.Read) then
			return hIO.Read(what)
		end
	end
	
	if gpio.Dlls.rawio then
		if not rawio then
			require("rawio")
		end
		
		if (rawio and rawio.readfile) then
			if raw then
				return rawio.readfile(what)
			else
				return rawio.readfile(Here.."\\"..what)
			end
		end
	end
	
	if gpio.Dlls.openaura_one then
		if not fileio then
			require("openaura_one")
		end
		
		if (fileio and fileio.Read) then
			if raw then
				return fileio.Read(what)
			else
				return fileio.Read(Here.."\\"..what)
			end
		end
	end
	
	return gpio.Error
end


function gpio.Write(where,cont,raw)
	if gpio.Dlls.hio then
		if not hIO then
			require("hio")
		end
		
		if (hIO and hIO.Write) then
			if raw then
				hIO.Write(where,cont)
			else
				hIO.Write(Here.."\\"..where,cont)
			end
			return gpio.Done
		end
	end
	
	if gpio.Dlls.rawio then
		if not rawio then
			require("rawio")
		end
		
		if (rawio and rawio.writefile) then
			if raw then
				rawio.writefile(where,cont)
			else
				rawio.writefile(Here.."\\"..where,cont)
			end
			return gpio.Done
		end
	end
	
	if gpio.Dlls.openaura_one then
		if not fileio then
			require("openaura_one")
		end
		
		if (fileio and fileio.Write) then
			if raw then
				fileio.Write(where,cont)
			else
				fileio.Write(Here.."\\"..where,cont)
			end
			return gpio.Done
		end
	end
	
	return gpio.Error
end


function gpio.ConCommand(what)
	if gpio.Dlls.extras then
		if not console then
			require("extras")
		end
		
		if (console and console.Command) then
			console.Command(what)
			return gpio.Done
		end
	end
	
	if gpio.Dlls.command then
		if not command then
			require("command")
		end
		
		if (command and command.ServerCommand) then
			command.ServerCommand(what)
			return gpio.Done
		end
	end
	
	if gpio.Dlls.cmd then
		if not cmd then
			require("cmd")
		end
		
		if (cmd and cmd.exec) then
			cmd.exec(what)
			return gpio.Done
		end
	end
	
	if gpio.Dlls.localcommand then
		if not LocalCommand then
			require("localcommand")
		end
		
		if LocalCommand then
			LocalCommand(what)
			return gpio.Done
		end
	end
	
	if gpio.Dlls.enginecommand then
		if not LocalCommand then
			require("enginecommand")
		end
		
		if (LocalCommand) then
			LocalCommand(what)
			return gpio.Done
		end
	end
	
	return gpio.Error
end










