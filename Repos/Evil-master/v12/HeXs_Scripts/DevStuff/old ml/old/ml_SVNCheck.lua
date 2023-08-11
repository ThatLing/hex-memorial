
local function Useless() end

local GAN = notification.AddLegacy

notification.AddProgress	= Useless
notification.AddLegacy		= Useless
--[[
notification.Kill			= Useless
notification.Die			= Useless
notification.UpdateNotice	= Useless
notification.Update			= Useless
]]

if not IsKida then return end
if not IsMainGMod then return end

local addons = file.FindDir( "addons/*", true )
local path, properties, current, latest, name
timer.Simple(0, function()
	for _, addon in ipairs( addons ) do
		path = "addons/" .. addon .. "/.svn/entries"
		if ( file.Exists( path, true ) ) then
			properties = string.Explode( "\n", file.Read( path, true ) )
			current = tonumber( properties[4] )
			 
			http.Get( "http://83.84.23.31/dev/get.php?url=" .. properties[5], "", function( contents )
				latest = tonumber( string.match( contents, "Revision ([0-9]+)" ) )
				 
				if ( current and latest and current < latest ) then
					name = KeyValuesToTable( file.Read( "addons/" .. addon .. "/info.txt", true ) )["name"]
					
					GAN("SVN Update for: "..( name or addon ), NOTIFY_UNDO, 10)
					print("[HeX] SVN Update for: ", (name or addon))
				end
			end )
		end
	end
end)



