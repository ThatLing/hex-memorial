////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Beacons System                             //
////////////////////////////////////////////////
local proxi = proxi

-- Won't make a metatable because there are so few base functions

local PROXI_BEACONS    = {}
local PROXI_STANDALONE = {}
local PROXI_BEACONORDER = {}

local PROXI_LastQueryBeacons = 0
local PROXI_BeaconQueryDelay = 0.1 -- Seconds.

local PROXI_TaggedEntities = {}

function proxi:ResetAllTags()
	//debug.Trace()
	//print( "Reset all tags." )
	PROXI_TaggedEntities = {}
	proxi:RemoveAllPhysicalTags()
	
end

function proxi:RemoveAllPhysicalTags()
	local allEnts = ents.GetAll()
	for _,ent in pairs( allEnts ) do
		if ValidEntity( ent ) then
			ent.__proxi_hasTags = nil
			ent.__proxi_tags = nil
		end
		
	end
	
end

function proxi:UpdateBeacons()
	if CurTime() < (PROXI_LastQueryBeacons + PROXI_BeaconQueryDelay) then return end
	PROXI_LastQueryBeacons = CurTime()
	
	local allEnts = ents.GetAll()
	for _,ent in pairs( allEnts ) do
		local couldTag = self:TagEntity( ent )
		
		-- couldTag can be a BOOLEAN or NIL :: "if (couldTag == true)" DOES NOT EQUAL TO "if (couldtag)"
		-- Actually, if there were only "(clouldTag)" it could work.
		-- If there is a case where I need "coundTag == false" then do "couldTag == false" and not "not couldTag"
		if couldTag == true then
			table.insert( PROXI_TaggedEntities, ent )
			
		end
		
	end
	
	local i = 1
	while i <= #PROXI_TaggedEntities do
		if not ValidEntity( PROXI_TaggedEntities[ i ] ) then
			table.remove( PROXI_TaggedEntities, i )
			
		else
			i = i + 1
			
		end
		
	end
	
end

function proxi:GetAllBeacons()
	return PROXI_BEACONS
	
end

function proxi:GetTaggedEntities()
	return PROXI_TaggedEntities
	
end

function proxi:TagEntity( ent )
	if not ValidEntity( ent ) then return nil end
	if ent.__proxi_hasTags ~= nil then return nil end -- CAN'T DEFINE TAGS ON AN ENTITIES THAT ALREADY HAVE.
	
	ent.__proxi_hasTags = false
	local tags = {}
	for tag,objBecon in pairs( PROXI_BEACONS ) do
		-- NO MATTER IF THE BEACON IS ENABLED OR NOT
		// Think about algorithm again ?
		if not objBecon.IsStandAlone then
			if objBecon:ShouldTag( ent ) then
				table.insert(tags, tag)
				
			end
			
		end
		
	end
	
	if #tags > 0 then
		ent.__proxi_hasTags = true
		ent.__proxi_tags = tags
		
	end
	
	return ent.__proxi_hasTags
	
end

local PROXI_STEPS = { 
	[0] = "PerformMath",
	[1] = "DrawUnderCircle",
	[2] = "DrawUnderCircle2D",
	[3] = "DrawOverCircle",
	[4] = "DrawOverCircle2D",
	[5] = "DrawOverEverything"
}

function proxi:DebugBeaconOps( tEnts, iStep )
	local sStep = PROXI_STEPS[iStep]
	self:DebugEntOps( sStep, tEnts, self:GetCurrentViewData() )
	self:DebugStandAloneOps( sStep )
	
end

function proxi:DebugEntOps( sStep, tEnts, viewData )
	for k,ent in pairs( tEnts ) do
		if ValidEntity( ent ) then
			for l,tag in pairs( ent.__proxi_tags ) do
				// should we Run a check on the tag existence ? ?
				local objBeacon = PROXI_BEACONS[tag]
				if objBeacon[sStep] and objBeacon:IsEnabled() and not objBeacon:IsEntityOffLimits( ent, viewData ) then
					objBeacon[sStep]( objBeacon, ent )
					
				end
				
			end
			
		end
		
	end
	
end

function proxi:DebugStandAloneOps( sStep, viewData )
	for k,tag in pairs ( PROXI_STANDALONE ) do
		local objBeacon = PROXI_BEACONS[tag]
		if objBeacon[sStep] and objBeacon:IsEnabled() then
			objBeacon[sStep]( objBeacon )
			
		end
		
	end
	
end

function proxi:MountBeacons( )
	self:ResetAllTags()
	
	for tag,objBeacon in pairs ( PROXI_BEACONS ) do
		if objBeacon:IsEnabled( ) then
			objBeacon:Mount( true )
			
		end
		
	end
	
end

function proxi:UnmountBeacons( )
	self:ResetAllTags()
	
	for tag,objBeacon in pairs ( PROXI_BEACONS ) do
		objBeacon:Unmount( true )
		
	end
	
end

function proxi:OrderBeaconTable()
	table.sort( PROXI_BEACONORDER, function( a, b )
		return (PROXI_BEACONS[a]:GetBarnstar() == PROXI_BEACONS[b]:GetBarnstar()) and (PROXI_BEACONS[a]:GetDisplayName() < PROXI_BEACONS[b]:GetDisplayName()) or (PROXI_BEACONS[a]:GetBarnstar() > PROXI_BEACONS[b]:GetBarnstar())
		
	end )
	
