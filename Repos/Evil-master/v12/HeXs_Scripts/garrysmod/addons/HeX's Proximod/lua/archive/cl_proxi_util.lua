////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Utility functions                          //
////////////////////////////////////////////////

function proxi:FamiliarizeString( stringInput )
	local stringParts = string.Explode( "_", stringInput )
	local stringOutput = ""
	for k,part in pairs( stringParts ) do
		local len = string.len( part )
		if len == 1 then
			stringOutput = stringOutput .. string.upper( part )
			
		elseif len > 1 then
			stringOutput = stringOutput .. string.Left( string.upper( part ), 1 ) .. string.Right( part, len - 1 )
			
		end
		
		if k != #stringParts then stringOutput = stringOutput .. " " end
		
	end
	return stringOutput
	
end

function proxi:Util_CalcPowerUniform( fUniform )
	return fUniform ^ 2, (1 - (1 - fUniform) ^ 2 )
end

function proxi:Util_GetVarColorVariadic( sCvar )
	return self.GetVar(sCvar .. "_r"), self.GetVar(sCvar .. "_g"), self.GetVar(sCvar .. "_b"), self.GetVar(sCvar .. "_a");
	
end

function proxi.Util_AppendCvar( tGroup, sName, oDefault, sType, ... )
	if not sType then
		tGroup[sName] = oDefault
		
	elseif sType == "color" then
		tGroup[sName .. "_r"] = oDefault[1]
		tGroup[sName .. "_g"] = oDefault[2]
		tGroup[sName .. "_b"] = oDefault[3]
		tGroup[sName .. "_a"] = oDefault[4]
		
	end
	
	
end

function proxi.Util_BuildCvars( tGroup, sPrefix )
	if not sPrefix then return end
	
	for sName,oDefault in pairs( tGroup ) do
		proxi.CreateVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ), true, false )
		
	end
	
end

function proxi.Util_RestoreCvars( tGroup, sPrefix )
	if not sPrefix then return end
	
	for sName,oDefault in pairs( tGroup ) do
		proxi.SetVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ) )
		
	end
	
end
