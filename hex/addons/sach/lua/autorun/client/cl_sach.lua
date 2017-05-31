
----------------------------------------
--         2014-07-12 20:32:51          --
------------------------------------------

MsgN("[SACH] loading")

include("autorun/von.lua")

SACH = {
	color_green 		= Color(158,195,79,255),
	color_offwhite 		= Color(251,236,203,255),
	achievement_info 	= {},
	modules 			= {},
	Debug				= false,
}




surface.CreateFont("Default12B", {
	font		= "Default",
	size 		= 12,
	weight		= 700,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("Default13B", {
	font		= "Default",
	size 		= 13,
	weight		= 700,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("Default14BA", {
	font		= "Default",
	size 		= 14,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)







//Handle popups and panels
local creditpnl
function Creditpnl()
	if ( creditpnl ) then
		creditpnl:Remove()
	end
	
	creditpnl = vgui.Create("DFrame")
		creditpnl:SetWide( 205 )
		creditpnl:SetTitle("Credits")
		creditpnl:MakePopup()
	
	local y = 30

	local infoLabel = vgui.Create("DLabel", creditpnl )
		infoLabel:SetPos( 15, y )
		infoLabel:SetText("Serverside Achievements")
		infoLabel:SetWide( 175 )
	y = y + infoLabel:GetTall()

	y = y + 5
	local infoLabel2 = vgui.Create("DLabel", creditpnl )
		infoLabel2:SetPos( 15, y )
		infoLabel2:SetText("by gmt2001")
		infoLabel2:SetWide( 175 )
	y = y + infoLabel2:GetTall()

	y = y + 5
	local divider = vgui.Create("DLabel", creditpnl )
		divider:SetPos( 15, y )
		divider:SetWide( 175 )
		divider:SetText(" ")
	y = y + divider:GetTall()
	
	local hexmsg = vgui.Create("DLabel", creditpnl )
		hexmsg:SetPos( 15, y )
		hexmsg:SetText("Edited/fixed by HeX")
		hexmsg:SetWide( 175 )
	y = y + hexmsg:GetTall()

	y = y + 5
	local infoLabel3 = vgui.Create("DLabel", creditpnl )
		infoLabel3:SetPos( 15, y )
		infoLabel3:SetText("Clientside Code from")
		infoLabel3:SetWide( 175 )
	y = y + infoLabel3:GetTall()

	y = y + 5
	local infoLabel4 = vgui.Create("DLabel", creditpnl )
		infoLabel4:SetPos( 15, y )
		infoLabel4:SetText( '"Achievements"' )
		infoLabel4:SetWide( 175 )
	y = y + infoLabel4:GetTall()

	y = y + 5
	local infoLabel5 = vgui.Create("DLabel", creditpnl )
		infoLabel5:SetPos( 15, y )
		infoLabel5:SetText("by RabidToaster and G3X")
		infoLabel5:SetWide( 175 )
	y = y + infoLabel5:GetTall()

	y = y + 5
	local close = vgui.Create("DButton", creditpnl )
		close:SetPos( 15, y )
		close:SetWide( 170 )
		close:SetText("OK")
		close.DoClick = function() creditpnl:Remove() end
	y = y + close:GetTall() + 5

	// Make the window the right size, and in the right place.
	y = y + 5
	creditpnl:SetTall( y )
	creditpnl:Center()
end




local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	self.Main = nil
end
function PANEL:SetAchievement( text, image, main )
	self.Main = main
	self.Text = text
	self.Image = image or "achievements/generic"
	
	self.Material = Material( self.Image )
	if ( !self.Material ) then self.Image = nil end
end
function PANEL:SetSlot( slot )
	self.Slot = slot
end
function PANEL:Think()
	self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
	self:InvalidateLayout()

	if (self.Removed) then
		self:Remove()
	end

	if ( self.Direction == 1 && self.Offset == 1 ) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if ( self.Down != nil && CurTime() > self.Down ) then
		self.Direction = -1
		self.Down = nil
	end
	if ( self.Offset == 0 && !self.Removed ) then
		self.Main:ClearSlot( self.Slot )
		self.Removed = true
	end
end
function PANEL:PerformLayout()
	local w, h = 240, 94
	
	self:SetSize( w, h )
	self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	
	surface.SetDrawColor( 47, 49, 45, a )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 104, 106, 101, a )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( 255, 255, 255, a )
	
	if ( self.Image ) then
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		surface.SetDrawColor( 70, 70, 70, a )
		surface.DrawOutlinedRect( 13, 13, 66, 66 )
	end
	
	draw.DrawText("Achievement Unlocked!", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT)
	
	local exp 	= string.Explode(" ", self.Text)
	local tmp 	= {"","",""}
	local line	= 1
	local y		= {
		{55},
		{50,61},
		{44,55,66}
	}
	
	
	for _,v in pairs(exp) do
		if (line < 4) then
			if (tmp[ line ] != "" && string.len( tmp[ line ].." "..v ) <= 24) then
				tmp[ line ] = tmp[ line ].." "..v
			elseif (tmp[ line ] == "") then
				tmp[ line ] = v
			else
				if (line == 3) then
					if (string.len( tmp[ line ] ) + 3 <= 24) then
						tmp[ line ] = tmp[ line ].."..."
					else
						tmp[ line ] = string.sub( tmp[ line ], 0, (24 - 3) )
						tmp[ line ] = tmp[ line ].."..."
					end
				end
				if (line <= 2) then
					tmp[ line + 1 ] = v
				end
				line = line + 1
			end
		end
	end
	
	if (line > 3) then
		line = 3
	end
	
	local i
	for i = 1, line do
		surface.SetFont("Default12B")
		local w2, h2 = surface.GetTextSize( tmp[ i ] )
		draw.DrawText( tmp[ i ] , "Default12B", 88, y[ line ][ i ], Color( 216, 222, 211, a ), TEXT_ALIGN_LEFT )
	end
end

vgui.Register("rt_achievement_popup", PANEL )





local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	self.Progress = "0/0"
	self.Main = nil
end
function PANEL:SetAchievement( text, image, mult, main )
	self.Main = main
	self.Text = text
	self.Image = image or "achievements/bwgeneric"
	
	self.Material = Material( self.Image )
	if ( !self.Material ) then self.Image = nil end

	local progress = SACH.achievement_info[ text ].max / 4
	progress = progress * mult
	progress = math.ceil(progress)
	self.Progress = progress.."/"..SACH.achievement_info[ text ].max
	self.Text = self.Text.." ("..self.Progress..")"
end
function PANEL:SetSlot( slot )
	self.Slot = slot
end
function PANEL:Think()
	self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
	self:InvalidateLayout()

	if (self.Removed) then
		self:Remove()
	end
	
	if ( self.Direction == 1 && self.Offset == 1 ) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if ( self.Down != nil && CurTime() > self.Down ) then
		self.Direction = -1
		self.Down = nil
	end
	if ( self.Offset == 0 && !self.Removed ) then
		self.Main:ClearSlot( self.Slot )
		self.Removed = true
	end
end
function PANEL:PerformLayout()
	local w, h = 240, 94
	
	self:SetSize( w, h )
	self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	
	surface.SetDrawColor( 47, 49, 45, a )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 104, 106, 101, a )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( 255, 255, 255, a )
	
	if ( self.Image ) then
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		surface.SetDrawColor( 70, 70, 70, a )
		surface.DrawOutlinedRect( 13, 13, 66, 66 )
	end
	
	draw.DrawText("Achievement Progress", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT)
	
	local exp 	= string.Explode(" ", self.Text)
	local tmp 	= {"","",""}
	local line 	= 1
	local y 	= {
		{55 },
		{50,61},
		{44,55,66}
	}
	
	for _,v in pairs(exp) do
		if (line < 4) then
			if (tmp[ line ] != "" && string.len( tmp[ line ].." "..v ) <= 24) then
				tmp[ line ] = tmp[ line ].." "..v
			elseif (tmp[ line ] == "") then
				tmp[ line ] = v
			else
				if (line == 3) then
					local len = string.len(" ("..self.Progress..")")
					if (string.sub( tmp[ line ], -len ) != " ("..self.Progress..")") then
						if (string.len( tmp[ line ] ) + len <= 24) then
							tmp[ line ] = tmp[ line ].." ("..self.Progress..")"
						else
							tmp[ line ] = string.sub( tmp[ line ], 0, (24 - len - 3) )
							tmp[ line ] = tmp[ line ].."... ("..self.Progress..")"
						end
					end
				end
				if (line <= 2) then
					tmp[ line + 1 ] = v
				end
				line = line + 1
			end
		end
	end
	
	if (line > 3) then
		line = 3
	end
	
	local i
	for i = 1, line do
		surface.SetFont("Default12B")
		local w2, h2 = surface.GetTextSize( tmp[ i ] )
		draw.DrawText( tmp[ i ] , "Default12B", 88, y[ line ][ i ], Color( 216, 222, 211, a ), TEXT_ALIGN_LEFT )
	end
end

vgui.Register("rt_achievement_progress_popup", PANEL )




local function ToValues( col )
	if ( !col ) then return 255, 255, 255, 255 end
	return col.r, col.g, col.b, col.a
end

local PANEL = {}
function PANEL:Init()
	self.Percent = 0
	self.Foreground = Color( 255, 255, 255 )
end
function PANEL:SetColour( fore, back )
	self.Fore = fore
	self.Back = back
end
function PANEL:SetPercent( percent )
	while ( percent > 1 ) do percent = percent / 100 end
	self.Percent = percent
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	if (self.Back) then
		surface.SetDrawColor( self.Back.r, self.Back.g, self.Back.b, self.Back.a )
	else
		surface.SetDrawColor( 26, 26, 26, 255 )
	end
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( self.Fore.r, self.Fore.g, self.Fore.b, self.Fore.a )
	surface.DrawRect( 0, 0, w * self.Percent, h )
end

vgui.Register("rt_achievement_progress", PANEL )




local PANEL = {}

function PANEL:Init()
	self.Text = "0/0"
	self.Percent = 100
	
	self.Bar = vgui.Create("rt_achievement_progress", self )
		self.Bar:SetColour( Color( 157, 81, 27 ), Color( 57, 53, 50 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 8, h - 25 )
	self.Bar:SetSize( w - 16, 16 )
end
function PANEL:SetEarned( earned, total )	
	self.Text = earned.."/"..total
	
	if ( total > 0 ) then
		self.Percent = math.floor( ( earned / total ) * 100 )
	else
		self.Percent = 0
	end
	
	self.Bar:SetPercent( self.Percent / 100 )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	surface.SetDrawColor( 26, 26, 26, 255 )
	surface.DrawRect( 0, 0, w, h )
	
	draw.SimpleText("Achievements Earned:", "Default13B", 8, 7, Color( 199, 188, 162 ) ) 
	draw.SimpleText( self.Text.." ("..self.Percent.."% )", "Default13B", w - 10, 7, Color( 199, 188, 162 ), TEXT_ALIGN_RIGHT ) 
end

vgui.Register("rt_achievement_progress_total", PANEL )





local PANEL = {}

function PANEL:Init()
	self.Name, self.Category, self.Description, self.Image, self.BWImage, self.Percent, self.PercentText = "", "", "", "", "", 1, ""
	
	self.LName = vgui.Create("DLabel", self )
		self.LName:SetFont("Default14BA")
		self.LName:SetPos( 71, 5 )
		
	self.LDesc = vgui.Create("DLabel", self )
		self.LDesc:SetFont("Default13B")
		self.LDesc:SetPos( 72, 22 )
	
	self.LPercent = vgui.Create("DLabel", self )
		self.LPercent:SetFont("Default13B")
	
	self.Bar = vgui.Create("rt_achievement_progress", self )
	self.Bar:SetColour( Color( 201, 185, 149 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 70, h - 22 )
	self.Bar:SetSize( 350, 12 )
	
	self.LName:SetSize( w, 15 )
	self.LDesc:SetSize( w, 15 )
	
	self.LPercent:SetSize( w, 15 )
	self.LPercent:SetPos( self.Bar.X + self.Bar:GetWide() + 10, h - 24 )
end
function PANEL:Setup( name, category, desc, image, bwimage, percent, percentText )
	self.Name, self.Category, self.Description, self.Image, self.BWImage, self.Percent, self.PercentText = name, category, desc, image or "", bwimage or "", percent, percentText or ""
	self.Percent = math.Clamp( self.Percent, 0, 1 )

	if (self.Percent != 1) then
		self.LName:SetTextColor( Color( 131, 131, 131 ) )
		self.LDesc:SetTextColor( Color( 131, 131, 131 ) )
		self.LPercent:SetTextColor( Color( 131, 131, 131 ) )
	else
		self.LName:SetTextColor( Color( 158, 195, 79 ) )
		self.LDesc:SetTextColor( Color( 203, 192, 167 ) )
		self.LPercent:SetTextColor( Color( 203, 192, 167 ) )
	end

	self.LName:SetText( name )
	self.LDesc:SetText( desc )
	self.LPercent:SetText( percentText or "")
	
	if ( self.Image != "") then
		if SACH.Debug then
			local Tmp = self.Image
			if not Tmp:find(".png") then
				Tmp = Tmp..".vmt"
			end
			
			if not file.Exists("materials/"..Tmp, "GAME") then
				ErrorNoHalt("Missing materials/"..Tmp.."\n")
			end
		end
		
		self.Material = Material( self.Image )
	else
		self.Material = Material("achievements/generic")
	end

	if ( self.BWImage != "") then
		self.BWMaterial = Material( self.BWImage )
	else
		self.BWMaterial = Material("achievements/bwgeneric")
	end
	
	self.Bar:SetVisible( percentText != "")
	self.Bar:SetPercent( self.Percent )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	if ( self.Percent == 1 ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 78, 78, 78 ) )
	else
		draw.RoundedBox( 4, 0, 0, w, h, Color( 52, 52, 52 ) )
	end

	if (self.Percent == 1) then
		if ( !self.Material ) then return end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 4, 4, 56, 56 )
	else
		if ( !self.BWMaterial ) then return end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.BWMaterial )
		surface.DrawTexturedRect( 4, 4, 56, 56 )
	end
end
vgui.Register("rt_achievement_info", PANEL )




local PANEL = {}

function PANEL:Init()
	self:SetTitle("Achievements")
	self:MakePopup()
	self:SetVisible( false )
	self:SetDeleteOnClose( false )

	self.Bar = vgui.Create("rt_achievement_progress_total", self)
	
	self.HideC = vgui.Create("DCheckBoxLabel", self )
	self.HideC.OnChange = function()
		self.HideAchieved = self.HideC:GetChecked( true )
		self:SortAchievements()
	end
	self.HideC:SetText("Hide Achieved")
	self.HideC.Label:SetTextColor( Color( 201, 189, 164, 255 ) )
	--self.HideC.Label:SetTextColorHovered( Color( 132, 122, 104, 255 ) )

	self.List = vgui.Create("DPanelList", self )
	self.List:EnableVerticalScrollbar()
	self.List:SetPadding( 8 )
	self.List:SetSpacing( 5 )
	
	function self.List.VBar:SetUp( _barsize_, _canvassize_ )
		self.BarSize 	= _barsize_
		self.CanvasSize = _canvassize_ - _barsize_
		self:SetEnabled( true )
		if (self.CanvasSize > 0) then
			self.btnGrip:SetVisible( true )
		else
			self.btnGrip:SetVisible( false )
		end
		self:InvalidateLayout()	
	end
	function self.List.VBar:AddScroll( dlta )
		if (self.CanvasSize > 0) then
			local OldScroll = self:GetScroll()
			dlta = dlta * 25
			self:SetScroll( self:GetScroll() + dlta )
			return OldScroll == self:GetScroll()
		end
		return false
	end
	function self.List.VBar:SetScroll( scrll )
		if ( !self.Enabled || self.CanvasSize <= 0 ) then self.Scroll = 0 return end
		self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )
		self:InvalidateLayout()
		// If our parent has a OnVScroll function use that, if
		// not then invalidate layout (which can be pretty slow)
		local func = self:GetParent().OnVScroll
		if ( func ) then
			func( self:GetParent(), self:GetOffset() )
		else
			self:GetParent():InvalidateLayout()
		end
	end
	
	self.CloseB = vgui.Create("DButton", self )
	self.CloseB:SetText("Close")
	self.CloseB.DoClick = function() self:SetVisible( false ) end

	self.LoadLbl = vgui.Create("DLabel", self )
	self.LoadLbl:SetFont("Default13B")
	self.LoadLbl:SetTextColor( Color( 217, 217, 217 ) )
	if (!SACH || !SACH.LoadedAchievements) then
		self.LoadLbl:SetText("Downloading from the server..")
	else
		self.LoadLbl:SetText(" ")
	end
	
	self.Options = vgui.Create("DButton", self )
	self.Options:SetText("Credits")
	--self.Options.DoClick = function() Options( self ) end
	self.Options.DoClick = function()
		Creditpnl( self )
	end
	
	self:SetSize( 630, math.floor( ScrH() * 0.6 ) )
	self:Center()
	
	self.Achievements = {}
	self.Categories = {}
	self.Category = "All"
	self.HideAchieved = false
	self.SlotsUsed = { false, false, false }
	self.SlotQueue = {}
end
function PANEL:PerformLayout()
	local w,h = self:GetWide(), self:GetTall()
	
	self.Bar:SetPos( 15, 40 )
	self.Bar:SetSize( w - 30, 50 )
	
	--self.CList:SetPos( 15, 100 )
	--self.CList:SetWide( 225 )
	
	surface.SetFont("Default13B")
	local w2,h2 = surface.GetTextSize("Hide Achieved")
	self.HideC:SetPos( 262, 103 )
	self.HideC:SetWide( w2 + 24 )
	
	local t = 20 --self.CList:GetTall()
	
	self.List:SetPos( 15, 105 + t )
	self.List:SetSize( w - 30, h - 145 - t )
	
	self.Options:SetPos( 15, h - 34 )
	self.Options:SetSize( 70, 24 )
	
	self.CloseB:SetPos( w - 85, h - 34 )
	self.CloseB:SetSize( 70, 24 )
	
	surface.SetFont("Default13B")
	
	local w2, h2 = surface.GetTextSize("Downloading from the server..")
	self.LoadLbl:SetSize( w2, h2 )
	self.LoadLbl:SetPos( (w*0.5) - (w2*0.5), h - h2 - 15 )
	
	for _,ach in pairs( self.Achievements or {} ) do
		ach.Panel:SetSize( self.List:GetWide() - 18, 64 )
	end
	
	self.List:InvalidateLayout()
	self.List.VBar:SetEnabled( true )
	self.List.VBar:InvalidateLayout()
	
	self.BaseClass.PerformLayout( self )
end


function PANEL:ClearSlot( slot )
	self.SlotsUsed[ slot ] = false

	if (#self.SlotQueue > 0) then
		local data = table.remove( self.SlotQueue, 1 )
		if (data[ 1 ]) then
			local popup = vgui.Create("rt_achievement_popup")
				popup:SetAchievement( data[ 2 ], data[ 3 ], self )
				popup:SetSlot( slot )
			self.SlotsUsed[ slot ] = true
		else
			local popup = vgui.Create("rt_achievement_progress_popup")
				popup:SetAchievement( data[ 2 ], data[ 3 ], data[ 4 ], self )
				popup:SetSlot( slot )
			self.SlotsUsed[ slot ] = true
		end
	end
end
function PANEL:LoadComplete()
	self.LoadLbl:SetText(" ")
end
function PANEL:SelectCategory( category )
	local res = -1
	local i = string.len( category )
	while(res == -1) do
		if (string.sub(category, i, i) == "(") then
			res = i
		end
		i = i - 1
	end
	self.Category = string.sub( category, 0, res-2 )
	self:SortAchievements()
end
function PANEL:SortCategories()
	local tab = {}
	for name, _ in pairs( self.Categories ) do
		if (name != "All") then
			tab[ #tab + 1 ] = name
		end
	end
	table.sort( tab )
	
	--self.CList:Clear()
	local info = self.Categories[ "All" ]
	if ( info ) then
		--self.CList:AddChoice("All ("..info.Achieved.." of "..info.Total..")")
	end
	for _, name in pairs( tab ) do
		local info = self.Categories[ name ]
		if ( info ) then
			--self.CList:AddChoice( name.." ("..info.Achieved.." of "..info.Total..")")
		end
	end
	local selected = self.Categories[ self.Category ]
	--self.CList:ChooseOption( self.Category.." ("..selected.Achieved.." of "..selected.Total..")")
	self:InvalidateLayout()
end
function PANEL:SortAchievements()
	local tab = {}
	for name, _ in pairs( self.Achievements ) do
		tab[ #tab + 1 ] = name
	end
	table.sort( tab )
	
	self.List:Clear()
	for _, name in pairs( tab ) do
		local info = self.Achievements[ name ]
		if ( info && info.Panel && (info.Category == self.Category || self.Category == "All") && (!info.Unlocked || !self.HideAchieved) ) then
			self.List:AddItem( info.Panel )
		end
	end
	self:InvalidateLayout()
end


function PANEL:SetupAchievement( name, category, desc, image, bwimage, percentText )
	percent = 0
	
	local panel
	if ( self.Achievements[ name ] == nil ) then
		panel = vgui.Create("rt_achievement_info", self )
			self.List:AddItem( panel )
		self:InvalidateLayout()
	else
		panel = self.Achievements[ name ].Panel
	end
	
	self.Achievements[ name ] = {
		Category = category,
		Desc = desc,
		Image = image,
		BWImage = bwimage,
		Percent = percent,
		Panel = panel,
		Unlocked = (percent == 1)
	}
	
	self:UpdateAchievement( name, percent, percentText, true )
end

function PANEL:LoadAchievement( name, percent, percentText, unlocked )
	if not self.Achievements[ name ] then
		ErrorNoHalt("! NO self.Achievements: "..name.."\n")
		return
	end
	
	self.Achievements[ name ].Unlocked = unlocked
	self:UpdateAchievement( name, percent, percentText, true )
end


function PANEL:UpdateAchievement( name, percent, percentText, ignore )
	if ( self.Achievements[ name ] == nil ) then return false end
	if ( ignore == nil ) then ignore = false end
	
	local ach = self.Achievements[ name ]
	local oldpercent = ach.Percent
	local unlocked = false
	ach.Percent = percent
	ach.Panel:Setup( name, ach.Category, ach.Desc, ach.Image, ach.BWImage, percent, percentText )

	if (!ignore) then
		if ( !ach.Unlocked && percent >= 1 ) then
			local slot = 0
			for k, v in pairs(self.SlotsUsed) do
				if (slot == 0 && !v) then
					slot = k
				end
			end
			if (slot != 0) then
				local popup = vgui.Create("rt_achievement_popup")
					popup:SetAchievement( name, ach.Image, self )
					popup:SetSlot( slot )
					self.SlotsUsed[ slot ] = true
			else
				table.insert( self.SlotQueue, { true, name, ach.Image } )
			end
			ach.Unlocked = true
			unlocked = true
		elseif (SACH.achievement_info[ name ].max >= SACH.progress_pop && (!SACH.progress_pop_four || math.fmod(SACH.achievement_info[ name ].max, 4) == 0)) then
			if (oldpercent < 0.25 && percent >= 0.25) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 1, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 1 } )
				end
			elseif (oldpercent < 0.5 && percent >= 0.5) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 2, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 2 } )
				end
			elseif (oldpercent < 0.75 && percent >= 0.75) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 3, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 3 } )
				end
			end
		end
	end

	if (!self.Categories[ "All" ]) then
		self.Categories[ "All" ] = {}
		self.Categories[ "All" ].Achieved = 0
		self.Categories[ "All" ].Total = 0
	end

	for k,_ in pairs( self.Categories ) do
		self.Categories[ k ].Achieved = 0
		self.Categories[ k ].Total = 0
	end

	local total = 0
	for _, ach in pairs( self.Achievements ) do
		if (!self.Categories[ ach.Category ]) then
			self.Categories[ ach.Category ] = {}
			self.Categories[ ach.Category ].Achieved = 0
			self.Categories[ ach.Category ].Total = 0
		end
		self.Categories[ ach.Category ].Total = self.Categories[ ach.Category ].Total + 1
		if ( ach.Percent == 1 ) then
			total = total + 1
			self.Categories[ ach.Category ].Achieved = self.Categories[ ach.Category ].Achieved + 1
		end
	end
	self.Bar:SetEarned( total, table.Count( self.Achievements ) )
	self.Categories[ "All" ].Achieved = total
	self.Categories[ "All" ].Total = table.Count( self.Achievements )

	if (unlocked || ignore) then
		self:SortCategories()
	end
	
	self.TotalAchievements = table.Count( self.Achievements )
