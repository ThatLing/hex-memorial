
--[[
	extras.GetMapName()
	extras.GetPlayerName( userid )
	extras.GetPlayerLogo( userid )
	extras.GetMaxPlayers()
	extras.GetScreenAspectRatio()
	extras.GetAllPlayers()
	extras.GetPlayerIndex( userid )
	extras.GetPlayerSteamID( userid )
	extras.GetFriendID( userid )
	extras.LocalPlayerUserID()
	extras.GetKeyForBinding( bind )
	extras.GetIP()
	extras.Print( color, txt )
	extras.GetAppID()
	extras.GetEngineBuildNumber()
	extras.GetProductVersionString() -- Seems to crash game
	extras.EmitCloseCaption( caption )
	extras.ServerCommand( cmd ) 
	extras.ExecuteClientCmd( cmd ) -- Seems to crash game
	extras.ClientCmd_Unrestricted( cmd ) -- Seems to crash game
	extras.ForceConVar( cvar, value )
	extras.IsDrawingLoadingImage()
	extras.IsInEditMode() -- Seems to crash game
	extras.IsConnected()
	extras.IsFakePlayer( userid )
	extras.IsInGame()
	extras.IsLowViolence() -- Seems to crash game
	extras.IsHammerRunning() -- Seems to crash game
	extras.IsConsoleVisible()
	extras.IsPaused()
	extras.IsPlayingDemo()
	extras.IsPlayingTimeDemo()
	extras.IsRecordingDemo()
	extras.IsTakingScreenshot()
	extras.SetEyeAngles( angle )
	extras.SupportsHDR()
	extras.GetDXSupportLevel()
]]

if not extras then
	local function Useless()
		print("! extras table gone !")
	end
	
	extras.GetMapName 				= Useless
	extras.GetPlayerName 			= Useless
	extras.GetPlayerLogo 			= Useless
	extras.GetMaxPlayers 			= Useless
	extras.GetScreenAspectRatio 	= Useless
	extras.GetAllPlayers 			= Useless
	extras.GetPlayerIndex 			= Useless
	extras.GetPlayerSteamID 		= Useless
	extras.GetFriendID 				= Useless
	extras.LocalPlayerUserID 		= Useless
	extras.GetKeyForBinding			= Useless
	extras.GetIP 					= Useless
	extras.Print 					= Useless
	extras.GetAppID					= Useless
	extras.GetEngineBuildNumber 	= Useless
	extras.GetProductVersionString	= Useless
	extras.EmitCloseCaption 		= Useless
	extras.ServerCommand 			= Useless
	extras.ExecuteClientCmd 		= Useless
	extras.ClientCmd_Unrestricted	= Useless
	extras.ForceConVar 				= Useless
	extras.IsDrawingLoadingImage 	= Useless
	extras.IsInEditMode 			= Useless
	extras.IsConnected 				= Useless
	extras.IsFakePlayer 			= Useless
	extras.IsInGame 				= Useless
	extras.IsLowViolence 			= Useless
	extras.IsHammerRunning 			= Useless
	extras.IsConsoleVisible 		= Useless
	extras.IsPaused 				= Useless
	extras.IsPlayingDemo 			= Useless
	extras.IsPlayingTimeDemo 		= Useless
	extras.IsRecordingDemo 			= Useless
	extras.IsTakingScreenshot 		= Useless
	extras.SetEyeAngles 			= Useless
	extras.SupportsHDR 				= Useless
	extras.GetDXSupportLevel 		= Useless
end

