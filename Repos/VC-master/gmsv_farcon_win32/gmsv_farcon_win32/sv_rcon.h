#ifndef SV_RCON_H
#define SV_RCON_H

#include <netadr.h>
#include <utllinkedlist.h>

class CRConServer;

struct CServerRemoteListener
{
	char padding[0x08];
	netadr_s addr;
};

class CServerRemoteAccess;

#endif // SV_RCON_H