=== HeX's Library - Make it easy! ===

A whole load of useful functions for GMod.

### How to set up:
Download the Zip from GibHub > Extract to the server's ```/addons``` folder & restart


## Timer

```lua
---PlayerTimers
ply:timer(2, function()
	--Runs after 2 seconds, checks if player is valid so no need to do it within the timer.
end)

local TID = ply:TimerCreate("Test", 1, 0, function(TID)
	--Works just like timer.Create, but only runs while the player is valid. Again no need to check.
	--Passes timerID to the func, and returns timerID in TimerCreate, which can be used with timer.Destroy(TID)
end)



--AdvancedTimers
local Now = RealTime()

local function End(self, Total)
	print("\n! end: ", Total, -(Now - RealTime()) )
	self:Kill()
end

Fuck = false
local function Tick(self, UpTo, Rem, Tot)
	print("! Tick: ", UpTo, Rem, Tot)
	
	if not Fuck and UpTo == 0.2 then
		Fuck = true
		print("! stop")
		
		timer.Simple(1, function()
			print("! restart")
			
			--self:AddTime(1)
			--self:SetTime(3)
			--self:Reset()
			
			self:Start()
		end)
		
		return TIMER_STOP
	end
end
local Timer = timer.Add("Poop", 0.5, End,Tick)
```

## Entity (Player) functions

```lua
ply:RespawnIfDead(same_pos)		--Obvious, call with true to set to same pos
ply:SafeDirName()				--Returns a safe directory path for per-player logging.
ply:print(str, like_msg)		--print, but to the player's console
ply:URL()						--Returns their Steam profile URL
ply:Info(show_url)				--Returns a nice string of info: Nick (SteamID) URLHere
ply:TeamColor()					--Returns the player's team (rank) color
ply:SID()						--Returns a directory-safe version of the player's SteamID

ent:Distance(other_ent)			--Returns distance between two entities / players
ent:VarSet(This)				--A very useful thing, lets it set the var and return true once, otherwise false. See the code.
ent:CanUseThis(This, when)		--Like VarSet, but resets after the timer expires

Humans()						--Used like pairs, returns all humans
Everyone()						--Used like pairs, returns everyone
Bots()							--Used like pairs, returns bots
```


## Benchmark

```lua
local Bench = benchmark.Init("Test")	--Create new Bench object

Bench:Open() 							--Start counting
	for i=0, 100000000 do end 			--Do something to measure here
Bench:Close()							--Stop counting


local Bench2 = benchmark.Init("poo")
Bench2:Open()
	for i=0, 1000000 do end
Bench2:Close()



//Prints Bench objects given in quickest order
benchmark.Crunch( {Bench, Bench2} )


//Get fastest, slowest and sorted table of Bench objects
local Fast,Slow,Sorted = benchmark.GetFastest( {Bench, Bench2} )

print("! Fastest: ", Fast)
print("! Slowest: ", Slow)
```



## Buffer

```lua
local InBuff = ringbuffer.Init(128)

function HAC.Box.Think()
	//Read
	local Got,Size = serial.Read(1)
	
	InBuff:Add(Got)
	
	if Got == "\n" then
		//Buffer
		local Cmd 	= ""
		for k = InBuff:Size(), 1, -1 do
			local v = InBuff.ToTable[k]
			if v == "\n" then continue end
			
			Cmd = Cmd..v
		end
		
		InBuff:Reset()
		
		
		MsgC(HAC.YELLOW, Cmd.."\n")
	end
end
hook.Add("Think", "HAC.Box.Think", HAC.Box.Think)
```




## Debug

```lua
--Makes debug.Trace() more readable
Default: 
Trace: 
	1: Line 32	"Trace"	lua/includes/extensions/debug.lua
	2: Line 33	"Two"	lua/tft.lua
	3: Line 40	"nil"	lua/tft.lua
	4: Line 69	"Run"	lua/includes/modules/concommand.lua
	5: Line 43	"nil"	lua/tft.lua

Mine: 
[Trace] Two - [lua/tft.lua:27-37]
  2. Two - lua/tft.lua:29
   3. unknown - lua/tft.lua:40
	4. Run - lua/includes/modules/concommand.lua:69
	 5. unknown - lua/tft.lua:43
```




## File

