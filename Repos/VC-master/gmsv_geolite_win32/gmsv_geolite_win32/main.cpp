

#pragma comment (linker, "/NODEFAULTLIB:libcmt")
#pragma comment(lib, "vstdlib.lib")
#pragma comment(lib, "tier0.lib")
#pragma comment(lib, "tier1.lib")
#pragma comment(lib, "WSock32.lib")
#pragma comment(lib, "MsWSock.lib")
#pragma comment(lib, "ws2_32.lib")

#pragma comment(lib, "zlibwapi.lib")
#pragma comment(lib, "zlibstat.lib")


#include <ILuaModuleManager.h>

ILuaInterface* sv_Lua = NULL;


#include <winsock2.h>
#include "libGeoIP/GeoIP.h"
#include "libGeoIP/GeoIPCity.h"

GeoIP* COUNTRY;
GeoIP* ISP;
GeoIP* ORG;
GeoIP* CITY;
GeoIP* ASN;
GeoIP* NET;


void SafeSetMember(ILuaObject* Tab, const char* what, const char* val) {
	if (val != NULL) {
		Tab->SetMember(what,val);
	}
}

bool GeoIPToLua(const char* ipstring, ILuaObject* Tab) {
	if (!COUNTRY) return false;
	
	GeoIPRecord* gir = GeoIP_record_by_addr(COUNTRY, ipstring);
	
	if (gir) {
		SafeSetMember(Tab,"city",			gir->city);
		SafeSetMember(Tab,"country_name",	gir->country_name);
		SafeSetMember(Tab,"region",			gir->region);
		SafeSetMember(Tab,"country_code",	gir->country_code);
		SafeSetMember(Tab,"postcode",		gir->postal_code);
		
		Tab->SetMember("lat",				gir->latitude);
		Tab->SetMember("long",				gir->longitude);
		Tab->SetMember("mask",		(double)gir->netmask);
		
		GeoIPRecord_delete(gir);
	}
	
	if (CITY) {
		gir = GeoIP_record_by_addr(CITY, ipstring);
		
		if (gir) {
			SafeSetMember(Tab, "CITY",				gir->city);
			SafeSetMember(Tab, "COUNTRY_NAME",		gir->country_name);
			SafeSetMember(Tab, "REGION",			gir->region);
			SafeSetMember(Tab, "COUNTRY_CODE",		gir->country_code);
			SafeSetMember(Tab, "POSTCODE",			gir->postal_code);
			
			Tab->SetMember("LAT",					gir->latitude);
			Tab->SetMember("LONG",					gir->longitude);
			Tab->SetMember("MASK",			(double)gir->netmask);
			GeoIPRecord_delete(gir);
		}
	}
	
	if (ISP) {
		SafeSetMember(Tab, "ISP", GeoIP_org_by_name(ISP, ipstring) );
	}
	if (ORG) {
		SafeSetMember(Tab, "org", GeoIP_name_by_name(ORG, ipstring) );
	}
	if (ASN) {
		SafeSetMember(Tab, "asn", GeoIP_org_by_name(ASN, ipstring) );
	}
	if (NET) {
		Tab->SetMember("speed", (double)GeoIP_id_by_name(NET, ipstring) );
	}
	
	return true;
}


LUA_FUNCTION(Lookup) {
	sv_Lua->CheckType(1, Type::STRING);
	const char* ipstring = sv_Lua->GetString(1);
	
	ILuaObject* Tab = sv_Lua->GetNewTable();
		bool ret = GeoIPToLua(ipstring,Tab);
		
		if (ret) {
			sv_Lua->Push(Tab);
		} else {
			sv_Lua->Push(false);
		}
	Tab->UnReference();
	
	return 1;
}


LUA_FUNCTION(IsLAN) {
	sv_Lua->CheckType(1, Type::STRING);
	
	sv_Lua->Push( (bool)GeoIP_is_private_v4( sv_Lua->GetString(1) ) );
	return 1;
}



#define LOAD_DB(what,datname,how) 	what = GeoIP_open("garrysmod/lua/bin/"datname".dat", how);\
	if (what == NULL)\
		what = GeoIP_open(datname".dat", how);\
	if (what != NULL) GeoIP_set_charset(what, GEOIP_CHARSET_UTF8);\



GMOD_MODULE(Open, Close);

int Open(lua_State *L) {
	sv_Lua = Lua();
	
	LOAD_DB(COUNTRY, 	"GeoIP", 		GEOIP_INDEX_CACHE);
	LOAD_DB(CITY,		"GeoLiteCity",	GEOIP_INDEX_CACHE);
	/*
	LOAD_DB(ISP,		"GeoIPISP",		GEOIP_INDEX_CACHE);
	LOAD_DB(ORG,		"GeoIPOrg",		GEOIP_INDEX_CACHE);
	LOAD_DB(ASN,		"GeoIPASNum",	GEOIP_INDEX_CACHE);
	LOAD_DB(NET,		"GeoIPNetSpeed",GEOIP_INDEX_CACHE);
	*/
	
	ILuaObject* Tab = sv_Lua->GetNewTable();
		Tab->SetMember("Lookup", 	Lookup);
		Tab->SetMember("IsLAN",		IsLAN);
	sv_Lua->Global()->SetMember("geolite", Tab);
	
	Tab->UnReference();
	
	return 0;
}


int Close(lua_State *L) {
	GeoIP_delete(COUNTRY);
	GeoIP_delete(ISP);
	GeoIP_delete(ORG);
	GeoIP_delete(CITY);
	GeoIP_delete(ASN);
	GeoIP_delete(NET);
	
	return 0;
}






























