
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if ( SERVER ) then
    AddCSLuaFile( "shared.lua" )
end

SWEP.Category                = "United Hosts"
SWEP.PrintName                = "Plasma SMG"
SWEP.Author                    = "Arcadium Software + HeX"
SWEP.Contact                = "cdbarrett@gmail.com"
SWEP.Purpose                = "Destroy your enemy!"
SWEP.Instructions            = "Left click to fire a pulse of energy."

SWEP.ViewModel                = "models/weapons/v_smg1.mdl"
SWEP.WorldModel                = "models/weapons/w_smg1.mdl"
SWEP.ViewModelFOV            = 52

SWEP.Slot                    = 2
SWEP.SlotPos                = 1
SWEP.Weight                    = 5
SWEP.AutoSwitchTo            = true
SWEP.AutoSwitchFrom            = false

SWEP.SwayScale                = 2.0
SWEP.BobScale                = 2.0

SWEP.Primary.Reload         = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Primary.ClipSize        = 40
SWEP.Primary.DefaultClip    = 255
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.125
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "SMG1"

SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"

SWEP.Spawnable                = true
SWEP.AdminSpawnable            = true

SWEP.IronSightsAng            = Vector( 0, 0, 0 )
SWEP.IronSightsPos            = Vector( -6.45, -8, 2.55 )

local EmptySound            = Sound( "buttons/combine_button1.wav" )
local ShootSound            = Sound( "npc/combine_gunship/attack_start2.wav" )

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

	SWEP.IconLetter		= "/"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 128, 255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont( "plasma_smg", "HL2MPTypeDeath", "/", Color( 255, 128, 255, 255 ) )
end


function SWEP:Initialize()
    self:SetWeaponHoldType( "smg" )
	
    self:InstallDataTable() -- networked variables
    self:DTVar( "Bool", 0, "IronSights" )
	
    if( CLIENT ) then
        self.LastIronSights = false
        self.IronSightsTime = 0
    end
	
    if( SERVER ) then  
        self.dt.IronSights = false
        self.NextIdleTime = CurTime()
    end
end


function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.Hit and not tr.HitSky ) then -- having the impact effect on the sky looks strange, ditch it
        local effect = EffectData()
            effect:SetOrigin( tr.HitPos )
            effect:SetNormal( tr.HitNormal )
        util.Effect( "NomadImpact", effect )
    end
    return true
end


function SWEP:CanPrimaryAttack()
	if( self:Clip1() >= 1 ) then -- have enough ammo to fire?
		return true
	else
		self:Reload()
		return false
	end
end


function SWEP:PrimaryAttack()
    if( not self:CanPrimaryAttack() ) then -- bail if we can't fire
        self:EmitSound( EmptySound )
        self:SetNextPrimaryFire( CurTime() + 0.4 )
        return
    end
    
    if( SERVER ) then
        self:TakePrimaryAmmo( 1 )
        self.IdleTime = CurTime() + 0.4 -- idle
    end

	
    local bullet = {
        Num            = 1,
        Src            = self.Owner:GetShootPos(),
        Dir            = self.Owner:GetAimVector(),
        Spread        = Vector( 0.02, 0.02, 0 ),
        Tracer        = 1,
        Force        = 10,
        Damage        = 15,
        AmmoType    = "Pistol",
        TracerName    = "NomadTracer",
        Attacker    = self.Owner,
        Inflictor    = self,
    }
    self:FireBullets( bullet ) -- fire the bullet
    
    -- sound & animation
    self:EmitSound( ShootSound, 100, math.random( 200, 250 ) )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	if not self.Owner.SetAnimation then
		return
	end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    -- handle weapon idle times
    if( SERVER ) then
        self.NextIdleTime = CurTime() + self:SequenceDuration()
    end
    
    -- some view punching to make it not so static.
    if( self.Owner:IsPlayer() ) then
        self.Owner:ViewPunch( Angle( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ) )
    end

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "NomadMuzzle", effect )

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) -- we're an automatic weapon, have a decent fire rate
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
	if self:DefaultReload( ACT_VM_RELOAD ) then
		self:EmitSound( self.Primary.Reload )
	end
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    if( SERVER ) then
        self:ToggleIronSights()
    end
    self:SetNextSecondaryFire( CurTime() + 0.25 )
end

