
--You can also use the concommand disconnect_msg "your message here", added by the module.

require("sourcenetinfo")

concommand.Add("hex_quit", function()
	sourcenetinfo.GetNetChannel():Shutdown("Windows 98 out of here my mother!")
end)






