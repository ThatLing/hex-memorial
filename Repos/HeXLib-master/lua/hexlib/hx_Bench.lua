--[[
	=== HeX's Benchmark script ===
	Examples at the bottom
	*** It seems to show different times taken if you re-run the same tests!, don't trust it! ***
	Its still useful though as it shows the difference, if not the accurate time taken.
]]


benchmark = {}
benchmark.__index = benchmark

function benchmark.Init(Name)
	local Info = debug.getinfo(2)
	
	return setmetatable(
		{
			Where	= Info.short_src..":"..Info.currentline,
			Name	= Name or "Bench @ "..os.time(),
			_Start	= 0,
			_Finish = 0,
		},
		benchmark
	)
end

function benchmark.GetFastest(Tab)
	for k,v in pairs(Tab) do
		if not v:IsValid() then
			Error("benchmark.GetFastest("..v.Name..") is invalid!")
		end
	end
	
	table.sort(Tab, function(k,v)
		return k > v
	end)
	
	return Tab[1], Tab[ #Tab ], Tab --Fastest, Slowest, Sorted
end

function benchmark.Crunch(Tab)
	local Fast,Slow,Sorted = benchmark.GetFastest(Tab)
	
	for k,v in pairs(Sorted) do
		print(k, v)
	end
end


function benchmark:Open()
	if self._Start != 0 then Error("This bench is already started, Close it first!") end
	self._Start = SysTime()
end

function benchmark:DoFunc(func)
	if not isfunction(func) then Error("DoFunc needs a function, not a "..type(func).."!") end
	
	self:Open()
		local ret,err = pcall(func)
		if err then
			Error("! benchmark:DoFunc error: "..err.."\n")
		end
	self:Close()
end

function benchmark:Close()
	if self._Start == 0 then Error("Can't Close what you didn't Open!") end
	if self._Finish != 0 then Error("Can't Close the same benchmark twice!") end
	self._Finish = SysTime()
end

function benchmark:Reset()
	self._Start		= 0
	self._Finish	= 0
end


function benchmark:IsValid()
	return (self._Start != 0 and self._Finish != 0)
end

function benchmark:Read()
	if not self:IsValid() then Error("Can't Read. Open and Close!") end
	
	return self._Finish - self._Start
end

function benchmark:__tostring()		return self.Name.." took:\t"..self:Read().." ["..self.Where.."]"	end
function benchmark:__concat(Bench)	return self:__tostring()..Bench:__tostring()						end
function benchmark:__eq(Bench)		return Bench:Read() == self:Read()									end
function benchmark:__lt(Bench)		return Bench:Read() < self:Read()									end
function benchmark:__le(Bench)		return Bench:Read() <= self:Read()									end






























