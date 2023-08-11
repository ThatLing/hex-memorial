-- SaitoHUD
-- Copyright (c) 2009-2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$

--- Makes a psuedo class.
-- @return Table
function SaitoHUD.MakeClass(base)
    local t = {}
    
    setmetatable(t, {
        __call = function(self, ...)
            local arg = {...}
            local instance = {}
            setmetatable(instance, {__index = t, __tostring = t.__tostring})
            if t.Initialize then instance:Initialize(unpack(arg)) end
            return instance
        end,
        __index = base
    })
    
    return t
end

--- Create hooks based on a cvar.
-- @param name Name of cvar
-- @param id ID of hook
-- @param hooks List of hooks
function SaitoHUD.HookOnCvar(name, id, hooks, checkAUT)
    local rehook = function()
        local enabled = false
        
        if type(name) == 'table' then
            for _, v in pairs(name) do
                enabled = GetConVar(v):GetBool()
                if enabled then break end
            end
        else
            enabled = GetConVar(name):GetBool()
        end
        
        if checkAUT and SaitoHUD.AntiUnfairTriggered() then
            enabled = false
        end
        
        if enabled then
            for h, f in pairs(hooks) do
                hook.Add(h, id, f)
            end
        else
            for h, f in pairs(hooks) do
                pcall(hook.Remove, h, id)
            end
        end
    end
    
    name = type(name) == 'table' and name or { name }
    
    for _, v in pairs(name) do
        cvars.AddChangeCallback(v, rehook)
    end
    
    rehook()
end

--- Create hooks if a value is true.
-- @param enabled Hook or not
-- @param id ID of hook
-- @param hooks List of hooks
function SaitoHUD.HookIfTrue(enabled, id, hooks, checkAUT)
    if checkAUT and SaitoHUD.AntiUnfairTriggered() then
        enabled = false
    end
    
    if enabled then
        for h, f in pairs(hooks) do
            hook.Add(h, id, f)
        end
    else
        for h, f in pairs(hooks) do
            pcall(hook.Remove, h, id)
        end
    end
end

--- Safely remove a hook.
-- @param name Name of hook
function SaitoHUD.RemoveHook(name, id)
    local ret = nil
    local hooks = hook.GetTable()[name]
    
    if hooks ~= nil then
        hook.Remove(name, id)
    end
end

--- Gets the number of hooks registered.
-- @param name Name of hook
-- @return Number of hooks
function SaitoHUD.CountHooks(name)
    local ret = nil
    local hooks = hook.GetTable()[name]
    
    if hooks ~= nil then
        local count = 0
        for _, _ in pairs(hooks) do count = count + 1 end
        
        return count
    else
        return 0
    end
end

--- Calls a hook registered by hook.Add.
-- Unlike hook.Call, this function return the last non-nil result, or nil if
-- there was none.
-- @param name Name of hook
-- @param args Arguments
-- @return Last result
function SaitoHUD.CallHookLast(name, ...)
    local ret = nil
    local hooks = hook.GetTable()[name]
    
    if hooks ~= nil then
        for _, f in pairs(hooks) do
            local result = f(unpack(arg))
            if result ~= nil then
                ret = result
            end
        end
    end
    
    return ret
end

--- Calls a hook registered by hook.Add.
-- Unlike hook.Call, this function will collect non-nil values that are returned
-- by the hooks into a table, and then return this table. If there are no hooks
-- registered, then a table with 0 elements will be returned.
-- @param name Name of hook
-- @param args Arguments
-- @return Table of results
function SaitoHUD.CallHookAggregate(name, ...)
    local results = {}
    local hooks = hook.GetTable()[name]
    
    if hooks ~= nil then
        for _, f in pairs(hooks) do
            local result = f(unpack(arg))
            if result ~= nil then
                table.insert(results, result)
            end
        end
    end
    
    return results
end

--- Calls a hook registered by hook.Add.
-- Unlike hook.Call, this function will collect non-nil table values and merge
-- the tables into one final table.
-- @param name Name of hook
-- @param args Arguments
-- @return Table of results
function SaitoHUD.CallHookCombined(name, ...)
    local results = {}
    local hooks = hook.GetTable()[name]
    
    if hooks ~= nil then
        for _, f in pairs(hooks) do
            local result = f(unpack(arg))
            if result ~= nil and type(result) == 'table' then
                table.Add(results, result)
            end
        end
    end
    
    return results
