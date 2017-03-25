
LUA->PushSpecial(0); //_G
	LUA->GetField(-1, "hook");
		LUA->GetField(-1, "Run");
			LUA->PushString("CanDoStuff");
			LUA->PushString("Test");
			LUA->PushNumber(1337);
			LUA->PushNumber(8);
		int CallError = LUA->PCall(4,1,0);
		
		//Error with hook
		if (CallError) {
			const char* Error = LUA->GetString();
			LUA->Pop();
			
			Warning("! Error: %s\n", Error);
			
		//Ran ok
		} else {
			
			//Bool
			if ( LUA->IsType(-1, Type::BOOL) ) {
				Warning("! Bool returned\n");
				
			//String
			} else if ( LUA->IsType(-1, Type::STRING) ) {
				const char* Ret = LUA->GetString();
				
				Warning("! String returned: %s\n", Ret);
			}
		}
		LUA->Pop();
	LUA->Pop();
LUA->Pop();