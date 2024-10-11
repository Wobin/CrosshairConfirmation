local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local mod = get_mod("Crosshair Confirmation")

local Definitions = {
  scenegraph_definition = {
    screen = UIWorkspaceSettings.screen,
    crosshair = {
      parent = "screen",
      size = { 150, 50 },
      vertical_alignment = "center",
      horizontal_alignment = "center",
      position = { 0, 0, 1 }    
    }    
  },
  widget_definitions = {
    crosshair = UIWidget.create_definition({
      {        
        pass_type = "texture",                
        style_id = "crosshair_style",        
        style = {
          horizontal_alignment = "center",
          vertical_alignment = "center",
          offset = {0,0,0,},
          size = {mod:get("monster_size"),mod:get("monster_size")},
          color = Color[mod:get("monster_colour")](255,true),			
          material_values = {
            texture_map = nil 
          },          
        },
        visibility_function = function() return mod.monster_show end,
      }
    }, "crosshair")
  }
}

local Crosshair = class("CrosshairTemplate_Monster", "HudElementBase")

function Crosshair:init(parent, draw_layer, start_scale)
  Crosshair.super.init(self, parent, draw_layer, start_scale, Definitions)  
  mod.crosshair["monster"] = self
end

return Crosshair