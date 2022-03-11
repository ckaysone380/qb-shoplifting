local QBCore = exports['qb-core']:GetCoreObject()
-- Variables

local PlayerData = {}
local coolDown = false
local GlobalTimer = 0
local completedJob = false
local firstComplete = false


-- FUNCTIONS BEGIN

function IsWearingGloves()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    --print(armIndex)
    if model == `mp_m_freemode_01` then
        if Config.MaleNoGloves[armIndex] ~= nil and Config.MaleNoGloves[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoGloves[armIndex] ~= nil and Config.FemaleNoGloves[armIndex] then
            retval = false
        end
    end
    if armIndex ~= 0 then 
    QBCore.Functions.Notify(Config.Masks[armIndex], 'primary', 5000)
end
    return retval
end

IsWearingGloves()

function IsWearingBulletVest()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 9)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == `mp_m_freemode_01` then
        if Config.MaleNoVest[armIndex] ~= nil and Config.MaleNoVest[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoNoVest[armIndex] ~= nil and Config.FemaleNoVest[armIndex] then
            retval = false
        end
    end
    if armIndex ~= 0 then 
    QBCore.Functions.Notify(Config.Masks[armIndex], 'primary', 5000)
end
    return retval
end


function IsWearingMask()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 1)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    print(armIndex)

    if model == `mp_m_freemode_01` then
        if Config.MaleNoMask[armIndex] ~= nil and Config.MaleNoMask[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoMask[armIndex] ~= nil and Config.FemaleNoMask[armIndex] then
            retval = false
        end
    end
    if armIndex ~= 0 then 
    QBCore.Functions.Notify(Config.Masks[armIndex], 'primary', 5000)
end
    return retval
end
IsWearingMask()



-- function tablePrintOut(table)
--     if type(table) == 'table' then
--        local s = '\n{ '
--        for k,v in pairs(table) do
--           if type(k) ~= 'number' then k = '"'..k..'"' end
--           s = s .. '['..k..'] = ' .. tablePrintOut(v) .. ',\n'
--        end
--        return s .. '}'
--     else
--        return tostring(table)
--     end
--  end

-- -- example how to trigger it

-- print(tablePrintOut(Config.Masks))
-- print(Config.Masks)

-- END OF FUNCTIONS

-- EVENTS BEGIN

RegisterNetEvent('qb-shoplifting:client:doStuff')
AddEventHandler('qb-shoplifting:client:doStuff', function(coords)
    local pos = GetEntityCoords(PlayerPedId())
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then
    streetLabel = streetLabel .. " " .. street2
    end
    local ped = PlayerPedId()
    local alertData = {
        title = "10-33 | Shoplifter",
        coords = coords,
        description = "Someone Is Trying To Shoplift At "..streetLabel.. " "
    }

    if GlobalTimer == 0 then

        QBCore.Functions.Progressbar('shopliftbar', 'Shoplifting...', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@gangops@facility@servers@',
            anim = 'hotwire',
            flags = 16,
        }, {}, {}, 
        function() -- Play When Done
            completedJob = true
            firstComplete = true
                TriggerServerEvent('qb-shoplifting:server:sendAlert', alertData, streetLabel, coords)
        end)

        function sWord() -- Play When Cancel
            QBCore.Functions.Notify('You Stopped Shoplifting', 'error', 5000) 
        end
        Wait(5000)
        ClearPedTasks(ped)
        FreezeEntityPosition(player, false)
        itemToGive = Config.RewardItems[math.random(1, #Config.RewardItems)]
        TriggerServerEvent('qb-shoplifting:server:RewardItem', itemToGive.item)
        QBCore.Functions.Notify('You Stole ' .. itemToGive.label .. '!', 'success', 5000)
    else
        QBCore.Functions.Notify('You Already Shoplifted From This Shelf, Wait ' .. GlobalTimer .. ' Seconds Before You Try Again', 'error', 5000)
    end
end)



CreateThread(function()
    while true do
        if GlobalTimer ~= 0 and GlobalTimer > -1 and firstComplete then 
            Wait(900)
            GlobalTimer = GlobalTimer - 1
        elseif completedJob then
            GlobalTimer = Config.CoolDownTimer
            completedJob = false
        end
        Wait(100)
    end
end)