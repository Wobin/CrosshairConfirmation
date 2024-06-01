local mod = get_mod("Crosshair Confirmation")
local InputUtils = require("scripts/managers/input/input_utils")


local localizations =  {
  mod_name = {
    en = "Crosshair Confirmation"
    },
	mod_description = {
		en = "Will display a brief custom crosshair when you kill a particular type of enemy",
	},
  special_crosshair = {
    en = "Special Enemies"
  },
  elite_crosshair = {
    en =  "Elite Enemies"
  },
  monster_crosshair = {
    en = "Monstrous Enemies"
    },
  shape_circle = {
    en = "Circle"
  },
  shape_dot = {
    en = "Dot"
  },
  shape_ex = {
    en = "X"
  },
  shape_heart = {
    en = "Heart"
  },
  shape_plus = {
    en = "Plus"
  },
  shape_square = {
    en = "Square"
  },
  shape_triangle = {
    en = "Triangle"
  },
}

local function addType(typeName)  
  localizations[typeName .. "_active"] = { en = "Turn on" }
  localizations[typeName .. "_colour"] = { en = "Colour" }
  localizations[typeName .. "_shape"] = { en = "Shape" }
  localizations[typeName .. "_size"] = { en = "Size" }
  localizations[typeName .. "_delay"] = { en = "Visibility Time" }
end

addType("special")
addType("elite")
addType("monster")

local function readable(text)
    local readable_string = ""
    local tokens = string.split(text, "_")
    for i, token in ipairs(tokens) do
        local first_letter = string.sub(token, 1, 1)
        token = string.format("%s%s", string.upper(first_letter), string.sub(token, 2))
        readable_string = string.trim(string.format("%s %s", readable_string, token))
    end

    return readable_string
end

local color_names = Color.list
for i, color_name in ipairs(color_names) do
    local color_values = Color[color_name](255, true)
    local text = InputUtils.apply_color_to_input_text(readable(color_name), color_values)
    localizations[color_name] = {
        en = text
    }
end

return localizations