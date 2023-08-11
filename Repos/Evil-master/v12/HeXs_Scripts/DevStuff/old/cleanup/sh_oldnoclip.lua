--AddCSLuaFile("noclip.lua")

if( CLIENT ) then
	
	/*------------------------------------
		CreateMove()
	------------------------------------*/
	local function CreateMove( cmd )
	
		local pl = LocalPlayer();
		if( IsValid( pl ) ) then
	
			// manage movement speeds in noclip, overrides new noclip
			if( pl:GetMoveType() == MOVETYPE_NOCLIP || pl:GetMoveType() == MOVETYPE_OBSERVER ) then
			
				local up = 0;
				local right = 0;
				local forward = 0;
				local maxspeed = pl:GetMaxSpeed();
				
				if( cmd:KeyDown( IN_DUCK ) ) then
				
					up = up - maxspeed;
				
				end
				if( cmd:KeyDown( IN_JUMP ) ) then
				
					up = up + maxspeed;
					
				end				
				// forward/back
				if( cmd:KeyDown( IN_FORWARD ) ) then
				
					forward = forward + maxspeed;
				
				end
				if( cmd:KeyDown( IN_BACK ) ) then
				
					forward = forward - maxspeed;
				
				end
				
				// left/right
				if( cmd:KeyDown( IN_MOVERIGHT ) ) then
				
					right = right + maxspeed;
				
				end
				if( cmd:KeyDown( IN_MOVELEFT ) ) then
				
					right = right - maxspeed;
				
				end
				
				// set speeds
				cmd:SetUpMove( up );
				cmd:SetForwardMove( forward );
				cmd:SetSideMove( right );
				
			end
		
		end
	
	end
	hook.Add( "CreateMove", "Noclip.CreateMove", CreateMove );

end

/*------------------------------------
	Move()
------------------------------------*/
local function Move( pl, mv )

	// only override the new noclip
	if( pl:GetMoveType() != MOVETYPE_NOCLIP and pl:GetMoveType() != MOVETYPE_OBSERVER ) then
	
		return;
		
	end
	
	local deltaTime = FrameTime();
	
	// I hate having to get these by name like this.
	local noclipSpeed = GetConVarNumber( "sv_noclipspeed" );
	local noclipAccelerate = GetConVarNumber( "sv_noclipaccelerate" );
	
	// calculate acceleration for this frame.
	local ang = mv:GetMoveAngles();
	local acceleration = ( ang:Forward() * mv:GetForwardSpeed() ) + ( ang:Right() * mv:GetSideSpeed() ) + ( Vector( 0, 0, 1 ) * mv:GetUpSpeed() );
	
	// clamp to our max speed, and take into account noclip speed
	local accelSpeed = math.min( acceleration:Length(), pl:GetMaxSpeed() );
	local accelDir = acceleration:GetNormal();
	acceleration = accelDir * accelSpeed * noclipSpeed;
	
	// calculate final velocity with friction
	local newVelocity = mv:GetVelocity() + acceleration * deltaTime * noclipAccelerate;
	newVelocity = newVelocity * ( 0.95 - deltaTime * 4 ); 

	// set velocity
	mv:SetVelocity( newVelocity );
	
	// move the player
	local newOrigin = mv:GetOrigin() + newVelocity * deltaTime;
	mv:SetOrigin( newOrigin );

	return true;

end
hook.Add( "Move", "Noclip.Move", Move );

