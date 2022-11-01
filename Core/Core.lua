local profileDefaults = {
	global = {
		minimap = {
			hide = false,
		},
		Autosave = false,
	},
	profile = {
		keybinds = {},
	},
}

function KeybindProfiles:OnInitialize()
	self.DB = LibStub("AceDB-3.0"):New("BindProfilesDB_Global", profileDefaults, "Default")

	self.Callbacks = LibStub("CallbackHandler-1.0")

	self.Options = self:GetOptions()
	self.Options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.DB)

	self.optionsFrame = AceConfigDialog:AddToBlizOptions("KeybindProfiles", "Keybind Profiles")

	local LDS = LibStub("LibDualSpec-1.0")
	LDS:EnhanceDatabase(self.DB, "KeybindProfiles")
	LDS:EnhanceOptions(self.Options.args.profiles, self.DB)

	-- Minimap icon
	self.MMB = LibStub("LibDataBroker-1.1"):NewDataObject("KeybindProfiles", {
		type = "launcher",
		icon = "Interface\\ICONS\\ability_warlock_moltencore",
		label = "KeybindProfiles",
		OnClick = function(obj, button)
			AceConfigDialog:Open("KeybindProfiles")
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then
				return
			end
			tooltip:AddLine("Keybind Profiles")
			tooltip:AddLine(string.format("Current Profile: %s", KeybindProfiles.DB:GetCurrentProfile()))
		end,
	})

	self.minmapBtn = LibStub("LibDBIcon-1.0")
	self.minmapBtn:Register("KeybindProfiles", KeybindProfiles.MMB, self.DB.global.minimap)

	self.DB.RegisterCallback(KeybindProfiles, "OnProfileChanged", "SetKeybinds")
	self.DB.RegisterCallback(KeybindProfiles, "OnProfileCopied", "SetKeybinds")
	self.DB.RegisterCallback(KeybindProfiles, "OnProfileReset", "ResetProfile")
	self.DB.RegisterCallback(KeybindProfiles, "OnDatabaseShutdown", "SaveProfile")

	-- Add hook to SaveBindings to be able to autosave if features is enabled
	hooksecurefunc("SaveBindings", function()
		if KeybindProfiles.DB.global.Autosave then
			KeybindProfiles:SaveProfile(true)
		end
	end)

	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("KeybindProfiles", self.Options)

	--self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:Print(string.format("Loaded |cffF07723%s|r", self.Version or "UNKNOWN"))
end

function KeybindProfiles:PLAYER_ENTERING_WORLD(event, addon)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetKeybinds()
end

function KeybindProfiles:ProfileExists(profileName)
	local profiles = KeybindProfiles.DB:GetProfiles()

	for k, v in ipairs(profiles) do
		if v == profileName then
			return true
		end
	end

	return false
end

function KeybindProfiles:ResetProfile()
	LoadBindings(1)
	self:SaveProfile(true)
	self:Print(
		string.format(
			"|cFF1eff00Profile '%s' Has Been Reset To Account Bindings|r",
			self.DB:GetCurrentProfile() or "unk"
		)
	)
	SaveBindings(2)
end

function KeybindProfiles:SaveProfile(supress)
	self.DB.profile.keybinds = {}
	for index = 1, GetNumBindings() do
		local command, key1 = GetBinding(index)
		if key1 then
			-- This creates a table like { cmd = key1, key2, key3 }
			self.DB.profile.keybinds[command] = { key1, select(3, GetBinding(index)) }
		else
			-- Remove previous bindings
			self.DB.profile.keybinds[command] = nil
		end
	end

	if not supress then
		self:Print(string.format("|cFF1eff00Profile '%s' Saved Successfully|r", self.DB:GetCurrentProfile() or "unk"))
	end
end

function KeybindProfiles:LoadProfile(profileName)
	if self.DB:GetCurrentProfile() ~= profileName then
		if KeybindProfiles:ProfileExists(profileName) then
			KeybindProfiles.DB:SetProfile(profileName)
			self:Print(string.format("|cFF1eff00Profile '%s' Loaded|r", profileName))
		else
			KeybindProfiles:Print(string.format("|cFFFF0000Invalid Profile '%s'|r", profileName))
		end
	else
		KeybindProfiles:Print(string.format("|cFFFF0000Profile '%s' Already Active|r", profileName))
	end
end

function KeybindProfiles:SetKeybinds()
	if not InCombatLockdown() then
		if self.DB.profile.keybinds ~= nil then
			for command, _ in pairs(self.DB.profile.keybinds) do
				local currKbs = { GetBindingKey(command) }
				local currKbsTbl = {}
				local profileKbs = {}
				local kbChanged = false

				for i, v in pairs(self.DB.profile.keybinds[command]) do
					profileKbs[v] = "1"
				end

				for i = 1, #currKbs do
					currKbsTbl[currKbs[i]] = "1"
				end

				for i, _ in pairs(profileKbs) do
					if not currKbsTbl[i] then
						kbChanged = true
					end
				end

				if not kbChanged then
					for k, _ in pairs(currKbsTbl) do
						if not profileKbs[k] then
							binding_modified = true
						end
					end
				end

				if kbChanged then
					for k, _ in pairs(currKbsTbl) do
						SetBinding(k)
					end

					for k, _ in pairs(profileKbs) do
						SetBinding(k, command)
					end
				end
			end

			SaveBindings(2)
		else
			self:Print("|cFFFF0000Profile Missing Keybind Data|r")
		end
	else
		self:Print("|cFFFF0000Cannot Change Keybind Profile While In Combat|r")
	end
end
