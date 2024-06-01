--[[
Name: Crosshair Confirmation
Author: Wobin
Date: 27/05/24
Version: 1.0
--]]

local mod = get_mod("Crosshair Confirmation")

mod.textures = {}
mod.loader = Managers.url_loader

mod.load_crosshair = function(self, crosshair, shape)
    if mod.textures[shape] then 
    crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map = mod.textures[shape].texture
  else
    mod.loader:load_texture(mod.texture_lookup[shape]):next(function(data)       
        mod.textures[shape] = data           
        crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map = mod.textures[shape].texture
    end)
  end
end

mod.show_crosshair = function(self, templateType)  
  mod[templateType.. "_show"] = true
  Promise.delay(mod:get(templateType.."_delay")):next(function() mod[templateType.. "_show"] = false end)  
end

mod.on_all_mods_loaded = function()    
  mod:hook_safe("HudElementCombatFeed", "event_combat_feed_kill", function(self, attacking_unit, attacked_unit)   
    if not player then player = Managers.player:local_player(1) end
    local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
    local breed = unit_data_extension and unit_data_extension:breed()
    if mod:get("monster_active") and breed.tags.monster then
        mod:show_crosshair("monster")
    end
    if mod:get("special_active") and breed.tags.special then
        mod:show_crosshair("special")
    end
    if mod:get("elite_active") and breed.tags.elite then
        mod:show_crosshair("elite")
    end    
  end)
end

    mod:register_hud_element({
      class_name = "CrosshairTemplate_elite",
      filename = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshairs/CrosshairElite",
      use_hud_scale = true,
      visibility_groups = {
        "alive"
      },    
    })
    mod:register_hud_element({
      class_name = "CrosshairTemplate_monster",
      filename = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshairs/CrosshairMonster",
      use_hud_scale = true,
      visibility_groups = {
        "alive"
      },    
    })
    mod:register_hud_element({
      class_name = "CrosshairTemplate_special",
      filename = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshairs/CrosshairSpecial",
      use_hud_scale = true,
      visibility_groups = {
        "alive"
      },    
    })


local promises = {}
 for i,v in pairs(mod.texture_lookup) do        
    if not mod.textures[i:lower()] then
      local item = mod.loader:load_texture(v):next(function(data)       
          mod.textures[i:lower()] = data           
      end)
      table.insert(promises, item)
    end
  end  
    
  Promise.all(unpack(promises))  
