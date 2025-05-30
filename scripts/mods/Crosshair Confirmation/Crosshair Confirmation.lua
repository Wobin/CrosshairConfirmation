--[[
Name: Crosshair Confirmation
Author: Wobin
Date: 24/05/25
Version: 1.4.3
--]]

local mod = get_mod("Crosshair Confirmation")
local DLS = get_mod("DarktideLocalServer")
mod.version = "1.4.3"
mod.textures = {}
mod.crosshair = {}
mod.special_show = false
mod.elite_show = false
mod.monster_show = false
mod.loader = Managers.url_loader

mod.load_crosshair = function(self, crosshair, shape)    
    if mod.textures[shape] and mod.textures[shape].texture then 
      crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map = mod.textures[shape].texture
    else
      mod:run_promises()
    end
  end

local function checktex(crosshair)
  return crosshair._widgets_by_name.crosshair.style.crosshair_style.material_values.texture_map 
end

mod.show_crosshair = function(self, templateType)  
  if not mod.textures[mod:get(templateType.."_shape")] or not mod.textures[mod:get(templateType.."_shape")].texture then     
    mod:load_crosshair(mod.crosshair[templateType], mod:get(templateType.."_shape"))    
  end
    
  if not checktex(mod.crosshair[templateType]) then        
    mod:load_crosshair(mod.crosshair[templateType], mod:get(templateType.."_shape"))        
  end
  
  if mod[templateType.. "_show"] then return end
  mod[templateType.. "_show"] = true
  Promise.delay(mod:get(templateType.."_delay")):next(function()       
      mod[templateType.. "_show"] = false end)  
end


    mod:register_hud_element({
      class_name = "CrosshairTemplate_Elite",
      filename = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshairs/CrosshairElite",
      use_hud_scale = true,
      visibility_groups = {
        "alive"
      },    
    })
    mod:register_hud_element({
      class_name = "CrosshairTemplate_Monster",
      filename = "Crosshair Confirmation/scripts/mods/Crosshair Confirmation/Crosshairs/CrosshairMonster",
      use_hud_scale = true,
      visibility_groups = {
        "alive"
      },    
    })
    mod:register_hud_element({
      class_name = "CrosshairTemplate_Special",
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
      if DLS then
        local texture_dir = DLS.absolute_path("images")      
        local dlsItem = DLS.get_image(texture_dir.. "\\".. mod.dls_lookup[i:lower()]):next(function(data)          
            mod.textures[i:lower()] = data                                   
          end):catch(function() mod:echo("Failed to get image") end)        
        table.insert(promises, dlsItem)
      else
        local item = mod.loader:load_texture(v):next(function(data)                 
          if not data.texture then 
            mod.refresh = true 
            mod:echo("Failed initial texture load for ".. v)
          else
            mod.textures[i:lower()] = data                       
          end
        end)
        table.insert(promises, item)
      end
    end
  end   
  Promise.all(unpack(promises)) 
end



mod.on_all_mods_loaded = function()    
  mod:info(mod.version)
  mod:hook_safe("HudElementCombatFeed", "event_combat_feed_kill", function(self, attacking_unit, attacked_unit)       
    if mod.refresh then 
      mod.refresh = false
      mod:run_promises()
      return
    end
    if not player then player = Managers.player:local_player(1) end
    if not player then return end
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
  if not Managers.backend:authenticated() then
    Managers.backend:authenticate():next(function() 
      mod:run_promises()          
    end):catch(function(errors)
      mod:dump(errors)
      mod:info("Error authenticating")
    end)
  else
    mod:run_promises()
  end  
end
