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

AccessorFunc(PANEL, "LineClass", "LineClass")

function PANEL:Init()
    --self.BaseClass.Init(self)
end

function PANEL:AddLine(...)
    self:SetDirty(true)
    self:InvalidateLayout()

    local line = vgui.Create(self.LineClass or "DListView_Line", self.pnlCanvas)
    local id = table.insert(self.Lines, line)

    line:SetListView(self) 
    line:SetID(id)

    for k, v in pairs(self.Columns) do
        line:SetColumnText(k, "")
    end

    for k, v in pairs({...}) do
        line:SetColumnText(k, v)
    end

    local SortID = table.insert(self.Sorted, line)

    if SortID % 2 == 1 then
        line:SetAltLine(true)
    end

    return line
end

vgui.Register("DCustomListView", PANEL, "DListView")