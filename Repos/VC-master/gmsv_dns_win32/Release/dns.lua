
require("dns")


local DNSIP = "8.8.8.8" --Google

function IsHostOnline(str)
	local Online,err,code = dns.Ping(DNSIP, 300)
	
	if not Online then
		error("Ping "..DNSIP.." failed! ("..err..(code and ", "..code or "")..")\n")
		return false
	end
	
	
	local Addr,err,code = dns.Lookup(str, DNSIP)
	if not Addr then
		error("Lookup "..str.." failed! ("..err..(code and ", "..code or "")..")\n")
		return false
	end
	
	return true,Addr
end


print("! Online,addr: ", IsHostOnline("unitedhosts.org") )










