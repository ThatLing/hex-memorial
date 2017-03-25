
local AllPacks = file.Find("cache/*.dua", true)

table.sort(AllPacks, function(a,b)
	return file.Time("../cache/"..a) > file.Time("../cache/"..b)
end)

NewPack		= AllPacks[1] --Newest datapack
local Name	= NewPack:gsub(".dua", ""):Right(3) --Last 3 chars of pack name

print("! newset: ", NewPack, NewName)


HSPMod.CopyCache(util.RelativePathToFull("cache/"..NewPack), "C:/"..NewPack)
HSPMod.DeleteCache("C:/"..NewPack)

file.Exists("C:/"..NewPack, true)