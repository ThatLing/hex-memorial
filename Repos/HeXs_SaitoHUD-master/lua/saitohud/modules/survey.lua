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


surface.CreateFont("DefaultSmallDropShadow", {
	font		= "Tahoma",
	size 		= 11,
	weight		= 0,
	antialias	= true,
	additive	= false,
	shadow		= true,
	}
)


local orthoTraceText = CreateClientConVar("ortho_trace_text", "1", true, false)
local reflectTraceNodes = CreateClientConVar("reflect_trace_nodes", "1", true, false)
local reflectTraceMultiple = CreateClientConVar("reflect_trace_multiple", "0", true, false)
local reflectTraceColorProgression = CreateClientConVar("reflect_trace_color_progression", "0", true, false)

local orthogonalTraces = {}
local reflectionLines = {}

local Rehook = nil

--- Console commands to do an ortho trace.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function OrthoTrace(ply, cmd, args)
    local start = SaitoHUD.GetRefTrace()
    
    local data = {}
    data.start = start.HitPos
    data.endpos = start.HitNormal * 100000 + start.HitPos
    data.filter = LocalPlayer()
    local final = util.TraceLine(data)
    
    table.insert(orthogonalTraces, {start.HitPos, final.HitPos})
    
    Rehook()
end

--- Console commands clear the list of ortho traces.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function OrthoTraceClear(ply, cmd, args)
    orthogonalTraces = {}
    
    Rehook()
end

local function CalculateReflectionAnalysis(startPos, endPos, numReflects, ent)
    local lines = {}
    
    local filter = ent and {ent, LocalPlayer()} or LocalPlayer()
    local vec = endPos - startPos
	local data = {}
	data.start = startPos
	data.endpos = endPos
	data.filter = filter
	local tr = util.TraceLine(data)

    table.insert(lines, {tr.StartPos, tr.HitPos})
    
    for i = 1, numReflects do
        local v = vec - 2 * vec:DotProduct(tr.HitNormal) * tr.HitNormal
        local lastPoint = tr.HitPos
        tr = util.QuickTrace(tr.HitPos + v:GetNormal() * -0.01, v:GetNormal() * 100000, filter)
        vec = tr.HitPos - tr.StartPos
        table.insert(lines, {lastPoint, tr.HitPos})
    end
    
    return lines
end

--- Console commands to do reflection analysis.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ReflectAnalysis(ply, cmd, args)
    local numReflects = tonumber(args[1])
    
    if #args ~= 1 then
        Msg("Invalid number of arguments\n")
        return
    elseif numReflects < 1 then
        Msg("Minimum number of reflections: 1\n")
        return
    end
    
    if not reflectTraceMultiple:GetBool() then reflectionLines = {} end
    
    local tr = SaitoHUD.GetRefTrace()
    
    table.insert(reflectionLines, {
        Lines = CalculateReflectionAnalysis(tr.StartPos, tr.HitPos, numReflects)
    })
    
    Rehook()
end

--- Console commands to do reflection analysis from an entity.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ReflectAnalysisEntity(ply, cmd, args)
    local numReflects = tonumber(args[1])
    local ang = SaitoHUD.ParseConcmdAngle(args, 1)
    
    if #args < 2 or #args > 4 then
        Msg("Invalid number of arguments\n")
        return
    elseif numReflects < 1 then
        Msg("Minimum number of reflections: 1\n")
        return
    end
    
    local tr = SaitoHUD.GetRefTrace()
    
    if IsValid(tr.Entity) then
        if not reflectTraceMultiple:GetBool() then reflectionLines = {} end
        
        worldAng = tr.Entity:LocalToWorldAngles(ang)
        
        table.insert(reflectionLines, {
            Lines = CalculateReflectionAnalysis(tr.Entity:GetPos(),
                                                ang:Forward() * 100000 + tr.Entity:GetPos(),
                                                numReflects, tr.Entity),
            Entity = tr.Entity,
            Live = cmd == "reflect_trace_ent_live",
            Ang = ang,
            NumReflects = numReflects
        })
    else
        LocalPlayer():ChatPrint("Nothing was found in an eye trace!")
    end
    
    Rehook()
end

--- Console commands clear the list of reflection traces.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ReflectAnalysisClear(ply, cmd, args)
    reflectionLines = {}
    
    Rehook()
end

