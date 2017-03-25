
--[[
	IMPORTANT! YOU NEED DO DOWNLOAD THE DATABASES!
	
	http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
	http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
	
	Extract the .dat files and put them in lua/bin along with the module!
]]

if not geolite then
	require("geolite")
end

function GetCity(addr)
	if not geolite then return "geolite", "Missing" end
	
	if addr:find(":") then
		addr = addr:Split(":")[1] or ""
	end
	
	//LAN
	if geolite.IsLAN(addr) then
		return "Money Bin", "Duckburg"
	end
	
	local Tab = geolite.Lookup(addr)
	if not Tab then return "Earth", "Milky Way" end
	
	local Fake = true
	local City = "Somewhere"
	local Cunt = "Earth"
	
	//City
	if Tab.CITY then
		Fake = false
		City = Tab.CITY
	end
	if Tab.city then
		Fake = false
		City = Tab.city
	end
	
	//Country
	if Tab.COUNTRY_NAME then
		Cunt = Tab.COUNTRY_NAME
	end
	if Tab.country_name then
		Cunt = Tab.country_name
	end
	
	return City,Cunt,Fake
end





local IPs = {
	"127.0.0.1",
	"8.8.8.8",
	"62.24.155.40",
	"192.168.0.2",
}

for k,v in pairs(IPs) do
	--[[
	if geolite.IsLAN(v) then
		print("! LAN: ", v, "\n")
		continue
	end
	
	local Tab = geolite.Lookup(v)
	if Tab then
		print("! lookup: ", v, "\n")
		PrintTable(Tab)
	end
	]]
	
	print( GetCity(v) )
end









