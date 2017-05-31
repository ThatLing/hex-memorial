
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
--[[
    **** Wing STool ****

    Purpose: Makes props simulate lift and drag like a wing

    Author: PackRat Updated for GMOD 13 By Rock

    Math for physics calcs adapted from the
    original wing script by ROBO_DONUT

    Code for Tool Menu by Exeption

	Version 1.2, 1st Jan, 2013

]]--

TOOL.Category	= "Construction"
TOOL.Name		= "#Wing Tool"
TOOL.Command	= nil
TOOL.ConfigName	= ""

if CLIENT then

    language.Add( "Tool.wing.name", "Wing Tool" )
    language.Add( "Tool.wing.desc", "Changes a prop's physical properties to simulate the drag and lift of a wing." )
    language.Add( "Tool.wing.0", "Primary: Create/Update Wing   Secondary: Copy Wing Settings" )

end

wingToolData = {}
wingToolData.wingArea            = 0.005
wingToolData.airDensity    		= 1.225
wingToolData.waterDensity         = 1000
wingToolData.liftCoefficient        = 1
wingToolData.dragCoefficient        = 0.6

TOOL.ClientConVar[ "lift" ] = wingToolData.liftCoefficient
TOOL.ClientConVar[ "drag" ] = wingToolData.dragCoefficient
TOOL.ClientConVar[ "area" ] = 0.5  -- meh this one is irrelevant anyway
TOOL.ClientConVar[ "include_area" ] = 0

wingEnts = {}
wingTime = CurTime()


function TOOL.BuildCPanel( CPanel )

    CPanel:AddControl( "Header", { Text = "#Tool.wing.name", Description  = "#Tool.wing.desc" }  )
    CPanel:AddControl( "Slider", { Label = "#Lift Coefficient", Type = "Float", Min = "0", Max = "20", Command = "wing_lift" } )
    CPanel:AddControl( "Slider", { Label = "#Drag Coefficient", Type = "Float", Min = "0", Max = "20", Command = "wing_drag" } )
    CPanel:AddControl( "Slider", { Label = "#Wing Area", Type = "Float", Min = "0", Max = "20", Command = "wing_area" } )
    CPanel:AddControl( "Checkbox", { Label = "#Allow tool to modify wing area", Command = "wing_include_area" } )

end


