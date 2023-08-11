////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Base                                       //
////////////////////////////////////////////////
-- proxi table is declared by the Cloud. Don't empty it on this file.

-- Don't use local shortcut here, it fails (index upvalue)
----local proxi = proxi

PROXI_SHORT = "PROXI"

proxi_util = {}

function proxi.IsEnabled()
	-- Here we use proxi and no method form, as an extra security for external scripts
	-- that would try to call proxi.IsEnabled()
	return proxi:GetVar("core_enable") > 0

end

function proxi.ReloadFromCloud()
	if proxi_cloud then
		proxi_cloud:Ask()
	end
	
end

function proxi.ReloadFromLocale()
	if proxi_cloud then
		proxi_cloud:LoadLocale()
	end
	
end

function proxi.QuickThink()
	proxi:UpdateBeacons()

end


function proxi.Mount()
	local self = proxi
	
	proxi_util.OutputLineBreak( )
	proxi_util.OutputIn( "Mounting ..." )
	
	proxi.dat = {}
	
	self:RequireParameterMediator( )
	self:CreateVarParam( "bool", "core_enable", "1", { callback = function( sCvar, prev, new )
			if not proxi then return end
			-- The following line is performed by the param already, as it is a bool.
			--if (tonumber( new ) <= 0 and tonumber( prev ) <= 0) or (tonumber( new ) > 0 and tonumber( prev ) > 0) then return end
			
			if tonumber( new ) > 0 then
				proxi:MountBeacons()
			
			else
				proxi:UnmountBeacons()
				
			end
			
		end } )
		
	self:CreateVarParam( "range", "global_finderdistance", "8192")
	self:CreateVarParam( "range", "regmod_xrel", "0.2" )
	self:CreateVarParam( "range", "regmod_yrel", "0.2")
	self:CreateVarParam( "range", "regmod_size", "172")
	self:CreateVarParam( "range", "regmod_pinscale", "5")
	self:CreateVarParam( "range", "regmod_fov", "45")
	self:CreateVarParam( "range", "regmod_radius", "2048")
	self:CreateVarParam( "range", "regmod_angle", "50")
	self:CreateVarParam( "range", "regmod_pitchdyn", "2")
	self:CreateVarParam( "bool", "eyemod_override", "0")
	self:CreateVarParam( "color", "uidesign_ringcolor", {147, 201, 224, 255} )
	self:CreateVarParam( "color", "uidesign_backcolor", {32, 37, 43, 128} )
	
	
	self.cmdGroups = {}
	self.cmdGroups.call = {}
	self:AppendCmd( self.cmdGroups, "core_enable", function(p,c,args) self:SetVar("core_enable", args[1] ) end )
	self:AppendCmd( self.cmdGroups.call, "changelog", function() self.ShowChangelog( self ) end )
	self:AppendCmd( self.cmdGroups.call, "menu", function() self.OpenMenu( self ) end )
	self:AppendCmd( self.cmdGroups, "menu", function() self.OpenMenu( self ) end )
	self:AppendCmd( self.cmdGroups, "+menu", function() self.OpenMenu( self ) end )
	self:AppendCmd( self.cmdGroups, "-menu", function() self.CloseMenu( self ) end )
	
	self.cmdGroupsNoRemove = {}
	self:AppendCmd( self.cmdGroupsNoRemove, "cloud_locale", proxi.ReloadFromLocale )
	
	self:BuildCmds( self.cmdGroups, "" )
	self:BuildCmds( self.cmdGroupsNoRemove, "" )
	
	self:MountMenu()
	
	hook.Add( "Think", "proxi.QuickThink", proxi.QuickThink )
	hook.Add( "HUDPaint", "proxi.HUDPaint", proxi.HUDPaint )
	
	proxi:RemoveAllPhysicalTags()
	proxi:MountBeacons( )

	proxi_util.OutputIn( "Mount complete : " .. (proxi_internal.IsUsingCloud() and "Cloud" or "Locale") )
	proxi_util.OutputLineBreak( )
	
end

function proxi.Unmount()
	local self = proxi

	local bOkay, strErr = pcall(function()
		-- Insert parachute Unmount
		
		proxi_util.OutputLineBreak( )
		proxi_util.OutputOut( "Unmounting ..." )
		
		self:DestroyChangelog()
		self:UnmountMenu()
		self:DismountCmds( self.cmdGroups )
		
		proxi_simmap = nil
		hook.Remove( "HUDPaint", "proxi.HUDPaint" )
		hook.Remove( "Think", "proxi.QuickThink" )
		
		
		proxi_util.OutputOut( "Unmount complete." )
		proxi_util.OutputLineBreak( )
		
	end)
	if not bOkay then
		proxi_util.OutputError( tostring(strErr) , "while unmounting" )
		
	end
	
	-- Don't remove proxi_util
	-- proxi_util = {}
	proxi = nil
	
end


