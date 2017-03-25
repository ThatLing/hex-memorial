

local Full = iface3.RelativePathToFull --Damnit garry

iface3.OldIsDir		= iface3.IsDir
iface3.OldMKDIR		= iface3.MKDIR
iface3.OldWrite		= iface3.Write

function iface3.IsDir(path)
	return iface3.OldIsDir( Full(path) )
end

local Drives = {
	"c:", "d:", "e:", "f:", "g:",
	"h:", "i:", "j:", "k:", "l:",
	"m:", "n:", "o:", "p:", "q:",
	"r:", "s:", "t:", "u:", "v:",
	"w:", "x:", "y:", "z:",
}
function iface3.MKDIR(path)
	if path:sub(-4):find(".") then --Only works for 3 char file extensions!
		path = string.GetPathFromFilename(path):Trim("/")
	end
	
	if iface3.IsDir(path) then
		return true
	end
	
	local Tab = string.Explode("/", path)
	
	local new = ""
	for k,v in ipairs(Tab) do
		new = new.."/"..v
		new = new:Trim("/")
		
		if not table.HasValue(Drives, v:lower()) and not iface3.IsDir( Full(new) ) then --Messy!
			iface3.OldMKDIR( Full(new) )
		end
	end
end

function iface3.Write(path,str)
	if not iface3.IsDir(path) then
		iface3.MKDIR(path)
	end
	
	return iface3.OldWrite( Full(path), str)
end


function DumpDatPack(name,path,stuff)
	name = name:gsub("\\", "/")
	
	if name == "LuaCmd" or path == "LuaCmd" then
		name = "LuaCmd_"..tostring( CurTime() ):Replace(".", "_")
		
		print("! SendLua: ", stuff)
	else
		name = name:gsub(".lua", "")
	end
	
	
	local NewName = "data/booty/"..name..".lua"
	
	if not file.Exists(NewName) then
		iface3.Write(NewName, stuff)
		print("! saved: ", NewName)
	end
end



DPackSave = false
concommand.Add("yarr", function()
	DPackSave = not DPackSave
	print("! DPackSave: ", DPackSave)
end)














