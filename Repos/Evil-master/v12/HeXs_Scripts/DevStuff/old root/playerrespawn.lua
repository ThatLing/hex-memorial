function playerRespawn( player )
   playerName = player.GetName( player );
   Msg( " " .. playerName .. " has respawned. " );
end
 
hook.Add( "PlayerSpawn", "playerRespawnTest", playerRespawn );

