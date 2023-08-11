

for sid,tab in pairs(SHers) do
	local Log		= "lol/"..sid:gsub(":", "_")..".txt"
	
	if not file.Exists(Log) then
		file.Write(Log, Format("SH\n%s\nSkidCheck\n", (tab.Name or "None")) )
	end
	print("! saved")
end

