
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


function FSA.Open(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	if FSA_MainMenu then
		FSA_MainMenu:Remove()
		FSA_MainMenu = nil
	end
	
    FSA_MainMenu = vgui.Create("fsaMainMenu")
end
concommand.Add("+fsa_menu", FSA.Open)
concommand.Add("+ass_menu", FSA.Open)
concommand.Add("+ev_menu", FSA.Open)


function FSA.Close(ply,cmd,args)
	if FSA_MainMenu then
		FSA_MainMenu:Remove()
	end
end
concommand.Add("-fsa_menu", FSA.Close)
concommand.Add("-ass_menu", FSA.Close)
concommand.Add("-ev_menu", FSA.Close)



local function FSACAT(um)
	local argc = um:ReadShort()
	local args = {}
	for i = 1, argc / 2,1 do
		table.insert(args, Color( um:ReadShort(),um:ReadShort(),um:ReadShort(),um:ReadShort() ) )
		table.insert(args, um:ReadString() )
	end
	
	timer.Simple(0.1, function()
		chat.AddText( unpack(args) )
		chat.PlaySound()
	end)
end
usermessage.Hook("FSACAT", FSACAT)





























----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------


function FSA.Open(ply,cmd,args)
	if not ply:IsAdmin() then return end
	
	if FSA_MainMenu then
		FSA_MainMenu:Remove()
		FSA_MainMenu = nil
	end
	
    FSA_MainMenu = vgui.Create("fsaMainMenu")
end
concommand.Add("+fsa_menu", FSA.Open)
concommand.Add("+ass_menu", FSA.Open)
concommand.Add("+ev_menu", FSA.Open)


function FSA.Close(ply,cmd,args)
	if FSA_MainMenu then
		FSA_MainMenu:Remove()
	end
end
concommand.Add("-fsa_menu", FSA.Close)
concommand.Add("-ass_menu", FSA.Close)
concommand.Add("-ev_menu", FSA.Close)



local function FSACAT(um)
	local argc = um:ReadShort()
	local args = {}
	for i = 1, argc / 2,1 do
		table.insert(args, Color( um:ReadShort(),um:ReadShort(),um:ReadShort(),um:ReadShort() ) )
		table.insert(args, um:ReadString() )
	end
	
	timer.Simple(0.1, function()
		chat.AddText( unpack(args) )
		chat.PlaySound()
	end)
end
usermessage.Hook("FSACAT", FSACAT)




























