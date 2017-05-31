
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType		= "ar2"
SWEP.Category			= "United Hosts"

if ( CLIENT ) then
	SWEP.PrintName			= "Galil"			
	SWEP.Author				= "Counter-Strike / MaNiAk"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "v"
	
	killicon.AddFont( "weapon_galil", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end


SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip		= false

SWEP.ViewModel			= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_galil.Single" )
SWEP.Primary.Recoil			= 1.7
SWEP.Primary.Damage			= 20--30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 125
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

--[[
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
]]


SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( -4.5, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 3, 0, 0 )




----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------


if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType		= "ar2"
SWEP.Category			= "United Hosts"

if ( CLIENT ) then
	SWEP.PrintName			= "Galil"			
	SWEP.Author				= "Counter-Strike / MaNiAk"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 3
	SWEP.IconLetter			= "v"
	
	killicon.AddFont( "weapon_galil", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end


SWEP.Base				= "weapon_cs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip		= false

SWEP.ViewModel			= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_galil.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_galil.Single" )
SWEP.Primary.Recoil			= 1.7
SWEP.Primary.Damage			= 20--30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 35
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 125
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

--[[
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
]]


SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( -4.5, -7, 2.5 )
SWEP.IronSightsAng 		= Vector( 3, 0, 0 )