end
vgui.Register("rt_SACH", PANEL, "DFrame")


// ##################################################
// END OF VGUI
// ##################################################


function SACH.FormatTime( time, format )
	local gah = { { "h", 3600 }, { "m", 60 }, { "s", 1 } }
	for _, t in pairs( gah ) do
		local amount = math.floor( time / t[ 2 ] )
		format = string.Replace( format, t[ 1 ], string.rep("0", 2 - string.len( amount ) )..amount )
		time = time % t[ 2 ]
	end
	return format
end

function SACH.Announcement( name, color, achievement )
	local ecolor = string.Explode(",", color )
	local name_color = Color( ecolor[1], ecolor[2], ecolor[3], 255 )
	
	chat.AddText(SACH.color_green, "[SACH] ", name_color, name, SACH.color_offwhite, " achieved ", Color(255,200,0), achievement )
	SACH.CallHook("c_achievement_announce", {name,name_color,achievement})
end





local function GetAchTable(dat) --Handle usermessages, new
	local data = net.ReadString()
	
	data = von.deserialize(data)
	
	if not SACH.FinishedLoading then
		timer.Simple(1, function()
			SACH.LoadAchievements(data)
		end)
		return
	end
	SACH.LoadAchievements(data)
end
net.Receive("sach_netstream", GetAchTable)

