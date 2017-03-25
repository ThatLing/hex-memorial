
class MLPlugins : public IServerPluginCallbacks
{
public:
	virtual bool Load(CreateInterfaceFn interfaceFactory, CreateInterfaceFn gameServerFactory);
	virtual void Unload();

	virtual void Pause();
	virtual void UnPause();

	virtual const char *GetPluginDescription();

	virtual void LevelInit(const char *pMapName);
	virtual void ServerActivate(edict_t *pEdictList, int edictCount, int clientMax);
	virtual void GameFrame(bool simulating);
	virtual void LevelShutdown();
	virtual void ClientActive(edict_t *pEntity);
	virtual void ClientDisconnect(edict_t *pEntity);
	virtual void ClientPutInServer(edict_t *pEntity, const char *playername);
	virtual void SetCommandClient(int index);
	virtual void ClientSettingsChanged(edict_t *pEdict);
	
	virtual PLUGIN_RESULT ClientConnect(bool *bAllowConnect, edict_t *pEntity, const char *pszName, const char *pszAddress, char *reject, int maxrejectlen);
	virtual PLUGIN_RESULT ClientCommand(edict_t *pEntity, const CCommand &args);
	virtual PLUGIN_RESULT NetworkIDValidated(const char *pszUserName, const char *pszNetworkID);
	
	virtual void OnQueryCvarValueFinished(QueryCvarCookie_t iCookie, edict_t *pPlayerEntity, EQueryCvarValueStatus eStatus, const char *pCvarName, const char *pCvarValue);
	virtual void OnEdictAllocated(edict_t *edict);
	virtual void OnEdictFreed(const edict_t *edict);
	virtual void FireGameEvent(KeyValues * event);
	virtual int	 GetCommandIndex() { return m_iClientCommandIndex; }
private:
	int						m_iClientCommandIndex;
};


