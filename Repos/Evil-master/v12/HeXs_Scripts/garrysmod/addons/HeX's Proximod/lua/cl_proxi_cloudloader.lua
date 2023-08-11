////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Cloud Loader                               //
////////////////////////////////////////////////

if proxi_cloud then pcall(function() proxi_cloud.Unmount() end) end

proxi_cloud = {}
proxi_cloudloader_version = 1.1

local PROXI_IsUsingCloud = false

local PROXI_CloudReceiverTimeoutDelay = 3 // !!

local PROXI_CloudReceiverQueried    = 0
local PROXI_CloudReceiverResponded  = false
local PROXI_CloudReceiverAborted    = false

local PROXI_CloudReceiverNumTries   = 3

local PROXI_CloudContents = ""
--local PROXI_CloudComposedContents = ""
local PROXI_CloudFileList = {}
local PROXI_CloudSubContents = {}
local PROXI_Origin = "http://proximod.googlecode.com/svn/trunk/lua/"
local PROXI_Start  = "cd_proxi_includelist.lua"


function proxi_cloud.IsUsingCloud()
	return PROXI_IsUsingCloud
	
end

function proxi_cloud.BuildBase()
	pcall(function() if proxi and proxi.Unmount then proxi.Unmount() end end)
	proxi = {}
	proxi_dat = {}
	
end

local function PROXI_ReceiveCloud( contents , size )
	if PROXI_CloudReceiverResponded or PROXI_CloudReceiverAborted then return end
	
	//debug should perform checks here
	PROXI_CloudContents = contents
	
	PROXI_CloudReceiverResponded = true
	
	// debug direct load
	proxi_cloud.Load()
	
end

