
----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------

local AmmoTypes = {}

--
-- Called by modders to add a new ammo type.
-- Ammo types aren't something you can add on the fly. You have one
-- opportunity during loadtime. The ammo types should also be IDENTICAL on 
-- server and client. 
-- If they're not you will receive errors and maybe even crashes.
--
--
--		game.AddAmmoType( 
--		{
--			name		=	"customammo",
--			dmgtype		=	DMG_BULLET,
--			tracer		=	TRACER_LINE_AND_WHIZ,
--			plydmg		=	20,
--			npcdmg		=	20,
--			force		=	100,
--			minsplash	=	10,
--			maxsplash	=	100
--		})
--
game.AddAmmoType = function ( tbl )

	if ( !tbl.name ) then return end

	table.insert( AmmoTypes, tbl )

end

--
-- Called by the engine to retrive the ammo types. 
-- You should never have to call this manually.
--
game.BuildAmmoTypes = function()

	--
	-- Sort the table by name here to assure that the ammo types
	--  are inserted in the same order on both server and client
	--
	table.SortByMember( AmmoTypes, "name", true )

	return AmmoTypes;

end



----------------------------------------
--         2014-07-12 20:32:44          --
------------------------------------------

local AmmoTypes = {}

--
-- Called by modders to add a new ammo type.
-- Ammo types aren't something you can add on the fly. You have one
-- opportunity during loadtime. The ammo types should also be IDENTICAL on 
-- server and client. 
-- If they're not you will receive errors and maybe even crashes.
--
--
--		game.AddAmmoType( 
--		{
--			name		=	"customammo",
--			dmgtype		=	DMG_BULLET,
--			tracer		=	TRACER_LINE_AND_WHIZ,
--			plydmg		=	20,
--			npcdmg		=	20,
--			force		=	100,
--			minsplash	=	10,
--			maxsplash	=	100
--		})
--
game.AddAmmoType = function ( tbl )

	if ( !tbl.name ) then return end

	table.insert( AmmoTypes, tbl )

end

--
-- Called by the engine to retrive the ammo types. 
-- You should never have to call this manually.
--
game.BuildAmmoTypes = function()

	--
	-- Sort the table by name here to assure that the ammo types
	--  are inserted in the same order on both server and client
	--
	table.SortByMember( AmmoTypes, "name", true )

	return AmmoTypes;

end


