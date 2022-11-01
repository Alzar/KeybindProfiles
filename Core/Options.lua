function KeybindProfiles:GetOptions()
	local Options = {
		type = "group",
		args = {
			minimap = {
				name = KeybindProfiles.Locale["hide_minimap_btn"],
				desc = KeybindProfiles.Locale["hide_minimap_btn_desc"],
				type = "toggle",
				order = 1,
				set = function(_, val)
					self.DB.global.minimap.hide = val
					if val then
						self.minmapBtn:Hide("KeybindProfiles")
					else
						self.minmapBtn:Show("KeybindProfiles")
					end
				end,
				get = function()
					return self.DB.global.minimap.hide
				end,
			},
			autosave = {
				name = KeybindProfiles.Locale["autosave_on_changes"],
				desc = KeybindProfiles.Locale["autosave_on_changes_desc"],
				type = "toggle",
				order = 2,
				set = function(_, val)
					self.DB.global.Autosave = val
				end,
				get = function()
					return self.DB.global.Autosave
				end,
			},
			save = {
				name = KeybindProfiles.Locale["manual_save"],
				desc = KeybindProfiles.Locale["manual_save_desc"],
				type = "execute",
				order = 3,
				func = function()
					KeybindProfiles:SaveProfile()
				end,
				disabled = function()
					return self.DB.global.Autosave
				end,
				hidden = function()
					return self.DB.global.Autosave
				end,
			},
			kbEdit = {
				name = KeybindProfiles.Locale["edit_keybinds"],
				desc = KeybindProfiles.Locale["edit_keybinds_desc"],
				type = "execute",
				width = "full",
				order = 4,
				func = function()
					AceConfigDialog:Close("KeybindProfiles")
					HideUIPanel(SettingsPanel)
					ShowUIPanel(QuickKeybindFrame)
				end,
			},
			accountKb = {
				name = KeybindProfiles.Locale["make_account_keybinds"],
				desc = KeybindProfiles.Locale["make_account_keybinds_desc"],
				type = "execute",
				width = "full",
				order = 5,
				func = function()
					SaveBindings(1)
					SaveBindings(2)
					KeybindProfiles:Print(
						string.format(
							"Profile '%s' Keybindings Applied To Account Default",
							KeybindProfiles.DB:GetCurrentProfile()
						)
					)
				end,
				confirm = true,
			},
			spacer = {
				name = "",
				type = "header",
				order = 7,
			},
		},
		plugins = { specializations = {} },
	}

	if KeybindProfiles.IsClassic then
		Options.args.kbEdit = nil
	end

	return Options
end
