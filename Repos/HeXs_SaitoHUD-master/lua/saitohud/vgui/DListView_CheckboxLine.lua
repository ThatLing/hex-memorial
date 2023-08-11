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

local PANEL = {}

function PANEL:Init()
    self.BaseClass.Init(self)
    
    self.Check = vgui.Create("DCheckBox", self)
    self.Check:SetSize(14, 14)
    self.Check.OnChange = function()
        self:SetColumnText(1, self.Check:GetChecked() and "1" or "")
        self:OnChange(self.Check:GetChecked())
    end
end

function PANEL:OnChange(checked)
end

function PANEL:SetChecked(checked)
    self.Check:SetValue(checked)
end

function PANEL:GetChecked()
    return self.Check:GetChecked()
end

function PANEL:DataLayout(listView)
    self:ApplySchemeSettings()

    local height = self:GetTall()
    
    local x = 0
    for k, column in pairs(self.Columns) do
        if k == 1 then
            column:SetVisible(false)
        end
        
        local w = listView:ColumnWidth(k)
        column:SetPos(x, 0)
        column:SetSize(w, height)
        if k == 1 then
            self.Check:SetPos(x + (w - self.Check:GetWide()) / 2,
                              (height - self.Check:GetTall()) / 2)
        end
        x = x + w
    end
end

vgui.Register("DListView_CheckboxLine", PANEL, "DListView_Line")