end

--- Parses a CSV file.
-- @param data Data to parse
-- @return Table of rows
function SaitoHUD.ParseCSV(data)
    if data == nil then return {} end
    if data:Trim() == "" then return {} end
    
    local lines = string.Explode("\n", data:gsub("\r", ""))
    local result = {}
    
    for i, line in pairs(lines) do
        local line = line:Trim()
        
        if line ~= "" then
            local buffer = ""
            local escaped = false
            local inQuote = false
            local fields = {}
            
            for c = 1, #line do
                local char = line:sub(c, c)
                if escaped then
                    buffer = buffer .. char
                    escaped = false
                else
                    if char == "\\" then
                        escaped = true
                    elseif char == "\"" then
                        inQuote = not inQuote
                    elseif char == "," then
                        if inQuote then
                            buffer = buffer .. char
                        else
                            table.insert(fields, buffer)
                            buffer = ""
                        end
                    else
                        buffer = buffer .. char
                    end
                end
            end
            
            table.insert(fields, buffer)
            table.insert(result, fields)
       end
    end
    
    return result
end

--- Write CSV data.
-- @param data
-- @return CSV
function SaitoHUD.WriteCSV(data)
    local output = ""
    
    for _, v in pairs(data) do
        local line = ""
        for _, p in pairs(v) do
            if type(p) == 'boolean' then
                line = line .. ",\"" .. (p and "true" or "false") .. "\""
            else
                line = line .. ",\"" .. tostring(p):gsub("[\"\\]", "\\%1") .. "\""
            end
        end
        
        output = output .. "\n" .. line:sub(2)
    end
    
    return output:sub(2)
end

--- Shortcut function to load a CSV file from disk and drop the header row.
-- If the file doesn't exist or it's blank, an empty table will be returned.
-- @param path
-- @param headers List of headers to drop, in order
-- @return Table with entries
function SaitoHUD.LoadCSV(path, headers)
    headers = headers or {}
    
    local data = file.Read(path, "DATA")
    if data == nil or data == "" then return {} end
    
    data = SaitoHUD.ParseCSV(data)
    if #data == 0 then return {} end
    
    -- Remove headers
    local dropFirstRow = false
    for k, v in pairs(headers) do
        if data[1][k] == v then
            dropFirstRow = true
        else
            dropFirstRow = false
            break
        end
    end
    
    if dropFirstRow then table.remove(data, 1) end
    
    return data
end

--- Function to autocomplete console commands with player names.
-- @param cmd
-- @param args
function SaitoHUD.ConsoleAutocompletePlayer(cmd, args)
    local testName = args or ""
    if testName:len() > 0 then
        testName = testName:Trim()
    end
    local testNameLength = testName:len()
    local names = {}
    
    for _, ply in pairs(player.GetAll()) do
        local name = ply:GetName()
        if name:len() >= testNameLength and 
           name:sub(1, testNameLength):lower() == testName:lower() then
            if name:find(" ") or name:find("\"") then
                name = "\"" .. name:gsub("\"", "\\\"") .. "\""
            end
            table.insert(names, cmd .. " " .. name)
        end
    end
    
    return names
end

--- Tries to parse a vector from console command arguments.
-- @param args Arguments
-- @param skip Number of initial arguments to ignore
function SaitoHUD.ParseConcmdVector(args, skip, ang)
    if skip == nil then skip = 0 end
    local x, y, z
    
    if #args - skip == 1 then
        local r = string.Explode(",", args[1 + skip])
        if r[3] == nil then return nil end
        x = tonumber(r[1])
        y = tonumber(r[2])
        z = tonumber(r[3])
    elseif #args - skip == 3 then
        x = args[1 + skip]:gsub(",", "")
        y = args[2 + skip]:gsub(",", "")
        z = args[3 + skip]:gsub(",", "")
        x = tonumber(x)
        y = tonumber(y)
        z = tonumber(z)
    else
        return nil
    end
    
    if x ~= nil and y ~= nil and z ~= nil then
        return ang and Angle(x, y, z) or Vector(x, y, z)
    else
        return nil
    end
