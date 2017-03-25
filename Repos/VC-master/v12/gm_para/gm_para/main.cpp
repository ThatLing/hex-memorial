/*
	=== gm_para ===
	*Paralell port control from GLua*
	
	Credits:
		. Logix4u (InpOut32.dll)
		. Henry00 (Bits and bytes)
		. HeX
*/

#undef _UNICODE

#include <GMLuaModule.h>
#include <Windows.h>

ILuaInterface* sv_Lua	= NULL;
int LAST_BYTE 			= 0;

//InpOut32
HINSTANCE InpOut32;
typedef short (__stdcall* lpInp32)(short);			//Input
lpInp32 Inp32;

typedef void  (__stdcall* lpOut32)(short,short);	//Output
lpOut32 Out32;


//Read
LUA_FUNCTION(ReadByte) {
	sv_Lua->CheckType(1, GLua::TYPE_NUMBER);
	
	sv_Lua->Push( (float)Inp32( sv_Lua->GetInteger(1) ) );
	return 1;
}

//Write
LUA_FUNCTION(WriteByte) {
	sv_Lua->CheckType(1, GLua::TYPE_NUMBER);
	sv_Lua->CheckType(2, GLua::TYPE_NUMBER);
	
	LAST_BYTE = sv_Lua->GetInteger(2);
	
	if ((LAST_BYTE > 255) || (LAST_BYTE < 0)) { //Whoops
		sv_Lua->Error("[gm_para]: What are you doing, min 0, max 255!\n");
	}
	
	Out32( sv_Lua->GetInteger(1), LAST_BYTE);
	return 0;
}



LUA_FUNCTION(DoBeep) {
	sv_Lua->CheckType(1, GLua::TYPE_NUMBER);
	sv_Lua->CheckType(2, GLua::TYPE_NUMBER);
	
	Beep( sv_Lua->GetInteger(1), sv_Lua->GetInteger(2) );
	return 0;
}






GMOD_MODULE(Open,Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	
	InpOut32 = LoadLibrary("garrysmod/lua/includes/modules/InpOut32.dll");
	if (!InpOut32) {
		sv_Lua->Error("[gm_para]: No InpOut32.dll in modules folder!\n");
	}
	
	Inp32 = (lpInp32)GetProcAddress(InpOut32, "Inp32");
	Out32 = (lpOut32)GetProcAddress(InpOut32, "Out32");
	
	if (!Inp32 || !Out32) {
		sv_Lua->Error("[gm_para]: Can't get Inp32/Out32 from InpOut32.dll!\n");
	}
	
	
	sv_Lua->NewGlobalTable("para");
	ILuaObject* para = sv_Lua->GetGlobal("para");
		para->SetMember("Read",		ReadByte);
		para->SetMember("Write",	WriteByte);
		para->SetMember("Beep",		DoBeep);
	para->UnReference();
	
	
	/*
		Data Register
		Bit     D0  D1  D2  D3  D4  D5  D6  D7
		Value   1   2   4   8   16  32  64  128
	*/
	sv_Lua->SetGlobal("DP_NONE", (float)0 );
	sv_Lua->SetGlobal("DP_ALL", (float)255 );
	
	sv_Lua->SetGlobal("DP0", (float)1 );
	sv_Lua->SetGlobal("DP1", (float)2 );
	sv_Lua->SetGlobal("DP2", (float)4 );
	sv_Lua->SetGlobal("DP3", (float)8 );
	sv_Lua->SetGlobal("DP4", (float)16 );
	sv_Lua->SetGlobal("DP5", (float)32 );
	sv_Lua->SetGlobal("DP6", (float)64 );
	sv_Lua->SetGlobal("DP7", (float)128 );
	
	
	/*
		Status Register
		Bit     SP3  SP4  SP5  SP6  SP7
		Value   8    16   32   64   128
	*/
	sv_Lua->SetGlobal("SP_NONE", (float)0 );
	sv_Lua->SetGlobal("SP_ALL", (float)248 );
	
	sv_Lua->SetGlobal("SP3", (float)8 );
	sv_Lua->SetGlobal("SP4", (float)16 );
	sv_Lua->SetGlobal("SP5", (float)32 );
	sv_Lua->SetGlobal("SP6", (float)64 );
	sv_Lua->SetGlobal("SP7", (float)128 );
	
	return 0;
}

int Close(lua_State *L) {
	FreeLibrary(InpOut32);
	return 0;
}









