
/*
	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	sv_Lua->CheckType(2, GLua::TYPE_STRING);
	
	string szSID 	= sv_Lua->GetString(1);
	string szSID_2	= sv_Lua->GetString(2);
	
	SID_64 SID 		= stoull(szSID);
	SID_64 SID_2	= stoull(szSID_2);
	
	Warning("! SID out: %s\n", to_string(SID) );
	Warning("! SID2 out: %s\n", to_string(SID_2) );
	
	SID_64 Out = SID - SID_2;
	Warning("! SID2 minus: %s\n", to_string(Out).c_str() );
*/

/*
SID_64 SID 		= FromString( sv_Lua->GetString(1) );
SID_64 SID_2	= FromString( sv_Lua->GetString(2) );

Warning("! Size SID: %s\n", sizeof(SID) );
Warning("! Size SID2: %s\n", sizeof(SID_2) );

const char* Out = ToString(SID - SID_2);

Warning("! Out: %s\n",Out);
*/

