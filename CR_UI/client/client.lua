local ESX	 = nil

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

-- Hides TREW UI when it's on Pause Menu
Citizen.CreateThread(function()

    local isPauseMenu = false

	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() then -- ESC Key
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = false })
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = true })
			end
		end
	end
end)



-- Player status
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if Config.ui.showHealth == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['isdead'] = false

			playerStatus['status'][showPlayerStatus] = {
				name = 'health',
				value = GetEntityHealth(GetPlayerPed(-1)) - 100
			}

			if IsEntityDead(GetPlayerPed(-1)) then
				playerStatus.isdead = true
			end
		end

		if Config.ui.showArmor == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'armor',
				value = GetPedArmour(GetPlayerPed(-1)),
			}
		end

		if Config.ui.showStamina == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'stamina',
				value = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
			}
		end

		TriggerServerEvent('trew_hud_ui:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end

	end
end)


-- Overall Info
RegisterNetEvent('trew_hud_ui:setInfo')
AddEventHandler('trew_hud_ui:setInfo', function(info)
	TriggerEvent('esx:getSharedObject', function(obj)
		ESX = obj
		ESX.PlayerData = ESX.GetPlayerData()
	end)

	local playerStatus 
	local showPlayerStatus = 0
	playerStatus = { action = 'setStatus', status = {} }


	if Config.ui.showHunger == true then
		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'hunger',
				value = math.floor(100-status.getPercent())
			}
		end)

	end

	if Config.ui.showThirst == true then
		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'thirst',
				value = math.floor(100-status.getPercent())
			}
		end)
	end

	if showPlayerStatus > 0 then
		SendNUIMessage(playerStatus)
	end


end)


AddEventHandler('esx:onPlayerSpawn', function()
	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
end)


function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local toggleui = false
RegisterCommand('ui', function()
	if not toggleui then
		SendNUIMessage({ action = 'toggleUi', value = false })
	else
		SendNUIMessage({ action = 'toggleUi', value = true })
	end
	toggleui = not toggleui
end)

exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)

exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end)
