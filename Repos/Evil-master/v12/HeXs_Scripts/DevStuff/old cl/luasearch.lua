LuaSearch = LuaSearch or {}
concommand.Add( "luasearch", function( ply, com, args )
	if(ValidEntity(LuaSearch.Panel)) then return end
	LuaSearch.Panel = vgui.Create("DFrame")
	local Panel = LuaSearch.Panel
	Panel:SetSize(ScrW(), ScrH())
	Panel:Center()
	Panel:MakePopup()
	Panel:SetTitle("Lua Search - Powered by Overv's Lua Searcher")

	Panel.Search = vgui.Create("DTextEntry", Panel)
	Panel.Search:SetSize(ScrW()-79, 20)
	Panel.Search:SetPos(5, ScrH()-22)

	Panel.Button = vgui.Create("DButton", Panel)
	Panel.Button:SetSize(70, 20)
	Panel.Button:SetPos(ScrW()-75, ScrH()-22)
	Panel.Button:SetText("Search")
	local function CreateTree()
		Panel.Tree = vgui.Create("DTree", Panel)
		Panel.Tree:SetSize(ScrW()-10, ScrH()-100) --50
		Panel.Tree:SetPos(5, 24)
		Panel.Tree:SetShowIcons(true)
	end

	CreateTree()

	Panel.DescriptionFrame = vgui.Create("DPanel", Panel)
	Panel.DescriptionFrame:SetPos(5, ScrH()-70)
	Panel.DescriptionFrame:SetSize(ScrW()-10, 45)
	Panel.DescriptionFrame:SetBackgroundColor(Color(221,221,221,255))

	Panel.DescriptionText = vgui.Create("DLabel", Panel.DescriptionFrame)
	Panel.DescriptionText:SetPos(5, 5)
	Panel.DescriptionText:SetText("Select a function.")
	Panel.DescriptionText:SetTextColor(Color(0,0,0,255))
	Panel.DescriptionText:SizeToContents()


	local function FixString(k)
		local finalstring = ""
		for i=1, #k do
			local char = string.sub(k, i, i)
			if(string.byte(char) > 160) then
				char = string.char(string.byte(char)-100)
			end
			finalstring = finalstring .. char
		end
		return finalstring
	end

	function Panel.Button:DoClick()
		local KeyWord = LuaSearch.Panel.Search:GetValue()
		if(KeyWord ~= "") then
			http.Get("http://luasearch.overvprojects.nl/love.php?keywords=" .. KeyWord, "", function(contents, size)
				local finalstring = ""
				for i=1, #contents do
					local char = string.sub(contents, i, i)
					if(string.upper(char) == char and string.byte(char) > 64 and char ~= "{" and char ~= "}") then -- this is a hacky way to get keyvaluestotable work with uppercase letters in the key.
						char = string.char(string.byte(char)+100)
					end
					finalstring = finalstring .. char
				end
				local table = util.KeyValuesToTable(finalstring)
--				PrintTable(table)
				Panel.Tree:Remove()
				CreateTree()
				local Objects = Panel.Tree:AddNode("Objects")
				for k,v in pairs(table.objects) do
					if(type(v) == "table") then
						local Node = Objects:AddNode(FixString(k))
						for i,z in pairs(v) do
							local Function = Node:AddNode(string.gsub("["..string.upper(FixString(z.state)).."]".." "..FixString(i).."("..FixString(z.arguments)..")", "\n", ""))
							Function.Function = FixString(i)
							Function.ReturnValue = FixString(z.returns)
							if(Function.ReturnValue == "") then Function.ReturnValue = "Nothing" end
							Function.Description = FixString(z.description)
							Function.DoClick = function(self)
								Panel.DescriptionText:SetText(self.Description.."\nReturns: "..self.ReturnValue, self.Function, "Close")
								Panel.DescriptionText:SizeToContents()
							end
							Function.ShowIcons = function() return false end
						end
					end
				end
				local Libraries = Panel.Tree:AddNode("Libraries")
				for k,v in pairs(table.libraries) do
					if(type(v) == "table") then
						local Node = Libraries:AddNode(FixString(k))
						for i,z in pairs(v) do
							local Function = Node:AddNode(string.gsub("["..string.upper(FixString(z.state)).."]".." "..FixString(i).."("..FixString(z.arguments)..")", "\n", ""))
							Function.Function = FixString(i)
							Function.ReturnValue = FixString(z.returns)
							if(Function.ReturnValue == "") then Function.ReturnValue = "Nothing" end
							Function.Description = FixString(z.description)
							Function.DoClick = function(self)
								Panel.DescriptionText:SetText(self.Description.."\nReturns: "..self.ReturnValue, self.Function, "Close")
								Panel.DescriptionText:SizeToContents()
							end
							Function.ShowIcons = function() return false end
						end
					end
				end
				local Hooks = Panel.Tree:AddNode("Hooks")
				for k,v in pairs(table.hooks) do
					if(type(v) == "table") then
						local Node = Hooks:AddNode(FixString(k))
						for i,z in pairs(v) do
							local Function = Node:AddNode(string.gsub("["..string.upper(FixString(z.state)).."]".." "..FixString(i).."("..FixString(z.arguments)..")", "\n", ""))
							Function.Function = FixString(i)
							Function.ReturnValue = FixString(z.returns)
							if(Function.ReturnValue == "") then Function.ReturnValue = "Nothing" end
							Function.Description = FixString(z.description)
							Function.DoClick = function(self)
								Panel.DescriptionText:SetText(self.Description.."\nReturns: "..self.ReturnValue, self.Function, "Close")
								Panel.DescriptionText:SizeToContents()
							end
							Function.ShowIcons = function() return false end
						end
					end
				end
					
			end)
		end
	end
	Panel.Search.OnEnter = Panel.Button.DoClick


end )