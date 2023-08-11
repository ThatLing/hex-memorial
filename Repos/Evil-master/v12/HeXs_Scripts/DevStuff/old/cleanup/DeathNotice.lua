
if ( SERVER ) then

	AddCSLuaFile( "DeathNotice.lua" )	
end

function deathnotice( victimdata, weapondata, killerdata )

finalmessagesuicide = nil
finalmessagekill = nil
weapon = nil

local victimname = victimdata:GetName()
local weaponname = weapondata:GetClass()
local killername = killerdata:GetName()

//-----------SUICIDES-----------
if ( ( victimname == killername ) == true ) then

//-------------
//Suicide
if weaponname == "player" then
finalmessagesuicide = ("")
end
//-------------

//Rocket suicide
if weaponname == "rpg_missile" then

local decider = math.random(1,13)

local message = {}

message[1] = ( killername .. " found out what the little red dot does." )
message[2] = ( killername .. " rearranged his insides with a rocket launcher." )
message[3] = ( killername .. " checked to see if it worked." )
message[4] = ( killername .. " painted the walls red." )
message[5] = ( killername .. " asplode." )
message[6] = ( killername .. " didn't check with the manual." )
message[7] = ( killername .. " threw himself all across the map." )
message[8] = ( killername .. " left a small crater." )
message[9] = ( killername .. " had too many limbs anyway." )
message[10] = ( killername .. " went trigger-happy with a rocket launcher." )
message[11] = ( killername .. " was eliminated in a natural selection." )
message[12] = ( killername .. " checked to see if it was loaded." )
message[13] = ( killername .. " ate his own rocket." )

finalmessagesuicide = message[decider]

end

//Grenade suicide
if weaponname == "npc_grenade_frag" then

local decider = math.random(1,11)

local message = {}

message[1] = ( killername .. " splattered himself with a frag." )
message[2] = ( killername .. " found out a little too late what the pin does." )
message[3] = ( killername .. " checked to see if it worked." )
message[4] = ( killername .. " painted the walls red." )
message[5] = ( killername .. " asplode." )
message[6] = ( killername .. " found his insides on the outside." )
message[7] = ( killername .. " couldn't get on with evolution." )
message[8] = ( killername .. " juggled his own grenades." )
message[9] = ( killername .. " had too many limbs anyway." )
message[10] = ( killername .. " checked the pin on his grenade." )
message[11] = ( killername .. " ate his own grenade." )

finalmessagesuicide = message[decider]

end

//Turret
if weaponname == "gmod_turret" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " checked to see if it worked." )
message[2] = ( killername .. " checked his turrets..." )
message[3] = ( killername .. " filled himself full of holes." )
message[4] = ( killername .. " shot himself up." )
message[5] = ( killername .. " was shot down by his own turret." )
message[6] = ( killername .. " was shot down in a turret accident." )

finalmessagesuicide = message[decider]

end

//Nuclear suicide
if weaponname == "sent_nuke" then

local decider = math.random(1,7)

local message = {}

message[1] = ( killername .. " vaporised himself." )
message[2] = ( killername .. " has been disintegrated." )
message[3] = ( killername .. " blew himself to bits with an atomic blast." )
message[4] = ( killername .. " forgot to apply his sun lotion when he detonated the nuke." )
message[5] = ( killername .. " forgot to set defusal codes on his nuclear weapon." )
message[6] = ( killername .. " spread himself evenly across the level." )
message[7] = ( killername .. " tested his nuke to check it worked." )

finalmessagesuicide = message[decider]

end

//Physics suicide
if weaponname == "prop_physics" then

local decider = math.random(1,7)

local message = {}

message[1] = ( victimname .. " has been flattened." )
message[2] = ( victimname .. " was crushed." )
message[3] = ( victimname .. " got himself killed." )
message[4] = ( victimname .. " tried to argue with laws of physics." )
message[5] = ( victimname .. " disregarded neuton's laws." )
message[6] = ( killername .. " didn't trajectorise his throw properly." )
message[7] = ( killername .. " caught something heavy with his forehead." )

finalmessagesuicide = message[decider]

end

//---------------------------

//Generic suicide
if finalmessagesuicide == nil then

finalmessagesuicide = ( killername .. " killed himself with a " .. weaponname .. "." )

end

//Final Message
local locateplayers = player.GetAll( )
for i = 1, table.getn( locateplayers ) do
locateplayers[i]:ChatPrint( finalmessagesuicide .."\n")
end

