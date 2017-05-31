
----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
if ( SERVER ) then
    AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then    
    killicon.AddFont( "weapon_p90", "CSKillIcons", "m", Color( 255, 80, 0, 255 ) )
end

SWEP.Base                = "weapon_cs_base"
SWEP.HoldType            = "ar2"

SWEP.DrawCrosshair        = false
SWEP.Slot                = 4
SWEP.SlotPos            = 2
SWEP.IconLetter            = "m"
SWEP.Weight                = 4

SWEP.Category			= "United Hosts"
SWEP.PrintName            = "P90"            
SWEP.Author            = "Desmond + HeX"
SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true
SWEP.ViewModel            = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_p90.mdl"

SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false
SWEP.WeaponDeploySpeed  = 1
SWEP.Primary.Sound            = Sound("Weapon_P90.Single")
SWEP.Primary.Recoil            = 0.099
SWEP.Primary.Damage            = 28
SWEP.Primary.NumShots        = 1
SWEP.Primary.Cone            = 0.032
SWEP.Primary.ClipSize        = 50
SWEP.Primary.Delay            = 0.093
SWEP.Primary.DefaultClip    = 90
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "smg1"
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo            = "none"


----------------------------------------
--         2014-07-12 20:33:14          --
------------------------------------------
if ( SERVER ) then
    AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then    
    killicon.AddFont( "weapon_p90", "CSKillIcons", "m", Color( 255, 80, 0, 255 ) )
end

SWEP.Base                = "weapon_cs_base"
SWEP.HoldType            = "ar2"

SWEP.DrawCrosshair        = false
SWEP.Slot                = 4
SWEP.SlotPos            = 2
SWEP.IconLetter            = "m"
SWEP.Weight                = 4

SWEP.Category			= "United Hosts"
SWEP.PrintName            = "P90"            
SWEP.Author            = "Desmond + HeX"
SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true
SWEP.ViewModel            = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_p90.mdl"

SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false
SWEP.WeaponDeploySpeed  = 1
SWEP.Primary.Sound            = Sound("Weapon_P90.Single")
SWEP.Primary.Recoil            = 0.099
SWEP.Primary.Damage            = 28
SWEP.Primary.NumShots        = 1
SWEP.Primary.Cone            = 0.032
SWEP.Primary.ClipSize        = 50
SWEP.Primary.Delay            = 0.093
SWEP.Primary.DefaultClip    = 90
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "smg1"
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo            = "none"

