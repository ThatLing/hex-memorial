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

local sampleDraw = CreateClientConVar("sample_draw", "1", false, false)
local sampleResolution = CreateClientConVar("sample_resolution", "100", true, false)
local sampleRandomColor = CreateClientConVar("sample_random_color", "0", true, false)
local sampleFade = CreateClientConVar("sample_fade", "0", true, false)
local sampleSize = CreateClientConVar("sample_size", "100", true, false)
local sampleThick = CreateClientConVar("sample_thick", "0", true, false)
local sampleNodes = CreateClientConVar("sample_nodes", "1", true, false)
local sampleMultiple = CreateClientConVar("sample_multiple", "0", true, false)

SaitoHUD.Samplers = {}

local lastSample = 0

local SamplingContext = {}

--- Creates a new sampling context.
-- @param ent Entity
-- @param color Color object to draw the lines and nodes with
-- @param randomColor Boolean indicating whether a random color should be used; color
--                    should be nil
function SamplingContext:new(ent, color, randomColor)
    if color == nil then
        if randomColor then
            color = HSVToColor(math.random(0, 255), 1, 1)
        else
            color = Color(0, 255, 255, 255)
        end
    end
    
    local instance = {
        ["ent"] = ent,
        ["points"] = {},
        ["color"] = color,
    }
    
    setmetatable(instance, self)
    self.__index = self
    return instance
end

--- Does logging for this sampling context. A size parameter can be given to
-- specify the number of data points to keep. If the parameter is not specified, then
-- the number configured via the relevant cvar will be used.
-- @param size
function SamplingContext:Log(size)
    if not self.ent or not IsValid(self.ent) then
        self.Log = function() end
        self.Draw = function() end
        return false
    end
    
    if size == nil then
        size = sampleSize:GetFloat()
    end
    
    table.insert(self.points, self.ent:GetPos())
    while #self.points > size do
        table.remove(self.points, 1)
    end
    
    return true
end