//-----------KILLS-----------
elseif ( ( victimname == killername ) == false ) then

//-------------
//PLAYER
if weaponname == "player" then

local weapon = ("")

if (killerdata:GetActiveWeapon() != NULL) then
weapon = killerdata:GetActiveWeapon():GetClass()
finalmessagekill = ( killername .. " killed " .. victimname .. " with " .. weapon .. " [weapon]" )
end

if (killerdata:GetActiveWeapon() == NULL) then
weapon = ("NULL")
finalmessagekill = ("What the hell happened.")
end

//Crowbar kill
if weapon == "weapon_crowbar" then

local decider = math.random(1,10)

local message = {}

message[1] = ( killername .. " redecorated " .. victimname .. "'s exterior." )
message[2] = ( victimname .. " was chased down by " .. killername .. "." )
message[3] = ( victimname .. " suddenly found " .. killername .. "'s crowbar in his eye." )
message[4] = ( victimname .. " was served a dose of " .. killername .. "'s crowbar." )
message[5] = ( victimname .. "'s looks have been altered by " .. killername .. "'s crowbar." )
message[6] = ( victimname .. " didn't fare well against " .. killername .. "'s crowbar." )
message[7] = ( victimname .. " said ''Hi'' to " .. killername .. "'s crowbar." )
message[8] = ( killername .. " helped " .. victimname .. " to shut the fuck up." )
message[9] = ( killername .. " redecorated the level with " .. victimname .. "." )
message[10] = ( killername .. " disassembled " .. victimname .. " with a crowbar." )

finalmessagekill = message[decider]

end

//Pistol kill
if weapon == "weapon_pistol" then

local decider = math.random(1,5)

local message = {}

message[1] = ( killername .. " put a few holes in " .. victimname .. "." )
message[2] = ( victimname .. " was not as good at running as " .. killername .. " was a shooting." )
message[3] = ( victimname .. " almost dodged " .. killername .. "'s bullet." )
message[4] = ( victimname .. " had a date with " .. killername .. "'s bullet." )
message[5] = ( killername .. "'s bullet proved mightier than " .. victimname .. "'s skull." )

finalmessagekill = message[decider]

end

//.357 kill
if weapon == "weapon_357" then

local decider = math.random(1,5)

local message = {}

message[1] = ( killername .. " fed " .. victimname .. " a bullet." )
message[2] = ( victimname .. " couldn't outrun " .. killername .. "'s bullet." )
message[3] = ( victimname .. " suddenly found " .. killername .. "'s bullet in his arse." )
message[4] = ( victimname .. " was sniped down by " .. killername .. "." )
message[5] = ( killername .. " shot " .. victimname .. " a new hole." )

finalmessagekill = message[decider]

end

//SMG kill
if weapon == "weapon_smg1" then

local decider = math.random(1,8)

local message = {}

message[1] = ( killername .. " filled " .. victimname .. " full of holes." )
message[2] = ( victimname .. " was gunned down by " .. killername .. "." )
message[3] = ( victimname .. " was served his daily dose of bullets by " .. killername .. "." )
message[4] = ( victimname .. " was mowed down by " .. killername .. "." )
message[5] = ( victimname .. " was spammed to death by " .. killername .. "." )
message[6] = ( victimname .. " was found dead near " .. killername .. "'s rifle range." )
message[7] = ( victimname .. " failed to go into bullet time with " .. killername .. "'s SMG." )
message[8] = ( victimname .. " was perforated by " .. killername .. "'s SMG." )

finalmessagekill = message[decider]

end

//AR2 kill
if weapon == "weapon_ar2" then

local decider = math.random(1,5)

local message = {}

message[1] = ( killername .. " shredded " .. victimname .. " to bits." )
message[2] = ( killername .. " put a few holes in " .. victimname .. "." )
message[3] = ( victimname .. " was battered by " .. killername .. "'s AR2." )
message[4] = ( victimname .. " throughoutly examined " .. killername .. "'s AR2." )
message[5] = ( victimname .. " couldn't go into bullet time with " .. killername .. "'s AR2." )

finalmessagekill = message[decider]

end

//Shotgun kill
if weapon == "weapon_shotgun" then

local decider = math.random(1,5)

local message = {}