function proxi_cloud.Load()
	if PROXI_CloudContents == "" then return end
	
	ADDON_PROP = {}
	
	local bOkay, strErr = pcall(function() proxi_cloud.InternalLoad() end)
	local bCouldLoad = false
	
	if not bOkay then
		print(" > " .. PROXI_NAME .. " Cloud Contents failed to pass semantics : ".. strErr)
		
	elseif (ADDON_PROP == nil) or (type(ADDON_PROP) ~= "table") or (#ADDON_PROP == 0) then
		print(" > " .. PROXI_NAME .. " Cloud Contents misses standard table.")
		
	else
		PROXI_CloudFileList = table.Copy(ADDON_PROP)
		bCouldLoad = true
		
		print(" > " .. PROXI_NAME .. " Cloud Contents now gathering Cloud Contents...")
		proxi_cloud.GatherSubContents()
		
	end

	ADDON_PROP = nil
	
	if not bCouldLoad then
		print(" > " .. PROXI_NAME .. " couldn't load from Cloud. Now using Locale.")
		proxi_cloud.LoadLocale()
		
	end
	
end

local function PROXI_ReceiveSubContents( args ,contents , size )
	if PROXI_CloudReceiverResponded or PROXI_CloudReceiverAborted then return end
	
	local packet_num = args[1]
	PROXI_CloudSubContents[packet_num] = contents
	print(" > " .. PROXI_NAME .. " Cloud Contents received packet #".. packet_num .." of ".. #PROXI_CloudFileList .. " :: ".. PROXI_CloudFileList[packet_num])
	
	if table.Count(PROXI_CloudSubContents) == #PROXI_CloudFileList then
		PROXI_CloudReceiverResponded = true
		print(" > " .. PROXI_NAME .. " Cloud Contents trying to mount from Cloud...")
		proxi_cloud.LoadComposition()
		
	end
	
end

function proxi_cloud.GatherSubContents()
	for k,path in pairs( PROXI_CloudFileList ) do
		http.Get( PROXI_Origin ..  path , "", PROXI_ReceiveSubContents, k )
		proxi_cloud.CheckTimeout( true )
		
	end
	
end

function proxi_cloud.InternalLoad()
	CompileString( PROXI_CloudContents , "PROXI_InternalLoad" )()
	
end

function proxi_cloud.LoadComposition()
	
	local bOkay, strErr = pcall(function() proxi_cloud.InternalCompose() end)
	local bCouldLoad = false
	
	if not bOkay then
		print(" > " .. PROXI_NAME .. " Cloud Contents Composition failed to pass semantics : ".. strErr)
		
		print(" > " .. PROXI_NAME .. " couldn't load from Cloud. Now using Locale.")
		proxi_cloud.LoadLocale()
		
	else
		proxi_cloud.AttemptMount()
		
	end
	
end

function proxi_cloud.InternalCompose()
	proxi_cloud.BuildBase()
	for i = 1, #PROXI_CloudSubContents do
		CompileString( PROXI_CloudSubContents[i] , "PROXI_INTERNALCOMPOSE__PACKET" .. tostring(i) )()
		
	end
	
end

function proxi_cloud.AttemptMount()
	PROXI_IsUsingCloud = true
	local bCouldLoad = false

	local strBivalErr = ""
	bCouldLoad, strBivalErr = pcall(function() proxi.Mount() end)
	if not bCouldLoad then
		print(" > " .. PROXI_NAME .. " Cloud Contents failed to mount : ".. strBivalErr)
		//Now used in buildbase
		//pcall(function() proxi.Unmount() end)
		
		print(" > " .. PROXI_NAME .. " couldn't load from Cloud. Now using Locale.")
		proxi_cloud.LoadLocale()
	else
		print(" > " .. PROXI_NAME .. " successfully loaded from Cloud.")
		
	end
	
end

function proxi_cloud.CheckTimeout( bFirst )
	if bFirst then
		timer.Create("PROXI_CLOUD_TIMEOUT", PROXI_CloudReceiverTimeoutDelay, 1, proxi_cloud.CheckTimeout)
		PROXI_CloudReceiverQueried = 0
		PROXI_CloudReceiverResponded = false
		PROXI_CloudReceiverAborted   = false

	elseif not PROXI_CloudReceiverResponded then
		PROXI_CloudReceiverQueried = PROXI_CloudReceiverQueried + 1
		
		if PROXI_CloudReceiverQueried <= PROXI_CloudReceiverNumTries then
			print(" > " .. PROXI_NAME .. " Cloud Contents failed to respond on check #" .. PROXI_CloudReceiverQueried .. ". Waiting.")
			timer.Create("PROXI_CLOUD_TIMEOUT", PROXI_CloudReceiverTimeoutDelay, 1, proxi_cloud.CheckTimeout)
		
		else
			print(" > " .. PROXI_NAME .. " Cloud Contents failed to respond on check #" .. PROXI_CloudReceiverQueried .. ".")
			proxi_cloud.Abort()
			
		end
		
	end
		
	
end

function proxi_cloud.Abort()
	if PROXI_CloudReceiverAborted then return end
	
	print(" > " .. PROXI_NAME .. " Cloud Contents loading aborted. Now using Locale.")
	PROXI_CloudReceiverAborted = true
	proxi_cloud.LoadLocale()
	
end

function proxi_cloud.LoadLocale()
	PROXI_IsUsingCloud = false
	proxi_cloud.BuildBase()
	
	ADDON_PROP = {}
	
	HeXInclude( PROXI_Start )
	
	for i = 1, #ADDON_PROP do
		HeXInclude( ADDON_PROP[i] )
		
	end
	
	ADDON_PROP = nil
	
	if proxi.Mount then
		proxi.Mount()
		
	end
	
end

function proxi_cloud.Ask()
	print(" > " .. PROXI_NAME .. " now trying to reach Cloud...")
	
	PROXI_CloudReceiverQueried   = 0
	PROXI_CloudContents = ""
	PROXI_CloudFileList = {}
	PROXI_CloudSubContents = {}

	proxi_cloud.Query()
	proxi_cloud.CheckTimeout( true )
	
end

function proxi_cloud.Query()
	http.Get( PROXI_Origin .. PROXI_Start, "", PROXI_ReceiveCloud )
	
end

function proxi_cloud.Mount()
	concommand.Add( "proxi_cloud_ask", proxi_cloud.Ask )
	
end


function proxi_cloud.Unmount()
	concommand.Remove( "proxi_cloud_ask" )

end

proxi_cloud.Mount()
