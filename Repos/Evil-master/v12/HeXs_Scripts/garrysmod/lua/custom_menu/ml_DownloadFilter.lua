
require("downloadfilter")
--[[
local fuckyou = {
	"weapon",
	"mw3",
}

hook.Add("ShouldDownload", "DownloadFilter", function(filename)
    local ext = string.GetExtensionFromFilename(filename)
	
	for k,v in pairs(fuckyou) do
		if filename:lower():find(v) then
			return false
		end
	end
	
    if ((ext != "bsp") && (ext != "dua")) then
        return false
    end
end)

if hook then return end
]]

local AvailableFilters = { --Add more filters here
	["Datapack"] = {"dua"},
	["Map Files"] = {"bsp", "ain", "nav", "res"},
	["Sound Files"] = {"wav", "ogg", "mp3"},
	["Model Files"] = {"mdl", "phy", "vtx", "vvd", "dx90.vtx", "dx80.vtx", "sw.vtx"},
	["Texture Files"] = {"vtf", "vmt"},
	["Text Files"] = {"txt", "ini", "cfg"},
	["Particle Files"] = {"pcf"},
	["Crap"] = {"vcs", "ani", "jpg", "psd", "db"},
}

local ActiveFilters = {}

for _,types in pairs( AvailableFilters ) do
	for _,filetype in pairs( types ) do
		ActiveFilters[ filetype ] = true -- Default all settings to be enabled
	end
end

if file.Exists( "downloadfilter/filters.txt" ) then
	for filetype,val in pairs( glon.decode( file.Read( "downloadfilter/filters.txt" ) ) ) do
		ActiveFilters[ filetype ] = val -- Load our saved settings
	end
end

local function IsCategoryFullyChecked( cat ) -- Is everything in a category checked
	local num = 0
	for _,filetype in pairs( AvailableFilters[ cat ] ) do
		if ActiveFilters[ filetype ] then
			num = num + 1
		end
	end
	return num >= #AvailableFilters[ cat ]
end


concommand.Add("downloadfilter_dump", function()
	PrintTable( ActiveFilters )
end)



local function CreateCollapsibleCategory( cat, rownum ) -- Making a custom vgui element derived from the CollapsibleCategory failed.. :\
	local CollapsibleCategory = vgui.Create( "DCollapsibleCategory" )
	CollapsibleCategory:SetHeight( 32 )
	CollapsibleCategory:SetLabel( cat )
	CollapsibleCategory:SetExpanded( tobool( cookie.GetNumber( "DLFilter:"..cat ) ) ) -- Load cookies
	
	CollapsibleCategory.OriginalLayout = CollapsibleCategory.PerformLayout
	CollapsibleCategory.OriginalToggle = CollapsibleCategory.Toggle
	
	CollapsibleCategory.DrawColor = Color( 185, 185, 185, 255 )

	CollapsibleCategory.alt = math.fmod( rownum, 2 ) == 1
	
	function CollapsibleCategory:Paint()
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), self.DrawColor )
	end
	
	function CollapsibleCategory:Toggle() -- Hook into the toggle call, use to save cookies :D
		self:OriginalToggle()
		cookie.Set( "DLFilter:"..cat, ( self:GetExpanded() and 1 or 0 ) )
	end
	
	local CategoryList = vgui.Create( "DPanelList", CollapsibleCategory )
	CategoryList:SetAutoSize( true )
	CategoryList:SetSpacing( 5 )
	CategoryList:EnableHorizontal( false )
	CategoryList:EnableVerticalScrollbar( true )
	
	CollapsibleCategory:SetContents( CategoryList )
	
	CollapsibleCategory.CheckBoxes = {}
	
	CollapsibleCategory.MainCheckBox = vgui.Create( "DCheckBox", CollapsibleCategory )
	CollapsibleCategory.MainCheckBox:SetPos( 0, 4 )
	CollapsibleCategory.MainCheckBox:SetSize( 16, 16 )
	CollapsibleCategory.MainCheckBox:SetValue( IsCategoryFullyChecked( cat ) )
	
	function CollapsibleCategory:UpdateColor()
		if ( !IsCategoryFullyChecked( cat ) ) then
			self.DrawColor = Color( 80, 80, 80, 255 )
		elseif ( self.alt ) then
			self.DrawColor = Color( 103, 103, 103, 255 )
		else   
			self.DrawColor = Color( 125, 125, 125, 255 )
		end
	end
	
	function CollapsibleCategory.MainCheckBox:OnChange( val )
		if !self.IgnoreChange then
			for _,checkbox in pairs( CollapsibleCategory.CheckBoxes ) do
				checkbox:SetValue( val )
			end
			CollapsibleCategory:UpdateColor()
		end
	end
	
	function CollapsibleCategory:AddCheckBox( chktxt, val )
		local CheckBox = vgui.Create( "DCheckBoxLabel", CategoryList )
		CheckBox:SetText( chktxt )
		CheckBox:SetValue( val )
		CheckBox:SizeToContents()
		function CheckBox:OnChange( val )
			ActiveFilters[ chktxt ] = val
			file.Write( "downloadfilter/filters.txt", glon.encode( ActiveFilters ) )
			CollapsibleCategory.MainCheckBox.IgnoreChange = true
			CollapsibleCategory.MainCheckBox:SetValue( IsCategoryFullyChecked( cat ) )
			CollapsibleCategory.MainCheckBox.IgnoreChange = nil
			CollapsibleCategory:UpdateColor()
		end
		CategoryList:AddItem( CheckBox )
		self.CheckBoxes[ chktxt ] = CheckBox
	end
	
	function CollapsibleCategory:PerformLayout()
		self:OriginalLayout()
		self.MainCheckBox:AlignRight( 4 )
	end
	
	CollapsibleCategory:UpdateColor()
	
	return CollapsibleCategory
