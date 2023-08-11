require( "downloadfilter" )

local AvailableFilters = { "dua", "bsp", "wav", "ogg", "mp3", "txt", "mdl", "phy", "vtx", "vvd", "vtf", "vmt", "vcs", "ini", "jpg", "ani", "ttf"}
local ActiveFilters = {}

if file.Exists( "downloadfilter/filters.txt" ) then
	ActiveFilters = glon.decode( file.Read( "downloadfilter/filters.txt" ) )
end

local PANEL = {}

surface.CreateFont( "Tahoma", 17, 1000, true, false, "LargeBold", false )

function PANEL:Init()

	self:Dock( TOP )
	self:DockMargin( 1, 1, 1, 0 )
	self:SetHeight( 32 )
	
	self.alt = false
	
	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( LEFT )
	self.Label:DockMargin( 16, 0, 0, 0 )
	self.Label:SetWidth( 300 )
	self.Label:SetFont( "LargeBold" )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 130 ) )
	
	self.CheckBox = vgui.Create( "DCheckBox", self )
	self.CheckBox:Dock( RIGHT )
	self.CheckBox:SetWidth( 16 )
	self.CheckBox:DockMargin( 10, 8, 10, 8 )
end

function PANEL:Setup( ext, rowid, bool )

	self.alt = math.fmod( rowid, 2 ) == 1
	self.available = true
	self.Label:SetText( ext )
	self.CheckBox:SetValue( bool )
	function self.CheckBox.OnChange( checkbox, val )
		self:UpdateColor()
		ActiveFilters[ ext ] = val
		file.Write( "downloadfilter/filters.txt", glon.encode( ActiveFilters ) )
	end
	self:UpdateColor()
end

function PANEL:PerformLayout()
	self:UpdateColor()
end

function PANEL:UpdateColor()

	self.Label:SetAlpha( 255 )
	self.Label:SetColor( Color( 255, 255, 255, 255 ) )
	
	if ( !self.CheckBox:GetChecked() || !self.available ) then
		self:SetBackgroundColor( Color( 100, 100, 100, 255 ) )	
		self.Label:SetColor( Color( 255, 255, 255, 255 ) )
		self.Label:SetAlpha( 100 )
	elseif ( self.alt ) then
		self:SetBackgroundColor( Color( 163, 163, 163, 255 ) )
	else	
		self:SetBackgroundColor( Color( 185, 185, 185, 255 ) )
	end

end
local pnlRow = vgui.RegisterTable( PANEL, "DPanel" )
local PANEL = {}

function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetPadding( 1 )
	self:DockMargin( 8, 8, 8, 8 )
	
	local label = Label( "Check an extension to allow these file types", self )
	label:Dock( BOTTOM )
	label:SetContentAlignment( 5 )
	label:SetColor( Color( 255, 30, 30 ) )
	local savedval = true
	for k, v in SortedPairs( AvailableFilters ) do
		local row = vgui.CreateFromTable( pnlRow, self )
		self:AddItem( row )
		savedval = ActiveFilters[ v ]
		row:Setup( v, k - 1, savedval )
	end
	
	self:Dock( FILL )
	
end

local pnlDFilter = vgui.RegisterTable( PANEL, "DScrollPanel" )

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
ExtensionsCMD()
local extensionspanel = debug.getupvalues( ExtensionsCMD ).Extensions

local DownloadFilter = vgui.CreateFromTable( pnlDFilter )

if IsValid( extensionspanel ) then --HACK RIGHT INTO THAT BITCH
	extensionspanel.PropertySheet:AddSheet( Localize( "Download Filter" ), DownloadFilter, "gui/silkicons/page" )
	extensionspanel:PerformLayout()
	extensionspanel:SetVisible( false )
	
else --Made just for you garry.
	Derma_Message( "WARNING: Unable to get extensions panel.\nThis may have been caused by an update that removed this functionality.\nPlease check for updates for mod ( \"Advanced Download Filter\" )", "ERROR: No extensions" )
end

hook.Add( "ShouldDownload", "DownloadFilter", function(filename)
	local ShouldDownload = ActiveFilters[ string.GetExtensionFromFilename(filename:gsub(".bz2","")) ]
	if ShouldDownload then
		Msg("[DL] Downloading: "..filename.."\n")
	else
		Msg("[DL] NOT Downloading: "..filename.."\n")
	end
	return ShouldDownload
end)