local function handleumsg(um) --Handle usermessages, old
	local type = um:ReadString()
	
	if (type == "announce_achievement") then
		SACH.Announcement( um:ReadString(), um:ReadString(), um:ReadString() )
	end
	
	if (type == "update_achievement") then
		SACH.Update( um:ReadString(), um:ReadFloat(), um:ReadString() )
	end
	
	if (type == "achievement_load") then
		SACH.effect = 3
		SACH.sound = 1
		
		SACH.progress_pop = um:ReadShort()
		SACH.progress_pop_four = um:ReadBool()
		
		SACH.allow_reset = false
		SACH.allow_effect_choose = false
		SACH.allow_sound_choose = false
	end
	
	if (type == "achievement_effects") then
	end
	if (type == "achievement_sounds") then
	end
	if (type == "achievement_loading") then
	end
	if (type == "achievement_new") then
	end
	
	if (type == "achievement_load_complete") then
		timer.Simple(1, function()
			SACH.LoadedAchievements = true
			SACH.MenuUpdate()
			chat.AddText( SACH.color_green, "[SACH]", color_white, " Loaded! press F4 to open the achievement panel")
		end)
	end
end
usermessage.Hook("s_achievement", handleumsg)




local function Initialize()
	local menu = vgui.Create("rt_SACH")
	
	function SACH.LoadAchievements(tab)
		for k,v in pairs(tab) do
			menu:LoadAchievement(k, v.Percent, v.PercentText, v.Unlocked)
		end
		SACH.CallHook("c_achievement_loaded", {tab})
	end
	
	function SACH.Register(name,desc,image,percentText,max)
		SACH.achievement_info[name] 		= {}
		SACH.achievement_info[name].ptext 	= percentText
		SACH.achievement_info[name].max 	= max
		
		menu:SetupAchievement(name, "General", desc, image, "vgui/spawnmenu/hover", percentText)
	end
	
	function SACH.GetNumber()
		return ( menu.TotalAchievements or 0 )
	end
	
	function SACH.Update( name, percent, percentText )
		menu:UpdateAchievement( name, percent, percentText )
		SACH.CallHook("c_achievement_update", { name, percent, percentText } )
	end
	function SACH.Sort()
		menu:SortAchievements()
		menu:SortCategories()
	end
	function SACH.MenuUpdate()
		if (!SACH.LoadedAchievements) then return end
		menu:LoadComplete()
	end
	
	function SACH.Reset()
		for k,v in pairs(SACH.achievement_info) do
			menu:LoadAchievement(k, 0, v.ptext, false)
		end
		SACH.Sort()
	end	
	
	
	function SACH.ToggleMenu()
		if ( menu:IsVisible() ) then
			menu:Close()
			return
		end
		
		menu:SetTitle(LocalPlayer():Nick().."'s achievements!")
		menu:InvalidateLayout()
		menu:SetVisible( true )
	end
	concommand.Add("SACH", SACH.ToggleMenu)
	
	local function Reset(ply,cmd,args)
		print("Resetting achievements...")
		SACH.Reset()
		RunConsoleCommand("SACH_cmd", "reset")
	end
	concommand.Add("SACH_reset", Reset)
	
	local Wait = false
	local WaitFor = 0.25
	local function CheckKeys()
		if not Wait and input.IsKeyDown(KEY_F4) then
			Wait = true
			timer.Simple(WaitFor, function()
				Wait = false
			end)
			SACH.ToggleMenu()
		end
	end
	hook.Add("Think", "SACH.CheckKeys", CheckKeys)
	
	
	local mFiles = file.Find("sach_modules/*.lua", "LUA")
	for k,mod in pairs(mFiles) do
		m = {}
		include("sach_modules/"..mod)
		
		if (!m.platform) then
			m.platform = "server"
		end
		if (m.enabled == nil) then
			m.enabled = true
		end
		
		if (m.enabled) then
			if (string.lower( m.platform ) != "server") then
				SACH.modules[ m.name ] = table.Copy( m )
				SACH.modules[ m.name ]:Init()
			end
		end
	end
	
	function SACH.CallHook( hook, data )
		for _,v in pairs( SACH.modules ) do
			v:Call( hook, data )
		end
	end
	
	
	local Afiles = file.Find("SACH/*.lua", "LUA")	
	for i,ach in pairs(Afiles) do
		include("SACH/"..ach)
	end
	SACH.Sort()
	SACH.FinishedLoading = true
	
	MsgN("[SACH] loaded ["..SACH.GetNumber().."] achievements!")