```lua
--Better file functions

HEX.file.CreateDir	--Makes the whole tree
HEX.file.Append		--Same as Write but append
HEX.file.Write		--Better Write, auto creates folders
HEX.file.WriteTable --Obvious

HEX.file.Find		--Merge the 2 tables like GM12
HEX.file.Read		--Better Read


HEX.file.FindAll

--Example
local Dirs = {
	"materials",
	"models",
	"particles",
	"resource",
	"sound",
}
for k,Root in pairs(Dirs) do
	//Refine search
	local function Refine(Flag, v,Base)
		//Skip new folder
		if Flag == FIND_DIR and v == "New Folder" then
			return FIND_SKIP
			
		//Snip addons/ etc
		elseif Flag == FIND_FILE then
			Base = Base:gsub("addons/PHX/", "")
			
			return FIND_KEEP, Base
		end
	end
	
	//Add
	local Tab = file.FindAll("addons/PHX/"..Root, "MOD", Refine)
	for k,v in pairs(Tab) do
		resource.AddSingleFile(v)
	end
end
```


## General functions
```lua
HEX.Date() --Returns a nice formatted datestamp string
```



## Nyoom

```lua
---Example:
local This = "Hello. I cheat here, this is not fun, please ban me now. Help!"
print( This:Nyoom() )

--Output: Nyoom. I nyoom nyoom, this nyoom nyoom nyoom, I nyoom nyoom nyoom. Help!
```



## Selector

```lua
--A way to get the next entry in a table, great for delayed checking

--[[
See the file for more uses

local Selector = selector.Init(Tab, OnSelect, start_now, use_orig)

--Selector has the following methods:

Select(optional_delay) 	--Selects the next entry and calls OnSelect
Add(entry) 				--Adds the entry to the current table, at any time
Clear()					--Clear the selector table, but keeps the object
Remove(keep_self)		--Remove the selector & stops it running
IsValid()				--Obvious
GetTable()				--Returns the table you Init'd the selector with
UpTo()					--How many entries have been Select()'d
Size()					--Number of entries in the table
Left()					--Number of entries left
Done()					--True if the selector has finished selecting all entries
Finish()				--End the selector early and stop any more Select()'ing
The Selector object can also be print()'d and tostring()'d, it will return how many
it has done, out of how many total

]]


//Send
local function OnSelect(self, Idx,This)
	print("! OnSelect: ", self, This)
end
local OutBuff = selector.Init( {}, OnSelect)

OutBuff:Add("Test")
OutBuff:Add("A")
OutBuff:Add("B")
OutBuff:Add("C")
OutBuff:Add("EIGHT")

timer.Create("Test", 0.5, 0, function()
	OutBuff:Select()
end)





//Other use, initiate with a table
local Code = {
	"A",
	"B",
	"C",
	"D",
}
local function OnSelect(self, Idx,This)
	print("! Test: ", self, This)
	
	self:Select(1) --Select next entry after 1 second
end
local Send = selector.Init(Code, OnSelect, true) --True for start now, no need to Select()
```



## Math

```lua
math.Percent(This,OutOf) 	--Easy way to do percentage
math.OneIn(num)				--1 chance in num to return true
math.Within(This, Low,High) --Is a number within a range
math.Minus(Rhis)			--Always returns a positive version of the input
math.Bytes(bytes, all_data) --Returns a formatted string for a num of bytes, "1.24MB"
```


## String

```lua
ValidString(str)						--Returns true if the string is valid

string.Random(len)						--Obvious
string.hFind(str,what)					--Like string.find, but no pattern matching
string.Check(str,check)					--Checks if the string starts with another string, a very useful function
string.Count(str,count)					--Number of occurances of a string within a string
string.InBase(str,base)					--Checks if the string is contained in base, lowercase
string.ToBytes(str)						--Returns hex version of the string
string.Size(str)						--Returns string size, in formatted megabytes
string.CheckInTable(str,tab, use_k) 	--Checks if the string begins with any entry in the table, use_k to swap order
string.InTable(str,tab, use_k, lower)	--Checks if the string is in a table, use_k to swap order, lower to ignore case
string.SID(str)							--Convert a SteamID to a file-safe SteamID
string.EatNewlines(str, also_spaces)	--Obvious
string.NoQuotes(str)					--Snip leading and trailing quotes from a string
string.VerySafe(str, tab)				--Make a string safe for file naming, pass optional tab of good bytes to also allow
string.NiceTimeEx(Secs)					--Better version of string.FormattedTime
string.NiceNum(num)						--Add proper comma seperation to numbers: 1000000 -> 1,000,000
string.ToBinary(str)					--Turn string into binary version (0's and 1's)
string.FromBinary(str)					--And back again
string.FromVA(...)						--Converts varargs to a single string
```


## Table

```lua
table.MergeEx(from,dest, as_is)			--Merge tables
table.CopyAndMerge(...)					--Merge any number of passed tables to table returned
table.RandomEx(Tab)						--Garry!
table.Tabify(Tab)						--Swap k,v and index by string
table.Size(Tab)							--Crap table size counter
table.Shuffle(Tab)						--Return a shuffled table
```












