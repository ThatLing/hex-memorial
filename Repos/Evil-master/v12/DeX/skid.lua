

Bulk	= {}
SHers	= {}
ExecDownload(DEX_PATH, "hx_SkidList.lua", true)


Skiddies = {}
local function Merge(tab)
	for k,v in pairs(tab) do
		Skiddies[k] = v
	end
	tab = nil
end
Merge(Bulk)
Merge(SHers)


local Enabled = true

local function StartSK(ply,cmd,args)
	Enabled = not Enabled
	
	ply:print("[OK] SkidCheck is now: "..tostring(Enabled) )
end
command.Add("sk_toggle", StartSK, "Toggle SkidCheck")


local function SBCheckPlayer(ply)
	http.Get("http://sethblock.tk/api.php?user="..ply:SteamID(), "", function(what,size)
		if ValidEntity(ply) and what:find("SethHack") then
			ply.IsSethBlock = true
		end
	end)
end
hook.Add("PlayerInitialSpawn", "SBCheckPlayer", SBCheckPlayer)



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



local StartSB = nil

function SkidCheck()
	if not Enabled then return end
	
	for k,v in pairs( player.GetHumans() ) do
		if not ValidEntity(v) then continue end
		
		if not StartSB then
			StartSB = true
			
			timer.Simple(k, function()
				if ValidEntity(v) then
					SBCheckPlayer(v)
				end
			end)
		end
		
		
		local SID 	= v:SteamID()
		local Tab 	= Skiddies[SID]
		
		if (Tab or v.SHer) and not v.DoneSK then
			local Name		= (Tab.Name or v:Nick()).." ("..SID..")"
			local DoTab		= nil
			
			if (Tab.SH or v.SHer) then
				DoTab = true
				
				CAT(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", team.GetColor( v:Team() ), v:Nick(), GREY, " is a ", RED, "SETHHACKER/CHEATER! ", GREEN, Name)
				
			elseif v.IsSethBlock then
				v.IsSethBlock = nil
				DoTab = true
				
				MsgAll("\n"..v:Nick().." is on SethBlock!\n\n")
				CAT(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", team.GetColor( v:Team() ), v:Nick(), GREY, " is on ", RED, "SethBlock! ", GREEN, Name)
				
			elseif Tab.Skid then
				DoTab = true
				MsgAll("\n"..v:Nick().." is a Skiddie!\n\n")
				CAT(GREY, "[", color_white, "Skid", BLUE, "Check", GREY, "]: ", team.GetColor( v:Team() ), v:Nick(), GREY, " is a ", KCHEAT, "Skiddie! ", GREEN, Name)
			end
			
			if DoTab then
				v.DoneSK = true
				BroadcastLua([[ surface.PlaySound( Sound("ambient/machines/thumper_shutdown1.wav") ) ]])
			end
		end
	end
end
timer.Create("SkidCheck", 6, 0, SkidCheck)


local function ResetSkiddies()
	StartSB = nil
	
	for k,v in pairs( player.GetAll() ) do
		if ValidEntity(v) then
			v.DoneSK = nil
		end
	end
end
timer.Create("ResetSkiddies", 160, 0, ResetSkiddies)


local function ResetSkiddies(ply,cmd,args)
	ResetSkiddies()
	
	ply:print("[SkidCheck] Messages reset, expect spam in 5s!")
end
concommand.Add("sk_reset_sv", ResetSkiddies)