end

local PANEL = {}

function PANEL:Init()
	self:EnableVerticalScrollbar()
	self:SetPadding( 7 )
	self:SetSpacing( 2 )
	self:DockMargin( 1, 1, 1, 1 )
	
	local label = Label( "Check an extension to allow these file types", self )
	label:Dock( BOTTOM )
	label:SetContentAlignment( 5 )
	label:SetColor( Color( 125, 125, 125, 255 ) )
	local savedval = true
	local rownum = 0
	for category, types in pairs( AvailableFilters ) do
		local row = CreateCollapsibleCategory( category, rownum )
		for _, filetype in pairs( types ) do
			row:AddCheckBox( filetype, ActiveFilters[ filetype ] )
		end
		self:AddItem( row )
		rownum = rownum + 1
	end
	
	self:Dock( FILL )
end

local pnlDFilter = vgui.RegisterTable( PANEL, "DPanelList" )

function debug.getupvalues( f )
	local t, i, k, v = {}, 1, debug.getupvalue( f, 1 )
	while k do
		t[k] = v
		i = i+1
		k,v = debug.getupvalue( f, i )
	end
	return t
end

local ExtensionsCMD = debug.getupvalues( concommand.Run ).CommandList["menu_extensions"]
local extensionspanel = nil

if ExtensionsCMD and type( ExtensionsCMD ) == "function" then
	ExtensionsCMD()
	extensionspanel = debug.getupvalues( ExtensionsCMD ).Extensions
end

if IsValid( extensionspanel ) then -- Failsafe incase garry ever removes the extensions menu
	local DownloadFilter = vgui.CreateFromTable( pnlDFilter )
	-- HACK RIGHT INTO THAT BITCH
	extensionspanel.PropertySheet:AddSheet( Localize( "Download Filter" ), DownloadFilter, "gui/silkicons/page" )
	extensionspanel:PerformLayout()
	extensionspanel:SetVisible( false )
else
	-- Made just for you garry.
	Derma_Message( "WARNING: Unable to get extensions panel.\nThis may have been caused by an update that removed this functionality.\nPlease check for updates for mod ( \"Advanced Download Filter\" )", "ERROR: No extensions" )
end

hook.Add( "ShouldDownload", "DownloadFilter", function( filename )
	filename = filename or "gone"
	
	local ext = string.GetExtensionFromFilename( filename:gsub(".bz2", "") )
	ext = ext:lower()
	
	COLCON(Color( 255, 174, 201 ), "DownloadFilter", Color( 255, 255, 255 ), ": ("..ext..") "..filename)
	
	if ActiveFilters[ ext ] != nil and ActiveFilters[ ext ] == false then -- Shouldnt ever be nil
		COLCON(Color( 255, 174, 201 ), "DownloadFilter BLOCK", Color( 255, 0, 0 ), ": ("..ext..") "..filename)
		
		return false -- Block the download
		
	elseif ActiveFilters[ ext ] == nil or ActiveFilters[ ext ] == true then
		return true -- If the filter for a file doesn't exist or if we are allowing it, download
	end
	
end )












