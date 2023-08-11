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

SaitoHUD.MeasurePoints = {}
SaitoHUD.MeasureLength = 0

local Rehook = nil
local containsLive = false

--- Recalculate the measured total.
local function RecalcMeasuredTotal()
    SaitoHUD.MeasureLength = 0
    containsLive = false
    
    if #SaitoHUD.MeasurePoints > 1 then
        local last = SaitoHUD.MeasurePoints[1]
        if type(last) == 'table' then containsLive = true end
        
        for i = 2, #SaitoHUD.MeasurePoints do
            local pt = SaitoHUD.MeasurePoints[i]
            SaitoHUD.MeasureLength = SaitoHUD.MeasureLength + pt:Distance(last)
            last = pt
            if type(last) == 'table' then containsLive = true end
        end
    end
end

--- Console command to add a point to the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function AddMeasuredPoint(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "vec", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, ImplicitTrace = true },
    })
    if not r then return end
    
    local vec = r.vec
    local last = SaitoHUD.MeasurePoints[#SaitoHUD.MeasurePoints]
    
    table.insert(SaitoHUD.MeasurePoints, vec)
    RecalcMeasuredTotal()
    
    if #SaitoHUD.MeasurePoints > 1 then
        print("Added point #" .. #SaitoHUD.MeasurePoints)
        print(string.format("Incremental distance: %f",
                            last:Distance(vec)))
        print(string.format("Total distance: %f", SaitoHUD.MeasureLength))
    end
    
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to close the path of the measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function CloseMeasurementLoop(ply, cmd, args)
    local vec = nil
    
    if #SaitoHUD.MeasurePoints < 2 then
        LocalPlayer():ChatPrint("Not enough points.")
    end
    
    local vec = SaitoHUD.MeasurePoints[1]
    
    local last = SaitoHUD.MeasurePoints[#SaitoHUD.MeasurePoints]
    
    table.insert(SaitoHUD.MeasurePoints, vec)
    RecalcMeasuredTotal()
    
    if #SaitoHUD.MeasurePoints > 1 then
        print("Added point #" .. #SaitoHUD.MeasurePoints)
        print(string.format("Incremental distance: %f",
                            last:Distance(vec)))
        print(string.format("Total distance: %f", SaitoHUD.MeasureLength))
    end
    
    
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to add an orthogonal line to the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function AddOrthoMeasuredPoint(ply, cmd, args)
    if #args ~= 0 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    local start = SaitoHUD.GetRefTrace()
    
    local data = {}
    data.start = start.HitPos
    data.endpos = start.HitNormal * 100000 + start.HitPos
    data.filter = LocalPlayer()
    local final = util.TraceLine(data)
    
    table.insert(SaitoHUD.MeasurePoints, start.HitPos)
    table.insert(SaitoHUD.MeasurePoints, final.HitPos)
    
    RecalcMeasuredTotal()
    
    print("Added points #" .. (#SaitoHUD.MeasurePoints - 1) ..
          " #" .. #SaitoHUD.MeasurePoints)
    print(string.format("Total distance: %f", SaitoHUD.MeasureLength))
    
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to insert a point in the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function InsertMeasuredPoint(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "index" },
        { Name = "vec", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, ImplicitTrace = true },
    })
    if not r then return end
    
    local index = math.floor(r.index)
    
    if index < 1 or index > #SaitoHUD.MeasurePoints + 1 then
        Msg("Invalid index\n")
        return
    end
    
    table.insert(SaitoHUD.MeasurePoints, index, r.vec)
    print("Inserted point at #" .. index)
    
    RecalcMeasuredTotal()
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to insert an orthogonal line in the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function InsertOrthoMeasuredPoint(ply, cmd, args)
    if #args ~= 1 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    local index = tonumber(args[1])
    
    if not index then
        Msg("Invalid index\n")
    end
    
    index = math.floor(index)
    
    if index < 1 or index > #SaitoHUD.MeasurePoints + 1 then
        Msg("Invalid index\n")
        return
    end
    
    local start = SaitoHUD.GetRefTrace()
    
    local data = {}
    data.start = start.HitPos
    data.endpos = start.HitNormal * 100000 + start.HitPos
    data.filter = LocalPlayer()
    local final = util.TraceLine(data)
    
    table.insert(SaitoHUD.MeasurePoints, index, start.HitPos)
    table.insert(SaitoHUD.MeasurePoints, index + 1, final.HitPos)
    
    print("Inserted 2 points at #" .. index)
    
    RecalcMeasuredTotal()
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to replace a point in the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ReplaceMeasuredPoint(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "index" },
        { Name = "vec", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, ImplicitTrace = true },
    })
    if not r then return end
    
    local index = math.floor(tonumber(r.index))
    
    if not SaitoHUD.MeasurePoints[index] then
        Msg("No such index\n")
        return
    end
    
    SaitoHUD.MeasurePoints[index] = r.vec
    print("Replaced point #" .. index)
    
    RecalcMeasuredTotal()
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to remove a point in the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function RemoveMeasuredPoint(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "index" },
        { Name = "vec", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, ImplicitTrace = true },
    })
    if not r then return end
    
    local index = math.floor(tonumber(r.index))
    
    if not SaitoHUD.MeasurePoints[index] then
        Msg("No such index\n")
        return
    end
    
    table.remove(SaitoHUD.MeasurePoints, index)
    print("Removed point #" .. index)
    
    RecalcMeasuredTotal()
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Console command to remove the last point in the path measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function RemoveLastMeasuredPoint(ply, cmd, args)
    RemoveMeasuredPoint(ply, cmd, {#SaitoHUD.MeasurePoints})
end

--- Console command to list points added in the measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ListMeasuredPoints(ply, cmd, args)
    if #args ~= 0 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    if #SaitoHUD.MeasurePoints > 0 then
        for k, pt in pairs(SaitoHUD.MeasurePoints) do
            if k == 1 then
                print(string.format("#%d (%s)",k, tostring(pt)))
            else
                print(string.format("#%d (%s) incr. dist.: %f",
                                    k, tostring(pt), pt:Distance(SaitoHUD.MeasurePoints[k - 1])))
            end
        end
        
        print(string.format("Total distance: %f", SaitoHUD.MeasureLength))
    else
        print("No points!")
    end
end

--- Console command to sum point distances in the measurement tool.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function SumMeasuredPoints(ply, cmd, args)
    if #args ~= 2 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    local index1 = tonumber(args[1])
    local index2 = tonumber(args[2])
    
    if not index1 or not index2 or index1 >= index2 then
        Msg("Invalid arguments\n")
        return
    end
    
    index1 = math.floor(index1)
    index2 = math.floor(index2)
    
    if index1 < 1 or index2 > #SaitoHUD.MeasurePoints then
        Msg("Indexes out of range\n")
        return
    end
    
    local last = SaitoHUD.MeasurePoints[index1]
    local total = 0
    
    for i = index1 + 1, index2 do
        local pt = SaitoHUD.MeasurePoints[i]
        total = total + pt:Distance(last)
        last = pt
    end
    
    print(string.format("Total distance from #%d -> #%d: %f", index1, index2, total))
end

--- Console command to get the distance between two points
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function BetweenMeasuredPoints(ply, cmd, args)
    if #args ~= 2 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    local index1 = tonumber(args[1])
    local index2 = tonumber(args[2])
    
    if not index1 or not index2 or index1 >= index2 then
        Msg("Invalid arguments\n")
        return
    end
    
    index1 = math.floor(index1)
    index2 = math.floor(index2)
    
    if index1 == index2 then
        Msg("Both indexes are the same\n")
        return
    end
    
    local distance = SaitoHUD.MeasurePoints[index1]:Distance(SaitoHUD.MeasurePoints[index2])
    
    print(string.format("Direct distance between #%d and #%d: %f", index1, index2, distance))
end

--- Console commands to clear the list of points.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ClearMeasuredPoints(ply, cmd, args)
    if #args ~= 0 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    SaitoHUD.MeasurePoints = {}
    
    print("Cleared")
    
    SaitoHUD.UpdateMeasuringPanel()
    Rehook()
end

--- Draw measured path.
local function DrawMeasuringLines()
    local dim = 5
    surface.SetDrawColor(255, 0, 255, 255)
    
    if #SaitoHUD.MeasurePoints > 1 then
        local last = SaitoHUD.MeasurePoints[1]
        local lastScreen = last:ToScreen()
        
        if lastScreen.visible then
            draw.SimpleText(tostring(1),
                            "DefaultSmallDropShadow", lastScreen.x, lastScreen.y,
                            color_white, 1, ALIGN_TOP)
        end
        
        for i = 2, #SaitoHUD.MeasurePoints do
            local pt = SaitoHUD.MeasurePoints[i]
            local midPt = (pt - last) / 2 + last
            local ptScreen = pt:ToScreen()
            local midPtScreen = midPt:ToScreen()
            
            if ptScreen.visible and lastScreen.visible then
                surface.DrawLine(lastScreen.x, lastScreen.y, ptScreen.x, ptScreen.y)
            end
            
            if midPtScreen.visible then
                draw.SimpleText(string.format("%0.2f", last:Distance(pt)),
                                "DefaultSmallDropShadow",
                                midPtScreen.x, midPtScreen.y,
                                Color(255, 200, 255, 255), 1, ALIGN_TOP)
            end
            
            if ptScreen.visible then
                draw.SimpleText(tostring(i), "DefaultSmallDropShadow",
                                ptScreen.x - 2, ptScreen.y - 5,
                                color_white, 1, ALIGN_TOP)
            end
            
            last = pt
            lastScreen = last:ToScreen()
        end

        local yOffset = ScrH() * 0.3 - 50
        local color = Color(255, 200, 255, 255)
        draw.SimpleText("Measured Total: " .. string.format("%.7f", SaitoHUD.MeasureLength),
                        "TabLarge", ScrW() - 16, yOffset, color, 2, ALIGN_TOP)
    elseif #SaitoHUD.MeasurePoints == 1 then
        local dim = 5
        local last = SaitoHUD.MeasurePoints[1]
        local lastScreen = last:ToScreen()
        surface.DrawOutlinedRect(lastScreen.x - dim / 2,
                                 lastScreen.y - dim / 2,
                                 dim, dim)
        draw.SimpleText(tostring(1),
                        "DefaultSmallDropShadow", lastScreen.x, lastScreen.y,
                        color_white, 1, ALIGN_TOP)
    end
end

--- Draw RenderScreenspaceEffects.
local function DoDrawSurveyScreenspace()
    -- Since the lines are long, we cannot draw on the HUD because lines with
    -- end points that are off screen may not appear right
    surface.SetDrawColor(255, 0, 255, 255)
    if #SaitoHUD.MeasurePoints > 1 then
        local last = SaitoHUD.MeasurePoints[1]
        
        for i = 2, #SaitoHUD.MeasurePoints do
            local pt = SaitoHUD.MeasurePoints[i]
            
            SaitoHUD.Draw3D2DLine(last, pt)
            
            last = pt
        end
    end
end

--- Draw survey HUDPaint stuff.
local function DrawSurvey()
    if containsLive then RecalcMeasuredTotal() end
    DrawMeasuringLines()
end

Rehook = function()
    if #SaitoHUD.MeasurePoints > 0 then
        hook.Add("RenderScreenspaceEffects", "SaitoHUD.Measure", DrawSurveyScreenspace)
        hook.Add("HUDPaint", "SaitoHUD.Measure", DrawSurvey)
    else
        pcall(hook.Remove, "RenderScreenspaceEffects", "SaitoHUD.Measure")
        pcall(hook.Remove, "HUDPaint", "SaitoHUD.Measure")
    end
end

Rehook()

concommand.Add("measure_add", AddMeasuredPoint)
concommand.Add("measure_add_ortho", AddOrthoMeasuredPoint)
concommand.Add("measure_close", CloseMeasurementLoop)
concommand.Add("measure_insert", InsertMeasuredPoint)
concommand.Add("measure_insert_ortho", InsertOrthoMeasuredPoint)
concommand.Add("measure_replace", ReplaceMeasuredPoint)
concommand.Add("measure_list", ListMeasuredPoints)
concommand.Add("measure_clear", ClearMeasuredPoints)
concommand.Add("measure_sum", SumMeasuredPoints)
concommand.Add("measure_between", BetweenMeasuredPoints)
concommand.Add("measure_remove", RemoveMeasuredPoint)
concommand.Add("measure_remove_last", RemoveLastMeasuredPoint)