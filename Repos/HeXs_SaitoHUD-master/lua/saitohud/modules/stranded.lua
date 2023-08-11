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

local checkSeeable = CreateClientConVar("stranded_res_seeable", "1", true, false)
local resDistance = CreateClientConVar("stranded_res_distance", "500", true, false)

local itemColors = {
    ["Stone"] = Color(217, 217, 217),
    ["Iron"] = Color(138, 162, 207),
    ["Iron Ore"] = Color(71, 85, 110),
    ["Copper"] = Color(219, 194, 116),
    ["Copper Ore"] = Color(99, 86, 45),
    ["Melon Seeds"] = Color(158, 255, 97),
    ["Orange Seeds"] = Color(255, 149, 0),
    ["Banana Seeds"] = Color(255, 244, 97),
    ["Grain Seeds"] = Color(191, 184, 136),
    ["Berries"] = Color(255, 0, 0),
    ["Sprouts"] = Color(0, 186, 6),
    ["Sand"] = Color(232, 230, 183),
    ["Herbs"] = Color(162, 179, 121),
    ["Salmon"] = Color(255, 181, 203),
    ["Shark"] = Color(97, 95, 161),
    ["Wood"] = Color(148, 101, 0),
    ["Bass"] = Color(173, 214, 255),
    ["Dead Bird"] = Color(41, 41, 41),
    ["Water Bottles"] = Color(0, 128, 255),
    ["Trout"] = Color(0, 154, 196),
    ["Dead Headcrab"] = Color(222, 201, 151),
    ["Metal Scrap"] = Color(82, 82, 82),
    ["Charcoal"] = Color(120, 120, 120),
    ["Sulphur"] = Color(255, 247, 0),
    ["Urine Bottles"] = Color(153, 148, 0),
    ["Medicine"] = Color(255, 0, 204),
    ["Saltpetre"] = Color(255, 255, 255),
    ["Gunslide"] = Color(241, 205, 255),
    ["Gungrip"] = Color(89, 45, 255),
    ["Gunbarrel"] = Color(84, 72, 60),
    ["Gunmagazine"] = Color(77, 77, 77),
    ["Gunpowder"] = Color(77, 77, 77),
    ["Raw Meat"] = Color(255, 163, 169),
    ["Glass"] = Color(204, 238, 255),
    ["Plastic"] = Color(227, 227, 227),
}

local plantIDs = {
    ["Melon_Seeds"] = "melon",
    ["Orange_Seeds"] = "orange",
    ["Banana_Seeds"] = "banana",
}

local function HUDPaint()
    local ply = LocalPlayer()
    local selfPos = ply:GetPos()
    local shootPos = ply:GetShootPos()

    for _, v in ipairs(ents.GetAll()) do
        if v:GetClass() == "gms_resourcedrop" then
            local pos = v:LocalToWorld(v:OBBCenter())
            local distance = selfPos:Distance(pos)
            
            local data = {}
            data.start = selfPos
            data.endpos = pos
            data.filter = ply
            local tr = util.TraceLine(data)

            if distance <= resDistance:GetFloat() and (not checkSeeable:GetBool() or 
                tr.Entity == v) then
                local text = (v.Res or "Loading") .. ": " .. tostring(v.Amount or 0)
                local drawLoc = pos:ToScreen()
                surface.SetFont("ChatFont")
                local w, h = surface.GetTextSize(text)
                 draw.RoundedBox(4, drawLoc.x - (w/2) - 3, drawLoc.y - (h/2) - 3,
                                w + 6, h + 6, Color(50, 50, 50, 200))
                local r, g, b = itemColors[v.Res] and itemColors[v.Res] or
                    HSVToColor((string.byte(text) * 5 + string.byte(text, 3) * 7) % 360, 1, 1)
                surface.SetTextColor(r, g, b, 200)
                surface.SetTextPos(drawLoc.x - (w/2), drawLoc.y - (h/2))
                surface.DrawText(text)
            end
        end

        if CheckName(v, GMS.StructureEntities) then
            local pos = v:LocalToWorld(v:OBBCenter())
            local minimum = v:LocalToWorld(v:OBBMins())
            local maximum = v:LocalToWorld(v:OBBMaxs())
            local loc = Vector(0, 0, 0)
            local distance = selfPos:Distance(pos)
            local range = (maximum - minimum):Length()
            if range < 200 then range = 200 end
            
            local data = {}
            data.start = selfPos
            data.endpos = pos
            data.filter = ply
            local tr = util.TraceLine(data)
            
            if distance <= range and (tr.Entity == v or not tr.Hit) then
                local text = v:GetNetworkedString("Name") or "Loading"
                if v:GetClass() == "gms_buildsite" then
                    text = text .. v:GetNetworkedString('Resources')
                end
                
                if minimum.z <= maximum.z then
                    if shootPos.z > maximum.z then
                        loc.z = maximum.z
                    elseif shootPos.z < minimum.z then
                        loc.z = minimum.z
                    else
                        loc.z = shootPos.z
                    end
                else
                    if shootPos.z < maximum.z then
                        loc.z = maximum.z
                    elseif shootPos.z > minimum.z then
                        loc.z = minimum.z
                    else
                        loc.z = shootPos.z
                    end
                end
                
                local drawLoc = Vector(pos.x, pos.y, loc.z):ToScreen()
                surface.SetFont("ChatFont")
                local w, h = surface.GetTextSize(text)
                 draw.RoundedBox(4, drawLoc.x - (w/2) - 3, drawLoc.y - (h/2) - 3,
                                w + 6, h + 6, Color(50, 50, 50, 200))
                surface.SetTextColor(255, 255, 255, 200)
                surface.SetTextPos(drawLoc.x - (w/2), drawLoc.y - (h/2))
                surface.DrawText(text)
            end
        end
    end
