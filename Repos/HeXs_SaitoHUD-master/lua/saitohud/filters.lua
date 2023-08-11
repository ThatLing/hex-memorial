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
-- $Id: filters.lua 184 2010-08-12 08:15:40Z the.sk89q $

local FilterContext = {}

--- Builds a new instance of a filter context
-- @param filterDef Filter definition table
-- @param tokens List of original tokens to produce the definition
-- @param filterFunc Function to filter with
function FilterContext:new(filterDef, tokens, filterFunc)
    local instance = {
        ["filterDef"] = filterDef,
        ["tokens"] = tokens,
        ["f"] = filterFunc,
    }
    
    setmetatable(instance, self)
    self.__index = self
    return instance
end

--- Creates a filter that will match nothing
-- @return Instance of FilterContext
function FilterContext.nullFilter()
    return FilterContext:new({}, {}, function() return false end)
end

--- Creates a filter that match anything
-- @return Instance of FilterContext
function FilterContext.universalFilter()
    return FilterContext:new({}, {"*"}, function() return true end)
end

local entityFilter = {}

-- Directive names and the number of arguments that each directive takes
entityFilter.directives = {
    ["mindist"] = 1,
    ["maxdist"] = 1,
    ["model"] = 1,
    ["material"] = 1,
    ["class"] = 1,
    ["id"] = 1,
    ["name"] = 1,
}

entityFilter.aliases = {
    ["min"] = "mindist",
    ["max"] = "maxdist",
    ["mdl"] = "model",
    ["mat"] = "material",
    ["cls"] = "class",
    ["nam"] = "name",
}

--- Helper method to build a list element of a filter definition
-- @param filterDef Filter definition table
-- @param key Key of list
-- @param item Value to update
function entityFilter.UpdateFilterDefList(filterDef, key, item)
    if item:sub(1, 1) == "-" then -- Blacklist
        key = key .. "Blacklist"
        item = item:sub(2)
        if not filterDef[key] then filterDef[key] = {} end
        if item != "*" then
            table.insert(filterDef[key], item)
        end
    else -- Whitelist
        if not filterDef[key] then filterDef[key] = {} end
        if item != "*" then
            table.insert(filterDef[key], item)
        end
    end
end

