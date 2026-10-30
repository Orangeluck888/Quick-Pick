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
    local FACTOR = 0.2  -- 约 5 倍速，改这里可调速度

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