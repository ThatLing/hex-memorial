

require("sdef2")




hook.Add("SEIsActive", "SEIsActive", function()
	print("! SEIsActive called!")
	
	return false
end)


hook.Add("ScriptAllowed", "ScriptAllowed", function(path,lua,size)
	print("! ScriptAllowed, path,size: ", path,size )
	
	return true
end)






