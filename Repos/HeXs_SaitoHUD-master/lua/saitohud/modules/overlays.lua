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

------------------------------------------------------------
-- Triads
------------------------------------------------------------

local triadsFilterGuide = CreateClientConVar("triads_filter_guide", "1", true, false)

--- Draw a triad.
-- @param p1 Point
-- @param ang Angle
local function DrawTriad(p1, ang)
    local p2 = p1 + ang:Forward() * 16
    local p3 = p1 + ang:Right() * 16
    local p4 = p1 + ang:Up() * 16
    
    p1, p2, p3, p4 = p1:ToScreen(), p2:ToScreen(), p3:ToScreen(), p4:ToScreen()
    
    surface.SetDrawColor(255, 0, 0, 255)
    surface.DrawLine(p1.x, p1.y, p2.x, p2.y) -- Forward
    surface.SetDrawColor(0, 255, 0, 255)
    surface.DrawLine(p1.x, p1.y, p3.x, p3.y) -- Right
    surface.SetDrawColor(0, 0, 255, 255)
    surface.DrawLine(p1.x, p1.y, p4.x, p4.y) -- Up
end

local OVERLAY = {}

function OVERLAY.DrawEnt(ent)
    local pos = ent:GetPos()
    DrawTriad(pos, ent:GetAngles())
end

function OVERLAY.HUDPaint(ent)
    if triadsFilterGuide:GetBool() then
        local w = ScrW()
        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawLine(w - 20, 30, w - 5, 38) -- Forward
        surface.SetDrawColor(0, 200, 0, 255)
        surface.DrawLine(w - 35, 38, w - 20, 30) -- Right
        surface.SetDrawColor(0, 0, 255, 255)
        surface.DrawLine(w - 20, 30, w - 20, 10) -- Up
    end
end

SaitoHUD.RegisterOverlay("triads", OVERLAY)

------------------------------------------------------------
-- Bounding boxes
------------------------------------------------------------

local OVERLAY = {}

function OVERLAY.DrawEnt(ent)
    local pos = ent:GetPos()
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
    
    local visible = true
    for i = 1, 8 do
        if not p[i].visible then
            visible = false
            break
        end
    end
    
    if visible then
        if ent:IsPlayer() then
            if ent:Alive() then
                surface.SetDrawColor(0, 255, 0, 255)
            else
                surface.SetDrawColor(0, 0, 255, 255)
            end
        else
            surface.SetDrawColor(255, 0, 0, 255)
        end
        
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

SaitoHUD.RegisterOverlay("bbox", OVERLAY)

------------------------------------------------------------
-- Text overlays
------------------------------------------------------------

local overlayFilterText = CreateClientConVar("overlay_filter_text", "class", true, false)
local overlayFilterPrint = CreateClientConVar("overlay_filter_print_removed", "0", true, false)

local peakSpeeds = {}
local peakEntityInfo = {}

function ClearOverlayCaches(ply, cmd, args)
    peakSpeeds = {}
    peakEntityInfo = {}
end

local OVERLAY = {}

function OVERLAY.DrawEnt(ent)
    local refPos = SaitoHUD.GetRefPos()
    local ot = overlayFilterText:GetString()
    
    local text = "<INVALID>"
    local pos = ent:GetPos()
    local screenPos = pos:ToScreen()
    
    if ot == "class" then
        text = ent:GetClass()
    elseif ot == "model" then
        text = ent:GetModel()
    elseif ot == "id" then
        text = tostring(ent:EntIndex())
    elseif ot == "material" then
        text = ent:GetMaterial()
    elseif ot == "speed" then
        local speed = ent:GetVelocity():Length()
        if speed == 0 then
            text = "Z"
        else
            text = string.format("%0.1f", speed)
        end
    elseif ot == "peakspeed" then
        local index = ent:EntIndex()
        local speed = ent:GetVelocity():Length()
        if not peakSpeeds[index] then
            peakSpeeds[index] = speed
            peakEntityInfo[index] = string.format("%s [%s]",
                                    ent:GetClass(),
                                    ent:GetModel())
        else
            if speed > peakSpeeds[index] then
                peakSpeeds[index] = speed
            end
        end
        if peakSpeeds[index] == 0 then
            text = "Z"
        else
            text = string.format("%0.1f", peakSpeeds[index])
        end
    end
    
    if text == nil then text = "" end
    
    draw.SimpleText(text, "TabLarge", screenPos.x, screenPos.y,
                    color_white, 1, ALIGN_TOP)
end

function OVERLAY.OnPostEvaluate()
    -- Clear dead entities from caches
    for k, _ in pairs(peakSpeeds) do
        local ent = ents.GetByIndex(k)
        if not IsValid(ent) then
            if overlayFilterPrint:GetBool() then
                print(string.format("%s removed, peak speed was %f",
                                    peakEntityInfo[k],
                                    peakSpeeds[k]))
            end
            
            peakSpeeds[k] = nil
        end
    end
end

SaitoHUD.RegisterOverlay("overlay", OVERLAY)

concommand.Add("overlay_filter_clear_cache", ClearOverlayCaches)
cvars.AddChangeCallback("overlay_filter_text", ClearOverlayCaches)

------------------------------------------------------------
-- Velocities
------------------------------------------------------------

local OVERLAY = {}

function OVERLAY.DrawEnt(ent)
    local pos = ent:GetPos()
    local vel = ent:GetVelocity()
    local len = vel:Length()
    local adjVel = vel / 10
    
    if len > 0 then
        local p1 = pos
        local p2 = pos + adjVel
        local d = math.Clamp(2 * math.exp(0.0004 * len), 5, 20)
        p1, p2 = p1:ToScreen(), p2:ToScreen()
        surface.SetDrawColor(255, 255, 0, 255)
        surface.DrawLine(p1.x, p1.y, p2.x, p2.y)
        local ang = math.atan2(p2.y - p1.y, p2.x - p1.x) - math.rad(135)
        local x = d * math.cos(ang) + p2.x
        local y = d * math.sin(ang) + p2.y
        surface.DrawLine(p2.x, p2.y, x, y)
        local ang = math.atan2(p2.y - p1.y, p2.x - p1.x) - math.rad(-135)
        local x = d * math.cos(ang) + p2.x
        local y = d * math.sin(ang) + p2.y
        surface.DrawLine(p2.x, p2.y, x, y)
    end
end

SaitoHUD.RegisterOverlay("vel_vec", OVERLAY)