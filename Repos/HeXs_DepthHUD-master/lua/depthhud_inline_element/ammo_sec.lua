ELEMENT.Name = "Ammo : Secondary"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 14
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.tvars = {}

function ELEMENT:Initialize( )
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():Alive() then
		local SWEP = LocalPlayer():GetActiveWeapon()
		self.tvars = {}
		if SWEP:IsValid() then
			self.tvars.clip2type = SWEP:GetSecondaryAmmoType() or ""
			//self.tvars.clip2     = tonumber(SWEP:Clip2()) or 0
			self.tvars.clip2left = LocalPlayer():GetAmmoCount(self.tvars.clip2type)
		else
			//self.tvars.clip2 = -1
			self.tvars.clip2left = -1
		end
		
		if self.tvars.clip2left > 0 then			
			self:DrawGenericInfobox(
	/*Text   */ self.tvars.clip2left
	/*Subtxt */ ,""
	/* %     */ ,-1
	/*atRight*/ ,true
	/*0.0 col*/ ,nil
	/*1.0 col*/ ,nil
	/*minSize*/ ,1.0
	/*maxSize*/ ,1.0
	/*blink< */ ,1.0
	/*blinkSz*/ ,1.0
	/*Font   */ ,nil
	/*bStatic*/ ,true
	/*stCol  */ ,nil
	/*stColSm*/ ,nil
			)
		end
	end
	
	return true
end