end
hook.Add("Initialize", "SACH.Initialize", Initialize)


















----------------------------------------
--         2014-07-12 20:32:51          --
------------------------------------------

MsgN("[SACH] loading")

include("autorun/von.lua")

SACH = {
	color_green 		= Color(158,195,79,255),
	color_offwhite 		= Color(251,236,203,255),
	achievement_info 	= {},
	modules 			= {},
	Debug				= false,
}




surface.CreateFont("Default12B", {
	font		= "Default",
	size 		= 12,
	weight		= 700,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("Default13B", {
	font		= "Default",
	size 		= 13,
	weight		= 700,
	antialias	= false,
	additive	= false,
	}
)

surface.CreateFont("Default14BA", {
	font		= "Default",
	size 		= 14,
	weight		= 700,
	antialias	= true,
	additive	= false,
	}
)







//Handle popups and panels
local creditpnl
function Creditpnl()
	if ( creditpnl ) then
		creditpnl:Remove()
	end
	
	creditpnl = vgui.Create("DFrame")
		creditpnl:SetWide( 205 )
		creditpnl:SetTitle("Credits")
		creditpnl:MakePopup()
	
	local y = 30

	local infoLabel = vgui.Create("DLabel", creditpnl )
		infoLabel:SetPos( 15, y )
		infoLabel:SetText("Serverside Achievements")
		infoLabel:SetWide( 175 )
	y = y + infoLabel:GetTall()

	y = y + 5
	local infoLabel2 = vgui.Create("DLabel", creditpnl )
		infoLabel2:SetPos( 15, y )
		infoLabel2:SetText("by gmt2001")
		infoLabel2:SetWide( 175 )
	y = y + infoLabel2:GetTall()

	y = y + 5
	local divider = vgui.Create("DLabel", creditpnl )
		divider:SetPos( 15, y )
		divider:SetWide( 175 )
		divider:SetText(" ")
	y = y + divider:GetTall()
	
	local hexmsg = vgui.Create("DLabel", creditpnl )
		hexmsg:SetPos( 15, y )
		hexmsg:SetText("Edited/fixed by HeX")
		hexmsg:SetWide( 175 )
	y = y + hexmsg:GetTall()

	y = y + 5
	local infoLabel3 = vgui.Create("DLabel", creditpnl )
		infoLabel3:SetPos( 15, y )
		infoLabel3:SetText("Clientside Code from")
		infoLabel3:SetWide( 175 )
	y = y + infoLabel3:GetTall()

	y = y + 5
	local infoLabel4 = vgui.Create("DLabel", creditpnl )
		infoLabel4:SetPos( 15, y )
		infoLabel4:SetText( '"Achievements"' )
		infoLabel4:SetWide( 175 )
	y = y + infoLabel4:GetTall()

	y = y + 5
	local infoLabel5 = vgui.Create("DLabel", creditpnl )
		infoLabel5:SetPos( 15, y )
		infoLabel5:SetText("by RabidToaster and G3X")
		infoLabel5:SetWide( 175 )
	y = y + infoLabel5:GetTall()

	y = y + 5
	local close = vgui.Create("DButton", creditpnl )
		close:SetPos( 15, y )
		close:SetWide( 170 )
		close:SetText("OK")
		close.DoClick = function() creditpnl:Remove() end
	y = y + close:GetTall() + 5

	// Make the window the right size, and in the right place.
	y = y + 5
	creditpnl:SetTall( y )
	creditpnl:Center()
end




local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	self.Main = nil
end
function PANEL:SetAchievement( text, image, main )
	self.Main = main
	self.Text = text
	self.Image = image or "achievements/generic"
	
	self.Material = Material( self.Image )
	if ( !self.Material ) then self.Image = nil end
end
function PANEL:SetSlot( slot )
	self.Slot = slot
end
function PANEL:Think()
	self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
	self:InvalidateLayout()

	if (self.Removed) then
		self:Remove()
	end

	if ( self.Direction == 1 && self.Offset == 1 ) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if ( self.Down != nil && CurTime() > self.Down ) then
		self.Direction = -1
		self.Down = nil
	end
	if ( self.Offset == 0 && !self.Removed ) then
		self.Main:ClearSlot( self.Slot )
		self.Removed = true
	end
end
function PANEL:PerformLayout()
	local w, h = 240, 94
	
	self:SetSize( w, h )
	self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	
	surface.SetDrawColor( 47, 49, 45, a )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 104, 106, 101, a )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( 255, 255, 255, a )
	
	if ( self.Image ) then
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		surface.SetDrawColor( 70, 70, 70, a )
		surface.DrawOutlinedRect( 13, 13, 66, 66 )
	end
	
	draw.DrawText("Achievement Unlocked!", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT)
	
	local exp 	= string.Explode(" ", self.Text)
	local tmp 	= {"","",""}
	local line	= 1
	local y		= {
		{55},
		{50,61},
		{44,55,66}
	}
	
	
	for _,v in pairs(exp) do
		if (line < 4) then
			if (tmp[ line ] != "" && string.len( tmp[ line ].." "..v ) <= 24) then
				tmp[ line ] = tmp[ line ].." "..v
			elseif (tmp[ line ] == "") then
				tmp[ line ] = v
			else
				if (line == 3) then
					if (string.len( tmp[ line ] ) + 3 <= 24) then
						tmp[ line ] = tmp[ line ].."..."
					else
						tmp[ line ] = string.sub( tmp[ line ], 0, (24 - 3) )
						tmp[ line ] = tmp[ line ].."..."
					end
				end
				if (line <= 2) then
					tmp[ line + 1 ] = v
				end
				line = line + 1
			end
		end
	end
	
	if (line > 3) then
		line = 3
	end
	
	local i
	for i = 1, line do
		surface.SetFont("Default12B")
		local w2, h2 = surface.GetTextSize( tmp[ i ] )
		draw.DrawText( tmp[ i ] , "Default12B", 88, y[ line ][ i ], Color( 216, 222, 211, a ), TEXT_ALIGN_LEFT )
	end
end

vgui.Register("rt_achievement_popup", PANEL )





local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	self.Progress = "0/0"
	self.Main = nil
end
function PANEL:SetAchievement( text, image, mult, main )
	self.Main = main
	self.Text = text
	self.Image = image or "achievements/bwgeneric"
	
	self.Material = Material( self.Image )
	if ( !self.Material ) then self.Image = nil end

	local progress = SACH.achievement_info[ text ].max / 4
	progress = progress * mult
	progress = math.ceil(progress)
	self.Progress = progress.."/"..SACH.achievement_info[ text ].max
	self.Text = self.Text.." ("..self.Progress..")"
end
function PANEL:SetSlot( slot )
	self.Slot = slot
end
function PANEL:Think()
	self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
	self:InvalidateLayout()

	if (self.Removed) then
		self:Remove()
	end
	
	if ( self.Direction == 1 && self.Offset == 1 ) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if ( self.Down != nil && CurTime() > self.Down ) then
		self.Direction = -1
		self.Down = nil
	end
	if ( self.Offset == 0 && !self.Removed ) then
		self.Main:ClearSlot( self.Slot )
		self.Removed = true
	end
end
function PANEL:PerformLayout()
	local w, h = 240, 94
	
	self:SetSize( w, h )
	self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	
	surface.SetDrawColor( 47, 49, 45, a )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 104, 106, 101, a )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( 255, 255, 255, a )
	
	if ( self.Image ) then
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		surface.SetDrawColor( 70, 70, 70, a )
		surface.DrawOutlinedRect( 13, 13, 66, 66 )
	end
	
	draw.DrawText("Achievement Progress", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT)
	
	local exp 	= string.Explode(" ", self.Text)
	local tmp 	= {"","",""}
	local line 	= 1
	local y 	= {
		{55 },
		{50,61},
		{44,55,66}
	}
	
	for _,v in pairs(exp) do
		if (line < 4) then
			if (tmp[ line ] != "" && string.len( tmp[ line ].." "..v ) <= 24) then
				tmp[ line ] = tmp[ line ].." "..v
			elseif (tmp[ line ] == "") then
				tmp[ line ] = v
			else
				if (line == 3) then
					local len = string.len(" ("..self.Progress..")")
					if (string.sub( tmp[ line ], -len ) != " ("..self.Progress..")") then
						if (string.len( tmp[ line ] ) + len <= 24) then
							tmp[ line ] = tmp[ line ].." ("..self.Progress..")"
						else
							tmp[ line ] = string.sub( tmp[ line ], 0, (24 - len - 3) )
							tmp[ line ] = tmp[ line ].."... ("..self.Progress..")"
						end
					end
				end
				if (line <= 2) then
					tmp[ line + 1 ] = v
				end
				line = line + 1
			end
		end
	end
	
	if (line > 3) then
		line = 3
	end
	
	local i
	for i = 1, line do
		surface.SetFont("Default12B")
		local w2, h2 = surface.GetTextSize( tmp[ i ] )
		draw.DrawText( tmp[ i ] , "Default12B", 88, y[ line ][ i ], Color( 216, 222, 211, a ), TEXT_ALIGN_LEFT )
	end
