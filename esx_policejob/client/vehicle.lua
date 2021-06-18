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


local spawnedVehicles = {}

function OpenVehicleSpawnerMenu(type, station, part, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = _U('garage_title'),
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = {
		
		    {label = _U('garage_buyitem'), action = 'buy_vehicle'},
			{label = _U('garage_storeditem'), action = 'garage'}
			

	}}, function(data, menu)
	
		if data.current.action == 'buy_vehicle' then
			local shopElements = {}
			local shopCoords = Config.PoliceStations[station][part][partNum].InsideShop
			local authorizedVehicles = Config.AuthorizedVehicles[type][ESX.GetPlayerData().job.grade_name]

			if authorizedVehicles then
				if #authorizedVehicles > 0 then
					for k,vehicle in ipairs(authorizedVehicles) do
						if IsModelInCdimage(vehicle.model) then
							local vehicleLabel = GetDisplayNameFromVehicleModel(vehicle.model)
							
							table.insert(shopElements, {
								label = vehicleLabel,
								name  = vehicleLabel,
								model = vehicle.model,
								props = vehicle.props,
								type  = type
							})
						end
					end

					if #shopElements > 0 then
						OpenShopMenu(shopElements, playerCoords, shopCoords)
					else
						ESX.ShowNotification(_U('garage_notauthorized'))
					end
				else
					ESX.ShowNotification(_U('garage_notauthorized'))
				end
			else
				ESX.ShowNotification(_U('garage_notauthorized'))
			end
		elseif data.current.action == 'garage' then
			local garage = {}

			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					local allVehicleProps = {}

					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)

						if IsModelInCdimage(props.model) then
							local vehicleName = GetDisplayNameFromVehicleModel(props.model)
							local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

							if v.state then
								label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
							else
								label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
							end

							table.insert(garage, {
								label = label,
								state = v.state,
								model = props.model,
								plate = props.plate
							})

							allVehicleProps[props.plate] = props
						end
					end

					if #garage > 0 then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
							title    = _U('garage_title'),
							align    = 'bottom-right',
		                    css      = 'entreprise',
							elements = garage
						}, function(data2, menu2)
							if data2.current.state then
								local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, part, partNum)

								if foundSpawn then
									menu2.close()
									
									local vehicleNearPoint = GetClosestVehicle(spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, 3.0, 0, 71)
                                    if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, 6.0) then
									
									ESX.Game.SpawnVehicleaa7b(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
										local vehicleProps = allVehicleProps[data2.current.plate]
										ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
										SetVehicleDirtLevel(vehicle, 0.0) 
                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
			                            SetEntityAsMissionEntity(vehicle, true, true)
										TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.plate, false)
										local carplate = GetVehicleNumberPlateText(vehicle)	
	
	                                    ESX.TriggerServerCallback('eden_garage:GetFuelLevel', function(fuellvl)		
                                        FuelValue = tonumber(fuellvl)					
                                        TriggerEvent("fuel:SetNewData", FuelValue)		
                                        end,carplate)
									end)
								else
								    exports['mythic_notify']:DoHudText('error', 'Action Denied! Please Wait For The Current Vehicle To Move First')
								  end
								end
							else
								ESX.ShowNotification(_U('garage_notavailable'))
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					else
						ESX.ShowNotification(_U('garage_empty'))
					end
				else
					ESX.ShowNotification(_U('garage_empty'))
				end
			end, type)
		elseif data.current.action == 'store_garage' then
			
		end
	end, function(data, menu)
		menu.close()
	end)
end


function GetAvailableVehicleSpawnPoint(station, part, partNum)
	local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name),
			align    = 'bottom-right',
		    css      = 'entreprise',
			elements = {
				{label = _U('confirm_no'), value = 'no'},
				{label = _U('confirm_yes'), value = 'yes'}
		}}, function(data2, menu2)

			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('esx_policejob:buyJobVehicle', function (bought)
					if bought then
						ESX.ShowNotification("You Were Just ~b~Assigned ~w~A ~g~[" ..data.current.name.. ']~w~ It Is Now In The ~b~Police Garage')

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)

						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification(_U('vehicleshop_money'))
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()
		WaitForVehicleToLoad(data.current.model)

		ESX.Game.SpawnLocalVehicleaa7b(data.current.model, shopCoords, 92.99, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetVehicleDirtLevel(vehicle, 0.0) 
			SetModelAsNoLongerNeeded(data.current.model)

			if data.current.props then
				ESX.Game.SetVehicleProperties(vehicle, data.current.props)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicleaa7b(elements[1].model, shopCoords, 92.99, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0.0) 
		SetModelAsNoLongerNeeded(elements[1].model)

		if elements[1].props then
			ESX.Game.SetVehicleProperties(vehicle, elements[1].props)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(_U('vehicleshop_awaiting_model'))
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end
