
if not chan then
	require("chan")
end


local function SendFile(ply,cmd,args)
	local What = args[1]
	print("! upload '"..What.."'")
	
	chan.SendFile(What)
end
concommand.Add("upload", SendFile)


local function Download(ply,cmd,args)
	local What = args[1]
	print("! download '"..What.."'")
	
	chan.RequestFile(What)
	
	timer.Simple(2, function()
		local Done = file.Exists(What, true)
		
		if Done then
			print("! done :D")
		else
			print("! no file :(")
		end
	end)
end
concommand.Add("download", Download)


