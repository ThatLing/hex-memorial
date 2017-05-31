
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
------------------------------------
--	Simple Prop Protection
--	By Spacetech
-- 	http://code.google.com/p/simplepropprotection
------------------------------------

AddCSLuaFile("autorun/sh_SPropProtection.lua")
AddCSLuaFile("SPropProtection/cl_Init.lua")
AddCSLuaFile("SPropProtection/sh_CPPI.lua")

SPropProtection = {}
SPropProtection.Version = 1337 -- "SVN"

CPPI = {}
CPPI_NOTIMPLEMENTED = 26
CPPI_DEFER = 16

include("SPropProtection/sh_CPPI.lua")

if(SERVER) then
	include("SPropProtection/sv_Init.lua")
else
	include("SPropProtection/cl_Init.lua")
end

Msg("=================================================================\n")
Msg("Simple Prop Protection Version UHDM by Spacetech + HeX has loaded\n")
Msg("=================================================================\n")


----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------
------------------------------------
--	Simple Prop Protection
--	By Spacetech
-- 	http://code.google.com/p/simplepropprotection
------------------------------------

AddCSLuaFile("autorun/sh_SPropProtection.lua")
AddCSLuaFile("SPropProtection/cl_Init.lua")
AddCSLuaFile("SPropProtection/sh_CPPI.lua")

SPropProtection = {}
SPropProtection.Version = 1337 -- "SVN"

CPPI = {}
CPPI_NOTIMPLEMENTED = 26
CPPI_DEFER = 16

include("SPropProtection/sh_CPPI.lua")

if(SERVER) then
	include("SPropProtection/sv_Init.lua")
else
	include("SPropProtection/cl_Init.lua")
end

Msg("=================================================================\n")
Msg("Simple Prop Protection Version UHDM by Spacetech + HeX has loaded\n")
Msg("=================================================================\n")

