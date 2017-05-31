
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

include('shared.lua')


SWEP.PrintName			= "#HL2_Pulse_Rifle"	// 'Nice' Weapon name (Shown on HUD)
SWEP.ClassName			= "swep_ar2"
--string.Strip( GetScriptPath(), "weapons/" )
SWEP.Slot				= 2						// Slot in the weapon selection menu
SWEP.SlotPos			= 1						// Position in the slot
SWEP.DrawAmmo			= true					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?

// Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectFont		= "TitleFont"
SWEP.WepSelectLetter	= "l"
SWEP.IconFont			= "HL2MPTypeDeath"
SWEP.IconLetter			= "2"

killicon.AddFont( SWEP.ClassName, SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )


	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end


--[[
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	// Set us up the texture
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( self.WepSelectFont )
	local w, h = surface.GetTextSize( self.WepSelectLetter )

	// Draw that mother
	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( self.WepSelectLetter )

end
]]



----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

include('shared.lua')


SWEP.PrintName			= "#HL2_Pulse_Rifle"	// 'Nice' Weapon name (Shown on HUD)
SWEP.ClassName			= "swep_ar2"
--string.Strip( GetScriptPath(), "weapons/" )
SWEP.Slot				= 2						// Slot in the weapon selection menu
SWEP.SlotPos			= 1						// Position in the slot
SWEP.DrawAmmo			= true					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?

// Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectFont		= "TitleFont"
SWEP.WepSelectLetter	= "l"
SWEP.IconFont			= "HL2MPTypeDeath"
SWEP.IconLetter			= "2"

killicon.AddFont( SWEP.ClassName, SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )


	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end


--[[
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	// Set us up the texture
	surface.SetDrawColor( color_transparent )
	surface.SetTextColor( 255, 220, 0, alpha )
	surface.SetFont( self.WepSelectFont )
	local w, h = surface.GetTextSize( self.WepSelectLetter )

	// Draw that mother
	surface.SetTextPos( x + ( wide / 2 ) - ( w / 2 ),
						y + ( tall / 2 ) - ( h / 2 ) )
	surface.DrawText( self.WepSelectLetter )

end
]]


