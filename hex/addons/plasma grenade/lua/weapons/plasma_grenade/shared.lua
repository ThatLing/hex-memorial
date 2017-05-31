
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/plasma_grenade.vmt")
	resource.AddFile("materials/vgui/entities/plasma_grenade.vtf")
end

--if turret explode, add kill and select icons

SWEP.Category                = "United Hosts"
SWEP.Purpose                = "Roll a grenade in there!"
SWEP.Instructions            = "Mouse1=Trow Mouse2=Drop"

SWEP.PrintName            = "Plasma Grenade"            
SWEP.Author                = "JusticeInACan + HeX"
SWEP.Slot                = 4
SWEP.SlotPos            = 1

SWEP.DrawAmmo            = false
SWEP.DrawCrosshair        = true
SWEP.ViewModelFOV        = 55
SWEP.ViewModelFlip        = false

SWEP.HoldType            = "grenade"

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true

SWEP.ViewModel            = "models/weapons/v_Grenade.mdl"
SWEP.WorldModel            = "models/weapons/W_grenade.mdl"
--SWEP.WorldModel            = "models/dav0r/hoverball.mdl"

SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false

SWEP.Primary.Delay                = 0.75

SWEP.Primary.ClipSize            = 1
SWEP.Primary.DefaultClip        = 1
SWEP.Primary.Automatic            = true
SWEP.Primary.Ammo                = "grenade"

SWEP.Secondary.ClipSize            = -1
SWEP.Secondary.DefaultClip        = -1
SWEP.Secondary.Automatic        = true
SWEP.Secondary.Ammo                = "none"

SWEP.NextThrow = CurTime()
SWEP.NextAnimation = CurTime()
SWEP.Throwing = false
SWEP.StartThrow = false
SWEP.ResetThrow = false
SWEP.Tossed = false
SWEP.ThrowVel = 1500



SWEP.IconLetter		= "4"

if (CLIENT) then

	function SWEP:PrintWeaponInfo(x, y, alpha)
		if (self.DrawWeaponInfoBox == false) then return end
		
		if (self.InfoMarkup == nil) then
			local str
			local title_color = "<color = 130, 0, 0, 255>"
			local text_color = "<color = 255, 255, 255, 200>"
			
			str = "<font=HudSelectionText>"
			if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
			if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
			if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
			if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
			str = str .. "</font>"
			
			self.InfoMarkup = markup.Parse(str, 250)
		end

		alpha = 180
		
		surface.SetDrawColor(0, 0, 0, alpha)
		surface.SetTexture(self.SpeechBubbleLid)
		
		surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
		draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
		
		self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
	end

	SWEP.IconLetter		= "4"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0,200,255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont("plasma_grenade", "HL2MPTypeDeath", "4", Color( 0,200,255, 255 ) )
end







function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

