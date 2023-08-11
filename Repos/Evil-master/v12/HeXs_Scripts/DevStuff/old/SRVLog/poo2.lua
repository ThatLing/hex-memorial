

require("gsapi")

hook.Add( "GSReputation", "GMTRep", function( eResult, repScore, isBanned, bannedInfo )

	Msg( "Got GSReputation!\n" )
	Msg( "EResult: ", eResult, "\n" )
	
	--if ( eResult != EResultOK ) then return end
	
	Msg( "Reputation: ", repScore, "\n" )
	Msg( "Is Banned: ", isBanned, "\n" )
	PrintTable( bannedInfo )
	Msg( "\n\n" )
	
end )

hook.Add( "GSGameStats", "GMTGameStats", function( eResult, rank, totalConnects, totalMinsPlayed )  
   
     Msg( "Got GSGameStats!\n" )  
     Msg( "EResult: ", eResult, "\n" )  
       
     --if ( eResult != EResultOK ) then return end  
       
     Msg( "Rank: ", rank, "\n" )  
     Msg( "Total Connects: ", totalConnects, "\n" )  
     Msg( "Total Mins Played: ", totalMinsPlayed, "\n\n" )       
 end ) 
 
print(gameserver.GetPublicIP())
gameserver.GetGameplayStats()