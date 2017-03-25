
HEX.file = {}


FIND_FILE 	= 1
FIND_DIR 	= 2
FIND_SKIP	= true
FIND_KEEP	= true

function HEX.file.FindAll(Base, PATH, Refine)
	if not Refine then Refine = function() end end
	local RawBase = Base
	local All = {}
	
	local function SearchNext(Base, PATH)
		local Files,Dirs = file.Find(Base.."/*", PATH)
		
		//Files
		for k,v in pairs(Files) do
			local Base = Base.."/"..v
			
			local Refine,NewBase = Refine(FIND_FILE, v,Base,RawBase)
			if not Refine or (Refine and NewBase) then
			--if Refine and not Refine(FIND_FILE, v,Base) then
				table.insert(All, NewBase and NewBase or Base)
			end
		end
		
		//Dirs
		for k,v in pairs(Dirs) do
			local Base = Base.."/"..v
			
			if Refine(FIND_DIR, v,Base) then
				continue
			end
			
			SearchNext(Base, PATH)
		end
	end
	SearchNext(Base, PATH)
	
	return All
end



function HEX.file.CreateDir(Path)
	local Tab 	= Path:Split("/")
	local Here	= ""
	
	for k,v in ipairs(Tab) do
		if k != #Tab then --Last entry in path table
			Here = Here..v.."/"
		end
	end
	
	if not file.IsDir(Here, "DATA") then
		file.CreateDir(Here, "DATA")
	end
end


function HEX.file.Write(Path,cont,mode)
	HEX.file.CreateDir(Path)
	
	--Write
	local Out = file.Open(Path, (mode or "w"), "DATA")
		if not Out then return end
		Out:Write(cont)
	Out:Close()
	Out = nil
end

//Write table
function HEX.file.WriteTable(Path,Tab, Fmt)
	HEX.file.CreateDir(Path)
	
	local Format 	= Format
	local Cont		= ""
	local Out 		= file.Open(Path, "w", "DATA")
		if not Out then return end
		
		for k,v in pairs(Tab) do
			Out:Write( Fmt and Format(Fmt,v) or "\n"..v )
		end
		
		Cont = Out:Read( Out:Size() )
	Out:Close()
	Out = nil
	
	return Cont
end


function HEX.file.Append(Path,cont)
	HEX.file.CreateDir(Path)
	
	--Write-append
	local Out = file.Open(Path, "a", "DATA")
		if not Out then return end
		Out:Write(cont)
	Out:Close()
end


function HEX.file.Find(Path,loc)
	local Files,Dirs = file.Find(Path,loc)
	
	for k,v in pairs(Dirs) do
		table.insert(Files,v)
	end
	
	return Files
end

function HEX.file.Read(Path,loc, nil_if_gone)
	if not loc then loc = "DATA" end
	
	local Out = file.Open(Path, "r", loc)
		if not Out then return end
		local str = Out:Read( Out:Size() )
	Out:Close()
	
	if not str then return nil_if_gone and nil or "" end
	return str
end
























