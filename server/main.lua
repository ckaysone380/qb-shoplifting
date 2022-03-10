local QBCore = exports['qb-core']:GetCoreObject()

local src = source

TriggerEvent('QBCore:GetObject')

RegisterServerEvent('qb-shoplifting:server:RewardItem')
AddEventHandler('qb-shoplifting:server:RewardItem', function(itemToGive)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    print(itemToGive)
    Player.Functions.AddItem(itemToGive, Config.RandomItemAmount)
end)

RegisterNetEvent('qb-shoplifting:server:sendAlert', function(alertData, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)