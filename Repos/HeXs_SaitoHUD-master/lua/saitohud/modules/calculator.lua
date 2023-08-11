-- SaitoHUD
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
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

--- Calculator functions.

------------------------------------------------------------
-- SaitoHUDCalculator
------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self.LastAnswer = 0
    self.Buffer = {}
    self.BufferIndex = 0
    self.Env = {}
    
    self:SetTitle("SaitoHUD Calculator")
    self:SetSizable(true)
    self:SetSize(250, 300)
    self:ShowCloseButton(true)
    self:SetDraggable(true)
    self:SetScreenLock(true)
    
    -- Make list view
    self.Log = vgui.Create("DPanelList", self)
    self.Log:SetPadding(3)
    self.Log:SetSpacing(3)
    self.Log:SetBottomUp(true)
    self.Log:EnableVerticalScrollbar(true)
    self.Log.Paint = function(self)
        draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(),
                        color_white)
    end
    
    local operators = {"*", "+", "-", "/", "%"}
    
    self.InputEntry = vgui.Create("DTextEntry", self)
    self.InputEntry:SetText("")
    self.InputEntry:SizeToContents()
    self.InputEntry:RequestFocus()
    self.InputEntry.OnTextChanged = function(panel, text)
        local val = panel:GetValue()
        if string.len(val) == 1 and table.HasValue(operators, val) then
            panel:SetText("ans" .. val)
            panel:SetCaretPos(4)
        end
    end
    self.InputEntry.OnKeyCodeTyped = function(panel, code)
        if code == KEY_ENTER and not panel:IsMultiline() and panel:GetEnterAllowed() then
            panel:FocusNext()
            panel:OnEnter()
        end
        
        if #self.Buffer == 0 then return end
        
        if code == KEY_UP then
            self.BufferIndex = self.BufferIndex - 1
            if self.BufferIndex < 1 then
                self.BufferIndex = #self.Buffer
            end
            
            local val = self.Buffer[self.BufferIndex]
            panel:SetText(val)
            panel:SetCaretPos(string.len(val))
        elseif code == KEY_DOWN then
            self.BufferIndex = self.BufferIndex + 1
            if self.BufferIndex > #self.Buffer then
                self.BufferIndex = 1
            end
            
            local val = self.Buffer[self.BufferIndex]
            panel:SetText(val)
            panel:SetCaretPos(string.len(val))
        end
    end
    self.InputEntry.OnEnter = function()
        self:OnEnter()
    end
    
    self.CalcBtn = vgui.Create("DButton", self)
    self.CalcBtn:SetText(">")
    self.CalcBtn:SetWide(20)
    self.CalcBtn.DoClick = function()
        self:OnEnter()
    end
    self.CalcBtn:SetTall(self.InputEntry:GetTall())
    
    self:AddIntro()
    
    self:SetPos(10, ScrH() - self:GetTall() - 10)
end