message[1] = ( killername .. " shredded " .. victimname .. " to bits." )
message[2] = ( victimname .. " was staring down the barrel of " .. killername .. "'s shotgun." )
message[3] = ( victimname .. " was on the wrong end of " .. killername .. "'s shotgun." )
message[4] = ( killername .. " put " .. victimname .. "'s limbs apart wtih a shotgun." )
message[5] = ( killername .. " disassembled " .. victimname .. " wtih a shotgun." )

finalmessagekill = message[decider]

end

//SWEPS

//FreezerNade Gun
if weapon == "freezegun" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " afroze " .. victimname .. " to death." )
message[2] = ( killername .. " painted the walls a lovely shade of " .. victimname .. "." )
message[3] = ( killername .. " disassembled " .. victimname .. " with a freeze-gun." )
message[4] = ( killername .. " depressurised " .. victimname .. " in a handy way." )
message[5] = ( victimname .. " was depressurised by " .. killername .. "." )
message[6] = ( killername .. " put " .. victimname .. " and his limbs apart." )

finalmessagekill = message[decider]

end

//AK47
if weapon == "weapon_ak47" then

local decider = math.random(1,3)

local message = {}

message[1] = ( killername .. " went communist on " .. victimname .. "'s ass." )
message[2] = ( killername .. " took a 47's approach to " .. victimname .. "." )
message[3] = ( killername .. " disassembled " .. victimname .. " the traditional way." )

finalmessagekill = message[decider]

end

//Deagle
if weapon == "weapon_deagle" then

local decider = math.random(1,2)

local message = {}

message[1] = ( killername .. " took a precision shot on " .. victimname .. "." )
message[2] = ( victimname .. " was shot down by " .. killername .. "." )

finalmessagekill = message[decider]

end

//Five-Seven
if weapon == "weapon_fiveseven" then

local decider = math.random(1,2)

local message = {}

message[1] = ( killername .. " took a shot at " .. victimname .. "." )
message[2] = ( victimname .. " was shot down by " .. killername .. "'s pew-pew gun." )

finalmessagekill = message[decider]

end

//Glock
if weapon == "weapon_glock" then

local decider = math.random(1,2)

local message = {}

message[1] = ( killername .. " popped a cap in " .. victimname .. "'s ass." )
message[2] = ( victimname .. " was shot down by " .. killername .. "." )

finalmessagekill = message[decider]

end

//M-4
if weapon == "weapon_m4" then

local decider = math.random(1,3)

local message = {}

message[1] = ( killername .. "'s bullet suddenly invaded " .. victimname .. "'s skull." )
message[2] = ( victimname .. " was battered by " .. killername .. "'s M4." )
message[3] = ( victimname .. " asked to take a closer look at " .. killername .. "'s M4." )

finalmessagekill = message[decider]

end

//Mac-10
if weapon == "weapon_mac10" then

local decider = math.random(1,2)

local message = {}

message[1] = ( victimname .. " got shot with " .. killername .. "'s Mac-10 a few times." )
message[2] = ( victimname .. " asked to take a closer look at " .. killername .. "'s Mac-10." )

finalmessagekill = message[decider]

end

//MP-5
if weapon == "weapon_mp5" then

local decider = math.random(1,2)

local message = {}

message[1] = ( killername .. "'s bullets travelled all the way through " .. victimname .. "'s intestines." )
message[2] = ( victimname .. " died of " .. killername .. " submachine-gun causes." )

finalmessagekill = message[decider]

end

//Para
if weapon == "weapon_para" then

local decider = math.random(1,2)

local message = {}

message[1] = ( killername .. " spammed " .. victimname .. " to bloody death." )
message[2] = ( killername .. " put a few hundered bullets around and inside " .. victimname .. "." )

finalmessagekill = message[decider]

end

//Pump Shotgun
if weapon == "weapon_pumpshotgun" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " was starring down " .. killername .. "'s barrel." )
message[2] = ( victimname .. " had a date with " .. killername .. "'s shotgun." )
message[3] = ( killername .. " disassembled " .. victimname .. " into tiny bits." )
message[4] = ( killername .. " shredded " .. victimname .. " to bits." )

finalmessagekill = message[decider]

end

//Pump Shotgun
if weapon == "weapon_tmp" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " died of " .. killername .. " submachine-gun causes." )
message[2] = ( victimname .. " was suddenly asassinated by " .. killername .. "." )
message[3] = ( killername .. " stalked " .. victimname .. " with some TMP rounds." )

