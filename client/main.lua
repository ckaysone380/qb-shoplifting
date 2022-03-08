local QBCore = exports['qb-core']:GetCoreObject()
-- Variables

local PlayerData = {}
local coolDown = false

-- BEGINING OF FUNCTIONS

function DrawMissionText(text, height, length)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(length, height)
end

function BlipDetails(blipName, blipText, color, route)
    BeginTextCommandSetBlipName("STRING")
    SetBlipColour(blipName, color)
    AddTextComponentString(blipText)
    SetBlipRoute(blipName, route)
    EndTextCommandSetBlipName(blipName)
end

function DrawText3Ds(x,y,z, text, scale)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

-- function Draw3DText(x,y,z, text)
--     local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    
--     SetTextScale(0.38, 0.38)
--     SetTextFont(4)
--     SetTextProportional(1)
--     SetTextColour(255, 255, 255, 200)
--     SetTextEntry("STRING")
--     SetTextCentre(1)

--     AddTextComponentString(text)
--     DrawText(_x, _y)

--     local factor = string.len(text) / 370
--     DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
-- end


-- END OF FUNCTIONS
-- EVENTS BEGIN


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('qb-shoplifting:client:doStuff', function()
local ped = PlayerPedId()
				if p.coolDown == 0 then

						QBCore.Functions.Progressbar('shopliftbar', 'Shoplifting...', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
							animDict = 'mini@repair',
							anim = 'fixing_a_ped',
							flags = 16,
						}, {}, {}, function() -- Play When Done
							ClearPedTasks(ped)

						end, function() -- Play When Cancel
							ClearPedTasks(ped)
						end)
						Wait(5000)
						p.coolDown = Config.CoolDownTimer
						FreezeEntityPosition(player, false)
						itemToGive = Config.RewardItems[math.random(1, #Config.RewardItems)]
						TriggerServerEvent('shoplifting:server:RewardItem', itemToGive.item)
						QBCore.Functions.Notify('You Stole ' .. itemToGive.label .. '!', 'success', 5000)
						else
						QBCore.Functions.Notify('You Already Shoplifted From This Shelf, Wait ' .. p.coolDown .. ' Seconds Before You Try Again', 'error', 5000)
			end
		end)
	end)
end

CreateThread(function()
	while true do
		Wait(1000)
		for _,p in pairs(Config.Positions) do
			if p.coolDown > 0 then
				p.coolDown = p.coolDown - 1
				print(p.coolDown) -- Prints out the cooldown left to Client 
			end
		end
	end
end)