end

vgui.Register("rt_achievement_progress_popup", PANEL )




local function ToValues( col )
	if ( !col ) then return 255, 255, 255, 255 end
	return col.r, col.g, col.b, col.a
end

local PANEL = {}
function PANEL:Init()
	self.Percent = 0
	self.Foreground = Color( 255, 255, 255 )
end
function PANEL:SetColour( fore, back )
	self.Fore = fore
	self.Back = back
end
function PANEL:SetPercent( percent )
	while ( percent > 1 ) do percent = percent / 100 end
	self.Percent = percent
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	if (self.Back) then
		surface.SetDrawColor( self.Back.r, self.Back.g, self.Back.b, self.Back.a )
	else
		surface.SetDrawColor( 26, 26, 26, 255 )
	end
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( self.Fore.r, self.Fore.g, self.Fore.b, self.Fore.a )
	surface.DrawRect( 0, 0, w * self.Percent, h )
end

vgui.Register("rt_achievement_progress", PANEL )




local PANEL = {}

function PANEL:Init()
	self.Text = "0/0"
	self.Percent = 100
	
	self.Bar = vgui.Create("rt_achievement_progress", self )
		self.Bar:SetColour( Color( 157, 81, 27 ), Color( 57, 53, 50 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 8, h - 25 )
	self.Bar:SetSize( w - 16, 16 )
end
function PANEL:SetEarned( earned, total )	
	self.Text = earned.."/"..total
	
	if ( total > 0 ) then
		self.Percent = math.floor( ( earned / total ) * 100 )
	else
		self.Percent = 0
	end
	
	self.Bar:SetPercent( self.Percent / 100 )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	surface.SetDrawColor( 26, 26, 26, 255 )
	surface.DrawRect( 0, 0, w, h )
	
	draw.SimpleText("Achievements Earned:", "Default13B", 8, 7, Color( 199, 188, 162 ) ) 
	draw.SimpleText( self.Text.." ("..self.Percent.."% )", "Default13B", w - 10, 7, Color( 199, 188, 162 ), TEXT_ALIGN_RIGHT ) 
end

vgui.Register("rt_achievement_progress_total", PANEL )





local PANEL = {}

function PANEL:Init()
	self.Name, self.Category, self.Description, self.Image, self.BWImage, self.Percent, self.PercentText = "", "", "", "", "", 1, ""
	
	self.LName = vgui.Create("DLabel", self )
		self.LName:SetFont("Default14BA")
		self.LName:SetPos( 71, 5 )
		
	self.LDesc = vgui.Create("DLabel", self )
		self.LDesc:SetFont("Default13B")
		self.LDesc:SetPos( 72, 22 )
	
	self.LPercent = vgui.Create("DLabel", self )
		self.LPercent:SetFont("Default13B")
	
	self.Bar = vgui.Create("rt_achievement_progress", self )
	self.Bar:SetColour( Color( 201, 185, 149 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 70, h - 22 )
	self.Bar:SetSize( 350, 12 )
	
	self.LName:SetSize( w, 15 )
	self.LDesc:SetSize( w, 15 )
	
	self.LPercent:SetSize( w, 15 )
	self.LPercent:SetPos( self.Bar.X + self.Bar:GetWide() + 10, h - 24 )
end
function PANEL:Setup( name, category, desc, image, bwimage, percent, percentText )
	self.Name, self.Category, self.Description, self.Image, self.BWImage, self.Percent, self.PercentText = name, category, desc, image or "", bwimage or "", percent, percentText or ""
	self.Percent = math.Clamp( self.Percent, 0, 1 )

	if (self.Percent != 1) then
		self.LName:SetTextColor( Color( 131, 131, 131 ) )
		self.LDesc:SetTextColor( Color( 131, 131, 131 ) )
		self.LPercent:SetTextColor( Color( 131, 131, 131 ) )
	else
		self.LName:SetTextColor( Color( 158, 195, 79 ) )
		self.LDesc:SetTextColor( Color( 203, 192, 167 ) )
		self.LPercent:SetTextColor( Color( 203, 192, 167 ) )
	end

	self.LName:SetText( name )
	self.LDesc:SetText( desc )
	self.LPercent:SetText( percentText or "")
	
	if ( self.Image != "") then
		if SACH.Debug then
			local Tmp = self.Image
			if not Tmp:find(".png") then
				Tmp = Tmp..".vmt"
			end
			
			if not file.Exists("materials/"..Tmp, "GAME") then
				ErrorNoHalt("Missing materials/"..Tmp.."\n")
			end
		end
		
		self.Material = Material( self.Image )
	else
		self.Material = Material("achievements/generic")
	end

	if ( self.BWImage != "") then
		self.BWMaterial = Material( self.BWImage )
	else
		self.BWMaterial = Material("achievements/bwgeneric")
	end
	
	self.Bar:SetVisible( percentText != "")
	self.Bar:SetPercent( self.Percent )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	if ( self.Percent == 1 ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 78, 78, 78 ) )
	else
		draw.RoundedBox( 4, 0, 0, w, h, Color( 52, 52, 52 ) )
	end

	if (self.Percent == 1) then
		if ( !self.Material ) then return end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 4, 4, 56, 56 )
	else
		if ( !self.BWMaterial ) then return end
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.BWMaterial )
		surface.DrawTexturedRect( 4, 4, 56, 56 )
	end
