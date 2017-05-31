
----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------
local PANEL = {}

function PANEL:Init()	
	self:SetBackgroundBlur( true )
	
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 250, 120 )
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	self:SetPos( (self.ScrW/2 - self:GetWide()/2), (self.ScrH/2 - self:GetTall()/2) )
	
	self.Close = vgui.Create( "DSysButton", self )
	self.Close:SetType( "close" )
	self.Close:SetCursor("hand")
	self.Close:SetPos(self:GetWide()-22, 3)
	self.Close:SetSize(19, 19)
	self.Close.DoClick = function() self:Remove() end
	self.Close:SetDrawBorder( false )
	self.Close:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self:SetLabel()
	self:SetTitle2()
	
	self.FinalFunction = function() end
	self.StoreData = ""
	
end

function PANEL:SetTitle2( strTitle )
	self.Title2 = strTitle or "FSA Text Entry"
end

function PANEL:SetLabel( str )
	self.LabelText = str or "Text Entry 1"
end

function PANEL:SetFunction( func )
	self.FinalFunction = func or function() end
	self:BuildInput()
end

function PANEL:SetStoreData( data )
	self.StoreData = data or ""
end

function PANEL:Paint()
	draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color(38,38,38,255))
	draw.RoundedBoxEx( 8, 3, 40, self:GetWide()-6, self:GetTall()-43, Color(237,237,237,255), false, false, true, true )
	surface.SetDrawColor( 2, 2, 2, 255 )
	surface.SetTexture( surface.GetTextureID("gui/gradient_up") )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 40 )
	draw.SimpleText( self.Title2, "TargetIDSmall", self:GetWide()/2, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:BuildInput()
	
	self.TextObject = vgui.Create("DTextEntry", self)
	self.TextObject:SetSize( self:GetWide()-30, 20 )
	self.TextObject:SetPos( 15, 60 )
	self.TextObject:SetMultiline(false)
	self.TextObject:SetText("")
	self.TextObject:SetEditable( true )
	self.TextObject:SetEnterAllowed( true )
	self.TextObject.OnEnter = function() self.OkObject:DoClick() end
	self.TextObject:RequestFocus()
	
	self.TextObjectLabel = vgui.Create("DLabel", self)
	self.TextObjectLabel:SetText( self.LabelText )
	self.TextObjectLabel:SetTextColor( Color(0, 0, 0, 255) )
	self.TextObjectLabel:SetPos( 15, 45 )
	self.TextObjectLabel:SizeToContents()
	
	self.OkObject = vgui.Create("DButton", self)
	self.OkObject:SetText( "Ok" )
	self.OkObject:SetSize( 50, 20 )
	self.OkObject:SetPos( 190, self:GetTall()-30 )
	self.OkObject.DoClick = function() self.FinalFunction(); self:Remove() end
	
	self.Cancel = vgui.Create("DButton", self)
	self.Cancel:SetText( "Cancel" )
	self.Cancel:SetSize( 50, 20 )
	self.Cancel:SetPos( 120, self:GetTall()-30 )
	self.Cancel.DoClick = function() self:Remove() end
end

derma.DefineControl( "fsaTextInput", "fsaTextInput", PANEL, "DFrame" )

----------------------------------------
--         2014-07-12 20:33:10          --
------------------------------------------
local PANEL = {}

function PANEL:Init()	
	self:SetBackgroundBlur( true )
	
	self:SetFocusTopLevel( true )
	self:SetCursor( "arrow" )
	self:SetSize( 250, 120 )
	self.ScrW = ScrW()
	self.ScrH = ScrH()
	self:SetPos( (self.ScrW/2 - self:GetWide()/2), (self.ScrH/2 - self:GetTall()/2) )
	
	self.Close = vgui.Create( "DSysButton", self )
	self.Close:SetType( "close" )
	self.Close:SetCursor("hand")
	self.Close:SetPos(self:GetWide()-22, 3)
	self.Close:SetSize(19, 19)
	self.Close.DoClick = function() self:Remove() end
	self.Close:SetDrawBorder( false )
	self.Close:SetDrawBackground( true )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:MakePopup()
	
	self:SetLabel()
	self:SetTitle2()
	
	self.FinalFunction = function() end
	self.StoreData = ""
	
end

function PANEL:SetTitle2( strTitle )
	self.Title2 = strTitle or "FSA Text Entry"
end

function PANEL:SetLabel( str )
	self.LabelText = str or "Text Entry 1"
end

function PANEL:SetFunction( func )
	self.FinalFunction = func or function() end
	self:BuildInput()
end

function PANEL:SetStoreData( data )
	self.StoreData = data or ""
end

function PANEL:Paint()
	draw.RoundedBox( 8, 0, 0, self:GetWide(), self:GetTall(), Color(38,38,38,255))
	draw.RoundedBoxEx( 8, 3, 40, self:GetWide()-6, self:GetTall()-43, Color(237,237,237,255), false, false, true, true )
	surface.SetDrawColor( 2, 2, 2, 255 )
	surface.SetTexture( surface.GetTextureID("gui/gradient_up") )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 40 )
	draw.SimpleText( self.Title2, "TargetIDSmall", self:GetWide()/2, 30, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:BuildInput()
	
	self.TextObject = vgui.Create("DTextEntry", self)
	self.TextObject:SetSize( self:GetWide()-30, 20 )
	self.TextObject:SetPos( 15, 60 )
	self.TextObject:SetMultiline(false)
	self.TextObject:SetText("")
	self.TextObject:SetEditable( true )
	self.TextObject:SetEnterAllowed( true )
	self.TextObject.OnEnter = function() self.OkObject:DoClick() end
	self.TextObject:RequestFocus()
	
	self.TextObjectLabel = vgui.Create("DLabel", self)
	self.TextObjectLabel:SetText( self.LabelText )
	self.TextObjectLabel:SetTextColor( Color(0, 0, 0, 255) )
	self.TextObjectLabel:SetPos( 15, 45 )
	self.TextObjectLabel:SizeToContents()
	
	self.OkObject = vgui.Create("DButton", self)
	self.OkObject:SetText( "Ok" )
	self.OkObject:SetSize( 50, 20 )
	self.OkObject:SetPos( 190, self:GetTall()-30 )
	self.OkObject.DoClick = function() self.FinalFunction(); self:Remove() end
	
	self.Cancel = vgui.Create("DButton", self)
	self.Cancel:SetText( "Cancel" )
	self.Cancel:SetSize( 50, 20 )
	self.Cancel:SetPos( 120, self:GetTall()-30 )
	self.Cancel.DoClick = function() self:Remove() end
end

derma.DefineControl( "fsaTextInput", "fsaTextInput", PANEL, "DFrame" )
