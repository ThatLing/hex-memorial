require("sourcenet3")
print("SN3 loaded")

MENU = true

NET_HOOKS = NET_HOOKS || { attach = {}, detach = {} }

function HookNetChannel( ... )
	local args = { ... }

	for k, v in pairs( args ) do
		local name = v.name:gsub( "::", "_" )

		local exists = false
		
		for k, v in pairs( NET_HOOKS.attach ) do
			if ( v.name == name ) then
				exists = true

				break
			end
		end
		
		if ( !exists ) then
			table.insert( NET_HOOKS.attach, { name = name, hook = _G[ "Attach__" .. name ], func = v.func, args = v.args, nochan = v.nochan } )
			table.insert( NET_HOOKS.detach, { name = name, hook = _G[ "Detach__" .. name ], func = v.func, args = v.args, nochan = v.nochan } )
		end
	end
	
	local function StandardNetHook( netchan, nethook )
		local args = {}

		if ( nethook.func ) then
			table.insert( args, nethook.func( netchan ) )
		elseif ( !nethook.nochan ) then
			table.insert( args, netchan )
		end
		
		if ( nethook.args ) then
			for k, v in pairs( nethook.args ) do
				table.insert( args, v )
			end
		end

		nethook.hook( unpack( args ) )
	end

	local function AttachNetChannel( netchan )
		if ( !netchan ) then return false end

		Attach__CNetChan_Shutdown( netchan )
		
		for k, v in pairs( NET_HOOKS.attach ) do
			StandardNetHook( netchan, v )
		end
		
		return true
	end

	local function DetachNetChannel( netchan )
		if ( !netchan ) then return false end

		Detach__CNetChan_Shutdown( netchan )
		
		for k, v in pairs( NET_HOOKS.detach ) do
			StandardNetHook( netchan, v )
		end

		return true
	end

	if ( !AttachNetChannel( CNetChan() ) ) then
		hook.Add( "Think", "CreateNetChannel", function() -- Wait until channel is created
			if ( CNetChan() ) then
				AttachNetChannel( CNetChan() )

				hook.Remove( "Think", "CreateNetChannel" )
			end
		end )
	end

	hook.Add( "PreNetChannelShutdown", "DetachHooks", function( netchan, reason )
		DetachNetChannel( netchan )

		if ( MENU ) then
			NET_HOOKS = NET_HOOKS || { attach = {}, detach = {} }

			hook.Add( "Think", "DestroyNetChannel", function() -- Ensure the current channel is destroyed before waiting for a new one
				if ( !CNetChan() ) then
					HookNetChannel( unpack( args ) )
					
					hook.Remove( "Think", "DestroyNetChannel" )
				end
			end )
		end
	end )
end