function PANEL:OnEnter()
    local text = self.InputEntry:GetValue():Trim()
    
    -- Clear
    if text == "clear" then
        self.Env = {}
        self.Log:Clear()
        self:AddIntro()
    
    -- Clear memory
    elseif text == "clearmem" then
        self:AddInfo({"Memory cleared of " .. table.Count(self.Env) .. " variables"})
        self.Env = {}
    
    -- List variables
    elseif text == "listmem" then
        local lines = {}
        for k, v in pairs(self.Env) do
            table.insert(lines, k .. " = " .. v)
        end
        self:AddInfo(lines)
    
    -- Copy
    elseif text == "copy" then
        SetClipboardText(tostring(self.LastAnswer))
        self.InputEntry:SetText("")
        self:Close()
        return
    
    -- Quit + copy
    elseif text == "qc" then
        SetClipboardText(tostring(self.LastAnswer))
        self.InputEntry:SetText("")
        self:Close()
        return
    
    -- Quit
    elseif text == "q" then
        self.InputEntry:SetText("")
        self:Close()
        return
    
    -- Help
    elseif text == "?" or text == "help" then
        self:AddIntro()
    
    -- Evaluate
    elseif text ~= "" then
        self:Evaluate(text)
    
    -- Previous evaluation
    elseif text == "" and #self.Buffer > 0 then
        self:Evaluate(self.Buffer[#self.Buffer])
    end

    self.InputEntry:SetText("")
    self.InputEntry:RequestFocus()
end

function PANEL:AddEvaluation(input, output, isErr)
    local line = vgui.Create("SaitoHUDCalculatorLine", self)
    line:Setup(input, output, isErr)
    self.Log:AddItem(line)
end

function PANEL:Evaluate(expr)    
    local ret, val, env = SaitoHUD.CalcExpr(expr, self.Env)
    self:AddEvaluation(expr, tostring(val), not ret)
    if ret then       
        self.LastAnswer = val
        self.Env = env
        self.Env.ans = self.LastAnswer
    end
    
    -- Remove from buffer
    for k, v in pairs(self.Buffer) do
        if v == expr then
            table.remove(self.Buffer, k)
            break
        end
    end
    
    -- Add to buffer
    table.insert(self.Buffer, expr)
    while #self.Buffer > 40 do
        table.remove(self.Buffer, 1)
    end
    
    self.BufferIndex = #self.Buffer + 1
end

function PANEL:AddIntro()
    self:AddInfo({
        "clear - Clear the log and memory",
        "clearmem - Clear the memory",
        "listmem - List the variables",
        "q - Close",
        "qc - Close and copy to clipboard",
        "copy - Copy to clipboard",
    })
end

function PANEL:AddInfo(lines)
    local panel = vgui.Create("SaitoHUDCalculatorInfo", self)
    panel:Setup(lines)
    self.Log:AddItem(panel)
end

function PANEL:PerformLayout()
    DFrame.PerformLayout(self)
    
    local wide = self:GetWide()
    local tall = self:GetTall()
    
    self.Log:StretchToParent(6, 26, 6, 33)
    
    self.InputEntry:SetPos(6, tall - self.CalcBtn:GetTall() - 6)
    self.InputEntry:SetWide(wide - self.CalcBtn:GetWide() - 15)
    
    self.CalcBtn:SetPos(wide - self.CalcBtn:GetWide() - 6,
                        tall - self.CalcBtn:GetTall() - 6)
end

vgui.Register("SaitoHUDCalculator", PANEL, "DFrame")

------------------------------------------------------------
-- SaitoHUDCalculatorTextEntry
------------------------------------------------------------

local PANEL = {}

function PANEL:Paint(panel)
    self:DrawTextEntryText(self.m_colText, self.m_colHighlight, self.m_colCursor)
end

function PANEL:ApplySchemeSettings()
    self:SetTextColor(self.IsError and Color(200, 0, 0, 255) or Color(0, 0, 0, 255))
    self:SetHighlightColor(Color(100, 100, 100, 255))
    self:SetCursorColor(Color(0, 0, 0, 255))
end

vgui.Register("SaitoHUDCalculatorTextEntry", PANEL, "DTextEntry")

------------------------------------------------------------
-- SaitoHUDCalculatorLine
------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    self.CreateTime = CurTime()
end

function PANEL:Setup(input, output, isErr)    
    self.Input = vgui.Create("SaitoHUDCalculatorTextEntry", self)
    self.Input:SetPos(3, 2)
    self.Input:SetText(input)
    self.Input:SizeToContents()
    
    self.Output = vgui.Create("SaitoHUDCalculatorTextEntry", self)
    self.Output:SetText(output)
    self.Output:SizeToContents()
    self.Output.IsError = isErr
    
    self:SetTall(self.Input:GetTall() + self.Output:GetTall() + 5)
    
    self.RemoveBtn = vgui.Create("DButton", self)
    self.RemoveBtn:SetSize(6, self:GetTall())
    self.RemoveBtn:SetText("")
    self.RemoveBtn:SetTooltip("Remove this line.")
    self.RemoveBtn.DoClick = function()
        self:Remove()
        self:GetParent():InvalidateLayout()
    end
end

function PANEL:Paint()
    local elapsed = CurTime() - self.CreateTime
    local c = math.max(200, (0.7 - elapsed / 0.7) * 55 + 200)
    
    draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(),
                    Color(200, 200, c, 255))
    draw.RoundedBox(0, 1, self:GetTall() / 2,
                    self:GetWide() - 2, self:GetTall() / 2 - 2,
                    color_white)
end

function PANEL:PerformLayout()
    local wide = self:GetWide()
    
    self.RemoveBtn:SetPos(wide - self.RemoveBtn:GetWide(), 0)
    self.Output:SetPos(3, self.Input:GetTall() + 3)
    self.Input:SetWide(wide - 8)
    self.Output:SetWide(wide - 8)
end

vgui.Register("SaitoHUDCalculatorLine", PANEL, "DPanel")

------------------------------------------------------------
-- SaitoHUDCalculatorInfo
------------------------------------------------------------

local PANEL = {}

function PANEL:Setup(lines)
    local height = #lines * 14.5
    
    self.Label = vgui.Create("SaitoHUDCalculatorTextEntry", self)
    self.Label:SetPos(3, 3)
    self.Label:SetText(table.concat(lines, "\n"))
    self.Label:SetWide(200)
    self.Label:SetMultiline(true)
    self.Label:SetTall(height)
    
    self:SetTall(height + 6)
    
    self.RemoveBtn = vgui.Create("DButton", self)
    self.RemoveBtn:SetSize(6, self:GetTall())
    self.RemoveBtn:SetText("")
    self.RemoveBtn:SetTooltip("Remove this line.")
    self.RemoveBtn.DoClick = function()
        self:Remove()
        self:GetParent():InvalidateLayout()
    end
end

function PANEL:Paint()
    draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(),
                    Color(200, 200, 255, 255))
end

function PANEL:PerformLayout()
    local wide = self:GetWide()
    
    if self.Label then
        self.Label:SetWide(wide - 6)
        self.RemoveBtn:SetPos(wide - self.RemoveBtn:GetWide(), 0)
    end
