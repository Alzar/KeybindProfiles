SLASH_KBP1 = "/KBP"
SlashCmdList["KBP"] = function(msg)
	local cmd, arg = string.split(" ", msg, 2)
	cmd = string.lower(cmd or "")
	arg = arg or ""

	if cmd == "config" then
		AceConfigDialog:Open("KeybindProfiles")
	elseif cmd == "load" and arg ~= "" then
		KeybindProfiles:LoadProfile(arg)
	else
		KeybindProfiles:Print("Invalid Command, available commands; |cFF1eff00/kbp config|r, |cFF1eff00/kbp load <profilename>|r")
	end
end
