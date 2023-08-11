
local BadLists = {
	"Robotics and Gears",
	"Specialized Construction",
	"Miscellaneous Props",
	"General Construction Props",
	"Useful and Explosive",
	"Rails and Rollercoasters",
	"Transportation",
	"Solid Steel",
	"Sliders",
}
local tab = {}
local lol = {}

local function RemoveFuckingSpawnlists()
	print("[HeX] Removing useless spawnlists..")
	tab = table.Copy(spawnmenu.GetPropTable())
	lol = spawnmenu.GetPropTable()
	
	for k,v in pairs(BadLists) do
		spawnmenu.DeletePropCategory(v)
		lol[v] = nil
		tab[v] = nil
	end
	
	
	lol = tab
	
	print("[HeX] Removed "..#BadLists.." spawnlists..")
end
RemoveFuckingSpawnlists()

--timer.Simple(3, RemoveFuckingSpawnlists)
concommand.Add("hex_removephx", RemoveFuckingSpawnlists)









