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