end
vgui.Register("rt_achievement_info", PANEL )




local PANEL = {}

function PANEL:Init()
	self:SetTitle("Achievements")
	self:MakePopup()
	self:SetVisible( false )
	self:SetDeleteOnClose( false )

	self.Bar = vgui.Create("rt_achievement_progress_total", self)
	
	self.HideC = vgui.Create("DCheckBoxLabel", self )
	self.HideC.OnChange = function()
		self.HideAchieved = self.HideC:GetChecked( true )
		self:SortAchievements()
	end
	self.HideC:SetText("Hide Achieved")
	self.HideC.Label:SetTextColor( Color( 201, 189, 164, 255 ) )
	--self.HideC.Label:SetTextColorHovered( Color( 132, 122, 104, 255 ) )

	self.List = vgui.Create("DPanelList", self )
	self.List:EnableVerticalScrollbar()
	self.List:SetPadding( 8 )
	self.List:SetSpacing( 5 )
	
	function self.List.VBar:SetUp( _barsize_, _canvassize_ )
		self.BarSize 	= _barsize_
		self.CanvasSize = _canvassize_ - _barsize_
		self:SetEnabled( true )
		if (self.CanvasSize > 0) then
			self.btnGrip:SetVisible( true )
		else
			self.btnGrip:SetVisible( false )
		end
		self:InvalidateLayout()	
	end
	function self.List.VBar:AddScroll( dlta )
		if (self.CanvasSize > 0) then
			local OldScroll = self:GetScroll()
			dlta = dlta * 25
			self:SetScroll( self:GetScroll() + dlta )
			return OldScroll == self:GetScroll()
		end
		return false
	end
	function self.List.VBar:SetScroll( scrll )
		if ( !self.Enabled || self.CanvasSize <= 0 ) then self.Scroll = 0 return end
		self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )
		self:InvalidateLayout()
		// If our parent has a OnVScroll function use that, if
		// not then invalidate layout (which can be pretty slow)
		local func = self:GetParent().OnVScroll
		if ( func ) then
			func( self:GetParent(), self:GetOffset() )
		else
			self:GetParent():InvalidateLayout()
		end
	end
	
	self.CloseB = vgui.Create("DButton", self )
	self.CloseB:SetText("Close")
	self.CloseB.DoClick = function() self:SetVisible( false ) end

	self.LoadLbl = vgui.Create("DLabel", self )
	self.LoadLbl:SetFont("Default13B")
	self.LoadLbl:SetTextColor( Color( 217, 217, 217 ) )
	if (!SACH || !SACH.LoadedAchievements) then
		self.LoadLbl:SetText("Downloading from the server..")
	else
		self.LoadLbl:SetText(" ")
	end
	
	self.Options = vgui.Create("DButton", self )
	self.Options:SetText("Credits")
	--self.Options.DoClick = function() Options( self ) end
	self.Options.DoClick = function()
		Creditpnl( self )
	end
	
	self:SetSize( 630, math.floor( ScrH() * 0.6 ) )
	self:Center()
	
	self.Achievements = {}
	self.Categories = {}
	self.Category = "All"
	self.HideAchieved = false
	self.SlotsUsed = { false, false, false }
	self.SlotQueue = {}
