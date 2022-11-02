CLASSIC_VERSION = "30400"

KeybindProfiles = LibStub("AceAddon-3.0"):NewAddon("KeybindProfiles", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
AceConfigDialog = LibStub("AceConfigDialog-3.0")
KeybindProfiles.Title = GetAddOnMetadata("KeybindProfiles", "Title")
KeybindProfiles.Author = GetAddOnMetadata("KeybindProfiles", "Author")
KeybindProfiles.Version = GetAddOnMetadata("KeybindProfiles", "Version")
KeybindProfiles.Locale = LibStub("AceLocale-3.0"):GetLocale("KeybindProfiles")
KeybindProfiles.GUI = LibStub("AceGUI-3.0")
KeybindProfiles.IsClassic = GetAddOnMetadata("KeybindProfiles", "Interface") == CLASSIC_VERSION

KeybindProfiles:SetDefaultModuleState(false)
