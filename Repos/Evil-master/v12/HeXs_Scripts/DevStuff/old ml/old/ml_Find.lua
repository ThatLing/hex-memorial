


local function FindInEnvironment(env,str)
	local tbl = {}
	--if str == "" then return tbl end
	local len = string.len(str)
	for k, v in pairs(env) do
		if string.Left(k,len) == str then
			local str = k
			if type(v) == "function" then
				str = str.."("
			end
			table.insert(tbl,str)
		end
	end
	return tbl
end

local function ParseRunToAutoComplete(str)
	if string.len(str) > 1 and string.Right(str,1) != "(" then
		local fstr = string.TrimLeft(str)
		for k, v in pairs({"=","%("}) do
			fstr = string.gsub(fstr,v," ")
		end
		local tbl = string.Explode(" ",fstr)
		local lastStr = string.Trim(table.remove(tbl))
		local match
		if lastStr == "" then
			return {}
		elseif lastStr != "." and string.find(string.reverse(lastStr),"%.") != nil then
			local tblS
			local lastn = 1
			while true do
				local n = string.find(lastStr,"%.",lastn)
				if n == nil then break end
				if tblS then
					tblS = tblS[string.sub(lastStr,lastn,n-1)]
					if not tblS then
						tblS = {}
						lastn = string.len(lastStr)
						break
					end
				else
					tblS = _G[string.sub(lastStr,lastn,n-1)]
				end
				lastn = n+1
			end
			match = FindInEnvironment(tblS or {},string.sub(lastStr,lastn))
			local lastStr = string.sub(lastStr,1,string.len(lastStr) - (string.find(string.reverse(lastStr),"%.")-1))
			for k, v in pairs(match) do
				match[k] = lastStr..v
			end
		else
			match = FindInEnvironment(_G,lastStr)
		end
		if table.getn(match) != 0 then
			local firstStr = string.sub(str,1,string.len(table.concat(tbl," "))+1) --just added trimleft thingy, test to do
			for k, v in pairs(match) do
				match[k] = "lua_run_menu"..firstStr..v
			end
			table.insert(match,"")
			return match
		end
	end
	return {}
end


local LastArgs = ""
concommand.Add("lua_run_menu",function (objPl,strCmd,tblArgs)
	local str = ""
	if string.len(LastArgs) > 1 then
		str = string.sub(LastArgs,2) --Get rid of the space at the beginning
	else
		str = table.concat(tblArgs," ")
	end
	RunString(str)
end,function (strCmd,strArgs)
	LastArgs = strArgs
	return ParseRunToAutoComplete(strArgs)
end)




local function ParseOpenscriptToAutoComplete(strCmd,strArgs)
	local s = (strArgs or ""):Trim()
	if s == "" then return end
	local path = ""
	if s:find("/") then  
		path = s:gsub("/[^/]+$","").."/"  
	end  
	local files = {}
	for _,v in pairs(file.FindInLua(s.."*")) do  
		if not (v == "." or v == "..") and (v:find("%.lua") or not v:find("%.")) then  
			local file = (path..v):gsub("[/\\]+","/")
			table.insert(files,strCmd.." "..file)
		end  
	end
	table.insert(files,"")
	return files
end


concommand.Add("lua_openscript_menu",function (objPl,strCmd,tblArgs)
	include(table.concat(tblArgs," "))
end,function (strCmd,strArgs)
	return ParseOpenscriptToAutoComplete(strCmd,strArgs)
end)




local function FindInTable(tab,what,parents,depth)
	depth = depth or 0
	parents = parents or ""
	
	if (depth > 3) then return end
	depth = depth + 1
	
	for k,v in pairs(tab) do
		if type(k) == "string" then
			if (k and k:lower():find( what:lower() ) ) then
				print("\t", parents, k, " - (", type(v), " - ", v, ")")
			end
			
			if (type(v) == "table" and
				k != "_R" and
				k != "_E" and
				k != "_G" and
				k != "_M" and
				k != "_LOADED" and
				k != "__index") then
				
				FindInTable(v, what, parents..k..".", depth)
			end
		end
	end
end


local function Find(ply,cmd,args)
	if not args[1] then return end
	local What = args[1]
	print("Finding '"..What.."' CLIENTSIDE:\n")
	FindInTable(_G, What)
	FindInTable(_R, What)
	print("\n")
end
concommand.Add("lua_find_ml",Find)




