

class MLPlugins: public IServerPluginCallbacks, public IGameEventListener {
public:
	MLPlugins();
	~MLPlugins();
	
	virtual bool			Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory);
	virtual void			Unload(void);
	virtual void			Pause(void);
	virtual void			UnPause(void);
	virtual const char     *GetPluginDescription(void);      
	virtual void			LevelInit(char const *pMapName);
	virtual void			ServerActivate(edict_t *pEdictList, int edictCount, int clientMax);
	virtual void			GameFrame(bool simulating);
	virtual void			LevelShutdown(void);
	virtual void			ClientActive(edict_t *pEntity);
	virtual void			ClientDisconnect(edict_t *pEntity);
	virtual void			ClientPutInServer(edict_t *pEntity, char const *playername);
	virtual void			SetCommandClient(int index);
	virtual void			ClientSettingsChanged(edict_t *pEdict);
	virtual PLUGIN_RESULT	ClientConnect(bool *Allow, edict_t *Ent, const char *Name, const char *IP, char *reject, int Len);
	virtual PLUGIN_RESULT	ClientCommand(edict_t *pEntity, const CCommand &args);
	virtual PLUGIN_RESULT	NetworkIDValidated(const char *pszUserName, const char *pszNetworkID);
	virtual void			OnQueryCvarValueFinished(QueryCvarCookie_t Cookie, edict_t *Ply, EQueryCvarValueStatus Status, const char *CName, const char *CVal);
	
	virtual void			OnEdictAllocated(edict_t *edict);
	virtual void			OnEdictFreed(const edict_t *edict);	
	
	virtual void			FireGameEvent(KeyValues * event);

	virtual int				GetCommandIndex() { return m_iClientCommandIndex; }
private:
	int						m_iClientCommandIndex;
};





