////////////////////////////////////////////////
// -- Proxi                                //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Version II                                 //
////////////////////////////////////////////////

proxi_internal = {}

local MY_VERSION = tonumber(string.Explode( "\n", file.Read("proxi.txt"))[1])
local ONLINE_VERSION = nil
local DOWNLOAD_LINK = nil
local RECEIVED_RESPONSE = false
local CONTENTS_REPLICATE = nil

function proxi_internal.IsUsingCloud()
	return proxi_cloud and proxi_cloud.IsUsingCloud and proxi_cloud:IsUsingCloud() or nil
end

function proxi_internal.HasReceivedResponse()
	return RECEIVED_RESPONSE
end

function proxi_internal.GetVersionData()
	return MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK
end

function proxi_internal.GetReplicate( ) -- >= cv1.1
	return CONTENTS_REPLICATE
end

function proxi_internal.ReceiveVersion( args, contents , size )
	
	--Taken from RabidToaster Achievements mod.
	CONTENTS_REPLICATE = contents
	local split = string.Explode( "\n", contents )
	local version = tonumber( split[ 1 ] or "" )
	
	if ( !version ) then
		ONLINE_VERSION = -1
		return
	end
	
	ONLINE_VERSION = version
	
	if ( split[ 2 ] ) then
		DOWNLOAD_LINK = split[ 2 ]
	end
	
	RECEIVED_RESPONSE = true
	if args and args[1] then args[1]() end
	
end

function proxi_internal.QueryVersion( funcCallback )
	http.Get( "http://proximod.googlecode.com/svn/trunk/data/proxi.txt", "", proxi_internal.ReceiveVersion, funcCallback )
	
end