finalmessagekill = message[decider]

end

end
//-------------

//Physics
if weaponname == "prop_physics" || weaponname == "prop_physics_respawnable" || weaponname == "prop_physics_multiplayer" then

local killerclass = killerdata:GetClass()

//Physics suicide
if killerclass == "prop_physics" || killerclass == "prop_physics_respawnable" || killerclass == "prop_physics_multiplayer" then

local decider = math.random(1,8)

local message = {}

message[1] = ( victimname .. " has been flattened." )
message[2] = ( victimname .. " was crushed." )
message[3] = ( victimname .. " was found dead." )
message[4] = ( victimname .. " was standing in the way of somthing heavy." )
message[5] = ( victimname .. " got himself killed." )
message[6] = ( victimname .. " tripped over something heavy." )
message[7] = ( victimname .. " tried to argue with laws of physics." )
message[8] = ( victimname .. " was staring at something heavy heading his way." )

finalmessagekill = message[decider]

end

//Physics kill
if killerclass != "prop_physics" && killerclass != "prop_physics_respawnable" && killerclass != "prop_physics_multiplayer" then

local decider = math.random(1,5)

local message = {}

message[1] = ( killername .. " smeared " .. victimname .. " across the floor." )
message[2] = ( victimname .. " played catch with " .. killername .. "." )
message[3] = ( victimname .. " was victim of " .. killername .. "'s flinging practice." )
message[4] = ( killername .. " disposed of " .. victimname .. " with some heavy prop." )
message[5] = ( victimname .. " ran into " .. killername .. "'s flinging practice object." )

finalmessagekill = message[decider]

end
end

//Combine ball kill
if weaponname == "prop_combine_ball" then

local decider = math.random(1,5)

local message = {}

message[1] = ( victimname .. " was disintegrated by " .. killername .. "'s balls." )
message[2] = ( killername .. " vaporised " .. victimname .. " with combine's balls." )
message[3] = ( victimname .. " thought you were meant to catch " .. killername .. "'s ball." )
message[4] = ( victimname .. " was depressurised by " .. killername .. "'s balls." )
message[5] = ( victimname .. " said ''Hi'' to " .. killername .. "'s balls." )

finalmessagekill = message[decider]

end

//Crossbow kill
if weaponname == "crossbow_bolt" then

local decider = math.random(1,6)

local message = {}

message[1] = ( victimname .. " got arrow'd by" .. killername .. "'s crossbow" )
message[2] = ( victimname .. " was sniped by " .. killername .. "." )
message[3] = ( victimname .. " met " .. killername .. "'s crossbow bolt." )
message[4] = ( victimname .. " stood in the way of " .. killername .. "'s crossbow." )
message[5] = ( victimname .. " got own3d by " .. killername .. "'s crossbow bolt." )
message[6] = ( killername .. " put a crossbow bolt in " .. victimname .. "." )

finalmessagekill = message[decider]

end

//Rocket kill
if weaponname == "rpg_missile" then

local decider = math.random(1,10)

local message = {}

message[1] = ( killername .. " put " .. victimname .. "'s insides on the outside." )
message[2] = ( victimname .. " accidently " .. killername .. "'s rocket." )
message[3] = ( victimname .. " couldn't outrun " .. killername .. "'s rocket." )
message[4] = ( victimname .. " met " .. killername .. "'s rocket." )
message[5] = ( killername .. " redecorated the level with " .. victimname .. "." )
message[6] = ( killername .. " threw " .. victimname .. " all across the map." )
message[7] = ( killername .. " taught " .. victimname .. " how to fly." )
message[8] = ( killername .. " opened up a can of whoop-ass on " .. victimname .. "." )
message[9] = ( killername .. " decided " .. victimname .. " had too many limbs." )
message[10] = ( killername .. " spread " .. victimname .. " evenly across the ground." )

finalmessagekill = message[decider]

end

//Grenade kill
if weaponname == "npc_grenade_frag" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " fed " .. victimname .. " a frag." )
message[2] = ( killername .. " sploded " .. victimname .. "'s ass apart." )
message[3] = ( killername .. " painted the walls a lovely shade of " .. victimname .. "." )
message[4] = ( victimname .. " tripped over " .. killername .. "'s grenade." )
message[5] = ( victimname .. " tried to juggle " .. killername .. "'s grenades." )
message[6] = ( killername .. " spread " .. victimname .. " evenly across the level." )

