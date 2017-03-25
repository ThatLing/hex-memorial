
local function MyCall(lev)
	local DGI = debug.getinfo(3)
	if not DGI then return "Gone",0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	return Path,Line
end



local SendLua = _R.Player.SendLua

function _R.Player.SendLua(self,lua)
	local Path,Line = MyCall()
	
	print( Format("! SendLua @ '%s': [%s:%s]", self:Nick(), Path,Line) )
	return SendLua(self,lua)
end

















