local mod = get_mod("Crosshair Confirmation")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")

mod.texture_lookup = {
  ["circle"] =   "https://wobin.github.io/CrosshairConfirmation/images/circle.png",
  ["dot"] =      "https://wobin.github.io/CrosshairConfirmation/images/dot.png",
  ["ex"] =       "https://wobin.github.io/CrosshairConfirmation/images/ex.png",
  ["heart"] =    "https://wobin.github.io/CrosshairConfirmation/images/heart.png",
  ["plus"] =     "https://wobin.github.io/CrosshairConfirmation/images/plus.png",
  ["square"] =   "https://wobin.github.io/CrosshairConfirmation/images/square.png",
  ["triangle"] = "https://wobin.github.io/CrosshairConfirmation/images/triangle.png",
}

local options = {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {}
    }
}

local color_options = {}
for i, color_name in ipairs(Color.list) do
    table.insert(
        color_options,
        {
            text = color_name,
            value = color_name
        }
    )
end

table.sort(color_options, function(a, b) return a.text < b.text end)

local shape_options = {}
local shapes = table.keys(mod.texture_lookup)

for i, shape in ipairs(shapes) do
  table.insert( 
    shape_options, 
    {
      text = "shape_"..shape,
      value = shape
    }
  )
end

table.sort(shape_options, function(a, b) return a.text < b.text end)

local function get_color_options()
    return table.clone(color_options)
end

mod.widgets = {}

local function create_option_set(typeName)
    mod.widgets[typeName] = false
    return {
        setting_id = typeName .. "_crosshair",
        type = "group",
        sub_widgets = {
            {
                setting_id = typeName .. "_active",
                type = "checkbox",
                default_value = true
            },
            {
                setting_id = typeName .. "_colour",
                type = "dropdown",
                default_value = "citadel_gauss_blaster_green",
                options = get_color_options()
            },
            {
                setting_id = typeName .. "_shape",
                type = "dropdown",
                default_value = "square",
                options = table.clone(shape_options)
            },
             {
                setting_id = typeName .. "_size",
                type = "numeric",
                default_value = 50,
                range = {30, 250},
                decimals_number = 0
            },
            {
                setting_id = typeName .. "_delay",
                type = "numeric",
                default_value = 2,
                range = {0.1, 3},
                decimals_number = 1
            },
        }
    }
end

table.insert(options.options.widgets, create_option_set("special"))
table.insert(options.options.widgets, create_option_set("elite"))
table.insert(options.options.widgets, create_option_set("monster"))
return options