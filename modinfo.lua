local function GetLanguage()
    return locale ~= nil and locale or "zh"
end
local is_chinese = GetLanguage():find("zh") ~= nil

name = is_chinese and "快速工作 2026" or "Quick Work 2026"
description = is_chinese
    and "缩短采集、拾取、收获，砍树，挖矿的动画时间（常开），但又不会过度超模；可选加速篝火烤食物、建造动画和制作读条。"
    or "Shorten the animation time for gathering, picking, harvesting, felling trees, and mining (always enabled), but without going overboard with excessive optimization; optional acceleration for cooking food over a campfire, building animations, and creating progress bars."
author = "salt510"
version = "1.5.0"
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
    "快速工作",
    "Quick Work",
    "salt510",
    "2026",
}

local on  = is_chinese and "开启" or "Enable"
local off = is_chinese and "关闭" or "Disable"

configuration_options = {
    {
        name = "Cook",
        label = is_chinese and "快速烹饪（篝火）" or "Quick Cook (Campfire)",
        hover = is_chinese
            and "缩短篝火/火坑等火炉烤食物的时间（约3.3倍速，不影响烹饪锅）"
            or "Reduce food cooking time on campfires/fire pits (~5x, does not affect cookpot)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "CookPot",
        label = is_chinese and "快速做饭（烹饪锅）" or "Quick Cook Pot",
        hover = is_chinese
            and "缩短烹饪锅和大厨便携锅的烹饪时间（加速30%，约1.4倍速）"
            or "Reduce cook time for cookpots and Warly's portable cookpot (30% faster, ~1.4x)",
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
            and "缩短建筑放置动作动画时间（约5倍速）"
            or "Shorten the build place animation(~4x)",
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
    {
        name = "Chop",
        label = is_chinese and "快速砍树" or "Quick Chop",
        hover = is_chinese
            and "砍树所需次数减少约20%（常开默认开启，可关闭）"
            or "Reduce hits needed to chop trees by ~20% (on by default, can be disabled)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "Mine",
        label = is_chinese and "快速挖矿" or "Quick Mine",
        hover = is_chinese
            and "挖矿所需次数减少约20%（默认开启，可关闭）"
            or "Reduce hits needed to mine rocks by ~20% (on by default, can be disabled)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "Fish",
        label = is_chinese and "快速钓鱼" or "Quick Fish",
        hover = is_chinese
            and "钓鱼等待/反应时间减少约20%（默认开启，可关闭）"
            or "Reduce fishing wait/reel time by ~20% (on by default, can be disabled)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "QuickPlant",
        label = is_chinese and "快速种地" or "Quick Plant",
        hover = is_chinese
            and "缩短播种种子和研究种子的动作动画时间"
            or "Shorten the animation time for planting seeds and researching seeds",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "QuickAnimal",
        label = is_chinese and "快速交互动物" or "Quick Animal Interaction",
        hover = is_chinese
            and "缩短抚摸、喂食、刷毛、剃毛、屠宰、检查陷阱等动物交互动作的动画时间"
            or "Shorten animations for petting, feeding, brushing, shaving, slaughtering, checking traps, etc.",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
    {
        name = "QuickHeavy",
        label = is_chinese and "快速搬雕像" or "Quick Heavy Carry",
        hover = is_chinese
            and "降低搬运重物（雕像、可疑大理石等）时的移速惩罚（减速由85%降至50%）"
            or "Reduce the movement speed penalty when carrying heavy items like statues (from 85% down to 50%)",
        options = {
            { description = on,  data = true  },
            { description = off, data = false },
        },
        default = true,
    },
}


