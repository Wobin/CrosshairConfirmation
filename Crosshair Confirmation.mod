return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Crosshair Confirmation` encountered an error loading the Darktide Mod Framework.")

		new_mod("Crosshair Confirmation", {
			mod_script       = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshair Confirmation",
			mod_data         = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshair Confirmation_data",
			mod_localization = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshair Confirmation_localization",
		})
	end,
  load_after = {
    "DarktideLocalServer",
  },
  version = "1.4.3",
	packages = {},
}
