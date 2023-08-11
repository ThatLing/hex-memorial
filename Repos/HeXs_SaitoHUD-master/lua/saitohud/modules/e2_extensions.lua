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

local e2ExtensionsWindow

local readableTypes = {
    ["n"] = "number",
    ["xv2"] = "vector2",
    ["v"] = "vector3",
    ["xv4"] = "vector4",
    ["a"] = "angle",
    ["s"] = "string",
    ["e"] = "entity",
    ["r"] = "array",
    ["t"] = "table",
    ["xrd"] = "rangerdata",
    ["b"] = "bone",
    ["xm2"] = "matrix2",
    ["m"] = "matrix3",
    ["xm4"] = "matrix4",
    ["xwl"] = "wirelink",
    ["c"] = "complex",
    ["q"] = "quaternion",
    ["g"] = "generic",
    ["xcd"] = "code",
    ["f"] = "function",
}

--- Turn the arguments into a list of readable ones.
-- @param args
-- @Param argNames Table of argument names
local function MakeReadableArgs(args, argNames)
    if args == "..." then return args end
    argNames = argNames or {}
    
    local text = {}
    
    local i = 1
    local argNameK = 97
    
    while i <= string.len(args) do
        local char = args:sub(i, i)
        local dataType
        
        if char == "x" then
            dataType = args:sub(i, i + 2)
            i = i + 3
        elseif char == "." then
            dataType = args:sub(i, i + 2)
            i = i + 3
        else
            dataType = char
            i = i + 1
        end
        
        if dataType ~= "..." then
            local argName = argNames[i]
            if not argName then
                argName = string.char(argNameK)
                argNameK = argNameK + 1
            end
            
            table.insert(text, (readableTypes[dataType] or dataType) .. " " .. argName)
        else
            table.insert(text, dataType)
        end
    end
    
    return string.Implode(", ", text)
end

--- Writes the standard function list.
function SaitoHUD.WriteE2StandardFuncs()
    local data = ""
    for signature, _ in pairs(wire_expression2_funcs) do
        data = data .. signature .. "\n"
    end
    file.Write("saitohud/e2_std_funcs.txt", data, "DATA")
end

--- Populates the function list.
-- @param lst List panel
local function PopulateE2ExtensionsList(lst)
    local data = file.Read("saitohud/e2_std_funcs.txt", "DATA")
    local standardFunctions = {}
    
    if data then
        local lines = string.Explode("\n", data)
        for _, v in pairs(lines) do
            v = v:Trim()
            if v ~= "" then
                standardFunctions[v] = true
            end
        end
    end
    
    for signature, info in pairs(wire_expression2_funcs) do
        local cls, args
        local func, inner = signature:match("([^%(]+)%((.*)%)")
        
        -- Index set function
        if not func:find("op:") and not standardFunctions[signature] then
            -- Try to extract the class and arguments
            if inner:find(":") then
                local res = string.Explode(":", inner)
                cls, args = res[1], res[2]
            else
                cls = ""
                args = inner
            end
            
            local text = string.format("%s %s(%s)",
                info[2] ~= "" and (readableTypes[info[2]] or info[2]) or "",
                (readableTypes[cls] and readableTypes[cls] .. ":" or cls) .. 
                func, MakeReadableArgs(args, info.argnames))
            
            lst:AddLine(info[2] ~= "" and (readableTypes[info[2]] or info[2]) or "",
                        readableTypes[cls] and readableTypes[cls] .. ":" or cls,
                        func .. "()",
                        MakeReadableArgs(args, info.argnames), signature, text:Trim())
        end
    end
end