end

local lastAttack2 = false

local function HandleKey(ply, key)
    if input.IsMouseDown(MOUSE_RIGHT) then
        if not lastAttack2 and ply:GetActiveWeapon():GetClass() == "gms_hands" then
            local shootPos = ply:GetShootPos()
            local eyeAngles = ply:EyeAngles()
            
            local data = {}
            data.start = shootPos
            data.endpos = shootPos + eyeAngles:Forward() * 200
            data.filter = ply
            
            local tr = util.TraceLine(data)
            if tr.Hit and IsValid(tr.Entity) then
                if tr.Entity:GetClass() == "gms_resourcedrop" and tr.Entity.Res then    
                    local id = tr.Entity.Res:gsub(" ", "_")
                    if Resources[id] then
                        ply:ChatPrint("Dropping " .. tr.Entity.Res .. ".")
                        RunConsoleCommand("say", string.format("!drop %s", id))
                    else
                        ply:ChatPrint("You don't have " .. tr.Entity.Res .. ".")
                    end
                end
            end
        end
    end
    lastAttack2 = input.IsMouseDown(MOUSE_RIGHT)
end

local function StrandedMenu(numHooks)
    local ply = LocalPlayer()
    local shootPos = ply:GetShootPos()
    
    local menu = {}
    
    -- Drop resources
    for id, num in pairs(Resources) do
        if num > 0 then
            local name = id:gsub("_", " ")
            table.insert(menu, {
                ["text"] = string.format("Drop %s (%d)", name, num),
                ["action"] = function()
                        RunConsoleCommand("say", string.format("!drop %s", id))
                    end,
                ["bgColor"] = Color(84, 58, 39, 255),
            })
        end
    end
    
    local bgColor = Color(100, 100, 39, 255)
    
    -- Drop weapon
    table.insert(menu, {
        ["text"] = "Drop Weapon",
        ["action"] = function()
                RunConsoleCommand("say", "!dropweapon")
            end,
        ["bgColor"] = Color(84, 58, 39, 255),
    })
    
    local bgColor = Color(49, 84, 39, 255)

    local data = {}
    data.start = shootPos
    data.endpos = shootPos + ply:GetAimVector() * 150
    data.filter = ply
    
    -- Take resources
    local tr = util.TraceLine(data)
    if tr.Hit and IsValid(tr.Entity) then 
        if ply:GetPos():Distance(tr.Entity:LocalToWorld(tr.Entity:OBBCenter())) < 65 and 
            tr.Entity:GetClass() == "gms_resourcedrop" and tr.Entity.Res then
            local name = tr.Entity.Res:gsub("_", " ")
            local id = name:gsub(" ", "_")
            
            if tr.Entity.Amount > 1 then
                table.insert(menu, {
                    ["text"] = string.format("Take %s (leave 1)", name),
                    ["action"] = function()
                            RunConsoleCommand("say", string.format("!take %s %d", id, tr.Entity.Amount - 1))
                        end,
                    ["bgColor"] = Color(49, 84, 39, 255),
                })
            end
            
            for _, num in pairs({1, 2, 5, 10, 50, 100}) do
                if num > tr.Entity.Amount then break end
                table.insert(menu, {
                    ["text"] = string.format("Take %s (%d/%d)", name, num, tr.Entity.Amount),
                    ["action"] = function()
                            RunConsoleCommand("say", string.format("!take %s %d", id, num))
                        end,
                    ["bgColor"] = Color(49, 84, 39, 255),
                })
            end
        end
    end
    
    -- Plant
    local foundPlant = false
    for id, cmd in pairs(plantIDs) do
        if Resources[id] and Resources[id] > 0 then
            table.insert(menu, {
                ["text"] = "Plant Anything",
                ["action"] = function()
                        SaitoHUD.StrandedPlantAnything()
                    end,
                ["bgColor"] = Color(41, 89, 75, 255),
            })
            break
        end
    end
    
    return menu
end

local function SetUp()
    if GMS then
        function SaitoHUD.StrandedPlantAnything()
            local foundPlant = false
            
            for id, cmd in pairs(plantIDs) do
                if Resources[id] and Resources[id] > 0 then
                    RunConsoleCommand("say", "!" .. cmd)
                    foundPlant = true
                    break
                end
            end
            
            if not foundPlant then
                SaitoHUD.ShowHint("Nothing to plant!")
            end
        end
        
        function SaitoHUD.StrandedDropSomething()
            for id, num in pairs(Resources) do
                if num > 0 then
                    RunConsoleCommand("say", "!drop " .. id)
                    break
                end
            end
        end

        hook.Add("SaitoHUDProvideMenu", "SaitoHUD.Stranded", StrandedMenu)
        hook.Add("HUDPaint", "SaitoHUDStrandedHUDPaint", HUDPaint)
        SaitoHUD.RemoveHook("HUDPaint", "GMS_ResourceDropsHUD")
        hook.Add("KeyRelease", "SaitoHUDStrandedKeyRelease", HandleKey)
        hook.Add("KeyPress", "SaitoHUDStrandedKeyPress", HandleKey)
    end
end

hook.Add("Initialize", "SaitoHUDStrandedInitialize", SetUp)
SetUp()