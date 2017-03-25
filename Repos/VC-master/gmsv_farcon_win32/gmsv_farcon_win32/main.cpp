#undef _UNICODE
#define GAME_DLL
#define WIN32_LEAN_AND_MEAN

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")
#pragma comment(lib, "detours.lib")
#pragma comment(lib, "ws2_32.lib")


#include "sv_rcon.h"
#include "cbytescanner.h"
#include "csimpledetour.h"


#include <bitbuf.h>

#include <ILuaModuleManager.h>


// Hook helpers
#define CLASSFUNC __stdcall
#define STORETHISPTR() void *_this;__asm MOV _this, ECX

// Signatures
#define CServerRemoteAccess_LogCommand_Signature \
	"\x55" \
	"\x8B\xEC" \
	"\xA1\xB4\x25\x7D\x61" \
	"\x83\x78\x30\x00" \
	"\x74\x51" \
	"\x8B\x45\x08" \
	"\x3B\x41\x44"

#define CServerRemoteAccess_LogCommand_Mask "xxxx????xxxxx?xxxxxx"

//Fangli 01
#define CServerRemoteAccess_WriteDataRequest_Signature "\xE8\xC5\xE9\xFF\xFF\x83\xC4\x0C\x84\xC0\x0F\x84\x0E\x03\x00\x00\x68\x00\x02\x00\x00"
#define CServerRemoteAccess_WriteDataRequest_Mask "?????xxxxx??????xxxxx"

#define CServerRemoteAccess_CheckPassword_Signature \
	"\x55" \
	"\x8B\xEC" \
	"\x8B\x45\x14" \
	"\x53" \
	"\x56" \
	"\x8B\x75\x08" \
	"\x8B\xD9" \
	"\x50" \
	"\x8B\xCE"

#define CServerRemoteAccess_CheckPassword_Mask "xxxxxxxxxxxxxxxx"


#define CRConServer_IsPassword_Signature \
	"\x55" \
	"\x8B\xEC" \
	"\x56" \
	"\x8D\x71\x40" \
	"\x8B\xCE"

#define CRConServer_IsPassword_Mask "xxxxxxxxx"



ILuaInterface* sv_Lua = NULL;
netadr_s* passwordCheckAddress = NULL;



void ( CLASSFUNC *CServerRemoteAccess_LogCommand_T )( unsigned int listener, const char *msg );
void CLASSFUNC CServerRemoteAccess_LogCommand_H( unsigned int listener, const char *msg );

SETUP_SIMPLE_DETOUR( CServerRemoteAccess_LogCommand_Detour, CServerRemoteAccess_LogCommand_T, CServerRemoteAccess_LogCommand_H );


void ( CLASSFUNC *CServerRemoteAccess_WriteDataRequest_T )( CRConServer *conn, unsigned int listener, const void *pData, int len );
void CLASSFUNC CServerRemoteAccess_WriteDataRequest_H( CRConServer *conn, unsigned int listener, const void *pData, int len );

SETUP_SIMPLE_DETOUR( CServerRemoteAccess_WriteDataRequest_Detour, CServerRemoteAccess_WriteDataRequest_T, CServerRemoteAccess_WriteDataRequest_H );


void ( CLASSFUNC *CServerRemoteAccess_CheckPassword_T)( CRConServer *conn, unsigned int listener, int id, const char *password );
void CLASSFUNC CServerRemoteAccess_CheckPassword_H( CRConServer *conn, unsigned int listener, int id, const char *password );

SETUP_SIMPLE_DETOUR( CServerRemoteAccess_CheckPassword_Detour, CServerRemoteAccess_CheckPassword_T, CServerRemoteAccess_CheckPassword_H );


bool ( CLASSFUNC *CRConServer_IsPassword_T)( const char *password );
bool CLASSFUNC CRConServer_IsPassword_H( const char *password );

SETUP_SIMPLE_DETOUR( CRConServer_IsPassword_Detour, CRConServer_IsPassword_T, CRConServer_IsPassword_H );




