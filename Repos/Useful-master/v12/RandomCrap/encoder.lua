


local function CombineString(str) --Remove newlines from the string
	return str:gsub("\n", "")
end

local function SplitStringAt(str,len)
	local Output	= ""
	local Temp 		= ""
	
	for i=0,str:len() do
		Temp = Temp..str:sub(i,i)
		
		if (#Temp == len) then
			Output = Output..Temp.."\n"
			Temp = ""
		end
	end
	
	return Output..Temp
end



function Encode(code)
	local buff = ""
	for i=1, #code do
		buff = buff..Format("%02X", code[i]:byte() )
	end
	return buff
end

function Decode(p)
	p = p:gsub("\n", "")
	local b,i = "",1
	while (i < #p) do
		b = b..string.char( tonumber(p[i]..p[i+1], 16) )
		i = i + 2
	end
	return b
end


--One line
RawText = [[i'd help you, but if you came to 4chan for electrical maintenance help, theres a good chance you'll die from attempting any advice i give you. so don't think of this as me holding out on you, think of it as me saving your life. you owe me.]]



RawText = SplitStringAt(RawText, 33)

--Output, split at 33 chars
--[[
i'd help you, but if you came to 
4chan for electrical maintenance 
help, theres a good chance you'll
 die from attempting any advice i
 give you. so don't think of this
 as me holding out on you, think 
of it as me saving your life. you
 owe me.
]]




RawText = SplitStringAt( Encode(RawText), 55)

--Output, encoded, split to 55
--[[
6927642068656C7020796F752C2062757420696620796F752063616
D6520746F200A346368616E20666F7220656C656374726963616C20
6D61696E74656E616E6365200A68656C702C2074686572657320612
0676F6F64206368616E636520796F75276C6C0A206469652066726F
6D20617474656D7074696E6720616E792061647669636520690A206
769766520796F752E20736F20646F6E2774207468696E6B206F6620
746869730A206173206D6520686F6C64696E67206F7574206F6E207
96F752C207468696E6B200A6F66206974206173206D652073617669
6E6720796F7572206C6966652E20796F750A206F7765206D652E
]]




RawText = Decode(RawText)


print( RawText )

--Output, decoded back to plaintext
--[[
i'd help you, but if you came to 
4chan for electrical maintenance 
help, theres a good chance you'll
 die from attempting any advice i
 give you. so don't think of this
 as me holding out on you, think 
of it as me saving your life. you
 owe me.
]]



RawText = CombineString(RawText)

--Output, recombined into original one-liner
--[[
i'd help you, but if you came to 4chan for electrical maintenance help, theres a good chance you'll die from attempting any advice i give you. so don't think of this as me holding out on you, think of it as me saving your life. you owe me.
]]



file.Write("output.txt", RawText)



















