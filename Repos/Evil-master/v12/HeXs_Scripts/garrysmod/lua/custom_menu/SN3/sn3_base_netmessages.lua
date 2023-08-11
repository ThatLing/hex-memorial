require( "sourcenet3" )

function debugprint( ... )
	--print( ... )
end

MAX_TABLES = 32

function math.log2( val )
	return math.log( val ) / math.log( 2 )
end

NET_MESSAGES = {
	[ net_NOP ] = { -- 0
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_NOP, NET_MESSAGE_BITS )
		end
	},
	
	[ net_Disconnect ] = { -- 1
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_Disconnect, NET_MESSAGE_BITS )
			
			local reason = read:ReadString()
			write:WriteString( reason )
			
			debugprint( "net_Disconnect", reason )
		end
	},
	
	[ net_File ] = { -- 2
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_File, NET_MESSAGE_BITS )
			
			local transferid = read:ReadUBitLong( 32 )
			write:WriteUBitLong( transferid, 32 )

			local filename = read:ReadString()
			write:WriteString( filename )

			local requested = read:ReadOneBit()
			write:WriteOneBit( requested )
			
			debugprint( "net_File", transferid, filename, ( requested == 1 ) )
		end
	},

	[ net_Tick ] = { -- 3
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_Tick, NET_MESSAGE_BITS )

			local tick = read:ReadLong()
			write:WriteLong( tick )

			local unk1 = read:ReadUBitLong( 16 ) -- 14h
			write:WriteUBitLong( unk1, 16 )

			local unk2 = read:ReadUBitLong( 16 ) -- 18h
			write:WriteUBitLong( unk2, 16 )
			
			debugprint( "net_Tick", tick, unk1, unk2 )
		end
	},
	
	[ net_StringCmd ] = { -- 4
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_StringCmd, NET_MESSAGE_BITS )

			local cmd = read:ReadString()
			write:WriteString( cmd )
			
			debugprint( "net_StringCmd", cmd )
		end		
	},

	[ net_SetConVar ] = { -- 5
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_SetConVar, NET_MESSAGE_BITS )

			local count = read:ReadByte()
			write:WriteByte( count )

			for i = 1, count do
				local cvarname = read:ReadString()
				write:WriteString( cvarname )
				
				local cvarvalue = read:ReadString()
				write:WriteString( cvarvalue )
					
				debugprint( "net_SetConVar", cvarname, "=", cvarvalue )
			end
		end
	},

	[ net_SignonState ] = { -- 6
		DefaultCopy = function( netchan, read, write )
			write:WriteUBitLong( net_SignonState, NET_MESSAGE_BITS )
			
			local state = read:ReadByte()
			write:WriteByte( state )
			
			local servercount = read:ReadLong()
			write:WriteLong( servercount )
			
			debugprint( "net_SignonState", state, servercount )
		end
	},

	CLC = {
		[ clc_ClientInfo ] = { -- 8
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_ClientInfo, NET_MESSAGE_BITS )
							
				local spawncount = read:ReadLong() -- 14h, server spawn count - reconnects client if incorrect
				write:WriteLong( spawncount )
							
				local sendTableCRC = read:ReadLong() -- 10h
				write:WriteLong( sendTableCRC )

				local ishltv = read:ReadOneBit() -- 18h, requires tv_enable
				write:WriteOneBit( ishltv )
							
				local friendsID = read:ReadLong() -- 1Ch
				write:WriteLong( friendsID )
							
				local guid = read:ReadString() -- 20h, hashed CD Key (32 hex alphabetic chars + 0 terminator)
				write:WriteString( guid )

				for i = 1, MAX_CUSTOM_FILES do
					local useFile = read:ReadOneBit() -- 40h, 44h, 48h, 4Ch
					write:WriteOneBit( useFile )

					local fileCRC

					if ( useFile == 1 ) then
						fileCRC = read:ReadUBitLong( 32 )

						write:WriteUBitLong( fileCRC, 32 )
						
						debugprint( "\t> customization file " .. i .. " = " .. fileCRC )
					else
						fileCRC = 0
					end
				end
				
				local unk = read:ReadOneBit() -- 19h, probably replay related
				write:WriteOneBit( unk )
				
				debugprint( "clc_ClientInfo", spawncount, sendTableCRC, ishltv == 1, friendsID, guid, unk )
			end
		},
		
		[ clc_Move ] = { -- 9
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_Move, NET_MESSAGE_BITS )

				local new = read:ReadUBitLong( 4 )
				write:WriteUBitLong( new, 4 )

				local backup = read:ReadUBitLong( 3 )
				write:WriteUBitLong( backup, 3 )

				local bits = read:ReadWord() 				
				write:WriteWord( bits )

				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "clc_Move", new, backup, bits )
			end
		},
		
		[ clc_VoiceData ] = { -- 10
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_VoiceData, NET_MESSAGE_BITS )
				
				local bits = read:ReadWord()
				write:WriteWord( bits )

				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "clc_VoiceData", bits )
			end
		},
		
		[ clc_BaselineAck ] = { -- 11
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_BaselineAck, NET_MESSAGE_BITS )
				
				local tick = read:ReadLong() -- 10h
				write:WriteLong( tick )
				
				local unk2 = read:ReadUBitLong( 1 ) -- 14h
				write:WriteUBitLong( unk2, 1 )
				
				debugprint( "clc_BaselineAck", tick, unk2 )
			end
		},
		
		[ clc_ListenEvents ] = { -- 12
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_ListenEvents, NET_MESSAGE_BITS )
				
				debugprint( "clc_ListenEvents" )

				for i = 1, 16 do
					local unk1 = read:ReadUBitLong( 32 )
					write:WriteUBitLong( unk1, 32 )
				end
			end
		},
		
		[ clc_RespondCvarValue ] = { -- 13
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_RespondCvarValue, NET_MESSAGE_BITS )
				
				local cookie = read:ReadSBitLong( 32 ) -- 10h
				write:WriteSBitLong( cookie, 32 )
				
				local status = read:ReadSBitLong( 4 ) -- 1Ch
				write:WriteSBitLong( status, 4 )
				
				local cvarname = read:ReadString() -- 14h
				write:WriteString( cvarname )
				
				local cvarvalue = read:ReadString() -- 18h
				write:WriteString( cvarvalue )
				
				debugprint( "clc_RespondCvarValue", cookie, status, cvarname, cvarvalue )
			end
		},
		
		[ clc_FileCRCCheck ] = { -- 14 (Untested)
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_FileCRCCheck, NET_MESSAGE_BITS )
				
				local unk1 = read:ReadOneBit()
				write:WriteOneBit( unk1 )
				
				local gamepath = read:ReadUBitLong( 2 )
				write:WriteUBitLong( gamepath, 2 )
				
				local unk3

				if ( gamepath == 0 ) then
					unk3 = read:ReadString() -- 10h
					write:WriteString( unk3 )
				end
				
				local unk4 = read:ReadUBitLong( 3 )
				write:WriteUBitLong( unk4, 3 )
				
				local filename = read:ReadString()
				write:WriteString( filename )
				
				local unk6 = read:ReadUBitLong( 32 )
				write:WriteUBitLong( unk6, 32 )
	
				debugprint( "FileCRCCheck", unk1, gamepath, unk3, unk4, filename, unk6 )
			end
		},
		
		[ clc_CmdKeyValues ] = { -- 16
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_CmdKeyValues, NET_MESSAGE_BITS )

				local length = read:ReadLong()
				write:WriteLong( length )

				local keyvalues = read:ReadBits( length * 8 )
				write:WriteBits( keyvalues, length * 8 )
				keyvalues:Delete()
				
				debugprint( "clc_CmdKeyValues", length )
			end
		},
	
		[ clc_FileMD5Check ] = { -- 17 (Untested, seems to just copy FileCRCCheck?)
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( clc_FileMD5Check, NET_MESSAGE_BITS )

				local unk1 = read:ReadOneBit()
				write:WriteOneBit( unk1 )
				
				local gamepath = read:ReadUBitLong( 2 )
				write:WriteUBitLong( gamepath, 2 )
				
				local unk3

				if ( gamepath == 0 ) then
					unk3 = read:ReadString() -- 10h
					write:WriteString( unk3 )
				end
				
				local unk4 = read:ReadUBitLong( 3 )
				write:WriteUBitLong( unk4, 3 )
				
				local filename = read:ReadString()
				write:WriteString( filename )
				
				local unk6 = read:ReadUBitLong( 32 )
				write:WriteUBitLong( unk6, 32 )
				
				debugprint( "FileMD5Check", unk1, gamepath, unk3, unk4, filename, unk6 )
			end			
		},
	},

	SVC = {
		[ svc_Print ] = { -- 7
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_Print, NET_MESSAGE_BITS )
				
				local str = read:ReadString()
				write:WriteString( str )
				
				debugprint( "svc_Print [" .. str .. "]" )
			end
		},
		
		[ svc_ServerInfo ] = { -- 8
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_ServerInfo, NET_MESSAGE_BITS )

				-- Protocol version number
				local version = read:ReadShort()
				write:WriteShort( version )

				-- # of servers spawned since server .exe started
				-- So that we can detect new server startup during download, etc.
				-- Map change causes new server to "spawn".
				local servercount = read:ReadLong()
				write:WriteLong( servercount )

				-- Is SourceTV enabled?
				local sourcetv = read:ReadOneBit()
				write:WriteOneBit( sourcetv )

				-- 0 == listen, 1 == dedicated
				local dedicated = read:ReadOneBit()
				write:WriteOneBit( dedicated )

				-- The client side DLL CRC check.
				local serverclientcrc = read:ReadLong()
				write:WriteLong( serverclientcrc )

				-- Max amount of 'classes' (entity classes?)
				local maxclasses = read:ReadWord()
				write:WriteWord( maxclasses )