netadr_s* ListenerIDToAddress(CServerRemoteAccess* CRA, unsigned int id) {
	unsigned int pos = (id*8)-id;
	
	netadr_s* addr;
	
	__asm {
		PUSH ECX
		PUSH EAX
		PUSH EDX
		MOV ECX, CRA
		MOV EAX, [ECX+0x2C]
		MOV ECX, pos
		LEA EDX, [EAX+ECX*0x04]
		LEA EAX, [EDX+0x08]
		MOV addr, EAX
		POP EDX
		POP EAX
		POP ECX
	}
	
	return addr;
}

void CLASSFUNC CServerRemoteAccess_LogCommand_H(unsigned int listener, const char* msg) {
	STORETHISPTR();
	
	//Sender address
	netadr_s* addr = ListenerIDToAddress( (CServerRemoteAccess*)_this, listener);
	
	if (addr) {
		//Call hook
		ILuaObject* hookTable = sv_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hookTable->GetMember("Call");
				hookCall->Push();
				sv_Lua->Push("RCON_LogCommand");
				sv_Lua->PushNil();
				sv_Lua->Push(msg);
				sv_Lua->Push( addr->ToString(true) );
				sv_Lua->Push( addr->GetPort() );
				sv_Lua->Call(5,1);
			hookCall->UnReference();
		hookTable->UnReference();
		
		//Check return value
		ILuaObject* returnValue = sv_Lua->GetReturn(0);
			bool returnIsNil = returnValue->isNil();
		returnValue->UnReference();
		
		//Don't call original function if a value is returned
		if (!returnIsNil) {
			return;
		}
	}
	
	//Call original function
	__asm {
		PUSH msg
		PUSH listener
		MOV ECX, _this
		CALL CServerRemoteAccess_LogCommand_T
	}
}

void CLASSFUNC CServerRemoteAccess_WriteDataRequest_H(CRConServer* conn, unsigned int listener, const void* pData, int len) {
	STORETHISPTR();
	
	//Sender address
	netadr_s* addr = ListenerIDToAddress( (CServerRemoteAccess *)_this, listener);

	if (addr) {
		//Sender data
		bf_read buffer(pData,len);
			long id = buffer.ReadLong();
			long request = buffer.ReadLong();
			char str[1024];
		buffer.ReadString(str, 1024);
		
		if ( !buffer.IsOverflowed() ) {
			//Call hook
			ILuaObject* hookTable = sv_Lua->GetGlobal("hook");
				ILuaObject* hookCall = hookTable->GetMember("Call");
					hookCall->Push();
					sv_Lua->Push("RCON_WriteDataRequest");
					sv_Lua->PushNil();
					sv_Lua->Push(id);
					sv_Lua->Push(request);
					sv_Lua->Push(str);
					sv_Lua->Push( addr->ToString(true) );
					sv_Lua->Push( addr->GetPort() );
					sv_Lua->Call(7,1);
				hookCall->UnReference();
			hookTable->UnReference();
			
			// Check return value
			ILuaObject* returnValue = sv_Lua->GetReturn( 0 );
				bool returnIsNil = returnValue->isNil();
			returnValue->UnReference();
			
			//Don't call original function if a value is returned
			if ( !returnIsNil ) {
				return;
			}
		}
	}
	
	//Call original function
	__asm {
		PUSH len
		PUSH pData
		PUSH listener
		PUSH conn
		MOV ECX, _this
		CALL CServerRemoteAccess_WriteDataRequest_T
	}
}


void CLASSFUNC CServerRemoteAccess_CheckPassword_H(CRConServer* conn, unsigned int listener, int id, const char* password) {
	STORETHISPTR();
	
	//Store address for CRConServer::IsPassword
	//Password checking can't be done in this function because it doesn't have a return value
	passwordCheckAddress = ListenerIDToAddress( (CServerRemoteAccess*)_this, listener);
	
	//Call original function
	__asm {
		PUSH password
		PUSH id
		PUSH listener
		PUSH conn
		MOV ECX, _this
		CALL CServerRemoteAccess_CheckPassword_T
	}
}


