	FileFindHandle_t handle;
	
	for (const char *fname = FileSys->FindFirst("lua/menu_plugins/*.lua", &handle); fname != NULL; fname = FileSys->FindNext(handle)) {
		ConColorMsg(Sexy, 	"[MenuPlugins");
		ConColorMsg(Green, 	"5");
		ConColorMsg(Sexy, 	"]: ");
		
		char flua[MAX_PATH];
		*flua = '\0';
		
		strcat(flua, "menu_plugins/");
		strcat(flua, fname);
		
		char* str = new char[256];
			sprintf(str, "include('%s.lua')", flua);
			
			ml_Lua->Msg("! was about to load: %s.lua!\n", flua);
			//RunStringReal(RSLua, flua, "", str, true, true);
		delete [] str;
	}
	
	FileSys->FindClose(handle);