

	include( "custom_menu/SN3/sn3_base_cl.lua" )

	

include( "custom_menu/SN3/sn3_base_netmessages.lua" )

-- Initialization

HookNetChannel(
	{ name = "CNetChan::SendDatagram" }
)

hook.Add( "PreSendDatagram", "OutFilter", function( netchan, ... )
	local buffers = { ... }

	for k, write in pairs( buffers ) do
		local totalbits = write:GetNumBitsWritten()
		local read = sn3_bf_read( write:GetBasePointer(), totalbits )

		write:Seek( 0 )
		
		while ( read:GetNumBitsLeft() >= NET_MESSAGE_BITS ) do
			local msg = read:ReadUBitLong( NET_MESSAGE_BITS )
			local handler = NET_MESSAGES[ msg ]

			if ( !handler ) then
				if ( CLIENT ) then
					handler = NET_MESSAGES.CLC[ msg ]
				else
					handler = NET_MESSAGES.SVC[ msg ]
				end

				if ( !handler ) then
					Msg( "Unknown outgoing message: " .. msg .. "\n" )

					write:Seek( totalbits )

					break
				end
			end

			local func = handler.OutgoingCopy or handler.DefaultCopy
			
			if ( func( netchan, read, write ) == false ) then
				Msg( "Failed to filter message " .. msg .. "\n" )

				write:Seek( totalbits )

				break
			end
		end
		
		read:FinishReading()
	end
end )

function FilterOutgoingMessage( msg, func )
	local handler = NET_MESSAGES[ msg ]
	
	if ( !handler ) then
		if ( CLIENT ) then
			handler = NET_MESSAGES.CLC[ msg ]
		else
			handler = NET_MESSAGES.SVC[ msg ]
		end
	end
	
	if ( !handler ) then return end

	handler.OutgoingCopy = func
end

function UnFilterOutgoingMessage( msg )
	FilterOutgoingMessage( msg, nil )
end