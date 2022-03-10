local QBCore = exports['qb-core']:GetCoreObject()
-- Variables

local PlayerData = {}
local coolDown = false
local GlobalTimer = 0
local completedJob = false
local firstComplete = false


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