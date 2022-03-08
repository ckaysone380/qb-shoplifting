local QBCore = exports['qb-core']:GetCoreObject()
-- Variables

local PlayerData = {}
local coolDown = false
local GlobalTimer = 0
local completedJob = false
local firstComplete = false

-- EVENTS BEGIN

RegisterNetEvent('qb-shoplifting:client:doStuff')
AddEventHandler('qb-shoplifting:client:doStuff', function()
    local ped = PlayerPedId()
    if GlobalTimer == 0 then

        QBCore.Functions.Progressbar('shopliftbar', 'Shoplifting...', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
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
        end, 

        function() -- Play When Cancel

        end)
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


RegisterNetEvent('qb-shoplifting:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" and onDuty then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "10-31 | Shop Lifter",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
        })

        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 458)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("10-31 | Shop Lifter")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
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