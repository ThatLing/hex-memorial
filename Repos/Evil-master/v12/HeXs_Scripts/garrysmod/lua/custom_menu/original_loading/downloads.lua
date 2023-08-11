


local pnlDownloadType = vgui.RegisterFile("download_type.lua")
local pnlRunnerType = vgui.RegisterFile("runner.lua")

PANEL.Base = "Panel"


function PANEL:Init()
	self.lblHeadline = vgui.Create("DLabel", self)
	self.lblHeadline:SetFont("LoadingProgress")
	self.lblHeadline:SetContentAlignment(5)
	
	self.Downloads = {}
	
	self.Downloads["other"] 	= self:DownloadType("Garbage", 		"gui/silkicons/box", 		25)
	self.Downloads["lua"] 		= self:DownloadType("Datapack", 	"gui/silkicons/page", 		30)
	self.Downloads["textures"] 	= self:DownloadType("Materials", 	"gui/silkicons/palette", 	40)
	self.Downloads["models"] 	= self:DownloadType("Models", 		"gui/silkicons/brick_add", 	50)
	self.Downloads["maps"] 		= self:DownloadType("Map", 			"gui/silkicons/world", 		60)
	self.Downloads["sounds"] 	= self:DownloadType("Sounds", 		"gui/silkicons/sound", 		35)
	self.Downloads["text"] 		= self:DownloadType("Text", 		"gui/silkicons/table_edit", 30)
end


function PANEL:DownloadType(strName, strTexture, speed)
	local ctrl = vgui.CreateFromTable(pnlDownloadType, self)
		ctrl:SetText(strName)
		ctrl:SetIcon(strTexture)
		ctrl:SetSpeed(speed)
	return ctrl
end


function PANEL:PerformLayout()
	self.lblHeadline:SetPos(0, 20)
	self.lblHeadline:SetSize(ScrW(), 20)
	
	y = 50
	
	for k, panel in pairs(self.Downloads) do
		if (panel:ShouldBeVisible()) then
			panel:SetVisible(true)
			panel:InvalidateLayout(true)
			panel:CenterHorizontal()
			panel.y = y
			y = y + panel:GetTall() + 2
		else
			panel:SetVisible(false)
		end
	end
end


function PANEL:RefreshDownloadables()
	self.Downloadables = GetDownloadables()
	if (!self.Downloadables) then return end
	
	self:ClearDownloads()
	
	local iDownloading = 0
	for k, v in pairs(self.Downloadables) do
		v = v:gsub(".bz2", "")
		v = v:gsub(".ztmp", "")
		v = v:gsub("\\", "/")
		
		iDownloading = iDownloading + self:ClassifyDownload(v)
	end
	
	if (iDownloading == 0) then return end
	
	self.lblHeadline:SetText(Format("%i files needed from server", iDownloading))
	self:InvalidateLayout()
end


function PANEL:ClearDownloads()
	for k, panel in pairs(self.Downloads) do
		panel:Clean()
		panel:SetVisible(false)
	end
end


function PANEL:ClassifyDownload(filename)
	local ctrl = self.Downloads["other"]
	
	if filename:find(".dua") then
		ctrl = self.Downloads["lua"]
		
	elseif (filename:find(".vtf") or filename:find(".vmt")) then
		ctrl = self.Downloads["textures"]
		
	elseif (filename:find("models/") or filename:find("models\\") or filename:find(".mdl")) then
		ctrl = self.Downloads["models"]
		
	elseif (filename:find("sound/") or filename:find("sound\\") or filename:find(".wav") or filename:find(".mp3")) then
		ctrl = self.Downloads["sounds"]
		
	elseif (filename:find(".bsp")) then
		ctrl = self.Downloads["maps"]
		
	elseif (filename:find(".txt")) then
		ctrl = self.Downloads["text"]
	end
	
	return ctrl:AddFile(filename)
end


function PANEL:CheckDownloadTables()
	local NumDownloadables = NumDownloadables()
	if (!NumDownloadables) then return end
	
	if (!self.NumDownloadables or NumDownloadables != self.NumDownloadables) then
		self.NumDownloadables = NumDownloadables
		self:RefreshDownloadables()
	end
end


function PANEL:Clean()
	self.NumDownloadables = nil
	self.Downloadables = nil
	self.FilesToDownload = nil
	
	self:ClearDownloads()
	
	self.lblHeadline:SetText("")
end



function PANEL:CurrentDownloadFinished()
	if (!self.strCurrentDownload) then return end
	
	for k, panel in pairs(self.Downloads) do
		panel:Downloaded(self.strCurrentDownload)
	end
	
	if (self.CurrentRunner) then
		if (self.CurrentRunner:IsValid()) then
			self.CurrentRunner:SetRepeat(false)
		end
		self.CurrentRunner = nil
	end
	
	self.strCurrentDownload = nil
end


function PANEL:DownloadingFile(filename)
	self:CheckDownloadTables()
	self:CurrentDownloadFinished()
	self.strCurrentDownload = filename
	
	if (self.CurrentRunner) then
		if (self.CurrentRunner:IsValid()) then
			self.CurrentRunner:SetRepeat(false)
		end
		self.CurrentRunner = nil
	end
	
	for k, panel in pairs(self.Downloads) do
		self.CurrentRunner = panel:MakeRunner(self.strCurrentDownload)
		if (self.CurrentRunner) then
			self.CurrentRunner:SetRepeat(true)
			break
		end
	end
end


function PANEL:StatusChanged(strNewStatus)
	self:CurrentDownloadFinished()
	self:CheckDownloadTables()
end


function PANEL:AddRunner(icon, speed)
	local Runner = vgui.CreateFromTable(pnlRunnerType, self)
		Runner:SetUp(icon, speed)
	return Runner
end

