
----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------



local physmeta 	= FindMetaTable("PhysObj")
local entmeta 	= FindMetaTable("Entity")
local wepmeta 	= FindMetaTable("Weapon")
local vecmeta 	= FindMetaTable("Vector")





if not physmeta.SetAngleVelocity then
	function physmeta:SetAngleVelocity(vel)
		self:AddAngleVelocity( -self:GetAngleVelocity() + vel)
	end
end


MAX_COORD_INTEGER			= (16384)
MIN_COORD_INTEGER			= (-MAX_COORD_INTEGER)
MAX_COORD_FRACTION			= (1.0-(1.0/16.0))
MIN_COORD_FRACTION			= (-1.0+(1.0/16.0))

MAX_COORD_FLOAT				= (16384.0)
MIN_COORD_FLOAT				= (-MAX_COORD_FLOAT)

COORD_EXTENT				= (2*MAX_COORD_INTEGER)

MAX_TRACE_LENGTH			= (1.732050807569 * COORD_EXTENT)		

MAX_COORD_RANGE				= (MAX_COORD_INTEGER)


function ASSERT_COORD(v) Error(2) end



HL2_WEAPONS = {
	"weapon_357",
	"weapon_ar2",
	// "weapon_bugbait",
	"weapon_crossbow",
	"weapon_crowbar",
	"weapon_frag",
	"weapon_pistol",
	"weapon_rpg",
	"weapon_shotgun",
	"weapon_smg1",
	"weapon_stunstick"
}




local SetNextPrimaryFire 	= wepmeta.SetNextPrimaryFire
local SetNextSecondaryFire 	= wepmeta.SetNextSecondaryFire

function wepmeta:SetNextPrimaryFire(timestamp)
	timestamp = timestamp - CurTime()
	timestamp = timestamp / GetConVarNumber("phys_timescale")
	
	SetNextPrimaryFire(self, CurTime() + timestamp)
end


function wepmeta:SetNextSecondaryFire(timestamp)
	timestamp = timestamp - CurTime()
	timestamp = timestamp / GetConVarNumber("phys_timescale")
	
	SetNextSecondaryFire(self, CurTime() + timestamp)
end







function vecmeta:__unm(vec)
	return -1 * vec
end

