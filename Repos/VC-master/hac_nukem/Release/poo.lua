
print("! poo.lua")

timer.Simple(2, function()
	if not nukem then print("! nukem failed :(") return end
	
	print("! nukem ready, calling..")
	local Tab = nukem.GetLoadedModules()
	
	if Tab then
		PrintTable(Tab)
	else
		print("! no Tab")
	end
end)


pcall(require, "psapi")