--- Draws the sample.
-- @param drawNodes Boolean indicating whether the nodes should be drawn
function SamplingContext:Draw(drawNodes)
    if not self.ent or not IsValid(self.ent) then
        self.Log = function() end
        self.Draw = function() end
        return false
    end
    
    local dim = 5
    local currentPos = self.ent:GetPos()
    local lastPt = nil
    
    surface.SetDrawColor(self.color.r, self.color.g, self.color.b, 255)
    
    for k, pt in pairs(self.points) do
        if lastPt != nil and lastPt != pt then 
            local from = lastPt:ToScreen()
            local to = pt:ToScreen()
            
            if from.visible and to.visible then
                if sampleFade:GetBool() then
                    surface.SetDrawColor(self.color.r, self.color.g, self.color.b,
                                         (k / #self.points) * 255)
                end
                
                surface.DrawLine(from.x, from.y, to.x, to.y)
                
                if sampleThick:GetBool() then
                    surface.DrawLine(from.x + 1, from.y, to.x + 1, to.y)
                    surface.DrawLine(from.x + 1, from.y + 1, to.x + 1, to.y + 1)
                    surface.DrawLine(from.x, from.y + 1, to.x, to.y + 1)
                end
                
                if sampleNodes:GetBool() then
                    surface.DrawOutlinedRect(to.x - dim / 2, to.y - dim / 2, dim, dim)
                end
            end
        end
        
        lastPt = pt
    end
    
    if lastPt != nil and lastPt != currentPos then 
        local from = lastPt:ToScreen()
        local to = currentPos:ToScreen()
        if from.visible and to.visible then
            surface.DrawLine(from.x, from.y, to.x, to.y)
            
            if sampleThick:GetBool() then
                surface.DrawLine(from.x + 1, from.y, to.x + 1, to.y)
                surface.DrawLine(from.x + 1, from.y + 1, to.x + 1, to.y + 1)
                surface.DrawLine(from.x, from.y + 1, to.x, to.y + 1)
            end
        end
    end
    
    return true
end

--- Adds and removes hooks as required.
local function Rehook()
    if #SaitoHUD.Samplers > 0 then
        hook.Add("Think", "SaitoHUD.Sampling", LogSamples)
        
        if sampleDraw:GetBool() then
            hook.Add("HUDPaint", "SaitoHUD.Sampling", DrawSamples)
        else
            SaitoHUD.RemoveHook("HUDPaint", "SaitoHUD.Sampling")
        end
    else
        SaitoHUD.RemoveHook("Think", "SaitoHUD.Sampling")
        SaitoHUD.RemoveHook("HUDPaint", "SaitoHUD.Sampling")
    end
end

--- Remove an entity from being sampled.
-- @param ent Entity
function SaitoHUD.RemoveSample(ent)
    for k, ctx in pairs(SaitoHUD.Samplers) do
        if ctx.ent == ent then
            table.remove(SaitoHUD.Samplers, k)
        end
    end
    
    Rehook()
end

--- Add a sampler to the list for an entity.
-- @param ent Entity
function SaitoHUD.AddSample(ent)
    for k, ctx in pairs(SaitoHUD.Samplers) do
        if ctx.ent == ent then
            return
        end
    end
    
    local ctx = SamplingContext:new(ent, nil, sampleRandomColor:GetBool())
    table.insert(SaitoHUD.Samplers, ctx)
    
    Rehook()
end

--- Sets the current sample list to sample only the given entity.
-- @param ent Entity
function SaitoHUD.SetSample(ent)
    local ctx = SamplingContext:new(ent, nil, sampleRandomColor:GetBool())
    SaitoHUD.Samplers = {ctx}
    
    Rehook()
end

--- Check to see whether a sampler exists for an entity.
-- @param ent Entity
-- @return Whether it exists
function SaitoHUD.HasSample(ent)
    for k, ctx in pairs(SaitoHUD.Samplers) do
        if ctx.ent == ent then
            return true
        end
    end
    return false
end

--- Collects data points, and removes any deleted entities from the sample list.
function SaitoHUD.LogSamples()
    for k, ctx in pairs(SaitoHUD.Samplers) do
        if not ctx:Log() then
            table.remove(SaitoHUD.Samplers, k)
        end
    end
end

--- Draws the sample on the screen, and removes any entities being sampled if the
-- entities are no longer valid.
function SaitoHUD.DrawSamples()
    for k, ctx in pairs(SaitoHUD.Samplers) do
        if not ctx:Draw() then
            table.remove(SaitoHUD.Samplers, k)
        end
    end
end

--- Console command to sample.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function Sample(ply, cmd, args)
    if not sampleMultiple:GetBool() then
        if table.Count(SaitoHUD.Samplers) > 0 then
            LocalPlayer():ChatPrint("Note: Multiple entity sampling is disabled")
        end
        SaitoHUD.Samplers = {}
    end
    
    if table.Count(args) == 0 then
        local tr = SaitoHUD.GetRefTrace()
        
        if IsValid(tr.Entity) then
            if SaitoHUD.HasSample(tr.Entity) then
                SaitoHUD.RemoveSample(tr.Entity)
                LocalPlayer():ChatPrint("No longer sampling entity #" ..  tr.Entity:EntIndex() .. ".")
            else
                SaitoHUD.AddSample(tr.Entity)
                LocalPlayer():ChatPrint("Sampling entity #" ..  tr.Entity:EntIndex() .. ".")
            end
        else
            LocalPlayer():ChatPrint("Nothing was found in an eye trace!")
        end
    elseif table.Count(args) == 1 then
        local m = SaitoHUD.MatchPlayerString(args[1])
        if m then
            SaitoHUD.AddSample(m)
            LocalPlayer():ChatPrint("Sampling player named " .. m:GetName() .. ".")
        else
            LocalPlayer():ChatPrint("No player was found by that name.")
        end
    else
        Msg("Invalid number of arguments\n")
    end
end

--- Console command to sample by entity filter.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function SampleFilter(ply, cmd, args)
    if not sampleMultiple:GetBool() then
        LocalPlayer():ChatPrint("Note: Multiple entity sampling is disabled")
        return
    end
    
    local filter = SaitoHUD.entityFilter.Build(args, true)
    local refPos = SaitoHUD.GetRefPos()
    local count = 0
    
    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) then
            if filter.f(ent, refPos) then
                SaitoHUD.AddSample(ent)
                count = count + 1
            end
        end
    end
    
    Msg(tostring(count) .. " entities were matched\n")
end

--- Console commands to sample by ID.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function SampleID(ply, cmd, args)
    if not sampleMultiple:GetBool() then
        if table.Count(SaitoHUD.Samplers) > 0 then
            LocalPlayer():ChatPrint("Note: Multiple entity sampling is disabled")
        end
        SaitoHUD.Samplers = {}
    end
    
    if table.Count(args) == 1 then
        local idx = tonumber(args[1])
        local m = ents.GetByIndex(idx)
        if IsValid(m) then
            SaitoHUD.AddSample(m)
            LocalPlayer():ChatPrint("Sampling entity of class " .. m:GetClass() .. ".")
        else
            LocalPlayer():ChatPrint("No entity was found by that index.")
        end
    else
        Msg("Invalid number of arguments\n")
    end
end

--- Console command to remove a sample.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function RemoveSample(ply, cmd, args)
    if table.Count(args) == 0 then
        local tr = SaitoHUD.GetRefTrace()
        
        if IsValid(tr.Entity) then
            SaitoHUD.RemoveSample(tr.Entity)
            LocalPlayer():ChatPrint("No longer sampling entity #" ..  tr.Entity:EntIndex() .. ".")
        else
            LocalPlayer():ChatPrint("Nothing was found in an eye trace!")
        end
    elseif table.Count(args) == 1 then
        local m = SaitoHUD.MatchPlayerString(args[1])
        if m then
            SaitoHUD.RemoveSample(m)
            LocalPlayer():ChatPrint("No longer sampling player named " .. m:GetName() .. ".")
        else
            LocalPlayer():ChatPrint("No player was found by that name.")
        end
    else
        Msg("Invalid number of arguments\n")
    end
end

--- Console command to remove a sample by its ID.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function RemoveSampleID(ply, cmd, args)
    if table.Count(args) == 1 then
        local idx = tonumber(args[1])
        local m = ents.GetByIndex(idx)
        if IsValid(m) then
            SaitoHUD.RemoveSample(m)
            LocalPlayer():ChatPrint("No longer sampling entity of class " .. m:GetClass() .. ".")
        else
            LocalPlayer():ChatPrint("No entity was found by that index.")
        end
    else
        Msg("Invalid number of arguments\n")
    end
end

--- Console command to remove samples entity filter.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function RemoveSampleFilter(ply, cmd, args)
    local filter = SaitoHUD.entityFilter.Build(args, true)
    local refPos = SaitoHUD.GetRefPos()
    local count = 0
    
    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) then
            if filter.f(ent, refPos) then
                if SaitoHUD.HasSample(ent) then
                    SaitoHUD.RemoveSample(ent)
                    count = count + 1
                end
            end
        end
    end
    
    Msg(tostring(count) .. " samplers were removed\n")
