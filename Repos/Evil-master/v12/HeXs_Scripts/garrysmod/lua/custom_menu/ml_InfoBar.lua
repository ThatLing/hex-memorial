
if not IsKida then return end


require( "markup" )

local UpdateLabel = vgui.Create( "DPanel" )

local UpdateText = markup.Parse( "<font=DefaultSmall><color=white>Garry's Mod <color=153,217,234,255>U"..VERSION )

UpdateLabel:SetSize( UpdateText:GetWidth(), UpdateText:GetHeight() )
UpdateLabel:SetPos( 8, 8 )
function UpdateLabel:Paint()
	UpdateText:Draw( 0, 0 )
end