/*
	=== gmsv_dns_win32 ===
	*DNS Lookup*
*/


#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "Ws2_32.lib")
#pragma comment(lib, "Dnsapi.lib")
#pragma comment(lib, "iphlpapi.lib")

#include <string>

#include <windows.h>

#include <winsock2.h>  //winsock
#include <iphlpapi.h>
#include <icmpapi.h>
#include <windns.h>   //DNS api's
#include <stdio.h>	//standard i/o

#include <ILuaModuleManager.h>


ILuaInterface*	sv_Lua = NULL;




LUA_FUNCTION(Ping) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_NUMBER);
	
	const char* IPAddress = sv_Lua->GetString(1);
	int Timeout = sv_Lua->GetNumber(2);
	
	unsigned long ipaddr = INADDR_NONE;
	ipaddr = inet_addr(IPAddress);
	
	if (ipaddr == INADDR_NONE) {
		sv_Lua->Push(false);
		sv_Lua->Push("Invalid IP address");
		return 2;
	}
	
	HANDLE hIcmpFile = IcmpCreateFile();
	if (hIcmpFile == INVALID_HANDLE_VALUE) {
		sv_Lua->Push(false);
		sv_Lua->Push("Unable to open handle");
		sv_Lua->Push( (const char)GetLastError() );
		return 3;
	}
	
	
	char SendData[32] = "Data Buffer";
	
	DWORD ReplySize = sizeof(ICMP_ECHO_REPLY) + sizeof(SendData);
	LPVOID ReplyBuffer = (VOID*)malloc(ReplySize);
	if (ReplyBuffer == NULL) {
		sv_Lua->Push(false);
		sv_Lua->Push("Unable to allocate memory");
		return 2;
	}
	
	DWORD dwRetVal = IcmpSendEcho(hIcmpFile, ipaddr, SendData, sizeof(SendData), NULL, ReplyBuffer, ReplySize, Timeout);
	
	if (dwRetVal == 0) {
		sv_Lua->Push(false);
		sv_Lua->Push("Host offline/unreachable");
		sv_Lua->Push( (const char)GetLastError() );
		return 3;
	}
	
	
	PICMP_ECHO_REPLY pEchoReply = (PICMP_ECHO_REPLY)ReplyBuffer;
	
	if (pEchoReply == 0) {
		sv_Lua->Push(false);
		sv_Lua->Push("No pEchoReply");
		return 2;
	}
	
	sv_Lua->Push(true);
	sv_Lua->Push( (int)pEchoReply->RoundTripTime );
	sv_Lua->Push( (int)pEchoReply->Status );
	return 3;
}


//DNS Lookup
LUA_FUNCTION(Lookup) {
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	const char* Lookup = sv_Lua->GetString(1);
	const char* Server = sv_Lua->GetString(2);
	
	PIP4_ARRAY pSrvList = (PIP4_ARRAY)LocalAlloc(LPTR, sizeof(IP4_ARRAY) );
	if (!pSrvList){
		sv_Lua->Push(false);
		sv_Lua->Push("pSrvList allocation failed");
		return 2;
	}
	
	pSrvList->AddrCount = 1;
	pSrvList->AddrArray[0] = inet_addr(Server);
	
	
	PDNS_RECORD pDnsRecord;
	DNS_STATUS status = DnsQuery(Lookup, DNS_TYPE_A, DNS_QUERY_BYPASS_CACHE, pSrvList, &pDnsRecord, NULL);
	
	LocalFree(pSrvList);
	
	if (status) {
		sv_Lua->Push(false);
		sv_Lua->Push("Failed to query the host");
		sv_Lua->Push( (int)status );
		return 3;
		
	} else {
		DNS_FREE_TYPE freetype = DnsFreeRecordListDeep;
		
		IN_ADDR ipaddr;
		ipaddr.S_un.S_addr = (pDnsRecord->Data.A.IpAddress);
		
		const char* Result = inet_ntoa(ipaddr);
		DnsRecordListFree(pDnsRecord, freetype);
		
		sv_Lua->Push(Result);
		return 1;
	}
}







GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	
	sv_Lua->NewGlobalTable("dns");
	ILuaObject* dns = sv_Lua->GetGlobal("dns");
		dns->SetMember("Ping",		Ping);
		dns->SetMember("Lookup",	Lookup);
	dns->UnReference();
	
	return 0;
}


int Close(lua_State *L) {
	return 0;
}