if CLIENT then
    --[[
    local function ShrinkHands(self,count,pcount)
        local grenade = self:LookupBone("ValveBiped.Grenade_body")
        local matr = self:GetBoneMatrix(grenade)
		print("! hands: ", matr, grenade)
        if matr then
            matr:Scale(vector_origin)
            self:SetBoneMatrix(grenade, matr)
        end
    end
    
    local function ResetHands(self,count,pcount)
        local grenade = self:LookupBone("ValveBiped.Grenade_body")
        local matr = self:GetBoneMatrix(grenade)
        if matr then
            matr:Scale(Vector(1,1,1))
            self:SetBoneMatrix(grenade,matr)
        end
    end
	
    function SWEP:ShrinkViewModel(cmodel)
        if IsValid(cmodel) then
            cmodel:SetupBones()
            cmodel.BuildBonePositions = ShrinkHands
			ShrinkHands(self)
        end
    end
    
    function SWEP:ResetViewModel(cmodel)
        if IsValid(cmodel) then
            cmodel:SetupBones()
            cmodel.BuildBonePositions = ResetHands
        end
    end
    ]]
    function SWEP:CreateViewProp()
        self.CSModel = ClientsideModel("models/dav0r/hoverball.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
        if self.CSModel && self.CSModel:IsValid() then
            self.CSModel:SetPos(self:GetPos())
            self.CSModel:SetAngles(self:GetAngles())
            self.CSModel:SetParent(self)
            self.CSModel:SetNoDraw(true)
        end
    end

end

function SWEP:ViewModelDrawn()

    local vm = self.Owner:GetViewModel()
    
    if self.Owner && self.Owner:IsValid() && vm && vm:IsValid() then
    
        local mdl = self.CSModel
        local bone = vm:LookupBone("ValveBiped.Grenade_body")
        
        if mdl && mdl:IsValid() then
            local vmang = Angle(120,30,90)
            local vmpos = Vector(-0.75,-0.70,1.25)

            local pos = vm:GetBonePosition(bone)
            local ang = vm:GetAngles()
            
            mdl:SetPos(pos + ang:Forward() * vmpos.x + ang:Right() * vmpos.y + ang:Up() * vmpos.z)
            
            ang:RotateAroundAxis(ang:Up(), vmang.y)
            ang:RotateAroundAxis(ang:Right(), vmang.p)
            ang:RotateAroundAxis(ang:Forward(), vmang.r)
            
            mdl:SetAngles(ang)
           -- mdl:SetModelScale( Vector(0.35,0.35,0.35), 0)
            mdl:SetModelScale(0.35, 0)
            
            render.SetColorModulation(0/255, 200/255, 1)
            render.SetBlend(1)
            mdl:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
            
        else
			--[[
            self:ShrinkViewModel( self.Owner:GetViewModel() )
            timer.Simple(0, function()
				self.CreateViewProp(self)
			end)
			]]
        end
    
    end
    
end

function SWEP:Deploy()

    if game.SinglePlayer() then
        self:CallOnClient("Deploy", "")
    end

    self.StartThrow = false
    self.Throwing = false
    self.ResetThrow = false

    if !self.Throwing then
    
        self:SendWeaponAnim(ACT_VM_DRAW)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        
        if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 && self:Clip1() <= 0 then
            self.Owner:RemoveAmmo(1, self.Primary.Ammo)
            self:SetClip1(self:Clip1()+1)
        end
        
    end
    
    return true    
    
end

function SWEP:Holster()

    if game.SinglePlayer() then
        self:CallOnClient("Holster", "")
    end

    self.StartThrow = false
    self.Throwing = false
    self.ResetThrow = false
    
	--[[
    if CLIENT then
        if self.CSModel && self.CSModel:IsValid() then self.CSModel:Remove() end
        if self.Owner && self.Owner:IsValid() && self.Owner:GetViewModel() then
           self:ResetViewModel(self.Owner:GetViewModel())
        end
    end
    ]]
    return true
    
end

function SWEP:OnRemove()
    if game.SinglePlayer() then
        self:CallOnClient("OnRemove", "")
    end
    
	--[[
    if CLIENT then
        if self.CSModel && self.CSModel:IsValid() then self.CSModel:Remove() end
        if self.Owner && self.Owner:IsValid() && self.Owner:GetViewModel() then
            self:ResetViewModel(self.Owner:GetViewModel())
        end
    end
	]]
end

function SWEP:CreateGrenade()

    if self.Owner && self.Owner:IsValid() && self.Weapon && self:IsValid() then

        if (SERVER) then
        
            local ent = ents.Create("plasma_grenade_grenade")
            if !ent then return end
            ent.Owner = self.Owner
            ent.Inflictor = self.Weapon
            ent:SetOwner(self.Owner)        
            local eyeang = self.Owner:GetAimVector():Angle()
            local right = eyeang:Right()
            local up = eyeang:Up()
            if self.Tossed then
                ent:SetPos(self.Owner:GetShootPos()+right*4-up*4)
            else
                ent:SetPos(self.Owner:GetShootPos()+right*4+up*4)
            end
            ent:SetAngles(self.Owner:GetAngles())
            ent:SetPhysicsAttacker(self.Owner)
            ent:Spawn()
                
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() then
                phys:SetVelocity(self.Owner:GetAimVector() * self.ThrowVel + (self.Owner:GetVelocity() * 0.75))
            end
            
        end
    
    end
    
end

function SWEP:Think()

    if self.Owner:KeyDown(IN_ATTACK2) then
        self.ThrowVel = 700
        self.Tossed = true
    elseif self.Owner:KeyDown(IN_ATTACK) then
        self.ThrowVel = 1500
        self.Tossed = false
    end

    if self.StartThrow && !self.Owner:KeyDown(IN_ATTACK) && !self.Owner:KeyDown(IN_ATTACK2) && self.NextThrow < CurTime() then
    
        self.StartThrow = false
        self.Throwing = true
        if self.Tossed then
            self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        else
            self:SendWeaponAnim(ACT_VM_THROW)
        end
        self.Owner:SetAnimation(PLAYER_ATTACK1)        
        self:CreateGrenade(self.Owner, self.Weapon)
        self:TakePrimaryAmmo(1)
        self.NextAnimation = CurTime() + self.Primary.Delay
        self.ResetThrow = true
        
    end
    
    if self.Throwing && self.ResetThrow && self.NextAnimation < CurTime() then
    
        if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 && self:Clip1() <= 0 then
        
            self.Owner:RemoveAmmo(1, self.Primary.Ammo)
            self:SetClip1(self:Clip1()+1)
            self:SendWeaponAnim(ACT_VM_DRAW)
            self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
            self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            
        else
            self.Owner:ConCommand("lastinv")
        end
        
        self.ResetThrow = false
        self.Throwing = false
        
    end
    
end

function SWEP:CanPrimaryAttack()
    if self.Throwing || ( self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 && self:Clip1() <= 0 ) then
        return false
    end
    
    return true
end

function SWEP:PrimaryAttack()
    if (!self:CanPrimaryAttack()) then return end
    if !self.Throwing && !self.StartThrow then
        self.StartThrow = true
        self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    end
end

function SWEP:SecondaryAttack()
    if (!self:CanPrimaryAttack()) then return end
    if !self.Throwing && !self.StartThrow then
        self.StartThrow = true
        self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    end
end

function SWEP:Reload()
end

 

----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------

if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	resource.AddFile("materials/vgui/entities/plasma_grenade.vmt")
	resource.AddFile("materials/vgui/entities/plasma_grenade.vtf")
end

--if turret explode, add kill and select icons

SWEP.Category                = "United Hosts"
SWEP.Purpose                = "Roll a grenade in there!"
SWEP.Instructions            = "Mouse1=Trow Mouse2=Drop"

SWEP.PrintName            = "Plasma Grenade"            
SWEP.Author                = "JusticeInACan + HeX"
SWEP.Slot                = 4
SWEP.SlotPos            = 1

SWEP.DrawAmmo            = false
SWEP.DrawCrosshair        = true
SWEP.ViewModelFOV        = 55
SWEP.ViewModelFlip        = false

SWEP.HoldType            = "grenade"

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true

SWEP.ViewModel            = "models/weapons/v_Grenade.mdl"
SWEP.WorldModel            = "models/weapons/W_grenade.mdl"
--SWEP.WorldModel            = "models/dav0r/hoverball.mdl"

SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false

SWEP.Primary.Delay                = 0.75

SWEP.Primary.ClipSize            = 1
SWEP.Primary.DefaultClip        = 1
SWEP.Primary.Automatic            = true
SWEP.Primary.Ammo                = "grenade"

SWEP.Secondary.ClipSize            = -1
SWEP.Secondary.DefaultClip        = -1
SWEP.Secondary.Automatic        = true
SWEP.Secondary.Ammo                = "none"

SWEP.NextThrow = CurTime()
SWEP.NextAnimation = CurTime()
SWEP.Throwing = false
SWEP.StartThrow = false
SWEP.ResetThrow = false
SWEP.Tossed = false
SWEP.ThrowVel = 1500



SWEP.IconLetter		= "4"

if (CLIENT) then

	function SWEP:PrintWeaponInfo(x, y, alpha)
		if (self.DrawWeaponInfoBox == false) then return end
		
		if (self.InfoMarkup == nil) then
			local str
			local title_color = "<color = 130, 0, 0, 255>"
			local text_color = "<color = 255, 255, 255, 200>"
			
			str = "<font=HudSelectionText>"
			if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
			if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
			if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
			if (self.Instructions!= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
			str = str .. "</font>"
			
			self.InfoMarkup = markup.Parse(str, 250)
		end

		alpha = 180
		
		surface.SetDrawColor(0, 0, 0, alpha)
		surface.SetTexture(self.SpeechBubbleLid)
		
		surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
		draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))
		
		self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
	end

	SWEP.IconLetter		= "4"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 0,200,255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont("plasma_grenade", "HL2MPTypeDeath", "4", Color( 0,200,255, 255 ) )
