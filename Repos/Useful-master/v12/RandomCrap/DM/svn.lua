
local function Path(v)
	return v:gsub("/","\\")
end

SVNPath = "C:\\srcds\\My Dropbox\\Public\\garrysmod"


--HSPMod.WinCMD(Format( [[ start svn remove "%s" --force &&exit ]], SVNPath.."\\cache\\lol.txt" ))


timer.Simple(2,function()
--HSPMod.WinCMD(Format( [[ start svn add "%s" &&exit ]], SVNPath.."\\cache\\test.txt" ))
end)

timer.Simple(4,function()
	--HSPMod.WinCMD(Format( [[ start svn commit "%s" -m "Datapack" &&exit]], SVNPath ))
end)



local Old = "cache/bcd7113d910b06874b52676aa111ba84.dua"

print( Path(util.RelativePathToFull(Old)) )

HSPMod.WinCMD(Format( [[ svn remove "%s" &&exit ]], Path(util.RelativePathToFull(Old)) ))



