
//Percent
function math.Percent(This,OutOf)
	if math.abs(OutOf) < 0.0001 then return 0 end
	return math.Round(This / OutOf * 100)
end

//One in
function math.OneIn(num)
	return math.random(0, (num or 1) ) == 0
end

//Within
function math.Within(This, Low,High)
	return This > Low and This < High
end

//Minus
function math.Minus(This)
	return This < 0 and -This or This
end

//Bytes
local Units = {"B", "KB", "MB", "GB, Whoops!"}
function math.Bytes(bytes, all_data)
	if not isnumber(bytes) then return error("! math.Bytes: No bytes\n") end
	
	local Div 	= math.floor( math.log(bytes) / math.log(1024) );
	local Raw 	= (bytes / math.pow(1024, math.floor(Div) ) )
	
	Div = Div + 1
	
	if all_data then
		return math.Round(Raw, 2),Units[ Div ], Raw,Div
	else
		return math.Round(Raw, 2).." "..Units[ Div ]
	end
end














