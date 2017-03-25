## === SkidCheck - 2.0 :hammer: ===
#### --By HeX

```
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ SkidCheck is the database of players who *I* don't want joining the UHDM server. +
+ If you don't trust the list, don't install it. It was made by me to keep out     +
+ people who ruin the game.  Not to cause drama.                                   +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
```

![](http://i.imgur.com/qJSb8nT.png)

![](http://i.imgur.com/diOzkSg.png)



### How to use:
* Download the Zip > Extract to the server's ```/addons``` folder and restart.

NOTE: If you're running a Linux GMod server, you ***must rename*** the addon folder to be **lower case**
(```SkidCheck-2.0-master``` -> ```skidcheck-2.0-master```), or it **WILL NOT LOAD**

######
##
### Setup / config:
Nothing is needed to configure or set up (Unless you want to).

By default, for any IDs in the database, this addon will do a warning message & sound
in the chat if those players spawn in the server.  
It will also download the latest DB from GitHub on map change, and then every 8 hours.  
It can not *detect* new cheaters, nor can it punish anyone it finds. (Unless hooked)
It can only do the following:

######
CVars, add them to your ```server.cfg``` if you want to change default options:

| CVar | Default | Can be | Does | Note |
| ----------- | ----- | ----- | ---------------------------------------------------- | -------------------------------------------- |
|```sk_kick```|```0```|```1```| Prevent players on this database from joining at all | |
|```sk_omit```|```1```|```0```| Send SK message to everyone BUT the known cheater | Useless if ```sk_kick``` or ```sk_admin``` is ```1``` |
|```sk_admin```|```0```|```1```| ONLY send SK messages to admins, no one else | Useless if ```sk_kick``` or ```sk_omit``` is ```1``` |
|```sk_sync```|```8```| ```Num. Hours``` | Allow list sync from GitHub | Number of hours to check for updates (```0``` to disable) |
|```sk_silent```|```0```|```1```| Disable all SK messages |  |


######
Commands, admin only (**DON'T** add to server.cfg):

| Command | Does |
| ------- | ---- |
|```sk```| Re-play the sound and message if any cheaters in game |
|```sk_update```| Re-sync lists now, usually syncs on map startup, then every ```sk_sync``` hours.


######
Logs (in the server's ```/data``` folder):

| File | Does |
| ------- | ---- |
|```sk_connect.txt```| Logs known cheater join attempts |
|```sk_encounters.txt```| Logs every known cheater that spawns in-game, only if ```sk_kick``` is ```0``` |


##

Note: The lists will only sync when the 1st player joins the server, due to Lua timers.
Nothing to worry about.

#

### API:
Hooks (SERVER side):

```lua
hook.Add("BlockSkidConnect", "SK", function(user,SID, Reason)
	return true, "You're not welcome here "..user.." ("..SID..")\n<"..Reason..">" --Reject connection
end)
```
Called when a known cheater connects.  
return ```true``` to prevent connection (with optional custom message).  
Return ```nil``` to allow (if ```sk_kick``` is ```0```)
#



```lua
hook.Add("OnSkid", "SK", function(ply, Reason)
	return true --Prevent SK message
end)
```

Called when a known cheater spawns in the server.  
Return ```true``` to stop the default message and handle it yourself.  
Return ```nil``` for default message & sound (if ```sk_kick```, ```sk_silent``` and ```sk_admin``` are ```0```)  

```sk_kick``` must be ```0``` for this to work, which will ALLOW them to join your server unless handled yourself in BlockSkidConnect!  

#



You can also query the database yourself, for other scripts etc.
```lua
//Player
if Skid then
	local Reason = ply:IsOnSK()
	if Reason then
		--Is on database
	end
end

//SteamID lookup, use the above if dealing with active players!
if Skid then
	local Reason = Skid.HAC_DB["STEAM_0:0:1337"]
	if Reason then
		--Is on database
	end
end
```


##
### List format:
I've made the files smaller by the following format, so for example:
```
["STEAM_0:0:1337"] = "Member of hack/troll group: FuckVacIHack"
```
Becomes
```
["0:1337"] = GG.." FuckVacIHack",
```
##

######
**If you want your ID removed, post an 'Issue' here with proof that you don't cheat***

#




