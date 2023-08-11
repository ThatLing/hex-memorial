if CLIENT then return end

--use for medkits etc? resspawning?
-- v.IsAutoSpawn = true

local HeXLRCL	= HeXLRCL	or function(str) LocalPlayer():ConCommand(str) end
local SavePath = "HeXSave"
--local CurMap = game.GetMap():lower()

concommand.Add("ls_save", function(ply,cmd,args)
	if not ply and ply:Valid() then return end
	if not ply:IsAdmin() then
		MsgN("[HeX] 401 You are not an admin!, bugger off!")
		return
	end
	local SaveName = args[1] or "temp"
	--SaveName = CurMap.."_"..SaveName
	
	if (SaveName == "temp") and #file.Find(SavePath.."/temp.txt") > 0 then
		file.Delete(SavePath.."/temp.txt")
	end
	if #file.Find(SavePath.."/"..SaveName..".txt") > 0 then
		--file.Delete(SavePath.."/"..SaveName..".txt")
		--file.Rename(SavePath.."/"..SaveName..".txt", SavePath.."/"..SaveName.."_2.txt")
		SaveName = SaveName.."_2"
	end

	file.Write( SavePath.."/"..SaveName..".txt", gmsave.SaveMap(ply) )
	
	if (SaveName == "temp") then
		MsgN("[HeX] 200 Saved: Temp file")
	else
		MsgN("[HeX] 200 Saved: ", SaveName)
	end
end)

concommand.Add("ls_load", function(ply,cmd,args)
	if not ply and ply:Valid() then return end
	if not ply:IsAdmin() then
		MsgN("[HeX] 401 You are not an admin!, bugger off!")
		return
	end
	local LoadName = args[1] or "temp"
	
	if #file.Find(SavePath.."/"..LoadName..".txt") > 0 then
		gmsave.LoadMap( file.Read(SavePath.."/"..LoadName..".txt"), ply )
		MsgN("[HeX] 200 loaded: ", LoadName)
		return
	else
		if (LoadName == "temp") then
			MsgN("[HeX] 404 Can't load: Temp file")
		else
			MsgN("[HeX] 404 Can't load: ", LoadName)
		end
		return
	end
end)

concommand.Add("ls_list", function(ply,cmd,args)
	if not ply and ply:Valid() then return end
	if not ply:IsAdmin() then
		MsgN("[HeX] 401 You are not an admin!, bugger off!")
		return
	end
	
	MsgN("Saved Files:")
	MsgN("===================")
	if #file.Find(SavePath.."/*.txt") > 0 then
		local Entry
		for k,v in pairs(file.Find(SavePath.."/*.txt")) do
			Entry = v:gsub(".txt", "") --returns "1" at the end otherwise.
			MsgN("	", Entry)
		end
	else
		MsgN("404 No files")
	end
	MsgN("===================")
	MsgN("[HeX] 200 OK!")
end)





