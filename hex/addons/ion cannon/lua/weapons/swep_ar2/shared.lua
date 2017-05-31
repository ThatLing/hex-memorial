
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


// Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"
SWEP.AnimPrefix		= "ar2"
SWEP.HoldType		= "ar2"

// Note: This is how it should have worked. The base weapon would set the category
// then all of the children would have inherited that.
// But a lot of SWEPS have based themselves on this base (probably not on purpose)
// So the category name is now defined in all of the child SWEPS.
//SWEP.Category			= "Half-Life 2"
SWEP.m_bFiresUnderwater	= false;
SWEP.m_fFireDuration	= 0.0;
SWEP.m_nShotsFired		= 0;

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Reload			= Sound( "Weapon_AR2.Reload" )
SWEP.Primary.Empty			= Sound( "Weapon_IRifle.Empty" )
SWEP.Primary.Sound			= Sound( "Weapon_AR2.Single" )
SWEP.Primary.Damage			= 11
SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.Primary.Cone			= VECTOR_CONE_3DEGREES
SWEP.Primary.ClipSize		= 30				// Size of a clip
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 60				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.Tracer			= 2
SWEP.Primary.TracerName		= "AR2Tracer"

SWEP.Secondary.Empty		= SWEP.Primary.Empty
SWEP.Secondary.Sound		= Sound( "Weapon_IRifle.Single" )
SWEP.Secondary.Special1		= Sound( "Weapon_CombineGuard.Special1" )
SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.Delay		= 0.5
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "AR2AltFire"



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end

	self:SetWeaponHoldType( self.HoldType )

end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;
	if (!pPlayer) then
		return;
	end

	// Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	if ( self:Clip1() <= 0 && self.Primary.ClipSize > -1 ) then
		if ( self:Ammo1() > 0 ) then
			self:EmitSound( self.Primary.Empty );
			self:Reload();
		else
			self:EmitSound( self.Primary.Empty );
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
		end

		return;
	end

	if ( self.m_bIsUnderwater && !self.m_bFiresUnderwater ) then
		self:EmitSound( self.Primary.Empty );
		self:SetNextPrimaryFire( CurTime() + 0.2 );

		return;
	end

	// Abort here to handle burst and auto fire modes
	if ( (self.Primary.ClipSize > -1 && self:Clip1() == 0) || ( self.Primary.ClipSize <= -1 && !pPlayer:GetAmmoCount(self.Primary.Ammo) ) ) then
		return;
	end

	pPlayer:MuzzleFlash();

	// To make the firing framerate independent, we may have to fire more than one bullet here on low-framerate systems,
	// especially if the weapon we're firing has a really fast rate of fire.
	local iBulletsToFire = 0;
	local fireRate = self.Primary.Delay;

	// MUST call sound before removing a round from the clip of a CHLMachineGun
	self:EmitSound(self.Primary.Sound);
	self:SetNextPrimaryFire( CurTime() + fireRate );
	iBulletsToFire = iBulletsToFire + self.Primary.NumShots;

	// Make sure we don't fire more than the amount in the clip, if this weapon uses clips
	if ( self.Primary.ClipSize > -1 ) then
		if ( iBulletsToFire > self:Clip1() ) then
			iBulletsToFire = self:Clip1();
		end
		self:TakePrimaryAmmo( self.Primary.NumAmmo );
	end

	self:ShootBullet( self.Primary.Damage, iBulletsToFire, self.Primary.Cone );

	//Factor in the view kick
	if ( !pPlayer:IsNPC() ) then
		self:AddViewKick();
	end

	--self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	pPlayer:SetAnimation( PLAYER_ATTACK1 );

	self.m_nShotsFired = self.m_nShotsFired + 1

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:DoMachineGunKick( pPlayer, dampEasy, maxVerticleKickAngle, fireDurationTime, slideLimitTime )

	local	KICK_MIN_X			= 0.2	//Degrees
	local	KICK_MIN_Y			= 0.2	//Degrees
	local	KICK_MIN_Z			= 0.1	//Degrees

	local vecScratch = Angle( 0, 0, 0 );

	//Find how far into our accuracy degradation we are
	local duration;
	if ( fireDurationTime > slideLimitTime ) then
		duration	= slideLimitTime
	else
		duration	= fireDurationTime;
	end
	local kickPerc = duration / slideLimitTime;

	// do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset( 10 );

	//Apply this to the view angles as well
	vecScratch.pitch = -( KICK_MIN_X + ( maxVerticleKickAngle * kickPerc ) );
	vecScratch.yaw = -( KICK_MIN_Y + ( maxVerticleKickAngle * kickPerc ) ) / 3;
	vecScratch.roll = KICK_MIN_Z + ( maxVerticleKickAngle * kickPerc ) / 8;

	//Wibble left and right
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.yaw = vecScratch.yaw * -1;
	end

	//Wobble up and down
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.roll = vecScratch.roll * -1;
	end

	//Clip this to our desired min/max
	// vecScratch = UTIL_ClipPunchAngleOffset( vecScratch, vec3_angle, Angle( 24.0, 3.0, 1.0 ) );

	//Add it to the view punch
	// NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	pPlayer:ViewPunch( vecScratch * 0.5 );

