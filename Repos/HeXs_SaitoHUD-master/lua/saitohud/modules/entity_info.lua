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

local drawEntityInfo = CreateClientConVar("entity_info", "1", true, false)
local showPlayerInfo = CreateClientConVar("entity_info_player", "0", true, false)
local EntinfoHight = CreateClientConVar("entity_info_hight", 0.3, true, false)

local function EntityInfoPaint()
    if SaitoHUD.Gesturing then return end
    
    local lines = SaitoHUD.GetEntityInfoLines(
        showPlayerInfo:GetBool(), 
        drawEntityInfo:GetBool()
    )
    
    if table.Count(lines) > 0 then
        local color = color_white
        
        local yOffset = ScrH() * EntinfoHight:GetFloat()
        for _, s in pairs(lines) do
            draw.SimpleText(s, "TabLarge", ScrW() - 16, yOffset, color, 2, ALIGN_TOP)
            yOffset = yOffset + 14
        end
    end
end

SaitoHUD.HookOnCvar("entity_info", "SaitoHUD.EntityInfo", {
    HUDPaint = EntityInfoPaint
})

concommand.Add("dump_info", function() SaitoHUD.DumpEntityInfo() end)