
----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------


H00.Weapon.Populate(SWEP,
					-- information
					'Bargin Bazooka',								-- name
					'HeX + Henry00',								-- author
					'It\'s useless, only for experts',				-- description
					'Unable to find manual for device',				-- instructions
					
					-- model
					'models/weapons/w_rocket_launcher.mdl',			-- world model
					'models/weapons/v_rpg.mdl',						-- view model
						60,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'call',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- secondary
					'call',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					4,												-- slot column
					5												-- slot row
)


SWEP.IconLetter	= "3"

if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/bargin_bazooka.vmt'
	resource.AddFile	'materials/vgui/entities/bargin_bazooka.vtf'
end


function SWEP:PrimaryFire()
	self:Malfunction()
	
	if SACH and SACH.ACH_Bargin then
		SACH.ACH_Bargin(self.Owner)
	end
end

function SWEP:SecondaryFire()
	self:Malfunction()
	
	if SACH and SACH.ACH_Bargin then
		SACH.ACH_Bargin(self.Owner)
	end
end

























----------------------------------------
--         2014-07-12 20:33:11          --
------------------------------------------


H00.Weapon.Populate(SWEP,
					-- information
					'Bargin Bazooka',								-- name
					'HeX + Henry00',								-- author
					'It\'s useless, only for experts',				-- description
					'Unable to find manual for device',				-- instructions
					
					-- model
					'models/weapons/w_rocket_launcher.mdl',			-- world model
					'models/weapons/v_rpg.mdl',						-- view model
						60,											-- view model FOV
						false,										-- view model flip
						
					-- primary
					'call',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- secondary
					'call',											-- ammo type
					-1,												-- pickup clip size
					-1,												-- clip size
					0.0,											-- automatic fire speed (0:off)
					
					-- interface
					4,												-- slot column
					5												-- slot row
)


SWEP.IconLetter	= "3"

if SERVER then
	AddCSLuaFile		'shared.lua'
	resource.AddFile	'materials/vgui/entities/bargin_bazooka.vmt'
	resource.AddFile	'materials/vgui/entities/bargin_bazooka.vtf'
end


function SWEP:PrimaryFire()
	self:Malfunction()
	
	if SACH and SACH.ACH_Bargin then
		SACH.ACH_Bargin(self.Owner)
	end
end

function SWEP:SecondaryFire()
	self:Malfunction()
	
	if SACH and SACH.ACH_Bargin then
		SACH.ACH_Bargin(self.Owner)
	end
end
























