--[[
Name: Crosshair Confirmation
Author: Wobin
Date: 27/05/24
Version: 1.0
--]]

local mod = get_mod("Crosshair Confirmation")
local player



mod.on_all_mods_loaded = function()  
  mod:echo("Loaded Confirmation")
  mod:hook_safe("HudElementCombatFeed", "event_combat_feed_kill", function(self, attacking_unit, attacked_unit)
    mod:echo("checking kill")    
    if not player then player = Managers.player:local_player(1) end
    local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
    local breed_or_nil = unit_data_extension and unit_data_extension:breed()

    mod:echo("Added info : " .. (breed_or_nil.tags.monster and "MONSTA" or (breed_or_nil.tags.special and "SPECIAL" or (breed_or_nil.tags.elite and "ELITE"))))    
    mod:dump(breed_or_nil.tags, "killed", 2)
  end)

end