function SWEP:Think()
    if( SERVER ) then
        if( self.NextIdleTime <= CurTime() ) then -- do idle
            self:SendWeaponAnim( ACT_VM_IDLE )
            self.NextIdleTime = CurTime() + self:SequenceDuration()
        end
    end
end


function SWEP:Deploy()
    if( SERVER ) then
        self.dt.IronSights = false
    end
end


function SWEP:Holster()
    if( SERVER ) then
        self.Owner:CrosshairEnable()
    end
    return true
end


if( CLIENT ) then

    function SWEP:GetTracerOrigin()
        local pos, ang = GetMuzzlePosition( self )
        return pos
    end
	
    function SWEP:GetViewModelPosition( pos, ang )
        local ironsights = self.dt.IronSights
		
        if( self.LastIronSights != ironsights ) then -- just changed
            self.LastIronSights = ironsights
            self.IronSightsTime = CurTime()
            
            if( ironsights ) then -- modify sway/bob scales
                self.SwayScale = 0.1
                self.BobScale = 0.15
            else
                self.SwayScale = 2
                self.BobScale = 2
            end
        end
        
        local ironTime = self.IronSightsTime
        local time = CurTime() - 0.25
        
        if( not ironsights and ironTime < time ) then -- not in ironsights, return default position
            return pos, ang
        end
        
       
        local frac = 1
        if( ironTime > time ) then -- figure out the fraction for transitioning
            frac = math.Clamp( ( CurTime() - ironTime ) / 0.25, 0, 1 )
			
            if( not ironsights ) then
                frac = 1 - frac
            end
        end
        
        local offset = self.IronSightsPos
        if( self.IronSightsAng ) then
            ang = ang * 1
            ang:RotateAroundAxis( ang:Right(), self.IronSightsAng.x * frac )
            ang:RotateAroundAxis( ang:Up(), self.IronSightsAng.y * frac )
            ang:RotateAroundAxis( ang:Forward(), self.IronSightsAng.z * frac )
        end
        
        pos = pos + offset.x * ang:Right() * frac
        pos = pos + offset.y * ang:Forward() * frac
        pos = pos + offset.z * ang:Up() * frac
		
        return pos, ang 
    end
end


if( SERVER ) then
    function SWEP:ToggleIronSights()
        self.dt.IronSights = not self.dt.IronSights
    end
	
    function SWEP:GetCapabilities()
        return 139264 --CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1
    end
end


local function GetMuzzlePosition( weapon, attachment )
    if( not IsValid( weapon ) ) then
        return vector_origin, vector_up
    end

    local origin = weapon:GetPos()
    local angle = weapon:GetAngles()

    if( weapon:IsWeapon() and weapon:IsCarriedByLocalPlayer() ) then -- if we're not in a camera and we're being carried by the local playeru, se their view model instead.
        local owner = weapon:GetOwner()
        if( IsValid( owner ) and GetViewEntity() == owner ) then
            local viewmodel = owner:GetViewModel()
            if( IsValid( viewmodel ) ) then
                weapon = viewmodel
            end
        end
    end
    
    local attachment = weapon:GetAttachment( attachment or 1 )
    if( not attachment ) then -- get the attachment
        return origin, angle
    end
    return attachment.Pos, attachment.Ang
end


if( CLIENT ) then

    local GlowMaterial = CreateMaterial( "arcadiumsoft/glow", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/light_glow01",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
	
    function EFFECT:Init( data )
        self.Weapon = data:GetEntity()
        
        self:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        self:SetParent( self.Weapon )
        
        self.LifeTime = math.Rand( 0.25, 0.35 )
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 16, 24 )
        
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local light = DynamicLight( self:EntIndex() ) -- emit a burst of light
            light.Pos            = pos
            light.Size            = 200
            light.Decay            = 400
            light.R                = 255
            light.G                = 128
            light.B                = 255
            light.Brightness    = 2
            light.DieTime        = CurTime() + 0.35
    end
	
    function EFFECT:Think()
        return IsValid( self.Weapon ) and self.DieTime >= CurTime()
    end
	
	
    function EFFECT:Render()
        if( not IsValid( self.Weapon ) ) then -- how'd this happen?
            return
        end
		
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
        local alpha = 255 * percent
        
        render.SetMaterial( GlowMaterial )
		
       -- for i = 1, 2 do -- draw it twice to double the brightness D:
            render.DrawSprite( pos, self.Size, self.Size, Color( 255, 128, 255, alpha ) )
            render.StartBeam( 2 )
                render.AddBeam( pos - ang:Forward() * 48, 16, 0, Color( 255, 128, 255, alpha ) )
                render.AddBeam( pos + ang:Forward() * 64, 16, 1, Color( 255, 128, 255, 0 ) )
            render.EndBeam()
       --end
    end
    effects.Register( EFFECT, "NomadMuzzle" )