end
function PANEL:PerformLayout()
	local w,h = self:GetWide(), self:GetTall()
	
	self.Bar:SetPos( 15, 40 )
	self.Bar:SetSize( w - 30, 50 )
	
	--self.CList:SetPos( 15, 100 )
	--self.CList:SetWide( 225 )
	
	surface.SetFont("Default13B")
	local w2,h2 = surface.GetTextSize("Hide Achieved")
	self.HideC:SetPos( 262, 103 )
	self.HideC:SetWide( w2 + 24 )
	
	local t = 20 --self.CList:GetTall()
	
	self.List:SetPos( 15, 105 + t )
	self.List:SetSize( w - 30, h - 145 - t )
	
	self.Options:SetPos( 15, h - 34 )
	self.Options:SetSize( 70, 24 )
	
	self.CloseB:SetPos( w - 85, h - 34 )
	self.CloseB:SetSize( 70, 24 )
	
	surface.SetFont("Default13B")
	
	local w2, h2 = surface.GetTextSize("Downloading from the server..")
	self.LoadLbl:SetSize( w2, h2 )
	self.LoadLbl:SetPos( (w*0.5) - (w2*0.5), h - h2 - 15 )
	
	for _,ach in pairs( self.Achievements or {} ) do
		ach.Panel:SetSize( self.List:GetWide() - 18, 64 )
	end
	
	self.List:InvalidateLayout()
	self.List.VBar:SetEnabled( true )
	self.List.VBar:InvalidateLayout()
	
	self.BaseClass.PerformLayout( self )
end


function PANEL:ClearSlot( slot )
	self.SlotsUsed[ slot ] = false

	if (#self.SlotQueue > 0) then
		local data = table.remove( self.SlotQueue, 1 )
		if (data[ 1 ]) then
			local popup = vgui.Create("rt_achievement_popup")
				popup:SetAchievement( data[ 2 ], data[ 3 ], self )
				popup:SetSlot( slot )
			self.SlotsUsed[ slot ] = true
		else
			local popup = vgui.Create("rt_achievement_progress_popup")
				popup:SetAchievement( data[ 2 ], data[ 3 ], data[ 4 ], self )
				popup:SetSlot( slot )
			self.SlotsUsed[ slot ] = true
		end
	end
end
function PANEL:LoadComplete()
	self.LoadLbl:SetText(" ")
end
function PANEL:SelectCategory( category )
	local res = -1
	local i = string.len( category )
	while(res == -1) do
		if (string.sub(category, i, i) == "(") then
			res = i
		end
		i = i - 1
	end
	self.Category = string.sub( category, 0, res-2 )
	self:SortAchievements()
end
function PANEL:SortCategories()
	local tab = {}
	for name, _ in pairs( self.Categories ) do
		if (name != "All") then
			tab[ #tab + 1 ] = name
		end
	end
	table.sort( tab )
	
	--self.CList:Clear()
	local info = self.Categories[ "All" ]
	if ( info ) then
		--self.CList:AddChoice("All ("..info.Achieved.." of "..info.Total..")")
	end
	for _, name in pairs( tab ) do
		local info = self.Categories[ name ]
		if ( info ) then
			--self.CList:AddChoice( name.." ("..info.Achieved.." of "..info.Total..")")
		end
	end
	local selected = self.Categories[ self.Category ]
	--self.CList:ChooseOption( self.Category.." ("..selected.Achieved.." of "..selected.Total..")")
	self:InvalidateLayout()
end
function PANEL:SortAchievements()
	local tab = {}
	for name, _ in pairs( self.Achievements ) do
		tab[ #tab + 1 ] = name
	end
	table.sort( tab )
	
	self.List:Clear()
	for _, name in pairs( tab ) do
		local info = self.Achievements[ name ]
		if ( info && info.Panel && (info.Category == self.Category || self.Category == "All") && (!info.Unlocked || !self.HideAchieved) ) then
			self.List:AddItem( info.Panel )
		end
	end
	self:InvalidateLayout()
end


function PANEL:SetupAchievement( name, category, desc, image, bwimage, percentText )
	percent = 0
	
	local panel
	if ( self.Achievements[ name ] == nil ) then
		panel = vgui.Create("rt_achievement_info", self )
			self.List:AddItem( panel )
		self:InvalidateLayout()
	else
		panel = self.Achievements[ name ].Panel
	end
	
	self.Achievements[ name ] = {
		Category = category,
		Desc = desc,
		Image = image,
		BWImage = bwimage,
		Percent = percent,
		Panel = panel,
		Unlocked = (percent == 1)
	}
	
	self:UpdateAchievement( name, percent, percentText, true )
end

function PANEL:LoadAchievement( name, percent, percentText, unlocked )
	if not self.Achievements[ name ] then
		ErrorNoHalt("! NO self.Achievements: "..name.."\n")
		return
	end
	
	self.Achievements[ name ].Unlocked = unlocked
	self:UpdateAchievement( name, percent, percentText, true )
end


function PANEL:UpdateAchievement( name, percent, percentText, ignore )
	if ( self.Achievements[ name ] == nil ) then return false end
	if ( ignore == nil ) then ignore = false end
	
	local ach = self.Achievements[ name ]
	local oldpercent = ach.Percent
	local unlocked = false
	ach.Percent = percent
	ach.Panel:Setup( name, ach.Category, ach.Desc, ach.Image, ach.BWImage, percent, percentText )

	if (!ignore) then
		if ( !ach.Unlocked && percent >= 1 ) then
			local slot = 0
			for k, v in pairs(self.SlotsUsed) do
				if (slot == 0 && !v) then
					slot = k
				end
			end
			if (slot != 0) then
				local popup = vgui.Create("rt_achievement_popup")
					popup:SetAchievement( name, ach.Image, self )
					popup:SetSlot( slot )
					self.SlotsUsed[ slot ] = true
			else
				table.insert( self.SlotQueue, { true, name, ach.Image } )
			end
			ach.Unlocked = true
			unlocked = true
		elseif (SACH.achievement_info[ name ].max >= SACH.progress_pop && (!SACH.progress_pop_four || math.fmod(SACH.achievement_info[ name ].max, 4) == 0)) then
			if (oldpercent < 0.25 && percent >= 0.25) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 1, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 1 } )
				end
			elseif (oldpercent < 0.5 && percent >= 0.5) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 2, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 2 } )
				end
			elseif (oldpercent < 0.75 && percent >= 0.75) then
				local slot = 0
				for k, v in pairs(self.SlotsUsed) do
					if (slot == 0 && !v) then
						slot = k
					end
				end
				if (slot != 0) then
					local popup = vgui.Create("rt_achievement_progress_popup")
						popup:SetAchievement( name, ach.BWImage, 3, self )
						popup:SetSlot( slot )
						self.SlotsUsed[ slot ] = true
				else
					table.insert( self.SlotQueue, { false, name, ach.BWImage, 3 } )
				end
			end
		end
	end

	if (!self.Categories[ "All" ]) then
		self.Categories[ "All" ] = {}
		self.Categories[ "All" ].Achieved = 0
		self.Categories[ "All" ].Total = 0
	end

	for k,_ in pairs( self.Categories ) do
		self.Categories[ k ].Achieved = 0
		self.Categories[ k ].Total = 0
	end

	local total = 0
	for _, ach in pairs( self.Achievements ) do
		if (!self.Categories[ ach.Category ]) then
			self.Categories[ ach.Category ] = {}
			self.Categories[ ach.Category ].Achieved = 0
			self.Categories[ ach.Category ].Total = 0
		end
		self.Categories[ ach.Category ].Total = self.Categories[ ach.Category ].Total + 1
		if ( ach.Percent == 1 ) then
			total = total + 1
			self.Categories[ ach.Category ].Achieved = self.Categories[ ach.Category ].Achieved + 1
		end
	end
	self.Bar:SetEarned( total, table.Count( self.Achievements ) )
	self.Categories[ "All" ].Achieved = total
	self.Categories[ "All" ].Total = table.Count( self.Achievements )

	if (unlocked || ignore) then
		self:SortCategories()
	end
	
	self.TotalAchievements = table.Count( self.Achievements )