end

//-----------------------------------------------------------------------------
// Purpose:
// Input  : &tr -
//			nDamageType -
//-----------------------------------------------------------------------------
function SWEP:DoImpactEffect( tr )

	local data = EffectData();

	data:SetOrigin( tr.HitPos + ( tr.HitNormal * 1.0 ) );
	data:SetNormal( tr.HitNormal );

	util.Effect( "AR2Impact", data );

end

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:DelayedAttack()

	self.m_bShotDelayed = false;

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

	// Deplete the clip completely
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() );

	// Register a muzzleflash for the AI
	pOwner:MuzzleFlash();

	self:EmitSound( self.Secondary.Sound );

	// Fire the bullets
	local vecSrc	 = pOwner:GetShootPos();
	local vecAiming = pOwner:GetAimVector();

	// Fire the bullets
	local vecVelocity = vecAiming * 1000.0;

if ( !CLIENT ) then
	// Fire the combine ball
	local pBall = ents.Create( "prop_combine_ball" )
						pBall:SetOwner( pOwner );
						pBall:SetPhysicsAttacker( pOwner );
						pBall:SetPos( vecSrc );

						pBall:SetVelocity( vecVelocity );
						pBall:Spawn();

						pBall:GetPhysicsObject():AddGameFlag( FVPHYSICS_DMG_DISSOLVE );
						pBall:GetPhysicsObject():AddGameFlag( FVPHYSICS_WAS_THROWN );
						pBall:GetPhysicsObject():SetVelocity( vecVelocity );
						pBall:EmitSound( "NPC_CombineBall.Launch" );
						pBall:SetModel( "models/Effects/combineball.mdl" );

	// View effects
	local white = Color(255, 255, 255, 64);
	//UTIL_ScreenFade( pOwner, white, 0.1, 0, FFADE_IN  );
end

	//Disorient the player
	local angles = pOwner:EyeAngles();

	angles.pitch = angles.pitch + math.random( -4, 4 );
	angles.yaw   = angles.pitch + math.random( -4, 4 );
	angles.roll  = 0;

//	pOwner:SnapEyeAngles( angles );

	pOwner:ViewPunch( Angle( -math.random( 8, 12 ), math.random( 1, 2 ), 0 ) );

	// Decrease ammo
	pOwner:RemoveAmmo( 1, self.Secondary.Ammo );

	// Can shoot again immediately
	self:SetNextPrimaryFire( CurTime() + 0.5 );

	// Can blow up after a short delay (so have time to release mouse button)
	self:SetNextSecondaryFire( CurTime() + 1.0 );

end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	if ( self.m_bShotDelayed ) then
		return;
	end

	// Cannot fire underwater
	if ( ( self.Owner && self.Owner:WaterLevel() == 3 ) || self:Ammo2() <= 0 ) then
		self:SendWeaponAnim( ACT_VM_DRYFIRE );
		self:EmitSound( self.Secondary.Empty );
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay );
		return;
	end

	self.m_bShotDelayed = true;
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay );
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay );
	self.m_flDelayedFire = CurTime() + self.Secondary.Delay;

	self:SendWeaponAnim( ACT_VM_FIDGET );
	self:EmitSound( self.Secondary.Special1 );

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()

	local fRet;
	local fCacheTime = self.Secondary.Delay;

	self.m_fFireDuration = 0.0;

	fRet = self:DefaultReload( ACT_VM_RELOAD );
	if ( fRet ) then
		// Undo whatever the reload process has done to our secondary
		// attack timer. We allow you to interrupt reloading to fire
		// a grenade.
		self:SetNextSecondaryFire( CurTime() + fCacheTime );

		self:EmitSound( self.Primary.Reload );

	end

	return fRet;

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:AddViewKick()

	local	EASY_DAMPEN			= 0.5
	local	MAX_VERTICAL_KICK	= 8.0	//Degrees
	local	SLIDE_LIMIT			= 5.0	//Seconds

	//Get the view kick
	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

	self:DoMachineGunKick( pPlayer, EASY_DAMPEN, MAX_VERTICAL_KICK, self.m_fFireDuration, SLIDE_LIMIT );

