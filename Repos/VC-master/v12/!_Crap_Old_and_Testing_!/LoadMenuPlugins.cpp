




void LoadMenuPlugins() {
	if (!FileSys) {
		ConColorMsg(Sexy, 	"[in_MenuPlugins");
		ConColorMsg(White, 	"4");
		ConColorMsg(Sexy, 	"]: ");
		ConColorMsg(White, "Can't get FileSys :(\n");
		return;
	}
	
	FileFindHandle_t handle;
	for (const char *fname = FileSys->FindFirst("lua/menu_plugins/*", &handle); fname != NULL; fname = FileSys->FindNext(handle)) {
		char ext[32];
		V_ExtractFileExtension(fname, ext, 32);
		
		if (!strcmp(ext, "lua")) {
			char flua[MAX_PATH];
			*flua = '\0';
			
			strcat(flua, "menu_plugins/");
			strcat(flua, fname);
			
			char* str = new char[256];
				ConColorMsg(Sexy, 	"[in_MenuPlugins");
				ConColorMsg(White, 	"4");
				ConColorMsg(Sexy, 	"]: ");		
				sprintf(str, "Loading lua/%s..\n", flua);
				ConColorMsg(White, str);
			delete [] str;
			
			//ml_Lua->Msg("! was about to load: %s!\n", flua);
			
			string fullPath;
			
			char workingDir [256];
			_getcwd(workingDir,256);
			fullPath = workingDir;
			
			fullPath += "\\garrysmod\\lua\\menu_plugins\\";
			fullPath += File;
			
			ifstream ReadFile;
			ReadFile.open(fullPath.c_str(), ios::binary);
			
			
			if (!ReadFile.is_open()) {
				char* str = new char[MAX_PATH];
					sprintf(str, " Can't open %s, won't work from addons!\n", File);
					ConColorMsg(Sexy, 	"[in_MenuPlugins");
					ConColorMsg(White, 	"4");
					ConColorMsg(Sexy, 	"]: ");
					ConColorMsg(White, str);
					return;
				delete [] str;
			}
			
			ReadFile.seekg(0, ios::end);
				int length = ReadFile.tellg();
			ReadFile.seekg(0, ios::beg);
			
			char* buffer = new char[length+1];
				ReadFile.read(buffer,length);
				buffer[length] = 0;
				
				ml_Lua->RunString("", "[in_MenuPlugins4]", buffer, true, true);
			delete [] buffer;
		}
	}
	
	FileSys->FindClose(handle);
}

