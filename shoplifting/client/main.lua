local QBCore = exports['qb-core']:GetCoreObject()


local PlayerData = {}
local coolDown = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
  PlayerData.job = job
end)

CreateThread(function()
	while true do
		local sleepThread = 750
		local player = PlayerPedId(-1)
		local pCoords = GetEntityCoords(player)

		for _,p in pairs(Config.Positions) do
			local dist1 = GetDistanceBetweenCoords(pCoords, p.x, p.y, p.z)
			if dist1 < 1 then
				sleepThread = 5;
				if p.coolDown == 0 then
					Draw3DText(p.x, p.y, p.z, '[~g~E~w~] Shoplift')
					if IsControlJustPressed(1, 38) then
						FreezeEntityPosition(player, true)
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
							--Stuff goes here
							IsDrilling = false
						end, function() -- Play When Cancel
							--Stuff goes here
						end)
						Wait(5000)
						p.coolDown = Config.CoolDownTimer
						FreezeEntityPosition(player, false)
						itemToGive = Config.RewardItems[math.random(1, #Config.RewardItems)]
						TriggerServerEvent('shoplifting:server:RewardItem', itemToGive.item)
						QBCore.Functions.Notify('You Stole ' .. itemToGive.label .. '!', 'success', 5000)
					end
				else
					Draw3DText(p.x, p.y, p.z, '[~r~E~w~] Shoplift')
					if IsControlJustPressed(1, 38) then
						QBCore.Functions.Notify('You Already Shoplifted From This Shelf, Wait ' .. p.coolDown .. ' Seconds Before You Try Again', 'error', 5000)
					end
				end
			end
		end
		Wait(sleepThread)
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		for _,p in pairs(Config.Positions) do
			if p.coolDown > 0 then
				p.coolDown = p.coolDown - 1
				print(p.coolDown)
			end
		end
	end
end)