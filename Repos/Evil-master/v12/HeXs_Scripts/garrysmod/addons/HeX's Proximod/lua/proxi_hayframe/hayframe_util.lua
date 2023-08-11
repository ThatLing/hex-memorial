////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Utility functions                          //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

function HAY_UTIL.OutputError( sText, sLocation )
	ErrorNoHalt( ">> " .. tostring(HAY_SHORT) .. " error'd " .. (sLocation and ("(" .. tostring(sLocation) ..")") or "") .. ":: " .. tostring(sText) .. "\n" )
	
end


function HAY_UTIL.OutputLineBreak( )
	print( "" )
	
end

function HAY_UTIL.OutputIn( sText )
	print( "[ " .. tostring(HAY_NAME) .. " :: " .. tostring(sText) .. " ]" )
	
end

function HAY_UTIL.OutputOut( sText )
	print( "] " .. tostring(HAY_NAME) .. " :: " .. tostring(sText) .. " [" )
	
end

HAY_UTIL.Output = HAY_UTIL.OutputOut

function HAY_UTIL.OutputDebug( sText )
	if not HAY_DEBUG then return end
	
	print( "<!> " .. tostring(HAY_SHORT) .. " :: " .. tostring(sText) )
	
end


function HAY_UTIL.FamiliarizeString( sInput )
	local stringParts = string.Explode( "_", sInput )
	local stringOutput = ""
	
	for k,part in pairs( stringParts ) do
		local len = string.len( part )
		if len <= 1 then
			stringOutput = stringOutput .. string.upper( part )
		
			--Assume if len == 0, received "__" thus "upper" nothing.
			
		else
			stringOutput = stringOutput .. string.Left( string.upper( part ), 1 ) .. string.Right( part, len - 1 )
			
		end
		
		if k ~= #stringParts then stringOutput = stringOutput .. " " end
		
	end
	
	return stringOutput
	
end

function HAY_UTIL.PercentCharge( fUniform )
	return (1 - (1 - fUniform) ^ 2 )
	
end

function HAY_UTIL.Cubar_FacepunchAlgorithm( )
	if not facepunch then return end
	
	// simple algorithm to replicate Cubar's account
	local assholes = {"CapsAdmin", "Blackops", "irzilla", "|flapjack|", "Ha3"}
	local assholeIndexed = {}
	for k,asshole in pairs( assholes ) do
		assholeIndexed[ asshole ] = 1000
		
	end
	
	local winners = {"Cubar"}
	for _,winner in pairs( winners ) do
		for k,post in pairs( facepunch.GetAllPostsFromUserID( facepunch.GetUserIDFromNickname( winner ) ) ) do
			post:AddRating( "agree" )
			
			for stringRating,tableUserIDs in pairs( post:GetAllRatings() ) do
				if stringRating == "dumb" or stringRating == "late" or stringRating == "disagree" then
					for i,ratingAssholeID in pairs( tableUserIDs ) do
						local assholeNickname = facepunch.GetNicknameFromUserID( ratingAssholeID )
						if not table.HasValue( winners, assholeNickname ) then
							assholeIndexed[ assholeNickname ] = ( assholeIndexed[ assholeNickname ] or 0 ) + 1
						
						end
					
					end
					
				end
				
			end
		
		end
	end
	
	local trueAssholes = {}
	for assholeNickname,quantity in pairs( assholeIndexed ) do
		table.insert( trueAssholes, assholeNickname )
		
	end

	for _,asshole in pairs( trueAssholes ) do
		for k,post in pairs( facepunch.GetAllPostsFromUserID( facepunch.GetUserIDFromNickname( asshole ) ) ) do
			post:AddRating( "dumb" )
		
		end
	end
	
end

function HAY_UTIL.DecoDaMan_GetParams( f )
	local co = coroutine.create(f)
	local params = {}
	debug.sethook(co, function()
	local i, k = 1, debug.getlocal(co, 2, 1)
	while k do
		if k ~= "(*temporary)" then
			table.insert(params, k)
		end
		i = i+1
		k = debug.getlocal(co, 2, i)
	end
	error("~~end~~")
	end, "c")
	local res, err = coroutine.resume(co)
	if res then
		error("The function provided defies the laws of the universe.", 2)
	elseif string.sub(tostring(err), -7) ~= "~~end~~" then
		error("The function failed with the error: "..tostring(err), 2)
	end
	return params
	
end

function HAY_UTIL.GenerateDocumentation( tGroup, sConvenientName )
	if not tGroup then return end
	
	local tfctName = {}
	for sFctName,fct in pairs( tGroup ) do
		if type(fct) == "function" then
			table.insert( tfctName, sFctName )
		end
	end
	table.sort( tfctName, function( a, b ) return a < b end )
	
	local gs = ""
	for _,sFctName in pairs( tfctName ) do
		local fct = tGroup[sFctName]
		
		local tParams = HAY_UTIL.DecoDaMan_GetParams( fct )
		
		local ts = sConvenientName
		if tParams[1] == "self" then
			ts = ts .. ":"
		else
			ts = ts .. "."
		end
		ts = ts .. sFctName .. "("
		for k,sParam in pairs( tParams ) do
			if k ~= 1 or sParam ~= "self" then
				ts = ts .. sParam
				
				if k < #tParams then
					ts = ts .. ", "
					
				end
				
			end
			
		end
		ts = ts .. ")"
		gs = gs .. ts .. "\n"
	end
	return gs

end

function HAY_UTIL.PrintDocumentation( )
	print( HAY_UTIL.GenerateDocumentation( HAY_MAIN, HAY_SHORT ) )
	
end
