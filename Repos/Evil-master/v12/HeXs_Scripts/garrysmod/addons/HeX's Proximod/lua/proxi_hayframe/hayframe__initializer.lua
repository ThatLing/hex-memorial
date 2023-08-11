////////////////////////////////////////////////
// -- HayFrame                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Utility functions                          //
////////////////////////////////////////////////


local HAY_MAIN     = proxi
local HAY_INTERNAL = proxi_internal
local HAY_CLOUD    = proxi_cloud
local HAY_UTIL     = proxi_util
local HAY_NAME     = PROXI_NAME
local HAY_SHORT    = PROXI_SHORT
local HAY_DEBUG    = PROXI_DEBUG

local HAY_LOCAL = {}
HAY_LOCAL.concmd_prefix = "proxi_"
HAY_LOCAL.var_prefix    = "cl_proxi_"


//local HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL = HAYFRAME_SetupReferences( )
//local HAY_NAME, HAY_SHORT, HAY_DEBUG = HAYFRAME_SetupConstants( )

function HAYFRAME_SetupReferences( )
	return HAY_MAIN, HAY_INTERNAL, HAY_CLOUD, HAY_UTIL
	
end

function HAYFRAME_SetupConstants( )
	return HAY_NAME, HAY_SHORT, HAY_DEBUG
	
end

function HAYFRAME_SetupParameter( sParam )
	return HAY_LOCAL[ sParam ]
	
end