finalmessagekill = message[decider]

end

//Nuclear kill
if weaponname == "sent_nuke" then

local decider = math.random(1,7)

local message = {}

message[1] = ( killername .. " vaporised " .. victimname .. " with a nuclear explosion." )
message[2] = ( victimname .. " was caught sunbathing in " .. killername .. "'s nuclear testing zone." )
message[3] = ( victimname .. " has been disintegrated by " .. killername .. "'s atomic bomb." )
message[4] = ( killername .. " splatterd " .. victimname .. " all across the map." )
message[5] = ( killername .. " wiped out " .. victimname .. "." )
message[6] = ( victimname .. " tripped over " .. killername .. "'s nuke." )
message[7] = ( victimname .. " stood too close to " .. killername .. "'s nuclear testing zone." )

finalmessagekill = message[decider]

end

//Gibs
if weaponname == "gib" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " threw some heavy leftovers in " .. victimname .. "'s general direction." )
message[2] = ( killername .. " threw some crap at " .. victimname .. "." )
message[3] = ( victimname .. " was done in by  " .. killername .. "'s high-speed leftovers." )
message[4] = ( killername .. " threw some junk at " .. victimname .. "'s face." )
message[5] = ( killername .. " finished off " .. victimname .. " with some random leftovers." )
message[6] = ( victimname .. " tripped over " .. killername .. "'s high-speed leftovers." )

finalmessagekill = message[decider]

end

//Fire & Flames
if weaponname == "env_fire" || weaponname == "entityflame" then

local decider = math.random(1,6)

local message = {}

message[1] = ( victimname .. " was made extra-crispy." )
message[2] = ( victimname .. " burned to death." )
message[3] = ( victimname .. " has been deep-fried." )
message[4] = ( victimname .. " sat too close to the campfire." )
message[5] = ( victimname .. " is now charred remains." )
message[6] = ( victimname .. " was roasted." )

finalmessagekill = message[decider]

end

//Random Hazards
if weaponname == "point_hurt" || weaponname == "trigger_hurt" then

local killerclass = killerdata:GetClass()

//Random suicide
if killerclass == "point_hurt" || killerclass == "trigger_hurt" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " was found dead." )
message[2] = ( victimname .. " got himself killed." )
message[3] = ( victimname .. " didn't check with his surroundings." )
message[4] = ( victimname .. " checked the area for traps." )

finalmessagekill = message[decider]

end

//Random kill
if killerclass != "point_hurt" && killerclass != "trigger_hurt" then

local decider = math.random(1,3)

local message = {}

message[1] = ( killername .. " spread " .. victimname .. " evenly across the level." )
message[2] = ( killername .. " painted the walls a lovely shade of " .. victimname .. "." )
message[3] = ( victimname .. " was caught in " .. killername .. "'s firing range." )

finalmessagekill = message[decider]

end

end

//Explosions
if weaponname == "env_explosion" || weaponname == "gmod_dynamite" then

local decider = math.random(1,7)

local message = {}

message[1] = ( victimname .. " asploded." )
message[2] = ( victimname .. " was blown to steaming bits." )
message[3] = ( victimname .. " was blown away by a big-ass explosion." )
message[4] = ( victimname .. " decorated the level with his insides." )
message[5] = ( victimname .. " splatterd all over the walls." )
message[6] = ( victimname .. " was sploded." )
message[7] = ( victimname .. " is now very dead." )

finalmessagekill = message[decider]

end

//Turrets
if weaponname == "gmod_turret" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " put a few holes in " .. victimname .. "." )
message[2] = ( killername .. " painted the walls a lovely shade of " .. victimname .. "." )
message[3] = ( victimname .. " was found dead near " .. killername .. "'s turret range." )
message[4] = ( victimname .. " came too close to " .. killername .. "'s turret range." )
message[5] = ( killername .. " shot " .. victimname .. " some new holes." )
message[6] = ( victimname .. " was shot up by " .. killername .. "." )

finalmessagekill = message[decider]

end

//Lasers
if weaponname == "env_laser" then

local decider = math.random(1,6)

local message = {}

message[1] = ( victimname .. " got laz0r'd." )
message[2] = ( victimname .. " got himself disintegrated." )
message[3] = ( victimname .. " didn't check for traps." )
message[4] = ( victimname .. " didn't read the fucking manual." )
message[5] = ( victimname .. " had an unfortunate shooping accident." )
message[6] = ( victimname .. " had an unfortunate shooping accident." )

