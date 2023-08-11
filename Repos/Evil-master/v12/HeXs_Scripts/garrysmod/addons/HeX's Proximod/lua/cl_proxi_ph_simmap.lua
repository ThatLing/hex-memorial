////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Simmap                                    //
////////////////////////////////////////////////

proxi_simmap = {}

local PROXI_SIMMAP_SPACE_TOLERENCE = 4
local PROXI_SIMMAP_Z_TOLERENCE = 16

local PROXI_SIMMAP_IsBuilding = false
local PROXI_SIMMAP_Thread = {}

function proxi_simmap.PrepareSimmapBuild_OnlyZ( vPos, iExtent )
	PROXI_SIMMAP_IsBuilding = true
	
	iExtent = iExtent - iExtent % PROXI_SIMMAP_SPACE_TOLERENCE
	if iExtent > 1 then
		vPos.x = vPos.x - vPos.x % PROXI_SIMMAP_SPACE_TOLERENCE
		vPos.y = vPos.y - vPos.y % PROXI_SIMMAP_SPACE_TOLERENCE
		vPos.z = vPos.z - vPos.z % PROXI_SIMMAP_Z_TOLERENCE
		
		table.insert( PROXI_SIMMAP_Thread, {vPos, iExtent, 0} )
	else
		Error("Proxi ERROR : Passed an extent than can be simplified to nothing !")
		
	end
	
end

function proxi_simmap.BuildArea( tThread )
	
	
end