--- Builds a filter context. Note that this will modify the table of tokens,
-- and so a copy should be made if you wish to keep the original.
-- @param tokens List of filter arguments
-- @return Filter context
function entityFilter.Build(tokens, nilForNull)
    local ORBranches = {}
    local ANDBranches = {}
    local filterDef = {}
    local i = 1
    
    if #tokens == 0 or tokens[1] == "" then
        print("Matching no entities")
        if nilForNull then
            return nil
        end
        return FilterContext.nullFilter()
    elseif #tokens == 1 and tokens[1] == "*" then
        print("Matching all entities")
        return FilterContext.universalFilter()
    end
    
    while i <= #tokens do
        local token = tokens[i]
        local directive = nil
        
        -- Handle touching paranthesis
        if token:sub(1, 1) == "(" and token ~= "(" then
            table.insert(tokens, i + 1, token:sub(2))
            tokens[i] = "("
        elseif token:sub(-1) == ")" and token ~= ")" then
            table.insert(tokens, i, token:sub(1, -2))
            tokens[i + 1] = "("
        end
        
        if token == "*" then
            Error("Unexpected *") 
        elseif token:sub(1, 1) == "@" then
            directive = token:sub(2):lower()
        elseif token:lower() == "and" then
            if i == #tokens then
                Error("Missing condition(s) after explicit AND")
            elseif i == 1 then
                Error("Expression starts with an explicit AND")
            elseif tokens[i + 1]:lower() == "or" then
                Error("Two logic operators togthether")
            end
        elseif token:lower() == "or" then
            -- Collect the later tokens and add this to an OR branch
            local moreTokens = {}
            for k = i + 1, #tokens do
                table.insert(moreTokens, tokens[k])
            end
            if #moreTokens == 0 then
                Error("Missing condition(s) after OR")
            end
            table.insert(ORBranches, entityFilter.Build(moreTokens, false).f)
            break
        elseif token == "(" then
            -- Collect the tokens within the parenthesis
            local moreTokens = {}
            local depth = 0
            for k = i + 1, #tokens do
                if tokens[k] == "(" then
                    depth = depth + 1
                elseif tokens[k] == ")" then
                    if depth == 0 then
                        i = k
                        break
                    else
                        depth = depth - 1
                    end
                else
                    table.insert(moreTokens, tokens[k])
                end
            end
            table.insert(ANDBranches, entityFilter.Build(moreTokens, false).f)
        elseif token == ")" then
            Error("Parenthesis mismatch")
        else
            local a, b = string.match(token, "^([^:]+)=(.*)$")
            if a ~= nil then
                directive = a
                tokens[i] = b
                i = i - 1 -- We added a token unexpectedly
            else
                directive = "class"
                i = i - 1 -- We added a token unexpectedly
            end
        end
        
        if directive ~= nil then
            if entityFilter.aliases[directive] then
                directive = entityFilter.aliases[directive]
            end
            
            if entityFilter.directives[directive] then
                local reqArgCount = entityFilter.directives[directive]
                
                if #tokens - i >= reqArgCount then
                    if directive == "mindist" then
                        filterDef.minDist = tonumber(tokens[i + 1])
                    elseif directive == "maxdist" then
                        filterDef.maxDist = tonumber(tokens[i + 1])
                    elseif directive == "id" then
                        entityFilter.UpdateFilterDefList(filterDef, "id", tokens[i + 1])
                    elseif directive == "model" then
                        entityFilter.UpdateFilterDefList(filterDef, "model", tokens[i + 1])
                    elseif directive == "material" then
                        entityFilter.UpdateFilterDefList(filterDef, "material", tokens[i + 1])
                    elseif directive == "class" then
                        entityFilter.UpdateFilterDefList(filterDef, "cls", tokens[i + 1])
                    elseif directive == "name" then
                        entityFilter.UpdateFilterDefList(filterDef, "name", tokens[i + 1])
                    end
                    
                    i = i + reqArgCount
                else
                    Error(string.format("Insufficient number of tokenuments for %s (%d required)",
                                        directive, reqArgCount))
                end
            else
                Error("Unknown directive: " .. directive)
            end
        end
        
        i = i + 1
    end
    
    -- Now obsolete
    -- for k, v in pairs(filterDef) do
        -- if type(v) == "table" then
            -- print(k .. ":")
            -- for k, v in pairs(v) do
                -- print("- " .. v)
            -- end
        -- else
            -- print(k .. ": " .. v)
        -- end
    -- end
    
    local satisfiesList = entityFilter.SatisfiesListSubstring
    
    local filterFunc = function(ent, refPos)
        for _, f in pairs(ANDBranches) do
            if not f(ent, refPos) then return false end
        end
        
        local id = ent:EntIndex()
        local cls = ent:GetClass()
        local model = ent:GetModel()
        local material = ent:GetMaterial()
        local pos = ent:GetPos()
        
        local name = ""
        if ent:IsPlayer() then
            name = ent:GetName()
        end
        
        if pos and refPos then
            local distance = pos:Distance(refPos)
            
            if filterDef.minDist and distance < filterDef.minDist then
                return false
            end
            
            if filterDef.maxDist and distance > filterDef.maxDist then
                return false
            end
        end
        
        if not satisfiesList(filterDef.id, tostring(id), false, true) then return false end
        if not satisfiesList(filterDef.cls, cls) then return false end
        if not satisfiesList(filterDef.name, name) then return false end
        if not satisfiesList(filterDef.model, model) then return false end
        if not satisfiesList(filterDef.material, material) then return false end
        
        if satisfiesList(filterDef.idBlacklist, id, true, true) then return false end
        if satisfiesList(filterDef.clsBlacklist, cls, true) then return false end
        if satisfiesList(filterDef.nameBlacklist, name, true) then return false end
        if satisfiesList(filterDef.modelBlacklist, model, true) then return false end
        if satisfiesList(filterDef.materialBlacklist, material, true) then return false end
        
        return true
    end
    
    -- We have OR branches
    if #ORBranches > 0 then
        local newFilterFunc = function(ent, refPos)
            if filterFunc(ent, refPos) then return true end
            for _, f in pairs(ORBranches) do
                if f(ent, refPos) then return true end
            end
            
            return false
        end
        
        return FilterContext:new(filterDef, tokens, newFilterFunc)
    else
        return FilterContext:new(filterDef, tokens, filterFunc)
    end
end

--- Helper method for the filter function to check whether a string is
-- a substring of any item in a list
-- @param lst Whitelist
-- @param v Item to check
function entityFilter.SatisfiesListSubstring(lst, v, isBlacklist, strict)    
    if lst == nil then
        if isBlacklist then
            return false
        else
            return true
        end
    end
    
    if not v or v == "" then
        return false
    end
    
    if #lst == 0 and v then
        return true
    end
    
    if not strict then
        if isBlacklist then
            for _, test in pairs(lst) do
                if v:lower():find(test:lower()) then -- TODO: Possibly lowercase text beforehand
                    return true
                end
            end
            return false
        else
            for _, test in pairs(lst) do
                if not v:lower():find(test:lower()) then -- TODO: Possibly lowercase text beforehand
                    return false
                end
            end
            return true
        end
    else
        if isBlacklist then
            for _, test in pairs(lst) do
                if v == test then -- TODO: Possibly lowercase text beforehand
                    return true
                end
            end
            return false
        else
            for _, test in pairs(lst) do
                if v != test then -- TODO: Possibly lowercase text beforehand
                    return false
                end
            end
            return true
        end
    end
end

SaitoHUD.FilterContext = FilterContext
SaitoHUD.entityFilter = entityFilter