end
vgui.Register("rt_SACH", PANEL, "DFrame")


// ##################################################
// END OF VGUI
// ##################################################


function SACH.FormatTime( time, format )
	local gah = { { "h", 3600 }, { "m", 60 }, { "s", 1 } }
	for _, t in pairs( gah ) do
		local amount = math.floor( time / t[ 2 ] )
		format = string.Replace( format, t[ 1 ], string.rep("0", 2 - string.len( amount ) )..amount )
		time = time % t[ 2 ]
	end
	return format
end

function SACH.Announcement( name, color, achievement )
	local ecolor = string.Explode(",", color )
	local name_color = Color( ecolor[1], ecolor[2], ecolor[3], 255 )
	
	chat.AddText(SACH.color_green, "[SACH] ", name_color, name, SACH.color_offwhite, " achieved ", Color(255,200,0), achievement )
	SACH.CallHook("c_achievement_announce", {name,name_color,achievement})
end





local function GetAchTable(dat) --Handle usermessages, new
	local data = net.ReadString()
	
	data = von.deserialize(data)
	
	if not SACH.FinishedLoading then
		timer.Simple(1, function()
			SACH.LoadAchievements(data)
		end)
		return
	end
	SACH.LoadAchievements(data)
end
net.Receive("sach_netstream", GetAchTable)

local function handleumsg(um) --Handle usermessages, old
	local type = um:ReadString()
	
	if (type == "announce_achievement") then
		SACH.Announcement( um:ReadString(), um:ReadString(), um:ReadString() )
	end
	
	if (type == "update_achievement") then
		SACH.Update( um:ReadString(), um:ReadFloat(), um:ReadString() )
	end
	
	if (type == "achievement_load") then
		SACH.effect = 3
		SACH.sound = 1
		
		SACH.progress_pop = um:ReadShort()
		SACH.progress_pop_four = um:ReadBool()
		
		SACH.allow_reset = false
		SACH.allow_effect_choose = false
		SACH.allow_sound_choose = false
	end
	
	if (type == "achievement_effects") then
	end
	if (type == "achievement_sounds") then
	end
	if (type == "achievement_loading") then
	end
	if (type == "achievement_new") then
	end
	
	if (type == "achievement_load_complete") then
		timer.Simple(1, function()
			SACH.LoadedAchievements = true
			SACH.MenuUpdate()
			chat.AddText( SACH.color_green, "[SACH]", color_white, " Loaded! press F4 to open the achievement panel")
		end)
	end
end
usermessage.Hook("s_achievement", handleumsg)




local function Initialize()
	local menu = vgui.Create("rt_SACH")
	
	function SACH.LoadAchievements(tab)
		for k,v in pairs(tab) do
			menu:LoadAchievement(k, v.Percent, v.PercentText, v.Unlocked)
		end
		SACH.CallHook("c_achievement_loaded", {tab})
	end
	
	function SACH.Register(name,desc,image,percentText,max)
		SACH.achievement_info[name] 		= {}
		SACH.achievement_info[name].ptext 	= percentText
		SACH.achievement_info[name].max 	= max
		
		menu:SetupAchievement(name, "General", desc, image, "vgui/spawnmenu/hover", percentText)
	end
	
	function SACH.GetNumber()
		return ( menu.TotalAchievements or 0 )
	end
	
	function SACH.Update( name, percent, percentText )
		menu:UpdateAchievement( name, percent, percentText )
		SACH.CallHook("c_achievement_update", { name, percent, percentText } )
	end
	function SACH.Sort()
		menu:SortAchievements()
		menu:SortCategories()
	end
	function SACH.MenuUpdate()
		if (!SACH.LoadedAchievements) then return end
		menu:LoadComplete()
	end
	
	function SACH.Reset()
		for k,v in pairs(SACH.achievement_info) do
			menu:LoadAchievement(k, 0, v.ptext, false)
		end
		SACH.Sort()
	end	
	
	
	function SACH.ToggleMenu()
		if ( menu:IsVisible() ) then
			menu:Close()
			return
		end
		
		menu:SetTitle(LocalPlayer():Nick().."'s achievements!")
		menu:InvalidateLayout()
		menu:SetVisible( true )
	end
	concommand.Add("SACH", SACH.ToggleMenu)
	
	local function Reset(ply,cmd,args)
		print("Resetting achievements...")
		SACH.Reset()
		RunConsoleCommand("SACH_cmd", "reset")
	end
	concommand.Add("SACH_reset", Reset)
	
	local Wait = false
	local WaitFor = 0.25
	local function CheckKeys()
		if not Wait and input.IsKeyDown(KEY_F4) then
			Wait = true
			timer.Simple(WaitFor, function()
				Wait = false
			end)
			SACH.ToggleMenu()
		end
	end
	hook.Add("Think", "SACH.CheckKeys", CheckKeys)
	
	
	local mFiles = file.Find("sach_modules/*.lua", "LUA")
	for k,mod in pairs(mFiles) do
		m = {}
		include("sach_modules/"..mod)
		
		if (!m.platform) then
			m.platform = "server"
		end
		if (m.enabled == nil) then
			m.enabled = true
		end
		
		if (m.enabled) then
			if (string.lower( m.platform ) != "server") then
				SACH.modules[ m.name ] = table.Copy( m )
				SACH.modules[ m.name ]:Init()
			end
		end
	end
	
	function SACH.CallHook( hook, data )
		for _,v in pairs( SACH.modules ) do
			v:Call( hook, data )
		end
	end
	
	
	local Afiles = file.Find("SACH/*.lua", "LUA")	
	for i,ach in pairs(Afiles) do
		include("SACH/"..ach)
	end
	SACH.Sort()
	SACH.FinishedLoading = true
	
	MsgN("[SACH] loaded ["..SACH.GetNumber().."] achievements!")
end
hook.Add("Initialize", "SACH.Initialize", Initialize)

















