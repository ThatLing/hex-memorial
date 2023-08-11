
--[[
local FrameTime = 0
local LastQuery = 0

function RealFrameTimeML() return FrameTime end

local function RealFrameTimeThink()

	FrameTime = math.Clamp( SysTime() - LastQuery, 0, 0.1 )
	LastQuery = SysTime()

end

hook.Add( "Think", "RealFrameTime", RealFrameTimeThink )
]]