-- Create a new wing
function TOOL:LeftClick( tr )

    -- check for world or player
    if ( !tr.Entity ) then return false end
    if ( !tr.Entity:IsValid() ) then return false end
    if ( tr.Entity:IsPlayer() ) then return false end
    if ( tr.Entity:IsWorld() ) then return false end

    -- check for physics object
    if ( SERVER && !util.IsValidPhysicsObject( tr.Entity, tr.PhysicsBone ) ) then return false end

    if ( CLIENT ) then return true end

    -- get entity/bone
    local ent      = tr.Entity
    local bone    = tr.PhysicsBone
    local entid  = ent:EntIndex()
    local user    = self:GetOwner()

    -- new wing with defaults
    if ( !wingEnts[entid] ) then
        wingEnts[entid]   = {}
        wingEnts[entid].ent  = ent
        wingEnts[entid].bone    = bone
        wingEnts[entid].pos  = ent:GetPos()
        wingEnts[entid].ang  = ent:GetAngles()
        wingEnts[entid].area    = wingToolData.wingArea * ent:GetPhysicsObjectNum( bone ):GetMass()
        wingEnts[entid].lift    = wingToolData.liftCoefficient
        wingEnts[entid].drag    = wingToolData.dragCoefficient

        -- 255 byte message limit?
        user:SendLua("GAMEMODE:AddNotify(\"Wing created! (default settings)\", NOTIFY_GENERIC, 7); " ..
                     "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )

    -- update existing wing with custom values
    else
        wingEnts[entid].drag = tonumber(self:GetClientInfo( "drag" ))
        wingEnts[entid].lift = tonumber(self:GetClientInfo( "lift" ))
		if ( tonumber(self:GetClientInfo( "include_area" )) != 0 ) then
			wingEnts[entid].area = tonumber(self:GetClientInfo( "area" ))
		end

        -- 255 byte message limit?
        user:SendLua( "GAMEMODE:AddNotify(\"Wing updated!\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Lift: " .. wingEnts[entid].lift .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Drag: " .. wingEnts[entid].drag .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Area: " .. wingEnts[entid].area .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )
    end

    return true

end


-- get wing settings
function TOOL:RightClick( tr )

    -- check for world or player
    if ( !tr.Entity ) then return false end
    if ( !tr.Entity:IsValid() ) then return false end
    if ( tr.Entity:IsPlayer() ) then return false end
    if ( tr.Entity:IsWorld() ) then return false end

    -- check for physics object
    if ( SERVER && !util.IsValidPhysicsObject( tr.Entity, tr.PhysicsBone ) ) then return false end

    if ( CLIENT ) then return true end

    -- get entity/bone
    local ent      = tr.Entity
    local bone    = tr.PhysicsBone
    local entid  = ent:EntIndex()
    local user    = self:GetOwner()

    -- new wing
    if ( !wingEnts[entid] ) then return false end

    user:ConCommand( "wing_area " .. wingEnts[entid].area )
    user:ConCommand( "wing_drag " .. wingEnts[entid].drag )
    user:ConCommand( "wing_lift " .. wingEnts[entid].lift )

    -- 255 byte message limit?
    user:SendLua( "GAMEMODE:AddNotify(\"Wing #" .. entid .. " Settings:\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Lift: " .. wingEnts[entid].lift .. " (Def: 1)\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Drag: " .. wingEnts[entid].drag .. " (Def: 0.6)\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Area: " .. wingEnts[entid].area .. " (Def: " .. wingToolData.wingArea *
                                                  wingEnts[entid].ent:GetPhysicsObjectNum( bone ):GetMass()
                                                  .. ")\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )

    return true

end


function wingToolThink()

    if ( !SERVER ) then return end

    -- Calculate the time that the last frame took
    local time    = CurTime()
    local timeDiff    = time - wingTime
    wingTime            = time

    if timeDiff != 0 then
        for entid, wingData in pairs( wingEnts ) do
            if wingData.ent:IsValid() then

                -- Calculate wing velocity
                local pos         = wingData.ent:GetPos()
                local ang         = wingData.ent:GetForward()
                local velocity    = ang:DotProduct( wingData.pos - pos ) / timeDiff
                local direction   = Vector( 0, 0, 0 )

                if velocity != 0 then
                    direction = ( wingData.pos - pos )
                    direction:Normalize()
                end

                wingEnts[entid].ang = ang
                wingEnts[entid].pos = pos

                -- Set density to either water or air
                local density
                if wingData.ent:WaterLevel() >= 2 then
                    density = wingToolData.waterDensity
                else
                    density = wingToolData.airDensity
                end

                -- Calculate wing lift scaled by time of last frame.
                -- Formula from [url]http://en.wikipedia.org/wiki/Lift_(force)[/url].
                local lift = wingData.lift * density * ( velocity ^ 2 * 0.5 ) * wingData.area * timeDiff

                -- Calculate wing drag scaled by time of last frame.
                -- Formula from [url]http://en.wikipedia.org/wiki/Drag_equation[/url].
                local drag = 0.5 * density * velocity ^ 2 * wingData.area * wingData.drag * timeDiff

                -- Calculate net force
                local netForce = ( wingData.ent:GetUp() * lift ) + ( direction * drag )

                -- Apply force
                wingData.ent:GetPhysicsObjectNum( wingData.bone ):ApplyForceCenter( netForce )

            else

                -- Entity doesn't exist, remove it from the table
                wingEnts[entid] = nil

            end
        end
    end

end

if ( SERVER ) then hook.Add( "Think", "wingToolThink()", wingToolThink ) end

----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
--[[
    **** Wing STool ****

    Purpose: Makes props simulate lift and drag like a wing

    Author: PackRat Updated for GMOD 13 By Rock

    Math for physics calcs adapted from the
    original wing script by ROBO_DONUT

    Code for Tool Menu by Exeption

	Version 1.2, 1st Jan, 2013

]]--

TOOL.Category	= "Construction"
TOOL.Name		= "#Wing Tool"
TOOL.Command	= nil
TOOL.ConfigName	= ""

if CLIENT then

    language.Add( "Tool.wing.name", "Wing Tool" )
    language.Add( "Tool.wing.desc", "Changes a prop's physical properties to simulate the drag and lift of a wing." )
    language.Add( "Tool.wing.0", "Primary: Create/Update Wing   Secondary: Copy Wing Settings" )

end

wingToolData = {}
wingToolData.wingArea            = 0.005
wingToolData.airDensity    		= 1.225
wingToolData.waterDensity         = 1000
wingToolData.liftCoefficient        = 1
wingToolData.dragCoefficient        = 0.6

TOOL.ClientConVar[ "lift" ] = wingToolData.liftCoefficient
TOOL.ClientConVar[ "drag" ] = wingToolData.dragCoefficient
TOOL.ClientConVar[ "area" ] = 0.5  -- meh this one is irrelevant anyway
TOOL.ClientConVar[ "include_area" ] = 0

wingEnts = {}
wingTime = CurTime()


function TOOL.BuildCPanel( CPanel )

    CPanel:AddControl( "Header", { Text = "#Tool.wing.name", Description  = "#Tool.wing.desc" }  )
    CPanel:AddControl( "Slider", { Label = "#Lift Coefficient", Type = "Float", Min = "0", Max = "20", Command = "wing_lift" } )
    CPanel:AddControl( "Slider", { Label = "#Drag Coefficient", Type = "Float", Min = "0", Max = "20", Command = "wing_drag" } )
    CPanel:AddControl( "Slider", { Label = "#Wing Area", Type = "Float", Min = "0", Max = "20", Command = "wing_area" } )
    CPanel:AddControl( "Checkbox", { Label = "#Allow tool to modify wing area", Command = "wing_include_area" } )

end


-- Create a new wing
function TOOL:LeftClick( tr )

    -- check for world or player
    if ( !tr.Entity ) then return false end
    if ( !tr.Entity:IsValid() ) then return false end
    if ( tr.Entity:IsPlayer() ) then return false end
    if ( tr.Entity:IsWorld() ) then return false end

    -- check for physics object
    if ( SERVER && !util.IsValidPhysicsObject( tr.Entity, tr.PhysicsBone ) ) then return false end

    if ( CLIENT ) then return true end

    -- get entity/bone
    local ent      = tr.Entity
    local bone    = tr.PhysicsBone
    local entid  = ent:EntIndex()
    local user    = self:GetOwner()

    -- new wing with defaults
    if ( !wingEnts[entid] ) then
        wingEnts[entid]   = {}
        wingEnts[entid].ent  = ent
        wingEnts[entid].bone    = bone
        wingEnts[entid].pos  = ent:GetPos()
        wingEnts[entid].ang  = ent:GetAngles()
        wingEnts[entid].area    = wingToolData.wingArea * ent:GetPhysicsObjectNum( bone ):GetMass()
        wingEnts[entid].lift    = wingToolData.liftCoefficient
        wingEnts[entid].drag    = wingToolData.dragCoefficient

        -- 255 byte message limit?
        user:SendLua("GAMEMODE:AddNotify(\"Wing created! (default settings)\", NOTIFY_GENERIC, 7); " ..
                     "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )

    -- update existing wing with custom values
    else
        wingEnts[entid].drag = tonumber(self:GetClientInfo( "drag" ))
        wingEnts[entid].lift = tonumber(self:GetClientInfo( "lift" ))
		if ( tonumber(self:GetClientInfo( "include_area" )) != 0 ) then
			wingEnts[entid].area = tonumber(self:GetClientInfo( "area" ))
		end

        -- 255 byte message limit?
        user:SendLua( "GAMEMODE:AddNotify(\"Wing updated!\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Lift: " .. wingEnts[entid].lift .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Drag: " .. wingEnts[entid].drag .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "GAMEMODE:AddNotify(\"Area: " .. wingEnts[entid].area .. "\", NOTIFY_GENERIC, 7);" )
        user:SendLua( "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )
    end

    return true

end


-- get wing settings
function TOOL:RightClick( tr )

    -- check for world or player
    if ( !tr.Entity ) then return false end
    if ( !tr.Entity:IsValid() ) then return false end
    if ( tr.Entity:IsPlayer() ) then return false end
    if ( tr.Entity:IsWorld() ) then return false end

    -- check for physics object
    if ( SERVER && !util.IsValidPhysicsObject( tr.Entity, tr.PhysicsBone ) ) then return false end

    if ( CLIENT ) then return true end

    -- get entity/bone
    local ent      = tr.Entity
    local bone    = tr.PhysicsBone
    local entid  = ent:EntIndex()
    local user    = self:GetOwner()

    -- new wing
    if ( !wingEnts[entid] ) then return false end

    user:ConCommand( "wing_area " .. wingEnts[entid].area )
    user:ConCommand( "wing_drag " .. wingEnts[entid].drag )
    user:ConCommand( "wing_lift " .. wingEnts[entid].lift )

    -- 255 byte message limit?
    user:SendLua( "GAMEMODE:AddNotify(\"Wing #" .. entid .. " Settings:\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Lift: " .. wingEnts[entid].lift .. " (Def: 1)\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Drag: " .. wingEnts[entid].drag .. " (Def: 0.6)\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "GAMEMODE:AddNotify(\"Area: " .. wingEnts[entid].area .. " (Def: " .. wingToolData.wingArea *
                                                  wingEnts[entid].ent:GetPhysicsObjectNum( bone ):GetMass()
                                                  .. ")\", NOTIFY_GENERIC, 7);" )
    user:SendLua( "surface.PlaySound( \"ambient/water/drip\"..math.random(1, 4)..\".wav\" )" )

    return true

end


function wingToolThink()

    if ( !SERVER ) then return end

    -- Calculate the time that the last frame took
    local time    = CurTime()
    local timeDiff    = time - wingTime
    wingTime            = time

    if timeDiff != 0 then
        for entid, wingData in pairs( wingEnts ) do
            if wingData.ent:IsValid() then

                -- Calculate wing velocity
                local pos         = wingData.ent:GetPos()
                local ang         = wingData.ent:GetForward()
                local velocity    = ang:DotProduct( wingData.pos - pos ) / timeDiff
                local direction   = Vector( 0, 0, 0 )

                if velocity != 0 then
                    direction = ( wingData.pos - pos )
                    direction:Normalize()
                end

                wingEnts[entid].ang = ang
                wingEnts[entid].pos = pos

                -- Set density to either water or air
                local density
                if wingData.ent:WaterLevel() >= 2 then
                    density = wingToolData.waterDensity
                else
                    density = wingToolData.airDensity
                end

                -- Calculate wing lift scaled by time of last frame.
                -- Formula from [url]http://en.wikipedia.org/wiki/Lift_(force)[/url].
                local lift = wingData.lift * density * ( velocity ^ 2 * 0.5 ) * wingData.area * timeDiff

                -- Calculate wing drag scaled by time of last frame.
                -- Formula from [url]http://en.wikipedia.org/wiki/Drag_equation[/url].
                local drag = 0.5 * density * velocity ^ 2 * wingData.area * wingData.drag * timeDiff

                -- Calculate net force
                local netForce = ( wingData.ent:GetUp() * lift ) + ( direction * drag )

                -- Apply force
                wingData.ent:GetPhysicsObjectNum( wingData.bone ):ApplyForceCenter( netForce )

            else

                -- Entity doesn't exist, remove it from the table
                wingEnts[entid] = nil

            end
        end
    end

end

if ( SERVER ) then hook.Add( "Think", "wingToolThink()", wingToolThink ) end