--[[
				-- The CRC of the server map must match the CRC of the client map. or else
				-- the client is probably cheating.
				local servermapcrc = read:ReadLong()
				write:WriteLong( servermapcrc )
--]]

				-- The MD5 of the server map must match the CRC of the client map. or else
				-- the client is probably cheating.
				local servermapmd5 = read:ReadBytes( 16 )
				write:WriteBytes( servermapmd5, 16 )
				servermapmd5:Delete()

				-- Amount of clients currently connected
				local playernum = read:ReadByte()
				write:WriteByte( playernum )

				-- Max amount of clients
				local maxclients = read:ReadByte()
				write:WriteByte( maxclients )

				-- Interval between ticks
				local interval_per_tick = read:ReadFloat()
				write:WriteFloat( interval_per_tick )

				-- Server platform ('w', ...?)
				local platform = read:ReadChar()
				write:WriteChar( platform )

				-- Directory used by game (eg. garrysmod)
				local gamedir = read:ReadString()
				write:WriteString( gamedir )

				-- Map being played
				local levelname = read:ReadString()
				write:WriteString( levelname )

				-- Skybox to use
				local skyname = read:ReadString()
				write:WriteString( skyname )

				-- Server name
				local hostname = read:ReadString()
				write:WriteString( hostname )
				
				-- Unknown bit (1Ah), probably replay
				local unk = read:ReadOneBit()
				write:WriteOneBit( unk )
				
				debugprint( "svc_ServerInfo", hostname, unk )
			end
		},
		
		[ svc_SendTable ] = { -- 9 (Untested!)
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_SendTable, NET_MESSAGE_BITS )
				
				local encoded = read:ReadOneBit()
				write:WriteOneBit( encoded )
				
				local bits = read:ReadShort() --14
				write:WriteShort( bits )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_SendTable", ( encoded == 1 ), bits )
			end
		},

		[ svc_ClassInfo ] = { -- 10
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_ClassInfo, NET_MESSAGE_BITS )
				
				local numclasses = read:ReadShort()
				write:WriteShort( numclasses )

				local useclientclasses = read:ReadOneBit()
				write:WriteOneBit( useclientclasses )

				if ( useclientclasses == 0 ) then
					for i = 1, numclasses do
						local unk3 = read:ReadUBitLong( math.log2( numclasses ) + 1 )
						write:WriteUBitLong( unk3, math.log2( numclasses ) + 1 )

						local unk4 = read:ReadString()
						write:WriteString( unk4 )

						local unk5 = read:ReadString()
						write:WriteString( unk5 )
						
						debugprint( "Full update", unk3, unk4, unk5 )
					end
				end
				
				debugprint( "svc_ClassInfo", numclasses, useclientclasses )
			end
		},
		
		[ svc_SetPause ] = { -- 11
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_SetPause, NET_MESSAGE_BITS )
				
				local state = read:ReadOneBit()
				write:WriteOneBit( state )
				
				debugprint( "svc_SetPause", ( state == 1 ) )
			end
		},
		
		[ svc_CreateStringTable ] = { -- 12
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_CreateStringTable, NET_MESSAGE_BITS )
				
				local tablename = read:ReadString()
				write:WriteString( tablename )

				local maxentries = read:ReadWord()
				write:WriteWord( maxentries )

				local entries = read:ReadUBitLong( math.log2( maxentries ) + 1 )
				write:WriteUBitLong( entries, math.log2( maxentries ) + 1 )

				local bits = read:ReadUBitLong( 20 )
				write:WriteUBitLong( bits, 20 )

				local userdata = read:ReadOneBit()
				write:WriteOneBit( userdata )

				if ( userdata == 1 ) then
					local userdatasize = read:ReadUBitLong( 12 )
					write:WriteUBitLong( userdatasize, 12 )

					local userdatabits = read:ReadUBitLong( 4 )
					write:WriteUBitLong( userdatabits, 4 )
				end
				
				local compressed = read:ReadOneBit()			
				write:WriteOneBit( compressed )	
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_CreateStringTable", tablename )
			end
		},

		[ svc_UpdateStringTable ] = { -- 13
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_UpdateStringTable, NET_MESSAGE_BITS )

				local tableid = read:ReadUBitLong( math.log2( MAX_TABLES ) ) -- 10h
				write:WriteUBitLong( tableid, math.log2( MAX_TABLES ) )

				local unk2 = read:ReadOneBit()
				write:WriteOneBit( unk2 )

				local changed

				if ( unk2 == 1 ) then
					changed = read:ReadWord() -- 14h
					write:WriteWord( changed )
				else
					changed = 1
				end
				
				local bits = read:ReadUBitLong( 20 ) -- 18h
				write:WriteUBitLong( bits, 20 )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()

				debugprint( "svc_UpdateStringTable", "table="..tableid..",", ( unk2 == 1 ), "changed="..changed..",", bits )
			end
		},

		[ svc_VoiceInit ] = { -- 14
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_VoiceInit, NET_MESSAGE_BITS )
				
				local codec = read:ReadString()
				write:WriteString( codec )
				
				local quality = read:ReadByte()
				write:WriteByte( quality )
				
				debugprint( "svc_VoiceInit", codec, quality )
			end
		},

		[ svc_VoiceData ] = { -- 15
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_VoiceData, NET_MESSAGE_BITS )

				local client = read:ReadByte() -- 10h				
				write:WriteByte( client )

				local proximity = read:ReadByte() -- 14h				
				write:WriteByte( proximity )

				local bits = read:ReadWord() -- 18h
				write:WriteWord( bits )

				local voicedata = read:ReadBits( bits )
				write:WriteBits( voicedata, bits )
				voicedata:Delete()
				
				debugprint( "svc_VoiceData", client, proximity, bits )
			end
		},

		[ svc_Sounds ] = { -- 17
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_Sounds, NET_MESSAGE_BITS )

				local reliable = read:ReadOneBit()
				write:WriteOneBit( reliable )

				local num
				local bits

				if ( reliable == 0 ) then
					num = read:ReadUBitLong( 8 )
					write:WriteUBitLong( num, 8 )

					bits = read:ReadUBitLong( 16 )
					write:WriteUBitLong( bits, 16 )
				else
					num = 1

					bits = read:ReadUBitLong( 8 )
					write:WriteUBitLong( bits, 8 )
				end

				local data = read:ReadBits( bits )
				write:WriteBits( data, bits ) -- Check out SoundInfo_t::ReadDelta if you want to read this	
				data:Delete()

				debugprint( "svc_Sounds", ( reliable == 1 ), num, bits )
			end
		},
		
		[ svc_SetView ] = { -- 18
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_SetView, NET_MESSAGE_BITS )
				
				local viewent = read:ReadUBitLong( 11 )
				write:WriteUBitLong( viewent, 11 )
				
				debugprint( "svc_SetView", viewent )
			end
		},

		[ svc_FixAngle ] = { -- 19
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_FixAngle, NET_MESSAGE_BITS )
				
				local relative = read:ReadOneBit()
				write:WriteOneBit( relative )

				local x = read:ReadBitAngle( 16 )
				write:WriteBitAngle( x, 16 )

				local y = read:ReadBitAngle( 16 )
				write:WriteBitAngle( y, 16 )

				local z = read:ReadBitAngle( 16 )
				write:WriteBitAngle( z, 16 )
				
				debugprint( "svc_FixAngle", ( relative == 1 ), x, y, z )
			end
		},

		[ svc_CrosshairAngle ] = { -- 20
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_CrosshairAngle, NET_MESSAGE_BITS )
				
				local p = read:ReadBitAngle( 16 )
				write:WriteBitAngle( p, 16 )

				local y = read:ReadBitAngle( 16 )
				write:WriteBitAngle( y, 16 )

				local r = read:ReadBitAngle( 16 )
				write:WriteBitAngle( r, 16 )
				
				debugprint( "svc_CrosshairAngle", p, y, r )
			end
		},

		[ svc_BSPDecal ] = { -- 21
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_BSPDecal, NET_MESSAGE_BITS )

				local pos = read:ReadBitVec3Coord() -- 10h
				write:WriteBitVec3Coord( pos )
				
				local texture = read:ReadUBitLong( 9 ) -- 1Ch
				write:WriteUBitLong( texture, 9 )
				
				local useentity = read:ReadOneBit()
				write:WriteOneBit( useentity )

				local ent -- 20h
				local modulation -- 24h

				if ( useentity == 1 ) then
					ent = read:ReadUBitLong( 11 ) 
					write:WriteUBitLong( ent, 11 )

					modulation = read:ReadUBitLong( 12 ) -- In engine build 4421 -> 4426 this changed from 11 to 12 bits
					write:WriteUBitLong( modulation, 12 )
				else
					ent = 0
					modulation = 0
				end
				
				local lowpriority = read:ReadOneBit() -- "Replaceable", 28h
				write:WriteOneBit( lowpriority )

				debugprint( string.format( "svc_BSPDecal %s, %d, %d, %d, %d, %d", tostring( pos ), texture, useentity, ent, modulation, lowpriority ) )
			end
		},

		[ svc_UserMessage ] = { -- 23
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_UserMessage, NET_MESSAGE_BITS )
				
				local msgtype = read:ReadByte() -- 10h
				write:WriteByte( msgtype )

				local bits = read:ReadUBitLong( 11 ) -- 14h
				write:WriteUBitLong( bits, 11 )

				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()

				debugprint( "svc_UserMessage", msgtype, bits )
			end
		},
		
		[ svc_EntityMessage ] = { -- 24
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_EntityMessage, NET_MESSAGE_BITS )
				
				local entity = read:ReadUBitLong( 11 )
				write:WriteUBitLong( entity, 11 )

				local class = read:ReadUBitLong( 9 )
				write:WriteUBitLong( class, 9 )

				local bits = read:ReadUBitLong( 11 )
				write:WriteUBitLong( bits, 11 )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_EntityMessage", entity, class, bits )
			end
		},

		[ svc_GameEvent ] = { -- 25
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_GameEvent, NET_MESSAGE_BITS )
				
				local bits = read:ReadUBitLong( 11 )
				write:WriteUBitLong( bits, 11 )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_GameEvent", bits )
			end
		},
		
		[ svc_PacketEntities ] = { -- 26
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_PacketEntities, NET_MESSAGE_BITS )
				
				local max = read:ReadUBitLong( 11 )
				write:WriteUBitLong( max, 11 )
				
				local unk2 = read:ReadOneBit()
				write:WriteOneBit( unk2 )
				
				local delta = 0

				if ( unk2 == 1 ) then
					delta = read:ReadLong()
					write:WriteLong( delta )
				end

				local unk4 = read:ReadUBitLong( 1 )
				write:WriteUBitLong( unk4, 1 )

				local changed = read:ReadUBitLong( 11 )
				write:WriteUBitLong( changed, 11 )

				local bits = read:ReadUBitLong( 20 )
				write:WriteUBitLong( bits, 20 )

				local unk7 = read:ReadOneBit()
				write:WriteOneBit( unk7 )
				
				local unk8 = read:ReadBits( bits )
				write:WriteBits( unk8, bits )
				unk8:Delete()
				
				debugprint( "svc_PacketEntities", max, unk2, delta, unk4, changed, bits, unk7 )
			end
		},
		
		[ svc_TempEntities ] = { -- 27
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_TempEntities, NET_MESSAGE_BITS )
				
				local num = read:ReadUBitLong( 8 ) -- 10h
				write:WriteUBitLong( num, 8 )
				
				local bits = read:ReadUBitLong( 17 ) -- 14h
				write:WriteUBitLong( bits, 17 )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_TempEntities", num, bits, data )
			end
		},
		
		[ svc_Prefetch ] = { -- 28
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_Prefetch, NET_MESSAGE_BITS )
				
				local index = read:ReadUBitLong( 13 )
				write:WriteUBitLong( index, 13 )
				
				debugprint( "svc_Prefetch", index )
			end
		},
		
		[ svc_Menu ] = { -- 29
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_Menu, NET_MESSAGE_BITS )
				
				local menutype = read:ReadShort()
				write:WriteShort( menutype )
				
				local bytes = read:ReadWord()
				write:WriteWord( bytes )
				
				local data = read:ReadBytes( bytes )
				write:WriteBytes( data, bytes )
				data:Delete()
				
				debugprint( "svc_Menu", menutype, bytes )
			end
		},
		
		[ svc_GameEventList ] = { -- 30
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_GameEventList, NET_MESSAGE_BITS )

				local num = read:ReadUBitLong( 9 )
				write:WriteUBitLong( num, 9 )
				
				local bits = read:ReadUBitLong( 20 )
				write:WriteUBitLong( bits, 20 )
				
				local data = read:ReadBits( bits )
				write:WriteBits( data, bits )
				data:Delete()
				
				debugprint( "svc_GameEventList", num, bits )
			end
		},
		
		[ svc_GetCvarValue ] = { -- 31
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_GetCvarValue, NET_MESSAGE_BITS )
				
				local cookie = read:ReadSBitLong( 32 )
				write:WriteSBitLong( cookie, 32 )

				local cvarname = read:ReadString()
				write:WriteString( cvarname )
				
				debugprint( "svc_GetCvarValue", cvarname )
			end
		},
		
		[ svc_CmdKeyValues ] = { -- 32
			DefaultCopy = function( netchan, read, write )
				write:WriteUBitLong( svc_CmdKeyValues, NET_MESSAGE_BITS )
				
				local length = read:ReadLong()
				write:WriteLong( length )
				
				local keyvalues = read:ReadBits( length * 8 )
				write:WriteBits( keyvalues, length * 8 )
				keyvalues:Delete()
				
				debugprint( "svc_CmdKeyValues", length )
			end
		},
	}
}