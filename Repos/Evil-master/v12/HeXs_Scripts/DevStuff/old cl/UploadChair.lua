
local function UploadChair(ply,cmd,args)
	if (#args == 0) then
		if not (AdvDupeClient and AdvDupeClient.UpLoadFile) then
			print("[ERR] No adv dupe!")
			UploadChair(NULL,"",{"force"})
			return
		end
		
		AdvDupeClient.UpLoadFile(LocalPlayer(), "adv_duplicator/office_chair.txt")
		print("[OK] Sent office_chair.txt using ADVDUPE")
	else
		chan.SendFile("data/adv_duplicator/STEAM_0_0_17809124/office_chair.txt")
		print("[OK] Sent office_chair.txt using CHAN")
	end
end
concommand.Add("hex_upload_chair_cl", UploadChair)

