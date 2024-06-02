local mod = get_mod("Crosshair Confirmation")
local InputUtils = require("scripts/managers/input/input_utils")


local localizations =  {
  mod_name = {
    en = "Crosshair Confirmation",
    ["zh-cn"] = "准星击杀确认",
    },
	mod_description = {
		en = "Will display a brief custom crosshair when you kill a particular type of enemy",
		["zh-cn"] = "在击杀特定类型敌人时，显示一个简单的自定义准星",
	},
  special_crosshair = {
    en = "Special Enemies",
    ["zh-cn"] = "特殊敌人",
  },
  elite_crosshair = {
    en =  "Elite Enemies",
    ["zh-cn"] = "精英敌人",
  },
  monster_crosshair = {
    en = "Monstrous Enemies",
    ["zh-cn"] = "怪物敌人",
    },
  shape_circle = {
    en = "Circle",
    ["zh-cn"] = "圆形",
  },
  shape_dot = {
    en = "Dot",
    ["zh-cn"] = "单点",
  },
  shape_ex = {
    en = "X"
  },
  shape_heart = {
    en = "Heart",
    ["zh-cn"] = "心形",
  },
  shape_plus = {
    en = "Plus",
    ["zh-cn"] = "十字",
  },
  shape_square = {
    en = "Square",
    ["zh-cn"] = "方形",
  },
  shape_triangle = {
    en = "Triangle",
    ["zh-cn"] = "三角",
  },
}

local function addType(typeName)  
  localizations[typeName .. "_active"] = {
    en = "Turn on",
    ["zh-cn"] = "启用",
  }
  localizations[typeName .. "_colour"] = {
    en = "Colour",
    ["zh-cn"] = "颜色",
  }
  localizations[typeName .. "_shape"] = {
    en = "Shape",
    ["zh-cn"] = "形状",
  }
  localizations[typeName .. "_size"] = {
    en = "Size",
    ["zh-cn"] = "大小",
  }
  localizations[typeName .. "_delay"] = {
    en = "Visibility Time",
    ["zh-cn"] = "可见时间",
  }
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
