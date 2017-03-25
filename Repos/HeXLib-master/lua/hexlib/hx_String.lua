--- === String === ---

function string.Random(len)
	local rnd = ""
	for i=1,( len or math.random(6,11) ) do
		local c = math.random(65,116)
		if c >= 91 and c <= 96 then
			c = c + 6
		end
		rnd = rnd..string.char(c)
	end
	return rnd
end



function ValidString(v)
	return isstring(v) and v != ""
end

function string.hFind(str,what)
	return str:find(what,nil,true)
end

function string.Check(str,check)
	return str:sub(1,#check) == check
end

function string.Count(str,count)
	return #str:Split(count) - 1
end

function string.InBase(str,base)
	return base:lower():find( str:lower() )
end

function string.ToBytes(str)
	return str:gsub("(.)", function(c)
		return Format("%02X%s", c:byte(), " "):Trim()
	end)
end

function string.Size(str)
	return math.Bytes( #str )
end

function string.CheckInTable(str,tab, use_k)
	for k,v in pairs(tab) do
		if str:Check( (use_k and k or v) ) then
			return true, k,v
		end
	end
	return false, false, false
end

function string.InTable(str,tab, use_k, lower)
	if not istable(tab) then
		debug.ErrorNoHalt("! Have a fuckup, string.InTable not a table!")
		return
	end
	for k,v in pairs(tab) do
		local This = use_k and k or v
		if str:find( lower and This:lower() or This, nil,true) then
			return true, k,v
		end
	end
	return false, false, false
end


function string.SID(str)
	return str:gsub(":", "_")
end

function string.Safe(str, newlines)
	str = tostring(str)
	str = str:Trim()
	str = str:gsub("[:/\\\"*%@?<>'#]", "_")
	str = str:gsub("[]([)]", "")
	
	if not newlines then
		str = str:gsub("[\n\r]", "")
	end
	
	str = str:Trim()
	return str
end

function string.EatNewlines(str, also_spaces)
	str = str:gsub("\n", " ")
	str = str:gsub("\r", "")
	str = str:gsub("\t", " ")
	
	if also_spaces then
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
	end
	return str
end

function string.NoQuotes(str)
	str = str:Trim()
	if str:Check('"') then
		str = str:sub(2)
	end
	
	if str:EndsWith('"') then
		str = str:sub(0,-2)
	end
	return str
end


local GoodBytes = {
	[32] = " ",
	--[35] = "#",
	[45] = "-",
	[46] = ".",
	[47] = "/",
	[95] = "_",
}
function string.VerySafe(str, tab)
	local out = ""
	local Tab = tab or GoodBytes
	
	for i=1, #str do
		local Byte = str:byte(i)
		
		if Tab[ Byte ] or (Byte >= 48 and Byte <= 57) or (Byte >= 65 and Byte <= 90) or (Byte >= 97 and Byte <= 122) then
			out = out..str:sub(i,i)
		end
	end
	
	return out
end



function string.NiceTimeEx(Secs)
	if not Secs then Secs = 0 end
	if Secs < 0 then Secs = -Secs end
	
	local hours 	= math.floor(Secs / 3600)
	local minutes	= math.floor( (Secs / 60) % 60)
	Secs 			= math.floor(Secs % 60)
	
	return (
		(hours >= 1 	and "0"..hours..":" or "")..
		(minutes <= 9 	and "0"..minutes 	or minutes)..":"..
		(Secs <= 9 		and "0"..Secs 		or Secs)
	)
end

function string.NiceNum(num)
	return tostring(num):reverse():gsub("(...)", "%1,"):gsub(",$", ""):reverse()
end



--- === string.ToBinary / string.FromBinary by RyanJGray === ---
local function toBits(num)
    local t = {}
    while num > 0 do
        rest = math.fmod(num, 2)
        t[ #t + 1 ] = rest
        num = ( num-rest ) / 2
    end
    return t
end

local function makeEight(str)
    return ( "0" ):rep( 8 - #str )..str
end

function string.ToBinary(str)
    local txt = ""

    for i=1, #str do
        txt = txt..makeEight( table.concat( toBits( string.byte( str:sub(i,i) ) ) ):reverse() )
    end

    return txt
end

function string.FromBinary(str)
    local txt2 = ""
    for k,v in pairs( str:Split("\n") ) do
        local q = 1
        for i=1, #v / 8 do
            txt2 = txt2..string.char( tonumber( v:sub(q, q + 7), 2 ) )
            q = q + 8
        end
    end

    return txt2
end





function string.FromVA(...)
	local Tab = {...}
	local Out = ""
	local Tot = select("#", ...)
	for k=1,Tot do
		Out = Out.."[["..tostring( Tab[k] ).."]]"..(k == Tot and "" or ", ")
	end
	return Out
end

















