

function ass(str)
	local tab = string.Explode(" ",str)

	for k,v in pairs(tab) do
		if string.len(v) <= 3 then
			tab[k] = v:upper()
			--print(k,v)
		end
	end
	
	--print("!: ", tab[1] )
	--PrintTable(tab)
	return table.concat(tab, " ")
end
print(" return value: ", ass("dm desert tower") )




local fuck = {
	[1] = "fuck",
	[2] = "ass",
	[3] = "balls",
}

for k,v in pairs(fuck) do
	if v == "ass" then
		--print("! ass")
		fuck[k] = "cock"
	end
end

print("! tab: ", fuck[2] )
PrintTable(fuck)