function VectorAdd(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	c.x = a.x + b.x;
	c.y = a.y + b.y;
	c.z = a.z + b.z;
	
	return c
end

function VectorSubtract(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	c.x = a.x - b.x;
	c.y = a.y - b.y;
	c.z = a.z - b.z;
	
	return c
end


function VectorMultiply(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	
	if ( type( b ) == "number" ) then
		c.x = a.x * b;
		c.y = a.y * b;
		c.z = a.z * b;
	elseif ( ( type( b ) == "Vector" ) ) then
		c.x = a.x * b.x;
		c.y = a.y * b.y;
		c.z = a.z * b.z;
	end
	
	return c
end

// Get a random vector.
function RandomVector(minVal, maxVal)
	local random;
	random = Vector( math.Rand( minVal, maxVal ), math.Rand( minVal, maxVal ), math.Rand( minVal, maxVal ) );
	return random;
end

// for backwards compatability
function VectorScale(input,scale,result)
	return VectorMultiply(input,scale,result);
end



function VectorNormalize(v)
	local l = v:Length();
	if (l != 0.0) then
		v = v / l;
	else
		// FIXME:
		// Just copying the existing implemenation; shouldn't res.z == 0?
		v.x = 0.0;
		v.y = 0.0; v.z = 1.0;
	end
	
	return v;
end


function CrossProduct(a, b)
	return Vector( a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x );
end

function RandomAngle( minVal, maxVal )
	local random = vec3_angle;
	
	random.pitch = math.Rand( minVal, maxVal );
	random.yaw   = math.Rand( minVal, maxVal );
	random.roll  = math.Rand( minVal, maxVal );
	
	return Angle( random.pitch, random.yaw, random.roll )
end



function string.Strip(text, to_be_stripped)
	return string.Replace(text, to_be_stripped, "")
end


ENTITY_INTOLERANCE	= 100





function RemapValClamped(val,A,B,C,D)
	if ( A == B ) then
		if ( val >= B ) then
			return D;
		else
			return C;
		end
	end
	
	local cVal = (val - A) / (B - A);
	cVal = math.Clamp( cVal, 0.0, 1.0 );
	
	return C + (D - C) * cVal;
end


function AngleNegate(a)
	a.pitch = -a.pitch;
	a.yaw   = -a.yaw;
	a.roll  = -a.roll;

	return a
end

function VectorNegate(a)
	a.x = -a.x;
	a.y = -a.y;
	a.z = -a.z;

	return a
end


function VectorMAInline(start,scale,direction,dest)
	dest = dest || vec3_origin
	dest.x=start.x+direction.x*scale;
	dest.y=start.y+direction.y*scale;
	dest.z=start.z+direction.z*scale;
	
	return dest
end

function VectorMA(start,scale,direction,dest)
	return VectorMAInline(start, scale, direction, dest);
end





DBL_DIG         = 15                      /* # of decimal digits of precision */
DBL_EPSILON     = 2.2204460492503131e-016 /* smallest such that 1.0+DBL_EPSILON != 1.0 */
DBL_MANT_DIG    = 53                      /* # of bits in mantissa */
DBL_MAX         = 1.7976931348623158e+308 /* max value */
DBL_MAX_10_EXP  = 308                     /* max decimal exponent */
DBL_MAX_EXP     = 1024                    /* max binary exponent */
DBL_MIN         = 2.2250738585072014e-308 /* min positive value */
DBL_MIN_10_EXP  = (-307)                  /* min decimal exponent */
DBL_MIN_EXP     = (-1021)                 /* min binary exponent */
_DBL_RADIX      = 2                       /* exponent radix */
_DBL_ROUNDS     = 1                       /* addition rounding: near */

FLT_DIG         = 6                       /* # of decimal digits of precision */
FLT_EPSILON     = 1.192092896e-07         /* smallest such that 1.0+FLT_EPSILON != 1.0 */
FLT_GUARD       = 0
FLT_MANT_DIG    = 24                      /* # of bits in mantissa */
FLT_MAX         = 3.402823466e+38         /* max value */
FLT_MAX_10_EXP  = 38                      /* max decimal exponent */
FLT_MAX_EXP     = 128                     /* max binary exponent */
FLT_MIN         = 1.175494351e-38         /* min positive value */
FLT_MIN_10_EXP  = (-37)                   /* min decimal exponent */
FLT_MIN_EXP     = (-125)                  /* min binary exponent */
FLT_NORMALIZE   = 0
FLT_RADIX       = 2                       /* exponent radix */
FLT_ROUNDS      = 1                       /* addition rounding: near */

LDBL_DIG        = DBL_DIG                 /* # of decimal digits of precision */
LDBL_EPSILON    = DBL_EPSILON             /* smallest such that 1.0+LDBL_EPSILON != 1.0 */
LDBL_MANT_DIG   = DBL_MANT_DIG            /* # of bits in mantissa */
LDBL_MAX        = DBL_MAX                 /* max value */
LDBL_MAX_10_EXP = DBL_MAX_10_EXP          /* max decimal exponent */
LDBL_MAX_EXP    = DBL_MAX_EXP             /* max binary exponent */
LDBL_MIN        = DBL_MIN                 /* min positive value */
LDBL_MIN_10_EXP = DBL_MIN_10_EXP          /* min decimal exponent */
LDBL_MIN_EXP    = DBL_MIN_EXP             /* min binary exponent */
_LDBL_RADIX     = DBL_RADIX               /* exponent radix */
_LDBL_ROUNDS    = DBL_ROUNDS              /* addition rounding: near */





WEAPON_ALTFIRE_HUD_HINT_COUNT	= 1
WEAPON_RELOAD_HUD_HINT_COUNT	= 1


SF_WEAPON_START_CONSTRAINED	= 0
SF_WEAPON_NO_PLAYER_PICKUP	= 1
SF_WEAPON_NO_PHYSCANNON_PUNT = 2

CLIP_PERC_THRESHOLD		= 0.75


VECTOR_CONE_PRECALCULATED	= vec3_origin
vec3_origin					= vector_origin
vec3_angle					= Angle( 0, 0, 0 )
VECTOR_CONE_1DEGREES		= Vector( 0.00873, 0.00873, 0.00873 )
VECTOR_CONE_2DEGREES		= Vector( 0.01745, 0.01745, 0.01745 )
VECTOR_CONE_3DEGREES		= Vector( 0.02618, 0.02618, 0.02618 )
VECTOR_CONE_4DEGREES		= Vector( 0.03490, 0.03490, 0.03490 )
VECTOR_CONE_5DEGREES		= Vector( 0.04362, 0.04362, 0.04362 )
VECTOR_CONE_6DEGREES		= Vector( 0.05234, 0.05234, 0.05234 )
VECTOR_CONE_7DEGREES		= Vector( 0.06105, 0.06105, 0.06105 )
VECTOR_CONE_8DEGREES		= Vector( 0.06976, 0.06976, 0.06976 )
VECTOR_CONE_9DEGREES		= Vector( 0.07846, 0.07846, 0.07846 )
VECTOR_CONE_10DEGREES		= Vector( 0.08716, 0.08716, 0.08716 )
VECTOR_CONE_15DEGREES		= Vector( 0.13053, 0.13053, 0.13053 )
VECTOR_CONE_20DEGREES		= Vector( 0.17365, 0.17365, 0.17365 )




// This is mainly for the benefit of Lua programmers, developers, and beta testers.
SWEP_BASES			= true
SWEP_BASES_VERSION	= 323
SWEP_BASES_AUTHOR	= "Andrew McWatters"







if (!entmeta.gFireBullets) then
	entmeta.gFireBullets = entmeta.FireBullets
end


local FireBullets = entmeta.FireBullets

if ( !entmeta.FirePenetratingBullets ) then
	function entmeta:FirePenetratingBullets( attacker, trace, dmginfo )
		local Penetration	= self.Penetration	|| 1
		// Direction (and length) that we are gonna penetrate
		local Dir			= trace.Normal * 16;
		if ( trace.MatType == MAT_ALIENFLESH	||
			 trace.MatType == MAT_DIRT			||
			 trace.MatType == MAT_FLESH			||
			 trace.MatType == MAT_WOOD ) then -- dirt == plaster, and wood should be easier to penetrate so increase the distance
			Dir = trace.Normal * ( 16 * Penetration );
		end
		if ( !attacker:IsValid() ) then return end
		if ( !dmginfo:IsBulletDamage() ) then return end

		local t				= {}
		t.start				= trace.HitPos + Dir
		t.endpos			= trace.HitPos
		t.filter			= self.Owner
		t.mask				= MASK_SHOT
		local tr			= util.TraceLine( t )
		// Bullet didn't penetrate.
		if ( tr.StartSolid			||
			 tr.Fraction	>= 1.0	||
			 trace.Fraction	<= 0.0 ) then return end
		// Fire bullet from the exit point using the original tradjectory
		local info		= {}
		info.Src		= tr.HitPos
		info.Attacker	= attacker
		info.Dir		= trace.Normal
		info.Spread		= vec3_origin
		info.Num		= 1
		info.Damage		= dmginfo:GetDamage()
		info.Callback = function( attacker, trace, dmginfo )
			return self:FirePenetratingBullets( attacker, trace, dmginfo )
		end;
		info.Tracer		= 0
		self:FireBullets( info )
		
		return {
			damage	= true,
			effects	= true
		}
	end
end


function util.ImpactTrace(traceHit, pPlayer)
	if ( traceHit.MatType == MAT_GRATE ) then
		return;
	end
	
	local vecSrc		= traceHit.StartPos;
	local vecDirection	= traceHit.Normal;
	
	if ( pPlayer && pPlayer:IsPlayer() ) then
		vecSrc			= pPlayer:GetShootPos();
		vecDirection	= pPlayer:GetAimVector();
	else
		pPlayer			= GetWorldEntity()
	end
	
	local info			= {
		Src			= vecSrc,
		Dir			= vecDirection,
		Num			= 1,
		Damage		= 0,
		Force		= 0,
		Tracer		= 0,
		Callback	= function(attacker,tr,dmginfo)
			return {
				damage		= false,
				effects		= true
			}
		end,
	};

	return FireBullets( pPlayer, info );
end















----------------------------------------
--         2014-07-12 20:32:50          --
------------------------------------------



local physmeta 	= FindMetaTable("PhysObj")
local entmeta 	= FindMetaTable("Entity")
local wepmeta 	= FindMetaTable("Weapon")
local vecmeta 	= FindMetaTable("Vector")





if not physmeta.SetAngleVelocity then
	function physmeta:SetAngleVelocity(vel)
		self:AddAngleVelocity( -self:GetAngleVelocity() + vel)
	end
end


MAX_COORD_INTEGER			= (16384)
MIN_COORD_INTEGER			= (-MAX_COORD_INTEGER)
MAX_COORD_FRACTION			= (1.0-(1.0/16.0))
MIN_COORD_FRACTION			= (-1.0+(1.0/16.0))

MAX_COORD_FLOAT				= (16384.0)
MIN_COORD_FLOAT				= (-MAX_COORD_FLOAT)

COORD_EXTENT				= (2*MAX_COORD_INTEGER)

MAX_TRACE_LENGTH			= (1.732050807569 * COORD_EXTENT)		

MAX_COORD_RANGE				= (MAX_COORD_INTEGER)


function ASSERT_COORD(v) Error(2) end



HL2_WEAPONS = {
	"weapon_357",
	"weapon_ar2",
	// "weapon_bugbait",
	"weapon_crossbow",
	"weapon_crowbar",
	"weapon_frag",
	"weapon_pistol",
	"weapon_rpg",
	"weapon_shotgun",
	"weapon_smg1",
	"weapon_stunstick"
}




local SetNextPrimaryFire 	= wepmeta.SetNextPrimaryFire
local SetNextSecondaryFire 	= wepmeta.SetNextSecondaryFire

function wepmeta:SetNextPrimaryFire(timestamp)
	timestamp = timestamp - CurTime()
	timestamp = timestamp / GetConVarNumber("phys_timescale")
	
	SetNextPrimaryFire(self, CurTime() + timestamp)
end


function wepmeta:SetNextSecondaryFire(timestamp)
	timestamp = timestamp - CurTime()
	timestamp = timestamp / GetConVarNumber("phys_timescale")
	
	SetNextSecondaryFire(self, CurTime() + timestamp)
end







function vecmeta:__unm(vec)
	return -1 * vec
end

function VectorAdd(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	c.x = a.x + b.x;
	c.y = a.y + b.y;
	c.z = a.z + b.z;
	
	return c
end

function VectorSubtract(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	c.x = a.x - b.x;
	c.y = a.y - b.y;
	c.z = a.z - b.z;
	
	return c
end


function VectorMultiply(a,b,c)
	if ( !a ) then return end;
	if ( !b ) then return end;
	
	local c = c || vec3_origin
	
	if ( type( b ) == "number" ) then
		c.x = a.x * b;
		c.y = a.y * b;
		c.z = a.z * b;
	elseif ( ( type( b ) == "Vector" ) ) then
		c.x = a.x * b.x;
		c.y = a.y * b.y;
		c.z = a.z * b.z;
	end
	
	return c
end

// Get a random vector.
function RandomVector(minVal, maxVal)
	local random;
	random = Vector( math.Rand( minVal, maxVal ), math.Rand( minVal, maxVal ), math.Rand( minVal, maxVal ) );
	return random;
end

// for backwards compatability
function VectorScale(input,scale,result)
	return VectorMultiply(input,scale,result);
end



function VectorNormalize(v)
	local l = v:Length();
	if (l != 0.0) then
		v = v / l;
	else
		// FIXME:
		// Just copying the existing implemenation; shouldn't res.z == 0?
		v.x = 0.0;
		v.y = 0.0; v.z = 1.0;
	end
	
	return v;
end


function CrossProduct(a, b)
	return Vector( a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x );
end

function RandomAngle( minVal, maxVal )
	local random = vec3_angle;
	
	random.pitch = math.Rand( minVal, maxVal );
	random.yaw   = math.Rand( minVal, maxVal );
	random.roll  = math.Rand( minVal, maxVal );
	
	return Angle( random.pitch, random.yaw, random.roll )
end



function string.Strip(text, to_be_stripped)
	return string.Replace(text, to_be_stripped, "")
end


ENTITY_INTOLERANCE	= 100





function RemapValClamped(val,A,B,C,D)
	if ( A == B ) then
		if ( val >= B ) then
			return D;
		else
			return C;
		end
	end
	
	local cVal = (val - A) / (B - A);
	cVal = math.Clamp( cVal, 0.0, 1.0 );
	
	return C + (D - C) * cVal;
end


function AngleNegate(a)
	a.pitch = -a.pitch;
	a.yaw   = -a.yaw;
	a.roll  = -a.roll;

	return a
end

function VectorNegate(a)
	a.x = -a.x;
	a.y = -a.y;
	a.z = -a.z;

	return a
end


function VectorMAInline(start,scale,direction,dest)
	dest = dest || vec3_origin
	dest.x=start.x+direction.x*scale;
	dest.y=start.y+direction.y*scale;
	dest.z=start.z+direction.z*scale;
	
	return dest
end

function VectorMA(start,scale,direction,dest)
	return VectorMAInline(start, scale, direction, dest);
end





DBL_DIG         = 15                      /* # of decimal digits of precision */
DBL_EPSILON     = 2.2204460492503131e-016 /* smallest such that 1.0+DBL_EPSILON != 1.0 */
DBL_MANT_DIG    = 53                      /* # of bits in mantissa */
DBL_MAX         = 1.7976931348623158e+308 /* max value */
DBL_MAX_10_EXP  = 308                     /* max decimal exponent */
DBL_MAX_EXP     = 1024                    /* max binary exponent */
DBL_MIN         = 2.2250738585072014e-308 /* min positive value */
DBL_MIN_10_EXP  = (-307)                  /* min decimal exponent */
DBL_MIN_EXP     = (-1021)                 /* min binary exponent */
_DBL_RADIX      = 2                       /* exponent radix */
_DBL_ROUNDS     = 1                       /* addition rounding: near */

FLT_DIG         = 6                       /* # of decimal digits of precision */
FLT_EPSILON     = 1.192092896e-07         /* smallest such that 1.0+FLT_EPSILON != 1.0 */
FLT_GUARD       = 0
FLT_MANT_DIG    = 24                      /* # of bits in mantissa */
FLT_MAX         = 3.402823466e+38         /* max value */
FLT_MAX_10_EXP  = 38                      /* max decimal exponent */
FLT_MAX_EXP     = 128                     /* max binary exponent */
FLT_MIN         = 1.175494351e-38         /* min positive value */
FLT_MIN_10_EXP  = (-37)                   /* min decimal exponent */
FLT_MIN_EXP     = (-125)                  /* min binary exponent */
FLT_NORMALIZE   = 0
FLT_RADIX       = 2                       /* exponent radix */
FLT_ROUNDS      = 1                       /* addition rounding: near */

LDBL_DIG        = DBL_DIG                 /* # of decimal digits of precision */
LDBL_EPSILON    = DBL_EPSILON             /* smallest such that 1.0+LDBL_EPSILON != 1.0 */
LDBL_MANT_DIG   = DBL_MANT_DIG            /* # of bits in mantissa */
LDBL_MAX        = DBL_MAX                 /* max value */
LDBL_MAX_10_EXP = DBL_MAX_10_EXP          /* max decimal exponent */
LDBL_MAX_EXP    = DBL_MAX_EXP             /* max binary exponent */
LDBL_MIN        = DBL_MIN                 /* min positive value */
LDBL_MIN_10_EXP = DBL_MIN_10_EXP          /* min decimal exponent */
LDBL_MIN_EXP    = DBL_MIN_EXP             /* min binary exponent */
_LDBL_RADIX     = DBL_RADIX               /* exponent radix */
_LDBL_ROUNDS    = DBL_ROUNDS              /* addition rounding: near */





WEAPON_ALTFIRE_HUD_HINT_COUNT	= 1
WEAPON_RELOAD_HUD_HINT_COUNT	= 1


SF_WEAPON_START_CONSTRAINED	= 0
SF_WEAPON_NO_PLAYER_PICKUP	= 1
SF_WEAPON_NO_PHYSCANNON_PUNT = 2

CLIP_PERC_THRESHOLD		= 0.75


VECTOR_CONE_PRECALCULATED	= vec3_origin
vec3_origin					= vector_origin
vec3_angle					= Angle( 0, 0, 0 )
VECTOR_CONE_1DEGREES		= Vector( 0.00873, 0.00873, 0.00873 )
VECTOR_CONE_2DEGREES		= Vector( 0.01745, 0.01745, 0.01745 )
VECTOR_CONE_3DEGREES		= Vector( 0.02618, 0.02618, 0.02618 )
VECTOR_CONE_4DEGREES		= Vector( 0.03490, 0.03490, 0.03490 )
VECTOR_CONE_5DEGREES		= Vector( 0.04362, 0.04362, 0.04362 )
VECTOR_CONE_6DEGREES		= Vector( 0.05234, 0.05234, 0.05234 )
VECTOR_CONE_7DEGREES		= Vector( 0.06105, 0.06105, 0.06105 )
VECTOR_CONE_8DEGREES		= Vector( 0.06976, 0.06976, 0.06976 )
VECTOR_CONE_9DEGREES		= Vector( 0.07846, 0.07846, 0.07846 )
VECTOR_CONE_10DEGREES		= Vector( 0.08716, 0.08716, 0.08716 )
VECTOR_CONE_15DEGREES		= Vector( 0.13053, 0.13053, 0.13053 )
VECTOR_CONE_20DEGREES		= Vector( 0.17365, 0.17365, 0.17365 )




// This is mainly for the benefit of Lua programmers, developers, and beta testers.
SWEP_BASES			= true
SWEP_BASES_VERSION	= 323
SWEP_BASES_AUTHOR	= "Andrew McWatters"







if (!entmeta.gFireBullets) then
	entmeta.gFireBullets = entmeta.FireBullets
end


local FireBullets = entmeta.FireBullets

if ( !entmeta.FirePenetratingBullets ) then
	function entmeta:FirePenetratingBullets( attacker, trace, dmginfo )
		local Penetration	= self.Penetration	|| 1
		// Direction (and length) that we are gonna penetrate
		local Dir			= trace.Normal * 16;
		if ( trace.MatType == MAT_ALIENFLESH	||
			 trace.MatType == MAT_DIRT			||
			 trace.MatType == MAT_FLESH			||
			 trace.MatType == MAT_WOOD ) then -- dirt == plaster, and wood should be easier to penetrate so increase the distance
			Dir = trace.Normal * ( 16 * Penetration );
		end
		if ( !attacker:IsValid() ) then return end
		if ( !dmginfo:IsBulletDamage() ) then return end

		local t				= {}
		t.start				= trace.HitPos + Dir
		t.endpos			= trace.HitPos
		t.filter			= self.Owner
		t.mask				= MASK_SHOT
		local tr			= util.TraceLine( t )
		// Bullet didn't penetrate.
		if ( tr.StartSolid			||
			 tr.Fraction	>= 1.0	||
			 trace.Fraction	<= 0.0 ) then return end
		// Fire bullet from the exit point using the original tradjectory
		local info		= {}
		info.Src		= tr.HitPos
		info.Attacker	= attacker
		info.Dir		= trace.Normal
		info.Spread		= vec3_origin
		info.Num		= 1
		info.Damage		= dmginfo:GetDamage()
		info.Callback = function( attacker, trace, dmginfo )
			return self:FirePenetratingBullets( attacker, trace, dmginfo )
		end;
		info.Tracer		= 0
		self:FireBullets( info )
		
		return {
			damage	= true,
			effects	= true
		}
	end
end


function util.ImpactTrace(traceHit, pPlayer)
	if ( traceHit.MatType == MAT_GRATE ) then
		return;
	end
	
	local vecSrc		= traceHit.StartPos;
	local vecDirection	= traceHit.Normal;
	
	if ( pPlayer && pPlayer:IsPlayer() ) then
		vecSrc			= pPlayer:GetShootPos();
		vecDirection	= pPlayer:GetAimVector();
	else
		pPlayer			= GetWorldEntity()
	end
	
	local info			= {
		Src			= vecSrc,
		Dir			= vecDirection,
		Num			= 1,
		Damage		= 0,
		Force		= 0,
		Tracer		= 0,
		Callback	= function(attacker,tr,dmginfo)
			return {
				damage		= false,
				effects		= true
			}
		end,
	};

	return FireBullets( pPlayer, info );
end














