////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// ConVar Reg Method - Customizable           //
////////////////////////////////////////////////


local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

local HAY_LOCAL_VARPREFIX = HAYFRAME_SetupParameter( "var_prefix" )

-- Added due to callback problems with the cvars lib.
if not HAY__CALLBACK_FUNC then	HAY__CALLBACK_FUNC = {} end
if not HAY__CALLBACK_FUNC[ HAY_SHORT ] then HAY__CALLBACK_FUNC[ HAY_SHORT ] = {} end
local HAY_REFERENCE_CALLBACK_FUNC = HAY__CALLBACK_FUNC[ HAY_SHORT ]

function HAY_MAIN:GetVarName( sVarName )
	return HAY_LOCAL_VARPREFIX .. sVarName
	
end

function HAY_MAIN:GetVar( sVarName, optbReturnString )
	if optbReturnString or false then
		return GetConVarString( HAY_LOCAL_VARPREFIX .. sVarName)
	end
	return GetConVarNumber( HAY_LOCAL_VARPREFIX .. sVarName )
end

function HAY_MAIN:CreateVar( sVarName, sContents, shouldSave, userData, optfCallback, optbIsBooleanType )
	CreateClientConVar( HAY_LOCAL_VARPREFIX .. sVarName, sContents, shouldSave, userData)
	
	if type( optfCallback ) == "function" then
		self:CreateVarCallback( sVarName, optfCallback, optbIsBooleanType )
		
	end
	
end

function HAY_MAIN:SetVar( sVarName, tContents )
	RunConsoleCommand( HAY_LOCAL_VARPREFIX .. sVarName , tostring(tContents) )
	
end

function HAY_MAIN:CreateVarCallback( sVarName, fCallback, bIsBooleanType )
	-- WARNING :
	-- On this architecture, if a session is restarted with a change in bIsBooleanType
	-- It will remain as previously set (Issue can happen in developer stage, not in end-user mode)
	
	if not HAY_REFERENCE_CALLBACK_FUNC[ sVarName ] then
		if not bIsBooleanType then
			cvars.AddChangeCallback( HAY_LOCAL_VARPREFIX .. sVarName , function( sCvar, prev, new )
				if not HAY_MAIN then return end
				HAY_REFERENCE_CALLBACK_FUNC[ sVarName ]( sCvar, prev, new )
				
			end )
		
		else
			cvars.AddChangeCallback( HAY_LOCAL_VARPREFIX .. sVarName , function( sCvar, prev, new )
				if not HAY_MAIN then return end
				if (tonumber( new ) <= 0 and tonumber( prev ) <= 0) or (tonumber( new ) > 0 and tonumber( prev ) > 0) then return end
				
				HAY_REFERENCE_CALLBACK_FUNC[ sVarName ]( sCvar, prev, new )
				
			end )
			
		end
		
	end
	HAY_REFERENCE_CALLBACK_FUNC[ sVarName ] = fCallback
	
end


////////////////////////////////////////////////
////////////////////////////////////////////////

function HAY_MAIN:GetVarColorVariadic( sCvar )
	return self:GetVar(sCvar .. "_r"), self:GetVar(sCvar .. "_g"), self:GetVar(sCvar .. "_b"), self:GetVar(sCvar .. "_a")
	
end

function HAY_MAIN:AppendVar( tGroup, sName, oDefault, sType, ... )
	if not sType then
		tGroup[sName] = oDefault
		
	elseif sType == "color" then
		tGroup[sName .. "_r"] = oDefault[1]
		tGroup[sName .. "_g"] = oDefault[2]
		tGroup[sName .. "_b"] = oDefault[3]
		tGroup[sName .. "_a"] = oDefault[4]
		
	end
	
	
end

function HAY_MAIN:BuildVars( tGroup, sPrefix )
	if not sPrefix then sPrefix = "" end
	
	for sName,oDefault in pairs( tGroup ) do
		if type( oDefault ) == "table" then
			self:BuildVars( oDefault, sPrefix .. sName .. "_" )
			
		else
			self:CreateVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ), true, false )
		
		end
		
	end
	
end

function HAY_MAIN:RestoreVars( tGroup, sPrefix )
	if not sPrefix then return end
	
	for sName,oDefault in pairs( tGroup ) do
		if type( oDefault ) == "table" then
			self:RestoreVars( oDefault, sPrefix .. sName .. "_" )
			
		else
			self:SetVar( tostring( sPrefix ) .. tostring( sName ), tostring( oDefault ) )
			
		end
		
	end
	
end

