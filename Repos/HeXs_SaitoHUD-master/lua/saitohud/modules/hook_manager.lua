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

g_SaitoHUDHookMemory = g_SaitoHUDHookMemory or {}

------------------------------------------------------------
-- SaitoHUDHookManager
------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self.HookMemory = g_SaitoHUDHookMemory
    
    self:SetTitle("SaitoHUD Hook Manager")
    self:SetSizable(true)
    self:SetSize(math.max(600, ScrW() * 0.8), 400)
    self:ShowCloseButton(true)
    self:SetDraggable(true)
    
    -- Make list view
    self.HookList = vgui.Create("DCustomListView", self)
    self.HookList:SetLineClass("DListView_CheckboxLine")
    self.HookList:AddColumn(""):SetFixedWidth(25)
    self.HookList:AddColumn("Hook"):SetWide(50)
    self.HookList:AddColumn("ID"):SetWide(100)
    self.HookList:AddColumn("File"):SetWide(200)
    
    self.RefreshBtn = vgui.Create("DButton", self)
    self.RefreshBtn:SetText("Refresh")
    self.RefreshBtn:SetWide(100)
    self.RefreshBtn.DoClick = function()
        self:PopulateHooks()
    end
    
    self:PopulateHooks()
end

function PANEL:PopulateHooks()
    self.HookList:Clear()
    
    for h, hooks in pairs(hook.GetTable()) do
        for id, func in pairs(hooks) do
            local info = debug.getinfo(func, 'S')
            local path = (info.source or ""):gsub("^@", "")
            local line = self.HookList:AddLine("", h, id, path)
            line:SetChecked(true)
            line.OnChange = function(line, checked)
                if checked then
                    self:EnableHook(h, id)
                else
                    self:DisableHook(h, id)
                end
            end
        end
        
        for id, func in pairs(self.HookMemory[h] or {}) do
            local info = debug.getinfo(func, 'S')
            local path = (info.source or ""):gsub("^@", "")
            local line = self.HookList:AddLine("", h, id, path)
            line:SetChecked(false)
            line.OnChange = function(line, checked)
                if checked then
                    self:EnableHook(h, id)
                else
                    self:DisableHook(h, id)
                end
            end
        end
    end
end

function PANEL:DisableHook(name, id)    
    local hookList = hook.GetTable()[name]
    if not hookList or not hookList[id] then
        Derma_Message("The hook doesn't exist anymore.", "Missing Hook")
        return
    end
    
    self.HookMemory[name] = self.HookMemory[name] or {}
    self.HookMemory[name][id] = hookList[id]
    hook.Remove(name, id)
end

function PANEL:EnableHook(name, id)
    local hookList = hook.GetTable()[name]
    if hookList and hookList[id] then
        hookList[id] = nil
        Derma_Message("The hook was recreated.", "Hook Recreated")
        return
    end
    
    if not self.HookMemory[name] or not self.HookMemory[name][id] then
        Derma_Message("The hook was never saved.", "Error")
        return
    end
    
    local f = self.HookMemory[name][id]
    hook.Add(name, id, f)
    self.HookMemory[name][id] = nil
end

function PANEL:PerformLayout()
    self.BaseClass.PerformLayout(self)
    
    local wide = self:GetWide()
    local tall = self:GetTall()
    
    self.HookList:StretchToParent(8, 28, 8, 36)
    
    self.RefreshBtn:SetPos(7, tall - self.RefreshBtn:GetTall() - 7)
end

vgui.Register("SaitoHUDHookManager", PANEL, "DFrame")

------------------------------------------------------------

function SaitoHUD.OpenHookManager()
    local frame = vgui.Create("SaitoHUDHookManager")
    frame:Center()
    frame:MakePopup()
end

concommand.Add("hook_manager", function()
    SaitoHUD.OpenHookManager()
end)