end







function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

if CLIENT then
    --[[
    local function ShrinkHands(self,count,pcount)
        local grenade = self:LookupBone("ValveBiped.Grenade_body")
        local matr = self:GetBoneMatrix(grenade)
		print("! hands: ", matr, grenade)
        if matr then
            matr:Scale(vector_origin)
            self:SetBoneMatrix(grenade, matr)
        end
    end
    
    local function ResetHands(self,count,pcount)
        local grenade = self:LookupBone("ValveBiped.Grenade_body")
        local matr = self:GetBoneMatrix(grenade)
        if matr then
            matr:Scale(Vector(1,1,1))
            self:SetBoneMatrix(grenade,matr)
        end
    end
	
    function SWEP:ShrinkViewModel(cmodel)
        if IsValid(cmodel) then
            cmodel:SetupBones()
            cmodel.BuildBonePositions = ShrinkHands
			ShrinkHands(self)
        end
    end
    
    function SWEP:ResetViewModel(cmodel)
        if IsValid(cmodel) then
            cmodel:SetupBones()
            cmodel.BuildBonePositions = ResetHands
        end
    end
    ]]
    function SWEP:CreateViewProp()
        self.CSModel = ClientsideModel("models/dav0r/hoverball.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
        if self.CSModel && self.CSModel:IsValid() then
            self.CSModel:SetPos(self:GetPos())
            self.CSModel:SetAngles(self:GetAngles())
            self.CSModel:SetParent(self)
            self.CSModel:SetNoDraw(true)
        end
    end

end

function SWEP:ViewModelDrawn()

    local vm = self.Owner:GetViewModel()
    
    if self.Owner && self.Owner:IsValid() && vm && vm:IsValid() then
    
        local mdl = self.CSModel
        local bone = vm:LookupBone("ValveBiped.Grenade_body")
        
        if mdl && mdl:IsValid() then
            local vmang = Angle(120,30,90)
            local vmpos = Vector(-0.75,-0.70,1.25)

            local pos = vm:GetBonePosition(bone)
            local ang = vm:GetAngles()
            
            mdl:SetPos(pos + ang:Forward() * vmpos.x + ang:Right() * vmpos.y + ang:Up() * vmpos.z)
            
            ang:RotateAroundAxis(ang:Up(), vmang.y)
            ang:RotateAroundAxis(ang:Right(), vmang.p)
            ang:RotateAroundAxis(ang:Forward(), vmang.r)
            
            mdl:SetAngles(ang)
           -- mdl:SetModelScale( Vector(0.35,0.35,0.35), 0)
            mdl:SetModelScale(0.35, 0)
            
            render.SetColorModulation(0/255, 200/255, 1)
            render.SetBlend(1)
            mdl:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)
            
        else
			--[[
            self:ShrinkViewModel( self.Owner:GetViewModel() )
            timer.Simple(0, function()
				self.CreateViewProp(self)
			end)
			]]
        end
    
    end
    