--- Prints the function list.
-- @param lst List panel
local function DumpE2ExtensionsList(lst)
    local data = file.Read("saitohud/e2_std_funcs.txt", "DATA")
    local standardFunctions = {}
    
    if data then
        local lines = string.Explode("\n", data)
        for _, v in pairs(lines) do
            v = v:Trim()
            if v ~= "" then
                standardFunctions[v] = true
            end
        end
    end
    
    local funcs = {}
    
    for signature, info in pairs(wire_expression2_funcs) do
        local cls, args
        local func, inner = signature:match("([^%(]+)%((.*)%)")
        
        -- Index set function
        if not func:find("op:") and not standardFunctions[signature] then
            -- Try to extract the class and arguments
            if inner:find(":") then
                local res = string.Explode(":", inner)
                cls, args = res[1], res[2]
            else
                cls = ""
                args = inner
            end
            
            local text = string.format("%s %s(%s)",
                info[2] ~= "" and (readableTypes[info[2]] or info[2]) or "",
                (readableTypes[cls] and readableTypes[cls] .. ":" or cls) .. 
                func, MakeReadableArgs(args, info.argnames))
            
            table.insert(funcs, {
                info[2] ~= "" and (readableTypes[info[2]] or info[2]) or "void",
                readableTypes[cls] and readableTypes[cls] .. ":" or cls,
                func,
                MakeReadableArgs(args, info.argnames)
            })
        end
    end
    
    table.SortByMember(funcs, 3, function(a, b) return a > b end)
    
    local out = ""
    
    for _, v in pairs(funcs) do
        local text = string.format("<tr><td>%s</td><td style=\"text-align: right\">%s</td><td><strong>%s</strong>(%s)</td></tr>\n",
            v[1], v[2], v[3], v[4] == "" and "" or " " .. v[4] .. " ")
        out = out .. text
    end
    
    file.Write("saitohud_dump_e2_funcs.txt", out, "DATA")
end

--- Opens the E2 extensions window.
function SaitoHUD.OpenE2Extensions()
    if not wire_expression2_funcs then
        Derma_Message("This server does not have Expression 2.", "Error", "OK")
        return
    end
    
    if e2ExtensionsWindow then
        e2ExtensionsWindow:SetVisible(true)
        e2ExtensionsWindow:MakePopup()
        e2ExtensionsWindow:InvalidateLayout(true, true)
        return
    end
    
    local frame = vgui.Create("DFrame")
    e2ExtensionsWindow = frame
    frame:SetTitle("Expression 2 Extensions")
    frame:SetDeleteOnClose(false)
    frame:SetScreenLock(true)
    frame:SetSize(math.min(600, ScrW() - 20), ScrH() * 4/5)
    frame:SetSizable(true)
    frame:Center()
    frame:MakePopup()
    
    -- Make information box
    local info = vgui.Create("DLabel", frame)
    info:SetText("")
    info:SetWrap(true)
    info:SetAutoStretchVertical(true)
    
    -- Make list view
    local funcs = vgui.Create("DListView", frame)
    funcs:SetMultiSelect(false)
    funcs:AddColumn("Return"):SetFixedWidth(80)
    funcs:AddColumn("Class"):SetFixedWidth(80)
    funcs:AddColumn("Function")
    funcs:AddColumn("Arguments")
    PopulateE2ExtensionsList(funcs)
    
    funcs.OnRowSelected = function(lst, index)
        local line = lst:GetLine(index)
        info:SetText(line:GetValue(6))
    end
    
    funcs.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Copy Function Name", function()
            local line = lst:GetLine(index)
            SetClipboardText(line:GetValue(3))
        end)
        menu:AddOption("Copy Signature", function()
            local line = lst:GetLine(index)
            SetClipboardText(line:GetValue(6))
        end)
        menu:AddOption("Copy Raw Signature", function()
            local line = lst:GetLine(index)
            SetClipboardText(line:GetValue(5))
        end)
        menu:Open() 
    end
    
    -- Make divider
    local divider = vgui.Create("DVerticalDivider", frame)
    divider:SetTopHeight(ScrH() * 4/5 - 50)
    divider:SetTop(funcs)
    divider:SetBottom(info)
    
    -- Layout
    local oldPerform = frame.PerformLayout
    frame.PerformLayout = function()
        oldPerform(frame)
        divider:StretchToParent(10, 28, 10, 10)
    end
    
    frame:InvalidateLayout(true, true)
end

concommand.Add("e2_extensions", function() SaitoHUD.OpenE2Extensions() end)
concommand.Add("dump_e2_extensions", DumpE2ExtensionsList)