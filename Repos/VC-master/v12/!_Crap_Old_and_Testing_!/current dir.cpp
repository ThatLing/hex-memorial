

	sv_Lua->CheckType(1, GLua::TYPE_STRING);
	string fullPath;
	
	if (sv_Lua->GetString(1)[1] == ':') {
		fullPath = sv_Lua->GetString(1);
	} else {
		char workingDir [256];
		_getcwd(workingDir, 256);
		
		fullPath = workingDir;
		fullPath += "\\garrysmod\\";
		fullPath += sv_Lua->GetString(1);
	}
	const char* path = fullPath.c_str();




