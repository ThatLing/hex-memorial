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

--- Remove the empty (string) entries from a table. This modifies the table
-- in-place and returns it for convenience.
-- @param t
-- @return t
local function RemoveEmptyEntries(t)
    if #t == 1 then return t end
    
    local i = 2
    while i <= #t do
        if t[i]:Trim() == "" then
            table.remove(t, i)
        else
            i = i + 1
        end
    end
    
    return t
end

SaitoHUD.VAR_CONCMD_GEOM_POINT = "VAR_CONCMD_GEOM_POINT"
SaitoHUD.VAR_CONCMD_GEOM_LINE = "VAR_CONCMD_GEOM_LINE"
SaitoHUD.VAR_CONCMD_ENTITY = "VAR_CONCMD_ENTITY"

--- Parse a console command's arguments using a variable number of
-- arguments.
-- @param params Table containing parameter information
-- @param maxLeftOver Maximum number of free arguments to allow
-- @return Parsed variables
function SaitoHUD.ParseVarConcmd(args, params, maxLeftOver)
    maxLeftOver = maxLeftOver or 0
    
    local i = 1
    local result = {}
    
    for _, param in pairs(params) do
        local name = param.Name
        local type = param.Type
        local wantedNumArgs = param.NumArgs or 1
        local cast = param.Cast
        local optional = param.Optional
        
        -- Preprocessing
        if type == SaitoHUD.VAR_CONCMD_GEOM_POINT then
            if #args == 0 then
                if not param.ImplicitTrace then
                    if optional then return result end
                    print("Insufficient number of arguments")
                    return
                end
                
                local tr = SaitoHUD.GetRefTrace()
                result[name] = tr.HitPos
            elseif args[1]:sub(1, 1) == "#" then
                local id = table.remove(args, 1):Trim():sub(2)
                
                if SaitoHUD.GEOM.Points[id] then
                    result[name] = SaitoHUD.GEOM.Points[id]
                else
                    print(string.format("GEOM library: No point by name of '%s'", id))
                    return
                end
            elseif args[1]:sub(1, 1) == "$" then
                local id = table.remove(args, 1):Trim():sub(2)
                local pt = SaitoHUD.GEOM.GetBuiltInPoint(id)
                
                if pt then
                    result[name] = pt
                else
                    print(string.format("GEOM library: No built-in point by name of '%s'", id))
                    return
                end
            else
                wantedNumArgs = 3
                if not cast then cast = Vector end
            end
        elseif type == SaitoHUD.VAR_CONCMD_GEOM_LINE then
            if #args == 0 then
                if optional then return result end
                print("Insufficient number of arguments")
                return
            elseif args[1]:sub(1, 1) == "#" then
                local id = table.remove(args, 1):Trim():sub(2)
                
                if SaitoHUD.GEOM.LineSegments[id] then
                    result[name] = SaitoHUD.GEOM.LineSegments[id]
                else
                    print(string.format("GEOM library: No line segment by name of '%s'", id))
                    return
                end
            elseif args[1]:sub(1, 1) == "$" then
                local id = table.remove(args, 1):Trim():sub(2)
                local segment = SaitoHUD.GEOM.GetBuiltInLine(id)
                
                if segment then
                    result[name] = segment
                else
                    print(string.format("GEOM library: No built-in line segment by name of '%s'", id))
                    return
                end
            else
                print("GEOM library: Line segments must specified by name")
                return
            end
        elseif type == SaitoHUD.VAR_CONCMD_ENTITY then
            if #args == 0 then
                if not param.ImplicitTrace then
                    if optional then return result end
                    print("Insufficient number of arguments")
                    return
                end
                
                local tr = SaitoHUD.GetRefTrace()
                if IsValid(tr.Entity) or optional then
                    result[name] = tr.Entity
                else
                    print("No entity in trace")
                    return
                end
            elseif args[1]:sub(1, 1) == "#" then
                local id = tonumber(table.remove(args, 1):Trim():sub(2))
                
                if not id then
                    print("Entity ID required")
                    return
                else
                    local ent = ents.GetByIndex(id)
                    if IsValid(ent) then
                        result[name] = ent
                    else
                        print(string.format("Unknown entity with ID %d", id))
                        return
                    end
                end
            elseif args[1]:sub(1, 1) == "$" then
                local id = table.remove(args, 1):Trim():sub(2)
                
                if id == "trace" then
                    local tr = SaitoHUD.GetRefTrace()
                    result[name] = tr.Entity
                else
                    print(string.format("No built-in entity by name of '%s'", id))
                    return
                end
            else
                print("Unknown entity argument")
                return
            end
        elseif type ~= nil then
            Error("ParseVarConcmd() got an unknown type: " .. type)
        end
        
        if not result[name] then
            -- No splitting by commas here
            if wantedNumArgs == 1 then
                -- Not enough arguments?
                if #args == 0 then
                    if optional then return result end
                    print("Insufficient number of arguments")
                    return
                end
                
                result[name] = table.remove(args, 1)
                
                if cast then result[name] = cast(result[name]) end
            else
                local extracted = {}
                
                while wantedNumArgs > #extracted do
                    -- Not enough arguments?
                    if #args == 0 then
                        if optional then return result end
                        print("Insufficient number of arguments")
                        return
                    end
                    
                    local res = string.Explode(",", table.remove(args, 1))
                    for _, r in pairs(RemoveEmptyEntries(res)) do
                        table.insert(extracted, r)
                    end
                end
                
                if #extracted > wantedNumArgs then
                    print("Too many arguments")
                    return
                end
                
                result[name] = extracted
                
                if cast then result[name] = cast(unpack(extracted)) end
            end
        end
    end
    
    if #args > maxLeftOver then
        print("Too many arguments")
        return
    end
    
    return result
end