finalmessagekill = message[decider]

end

//Worldspawn
if weaponname == "worldspawn" then

local decider = math.random(1,15)

local message = {}

message[1] = ( victimname .. " kissed the dirt." )
message[2] = ( victimname .. " is now a pavment pizza." )
message[3] = ( victimname .. " learned the power of gravity." )
message[4] = ( victimname .. " illustrated how falling works." )
message[5] = ( victimname .. " forgot how to noclip." )
message[6] = ( victimname .. " tried to argue with laws of physics." )
message[7] = ( victimname .. " decorated the level with his insides." )
message[8] = ( victimname .. " went too close to the edge." )
message[9] = ( victimname .. " splatterd on the floor." )
message[10] = ( victimname .. " didn't read the safety guide." )
message[11] = ( victimname .. " didn't wait for the elivator." )
message[12] = ( victimname .. " fell into the floor at 113mph." )
message[13] = ( victimname .. " smeared himself across the floor." )
message[14] = ( victimname .. " didn't check with the manual." )
message[15] = ( victimname .. " didn't need all those limbs anyway." )

finalmessagekill = message[decider]

end

//SWEPS

//FreezerNade Minigun
if weaponname == "freezegun_mini" then

local decider = math.random(1,6)

local message = {}

message[1] = ( killername .. " painted the walls a lovely shade of " .. victimname .. "." )
message[2] = ( killername .. " disassembled " .. victimname .. " the messy way." )
message[3] = ( killername .. " shot " .. victimname .. " a new one." )
message[4] = ( killername .. " put " .. victimname .. " and his limbs apart." )
message[5] = ( victimname .. " met " .. killername .. "'s lucky bullet." )
message[6] = ( killername .. " shot " .. victimname .. " some new holes." )

finalmessagekill = message[decider]

end

//NPC

//Combine soldier
if weaponname == "npc_combine_s" then

local decider = math.random(1,5)

local message = {}

message[1] = ( victimname .. " ran into a bunch of combine soldiers." )
message[2] = ( victimname .. " was shot up by some combine soldiers." )
message[3] = ( victimname .. " played tag with a bunch of combine." )
message[4] = ( victimname .. " was never good at hide-n-seek." )
message[5] = ( victimname .. " strafed into some combine soldiers." )

finalmessagekill = message[decider]

end

//Antlions
if weaponname == "npc_antlion" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " ran into a bunch of antlions." )
message[2] = ( victimname .. " was chased down by some antlions." )
message[3] = ( victimname .. " was bugged." )

finalmessagekill = message[decider]

end

//Antlion guard
if weaponname == "npc_antlionguard" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " was chased down by an antlion guard." )
message[2] = ( victimname .. " was put apart by an antlion guard." )
message[3] = ( victimname .. " painted the walls red." )
message[4] = ( victimname .. " played a game of catch with an Antlion Guard." )

finalmessagekill = message[decider]

end

//Barnacle
if weaponname == "npc_barnacle" then

local decider = math.random(1,5)

local message = {}

message[1] = ( "Silly " .. victimname .. ", barnacles are for enemies...")
message[2] = ( victimname .. " was slow enough to get chased down by a barnacle." )
message[3] = ( victimname .. " didn't look up." )
message[4] = ( victimname .. " was eliminated in natural selection." )
message[5] = ( victimname .. " was dumb enough to get strangled by a barnacle." )

finalmessagekill = message[decider]

end

//Gunship
if weaponname == "npc_combinegunship" then

local decider = math.random(1,2)

local message = {}

message[1] = ( victimname .. " was chased down by a gunship." )
message[2] = ( victimname .. " didn't make it." )

finalmessagekill = message[decider]

end

//Helicopter
if weaponname == "npc_helicopter" then

local decider = math.random(1,2)

local message = {}

message[1] = ( victimname .. " was chased down by a combine helicopter." )
message[2] = ( victimname .. " didn't see it coming." )

finalmessagekill = message[decider]

end

//Zombies
if weaponname == "npc_fastzombie" || weaponname == "npc_zombie" || weaponname == "npc_poisonzombie" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " ran into a bunch of zombies." )
message[2] = ( victimname .. " was the finest brain of his generation." )
message[3] = ( victimname .. " was stalked by some zombies." )
message[4] = ( victimname .. " made a camp by some zombies." )

