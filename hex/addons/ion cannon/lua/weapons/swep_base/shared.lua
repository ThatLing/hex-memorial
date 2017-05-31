
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


if ( SERVER ) then

	// resource.AddFile( "materials/VGUI/entities/.vmt" )
	// resource.AddFile( "materials/VGUI/entities/.vtf" )

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then

	SWEP.PrintName			= "Scripted Weapon"
	SWEP.ClassName			= "swep_base"
	SWEP.Author				= ""
	SWEP.IconLetter			= "."

	killicon.AddFont( SWEP.ClassName, "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end


SWEP.HoldType			= "pistol"								// Animation of the owner
SWEP.Base				= "swep_357"							// Derived base weapon
SWEP.Category			= "United Hosts"
SWEP.m_bFiresUnderwater	= false									// If weapon can fire underwater

SWEP.Spawnable			= false									// If anyone can spawn
SWEP.AdminSpawnable		= false									// If admins can spawn

SWEP.Primary.Empty			= Sound( "Weapon_Pistol.Empty" )	// Sound of an empty clip
SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )		// Sound of a single shot
SWEP.Primary.Damage			= 75								// Amount of damage per shot
SWEP.Primary.NumShots		= 1									// Number of bullets fired
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots				// Number of taken from the clip per shot
SWEP.Primary.Cone			= vec3_origin						// Spread of a shot
SWEP.Primary.ClipSize		= 6									// Size of a clip
SWEP.Primary.Delay			= 0.75								// Delay before the next fire in seconds
SWEP.Primary.DefaultClip	= 6									// Default number of bullets in a clip
SWEP.Primary.Automatic		= true								// Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"								// Type of ammunition
SWEP.Primary.Tracer			= 4									// Tracer shown after this many shots
SWEP.Primary.TracerName		= "Tracer"							// Name of the tracer used

SWEP.Secondary.ClipSize		= -1								// Size of a clip
SWEP.Secondary.DefaultClip	= -1								// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false								// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "None"							// Type of ammunition

function SWEP:PreThink()
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
end

function SWEP:ShootCallback( attacker, trace, dmginfo )
end

function SWEP:CanPrimaryAttack()
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end


----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


if ( SERVER ) then

	// resource.AddFile( "materials/VGUI/entities/.vmt" )
	// resource.AddFile( "materials/VGUI/entities/.vtf" )

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then

	SWEP.PrintName			= "Scripted Weapon"
	SWEP.ClassName			= "swep_base"
	SWEP.Author				= ""
	SWEP.IconLetter			= "."

	killicon.AddFont( SWEP.ClassName, "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end


SWEP.HoldType			= "pistol"								// Animation of the owner
SWEP.Base				= "swep_357"							// Derived base weapon
SWEP.Category			= "United Hosts"
SWEP.m_bFiresUnderwater	= false									// If weapon can fire underwater

SWEP.Spawnable			= false									// If anyone can spawn
SWEP.AdminSpawnable		= false									// If admins can spawn

SWEP.Primary.Empty			= Sound( "Weapon_Pistol.Empty" )	// Sound of an empty clip
SWEP.Primary.Sound			= Sound( "Weapon_357.Single" )		// Sound of a single shot
SWEP.Primary.Damage			= 75								// Amount of damage per shot
SWEP.Primary.NumShots		= 1									// Number of bullets fired
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots				// Number of taken from the clip per shot
SWEP.Primary.Cone			= vec3_origin						// Spread of a shot
SWEP.Primary.ClipSize		= 6									// Size of a clip
SWEP.Primary.Delay			= 0.75								// Delay before the next fire in seconds
SWEP.Primary.DefaultClip	= 6									// Default number of bullets in a clip
SWEP.Primary.Automatic		= true								// Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"								// Type of ammunition
SWEP.Primary.Tracer			= 4									// Tracer shown after this many shots
SWEP.Primary.TracerName		= "Tracer"							// Name of the tracer used

SWEP.Secondary.ClipSize		= -1								// Size of a clip
SWEP.Secondary.DefaultClip	= -1								// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false								// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "None"							// Type of ammunition

function SWEP:PreThink()
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
end

function SWEP:ShootCallback( attacker, trace, dmginfo )
end

function SWEP:CanPrimaryAttack()
	if SERVER and hook.Run("HSP_NoFireWeapon", self) then return end
	
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

