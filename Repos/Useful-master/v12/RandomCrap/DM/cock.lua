

function RandomString(len)
	if not len then
		len = 8
	end
	local random = ""
	for i = 1, len do
		local c = math.random(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		random = random..string.char(c)
	end
	return random
end

print( RandomString() )

