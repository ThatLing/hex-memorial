

#pragma once

#define GMODLUASHAREDINTERFACE "LuaShared002"


enum {
	LUA_INTERFACE_CLIENT = 0,
	LUA_INTERFACE_SERVER,
	LUA_INTERFACE_MENU
};


class ILuaShared {
	public:
	/* 0 */ virtual 				~ILuaShared();
	/* 1 */ virtual void 			Init(void * (*)(char  const*,int *),bool, void *); //, CSteamAPIContext *, IGet * 
	/* 2 */ virtual void 			Shutdown(void);
	/* 3 */ virtual void 			DumpStats(void);
	/* 4 */ virtual void 			CreateLuaInterface(unsigned char,bool);
	/* 5 */ virtual void 			CloseLuaInterface(ILuaInterfaceInternal *);
	/* 6 */ virtual ILuaInterfaceInternal* 	GetLuaInterface(unsigned char);
	/* 7 */ virtual void			LoadFile(const char* ,const char* ,bool,bool); //std::string  const&,std::string  const&
	/* 8 */ virtual void 			GetCache(const char&); //std::string  const&
	/* 9 */ virtual void 			MountLua(char  const*);
	/* 10 */ virtual void 			MountLuaAdd(char  const*,char  const*);
	/* 11 */ virtual void 			UnMountLua(char  const*);
	/* 12 */ virtual void 			SetFileContents(char  const*,char  const*);
	/* 13 */ virtual void 			SetLuaFindHook(void); //LuaClientDatatableHook *
	/* 14 */ virtual void 			FindScripts(void); //std::string  const&,std::string  const&,std::vector<std::string,std::allocator<std::string>> &
};


























