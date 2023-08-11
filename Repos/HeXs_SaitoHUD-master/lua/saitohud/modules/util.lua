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
-- Super flashlight
------------------------------------------------------------

local selfLight = CreateClientConVar("super_flashlight_self", "0", true, false)
local brightLight = CreateClientConVar("super_flashlight_bright", "0", true, false)

local lightEnabled = false

local function RenderFlashlight()
    local bright = brightLight:GetBool()
    
    if not selfLight:GetBool() then
        local light = DynamicLight(123120000)
        if light then 
            local tr = SaitoHUD.GetRefTrace()
            light.Pos = tr.HitPos + tr.HitNormal * 100
            light.r = 255
            light.g = 255 
            light.b = 255
            light.Brightness = 0.25
            light.Size = bright and 5000 or 1000
            light.Decay = 0 
            light.DieTime = CurTime() + 0.3
        end
    end
    
    local light = DynamicLight(123120001) 
    if light then 
        light.Pos = SaitoHUD.GetRefPos() + Vector(0, 0, 40)
        light.r = 255
        light.g = 255 
        light.b = 255
        light.Brightness = 0.25
        light.Size = bright and 5000 or 1000
        light.Decay = 0 
        light.DieTime = CurTime() + 0.3
    end 
end

concommand.Add("super_flashlight", function()
    lightEnabled = not lightEnabled
    
    surface.PlaySound("items/flashlight1.wav")
    
    SaitoHUD.HookIfTrue(lightEnabled, "SaitoHUD.FlashLight", {
        Think = RenderFlashlight,
    }, true)
end)

------------------------------------------------------------
-- HUD hide
------------------------------------------------------------

local hideHUD = false

concommand.Add("toggle_hud", function(ply, cmd, args)
    hideHUD = not hideHUD
    
    SaitoHUD.HookIfTrue(hideHUD, "SaitoHUD.FlashLight", {
        HUDShouldDraw = function() return false end,
    })
end)

------------------------------------------------------------
-- Toggled console commands
------------------------------------------------------------

local toggledCommands = {}

concommand.Add("toggle_concmd", function(ply, cmd, args)
    if #args ~= 1 then
        Msg("Invalid number of arguments\n")
        return
    end
    
    local cmd = args[1]
    
    if toggledCommands[cmd] then
        RunConsoleCommand("-" .. cmd)
        toggledCommands[cmd] = nil
        chat.AddText(Color(255, 0, 0), "-" .. cmd)
    else
        RunConsoleCommand("+" .. cmd)
        toggledCommands[cmd] = true
        chat.AddText(Color(0, 255, 0), "+" .. cmd)
    end
end)

------------------------------------------------------------
-- Aim traces
------------------------------------------------------------

local traceAims = CreateClientConVar("trace_aims", "0", true, false)
local data = {}

local function DrawPlayerAim(ply)
    if ply == LocalPlayer() or not ply:Alive() then return end
    
    local shootPos = ply:GetShootPos()
    local eyeAngles = ply:EyeAngles()
    
    data.start = shootPos
    data.endpos = shootPos + eyeAngles:Forward() * 10000
    data.filter = ply
    
    local tr = util.TraceLine(data)
    local distance = tr.HitPos:Distance(shootPos)
    
    -- Draw the end point
    cam.Start3D2D(tr.HitPos + tr.HitNormal * 0.2,
                  tr.HitNormal:Angle() + Angle(90, 0, 0), 1)
    if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
        surface.SetDrawColor(255, 255, 0, 200)
    else
        surface.SetDrawColor(0, 0, 255, 150)
    end
    surface.DrawRect(-5, -5, 10, 10)
    cam.End3D2D()
    
    -- Draw the line
    cam.Start3D2D(shootPos, eyeAngles, 1)
    if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
        surface.SetDrawColor(255, 255, 0, 255)
    else
        surface.SetDrawColor(0, 0, 255, 200)
    end
    surface.DrawLine(0, 0, distance, 0)
    cam.End3D2D()
end

local function DrawTraceAims()
    cam.Start3D(EyePos(), EyeAngles())
    for _, ply in pairs(player.GetAll()) do
        pcall(DrawPlayerAim, ply)
    end
    cam.End3D()
end

SaitoHUD.HookOnCvar("trace_aims", "SaitoHUD.AimTrace", {
    RenderScreenspaceEffects = DrawTraceAims,
}, true)