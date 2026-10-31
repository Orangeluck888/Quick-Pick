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

-- 快速烹饪（篝火类火炉）
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

-- 快速砍树
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

-- 快速挖矿
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

-- 快速钓鱼
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

-- 快速种地
if GetModConfigData("QuickPlant") then
    local plant_actions = {
        "PLANTSEED",                     -- 播种到农田/耕地
        "PLANTSOIL",                     -- 翻土（部分流程包含）
        "PLANTREGISTRY_RESEARCH",        -- 研究种子
        "PLANTREGISTRY_RESEARCH_FAIL",   -- 研究失败
        "ASSESSPLANTHAPPINESS",          -- 检查植物幸福度
        "INTERACT_WITH",                 -- 照料植物（与作物互动/对话）
    }
    for _, key in ipairs(plant_actions) do
        if GLOBAL.ACTIONS[key] then
            ChangeAction(GLOBAL.ACTIONS[key], "doshortaction")
        end
    end
end

--快速交互动物
if GetModConfigData("QuickAnimal") then
    local animal_actions = {
        "PET", "FEED", "MURDER", "BRUSH", "SHAVE",
        "CHECKTRAP", "SLAUGHTER", "STOPUSINGITEM", "RETURN_FOLLOWER",
    }
    for _, key in ipairs(animal_actions) do
        if GLOBAL.ACTIONS[key] then
            ChangeAction(GLOBAL.ACTIONS[key], "doshortaction")
        end
    end

    if GLOBAL.ACTIONS.CARNIVALGAME_FEED then
        ChangeAction(GLOBAL.ACTIONS.CARNIVALGAME_FEED, function(inst, action)
            return (inst.components.rider ~= nil and inst.components.rider:IsRiding() and "doshortaction") or
                       "doequippedaction"
        end)
    end

    if GLOBAL.ACTIONS.COMMUNEWITHSUMMONED then
        ChangeAction(GLOBAL.ACTIONS.COMMUNEWITHSUMMONED, function(inst, action)
            return action.invobject ~= nil and action.invobject:HasTag("abigail_flower") and "commune_with_abigail" or
                       "doshortaction"
        end)
    end
end

-- 快速搬雕像
-- 降低所有“重物”的移动减速倍率（默认 0.15，即减速 85%）
-- 新倍率设为 0.5，即只减速 50%
-- 注意：影响所有 heavy 标签物品，不限于雕像
if GetModConfigData("QuickHeavy") then
    -- TUNING.HEAVY_SPEED_MULT 是原版定义重物减速倍率的位置
    -- 原值约 0.15（乘以移速 = 减速 85%）
    if GLOBAL.TUNING.HEAVY_SPEED_MULT then
        GLOBAL.TUNING.HEAVY_SPEED_MULT = 0.5
    end
end

-- 快速抗击飞（缩短倒地起身硬直）
if GetModConfigData("QuickKnockback") then
    local GETUP_TIME = 0.5  -- 起身硬直时长（秒），原版约 1.5~2 秒；改小更快

    local function QuickKnockbackGetUp(sg)
        -- 1) 创建自定义的快速起身状态
        if not sg.states["doquickknockbacklanded"] then
            sg.states["doquickknockbacklanded"] = {
                name = "doquickknockbacklanded",
                tags = {"busy", "knockback"},
                onenter = function(inst)
                    inst.AnimState:PlayAnimation("knockbacklanded")
                    inst.sg:SetTimeout(GETUP_TIME)
                end,
                ontimeout = function(inst)
                    inst.sg:GoToState("idle")
                end,
                events = {
                    GLOBAL.EventHandler("animover", function(inst)
                        inst.sg:GoToState("idle")
                    end),
                },
            }
        end

        -- 2) 把原本进入 knockbacklanded 的逻辑，重定向到我们的快速状态
        local knockback_event = sg.events and sg.events["knockback"]
        if knockback_event then
            -- 保存原版 knockback 事件处理函数
            local old_knockback_fn = knockback_event.fn
            if old_knockback_fn then
                -- 替换 knockback 事件处理，在内部把 "knockbacklanded" 替换为 "doquickknockbacklanded"
                knockback_event.fn = function(inst, data)
                    -- 使用原版逻辑，但临时把 knockbacklanded 状态名替换掉
                    local old_GoToState = inst.sg.GoToState
                    inst.sg.GoToState = function(self, statename, params)
                        if statename == "knockbacklanded" then
                            statename = "doquickknockbacklanded"
                        end
                        return old_GoToState(self, statename, params)
                    end

                    local ok, err = pcall(old_knockback_fn, inst, data)
                    inst.sg.GoToState = old_GoToState  -- 恢复

                    if not ok then
                        print("[QuickKnockback] knockback event error:", err)
                    end
                end
            end
        end
    end

    -- 同时挂钩服务端和客户端
    AddStategraphPostInit("wilson", QuickKnockbackGetUp)
    AddStategraphPostInit("wilson_client", QuickKnockbackGetUp)
end

