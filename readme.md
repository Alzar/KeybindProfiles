Keybind Profiles does exactly as it says, adds support for creating preset profiles for your keybinds. It has support for changing profiles based on spec, there's also exposed functions for changing profiles through other addons or WeakAuras.


## How To Use
Use of the addon is simple, create your profile and then modify your keybinds. From there manually save your profile in the addon config or enable autosave and the addon will automatically save any changes to keybinds to your currently active profile.

For loading profiles, there's several ways to do it.
1. Through UI, select the profile you'd like to load (Or additionally setup profiles to be loaded per-spec)
2. Through slash command; /kbp load \<profilename\>
3. Through code; KeybindProfiles:Load(\<profilename\>)

NOTE: By default, the behavior to save profiles anytime keybinds are saved is disabled which means you would need to manually save your profile in the addon config (/kbp config). You can enable autosaving, there is no issues with it, but if you use lower-end specs you may experience a small bit of lag.

## Compatibility
This addon has been verified to work with default Blizzard action bars, Bartender4, and ElvUI. Anything outside of these addons is a use at your own risk.

## Contribute
This addon is fully open source, can find the source [here](https://github.com/Alzar/KeybindProfiles)