
--- === Table === ---

function table.MergeEx(from,dest, as_is)
	if as_is then
		dest[ as_is ] = from
	else
		for k,v in pairs(from) do
			dest[k] = v
		end
	end
	
	from = nil
	return dest
end

function table.CopyAndMerge(...)
	local New = {}
	for k,v in pairs( {...} ) do
		table.Add(New, table.Copy(v) )
	end
	return New
end

function table.RandomEx(Tab)
	local Rand = table.Random(Tab) --Garry'd
	return Rand
end

function table.Tabify(Tab)
	local N = {}
	for k,v in pairs(Tab) do
		N[v] = 1
	end
	return N
end

function table.Size(Tab)
	local Size = 0
	
	local function Count(Tab)
		done = done	or {}
		
		for k,v in pairs(Tab) do
			local typ = type(v)
			
			if typ == "table" and not done[v] then
				done[v] = true
				
				table.Size(v, done)
			elseif typ == "string" or typ == "number" then
				Size = Size + #tostring(v)
			end
		end
	end
	Count(Tab)
	
	return Size
end

function table.Shuffle(Tab)
	local This = #Tab
	
	while This >= 2 do
		local k = math.random(This)
		Tab[ This ], Tab[ k ] = Tab[ k ], Tab[ This ]
		This = This - 1
	end
	return Tab
end


