end

/*---------------------------------------------------------
   Name: SWEP:PreThink( )
   Desc: Called before every frame
---------------------------------------------------------*/
function SWEP:PreThink()
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()

	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	self:PreThink();

	if ( pPlayer:WaterLevel() >= 3 ) then
		self.m_bIsUnderwater = true;
	else
		self.m_bIsUnderwater = false;
	end

	if ( pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration	= self.m_fFireDuration + FrameTime();
	elseif ( !pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration	= 0.0;
		self.m_nShotsFired		= 0;
	end

	// See if we need to fire off our secondary round
	if ( self.m_bShotDelayed && CurTime() > self.m_flDelayedFire ) then
		self:DelayedAttack();
	end

	self.BaseClass:Think();

end


/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetDeploySpeed( self:SequenceDuration() )

	self.m_fFireDuration	= 0.0;
	self.m_bShotDelayed		= false;
	self.m_flDelayedFire	= 0.0;

	return true

end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	local pHL2MPPlayer = pPlayer;

		// Fire the bullets
	local info = {};
	info.Num = num_bullets;
	info.Src = pHL2MPPlayer:GetShootPos();
	info.Dir = pPlayer:GetAimVector();
	info.Spread = aimcone;
	info.Damage = damage;
	info.Tracer = self.Primary.Tracer;
	info.TracerName = self.Primary.TracerName;

	info.Owner = self.Owner
	info.Weapon = self.Weapon

	info.DoImpactEffect = self.DoImpactEffect;
	info.ShootCallback = self.ShootCallback;

	info.Callback = function( attacker, trace, dmginfo )
		info:DoImpactEffect( trace );
		return info:ShootCallback( attacker, trace, dmginfo );
	end

	pPlayer:FireBullets( info );

end


/*---------------------------------------------------------
   Name: SWEP:ShootCallback( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootCallback( attacker, trace, dmginfo )
end


/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	return true
end


/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()
	return true
end


/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self:SetNextPrimaryFire( CurTime() + speed )
	self:SetNextSecondaryFire( CurTime() + speed )

end



----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


// Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"
SWEP.AnimPrefix		= "ar2"
SWEP.HoldType		= "ar2"

// Note: This is how it should have worked. The base weapon would set the category
// then all of the children would have inherited that.
// But a lot of SWEPS have based themselves on this base (probably not on purpose)
// So the category name is now defined in all of the child SWEPS.
//SWEP.Category			= "Half-Life 2"
SWEP.m_bFiresUnderwater	= false;
SWEP.m_fFireDuration	= 0.0;
SWEP.m_nShotsFired		= 0;

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Reload			= Sound( "Weapon_AR2.Reload" )
SWEP.Primary.Empty			= Sound( "Weapon_IRifle.Empty" )
SWEP.Primary.Sound			= Sound( "Weapon_AR2.Single" )
SWEP.Primary.Damage			= 11
SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.Primary.Cone			= VECTOR_CONE_3DEGREES
SWEP.Primary.ClipSize		= 30				// Size of a clip
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 60				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.Tracer			= 2
SWEP.Primary.TracerName		= "AR2Tracer"

SWEP.Secondary.Empty		= SWEP.Primary.Empty
SWEP.Secondary.Sound		= Sound( "Weapon_IRifle.Single" )
SWEP.Secondary.Special1		= Sound( "Weapon_CombineGuard.Special1" )
SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.Delay		= 0.5
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "AR2AltFire"



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end

	self:SetWeaponHoldType( self.HoldType )

end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;
	if (!pPlayer) then
		return;
	end

	// Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	if ( self:Clip1() <= 0 && self.Primary.ClipSize > -1 ) then
		if ( self:Ammo1() > 0 ) then
			self:EmitSound( self.Primary.Empty );
			self:Reload();
		else
			self:EmitSound( self.Primary.Empty );
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
		end

		return;
	end

	if ( self.m_bIsUnderwater && !self.m_bFiresUnderwater ) then
		self:EmitSound( self.Primary.Empty );
		self:SetNextPrimaryFire( CurTime() + 0.2 );

		return;
	end

	// Abort here to handle burst and auto fire modes
	if ( (self.Primary.ClipSize > -1 && self:Clip1() == 0) || ( self.Primary.ClipSize <= -1 && !pPlayer:GetAmmoCount(self.Primary.Ammo) ) ) then
		return;
	end

	pPlayer:MuzzleFlash();

	// To make the firing framerate independent, we may have to fire more than one bullet here on low-framerate systems,
	// especially if the weapon we're firing has a really fast rate of fire.
	local iBulletsToFire = 0;
	local fireRate = self.Primary.Delay;

	// MUST call sound before removing a round from the clip of a CHLMachineGun
	self:EmitSound(self.Primary.Sound);
	self:SetNextPrimaryFire( CurTime() + fireRate );
	iBulletsToFire = iBulletsToFire + self.Primary.NumShots;

	// Make sure we don't fire more than the amount in the clip, if this weapon uses clips
	if ( self.Primary.ClipSize > -1 ) then
		if ( iBulletsToFire > self:Clip1() ) then
			iBulletsToFire = self:Clip1();
		end
		self:TakePrimaryAmmo( self.Primary.NumAmmo );
	end

	self:ShootBullet( self.Primary.Damage, iBulletsToFire, self.Primary.Cone );

	//Factor in the view kick
	if ( !pPlayer:IsNPC() ) then
		self:AddViewKick();
	end

	--self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	pPlayer:SetAnimation( PLAYER_ATTACK1 );

	self.m_nShotsFired = self.m_nShotsFired + 1

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:DoMachineGunKick( pPlayer, dampEasy, maxVerticleKickAngle, fireDurationTime, slideLimitTime )

	local	KICK_MIN_X			= 0.2	//Degrees
	local	KICK_MIN_Y			= 0.2	//Degrees
	local	KICK_MIN_Z			= 0.1	//Degrees

	local vecScratch = Angle( 0, 0, 0 );

	//Find how far into our accuracy degradation we are
	local duration;
	if ( fireDurationTime > slideLimitTime ) then
		duration	= slideLimitTime
	else
		duration	= fireDurationTime;
	end
	local kickPerc = duration / slideLimitTime;

	// do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset( 10 );

	//Apply this to the view angles as well
	vecScratch.pitch = -( KICK_MIN_X + ( maxVerticleKickAngle * kickPerc ) );
	vecScratch.yaw = -( KICK_MIN_Y + ( maxVerticleKickAngle * kickPerc ) ) / 3;
	vecScratch.roll = KICK_MIN_Z + ( maxVerticleKickAngle * kickPerc ) / 8;

	//Wibble left and right
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.yaw = vecScratch.yaw * -1;
	end

	//Wobble up and down
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.roll = vecScratch.roll * -1;
	end

	//Clip this to our desired min/max
	// vecScratch = UTIL_ClipPunchAngleOffset( vecScratch, vec3_angle, Angle( 24.0, 3.0, 1.0 ) );

	//Add it to the view punch
	// NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	pPlayer:ViewPunch( vecScratch * 0.5 );

end

//-----------------------------------------------------------------------------
// Purpose:
// Input  : &tr -
//			nDamageType -
//-----------------------------------------------------------------------------
function SWEP:DoImpactEffect( tr )

	local data = EffectData();

	data:SetOrigin( tr.HitPos + ( tr.HitNormal * 1.0 ) );
	data:SetNormal( tr.HitNormal );

	util.Effect( "AR2Impact", data );

end

//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:DelayedAttack()

	self.m_bShotDelayed = false;

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

	// Deplete the clip completely
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() );

	// Register a muzzleflash for the AI
	pOwner:MuzzleFlash();

	self:EmitSound( self.Secondary.Sound );

	// Fire the bullets
	local vecSrc	 = pOwner:GetShootPos();
	local vecAiming = pOwner:GetAimVector();

	// Fire the bullets
	local vecVelocity = vecAiming * 1000.0;

if ( !CLIENT ) then
	// Fire the combine ball
	local pBall = ents.Create( "prop_combine_ball" )
						pBall:SetOwner( pOwner );
						pBall:SetPhysicsAttacker( pOwner );
						pBall:SetPos( vecSrc );

						pBall:SetVelocity( vecVelocity );
						pBall:Spawn();

						pBall:GetPhysicsObject():AddGameFlag( FVPHYSICS_DMG_DISSOLVE );
						pBall:GetPhysicsObject():AddGameFlag( FVPHYSICS_WAS_THROWN );
						pBall:GetPhysicsObject():SetVelocity( vecVelocity );
						pBall:EmitSound( "NPC_CombineBall.Launch" );
						pBall:SetModel( "models/Effects/combineball.mdl" );

	// View effects
	local white = Color(255, 255, 255, 64);
	//UTIL_ScreenFade( pOwner, white, 0.1, 0, FFADE_IN  );
end

	//Disorient the player
	local angles = pOwner:EyeAngles();

	angles.pitch = angles.pitch + math.random( -4, 4 );
	angles.yaw   = angles.pitch + math.random( -4, 4 );
	angles.roll  = 0;

//	pOwner:SnapEyeAngles( angles );

	pOwner:ViewPunch( Angle( -math.random( 8, 12 ), math.random( 1, 2 ), 0 ) );

	// Decrease ammo
	pOwner:RemoveAmmo( 1, self.Secondary.Ammo );

	// Can shoot again immediately
	self:SetNextPrimaryFire( CurTime() + 0.5 );

	// Can blow up after a short delay (so have time to release mouse button)
	self:SetNextSecondaryFire( CurTime() + 1.0 );

end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	if ( self.m_bShotDelayed ) then
		return;
	end

	// Cannot fire underwater
	if ( ( self.Owner && self.Owner:WaterLevel() == 3 ) || self:Ammo2() <= 0 ) then
		self:SendWeaponAnim( ACT_VM_DRYFIRE );
		self:EmitSound( self.Secondary.Empty );
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay );
		return;
	end

	self.m_bShotDelayed = true;
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay );
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay );
	self.m_flDelayedFire = CurTime() + self.Secondary.Delay;

	self:SendWeaponAnim( ACT_VM_FIDGET );
	self:EmitSound( self.Secondary.Special1 );

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()

	local fRet;
	local fCacheTime = self.Secondary.Delay;

	self.m_fFireDuration = 0.0;

	fRet = self:DefaultReload( ACT_VM_RELOAD );
	if ( fRet ) then
		// Undo whatever the reload process has done to our secondary
		// attack timer. We allow you to interrupt reloading to fire
		// a grenade.
		self:SetNextSecondaryFire( CurTime() + fCacheTime );

		self:EmitSound( self.Primary.Reload );

	end

	return fRet;

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:AddViewKick()

	local	EASY_DAMPEN			= 0.5
	local	MAX_VERTICAL_KICK	= 8.0	//Degrees
	local	SLIDE_LIMIT			= 5.0	//Seconds

	//Get the view kick
	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

	self:DoMachineGunKick( pPlayer, EASY_DAMPEN, MAX_VERTICAL_KICK, self.m_fFireDuration, SLIDE_LIMIT );

end

/*---------------------------------------------------------
   Name: SWEP:PreThink( )
   Desc: Called before every frame
---------------------------------------------------------*/
function SWEP:PreThink()
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()

	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	self:PreThink();

	if ( pPlayer:WaterLevel() >= 3 ) then
		self.m_bIsUnderwater = true;
	else
		self.m_bIsUnderwater = false;
	end

	if ( pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration	= self.m_fFireDuration + FrameTime();
	elseif ( !pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration	= 0.0;
		self.m_nShotsFired		= 0;
	end

	// See if we need to fire off our secondary round
	if ( self.m_bShotDelayed && CurTime() > self.m_flDelayedFire ) then
		self:DelayedAttack();
	end

	self.BaseClass:Think();

end


/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetDeploySpeed( self:SequenceDuration() )

	self.m_fFireDuration	= 0.0;
	self.m_bShotDelayed		= false;
	self.m_flDelayedFire	= 0.0;

	return true

end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	local pHL2MPPlayer = pPlayer;

		// Fire the bullets
	local info = {};
	info.Num = num_bullets;
	info.Src = pHL2MPPlayer:GetShootPos();
	info.Dir = pPlayer:GetAimVector();
	info.Spread = aimcone;
	info.Damage = damage;
	info.Tracer = self.Primary.Tracer;
	info.TracerName = self.Primary.TracerName;

	info.Owner = self.Owner
	info.Weapon = self.Weapon

	info.DoImpactEffect = self.DoImpactEffect;
	info.ShootCallback = self.ShootCallback;

	info.Callback = function( attacker, trace, dmginfo )
		info:DoImpactEffect( trace );
		return info:ShootCallback( attacker, trace, dmginfo );
	end

	pPlayer:FireBullets( info );

end


/*---------------------------------------------------------
   Name: SWEP:ShootCallback( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootCallback( attacker, trace, dmginfo )
end


/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	return true
end


/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()
	return true
end


/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self:SetNextPrimaryFire( CurTime() + speed )
	self:SetNextSecondaryFire( CurTime() + speed )

end