end


if( CLIENT ) then

    local GlowMaterial = CreateMaterial( "arcadiumsoft/glow", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/light_glow01",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
    
    function EFFECT:Init( data )
        local pos = data:GetOrigin()
        local normal = data:GetNormal()
        
        self.Position = pos
        self.Normal = normal
        
        self.LifeTime = math.Rand( 0.25, 0.35 ) -- 0.25, 0.35
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 32, 48 )
        
        local emitter = ParticleEmitter( pos )
        for i = 1, 32 do -- impact particles
            local particle = emitter:Add( "sprites/glow04_noz", pos + normal * 2 )
            particle:SetVelocity( ( normal + VectorRand() * 0.75 ):GetNormal() * math.Rand( 75, 125 ) )
            particle:SetDieTime( math.Rand( 0.5, 1.25 ) )
            particle:SetStartAlpha( 255 )
            particle:SetEndAlpha( 0 )
            particle:SetStartSize( math.Rand( 1, 2 ) )
            particle:SetEndSize( 0 )
            particle:SetRoll( 0 )
            particle:SetColor( 255, 128, 255 )
            particle:SetGravity( Vector( 0, 0, -250 ) )
            particle:SetCollide( true )
            particle:SetBounce( 0.3 )
            particle:SetAirResistance( 5 )
        end
        emitter:Finish()
		
        local light = DynamicLight( 0 ) -- emit a burst of light
            light.Pos            = pos
            light.Size            = 64
            light.Decay            = 256
            light.R                = 255
            light.G                = 128
            light.B                = 255
            light.Brightness    = 2
            light.DieTime        = CurTime() + 0.35
    end
	
	
    function EFFECT:Think()
        return self.DieTime >= CurTime()
    end
	
	
    function EFFECT:Render()
        local pos, normal = self.Position, self.Normal
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
        local alpha = 255 * percent
        
        render.SetMaterial( GlowMaterial ) -- draw the muzzle flash as a series of sprites
        render.DrawQuadEasy( pos + normal, normal, self.Size, self.Size, Color( 255, 128, 255, alpha ) )
    end
    effects.Register( EFFECT, "NomadImpact" )
end


