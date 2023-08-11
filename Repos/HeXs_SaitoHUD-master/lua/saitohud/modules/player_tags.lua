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
-- Name tags
------------------------------------------------------------

local drawNameTags = CreateClientConVar("name_tags", "0", true, false)
local alwaysDrawFriendTags = CreateClientConVar("friend_tags_always", "0", true, false)
local simpleNameTags = CreateClientConVar("name_tags_simple", "1", true, false)
local rainbowFriends = CreateClientConVar("name_tags_rainbow_friends", "0", true, false)
local boldFriends = CreateClientConVar("name_tags_bold_friends", "1", true, false)
local playerDistances = CreateClientConVar("name_tags_distances", "1", true, false)

local function NameTagsPaint()
    local refPos = SaitoHUD.GetRefPos()
    local all = drawNameTags:GetBool()
    local alwaysFriends = alwaysDrawFriendTags:GetBool()
    local showDistances = playerDistances:GetBool()
    local simpleTags = simpleNameTags:GetBool()
    local boldFriends = boldFriends:GetBool()
    local rainbow = rainbowFriends:GetBool()
    
    for _, ply in pairs(player.GetAll()) do
        local name = ply:GetName()
        local screenPos = (ply:GetPos() + Vector(0, 0, 50)):ToScreen()
        local distance = math.Round(ply:GetPos():Distance(refPos))
        local color = color_white
        local shadowColor = Color(0, 0, 0, 255)
        local isFriend = SaitoHUD.IsFriend(ply)
        local bold = boldFriends and isFriend
        
        if all or (alwaysFriends and isFriend) then
            -- Friend name colors
            if isFriend then
                if rainbow then
                    color = HSVToColor(math.sin(CurTime() * 360 / 500) * 360, 1, 1)
                else
                    color = SaitoHUD.GetFriendColor(ply)
                end
            end
            
            -- Distances
            local text = name
            if showDistances then
                text = text .. "[" .. tostring(distance) .. "]"
            end
            
            if simpleTags then
                if bold then
                    draw.SimpleText(text, "DefaultBold", screenPos.x + 1,
                                    screenPos.y + 1, shadowColor, 1, ALIGN_TOP)
                    draw.SimpleText(text, "DefaultBold", screenPos.x, screenPos.y,
                                    color, 1, ALIGN_TOP)
                else
                    draw.SimpleText(text, "DefaultSmallDropShadow", screenPos.x + 1,
                                    screenPos.y + 1, color, 1, ALIGN_TOP)
                end
            else
                if bold then
                    draw.SimpleTextOutlined(text, "DefaultBold", screenPos.x,
                                            screenPos.y, color, 1, ALIGN_TOP, 1,
                                            shadowColor)
                else
                    draw.SimpleTextOutlined(text, "DefaultSmall", screenPos.x,
                                            screenPos.y, color, 1, ALIGN_TOP, 1,
                                            shadowColor)
                end
            end
        end
        
        -- End player loop
    end
end

SaitoHUD.HookOnCvar({"name_tags", "friend_tags_always"}, "SaitoHUD.NameTags", {
    HUDPaint = NameTagsPaint,
}, true)

------------------------------------------------------------
-- Player bounding boxes
------------------------------------------------------------

local playerBoxes = CreateClientConVar("player_boxes", "0", true, false)

local function PlayerBBoxesPaint()
    local refPos = SaitoHUD.GetRefPos()
    
    for _, ply in pairs(player.GetAll()) do
        local pos = ply:GetPos()
        
        local obbMin = ply:OBBMins()
        local obbMax = ply:OBBMaxs()
        
        local p = {
            Vector(obbMin.x, obbMin.y, obbMin.z),
            Vector(obbMin.x, obbMax.y, obbMin.z),
            Vector(obbMax.x, obbMax.y, obbMin.z),
            Vector(obbMax.x, obbMin.y, obbMin.z),
            Vector(obbMin.x, obbMin.y, obbMax.z),
            Vector(obbMin.x, obbMax.y, obbMax.z),
            Vector(obbMax.x, obbMax.y, obbMax.z),
            Vector(obbMax.x, obbMin.y, obbMax.z),
        }
        
        local front = Vector(0, 0, 40)
        front:Rotate(Angle(0, ply:EyeAngles().y, 0))
        front = ply:LocalToWorld(front):ToScreen()
        local front2 = Vector(50, 0, 40)
        front2:Rotate(Angle(0, ply:EyeAngles().y, 0))
        front2 = ply:LocalToWorld(front2):ToScreen()
        
        local visible = true
        for i = 1, 8 do
            p[i]:Rotate(Angle(0, ply:EyeAngles().y, 0))
            p[i] = ply:LocalToWorld(p[i])
            p[i] = p[i]:ToScreen()
            if not p[i].visible then
                visible = false
                break
            end
        end
        
        if visible then
            if ply:Alive() then
                surface.SetDrawColor(0, 255, 0, 255)
            else
                surface.SetDrawColor(0, 0, 255, 255)
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
            
            surface.DrawLine(front.x, front.y, front2.x, front2.y)
        end
    end
end

SaitoHUD.HookOnCvar("player_boxes", "SaitoHUD.PlayerBBoxes", {
    HUDPaint = PlayerBBoxesPaint,
}, true)

------------------------------------------------------------
-- Player markers
------------------------------------------------------------

local playerMarkers = CreateClientConVar("player_markers", "0", true, false)

local function PlayerMarkersPaint()
    for _, ply in pairs(player.GetAll()) do
        local pos = ply:GetPos()
        
        local obbMin = ply:OBBMins()
        local obbMax = ply:OBBMaxs()
        
        local p = {
            Vector(0, 10, 0),
            Vector(0, -10, 0),
            Vector(10, 0, 0),
        }
        
        local visible = true
        for i = 1, 3 do
            p[i]:Rotate(Angle(0, ply:EyeAngles().y, 0))
            p[i] = ply:LocalToWorld(p[i])
            p[i] = p[i]:ToScreen()
            if not p[i].visible then
                visible = false
                break
            end
        end
        
        if visible then
            if ply:Alive() then
                surface.SetDrawColor(0, 255, 0, 255)
            else
                surface.SetDrawColor(0, 0, 255, 255)
            end
            
            -- Bottom
            surface.DrawLine(p[1].x, p[1].y, p[2].x, p[2].y)
            surface.DrawLine(p[2].x, p[2].y, p[3].x, p[3].y)
            surface.DrawLine(p[3].x, p[3].y, p[1].x, p[1].y)
        end
    end
end

SaitoHUD.HookOnCvar("player_markers", "SaitoHUD.PlayerMarkers", {
    HUDPaint = PlayerMarkersPaint,
}, true)