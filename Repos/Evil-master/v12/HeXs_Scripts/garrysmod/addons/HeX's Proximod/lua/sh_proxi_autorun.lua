////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Shared Autorun                             //
////////////////////////////////////////////////

if PROXI_DEBUG == nil then
	PROXI_DEBUG = false
end

-- Developer notes :
--   "--" comments should be used for regular comments.
--   "//" comments should be used for debugging / technical / header comments.

PROXI_NAME = "Proxi"

PROXI_FORCE_VERSION = false // !!
PROXI_FORCE_USE_CLOUD = true // !!

if (CLIENT or SinglePlayer()) then
	if (proxi and proxi.Unmount) then proxi.Unmount() end
	
	HeXInclude("cl_proxi_cloudloader.lua")
	HeXInclude("cl_proxi_version.lua")
	HeXInclude("cl_proxi_preforce.lua")
	
	proxi_InitLoad()
	
	--proxi = {}
	--proxi_dat = {}
	--proxi_focus = {} // Did in the focus lua file
	
	if not PROXI_FORCE_VERSION then
		local function PROXI_CheckResponse()
			if not proxi_internal.HasReceivedResponse() then
				print(" > " .. PROXI_NAME .. " did not get a response from Cloud Version query. Now loading Locale.")
				proxi_cloud.LoadLocale()
				
			end
			
		end
		
		local function PROXI_CallbackResponse()
			local MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK = proxi_internal.GetVersionData()
			if MY_VERSION < ONLINE_VERSION then
				print(" > " .. PROXI_NAME .. " found an updated version from the Cloud (Locale is ".. MY_VERSION .. ", Online is " .. ONLINE_VERSION .. "). Now querying Cloud.")
				proxi_cloud.Ask()
			
			else
				print(" > " .. PROXI_NAME .. " Locale seems as up to date as the Cloud. Loading Locale.")
				proxi_cloud.LoadLocale()
				
			end
			
		end
		
		print(" > " .. PROXI_NAME .. " is in normal mode. Now querying Version.")
		proxi_internal.QueryVersion( PROXI_CallbackResponse )
		timer.Simple( 10, PROXI_CheckResponse )
	
	elseif PROXI_FORCE_USE_CLOUD then
		print(" > " .. PROXI_NAME .. " is in Cloud force mode. Now querying Cloud.")
		proxi_cloud.Ask()
		
	else
		print(" > " .. PROXI_NAME .. " is in Locale force mode. Now loading Locale.")
		proxi_cloud.LoadLocale()
		
	end
	
	PROXI_INCLUDED_AT_LEAST_ONCE = true
end