if( CLIENT ) then

    local SparkMaterial = CreateMaterial( "arcadiumsoft/spark", "UnlitGeneric", {
        [ "$basetexture" ]    = "effects/spark",
        [ "$brightness" ]    = "effects/spark_brightness",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
    
    function EFFECT:Init( data )
        local weapon = data:GetEntity()
        local attachment = data:GetAttachment()
                
        local startPos = GetMuzzlePosition( weapon, attachment )
        local endPos = data:GetOrigin()
        local distance = ( startPos - endPos ):Length()
        
        self.StartPos = startPos
        self.EndPos = endPos
        self.Normal = ( endPos - startPos ):GetNormal()
        self.Length = math.random( 128, 500 )
        self.StartTime = CurTime()
        self.DieTime = CurTime() + ( distance + self.Length ) / 5000
    end

    function EFFECT:Think()
        return self.DieTime >= CurTime()
    end
	
    function EFFECT:Render()
        local time = CurTime() - self.StartTime
        local endDistance = 5000 * time
        local startDistance = endDistance - self.Length
        
        startDistance = math.max( 0, startDistance ) -- clamp the start distance so we don't extend behind the weapon
        
        local startPos = self.StartPos + self.Normal * startDistance
        local endPos = self.StartPos + self.Normal * endDistance
        
        render.SetMaterial( SparkMaterial ) -- draw the beam
        render.DrawBeam( startPos, endPos, 8, 0, 1, Color( 255, 128, 255, 255 ) )
    end
    effects.Register( EFFECT, "NomadTracer" )
end



----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------
if ( SERVER ) then
    AddCSLuaFile( "shared.lua" )
end

SWEP.Category                = "United Hosts"
SWEP.PrintName                = "Plasma SMG"
SWEP.Author                    = "Arcadium Software + HeX"
SWEP.Contact                = "cdbarrett@gmail.com"
SWEP.Purpose                = "Destroy your enemy!"
SWEP.Instructions            = "Left click to fire a pulse of energy."

SWEP.ViewModel                = "models/weapons/v_smg1.mdl"
SWEP.WorldModel                = "models/weapons/w_smg1.mdl"
SWEP.ViewModelFOV            = 52

SWEP.Slot                    = 2
SWEP.SlotPos                = 1
SWEP.Weight                    = 5
SWEP.AutoSwitchTo            = true
SWEP.AutoSwitchFrom            = false

SWEP.SwayScale                = 2.0
SWEP.BobScale                = 2.0

SWEP.Primary.Reload         = Sound("weapons/smg1/smg1_reload.wav")
SWEP.Primary.ClipSize        = 40
SWEP.Primary.DefaultClip    = 255
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.125
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "SMG1"

SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"

SWEP.Spawnable                = true
SWEP.AdminSpawnable            = true

SWEP.IronSightsAng            = Vector( 0, 0, 0 )
SWEP.IronSightsPos            = Vector( -6.45, -8, 2.55 )

local EmptySound            = Sound( "buttons/combine_button1.wav" )
local ShootSound            = Sound( "npc/combine_gunship/attack_start2.wav" )

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

	SWEP.IconLetter		= "/"

	-- Draw weapon info box
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "HL2MPTypeDeath", x + wide/2, y + tall/2.5, Color( 255, 128, 255, 255 ), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end

	killicon.AddFont( "plasma_smg", "HL2MPTypeDeath", "/", Color( 255, 128, 255, 255 ) )
end


function SWEP:Initialize()
    self:SetWeaponHoldType( "smg" )
	
    self:InstallDataTable() -- networked variables
    self:DTVar( "Bool", 0, "IronSights" )
	
    if( CLIENT ) then
        self.LastIronSights = false
        self.IronSightsTime = 0
    end
	
    if( SERVER ) then  
        self.dt.IronSights = false
        self.NextIdleTime = CurTime()
    end
end


function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.Hit and not tr.HitSky ) then -- having the impact effect on the sky looks strange, ditch it
        local effect = EffectData()
            effect:SetOrigin( tr.HitPos )
            effect:SetNormal( tr.HitNormal )
        util.Effect( "NomadImpact", effect )
    end
    return true
end


function SWEP:CanPrimaryAttack()
	if( self:Clip1() >= 1 ) then -- have enough ammo to fire?
		return true
	else
		self:Reload()
		return false
	end
end


function SWEP:PrimaryAttack()
    if( not self:CanPrimaryAttack() ) then -- bail if we can't fire
        self:EmitSound( EmptySound )
        self:SetNextPrimaryFire( CurTime() + 0.4 )
        return
    end
    
    if( SERVER ) then
        self:TakePrimaryAmmo( 1 )
        self.IdleTime = CurTime() + 0.4 -- idle
    end

	
    local bullet = {
        Num            = 1,
        Src            = self.Owner:GetShootPos(),
        Dir            = self.Owner:GetAimVector(),
        Spread        = Vector( 0.02, 0.02, 0 ),
        Tracer        = 1,
        Force        = 10,
        Damage        = 15,
        AmmoType    = "Pistol",
        TracerName    = "NomadTracer",
        Attacker    = self.Owner,
        Inflictor    = self,
    }
    self:FireBullets( bullet ) -- fire the bullet
    
    -- sound & animation
    self:EmitSound( ShootSound, 100, math.random( 200, 250 ) )
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	if not self.Owner.SetAnimation then
		return
	end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    
    -- handle weapon idle times
    if( SERVER ) then
        self.NextIdleTime = CurTime() + self:SequenceDuration()
    end
    
    -- some view punching to make it not so static.
    if( self.Owner:IsPlayer() ) then
        self.Owner:ViewPunch( Angle( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ) )
    end

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "NomadMuzzle", effect )

    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) -- we're an automatic weapon, have a decent fire rate
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
	if self:DefaultReload( ACT_VM_RELOAD ) then
		self:EmitSound( self.Primary.Reload )
	end
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    if( SERVER ) then
        self:ToggleIronSights()
    end
    self:SetNextSecondaryFire( CurTime() + 0.25 )
