--[[
Name: Crosshair Confirmation
Author: Wobin
Date: 06/07/24
Version: 1.2d
--]]

local mod = get_mod("Crosshair Confirmation")
mod.version = "1.2d"
mod.textures = {}
mod.crosshair = {}
mod.loader = Managers.url_loader

mod.load_crosshair = function(self, crosshair, shape)        
    if mod.textures[shape] and mod.textures[shape].texture then 
    crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map = mod.textures[shape].texture
  else
    mod:echo("load_crosshair -> load texture ".. mod.texture_lookup[shape])
    mod:dump(mod.textures[shape].texture, "texture",1)
    mod.loader:load_texture(mod.texture_lookup[shape]):next(function(data)
        mod:dump(data, "data",1)
        mod.textures[shape] = data           
        crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map = mod.textures[shape].texture
    end
      )
  end
end

local function checktex(crosshair)
  return crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map 
end

mod.show_crosshair = function(self, templateType)  
  if not mod.textures[mod:get(templateType.."_shape")] or not mod.textures[mod:get(templateType.."_shape")].texture then     
    mod:echo("show_crosshair -> no texture -> load_crosshair")
    mod:load_crosshair(mod.crosshair[templateType], mod:get(templateType.."_shape"))
    return 
  end
    
  if not checktex(mod.crosshair[templateType], mod:get(templateType.."_shape")) then    
    mod:echo("show_crosshair -> no texturemap -> load_crosshair")
    mod:load_crosshair(mod.crosshair[templateType], mod:get(templateType.."_shape"))
    return
  end
  
  if mod[templateType.. "_show"] then return end
  
  mod[templateType.. "_show"] = true
  Promise.delay(mod:get(templateType.."_delay")):next(function() mod[templateType.. "_show"] = false end)  
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

mod.run_promises = function(self)

local promises = {}

 for i,v in pairs(mod.texture_lookup) do        
    if not mod.textures[i:lower()] then
      local item = mod.loader:load_texture(v):next(function(data)                 
          if not data.texture then 
            mod:dump(data, "unloaded texture", 1)
            mod.refresh = true 
          else
            mod.textures[i:lower()] = data           
          end
      end)
      table.insert(promises, item)
    end
  end   
  Promise.all(unpack(promises)) 
end

Managers.backend:authenticate()


mod.on_all_mods_loaded = function()    
  mod:hook_safe("HudElementCombatFeed", "event_combat_feed_kill", function(self, attacking_unit, attacked_unit)       
    if mod.refresh then 
      mod.refresh = false
      mod:run_promises()
      return
    end
    if not player then player = Managers.player:local_player(1) end
    if player.player_unit ~= attacking_unit then return end
    local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
    local breed = unit_data_extension and unit_data_extension:breed()
    
    if not breed or not breed.tags then return end
    
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
  
  mod:run_promises()
end
