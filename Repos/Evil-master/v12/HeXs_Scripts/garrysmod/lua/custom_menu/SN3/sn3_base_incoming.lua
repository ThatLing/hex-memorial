

	include( "custom_menu/SN3/sn3_base_cl.lua" )

include( "custom_menu/SN3/sn3_base_netmessages.lua" )

-- Initialization

HookNetChannel(
	{ name = "CNetChan::ProcessMessages", nochan = true }
)

hook.Add( "PreProcessMessages", "InFilter", function( netchan, read, write )
	hook.Call( "BASE_PreProcessMessages", nil, netchan, read, write )

	local totalbits = read:GetNumBitsLeft() + read:GetNumBitsRead()

	while ( read:GetNumBitsLeft() >= NET_MESSAGE_BITS ) do
		local msg = read:ReadUBitLong( NET_MESSAGE_BITS )
		local handler = NET_MESSAGES[ msg ]

		if ( !handler ) then
			if ( CLIENT ) then
				handler = NET_MESSAGES.SVC[ msg ]
			else
				handler = NET_MESSAGES.CLC[ msg ]
			end

			if ( !handler ) then
				Msg( "Unknown incoming message: " .. msg .. "\n" )
					
				write:Seek( totalbits )

				break
			end
		end

		local func = handler.IncomingCopy or handler.DefaultCopy
	
		if ( func( netchan, read, write ) == false ) then
			Msg( "Failed to filter message " .. msg .. "\n" )

			write:Seek( totalbits )

			break
		end
	end
end )

function FilterIncomingMessage( msg, func )
	local handler = NET_MESSAGES[ msg ]
	
	if ( !handler ) then
		if ( CLIENT ) then
			handler = NET_MESSAGES.SVC[ msg ]
		else
			handler = NET_MESSAGES.CLC[ msg ]
		end
	end
	
	if ( !handler ) then return end

	handler.IncomingCopy = func
end

function UnFilterIncomingMessage( msg )
	FilterIncomingMessage( msg, nil )
end