end

--- Console command to clear samples.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function ClearSamples(ply, cmd, args)
    if table.Count(SaitoHUD.Samplers) == 0 then
        LocalPlayer():ChatPrint("No samplers are active.")
    else
        LocalPlayer():ChatPrint(table.Count(SaitoHUD.Samplers) .. " sampler(s) removed.")
        SaitoHUD.Samplers = {}
    end
end

--- Console command to list the objects being sampled.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
function ListSamples(ply, cmd, args)
    if #SaitoHUD.Samplers > 0 then
        for k, ctx in pairs(SaitoHUD.Samplers) do
            if IsValid(ctx.ent) then
                print(string.format("#%d %s (%s)", ctx.ent:EntIndex(), ctx.ent:GetClass(), 
                                    ctx.ent:GetModel()))
            end
        end
    else
        print("Nothing is being sampled.")
    end
end

--- Hook to log and draw samples.
function LogSamples()
    if CurTime() - lastSample > sampleResolution:GetFloat() / 1000 then
        SaitoHUD.LogSamples()
        lastSample = CurTime()
    end
end

--- Hook to log and draw samples.
function DrawSamples()
    if sampleDraw:GetBool() and not SaitoHUD.AntiUnfairTriggered() then
        SaitoHUD.DrawSamples(true)
    end
end

concommand.Add("sample", Sample, SaitoHUD.ConsoleAutocompletePlayer)
concommand.Add("sample_filter", SampleFilter)
concommand.Add("sample_id", SampleID)
concommand.Add("sample_remove", RemoveSample, SaitoHUD.ConsoleAutocompletePlayer)
concommand.Add("sample_remove_id", RemoveSampleID)
concommand.Add("sample_remove_filter", RemoveSampleFilter)
concommand.Add("sample_clear", ClearSamples) 
concommand.Add("sample_list", ListSamples)

-- Need to rehook if sample_draw changes
cvars.AddChangeCallback("sample_draw", function(cv, old, new) Rehook() end)