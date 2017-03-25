#ifndef ICLIENT_NEW_H
#define ICLIENT_NEW_H

#include <inetmessage.h>
#include <inetmsghandler.h>
#include "tier0/platform.h"


class IGameEvent;
class IServer;

class IClient : public INetChannelHandler
{
public:
	/* 0 */ virtual					~IClient();
	/* 1 */ virtual	void 			ConnectionStart(INetChannel *);
	/* 2 */ virtual	void			ConnectionClosing(char  const*);
	/* 3 */ virtual	void			ConnectionCrashed(char  const*);
	/* 4 */ virtual	void			PacketStart(int, int);
	/* 5 */ virtual	void			PacketEnd(void);
	/* 6 */ virtual	void			FileRequested(char  const*, unsigned int);
	/* 7 */ virtual	void			FileReceived(char  const*, unsigned int);
	/* 8 */ virtual	void			FileDenied(char  const*, unsigned int);
	/* 9 */ virtual	void			FileSent(char  const*, unsigned int);
	/* 10 */ virtual void			Connect(const char * szName, int nUserID, INetChannel *pNetChannel, bool bFakePlayer) = 0;
	/* 11 */ virtual void			Inactivate( void ) = 0;
	/* 12 */ virtual void			Reconnect( void ) = 0;
	/* 13 */ virtual void			Disconnect( const char *reason, ... ) = 0;
	/* 14 */ virtual int			GetPlayerSlot() const = 0;
	/* 15 */ virtual int			GetUserID() const = 0;
	/* 16 */ virtual const int		GetNetworkID() const = 0;
	/* 17 */ virtual const char*	GetClientName() const = 0;
	/* 18 */ virtual INetChannel*	GetNetChannel() = 0;
	/* 19 */ virtual IServer*		GetServer() = 0;
	/* 20 */ virtual const char*	GetUserSetting(const char *cvar) const = 0;
	/* 21 */ virtual const char*	GetNetworkIDString() const = 0;
	/* 22 */ virtual void			SetRate( int nRate, bool bForce ) = 0;
	/* 23 */ virtual int			GetRate( void ) const = 0;
	/* 24 */ virtual void			SetUpdateRate( int nUpdateRate, bool bForce ) = 0;
	/* 25 */ virtual int			GetUpdateRate( void ) const = 0;
	/* 26 */ virtual void			Clear( void ) = 0;
	/* 27 */ virtual int			GetMaxAckTickCount() const = 0;
	/* 28 */ virtual bool			ExecuteStringCommand( const char *s ) = 0;
	/* 29 */ virtual bool			SendNetMsg(INetMessage &msg, bool bForceReliable = false) = 0;
	/* 30 */ virtual void			ClientPrintf (const char *fmt, ...) = 0;
	/* 31 */ virtual bool			IsConnected( void ) const = 0;
	/* 32 */ virtual bool			IsSpawned( void ) const = 0;
	/* 33 */ virtual bool			IsActive( void ) const = 0;
	/* 34 */ virtual bool			IsFakeClient( void ) const = 0;
	/* 35 */ virtual bool			IsHLTV( void ) const = 0;
	/* 36 */ virtual bool			IsReplay(void);
	/* 37 */ virtual bool			IsHearingClient(int index) const = 0;
	/* 38 */ virtual bool			IsProximityHearingClient(int index) const = 0;
	/* 39 */ virtual void			SetMaxRoutablePayloadSize( int nMaxRoutablePayloadSize ) = 0;
};

#endif // ICLIENT_NEW_H

