end

function proxi:GetBeaconOrderTable()
	return PROXI_BEACONORDER
end


/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


local BEACON = {}

function BEACON:IsEnabled( )
	return proxi:GetVar("beacons_enable_" .. self._rawname) > 0
	
end

function BEACON:GetDisplayName( )
	return self.Name
	
end

function BEACON:GetRawName( )
	return self._rawname
	
end

function BEACON:GetDescription( )
	return self.Description or nil
	
end

function BEACON:GetBarnstar()
	return proxi:GetVar( "beacons_barnstar_" .. self._rawname )
	
end

function BEACON:IsMounted()
	return self._IsMounted
end

function BEACON:HasBypassDistance( )
	return self._CanBypassDistance
end

function BEACON:IsBypassingDistance( )
	return not self._CanBypassDistance or (proxi:GetVar( "beacons_settings_" .. self._rawname .. "__bypassdistance" ) > 0)
end

function BEACON:IsEntityOffLimits( ent, viewData, optb_forceTest )
	if not optb_forceTest and self:IsBypassingDistance( ) then return false end
	
	if self.IsEntityOffLimitsCustom then
		return self:IsEntityOffLimitsCustom( ent, viewData )
	end
	return (ent:GetPos() - viewData.referencepos):Length() > viewData.bypass_distance // TODO : RADIUS
end


function BEACON:Mount( optbNoTagReset )
	if self._IsMounted then return false end
	
	if self.Load then
		local bOkay, strErr = pcall(function() self:Load() end)
		if not bOkay then Error(" > " .. PROXI_NAME .. " MountPlugin ERROR [".. self._rawname .."] : ".. strErr) end
	end
	
	for hookName, func in pairs(self.Hooks) do
		hook.Add( hookName , "proxi_" .. self._rawname .. "_" .. hookName , func )
		
	end
	
	self._IsMounted = true
	
	if not optbNoTagReset then proxi:ResetAllTags() end
	
end

function BEACON:Unmount( optbNoTagReset )
	if not self._IsMounted then return false end
	
	for hookName, func in pairs(self.Hooks) do
		hook.Remove( hookName , "proxi_" .. self._rawname .. "_" .. hookName)
	end
	
	if self.Unload then
		local bOkay, strErr = pcall(function() self:Unload() end)
		if not bOkay then ErrorNoHalt(" > " .. INSCRIPT_NAME .. " UnmountPlugin ERROR [".. self._rawname .."] : ".. strErr) end
		
	end
	
	self._IsMounted = false
	
	if not optbNoTagReset then proxi:ResetAllTags() end
end

local proxi_beacon_meta = {__index=BEACON}



-- LIBVAR

function proxi.RegisterBeacon( objBeacon, sName )
	proxi:RequireParameterMediator( )
	
	if not objBeacon or not sName then return end
	sName = string.lower( sName )
	if string.find( sName, " " ) or string.find( sName, "_" ) or PROXI_BEACONS[sName] then return end
	
	objBeacon.IsStandAlone = objBeacon.IsStandAlone or false
	if objBeacon.IsStandAlone then
		table.insert(PROXI_STANDALONE, sName)
		
	elseif not objBeacon.ShouldTag then
		return -- ERROR : Not standalone but no way to tag either ! It's invalid !
		
	else
		objBeacon._CanBypassDistance = (objBeacon.CanBypassDistance == nil) or objBeacon.CanBypassDistance
		
	end
	
	objBeacon._IsMounted = false
	
	objBeacon.Name = objBeacon.Name or ("<" .. sName .. ">")
	objBeacon._rawname = sName
	
	objBeacon.Hooks = {}
	if objBeacon.HOOK then		
		for name, func in pairs( objBeacon.HOOK ) do
			if type(func) == "function" then
				objBeacon.Hooks[name] = function(...)
					if not proxi or not proxi.IsEnabled or not proxi.IsEnabled() then return end
					return func( objBeacon, ... )
					
				end
			end
		end
		
	end
	
	PROXI_BEACONS[sName] = objBeacon
	table.insert( PROXI_BEACONORDER, sName )
	
	proxi:CreateVarParam("bool", "beacons_barnstar_" .. sName, "0", true, false)
	if objBeacon._CanBypassDistance then
		proxi:CreateVarParam("bool", "beacons_settings_" .. sName .. "__bypassdistance", (objBeacon.DefaultBypassDistance or false) and "1" or "0")
	
	end
	proxi:CreateVarParam("bool", "beacons_enable_" .. sName, (objBeacon.DefaultOn or false) and "1" or "0", { callback = function( sCvar, prev, new )
		--local name = string.gsub( sCvar, proxi:GetVarName( "beacons_enable_" ), "" )
		
		if not proxi then return end
		if not proxi.GetAllBeacons or not proxi:GetAllBeacons() or not proxi:GetAllBeacons()[ sName ]  then return end
		
		if tonumber( new ) > 0 then
			proxi:GetAllBeacons()[ sName ]:Mount()
		
		else
			proxi:GetAllBeacons()[ sName ]:Unmount()
			
		end
		
	end } )
	
	setmetatable(objBeacon, proxi_beacon_meta)
	
	proxi:OrderBeaconTable()
	
end
