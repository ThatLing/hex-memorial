#include <eiface.h>
#include <tier1/bitbuf.h>
#include <inetchannelinfo.h>
#include <edict.h>

#include "GarrysMod/Lua/Interface.h"
#include "interface.h"

#include "vtable.h"
#include "conv.h"


#define LUA_HOOK_NAME ("ReadPacket") // player, name, ...
#define INVALID_PACKET_HOOK_NAME ("InvalidPacket") // player, id

class CServerGameClients;

CServerGameClients *clients;
IVEngineServer *server;

#define vtindex_receivepacket_intrnl (72 / 4)

#ifdef _WIN32
#define vtindex_receivepacket vtindex_receivepacket_intrnl
#else
#define vtindex_receivepacket vtindex_receivepacket_intrnl
#endif

VTable *clients_vt = 0;

const char *types[] = {
	"NetMessage",
	0,
	"LuaError",
	0,
	"RequestLuaFile",
};

lua_State *st = 0;
#define LAU (st->luabase)

using namespace GarrysMod;

void __hook GMOD_ReceiveClientMessage_Hook(CServerGameClients *ths, HOOK_EDX(void *) int unk1, edict_t *ent, bf_read *read, int length)
{
	typedef void(__thiscall *OriginalFn)(CServerGameClients *, int, edict_t *, bf_read *, int);

	unsigned int current = read->m_iCurBit;


	int byte = read->ReadByte();


	LAU->PushSpecial(Lua::SPECIAL_GLOB); // 0
	if (ent->m_EdictIndex == 0)
		LAU->PushNil();
	else
	{
		LAU->GetField(-1, "Entity"); // 1
		LAU->PushNumber(ent->m_EdictIndex); // 2
		LAU->Call(1, 1); // 1
	}
	LAU->GetField(-2, "hook"); // 2
	LAU->GetField(-1, "Run"); // 3

	

	if (length < 0 || byte >= sizeof(types) / sizeof(*types) || byte < 0 || types[byte] == 0)
	{

		if (length < 0)
		{
			length = -length;

			*(int *)read->m_pData = length;

		}

		LAU->PushString(INVALID_PACKET_HOOK_NAME); // 4
		LAU->Push(-4); // 5
		LAU->PushString(server->GetPlayerNetInfo(ent->m_EdictIndex)->GetAddress()); // 6
		LAU->PushNumber(byte); // 7

		LAU->Call(4, 0);
		LAU->Pop(3); // 0
		return;
	}
	else
	{

		LAU->PushString(LUA_HOOK_NAME); // 4
		LAU->Push(-4); // 5
		LAU->PushString(server->GetPlayerNetInfo(ent->m_EdictIndex)->GetAddress()); // 6
		LAU->PushString(types[byte]); // 7

		int args = 4;

		if (byte == 0)
		{
			LAU->PushNumber(read->ReadBitLong(16, false)); // 8
			args++;
		}
		else if (byte == 2)
		{
			int charcount;
			char temp[0x10000];
			read->ReadString(temp, sizeof(temp), false, &charcount);
			LAU->PushString(temp, charcount);
			args++;
		}
		else if (byte == 4)
		{
			LAU->CreateTable(); // 8
			unsigned short crc = read->ReadBitLong(16, false);
			int i = 1;
			while (crc != 0 && !read->IsOverflowed())
			{
				LAU->PushNumber(i); // 9
				LAU->PushNumber(crc); // 10
				LAU->SetTable(-3); // 8
				i++;
				crc = read->ReadBitLong(16, false);
			}
			args++;
		}

		LAU->Call(args, 1);

		bool dontprocess = LAU->GetBool(-1);
		LAU->Pop(4);
		if (dontprocess) return;

	}


	read->m_iCurBit = current;

	OriginalFn(clients_vt->getold(vtindex_receivepacket))(ths, unk1, ent, read, length);

}

GMOD_MODULE_OPEN() {

	st = state;
	clients = GetInterface<CServerGameClients *>("server", "ServerGameClients003");
	
	if(!clients)
		clients = GetInterface<CServerGameClients *>("server_srv", "ServerGameClients003");
		
	if(!clients)
		clients = GetInterface<CServerGameClients *>("dedicated_srv", "ServerGameClients003");
		
	if(!clients)
		clients = GetInterface<CServerGameClients *>("dedicated", "ServerGameClients003");

	if (!clients)
		LUA->ThrowError("Unable to fetch CServerGameClients class!");

	server = GetInterface<IVEngineServer *>("engine", "VEngineServer021");
	
	if(!server)
		server = GetInterface<IVEngineServer *>("engine_srv", "VEngineServer021");

	if (!server)
		LUA->ThrowError("Unable to fetch IVEngineServer class!");

	clients_vt = new VTable(clients);


	clients_vt->hook(vtindex_receivepacket, (void *)&GMOD_ReceiveClientMessage_Hook);


	return 0;
}

GMOD_MODULE_CLOSE() {
	delete clients_vt;
	clients_vt = 0;
	return 0;
}