end

--- Tries to parse an angle from console command arguments.
-- @param args Arguments
-- @param skip Number of initial arguments to ignore
function SaitoHUD.ParseConcmdAngle(args, skip)
    return SaitoHUD.ParseConcmdVector(args, skip, true)
end

--- Parses a string into a table, as if it were a console command.
-- @params str
-- @return The table
function SaitoHUD.ParseCommand(str)
    local quoted = false
    local escaped = false
    local result = {}
    local buf = ""
    for c = 1, #str do
        local char = str:sub(c, c)
        if escaped then
            buf = buf .. char
            escaped = false
        elseif char == "\"" and quoted then
            quoted = false
            table.insert(result, buf)
            buf = ""
        elseif char == "\"" and buf == "" then
            quoted = true
        elseif char == " " and not quoted then
            if buf ~= "" then
                table.insert(result, buf)
                buf = ""
            end
        else
            buf = buf .. char
        end
    end
    if buf ~= "" then
        table.insert(result, buf)
    end
    return result
end

--- Draws the bounding box of an entity.
-- @param ent Entity to draw bounding box for
-- @param color Color to draw the bounding box in
function SaitoHUD.DrawBBox(ent, color)
    local obbMin = ent:OBBMins()
    local obbMax = ent:OBBMaxs()
    
    local p = {
        ent:LocalToWorld(Vector(obbMin.x, obbMin.y, obbMin.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMin.x, obbMax.y, obbMin.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMax.x, obbMax.y, obbMin.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMax.x, obbMin.y, obbMin.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMin.x, obbMin.y, obbMax.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMin.x, obbMax.y, obbMax.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMax.x, obbMax.y, obbMax.z)):ToScreen(),
        ent:LocalToWorld(Vector(obbMax.x, obbMin.y, obbMax.z)):ToScreen(),
    }
    
    local front = ent:LocalToWorld(Vector(0, 0, 40)):ToScreen()
    local front2 = ent:LocalToWorld(Vector(50, 0, 40)):ToScreen()
    
    -- Odd things happen if not all the points are visible
    local visible = true
    for i = 1, 8 do
        if not p[i].visible then
            visible = false
            break
        end
    end
    
    if visible then
        local r, g, b, a = color
        surface.SetDrawColor(r, g, b, a)
        
        -- Bottom
        surface.DrawLine(p[1].x, p[1].y, p[2].x, p[2].y)
        surface.DrawLine(p[2].x, p[2].y, p[3].x, p[3].y)
        surface.DrawLine(p[3].x, p[3].y, p[4].x, p[4].y)
        surface.DrawLine(p[4].x, p[4].y, p[1].x, p[1].y)
        -- Top
        surface.DrawLine(p[5].x, p[5].y, p[6].x, p[6].y)
        surface.DrawLine(p[6].x, p[6].y, p[7].x, p[7].y)
        surface.DrawLine(p[7].x, p[7].y, p[8].x, p[8].y)
        surface.DrawLine(p[8].x, p[8].y, p[5].x, p[5].y)
        -- Sides
        surface.DrawLine(p[1].x, p[1].y, p[5].x, p[5].y)
        surface.DrawLine(p[2].x, p[2].y, p[6].x, p[6].y)
        surface.DrawLine(p[3].x, p[3].y, p[7].x, p[7].y)
        surface.DrawLine(p[4].x, p[4].y, p[8].x, p[8].y)
        -- Bottom
        --surface.DrawLine(p[1].x, p[1].y, p[3].x, p[3].y)
    end
end

--- Draws a 2D line in 3D-space. This must be called within a cam.Start3D
-- section.
-- @param p1 Start
-- @param p2 End
function SaitoHUD.Draw3D2DLine(p1, p2)
    -- Draw the line
    cam.Start3D2D(p1, (p2 - p1):Angle(), 1)
    surface.DrawLine(0, 0, p1:Distance(p2), 0)
    cam.End3D2D()
end