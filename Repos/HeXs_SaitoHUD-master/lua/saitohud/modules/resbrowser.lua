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

local soundFolders = {}
local soundList = {}
local soundBrowserWindow
local loaded = false

--- Loads the sounds from file.
local function LoadSounds(f)
    local data = SaitoHUD.ParseCSV(file.Read("saitohud/resource_browser/sounds/" .. f, "DATA"))
    soundList = data
    
    soundFolders = {}
    
    if #data > 0 then
        -- Remove the header
        if data[1][1] == "Path" then
            table.remove(data, 1)
        end
        
        for _, v in pairs(data) do
            local parts = string.Explode("/", tostring(v[1]))
            table.remove(parts, #parts)
            
            local n = soundFolders
            for _, p in pairs(parts) do
                if not n[p] then n[p] = {} end
                n = n[p]
            end
        end
    end
    
    if soundBrowserWindow and soundBrowserWindow:IsValid() then
        soundBrowserWindow:Remove()
        soundBrowserWindow = nil
    end
end

--- Adds nodes for folders to a tree.
-- @param tree
-- @param folders
-- @param clickFunc
-- @param path
local function AddTreeFolders(tree, folders, clickFunc, path)
    local keys = {}
    if not path then path = "" end
    
    for folder, _ in pairs(folders) do
        table.insert(keys, folder)
    end
    
    table.sort(keys, function(a, b) return a:lower() < b:lower() end)
    
    for _, folder in pairs(keys) do
        local subfolders = folders[folder]
        local node = tree:AddNode(folder)
        node.DoClick = function(self)
            clickFunc(path .. folder .. "/")
        end
        AddTreeFolders(node, subfolders, clickFunc, path .. folder .. "/")
    end
end

--- Updates the list with the list of sound files.
-- @param panel
-- @param entries
-- @param path
local function UpdateSoundList(panel, entries, path)
    panel:Clear()
    
    local len = string.len(path)
    for _, line in pairs(entries) do
        local testPath = tostring(line[1])
        if string.sub(testPath, 1, len) == path then
            local rest = string.sub(testPath, len + 1)
            if not rest:find("/") then
                panel:AddLine(rest, "", path, testPath)
            end
        end
    end
end

--- Opens the sound browser.
function SaitoHUD.OpenSoundBrowser()
    if soundBrowserWindow then
        soundBrowserWindow:SetVisible(true)
        soundBrowserWindow:MakePopup()
        soundBrowserWindow:InvalidateLayout(true, true)
        return
    end
    
    if not loaded then
        LoadSounds("source.txt")
        loaded = true
    end
    
    local frame = vgui.Create("DFrame")
    soundBrowserWindow = frame
    frame:SetTitle("Sound Browser")
    frame:SetDeleteOnClose(false)
    frame:SetScreenLock(true)
    frame:SetSize(math.min(600, ScrW() - 20), ScrH() * 4/5)
    frame:SetSizable(true)
    frame:Center()
    frame:MakePopup()
    
    -- Make list view
    local sounds = vgui.Create("DListView", frame)
    sounds:SetMultiSelect(false)
    sounds:AddColumn("Filename"):SetMinWidth(200)
    sounds:AddColumn("Duration")
    sounds:AddColumn("Folder")
    
    sounds.OnRowSelected = function(lst, index)
        local line = lst:GetLine(index)
        local path = line:GetValue(4)
        RunConsoleCommand("stopsounds")
        timer.Simple(0.1, function()
            surface.PlaySound(path)
        end)
        line:SetValue(2, string.format("%.2f", SoundDuration(path)))
    end
    
    sounds.OnRowRightClick = function(lst, index, line)
        local menu = DermaMenu()
        menu:AddOption("Play", function()
            local line = lst:GetLine(index)
            local path = line:GetValue(4)
            RunConsoleCommand("stopsounds")
            timer.Simple(0.1, function()
                surface.PlaySound(path)
            end)
        end)
        menu:AddOption("Copy Filename", function()
            local line = lst:GetLine(index)
            SetClipboardText(line:GetValue(1))
        end)
        menu:AddOption("Copy Path", function()
            local line = lst:GetLine(index)
            SetClipboardText(line:GetValue(4))
        end)
        menu:AddOption("Copy Duration", function()
            local line = lst:GetLine(index)
            SetClipboardText(SoundDuration(line:GetValue(4)))
        end)
        menu:AddOption("Send to Wired Sound Emitter", function()
            local line = lst:GetLine(index)
            RunConsoleCommand("wire_soundemitter_sound", line:GetValue(4))
            RunConsoleCommand("tool_wire_soundemitter")
        end)
        menu:Open() 
    end
    
    sounds.DoDoubleClick = function(lst, index, line)
        if not line then return end
        frame:Close()
    end
    
    UpdateSoundList(sounds, soundList, "/")
    
    -- Make folder view
    local tree = vgui.Create("DTree", frame)
    
    AddTreeFolders(tree, soundFolders, function(path)
        UpdateSoundList(sounds, soundList, path)
    end)
    
    -- Make divider
    local divider = vgui.Create("DHorizontalDivider", frame)
    divider:SetLeftWidth(150)
    divider:SetLeft(tree)
    divider:SetRight(sounds)
    
    -- Load list button
    local loadListButton = vgui.Create("DButton", frame)
    loadListButton:SetText("Load List..")
    loadListButton:SetWide(80)
    loadListButton.DoClick = function()
        local files = file.Find("saitohud/resource_browser/sounds/*.txt", "DATA")
        
        local menu = DermaMenu()
        
        for _, file in pairs(files) do
            menu:AddOption(file, function()
                soundBrowserWindow:Close()
                LoadSounds(file)
                -- Very ugly
                SaitoHUD.OpenSoundBrowser()
            end)
        end
        
        menu:Open() 
    end
    
    -- Stop sounds button
    local stopSoundsButton = vgui.Create("DButton", frame)
    stopSoundsButton:SetText("Stop All Sounds")
    stopSoundsButton:SetWide(110)
    stopSoundsButton:SetTooltip("Will also stop game sounds")
    stopSoundsButton.DoClick = function()
        RunConsoleCommand("stopsounds")
    end
    
    -- Layout
    local oldPerform = frame.PerformLayout
    frame.PerformLayout = function()
        oldPerform(frame)
        divider:StretchToParent(10, 28 + 28, 10, 10)
        
        loadListButton:SetPos(10, 28)
        stopSoundsButton:SetPos(10 + loadListButton:GetWide() + 5, 28)
    end
    
    -- Close
    local oldClose = frame.Close
    frame.Close = function(self)
        RunConsoleCommand("stopsounds")
        oldClose(self)
    end
    
    frame:InvalidateLayout(true, true)
end

concommand.Add("sound_browser", function() SaitoHUD.OpenSoundBrowser() end)