--- Draw RenderScreenspaceEffects.
local function DoDrawSurveyScreenspace()
    surface.SetDrawColor(255, 255, 0, 255)
    for _, v in pairs(orthogonalTraces) do
        SaitoHUD.Draw3D2DLine(v[1], v[2])
    end
    
    surface.SetDrawColor(255, 255, 0, 255)
    for _, data in pairs(reflectionLines) do
        local lines = data.Lines
        for k, v in pairs(lines) do
            if reflectTraceColorProgression:GetBool() then
                surface.SetDrawColor(255 * k / #lines, 255 * (1 - k / #lines),
                                     255 * (1 - k / #lines), 255)
            end
            SaitoHUD.Draw3D2DLine(v[1], v[2])
        end
    end
end

--- Draw orthogonal trace text.
local function DrawOrthoTraceText()
    for _, v in pairs(orthogonalTraces) do
		local dist = math.Round(v[1]:Distance(v[2]))
        local screenPos = v[1]:ToScreen()
        draw.SimpleText(tostring(v[1]),
                        "DefaultSmallDropShadow", screenPos.x, screenPos.y,
                        color_white, 1, ALIGN_TOP)
                        
        draw.SimpleText(tostring(dist),
                        "DefaultSmallDropShadow", screenPos.x, screenPos.y+10,
                        color_white, 1, ALIGN_TOP)
        
        local screenPos = v[2]:ToScreen()
        draw.SimpleText(tostring(v[2]),
                        "DefaultSmallDropShadow", screenPos.x, screenPos.y,
                        color_white, 1, ALIGN_TOP)
                        
        draw.SimpleText(tostring(dist),
                        "DefaultSmallDropShadow", screenPos.x, screenPos.y+10,
                        color_white, 1, ALIGN_TOP)
    end
end

--- Draw reflection analysis text.
local function DrawReflectAnalysisText()
    local dim = 5
    
    surface.SetDrawColor(255, 255, 0, 255)
    
    for _, data in pairs(reflectionLines) do
        if data.Live and IsValid(data.Entity) then
            worldAng = data.Entity:LocalToWorldAngles(data.Ang)
            
            data.Lines = CalculateReflectionAnalysis(
                data.Entity:GetPos(), worldAng:Forward() * 100000 + data.Entity:GetPos(),
                data.NumReflects, data.Entity)
        end
        
        local lines = data.Lines
        
        for k, v in pairs(lines) do
            if reflectTraceColorProgression:GetBool() then
                surface.SetDrawColor(255 * k / #lines, 255 * (1 - k / #lines),
                                     255 * (1 - k / #lines), 255)
            end
            
            local screenPos = v[1]:ToScreen()
            surface.DrawOutlinedRect(screenPos.x - dim / 2, screenPos.y - dim / 2, dim, dim)
            
            if k == #lines then
                local screenPos = v[2]:ToScreen()
                surface.DrawOutlinedRect(screenPos.x - dim / 2, screenPos.y - dim / 2, dim, dim)
            end
        end
    end
end

--- Hook to draw survey stuff in RenderScreenspaceEffects.
local function DrawSurveyScreenspace()
    cam.Start3D(EyePos(), EyeAngles())
    -- Wrap the call in pcall() because an error here causes mayhem, so it
    -- is best if any errors are caught
    err, x = pcall(DoDrawSurveyScreenspace)
    cam.End3D()
end

--- Draw survey HUDPaint stuff.
local function DrawSurvey()
    if orthoTraceText:GetBool() then
        DrawOrthoTraceText()
    end
    
    if reflectTraceNodes:GetBool() then
        DrawReflectAnalysisText()
    end
end

Rehook = function()
    if #orthogonalTraces > 0 or #reflectionLines > 0 then
        hook.Add("RenderScreenspaceEffects", "SaitoHUD.Survey", DrawSurveyScreenspace)
        hook.Add("HUDPaint", "SaitoHUD.Survey", DrawSurvey)
    else
        pcall(hook.Remove, "RenderScreenspaceEffects", "SaitoHUD.Survey")
        pcall(hook.Remove, "HUDPaint", "SaitoHUD.Survey")
    end
end

Rehook()

concommand.Add("ortho_trace", OrthoTrace)
concommand.Add("ortho_trace_clear", OrthoTraceClear)
concommand.Add("reflect_trace", ReflectAnalysis)
concommand.Add("reflect_trace_ent", ReflectAnalysisEntity)
concommand.Add("reflect_trace_ent_live", ReflectAnalysisEntity)
concommand.Add("reflect_trace_clear", ReflectAnalysisClear)