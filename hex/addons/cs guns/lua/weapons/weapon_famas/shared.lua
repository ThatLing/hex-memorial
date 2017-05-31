
----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"
SWEP.Category			= "United Hosts"

if ( CLIENT ) then
	SWEP.PrintName			= "Famas F1"			
	SWEP.Author				= "Counter-Strike / MaNiAk"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 4
	SWEP.IconLetter			= "t"
	
	killicon.AddFont( "weapon_famas", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end



SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip		= false

SWEP.ViewModel			= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_famas.Single" )
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 115
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"




----------------------------------------
--         2014-07-12 20:33:13          --
------------------------------------------


if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "ar2"
SWEP.Category			= "United Hosts"

if ( CLIENT ) then
	SWEP.PrintName			= "Famas F1"			
	SWEP.Author				= "Counter-Strike / MaNiAk"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 4
	SWEP.IconLetter			= "t"
	
	killicon.AddFont( "weapon_famas", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end



SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip		= false

SWEP.ViewModel			= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_famas.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_famas.Single" )
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 115
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"



