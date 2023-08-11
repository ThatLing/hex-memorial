////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Concommands RegMod                         //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

local HAY_LOCAL_CONCMDPREFIX = HAYFRAME_SetupParameter( "concmd_prefix" )

function HAY_MAIN:CreateCmd( sCmdName, fCallback )
	local prefix = string.find( sCmdName, "+" ) and "+" or string.find( sCmdName, "-" ) and "-" or ""
	sCmdName = string.gsub( sCmdName, "+", "" )
	sCmdName = string.gsub( sCmdName, "-", "" )
	
	concommand.Add( prefix .. HAY_LOCAL_CONCMDPREFIX .. sCmdName, fCallback )
	
end

function HAY_MAIN:RemoveCmd( sCmdName )
	local prefix = string.find( sCmdName, "+" ) and "+" or string.find( sCmdName, "-" ) and "-" or ""
	sCmdName = string.gsub( sCmdName, "+", "" )
	sCmdName = string.gsub( sCmdName, "-", "" )
	
	concommand.Remove( prefix .. HAY_LOCAL_CONCMDPREFIX .. sCmdName )
	
end

// Should not ...
function HAY_MAIN:CallCmd( sCmdName, ... )
	local prefix = string.find( sCmdName, "+" ) and "+" or string.find( sCmdName, "-" ) and "-" or ""
	sCmdName = string.gsub( sCmdName, "+", "" )
	sCmdName = string.gsub( sCmdName, "-", "" )
	
	RunConsoleCommand( prefix .. HAY_LOCAL_CONCMDPREFIX .. sCmdName, ... )
	
end

function HAY_MAIN:AppendCmd( tGroup, sName, fCallback, ... )
	tGroup[sName] = fCallback
	
end

function HAY_MAIN:BuildCmds( tGroup, sPrefix )
	if not sPrefix then sPrefix = "" end
	
	for sName,oObject in pairs( tGroup ) do
		if type( oObject ) == "table" then
			HAY_MAIN:BuildCmds( oObject, sPrefix .. sName .. "_" )
			
		else
			self:CreateCmd( tostring( sPrefix ) .. tostring( sName ), oObject )
		
		end
		
	end
	
end

function HAY_MAIN:DismountCmds( tGroup, sPrefix )
	if not sPrefix then sPrefix = "" end
	
	for sName,oObject in pairs( tGroup ) do
		if type( oObject ) == "table" then
			HAY_MAIN:DismountCmds( oObject, sPrefix .. sName .. "_" )
			
		else
			self:RemoveCmd( tostring( sPrefix ) .. tostring( sName ) )
			
		end
		
	end
	
end