bool CLASSFUNC CRConServer_IsPassword_H(const char * password) {
	STORETHISPTR();
	
	if (passwordCheckAddress) {
		//Call hook
		ILuaObject* hookTable = sv_Lua->GetGlobal("hook");
			ILuaObject* hookCall = hookTable->GetMember("Call");
				hookCall->Push();
				sv_Lua->Push("RCON_CheckPassword");
				sv_Lua->PushNil();
				sv_Lua->Push(password);
				sv_Lua->Push( passwordCheckAddress->ToString(true) );
				sv_Lua->Push( passwordCheckAddress->GetPort() );
				sv_Lua->Call(5,1);
			hookCall->UnReference();
		hookTable->UnReference();
		
		//Check return value
		ILuaObject* returnValue = sv_Lua->GetReturn(0);
		
		bool returnIsNil = returnValue->isNil();	
		bool returnResponse = returnValue->GetBool();
		
		returnValue->UnReference();
		
		//Reset stored address
		passwordCheckAddress = NULL;
		
		//Return custom password response if specified
		if ( !returnIsNil ) {
			return returnResponse;
		}
	}
	
	//Call original function
	__asm {
		PUSH password
		MOV ECX, _this
		CALL CRConServer_IsPassword_T
	}
}



GMOD_MODULE(Open, Close);

int Open(lua_State* L) {
	sv_Lua = Lua();
	
	CByteScanner engineScanner("engine.dll");
	
	//CServerRemoteAccess::LogCommand
	if ( engineScanner.FindCodePattern( CServerRemoteAccess_LogCommand_Signature, CServerRemoteAccess_LogCommand_Mask, (LPVOID *)&CServerRemoteAccess_LogCommand_T ) ) {
		CServerRemoteAccess_LogCommand_Detour.Attach();
	} else {
		sv_Lua->ErrorNoHalt("[gmsv_rcon] CServerRemoteAccess::LogCommand signature scan failed. Please report this error.\n");
	}
	
	//CServerRemoteAccess::WriteDataRequest
	if ( engineScanner.FindCodePattern( CServerRemoteAccess_WriteDataRequest_Signature, CServerRemoteAccess_WriteDataRequest_Mask, (LPVOID *)&CServerRemoteAccess_WriteDataRequest_T ) ) {
		CServerRemoteAccess_WriteDataRequest_Detour.Attach();
	}else {
		sv_Lua->ErrorNoHalt("[gmsv_rcon] CServerRemoteAccess::WriteDataRequest signature scan failed. Please report this error.\n");
	}
	
	//CServerRemoteAccess::CheckPassword
	if ( engineScanner.FindCodePattern( CServerRemoteAccess_CheckPassword_Signature, CServerRemoteAccess_CheckPassword_Mask, (LPVOID *)&CServerRemoteAccess_CheckPassword_T ) ) {
		CServerRemoteAccess_CheckPassword_Detour.Attach();
	} else {
		sv_Lua->ErrorNoHalt("[gmsv_rcon] CServerRemoteAccess::CheckPassword signature scan failed. Please report this error.\n");
	}
	
	//CRConServer::IsPassword
	if ( engineScanner.FindCodePattern( CRConServer_IsPassword_Signature, CRConServer_IsPassword_Mask, (LPVOID *)&CRConServer_IsPassword_T ) ) {
		CRConServer_IsPassword_Detour.Attach();
	} else {
		sv_Lua->ErrorNoHalt("[gmsv_rcon] CRConServer::IsPassword signature scan failed. Please report this error.\n");
	}
	
	
	return 0;
}


int Close(lua_State* L) {
	CServerRemoteAccess_LogCommand_Detour.Detach();
	CServerRemoteAccess_WriteDataRequest_Detour.Detach();
	CServerRemoteAccess_CheckPassword_Detour.Detach();
	CRConServer_IsPassword_Detour.Detach();
	
	return 0;
}


















