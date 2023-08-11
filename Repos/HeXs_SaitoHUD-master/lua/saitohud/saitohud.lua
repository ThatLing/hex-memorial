-- SaitoHUD

local ignoreHooks = CreateClientConVar("saitohud_ignore_hooks", "0", false, false)

--- Checks whether the anti-unfair mode is triggered.
function SaitoHUD.AntiUnfairTriggered()
	--[[
    if GAMEMODE == nil or type(GAMEMODE) ~= 'table' then return false end
    if (LocalPlayer().IsAdmin and LocalPlayer():IsAdmin()) or 
       (LocalPlayer().IsSuperAdmin and LocalPlayer():IsSuperAdmin()) then
       return false
    end
    local name = tostring(GAMEMODE.Name)
    local folder = tostring(GAMEMODE.Folder)
    return __SaitoHUDUnfair == true and 
        string.find(name:lower(), "sandbox") == nil and 
        string.find(folder:lower(), "sandbox") == nil and 
        string.find(folder:lower(), "spaceage") == nil
	]]
	return false --ha
end

--- Returns where hooks are disabled.
function SaitoHUD.ShouldIgnoreHook()
    return ignoreHooks:GetBool()
end

--- Gets a player trace. This function should be used in case a SaitoHUD component
-- changes the origin of the player's camera.
-- @return Trace result
function SaitoHUD.GetRefTrace()
    return util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
end

--- Gets a player's reference location. This function should be used in case a
-- SaitoHUD component changes the origin of the player's camera.
function SaitoHUD.GetRefPos()
    return LocalPlayer():GetPos()
end

--- Returns a Player object by name, or nil if nothing be found.
-- @param testName Name of player to match
-- @return Player object
function SaitoHUD.MatchPlayerString(testName)
    local possibleMatch = nil
    testName = testName:lower()
    
    for _, ply in pairs(player.GetAll()) do
        local name = ply:GetName()
        
        if name:lower() == testName:lower() then
            return ply
        else
            if name:lower():find(testName, 1, true) then
                possibleMatch = ply
            end
        end
    end
    
    if possibleMatch then
        return possibleMatch
    else
        return nil
    end
end

--- Used to get the entity information text.
-- @return Text
function SaitoHUD.GetEntityInfoLines(showPlayerInfo,showEntityInfo)
    local tr = SaitoHUD.GetRefTrace()
    
    local lines = {}
    
    if IsValid(tr.Entity) then
        local Col = tr.Entity:GetColor();
        lines = {}
        
        if showEntityInfo then
            local skin = tr.Entity:GetSkin()
            table.Add(lines,{
                "#" .. tostring(tr.Entity:EntIndex()) .. " [" .. tostring(tr.HitPos:Distance(SaitoHUD.GetRefPos())) .. "]",
                "Current Pos: " .. tostring(SaitoHUD.GetRefPos()),
                "Hit Pos: " .. tostring(tr.HitPos),
                "Class: " .. tostring(tr.Entity:GetClass()),
                "Position: " .. tostring(tr.Entity:GetPos()),
                "Size: " .. tostring(tr.Entity:OBBMaxs()-tr.Entity:OBBMins()),
                "Angle: " .. tostring(tr.Entity:GetAngles()),
                "Color: " .. string.format("%s %s %s %s", Col.r, Col.g, Col.b, Col.a),
                "Model: " .. tostring(tr.Entity:GetModel()),
                "Material: " .. tostring(tr.Entity:GetMaterial()) .. 
                    " (skin: " .. (skin and tostring(skin) or "N/A") .. ")",
                "Velocity: " .. tostring(tr.Entity:GetVelocity()),
                "Speed: " .. tostring(tr.Entity:GetVelocity():Length()),
                "Local: " .. tostring(tr.Entity:WorldToLocal(tr.HitPos)),
            })
        end
        
        if not SaitoHUD.AntiUnfairTriggered() and 
            showPlayerInfo and tr.Entity:IsPlayer() then
            if showEntityInfo then
                table.insert(lines, "")
            else
                table.insert(lines, "#" .. tostring(tr.Entity:EntIndex()) .. " [" .. tostring(tr.HitPos:Distance(LocalPlayer():GetPos())) .. "]")
            end
            
            table.Add(lines, {
                "Name: " .. tostring(tr.Entity:Name()),
                "SteamID: " .. tostring(tr.Entity:SteamID()),
                "Ping: " .. tostring(tr.Entity:Ping()),
                "Health: " .. tostring(tr.Entity:Health()),
                "Armor: " .. tostring(tr.Entity:Armor()),
                "Weapon: " .. tostring(tr.Entity:GetActiveWeapon()),
                "Kills: " .. tostring(tr.Entity:Frags()),
                "Deaths: " .. tostring(tr.Entity:Deaths()),
            })
        end
    else
        if tr.Hit and showEntityInfo then
            lines = {
                "[" .. tostring(tr.HitPos:Distance(LocalPlayer():GetPos())) .. "]",
                "Current Pos: " .. tostring(SaitoHUD.GetRefPos()),
                "Hit Pos: " .. tostring(tr.HitPos),
            }
        end
    end
    
    return lines
end

--- Dumps the entity information printout to console.
function SaitoHUD.DumpEntityInfo()
    local lines = SaitoHUD.GetEntityInfoLines(true, true)
    
    if table.Count(lines) > 0 then
        for _, s in pairs(lines) do
            Msg(s .. "\n")
        end
    end
end

--- Shows a hint.
-- @param msg Message
-- @param t Number of seconds, 10 by default
-- @param c Type of message, NOTIFY_GENERIC by default
function SaitoHUD.ShowHint(msg, t, c)
    if not t then t = 10 end
    if not c then c = NOTIFY_GENERIC end
    GAMEMODE:AddNotify(msg, c, t);
    surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
end

--- Opens the help window.
function SaitoHUD.OpenHelp()
    if SaitoHUD.HelpWindow and SaitoHUD.HelpWindow:IsValid() then
        return
    end
    
    local contents = ""
    
	--[[
    if file.Exists("../addons/SaitoHUD/docs.txt") then --why!? what's wrong with the data folder!
        contents = file.Read("../addons/SaitoHUD/docs.txt")
    else
        Error("addons/SaitoHUD/docs.txt doesn't exist\n")
    end
	]]
	if file.Exists("SaitoHUD/docs.txt", "DATA") then
        contents = file.Read("SaitoHUD/docs.txt", "DATA")
    else
        Error("SaitoHUD/docs.txt doesn't exist\n")
    end
    
    local frame = vgui.Create("DFrame")
    SaitoHUD.HelpWindow = frame
    frame:SetTitle("SaitoHUD Help")
    frame:SetDeleteOnClose(true)
    frame:SetScreenLock(true)
    frame:SetSize(math.min(780, ScrW() - 0), ScrH() * 4/5)
    frame:SetSizable(true)
    frame:Center()
    frame:MakePopup()
    
    local browser = vgui.Create("HTML", frame)
    browser:SetVerticalScrollbarEnabled(false)
    browser:SetHTML(contents)

    -- Layout
    local oldPerform = frame.PerformLayout
    frame.PerformLayout = function()
        oldPerform(frame)
        browser:StretchToParent(10, 28, 10, 10)
    end
    
    frame:InvalidateLayout(true, true)
end

concommand.Add("saitohud_help", function() SaitoHUD.OpenHelp() end)


__SaitoHUDUnfair = false --ha









