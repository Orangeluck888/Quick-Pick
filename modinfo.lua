local function GetLanguage()
    return locale ~= nil and locale or "zh"
end
local is_chinese = GetLanguage():find("zh") ~= nil

name = is_chinese and "快速采集" or "Quick Pick"
description = is_chinese
    and "缩短采集、拾取、收获等动作的动画时间，让采集更流畅。"
    or "Shortens the animation time of picking, picking up, and harvesting actions for smoother gathering."
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
}