end

vgui.Register("SaitoHUDCalculatorInfo", PANEL, "DPanel")

------------------------------------------------------------

local function SetError(f, err)
    setfenv(f, { _err = err })
    error("Exception occurred")
    -- Cannot use Error()!
end

local function MakeHook(f, maxLines, recursionLimit, maxTime)
    local lines = 0
    local calls = 0
    local start = 0

    return function(evt)
        if start == 0 then start = os.clock() end
        if os.clock() - start > maxTime then SetError(f, "Time limit hit") end
        if evt == "line" then
            lines = lines + 1
            if lines > maxLines then SetError(f, "Line limit hit") end
        elseif evt == "call" then
            calls = calls + 1
            if calls > recursionLimit then SetError(f, "Recursion limit hit") end
        elseif evt == "return" then
            calls = calls - 1
        end
    end
end

--- Calculates a mathematical expression securely.
-- @param str Expression
-- @return Success or not
-- @return Error message or result
function SaitoHUD.CalcExpr(str, vars)
    local setVar = "_result"
    local code = "_result = " .. str
    
    -- Detect attempts at setting a variable
    local m = string.match(str, "^([A-Za-z_][A-Za-z0-9_]*) *=")
    if m then
        setVar = m
        code = str
    end
    
    -- Compile code; note that the error is caught in the current version
    -- of Gmod (it's a bug)
    local ret, err = pcall(CompileString, code, "calc")
    if not ret or type(err) ~= 'function' then
        return false, "Parsing error"
    end
    
    local f = err
    local missingVars = {}
    local missingVarsIndex = {}
    
    -- Build the environment
    local env = {
        abs = math.abs,
        acos = math.acos,
        asin = math.asin,
        atan = math.atan,
        ceil = math.ceil,
        cos = math.cos,
        cosh = math.cosh,
        deg = math.deg,
        exp = math.exp,
        floor = math.floor,
        fmod = math.fmod,
        ln = math.log,
        log = math.log,
        log10 = math.log10,
        max = math.max,
        min = math.min,
        pow = math.pow,
        rad = math.rad,
        rand = math.random,
        sin = math.sin,
        sinh = math.sinh,
        sqrt = math.sqrt,
        tanh = math.tanh,
        tan = math.tan,
        
        pi = math.pi,
        inf = math.huge,
        e = 2.718281828459,
        gr = 1.618033988749,
    }
    
    setmetatable(env, {
        __index = function(t, k)
            if not missingVarsIndex[k] then
                table.insert(missingVars, k)
                missingVarsIndex[k] = true
            end
            return 0
        end,
    })
    
    -- Keep track of the standard environment so we can get rid of it
    local stdEnvKeys = {}
    for k, v in pairs(env) do
        stdEnvKeys[k] = true
    end
    
    -- Add in the provided environment
    if vars then
        for k, v in pairs(vars) do
            env[k] = v
        end
    end
    
    setfenv(f, env)
    
    -- Workaround for coroutine issues
    for i = 1, 3 do
        -- Run in a coroutine so we can set a runtime checks
        local co = coroutine.create(f)
        debug.sethook(co, MakeHook(f, 100, 5, 0.1), "crl")
        local ret, succ, err = pcall(coroutine.resume, co) -- Gmod has issues
        
        if ret then
            -- Check for missing variables
            if #missingVars == 1 then
                return false, string.format("'%s' is undefined", missingVars[1])
            elseif #missingVars > 1 then
                return false, string.format("%s are undefined",
                    table.concat(missingVars, ", "))
            elseif succ then
                local retEnv = getfenv(f)
                local cleaned = {}
                
                for k, v in pairs(retEnv) do
                    if not stdEnvKeys[k] and k ~= "_result" then
                        if type(v) ~= 'function' and type(v) ~= 'number' then
                            v = 0
                        end
                        cleaned[k] = v
                    end
                end
                
                return true, tonumber(retEnv[setVar]) or 0, cleaned
            else
                local exceptionError = getfenv(f)._err
                if exceptionError == 0 then exceptionError = nil end
                return false, exceptionError or err
            end
        end
    end
    
    -- Failure
    return false, "Internal error 1"
end

------------------------------------------------------------

concommand.Add("calculator", function()
    if g_SaitoHUDCalculator and g_SaitoHUDCalculator:IsValid() then
        local frame = g_SaitoHUDCalculator
        -- Reload protection
        if frame.SaitoHUDRef ~= SaitoHUD then
            frame:Remove()
        else
            frame:SetVisible(true)
            frame.InputEntry:RequestFocus()
            return
        end
    end
    
    local frame = vgui.Create("SaitoHUDCalculator")
    frame:GetDeleteOnClose(false)
    frame:MakePopup()
    frame.SaitoHUDRef = SaitoHUD
    frame.Close = function()
        frame:SetVisible(false)
    end
    g_SaitoHUDCalculator = frame
    
end)