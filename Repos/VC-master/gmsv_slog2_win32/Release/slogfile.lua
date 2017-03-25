



hook.Add("FileRequested", "FileRequested", function(what,idx)
	print("! FileRequested, what,idx: ", what,idx, Player(idx), Entity(idx) )
	return true
end)

hook.Add("FileReceived", "FileReceived", function(what,idx)
	print("! FileReceived, what,idx: ", what,idx, Player(idx), Entity(idx) )
end)
















