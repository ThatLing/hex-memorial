-- SaitoHUD
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
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


surface.CreateFont("DefaultBold", {
	font		= "Tahoma",
	size 		= 13,
	weight		= 1000,
	antialias	= true,
	additive	= false,
	}
)



local autoLive = CreateClientConVar("geom_auto_live", "0", true, false)

local GEOM = SaitoHUD.GEOM

------------------------------------------------------------
-- Drawing
------------------------------------------------------------

local function DrawCross(pt)
    local scr = pt:ToScreen()
    
    surface.DrawLine(scr.x - 7, scr.y, scr.x + 7, scr.y)
    surface.DrawLine(scr.x, scr.y - 7, scr.x, scr.y + 7)
end

local function DetermineScale(pt)
    return math.Clamp(4.6988 * math.exp(0.0006 * SaitoHUD.GetRefPos():Distance(pt)), 5, 40)
end

local function Draw3DCross(pt, dir)
    local scale = DetermineScale(pt)
    local ang = dir:Angle()
    local topScr = (pt + ang:Up() * scale):ToScreen()
    local bottomScr = (pt - ang:Up() * scale):ToScreen()
    local rightScr = (pt + ang:Right() * scale):ToScreen()
    local leftScr = (pt- ang:Right() * scale):ToScreen()
    surface.DrawLine(topScr.x, topScr.y, bottomScr.x, bottomScr.y)
    surface.DrawLine(leftScr.x, leftScr.y, rightScr.x, rightScr.y)
end

local function Draw3DArrow(pt, dir)
    local scale = DetermineScale(pt)
    local ang = dir:Angle()
    local centerScr = pt:ToScreen()
    local topScr = (pt + ang:Up() * scale - ang:Forward() * scale):ToScreen()
    local bottomScr = (pt - ang:Up() * scale - ang:Forward() * scale):ToScreen()
    local rightScr = (pt + ang:Right() * scale - ang:Forward() * scale):ToScreen()
    local leftScr = (pt- ang:Right() * scale - ang:Forward() * scale):ToScreen()
    surface.DrawLine(centerScr.x, centerScr.y, topScr.x, topScr.y)
    surface.DrawLine(centerScr.x, centerScr.y, bottomScr.x, bottomScr.y)
    surface.DrawLine(centerScr.x, centerScr.y, leftScr.x, leftScr.y)
    surface.DrawLine(centerScr.x, centerScr.y, rightScr.x, rightScr.y)
end

local function Draw3DEndMarker(pt, dir)
    local scale = DetermineScale(pt)
    local ang = dir:Angle()
    local left = (pt - ang:Right() * scale):ToScreen()
    local right = (pt + ang:Right() * scale):ToScreen()
    surface.DrawLine(left.x, left.y, right.x, right.y)
end

--- Draw GEOM objects.
local function HUDPaint()
    for key, pt in pairs(GEOM.Points) do
        local scr = pt:ToScreen()
        
        surface.SetDrawColor(0, 255, 255, 255)
        surface.SetTextColor(0, 255, 255, 255)
            
        if scr.visible then
            DrawCross(pt)
        end
            
        surface.SetFont("DefaultBold")
        local w, h = surface.GetTextSize(key)
        surface.SetTextPos(scr.x - w - 4, scr.y + 1) 
        surface.DrawText(key)
    end
    
    for key, line in pairs(GEOM.Lines) do
        local scr1 = line.pt1:ToScreen()
        local scr2 = line.pt2:ToScreen()
        
        surface.SetDrawColor(255, 0, 0, 255)
        
        if scr1.visible then Draw3DCross(line.pt1, line.pt2 - line.pt1) end
        if scr2.visible then Draw3DEndMarker(line.pt2, line.pt2 - line.pt1) end
        if scr1.visible and scr2.visible then
            surface.DrawLine(scr1.x, scr1.y, scr2.x, scr2.y)
        end
        
        surface.SetFont("DefaultBold")
        surface.SetTextColor(255, 0, 0, 255)
        surface.SetTextPos(scr1.x + 4, scr1.y + 1) 
        surface.DrawText(key)
    end
end

hook.Add("HUDPaint", "SaitoHUD.GEOMView", HUDPaint)

------------------------------------------------------------
-- Commands
------------------------------------------------------------

--- Create a point.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function AddPoint(ply, cmd, args)    
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "name", NumArgs = 1, },
        { Name = "vec", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, ImplicitTrace = true },
        { Name = "ent", Type = SaitoHUD.VAR_CONCMD_ENTITY, ImplicitTrace = true,
            Optional = true },
    })
    if not r then return end
    
    if cmd == "geom_point_live" or (r.ent and autoLive:GetBool()) then
        GEOM.SetPoint(r.name, GEOM.EntityRelVector(r.vec.x, r.vec.y, r.vec.z, r.ent))
    else
        GEOM.SetPoint(r.name, r.vec)
    end
    
    print(string.format("Point #%s: %s -> %s", r.name, tostring(r.vec)))
end

--- Create an entity-relative point
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function AddEntPoint(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "name", NumArgs = 1, },
        { Name = "ent", Type = SaitoHUD.VAR_CONCMD_ENTITY, ImplicitTrace = true },
    })
    if not r then return end
    
    local pos
    
    if cmd:find("geom_point_center") then
        pos = r.ent:GetPos()
    elseif cmd:find("geom_point_bbox") then
        pos = r.ent:LocalToWorld(r.ent:OBBCenter())
    elseif cmd:find("geom_point_mass") then
    
    end
    
    if cmd:find("live") or autoLive:GetBool() then
        GEOM.SetPoint(r.name, GEOM.EntityRelVector(pos.x, pos.y, pos.z, r.ent))
    else
        GEOM.SetPoint(r.name, pos)
    end
    
    print(string.format("Point #%s: %s -> %s", r.name, tostring(pos)))
end

--- Create a line.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function AddLine(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "name", NumArgs = 1, },
        { Name = "pt1", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, },
         { Name = "pt2", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, },
    })
    if not r then return end
    
    GEOM.SetLine(r.name, GEOM.Line(r.pt1, r.pt2))
    print(string.format("Line #%s: %s -> %s", r.name, tostring(r.pt1), tostring(r.pt2)))
end

--- Project a point onto a segment.
-- @param ply Player
-- @param cmd Command
-- @param args Arguments
local function ProjectPointSegment(ply, cmd, args)
    local r = SaitoHUD.ParseVarConcmd(args, {
        { Name = "name", NumArgs = 1, },
        { Name = "pt", Type = SaitoHUD.VAR_CONCMD_GEOM_POINT, },
        { Name = "segment", Type = SaitoHUD.VAR_CONCMD_GEOM_LINE, },
    })
    if not r then return end
    
    GEOM.SetPoint(r.name, GEOM.PointLineSegmentProjection(r.pt, r.segment))
    print(string.format("Point-line segment projection #%s: %s -> %s", r.name,
                        tostring(r.pt), tostring(r.segment)))
end

concommand.Add("geom_point", AddPoint)
concommand.Add("geom_point_live", AddPoint)
concommand.Add("geom_point_center", AddEntPoint)
concommand.Add("geom_point_center_live", AddEntPoint)
concommand.Add("geom_point_bbox", AddEntPoint)
concommand.Add("geom_point_bbox_live", AddEntPoint)
concommand.Add("geom_point_mass", AddEntPoint)
concommand.Add("geom_point_mass_live", AddEntPoint)
concommand.Add("geom_line", AddLine)
concommand.Add("geom_project_point_segment", ProjectPointSegment)