end

function SWEP:Deploy()

    if game.SinglePlayer() then
        self:CallOnClient("Deploy", "")
    end

    self.StartThrow = false
    self.Throwing = false
    self.ResetThrow = false

    if !self.Throwing then
    
        self:SendWeaponAnim(ACT_VM_DRAW)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        
        if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 && self:Clip1() <= 0 then
            self.Owner:RemoveAmmo(1, self.Primary.Ammo)
            self:SetClip1(self:Clip1()+1)
        end
        
    end
    
    return true    
    
end

function SWEP:Holster()

    if game.SinglePlayer() then
        self:CallOnClient("Holster", "")
    end

    self.StartThrow = false
    self.Throwing = false
    self.ResetThrow = false
    
	--[[
    if CLIENT then
        if self.CSModel && self.CSModel:IsValid() then self.CSModel:Remove() end
        if self.Owner && self.Owner:IsValid() && self.Owner:GetViewModel() then
           self:ResetViewModel(self.Owner:GetViewModel())
        end
    end
    ]]
    return true
    
end

function SWEP:OnRemove()
    if game.SinglePlayer() then
        self:CallOnClient("OnRemove", "")
    end
    
	--[[
    if CLIENT then
        if self.CSModel && self.CSModel:IsValid() then self.CSModel:Remove() end
        if self.Owner && self.Owner:IsValid() && self.Owner:GetViewModel() then
            self:ResetViewModel(self.Owner:GetViewModel())
        end
    end
	]]
