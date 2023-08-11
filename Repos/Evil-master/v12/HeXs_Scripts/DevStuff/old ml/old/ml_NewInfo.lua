require( "markup" )
include( "includes/extensions/global_cl.lua" )

local texGradient = surface.GetTextureID( "gui/gradient" )

surface.CreateFont( "coolvetica", ScreenScale( 10 ), 500, true, false, "gmod_version" )

local UpdateLabel = vgui.Create( "DPanel" )

local UpdateText = markup.Parse( "<font=gmod_version><color=white>garry's mod <color=153,217,234,255>update " .. VERSION )
UpdateLabel:SetSize( UpdateText:GetWidth() * 1.5, UpdateText:GetHeight() + 2 )

function UpdateLabel:Paint()
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.SetTexture( texGradient )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )

	draw.SimpleText( string.format( "garry's mod update %s", VERSION ), "gmod_version", 9, 1, Color( 150, 150, 150, 255 ) )
	UpdateText:Draw( 8, 0 )
end

function UpdateLabel:OnMouseReleased( mc )
	if mc == MOUSE_LEFT then
		gui.OpenURL( "http://store.steampowered.com/news/?appids=4000" )
	end
end