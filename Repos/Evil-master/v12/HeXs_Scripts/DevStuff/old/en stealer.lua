

if (#file.FindInLua("includes/modules/gm_hio.dll") > 0) then
	require("hio")
end
local GetSendLua = false
local GetSendLua = true

local Format = Format
local string = string
local file = file

local function WriteFile(Filename,Cont)
	if not (hIO) then
		return file.Write(Filename, Cont)
	end
	
	local HFileName	= string.gsub(Filename, ".txt",".lua")
	
	if (hIO) and file.Exists(HFileName) then
		hIO.Remove(Format("%s/data/%s", ModDIR, HFileName))
	end
	if file.Exists(Filename) then
		file.Delete(Filename)
	end	
	
	file.Write(Filename, Cont)
	
	if (hIO) then
		hIO.Rename( Format("%s/data/%s", ModDIR, Filename),Format("%s/data/%s", ModDIR, HFileName) )
	end
end

local function ExistsFile(Filename)
	if not (hIO) then
		return file.Exists(Filename)
	end
	
	local HFileName	= string.gsub(Filename, ".txt",".lua")
	
	return file.Exists(HFileName)
end



if (#file.FindInLua("includes/modules/gm_preproc.dll") > 0) then
	require("hook")
	require("preproc")

	hook.Add("Lua_Preprocess", "LuaHook", function(name, path, lua)
		if name == "LuaCmd" and GetSendLua then
			file.Append("datapack/lua_run.txt", lua)
			print("! lua_run: ", lua)
			return
		end
		
		if GetLua then
			name = string.gsub(name, ".lua", ".txt")
			name = "datapack/"..name
			
			if not ExistsFile(name) then
				WriteFile(name, lua)
				print("! got: ", name)
			end
		end
	end)
end