end

function SWEP:Think()
    if( SERVER ) then
        if( self.NextIdleTime <= CurTime() ) then -- do idle
            self:SendWeaponAnim( ACT_VM_IDLE )
            self.NextIdleTime = CurTime() + self:SequenceDuration()
        end
    end
end


function SWEP:Deploy()
    if( SERVER ) then
        self.dt.IronSights = false
    end
end


function SWEP:Holster()
    if( SERVER ) then
        self.Owner:CrosshairEnable()
    end
    return true
end


if( CLIENT ) then

    function SWEP:GetTracerOrigin()
        local pos, ang = GetMuzzlePosition( self )
        return pos
    end
	
    function SWEP:GetViewModelPosition( pos, ang )
        local ironsights = self.dt.IronSights
		
        if( self.LastIronSights != ironsights ) then -- just changed
            self.LastIronSights = ironsights
            self.IronSightsTime = CurTime()
            
            if( ironsights ) then -- modify sway/bob scales
                self.SwayScale = 0.1
                self.BobScale = 0.15
            else
                self.SwayScale = 2
                self.BobScale = 2
            end
        end
        
        local ironTime = self.IronSightsTime
        local time = CurTime() - 0.25
        
        if( not ironsights and ironTime < time ) then -- not in ironsights, return default position
            return pos, ang
        end
        
       
        local frac = 1
        if( ironTime > time ) then -- figure out the fraction for transitioning
            frac = math.Clamp( ( CurTime() - ironTime ) / 0.25, 0, 1 )
			
            if( not ironsights ) then
                frac = 1 - frac
            end
        end
        
        local offset = self.IronSightsPos
        if( self.IronSightsAng ) then
            ang = ang * 1
            ang:RotateAroundAxis( ang:Right(), self.IronSightsAng.x * frac )
            ang:RotateAroundAxis( ang:Up(), self.IronSightsAng.y * frac )
            ang:RotateAroundAxis( ang:Forward(), self.IronSightsAng.z * frac )
        end
        
        pos = pos + offset.x * ang:Right() * frac
        pos = pos + offset.y * ang:Forward() * frac
        pos = pos + offset.z * ang:Up() * frac
		
        return pos, ang 
    end
end


if( SERVER ) then
    function SWEP:ToggleIronSights()
        self.dt.IronSights = not self.dt.IronSights
    end
	
    function SWEP:GetCapabilities()
        return 139264 --CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1
    end
end


local function GetMuzzlePosition( weapon, attachment )
    if( not IsValid( weapon ) ) then
        return vector_origin, vector_up
    end

    local origin = weapon:GetPos()
    local angle = weapon:GetAngles()

    if( weapon:IsWeapon() and weapon:IsCarriedByLocalPlayer() ) then -- if we're not in a camera and we're being carried by the local playeru, se their view model instead.
        local owner = weapon:GetOwner()
        if( IsValid( owner ) and GetViewEntity() == owner ) then
            local viewmodel = owner:GetViewModel()
            if( IsValid( viewmodel ) ) then
                weapon = viewmodel
            end
        end
    end
    
    local attachment = weapon:GetAttachment( attachment or 1 )
    if( not attachment ) then -- get the attachment
        return origin, angle
    end
    return attachment.Pos, attachment.Ang
end


if( CLIENT ) then

    local GlowMaterial = CreateMaterial( "arcadiumsoft/glow", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/light_glow01",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
	
    function EFFECT:Init( data )
        self.Weapon = data:GetEntity()
        
        self:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        self:SetParent( self.Weapon )
        
        self.LifeTime = math.Rand( 0.25, 0.35 )
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 16, 24 )
        
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local light = DynamicLight( self:EntIndex() ) -- emit a burst of light
            light.Pos            = pos
            light.Size            = 200
            light.Decay            = 400
            light.R                = 255
            light.G                = 128
            light.B                = 255
            light.Brightness    = 2
            light.DieTime        = CurTime() + 0.35
    end
	
    function EFFECT:Think()
        return IsValid( self.Weapon ) and self.DieTime >= CurTime()
    end
	
	
    function EFFECT:Render()
        if( not IsValid( self.Weapon ) ) then -- how'd this happen?
            return
        end
		
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
        local alpha = 255 * percent
        
        render.SetMaterial( GlowMaterial )
		
       -- for i = 1, 2 do -- draw it twice to double the brightness D:
            render.DrawSprite( pos, self.Size, self.Size, Color( 255, 128, 255, alpha ) )
            render.StartBeam( 2 )
                render.AddBeam( pos - ang:Forward() * 48, 16, 0, Color( 255, 128, 255, alpha ) )
                render.AddBeam( pos + ang:Forward() * 64, 16, 1, Color( 255, 128, 255, 0 ) )
            render.EndBeam()
       --end
    end
    effects.Register( EFFECT, "NomadMuzzle" )
