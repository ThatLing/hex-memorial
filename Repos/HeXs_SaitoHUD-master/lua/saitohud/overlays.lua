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

local excludeClasses = {
    viewmodel = true,
    physgun_beam = true,
    gmod_tool = true,
    gmod_camera = true,
    worldspawn = true,
}

local evaluateOnEveryDraw = CreateClientConVar("overlays_continuous_eval", "0", true, false)

SaitoHUD.OverlayTypes = {}

local lastOverlayMatch = 0

--- Builds the cache of matched of entities. This is to significantly increase
-- performance, as evaluating the filter is a fairly resource intensive task.
local function EvaluateFilters()
    local refPos = SaitoHUD.GetRefPos()
    
    -- Clear match lists
    for id, data in pairs(SaitoHUD.OverlayTypes) do
        data.Matches = {}
    end
    
    -- Evaluate filters
    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) then
            local cls = ent:GetClass()
            local pos = ent:GetPos()
            
            -- Class may be empty
            if cls == "" or not cls then
                cls = "<?>"
            end
            
            if not excludeClasses[cls] then
                -- Add to matches
                for id, data in pairs(SaitoHUD.OverlayTypes) do
                    if data.Filter and data.Filter.f(ent, refPos) then
                        table.insert(data.Matches, ent)
                    end
                end
            end
        end
    end
    
    -- Post evaluate hook
    for id, data in pairs(SaitoHUD.OverlayTypes) do
        if data.Filter and data.OnPostEvaluate then
            data.OnPostEvaluate()
        end
    end
end

--- Do the drawing.
local function Draw()
    -- Evaluate filters
    if CurTime() - lastOverlayMatch > 1 or evaluateOnEveryDraw:GetBool() then
        EvaluateFilters()
        lastOverlayMatch = CurTime()
    end
    
    for id, data in pairs(SaitoHUD.OverlayTypes) do
        -- Paint HUD hook
        if data.Filter and data.HUDPaint then
            data.HUDPaint()
        end
        
        -- Draw each entity
        for _, ent in pairs(data.Matches) do
            if IsValid(ent) then
                data.DrawEnt(ent)
            end
        end
    end
end

--- Create/remove hooks.
local function Rehook()
    local hasActive = false
    
    for id, data in pairs(SaitoHUD.OverlayTypes) do
        if data.Filter then
            hasActive = true
            break
        end
    end
    
    if hasActive then
        hook.Add("HUDPaint", "SaitoHUD.Overlays", Draw)
    else
        pcall(hook.Remove, "HUDPaint", "SaitoHUD.Overlays")
    end
end

--- Registers an overlay.
-- @param id
-- @param drawEntFunc Function to draw each entity
-- @param hudPaint HUD paint function
function SaitoHUD.RegisterOverlay(id, t)
    local data = {
        Enabled = false,
        DrawEnt = t.DrawEnt,
        HUDPaint = t.HUDPaint,
        OnPostEvaluate = t.OnPostEvaluate,
        Matches = {},
        Filter = nil,
        LastFilter = nil,
    }
    
    SaitoHUD.OverlayTypes[id] = data
    
    concommand.Add(id .. "_filter", function(ply, cmd, args)
        if SaitoHUD.AntiUnfairTriggered() then return end
        
        data.Matches = {}
        data.Filter = SaitoHUD.entityFilter.Build(args, true)
        Rehook()
    end)
    
    concommand.Add("toggle_" .. id, function(ply, cmd, args)
        if SaitoHUD.AntiUnfairTriggered() then return end
        
        data.Matches = {}
        
        if data.Filter then
            data.LastFilter = data.Filter
            data.Filter = nil
        else
            if data.LastFilter then
                data.Filter = data.LastFilter
            else
                data.Filter = SaitoHUD.entityFilter.Build({"*"}, true)
            end
        end
    
        Rehook()
    end)
end