end

function SWEP:CreateGrenade()

    if self.Owner && self.Owner:IsValid() && self.Weapon && self:IsValid() then

        if (SERVER) then
        
            local ent = ents.Create("plasma_grenade_grenade")
            if !ent then return end
            ent.Owner = self.Owner
            ent.Inflictor = self.Weapon
            ent:SetOwner(self.Owner)        
            local eyeang = self.Owner:GetAimVector():Angle()
            local right = eyeang:Right()
            local up = eyeang:Up()
            if self.Tossed then
                ent:SetPos(self.Owner:GetShootPos()+right*4-up*4)
            else
                ent:SetPos(self.Owner:GetShootPos()+right*4+up*4)
            end
            ent:SetAngles(self.Owner:GetAngles())
            ent:SetPhysicsAttacker(self.Owner)
            ent:Spawn()
                
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() then
                phys:SetVelocity(self.Owner:GetAimVector() * self.ThrowVel + (self.Owner:GetVelocity() * 0.75))
            end
            
        end
    
    end
    
end

function SWEP:Think()

    if self.Owner:KeyDown(IN_ATTACK2) then
        self.ThrowVel = 700
        self.Tossed = true
    elseif self.Owner:KeyDown(IN_ATTACK) then
        self.ThrowVel = 1500
        self.Tossed = false
    end

    if self.StartThrow && !self.Owner:KeyDown(IN_ATTACK) && !self.Owner:KeyDown(IN_ATTACK2) && self.NextThrow < CurTime() then
    
        self.StartThrow = false
        self.Throwing = true
        if self.Tossed then
            self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        else
            self:SendWeaponAnim(ACT_VM_THROW)
        end
        self.Owner:SetAnimation(PLAYER_ATTACK1)        
        self:CreateGrenade(self.Owner, self.Weapon)
        self:TakePrimaryAmmo(1)
        self.NextAnimation = CurTime() + self.Primary.Delay
        self.ResetThrow = true
        
    end
    
    if self.Throwing && self.ResetThrow && self.NextAnimation < CurTime() then
    
        if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 && self:Clip1() <= 0 then
        
            self.Owner:RemoveAmmo(1, self.Primary.Ammo)
            self:SetClip1(self:Clip1()+1)
            self:SendWeaponAnim(ACT_VM_DRAW)
            self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
            self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            
        else
            self.Owner:ConCommand("lastinv")
        end
        
        self.ResetThrow = false
        self.Throwing = false
        
    end
    
end

function SWEP:CanPrimaryAttack()
    if self.Throwing || ( self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 && self:Clip1() <= 0 ) then
        return false
    end
    
    return true
end

function SWEP:PrimaryAttack()
    if (!self:CanPrimaryAttack()) then return end
    if !self.Throwing && !self.StartThrow then
        self.StartThrow = true
        self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    end
end

function SWEP:SecondaryAttack()
    if (!self:CanPrimaryAttack()) then return end
    if !self.Throwing && !self.StartThrow then
        self.StartThrow = true
        self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    end
end

function SWEP:Reload()
end

 
