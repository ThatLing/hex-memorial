





local function VFSPath(path)
	if HSPMod.Exists(path) then
		return path --Not in VFS
	end
	
	for k,v in pairs( file.Find("addons/*", true) ) do
		local APath = "addons/"..v.."/"..path
		if file.Exists(APath, true) then
			return APath
		end
	end
	
	ErrorNoHalt("! VFSPath fuckup, can't find: "..path.." in addons! (blame garry)\n")
	return ""
end



















