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

RegisterNetEvent('qb-shoplifting:server:callCops', function(type, safe, streetLabel, coords)
    local alertData = {
        title = "10-33 | Shop Robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Someone Is Trying To Shop Lift At "..streetLabel.."
    }
    TriggerClientEvent("qb-storerobbery:client:robberyCall", -1, type, safe, streetLabel, coords)
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
end)