
LUA_FUNCTION(ReplicateVar) {
	if (!g_ICvar) {
		ml_Lua->Push(false);
		return 1;
	}
	
	ml_Lua->CheckType(1, GLua::TYPE_STRING);
	ml_Lua->CheckType(2, GLua::TYPE_STRING);
	ml_Lua->CheckType(3, GLua::TYPE_NUMBER);
	ml_Lua->CheckType(4, GLua::TYPE_STRING);
	
	const char* origCvarName	=	ml_Lua->GetString(1);
	const char* newCvarName		=	ml_Lua->GetString(2);
	int origFlags				=	ml_Lua->GetInteger(3);
	const char* defaultValue	=	ml_Lua->GetString(4);
	
	ConVar* pCvar = g_ICvar->FindVar( origCvarName );
	
	if (!pCvar) {
		ml_Lua->Push(false);
		return 1;
	}
	
	if (origFlags < 0) {
		origFlags = pCvar->m_nFlags;
	}
	ConVar* pNewVar = (ConVar*)malloc( sizeof ConVar );
	
	memcpy( pNewVar, pCvar,sizeof( ConVar ));
	pNewVar->m_pNext = 0;
	g_ICvar->RegisterConCommand( pNewVar );
	pCvar->m_pszName = new char[50];
	
	
	char tmp[50];
	Q_snprintf(tmp, sizeof(tmp), "%s", newCvarName);
	strcpy((char*)pCvar->m_pszName, tmp);
	pCvar->m_nFlags = FCVAR_NONE;
	
	ml_Lua->Push(true);
	return 1;
}
