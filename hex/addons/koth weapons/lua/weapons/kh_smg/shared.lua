
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.HoldType			= "smg"

end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("smg")  
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	--SWEP.PrintName = "KH SMG"
	SWEP.DrawCrosshair	= true
	SWEP.IconLetter = "/"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	--killicon.AddFont( "kh_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"
SWEP.Category			= "United Hosts"
SWEP.PrintName			= "KH SMG!"
SWEP.Author				= "HeX"
SWEP.Purpose			= "Automatic Fire, Magazine Discharge"
SWEP.Instructions		= "Mouse1 = Fire, Mouse2 = Change mode."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel	= "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Firemodes = { "Automatic Fire", "Magazine Discharge" }

SWEP.SprintPos = Vector(-2.5363, -10.2105, -4.0824)
SWEP.SprintAng = Vector(31.4104, 1.2127, -0.8824)

SWEP.Primary.Sound			= Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.Reload         = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Primary.ModeChange		= Sound("weapons/smg1/switch_single.wav")
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound        = Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Secondary.Reload       = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/smg1/switch_burst.wav")
SWEP.Secondary.Damage		= 5
SWEP.Secondary.NumShots		= 2
SWEP.Secondary.Cone			= 0.075
SWEP.Secondary.Delay        = 0.070

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
	elseif not self.Discharge then
	
		self.Discharge = 0
	
	end
end

function SWEP:Deploy()

	self.Discharge = nil

	if SERVER then
		self:SetFiremode(1)
		self:SetViewModelPosition()
	end	

	self:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:Think()

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.Discharge and self.Discharge < CurTime() then
	
		if self.Owner:KeyDown(IN_SPEED) then
			self:SetClip1(0)
			self:ProperReload()
			self.Discharge = nil
			return
		end
	
		if self:Clip1() < 1 then
			self:ProperReload()
			self.Discharge = nil
			return
		end
	
		self.Discharge = CurTime() + self.Secondary.Delay 

		self:EmitSound( self.Secondary.Sound, 100, math.random(120,130) )
		self:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
		self:TakePrimaryAmmo( 2 )
	
		return
		
	end
end

function SWEP:Reload()

	self:ProperReload()
	
end

function SWEP:ProperReload()
	self:DefaultReload( ACT_VM_RELOAD )
	if not self.ReloadPlay then
		self.Discharge = nil
		self.ReloadPlay = true
		self:EmitSound( self.Primary.Reload )
	end
end


----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.HoldType			= "smg"

end

--fucking update 78
function SWEP:Initialize()  
	self:SetWeaponHoldType("smg")  
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	--SWEP.PrintName = "KH SMG"
	SWEP.DrawCrosshair	= true
	SWEP.IconLetter = "/"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	--killicon.AddFont( "kh_smg", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"
SWEP.Category			= "United Hosts"
SWEP.PrintName			= "KH SMG!"
SWEP.Author				= "HeX"
SWEP.Purpose			= "Automatic Fire, Magazine Discharge"
SWEP.Instructions		= "Mouse1 = Fire, Mouse2 = Change mode."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel	= "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.Firemodes = { "Automatic Fire", "Magazine Discharge" }

SWEP.SprintPos = Vector(-2.5363, -10.2105, -4.0824)
SWEP.SprintAng = Vector(31.4104, 1.2127, -0.8824)

SWEP.Primary.Sound			= Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.Reload         = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Primary.ModeChange		= Sound("weapons/smg1/switch_single.wav")
SWEP.Primary.Damage			= 8
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true

SWEP.Secondary.Sound        = Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Secondary.Reload       = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Secondary.ModeChange	= Sound("weapons/smg1/switch_burst.wav")
SWEP.Secondary.Damage		= 5
SWEP.Secondary.NumShots		= 2
SWEP.Secondary.Cone			= 0.075
SWEP.Secondary.Delay        = 0.070

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self:GetFiremode() == 1 then

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		self:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		
	elseif not self.Discharge then
	
		self.Discharge = 0
	
	end
end

function SWEP:Deploy()

	self.Discharge = nil

	if SERVER then
		self:SetFiremode(1)
		self:SetViewModelPosition()
	end	

	self:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:Think()

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.Discharge and self.Discharge < CurTime() then
	
		if self.Owner:KeyDown(IN_SPEED) then
			self:SetClip1(0)
			self:ProperReload()
			self.Discharge = nil
			return
		end
	
		if self:Clip1() < 1 then
			self:ProperReload()
			self.Discharge = nil
			return
		end
	
		self.Discharge = CurTime() + self.Secondary.Delay 

		self:EmitSound( self.Secondary.Sound, 100, math.random(120,130) )
		self:ShootBullets( self.Secondary.Damage, self.Secondary.NumShots, self.Secondary.Cone )
		self:TakePrimaryAmmo( 2 )
	
		return
		
	end
end

function SWEP:Reload()

	self:ProperReload()
	
end

function SWEP:ProperReload()
	self:DefaultReload( ACT_VM_RELOAD )
	if not self.ReloadPlay then
		self.Discharge = nil
		self.ReloadPlay = true
		self:EmitSound( self.Primary.Reload )
	end
end