finalmessagekill = message[decider]

end

//Zombie torsos
if weaponname == "npc_fastzombie_torso" || weaponname == "npc_zombie_torso" then

local decider = math.random(1,2)

local message = {}

message[1] = ( victimname .. " didn't check for survivors." )
message[2] = ( victimname .. " couldn't handle half a zombie." )

finalmessagekill = message[decider]

end

//Headcrabs
if weaponname == "npc_headcrab" || weaponname == "npc_headcrab_black" || weaponname == "npc_headcrab_fast" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " ran into a bunch of headcrabs." )
message[2] = ( victimname .. " was headhumped to death." )
message[3] = ( victimname .. " mistook headcrab for a pet." )

finalmessagekill = message[decider]

end

//Manhacks
if weaponname == "npc_manhack" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " was cut up by some manhacks." )
message[2] = ( victimname .. " was cut up extra-thin." )
message[3] = ( victimname .. " didn't know those weren't scanners." )
message[4] = ( victimname .. " was shredded extra-thin." )

finalmessagekill = message[decider]

end

//Turrets
if weaponname == "npc_turret_ceiling" || weaponname == "npc_turret_floor" || weaponname == "npc_turret_ground" || weaponname == "sent_turret" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " was shot down in a turret accident." )
message[2] = ( victimname .. " checked the area." )
message[3] = ( victimname .. " didn't check the area for turrets." )

finalmessagekill = message[decider]

end

//Rollermines
if weaponname == "npc_rollermine" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " ran into a bunch of rollermines." )
message[2] = ( victimname .. " was done in by rollermine's Sonic Spin Attack." )
message[3] = ( victimname .. " was electrocuted by the combine spinning menace." )

finalmessagekill = message[decider]

end

//Metropolice
if weaponname == "npc_metropolice" then

local decider = math.random(1,6)

local message = {}

message[1] = ( victimname .. " ran into City 17 police force." )
message[2] = ( victimname .. " was shot down by C17 police force." )
message[3] = ( victimname .. " exceeded his infractions limit." )
message[4] = ( victimname .. " was suddenly elected Citizen 101." )
message[5] = ( victimname .. " asked a CP for directions." )
message[6] = ( victimname .. " was making funny faces in front of some CPs." )

finalmessagekill = message[decider]

end

//Striders
if weaponname == "npc_strider" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " ran into a strider." )
message[2] = ( victimname .. " was shot down by a strider." )
message[3] = ( victimname .. " was served extra-crispy." )
message[4] = ( victimname .. " stopped to tie his shoelaces." )

finalmessagekill = message[decider]

end

//Vortigaunts
if weaponname == "npc_vortigaunt" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " ran into a bunch of vortigaunts." )
message[2] = ( victimname .. " couldn't argue with a vortigaunt." )
message[3] = ( victimname .. " crossed roads with a vortigaunt." )

finalmessagekill = message[decider]

end

//Vehicles

//Jeep
if weaponname == "prop_vehicle_jeep" then

local decider = math.random(1,4)

local message = {}

message[1] = ( victimname .. " had a car accident." )
message[2] = ( victimname .. " crossed roads with a jeep." )
message[3] = ( victimname .. " met a bumper of a speeding jeep." )
message[4] = ( victimname .. " was driven over." )

finalmessagekill = message[decider]

end

//Airboat
if weaponname == "prop_vehicle_airboat" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " couldn't outrun an airboat." )
message[2] = ( victimname .. " was shredded apart by airboat's rear blades." )
message[3] = ( victimname .. " didn't notice an airboat just before his nose." )

finalmessagekill = message[decider]

end

//Pod
if weaponname == "prop_vehicle_prisoner_pod'" then

local decider = math.random(1,3)

local message = {}

message[1] = ( victimname .. " didn't see it coming." )
message[2] = ( victimname .. " was successfully landed on." )
message[3] = ( victimname .. " was killed my the chair." )

finalmessagekill = message[decider]

end

//---------------------------

//Generic kill
if finalmessagekill == nil then

finalmessagekill = ( killername .. " killed " .. victimname .. " with " .. weaponname .. "." )

end

//Final message
local locateplayers = player.GetAll( )
for i = 1, table.getn( locateplayers ) do
locateplayers[i]:ChatPrint( finalmessagekill .."\n")
end

end
end
hook.Add( "PlayerDeath", "DeathNotificationHook", deathnotice )