end


if( CLIENT ) then

    local GlowMaterial = CreateMaterial( "arcadiumsoft/glow", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/light_glow01",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
    
    function EFFECT:Init( data )
        local pos = data:GetOrigin()
        local normal = data:GetNormal()
        
        self.Position = pos
        self.Normal = normal
        
        self.LifeTime = math.Rand( 0.25, 0.35 ) -- 0.25, 0.35
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 32, 48 )
        
        local emitter = ParticleEmitter( pos )
        for i = 1, 32 do -- impact particles
            local particle = emitter:Add( "sprites/glow04_noz", pos + normal * 2 )
            particle:SetVelocity( ( normal + VectorRand() * 0.75 ):GetNormal() * math.Rand( 75, 125 ) )
            particle:SetDieTime( math.Rand( 0.5, 1.25 ) )
            particle:SetStartAlpha( 255 )
            particle:SetEndAlpha( 0 )
            particle:SetStartSize( math.Rand( 1, 2 ) )
            particle:SetEndSize( 0 )
            particle:SetRoll( 0 )
            particle:SetColor( 255, 128, 255 )
            particle:SetGravity( Vector( 0, 0, -250 ) )
            particle:SetCollide( true )
            particle:SetBounce( 0.3 )
            particle:SetAirResistance( 5 )
        end
        emitter:Finish()
		
        local light = DynamicLight( 0 ) -- emit a burst of light
            light.Pos            = pos
            light.Size            = 64
            light.Decay            = 256
            light.R                = 255
            light.G                = 128
            light.B                = 255
            light.Brightness    = 2
            light.DieTime        = CurTime() + 0.35
    end
	
	
    function EFFECT:Think()
        return self.DieTime >= CurTime()
    end
	
	
    function EFFECT:Render()
        local pos, normal = self.Position, self.Normal
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
        local alpha = 255 * percent
        
        render.SetMaterial( GlowMaterial ) -- draw the muzzle flash as a series of sprites
        render.DrawQuadEasy( pos + normal, normal, self.Size, self.Size, Color( 255, 128, 255, alpha ) )
    end
    effects.Register( EFFECT, "NomadImpact" )
end


if( CLIENT ) then

    local SparkMaterial = CreateMaterial( "arcadiumsoft/spark", "UnlitGeneric", {
        [ "$basetexture" ]    = "effects/spark",
        [ "$brightness" ]    = "effects/spark_brightness",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } )
    
    local EFFECT = {}
    
    function EFFECT:Init( data )
        local weapon = data:GetEntity()
        local attachment = data:GetAttachment()
                
        local startPos = GetMuzzlePosition( weapon, attachment )
        local endPos = data:GetOrigin()
        local distance = ( startPos - endPos ):Length()
        
        self.StartPos = startPos
        self.EndPos = endPos
        self.Normal = ( endPos - startPos ):GetNormal()
        self.Length = math.random( 128, 500 )
        self.StartTime = CurTime()
        self.DieTime = CurTime() + ( distance + self.Length ) / 5000
    end

    function EFFECT:Think()
        return self.DieTime >= CurTime()
    end
	
    function EFFECT:Render()
        local time = CurTime() - self.StartTime
        local endDistance = 5000 * time
        local startDistance = endDistance - self.Length
        
        startDistance = math.max( 0, startDistance ) -- clamp the start distance so we don't extend behind the weapon
        
        local startPos = self.StartPos + self.Normal * startDistance
        local endPos = self.StartPos + self.Normal * endDistance
        
        render.SetMaterial( SparkMaterial ) -- draw the beam
        render.DrawBeam( startPos, endPos, 8, 0, 1, Color( 255, 128, 255, 255 ) )
    end
    effects.Register( EFFECT, "NomadTracer" )
end


