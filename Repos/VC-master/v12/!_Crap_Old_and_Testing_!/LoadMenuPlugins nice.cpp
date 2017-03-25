
void LoadMenuPlugins() {
	if (!FileSys) {
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"4");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(White, "Can't get FileSys :(\n");
		return;
	}
	/*
	FileFindHandle_t handle;
	for (const char *File = FileSys->FindFirst("lua/menu_plugins/*", &handle); File != NULL; File = FileSys->FindNext(handle)) {
		char ext[32];
		V_ExtractFileExtension(File, ext, 32);
		
		if (!strcmp(ext, "lua")) {
			string fullPath;
			
			char workingDir [256];
			_getcwd(workingDir,256);
			fullPath = workingDir;
			
			fullPath += "\\garrysmodbeta\\lua\\menu_plugins\\";
			fullPath += File;
			
			ifstream ReadFile;
			ReadFile.open(fullPath.c_str(), ios::binary);
			
			char* str = new char[MAX_PATH];
				if (!ReadFile.is_open()) {
					sprintf(str, " Can't open lua/menu_plugins/%s, won't work from addons!\n", File);
					ConColorMsg(Sexy, 	"[in_MenuPlugins");
					ConColorMsg(White, 	"4");
					ConColorMsg(Sexy, 	"]: ");
					ConColorMsg(White, str);
					return;
				}
				
				ReadFile.seekg(0, ios::end);
					int length = ReadFile.tellg();
				ReadFile.seekg(0, ios::beg);
				
				char* buffer = new char[length+1];
					ReadFile.read(buffer,length);
					buffer[length] = 0;
					
					ConColorMsg(Sexy, 	"[in_MenuPlugins");
					ConColorMsg(White, 	"4");
					ConColorMsg(Sexy, 	"]: ");		
					sprintf(str, "Loading lua/menu_plugins/%s..\n", File);
					ConColorMsg(White, str);
					
					ml_Lua->Msg("! code: %s\n", buffer);
					Sleep(500);
					ml_Lua->RunString("", File, buffer, true, true);
				delete [] buffer;
			delete [] str;
		}
	}
	
	FileSys->FindClose(handle);
	*/
	
	ml_Lua->Msg("! test");
	
	g_EngineClient->ClientCmd("lua_run_in include('in_menuplugins.lua')");
}
