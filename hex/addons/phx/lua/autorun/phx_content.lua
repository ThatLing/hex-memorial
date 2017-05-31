
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
--[Phoenix Storms 2 - Content by Lua
--[This file takes care of all PHX content.
--[Created by 1/4 Life.

--[Soundscapes (Can we even precache a soundscape this way? Someone needs to figure this out and PM 1/4 Life.)

-- The only thing I found close to it is:   PrecacheScriptSound(STRING) 

Sound("HeavyMetal.ImpactHard")
Sound("HeavyMetal.ImpactSoft")
Sound("Egg.Crack")

--[THRUSTERS SOUNDS]  NEW!!!! :D  by PhoeniX-Storms

list.Set( "ThrusterSounds", "PHX - Hover (Light)________[Phx.HoverLight]", { thruster_soundname = "Phx.HoverLight" } )
list.Set( "ThrusterSounds", "PHX - Hover (Standard)_____[Phx.HoverStandard]", { thruster_soundname = "Phx.HoverStandard" } )
list.Set( "ThrusterSounds", "PHX - Hover (Heavy)________[Phx.HoverHeavy]", { thruster_soundname = "Phx.HoverHeavy" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 1________[Phx.Afterburner1]", { thruster_soundname = "Phx.Afterburner1" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 2________[Phx.Afterburner2]", { thruster_soundname = "Phx.Afterburner2" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 3________[Phx.Afterburner3]", { thruster_soundname = "Phx.Afterburner3" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 4________[Phx.Afterburner4]", { thruster_soundname = "Phx.Afterburner4" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 5________[Phx.Afterburner5]", { thruster_soundname = "Phx.Afterburner5" } )
list.Set( "ThrusterSounds", "PHX - Turbine______________[Phx.Turbine]", { thruster_soundname = "Phx.Turbine" } )
list.Set( "ThrusterSounds", "PHX - Alien Engine 1_______[Phx.Alien1]", { thruster_soundname = "Phx.Alien1" } )
list.Set( "ThrusterSounds", "PHX - Alien Engine 2_______[Phx.Alien2]", { thruster_soundname = "Phx.Alien2" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 1_________[Phx.Jet1]", { thruster_soundname = "Phx.Jet1" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 2_________[Phx.Jet2]", { thruster_soundname = "Phx.Jet2" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 3_________[Phx.Jet3]", { thruster_soundname = "Phx.Jet3" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 4_________[Phx.Jet4]", { thruster_soundname = "Phx.Jet4" } )


--[Thrusters
//PhoeniX-Storms
list.Set( "ThrusterModels", "models/props_phx2/garbage_metalcan001a.mdl", {} )
//Tile Model Pack
list.Set( "ThrusterModels", "models/hunter/plates/plate.mdl", {} )
list.Set( "ThrusterModels", "models/hunter/blocks/cube025x025x025.mdl", {} )
//XQM Model Pack
list.Set( "ThrusterModels", "models/XQM/AfterBurner1.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Medium.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Big.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Huge.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Large.mdl", {} )

--[Wheels (FIXME: Create a seperate wheel tool for these, We're really pushing the wheel list.)   <-   That we are.
//PhoeniX-Storms
list.Set( "WheelModels", "models/props_phx/facepunch_logo.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/facepunch_barrel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/oildrum001.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/oildrum001_explosive.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/chrome_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/breakable_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gibs/tire1_gib.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/normal_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/medgear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/biggear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel90_24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/smallwheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/747wheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/wheel_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/medium_wheel_2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_back.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_front.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/monster_truck.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller2x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller3x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_med_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/moped_tire.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//Tile Model Pack
list.Set( "WheelModels", "models/hunter/misc/cone1x05.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle2x2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle4x4.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//Primitive Mechanics
list.Set( "WheelModels", "models/mechanics/wheels/bmw.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/bmwl.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/rim_1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/tractor.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2l.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_extruded_48.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_race.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_smooth2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//XQM Model Pack
list.Set( "WheelModels", "models/NatesWheel/nateswheel.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/NatesWheel/nateswheelwide.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropeller.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotor.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
//Xeon133's Wheels
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-20.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-30.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-40.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-50.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-60.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-70.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-80.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )

--[Buttons
//PhoeniX-Storms
list.Set( "ButtonModels", "models/props_phx/construct/metal_plate1.mdl", {} )
list.Set( "ButtonModels", "models/props_phx/rt_screen.mdl", {} )
list.Set( "ButtonModels", "models/props_phx/misc/fender.mdl", {} )
//Tile Model Pack
list.Set( "ButtonModels", "models/hunter/plates/plate.mdl", {} )
list.Set( "ButtonModels", "models/hunter/blocks/cube025x025x025.mdl", {} )
//XQM Model Pack
list.Set( "ButtonModels", "models/XQM/button1.mdl", {} )
list.Set( "ButtonModels", "models/XQM/button2.mdl", {} )
list.Set( "ButtonModels", "models/XQM/button3.mdl", {} )

--[Materials
//PhoeniX-Storms
list.Add( "OverrideMaterials", "phoenix_storms/metalset_1-2" )
list.Add( "OverrideMaterials", "phoenix_storms/metalfloor_2-3" )
list.Add( "OverrideMaterials", "phoenix_storms/plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/wood" )
list.Add( "OverrideMaterials", "phoenix_storms/chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/black_chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/bluemetal" )
list.Add( "OverrideMaterials", "phoenix_storms/cube" )
list.Add( "OverrideMaterials", "phoenix_storms/dome" )
list.Add( "OverrideMaterials", "phoenix_storms/gear" )
list.Add( "OverrideMaterials", "phoenix_storms/stripes" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_green" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_red" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_blue" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber2" )
//Tile Model Pack
list.Add( "OverrideMaterials", "hunter/myplastic" )
list.Add( "OverrideMaterials", "hunter/mywindow" )
//XQM Model Pack
list.Add( "OverrideMaterials", "Straw/StrawTile_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/Deg360_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/BoxFull_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CellShadedCamo_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/2Deg360_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/SquaredMat" )
list.Add( "OverrideMaterials", "models/XQM/SquaredMatInverted" )
list.Add( "OverrideMaterials", "models/XQM/LightLinesRed" )
list.Add( "OverrideMaterials", "models/XQM/LightLinesGB" )
list.Add( "OverrideMaterials", "models/XQM/Panel360_Diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CoasterTrack/Special_Station" )
list.Add( "OverrideMaterials", "models/XQM/WoodPlankTexture" )
list.Add( "OverrideMaterials", "models/XQM/CinderBlock_Tex" )
list.Add( "OverrideMaterials", "models/XQM/WoodTexture_1" )
list.Add( "OverrideMaterials", "models/XQM/Rails/gumball_1" )

--[Vehicles
local Category = "PhoeniX-Storms"

local function HandlePHXSeatAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT ) 
end

local function HandlePHXVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_JEEP ) 
end

local function HandlePHXCoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

//PhoeniX-Storms
local V = { 	
				Name = "Car Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Sitting Animation",
				Model = "models/props_phx/carseat2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXSeatAnimation,
							}
}
list.Set( "Vehicles", "phx_seat", V )

local V = { 	
				Name = "Car Seat 2", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Driving Animation",
				Model = "models/props_phx/carseat3.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXVehicleAnimation,
							}
}
list.Set( "Vehicles", "phx_seat2", V )





----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
--[Phoenix Storms 2 - Content by Lua
--[This file takes care of all PHX content.
--[Created by 1/4 Life.

--[Soundscapes (Can we even precache a soundscape this way? Someone needs to figure this out and PM 1/4 Life.)

-- The only thing I found close to it is:   PrecacheScriptSound(STRING) 

Sound("HeavyMetal.ImpactHard")
Sound("HeavyMetal.ImpactSoft")
Sound("Egg.Crack")

--[THRUSTERS SOUNDS]  NEW!!!! :D  by PhoeniX-Storms

list.Set( "ThrusterSounds", "PHX - Hover (Light)________[Phx.HoverLight]", { thruster_soundname = "Phx.HoverLight" } )
list.Set( "ThrusterSounds", "PHX - Hover (Standard)_____[Phx.HoverStandard]", { thruster_soundname = "Phx.HoverStandard" } )
list.Set( "ThrusterSounds", "PHX - Hover (Heavy)________[Phx.HoverHeavy]", { thruster_soundname = "Phx.HoverHeavy" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 1________[Phx.Afterburner1]", { thruster_soundname = "Phx.Afterburner1" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 2________[Phx.Afterburner2]", { thruster_soundname = "Phx.Afterburner2" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 3________[Phx.Afterburner3]", { thruster_soundname = "Phx.Afterburner3" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 4________[Phx.Afterburner4]", { thruster_soundname = "Phx.Afterburner4" } )
list.Set( "ThrusterSounds", "PHX - Afterburner 5________[Phx.Afterburner5]", { thruster_soundname = "Phx.Afterburner5" } )
list.Set( "ThrusterSounds", "PHX - Turbine______________[Phx.Turbine]", { thruster_soundname = "Phx.Turbine" } )
list.Set( "ThrusterSounds", "PHX - Alien Engine 1_______[Phx.Alien1]", { thruster_soundname = "Phx.Alien1" } )
list.Set( "ThrusterSounds", "PHX - Alien Engine 2_______[Phx.Alien2]", { thruster_soundname = "Phx.Alien2" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 1_________[Phx.Jet1]", { thruster_soundname = "Phx.Jet1" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 2_________[Phx.Jet2]", { thruster_soundname = "Phx.Jet2" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 3_________[Phx.Jet3]", { thruster_soundname = "Phx.Jet3" } )
list.Set( "ThrusterSounds", "PHX - Jet Engine 4_________[Phx.Jet4]", { thruster_soundname = "Phx.Jet4" } )


--[Thrusters
//PhoeniX-Storms
list.Set( "ThrusterModels", "models/props_phx2/garbage_metalcan001a.mdl", {} )
//Tile Model Pack
list.Set( "ThrusterModels", "models/hunter/plates/plate.mdl", {} )
list.Set( "ThrusterModels", "models/hunter/blocks/cube025x025x025.mdl", {} )
//XQM Model Pack
list.Set( "ThrusterModels", "models/XQM/AfterBurner1.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Medium.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Big.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Huge.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Large.mdl", {} )

--[Wheels (FIXME: Create a seperate wheel tool for these, We're really pushing the wheel list.)   <-   That we are.
//PhoeniX-Storms
list.Set( "WheelModels", "models/props_phx/facepunch_logo.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/facepunch_barrel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/oildrum001.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/oildrum001_explosive.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/chrome_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/breakable_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gibs/tire1_gib.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/normal_tire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/medgear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/mechanics/biggear.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel90_24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/bevel36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur9.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur12.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur24.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/gears/spur36.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/smallwheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/747wheel.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/trucktire2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/metal_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/wooden_wheel2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/metal_plate_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/wood/wood_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x1.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/construct/windows/window_curve360x2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/wheel_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/medium_wheel_2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/trains/double_wheels2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_back.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/drugster_front.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/monster_truck.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller2x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/propeller3x_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/misc/paddle_small2.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_small_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_medium.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_med_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/magnetic_large_base.mdl", { wheel_rx = 90, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/props_phx/wheels/moped_tire.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//Tile Model Pack
list.Set( "WheelModels", "models/hunter/misc/cone1x05.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle2x2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/hunter/tubes/circle4x4.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//Primitive Mechanics
list.Set( "WheelModels", "models/mechanics/wheels/bmw.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/bmwl.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/rim_1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/tractor.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_2l.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_extruded_48.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_race.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/mechanics/wheels/wheel_smooth2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear12x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear16x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x12_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x24_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_large.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears/gear24x6_small.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_12t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_18t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_24t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_36t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_48t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/gear_60t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_48t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/bevel_60t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_12t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_18t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_24t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/vert_36t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t1.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t2.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_20t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_40t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
list.Set( "WheelModels", "models/Mechanics/gears2/pinion_80t3.mdl", { wheel_rx = 90, wheel_ry = 0, wheel_rz = 0 } )
//XQM Model Pack
list.Set( "WheelModels", "models/NatesWheel/nateswheel.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/NatesWheel/nateswheelwide.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropeller.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/JetEnginePropellerLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotor.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorMedium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorBig.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorHuge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/HelicopterRotorLarge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/Propeller1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Medium.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Big.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Huge.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/XQM/AirPlaneWheel1Large.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
//Xeon133's Wheels
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-20.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-30.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-40.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-50.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-60.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-70.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )
list.Set( "WheelModels", "models/xeon133/offroad/Off-road-80.mdl", { wheel_rx = 0, 	wheel_ry = 0, 	wheel_rz = 0} )

--[Buttons
//PhoeniX-Storms
list.Set( "ButtonModels", "models/props_phx/construct/metal_plate1.mdl", {} )
list.Set( "ButtonModels", "models/props_phx/rt_screen.mdl", {} )
list.Set( "ButtonModels", "models/props_phx/misc/fender.mdl", {} )
//Tile Model Pack
list.Set( "ButtonModels", "models/hunter/plates/plate.mdl", {} )
list.Set( "ButtonModels", "models/hunter/blocks/cube025x025x025.mdl", {} )
//XQM Model Pack
list.Set( "ButtonModels", "models/XQM/button1.mdl", {} )
list.Set( "ButtonModels", "models/XQM/button2.mdl", {} )
list.Set( "ButtonModels", "models/XQM/button3.mdl", {} )

--[Materials
//PhoeniX-Storms
list.Add( "OverrideMaterials", "phoenix_storms/metalset_1-2" )
list.Add( "OverrideMaterials", "phoenix_storms/metalfloor_2-3" )
list.Add( "OverrideMaterials", "phoenix_storms/plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/wood" )
list.Add( "OverrideMaterials", "phoenix_storms/chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/black_chrome" )
list.Add( "OverrideMaterials", "phoenix_storms/bluemetal" )
list.Add( "OverrideMaterials", "phoenix_storms/cube" )
list.Add( "OverrideMaterials", "phoenix_storms/dome" )
list.Add( "OverrideMaterials", "phoenix_storms/gear" )
list.Add( "OverrideMaterials", "phoenix_storms/stripes" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_green" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_red" )
list.Add( "OverrideMaterials", "phoenix_storms/wire/pcb_blue" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_metallic2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_plastic2" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber" )
list.Add( "OverrideMaterials", "phoenix_storms/mat/mat_phx_carbonfiber2" )
//Tile Model Pack
list.Add( "OverrideMaterials", "hunter/myplastic" )
list.Add( "OverrideMaterials", "hunter/mywindow" )
//XQM Model Pack
list.Add( "OverrideMaterials", "Straw/StrawTile_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/Deg360_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/BoxFull_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CellShadedCamo_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/2Deg360_diffuse" )
list.Add( "OverrideMaterials", "models/XQM/SquaredMat" )
list.Add( "OverrideMaterials", "models/XQM/SquaredMatInverted" )
list.Add( "OverrideMaterials", "models/XQM/LightLinesRed" )
list.Add( "OverrideMaterials", "models/XQM/LightLinesGB" )
list.Add( "OverrideMaterials", "models/XQM/Panel360_Diffuse" )
list.Add( "OverrideMaterials", "models/XQM/CoasterTrack/Special_Station" )
list.Add( "OverrideMaterials", "models/XQM/WoodPlankTexture" )
list.Add( "OverrideMaterials", "models/XQM/CinderBlock_Tex" )
list.Add( "OverrideMaterials", "models/XQM/WoodTexture_1" )
list.Add( "OverrideMaterials", "models/XQM/Rails/gumball_1" )

--[Vehicles
local Category = "PhoeniX-Storms"

local function HandlePHXSeatAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT ) 
end

local function HandlePHXVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_JEEP ) 
end

local function HandlePHXCoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

//PhoeniX-Storms
local V = { 	
				Name = "Car Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Sitting Animation",
				Model = "models/props_phx/carseat2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXSeatAnimation,
							}
}
list.Set( "Vehicles", "phx_seat", V )

local V = { 	
				Name = "Car Seat 2", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Driving Animation",
				Model = "models/props_phx/carseat3.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXVehicleAnimation,
							}
}
list.Set( "Vehicles", "phx_seat2", V )




