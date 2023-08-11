ELEMENT.Name = "Ammo : Primary"
ELEMENT.DefaultOff = false
ELEMENT.DefaultGridPosX = 16
ELEMENT.DefaultGridPosY = 16
ELEMENT.SizeX = nil
ELEMENT.SizeY = nil

ELEMENT.STORmaxammo = {}
ELEMENT.tvars = {}

ELEMENT.colorText   = nil
ELEMENT.colorLesser = nil
ELEMENT.colorEmpty     = Color(255,0,0,92)
ELEMENT.colorEmptyText = Color(255,0,0,192)

function ELEMENT:Initialize( )
end

function ELEMENT:DrawFunction( )
	if LocalPlayer():Alive() then
		local SWEP = LocalPlayer():GetActiveWeapon()
		self.tvars = {}
		if SWEP:IsValid() then
			self.tvars.clip1type = SWEP:GetPrimaryAmmoType() or ""
			self.tvars.clip1     = tonumber(SWEP:Clip1()) or -1
			self.tvars.clip1left = LocalPlayer():GetAmmoCount(self.tvars.clip1type)
		else
			self.tvars.clip1 = -1
			self.tvars.clip1left = -1
		end
		if not self.STORmaxammo[SWEP] then
			self.STORmaxammo[SWEP] = self.tvars.clip1
		elseif self.tvars.clip1 > self.STORmaxammo[SWEP] then
			self.STORmaxammo[SWEP] = self.tvars.clip1
		end
		
		self.tvars.clip1max = tonumber(self.STORmaxammo[SWEP]) or 1
		
		//Sweps, not the phys/gravgun...
		if self.tvars.clip1 >= 0 and self.tvars.clip1type != -1 then	
			self.colorText   = nil
			self.colorLesser = nil
			local smallText = ""
			local rate = -1
			if self.tvars.clip1 <= 0 then
				self.colorLesser = self.colorEmpty
				self.colorText   = self.colorEmptyText
			end
			if self.tvars.clip1left > 0 then
				smallText = self.tvars.clip1left
			else
				smallText = ""
			end
			
			local rate = self.tvars.clip1 / (self.STORmaxammo[SWEP] or 1)
			
			self:DrawGenericInfobox(
	/*Text   */ self.tvars.clip1
	/*Subtxt */ ,smallText
	/* %     */ ,rate
	/*atRight*/ ,true
	/*0.0 col*/ ,self.colorLesser
	/*1.0 col*/ ,self.colorLesser
	/*minSize*/ ,0.0
	/*maxSize*/ ,1.0
	/*blink< */ ,0.0
	/*blinkSz*/ ,1.0
	/*Font   */ ,nil
	/*bStatic*/ ,true
	/*stCol  */ ,self.colorText
	/*stColSm*/ ,nil
			)
		
		//Gravgun/nades
		elseif self.tvars.clip1left > 0 then
			self:DrawGenericInfobox(
	/*Text   */ self.tvars.clip1left
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
