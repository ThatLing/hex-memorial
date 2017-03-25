




local function Safe(str,maxlen)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[\n\r:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "_n", "")
	str = string.gsub(str, "_r", "")
	str = string.Trim( string.Left(str, maxlen or 20) )
	return str
end


print( Safe([[ [one]\n\r, C:\poo\n (two), 'thr@ee', "four", #lol, <ass>, dong*\?]], 99) )


