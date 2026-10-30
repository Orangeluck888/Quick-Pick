local function GetLanguage()
    return locale ~= nil and locale or "zh"
end
local is_chinese = GetLanguage():find("zh") ~= nil

name = is_chinese and "快速采集" or "Quick Pick"
description = is_chinese
    and "缩短采集、拾取、收获的动画时间（常开）；可选加速篝火烤食物、建造动画和制作读条。"
    or "Shortens pick/pickup/harvest animations (always on). Optional faster campfire cooking, build animations, and crafting time."
author = "salt510"
version = "1.0.0"
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false
client_only_mod = false
all_clients_require_mod = true
api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "快速采集",
    "Quick Pick",
    "salt510",
    "2026",
}

configuration_options = {
    {
        name = "Cook",
        label = is_chinese and "快速烹饪（篝火）" or "Quick Cook (Campfire)",
        hover = is_chinese
            and "缩短篝火/火坑等火炉烤食物的时间（约5倍速，不影响烹饪锅）"
            or "Reduce food cooking time on campfires/fire pits (~5x, does not affect cookpot)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "QuickBuild",
        label = is_chinese and "快速建造" or "Quick Build",
        hover = is_chinese
            and "缩短建筑放置动作动画时间"
            or "Shorten the build place animation",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "QuickCraft",
        label = is_chinese and "快速制作读条" or "Quick Craft Time",
        hover = is_chinese
            and "缩短制作栏物品/建筑时的制作读条时间（约4倍速）"
            or "Shorten the crafting progress time for items/structures (~4x)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
}

