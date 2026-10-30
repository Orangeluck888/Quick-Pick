local function ChangeAction(action, fn, name)
    if name then
        AddStategraphActionHandler(name, GLOBAL.ActionHandler(action, fn))
    else
        AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(action, fn))
        AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(action, fn))
    end
end

-- 采集（草、树枝、浆果等所有可采集物资）
ChangeAction(GLOBAL.ACTIONS.PICK, function(inst, action)
    return (action.target:HasTag("noquickpick") and "dolongaction")
        or (inst:HasTag("farmplantfastpicker") and action.target:HasTag("farm_plant") and "doshortaction")
        or (inst.replica.rider ~= nil and inst.replica.rider:IsRiding() and (
                (inst:HasTag("woodiequickpicker") and "dowoodiefastpick") or
                "doshortaction"
            ))
        or (action.target:HasTag("jostlepick") and "dojostleaction")
        or (action.target:HasTag("quickpick") and "doshortaction")
        or (inst:HasTag("fastpicker") and "doshortaction")
        or (inst:HasTag("woodiequickpicker") and "dowoodiefastpick")
        or (inst:HasTag("quagmire_fasthands") and "doshortaction")
        or "doshortaction"
end)

-- 暗影麦斯威尔角色的采集
ChangeAction(GLOBAL.ACTIONS.PICK, function(inst, action)
    return action.target ~= nil and action.target.components.pickable ~= nil and "doshortaction" or nil
end, "shadowmaxwell")

-- 收获（如农场、蜂箱等）
ChangeAction(GLOBAL.ACTIONS.HARVEST, "doshortaction")

-- 快速烹饪（篝火类火炉，开关，默认关闭）
if GetModConfigData("Cook") then
    local FACTOR = 0.3  -- 约 3.3 倍速，改这里可调速度

    -- 1) 缩短 "COOK" 动作的动画时间（篝火烤、烹饪锅放食材都走这个动作）
    ChangeAction(GLOBAL.ACTIONS.COOK, "doshortaction")

    -- 2) 缩短食物在篝火上的实际烤制时间
    --    在 StartCooking 时临时缩放 cooktime，烤完还原
    AddComponentPostInit("cookable", function(self)
        local old_StartCooking = self.StartCooking
        self.StartCooking = function(self, ...)
            local orig = self.cooktime
            if orig then
                self.cooktime = math.max(0.1, orig * FACTOR)
            end
            local r = old_StartCooking(self, ...)
            self.cooktime = orig
            return r
        end
    end)
end

if GetModConfigData("CookPot") then
    local FACTOR = 0.7  -- 加速 30%

    ChangeAction(GLOBAL.ACTIONS.COOK, "doshortaction")

    -- 精确到每个锅实例：在 stewer 组件初始化后缩放 cooktime，
    -- 比改全局 TUNING.BASE_COOK_TIME 更干净，
    -- 也不会被其他模组改 TUNING 时互相覆盖
    AddComponentPostInit("stewer", function(self)
        if self.cooktime then
            self.cooktime = math.max(0.1, self.cooktime * FACTOR)
        end
    end)
end

if GetModConfigData("QuickBuild") then
    ChangeAction(GLOBAL.ACTIONS.BUILD, "doshortaction")
    ChangeAction(GLOBAL.ACTIONS.REPAIR, "doshortaction")
    ChangeAction(GLOBAL.ACTIONS.SEW, "doshortaction")
    ChangeAction(GLOBAL.ACTIONS.DECORATEVASE, "doshortaction")
end

if GetModConfigData("QuickCraft") then
    local CRAFT_TIME_FACTOR = 0.25  -- 约 4 倍速

    AddSimPostInit(function()
        if GLOBAL.AllRecipes then
            for _, recipe in pairs(GLOBAL.AllRecipes) do
                if recipe.craft_time and recipe.craft_time > 0 then
                    recipe.craft_time = math.max(0.1, recipe.craft_time * CRAFT_TIME_FACTOR)
                end
            end
        end
    end)
end

local function ScaleTuningByFactor(keys, factor)
    for _, k in ipairs(keys) do
        if GLOBAL.TUNING[k] then
            GLOBAL.TUNING[k] = math.max(1, math.ceil(GLOBAL.TUNING[k] * factor))
        end
    end
end

-- 快速砍树（开关）
if GetModConfigData("Chop") then
    ScaleTuningByFactor({
        "EVERGREEN_CHOPS_SMALL", "EVERGREEN_CHOPS_NORMAL", "EVERGREEN_CHOPS_TALL",
        "DECIDUOUS_CHOPS_SMALL", "DECIDUOUS_CHOPS_NORMAL", "DECIDUOUS_CHOPS_TALL", "DECIDUOUS_CHOPS_MONSTER",
        "MUSHTREE_CHOPS_SMALL", "MUSHTREE_CHOPS_MEDIUM", "MUSHTREE_CHOPS_TALL",
        "WINTER_TREE_CHOP_SMALL", "WINTER_TREE_CHOP_NORMAL", "WINTER_TREE_CHOP_TALL",
        "TOADSTOOL_MUSHROOMSPROUT_CHOPS", "TOADSTOOL_DARK_MUSHROOMSPROUT_CHOPS",
        "DRIFTWOOD_TREE_CHOPS", "DRIFTWOOD_SMALL_CHOPS",
        "MOON_TREE_CHOPS_SMALL", "MOON_TREE_CHOPS_NORMAL", "MOON_TREE_CHOPS_TALL",
    }, 0.8)
end

-- 快速挖矿（开关）
if GetModConfigData("Mine") then
    ScaleTuningByFactor({
        "ICE_MINE", "ROCKS_MINE", "ROCKS_MINE_MED", "ROCKS_MINE_LOW",
        "MARBLETREE_MINE", "MARBLESHRUB_MINE_SMALL", "MARBLESHRUB_MINE_NORMAL", "MARBLESHRUB_MINE_TALL",
        "PETRIFIED_TREE_SMALL", "PETRIFIED_TREE_NORMAL", "PETRIFIED_TREE_TALL",
        "GARGOYLE_MINE", "GARGOYLE_MINE_LOW", "CAVEIN_BOULDER_MINE",
        "SPILAGMITE_SPAWNER", "SPILAGMITE_ROCK", "SCULPTURE_COVERED_WORK",
        "SEASTACK_MINE", "SHELL_CLUSTER_MINE", "MOONALTAR_ROCKS_MINE", "SALTSTACK_WORK_REQUIRED",
    }, 0.8)
end

-- 快速钓鱼（开关）
if GetModConfigData("Fish") then
    AddPrefabPostInit("fishingrod", function(inst)
        local fr = inst.components.fishingrod
        if fr then
            if fr.waittime then
                fr.waittime = math.max(0.1, fr.waittime * 0.8)
            end
            if fr.reeltime then
                fr.reeltime = math.max(0.1, fr.reeltime * 0.8)
            end
        end
    end)
end