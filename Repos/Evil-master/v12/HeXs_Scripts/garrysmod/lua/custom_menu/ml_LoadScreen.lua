

local pnlLoadProgress = vgui.RegisterFile("custom_menu/original_loading/progress.lua")
local pnlDownloads = vgui.RegisterFile("custom_menu/original_loading/downloads.lua")

local PANEL = {}

function PANEL:Init()
	self:SetVisible(false)
	self.Progress = vgui.CreateFromTable(pnlLoadProgress, self)
	self.Downloads = vgui.CreateFromTable(pnlDownloads, self)
	
	/*
	self.Button = vgui.Create("DButton", self)
		self.Button:SetText("#Cancel")
	function self.Button:DoClick() CancelLoading() end
	*/
end


function PANEL:PerformLayout()
	local Width,Hight = ScrW(),ScrH()
	
	self:SetSize(Width,Hight)
	
	self.Progress:InvalidateLayout(true)
	self.Progress:SetPos(0, Hight * 0.4)
	
	self.Downloads:SetPos(0, 0)
	self.Downloads:SetSize(Width, Hight * 0.4)
	
	/*
	self.Button:AlignRight(50)
	self.Button:AlignBottom(50)
	*/
end

function PANEL:Paint()
	surface.SetDrawColor(250, 250, 250, 255)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end


function PANEL:StatusChanged(what)
	// If it's a file download we do some different stuff..
	if what:find("Downloading ") then
		local name = what:gsub("Downloading ", "")
		
		self.Progress:DownloadingFile(name)
		self.Downloads:DownloadingFile(name)
		return
	end
	
	self.Progress:StatusChanged(what)
	self.Downloads:StatusChanged(what)
end


function PANEL:CheckForStatusChanges()
	local str = GetLoadStatus()
	if (!str) then return end
	
	str = string.Trim(str)
	str = string.Trim(str, "\n")
	str = string.Trim(str, "\t")
	
	str = string.gsub(str, ".bz2", "")
	str = string.gsub(str, ".ztmp", "")
	str = string.gsub(str, "\\", "/")
	
	if (self.OldStatus && self.OldStatus == str) then return end
	
	self.OldStatus = str
	self:StatusChanged(str)
end


function PANEL:OnActivate()
	self:OnDeactivate()
end

function PANEL:OnDeactivate()
	self.Progress:Clean()
	self.Downloads:Clean()
end


function PANEL:Think()
	self:CheckForStatusChanges()
end

local load_panel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "EditablePanel"))

local LoadTime = SysTime()

hook.Add("OnLoadingStarted", "PopupLoad", function(ip, connectionPort, queryPort)
	load_panel:MakePopup() // This isn't done by default in the C++, but the panel is automatically hidden when the loading is finished
	LoadTime = SysTime()
end)

local hide = false

hook.Add("OnLoadingStopped", "EndLoad", function(bool1, string1, string2)
	print(Format("Load time: %f", SysTime() - LoadTime))
	hide = bool1
end)

hook.Add("OnDisconnectFromServer", "GOAWAY", function(enum)
	if hide then
		load_panel:SetVisible(false)
	end
end)

loading.SetPanelOverride(load_panel)


