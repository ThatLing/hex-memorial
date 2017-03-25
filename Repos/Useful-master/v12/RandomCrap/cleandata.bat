
@echo off

D:
cd "D:\Steam\steamapps\user\garrysmod\garrysmod\data"



::FuckFile
rd /S /Q "ULib"
rd /S /Q "FSAMod"
rd /S /Q "ass_config_server.txt"
rd /S /Q "ass_debug_sv.txt"
rd /S /Q "ass_rankings.txt"
rd /S /Q "ev_globalvars.txt"
rd /S /Q "ev_playerinfo.txt"
rd /S /Q "ev_userranks.txt"


rd /S /Q "ASSMod"
rd /S /Q "achievements"
rd /S /Q "ulx"
rd /S /Q "luapad"
rd /S /Q "GPUChip"
rd /S /Q "CPUChip"
rd /S /Q "playx"
rd /S /Q "StarfallScriptData"
rd /S /Q "ez_rollercoaster"
rd /S /Q "jcdata"
rd /S /Q "aowl"
rd /S /Q "ULib"
rd /S /Q "youtube player"

del "particle materials.txt"
del "stargate.cvar.check.txt"
del "scarhud.txt"
del "scarkeybindings.txt"
del "scarradiochannels.txt"
del "scarcam.txt"
del "ev_globalvars.txt"
del "ass_config_client.txt"
del "hoverboards.txt"
del "smartsnap_offsets_custom.txt"
del "motd*.*"


cd ..

del "temp_html_page.html"
del "lua_errors_client.txt"
del "lua_errors_server.txt"

rd /S /Q "lua_temp"

::FuckFile
cd cfg
rd /S /Q "banned_user.cfg"
rd /S /Q "banned_ip.cfg"

cd ..

cd settings\spawnlist

del "wiremod stuff.txt"
del "teletubbies_hl2mp.txt"
del "stargate.txt"
del "sgamp.txt"
del "carter_s addon pack.txt"
del "carter_s addon pack - ramps.txt"
del "carter_s addon pack - catwalkbuild.txt"
del "carter_s addon pack - capbuild.txt"









