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


surface.CreateFont("Trebuchet22", {
	font		= "Trebuchet MS",
	size 		= 22,
	weight		= 900,
	antialias	= true,
	additive	= false,
	}
)




local spectateLock = CreateClientConVar("free_spectate_lock", "1", true, false)
local spectateRate = CreateClientConVar("free_spectate_rate", "1000", true, false)
local spectateSlowFactor = CreateClientConVar("free_spectate_slow_factor", "4", true, false)
local spectateNotice = CreateClientConVar("free_spectate_notice", "1", true, false)

local viewPos = Vector()
local viewAng = Angle()
local spectating = false
local origViewAngle = Angle()
local listenPresses = {
    "+forward", "+back", "+moveleft", "+moveright",
    "+jump", "+speed", "+duck", "+walk"
}
local keyPressed = {}

------------------------------------------------------------
-- Hooks
------------------------------------------------------------

local data = {}

--- Control view angle.
local function CreateMove(usercmd)
    viewAng.p = math.Clamp(viewAng.p + usercmd:GetMouseY() * 0.025, -90, 90)
    viewAng.y = viewAng.y - usercmd:GetMouseX() * 0.025
    
    if spectateLock:GetBool() then
        usercmd:SetViewAngles(origViewAngle)
    else
        data.start = viewPos
        data.endpos = viewPos + viewAng:Forward() * 50000
        data.filter = LocalPlayer()
        local tr = util.TraceLine(data)
        usercmd:SetViewAngles((tr.HitPos - LocalPlayer():GetShootPos()):Angle())
    end
end

--- Handle key presses.
local function PlayerBindPress(ply, bind, pressed)
    for _, key in pairs(listenPresses) do
        if bind:find(key) then
            keyPressed[key] = pressed
            return true
        end
    end
    
    if spectateLock:GetBool() and bind:find("+attack") or 
        bind:find("+attack2") or bind:find("+use") or bind:find("+reload") then
        return true
    end
end

--- Set the view.
local function CalcView(ply, origin, angles, fov)
    local view = {}
    view.origin = viewPos
    view.angles = viewAng
    view.fov = fov
    return view
end

--- Do movement.
local function Think()
    local rate = keyPressed["+speed"] and spectateRate:GetFloat() * 2 or spectateRate:GetFloat()
    if keyPressed["+walk"] then rate = rate / spectateSlowFactor:GetFloat() end
    
    if keyPressed["+forward"] then viewPos = viewPos + viewAng:Forward() * rate * RealFrameTime() end
    if keyPressed["+back"] then viewPos = viewPos - viewAng:Forward() * rate * RealFrameTime() end
    if keyPressed["+moveleft"] then viewPos = viewPos - viewAng:Right() * rate * RealFrameTime() end
    if keyPressed["+moveright"] then viewPos = viewPos + viewAng:Right() * rate * RealFrameTime() end
    if keyPressed["+jump"] then viewPos = viewPos + viewAng:Up() * rate * RealFrameTime() end
    if keyPressed["+duck"] then viewPos = viewPos - viewAng:Up() * rate * RealFrameTime() end
end

--- HUDPaint function.
local function HUDPaint()
    if not spectateNotice:GetBool() then return end
    
    local text = "Free Spectating"
    
    if not spectateLock:GetBool() then
        text = "(UNLOCKED) Free Spectating"
    end
    
    draw.SimpleText(text, "Trebuchet22", ScrW() / 2 + 1, ScrH() * .8 + 1,
                    Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(text, "Trebuchet22", ScrW() / 2, ScrH() * .8,
                    color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

------------------------------------------------------------
-- Override
------------------------------------------------------------

local pMeta = FindMetaTable("Player")

-- Have to protect old trace functions
if not pMeta._GetEyeTrace then
	pMeta._GetEyeTrace = pMeta.GetEyeTrace
end

if not util._GetPlayerTrace then
	util._GetPlayerTrace = util.GetPlayerTrace
end


local data = {} -- util.GetEyeTrace()
local lastTrace = nil
local lastTraceTime = 0

function pMeta:GetEyeTrace()
    local localPly = LocalPlayer()
    
    if not spectating or self ~= localPly then
        return self:_GetEyeTrace()
    end
    
    -- No point to do traces more than needed
    if lastTraceTime == CurTime() then
        return lastTrace
    end
    
    data.start = viewPos
    data.endpos = viewPos + viewAng:Forward() * 16384 
    data.filter = localPly
    lastTrace = util.TraceLine(data)
    return lastTrace
end

local data = {} -- util.GetPlayerTrace()

function util.GetPlayerTrace(ply)
    local localPly = LocalPlayer()
    
    if spectating and ply == localPly then
        return localPly:GetEyeTrace()
    else
        return util._GetPlayerTrace(ply)
    end
end

local data = {} -- SaitoHUD.GetRefTrace()

function SaitoHUD.GetRefTrace()
    return LocalPlayer():GetEyeTrace()
end

function SaitoHUD.GetRefPos()
    return spectating and viewPos or LocalPlayer():GetPos()
end

------------------------------------------------------------
-- Control
------------------------------------------------------------

local function ToggleSpectate(ply, cmd, args)
    spectating = not spectating
    
    local localPly = LocalPlayer()
    origViewAngle = localPly:EyeAngles()
    viewPos = localPly:GetShootPos()
    viewAng = localPly:EyeAngles() -- Need to make a copy
    
    SaitoHUD.HookIfTrue(spectating, "SaitoHUD.Spectate", {
        CreateMove = CreateMove,
        PlayerBindPress = PlayerBindPress,
        CalcView = CalcView,
        Think = Think,
        ShouldDrawLocalPlayer = function() return true end,
        HUDPaint = HUDPaint,
    }, true)
end

concommand.Add("free_spectate", ToggleSpectate)
concommand.Add("toggle_spectate", ToggleSpectate)
