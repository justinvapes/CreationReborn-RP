-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local carInstance = {}

cachedData = {}

-- Fin Local

-- Init ESX
ESX = nil

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


RegisterNetEvent('esx_eden_garage:ControlVehicle')
AddEventHandler('esx_eden_garage:ControlVehicle', function()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local vehicle = GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			OpenVehicleMenu()
		else
			ESX.ShowNotification('You cannot do this if you are not the driver')
		end
	else
		OpenVehicleMenu()
	end
end)

RegisterNetEvent('eden_garage:EjectUsers')
AddEventHandler('eden_garage:EjectUsers', function()
	TaskLeaveAnyVehicle(PlayerPedId(), 0, 0)
end)

function OpenMenuGarage(garage, KindOfVehicle, garage_name, vehicle_type)
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Return Vehicle ("..Config.Price.."$)", value = 'return_vehicle'},
	}


	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			title    = 'Garage',
			align    = 'bottom-right',
			css      = 'garage',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'return_vehicle') then
				ReturnVehicleMenu(garage, KindOfVehicle, garage_name, vehicle_type)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end
-- Afficher les listes des vehicules
function ListVehiclesMenu(garage, KindOfVehicle, garage_name, vehicle_type)
	local elements, vehiclePropsList = {}, {}
	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
		if not table.empty(vehicles) then
			for _,v in pairs(vehicles) do
				local vehicleProps = json.decode(v.vehicle)
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleHash = vehicleProps.model
				local vehicleName, vehicleLabel
								
				if v.vehiclename == 'voiture' then
					vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
				else
					vehicleName = v.vehiclename
				end

				if v.fourrieremecano then
					vehicleLabel = vehicleName..': Police Impound | ' .. v.plate
				elseif v.state then
					vehicleLabel = vehicleName..' | '.." "..v.garage_name.." | " .. v.plate
				else
					vehicleLabel = vehicleName..': Impound | '.." "..v.garage_name.." | " .. v.plate 
				end
				table.insert(elements, {
					label = vehicleLabel,
					vehicleName = vehicleName,
					state = v.state,
					plate = vehicleProps.plate,
					fourrieremecano = v.fourrieremecano,
					garage_name = v.garage_name
				})
				
			end
		else
			table.insert(elements, {label = "No Vehicles in the garage"})
		end
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = 'Garage',
			align    = 'bottom-right',
			css      = 'garage',--Boatsssssss
			elements = elements,
		},
		function(data, menu)
			local CarProps = vehiclePropsList[data.current.plate]
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_menu', {
				title    =  data.current.vehicleName,
				align    = 'bottom-right',
			    css      = 'garage',
				elements = {
					{label ="Use This Vehicle" , value = 'get_vehicle_out'},
					{label ="Rename This Vehicle" , value = 'rename_vehicle'},
					{label ="Delete This Vehicle" , value = 'delete_vehicle'}
			}}, function(data2, menu2)
			
					if data2.current.value == "get_vehicle_out" then
						local doesVehicleExist = false
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.plate) then
								if DoesEntityExist(v.vehicleentity) then
									doesVehicleExist = true
								else
									table.remove(carInstance, k)
									doesVehicleExist = false
								end
							end
						end
                        if (doesVehicleExist) then
							TriggerEvent('esx:showNotification', 'This Vehicle Is Already Out! Go Find It')
							
                        elseif (data.current.fourrieremecano) then
                            TriggerEvent('esx:showNotification', 'This Vehicle Is In The Police Impound')
							
                        elseif garage_name ~= data.current.garage_name then
							local elem = {}
							table.insert(elem, {label = 'Yes Transfer'.." $"..tostring(Config.SwitchGaragePrice) , value = 'transfer_yes'})
							table.insert(elem, {label ='No' , value = 'transfer_no'})
							ESX.UI.Menu.Open(
								'default', GetCurrentResourceName(), 'transfer_menu',
								{
									title    =  'Do you want to transfer'..": "..data.current.vehicleName..' to this garage',
									align    = 'bottom-right',
									css      = 'garage',
									elements = elem,
								},
								function(data3, menu3)
									if data3.current.value == "transfer_yes" then 
										if (data.current.state)  then
											ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
												if hasEnoughMoney then
													TriggerServerEvent("esx_eden_garage:MoveGarage",data.current.plate, garage_name)
													--SpawnVehicle(CarProps, garage, KindOfVehicle)
													ESX.UI.Menu.CloseAll()
												else
													ESX.ShowNotification('Not enough money to transfer')
												end
											end, Config.SwitchGaragePrice)
										else
											TriggerEvent('esx:showNotification', 'This Vehicle Is In The Impound')
										end
									else
										menu2.close()
										menu3.close()
									end
								end,
								function(data3, menu3)
									menu3.close()
								end
							)

						elseif (data.current.state) then
                            SpawnVehicle(CarProps, garage, garage_name, KindOfVehicle)
							ESX.UI.Menu.CloseAll()
                        else
                            TriggerEvent('esx:showNotification', 'This Vehicle Is In The Impound')
                        end
						
						elseif data2.current.value == "delete_vehicle" then	
						
						local elements = {
		                {label = "Are You Sure You Want To Delete This Vehicle?", value = 'yes'},
	                    }
	                    ESX.UI.Menu.Open(
		                 'default', GetCurrentResourceName(), 'delete_menu',
		                 {
			              title    = 'Delete Vehicle',
			              align    = 'bottom-right',
			              css      = 'garage',
			              elements = elements,
		                 },
		                 function(data2, menu2)
			             menu2.close()
						
			            if(data2.current.value == 'yes') then
			              TriggerServerEvent('eden_garage:deleteit', data.current.plate)
						  exports['mythic_notify']:DoHudText('error', 'The Vehicle With The Plate [' ..data.current.plate.. '] Has Now Been Deleted')
                          ESX.UI.Menu.CloseAll()
						  ListVehiclesMenu(garage, KindOfVehicle, garage_name, vehicle_type)
						  menu2.close()						  
			           end
		             end,
		                function(data2, menu2)
			            menu2.close()
		             end
	                )
											
					elseif data2.current.value == "rename_vehicle" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_vehicle', {
							title = 'Name of The Vehicle'
						}, function(data3, menu3)
								TriggerServerEvent('eden_garage:renamevehicle', data.current.plate, data3.value)
								ESX.UI.Menu.CloseAll()
								ListVehiclesMenu(garage, KindOfVehicle, garage_name, vehicle_type)
								menu3.close()

						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end,
				function(data2, menu2)
					menu2.close()
				end
			)
		end,
		function(data, menu)
			menu.close()
		end
	)
	end, KindOfVehicle, garage_name, vehicle_type)
end

-- Fin Afficher les listes des vehicules

-- Afficher les listes des vehicules de fourriere
function ListVehiclesFourriereMenu(garage)
	local elements, vehiclePropsList = {}, {}

	ESX.TriggerServerCallback('eden_garage:getVehiclesMecano', function(vehicles)

		for k,v in ipairs(vehicles) do
			--print(ESX.DumpTable(v))
			local vehicleProps = json.decode(v.vehicle)
			vehiclePropsList[vehicleProps.plate] = vehicleProps
			local vehicleHash = vehicleProps.model
			local vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)

			table.insert(elements, {
				label = ('%s | %s | %s'):format(vehicleName, v.ownerName, v.plate),
				plate = vehicleProps.plate
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle_mecano', {
			title    = 'Garage',
			align    = 'bottom-right',
			css      = 'garage',
			elements = elements,
		}, function(data, menu)
			local vehicleProps = vehiclePropsList[data.current.plate]
			menu.close()
			SpawnVehicleMecano(vehicleProps, garage)
			TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicleProps, false)
		end, function(data, menu)
			menu.close()
		end)

	end)
end
-- Fin Afficher les listes des vehicules de fourriere


-- Fonction qui permet de rentrer un vehicule
function StockVehicleMenu(KindOfVehicle, garage_name, vehicle_type)
	local playerPed  = PlayerPedId()
	
	if IsPedInAnyVehicle(playerPed,  false) then
		local vehicle = GetVehiclePedIsIn(playerPed,false)
		
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(vehicle)
			
			if GotTrailer then
			
				local trailerProps  = ESX.Game.GetVehicleProperties(TrailerHandle)
				ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
					if(valid) then
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(trailerProps.plate) then
								table.remove(carInstance, k)
							end
						end
						DeleteEntity(TrailerHandle)
						TriggerServerEvent('eden_garage:modifystate', trailerProps.plate, true)
						TriggerServerEvent("esx_eden_garage:MoveGarage", trailerProps.plate, garage_name)
						TriggerEvent('esx:showNotification', '~b~Your ~g~Trailer Is In The ~b~Garage')
					else
						TriggerEvent('esx:showNotification', "~b~You ~r~Can't ~w~Store This ~b~Vehicle")
					end
				end,trailerProps, KindOfVehicle, garage_name, vehicle_type)
			else

				local vehicleProps = GetVehicleProperties(vehicle)

				Fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))
				FuelValue = tonumber(Fuel)  
				
				ESX.TriggerServerCallback('eden_garage:stockv',function(valid)
					if(valid) then
						for k,v in pairs (carInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehicleProps.plate) then
								table.remove(carInstance, k)
							end
						end
						
						local Passengers = GetVehicleMaxNumberOfPassengers(vehicle)

			            for i = -1, Passengers, 1 do
																	   
						    local pedSeat = GetPedInVehicleSeat(vehicle, i)	
							
							if pedSeat ~= 0 then						
                               ID = GetPlayerServerId(NetworkGetEntityOwner(pedSeat))						   
                               TriggerServerEvent('eden_garage:EjectUsers', ID)	
                            end							
					     end
							
				       while IsPedInVehicle(PlayerPedId(), vehicle, true) do
					   Citizen.Wait(0)
				       end
					   
					   if GetVehicleNumberOfPassengers(vehicle) == 0 then
	                      Citizen.Wait(1000)
				          ESX.Game.DeleteVehicle(vehicle)
	                  else						
				          Citizen.Wait(1300)
				          ESX.Game.DeleteVehicle(vehicle)
					   end
					    TriggerServerEvent('eden_garage:updateModelName', vehicleProps.plate, GetDisplayNameFromVehicleModel(tonumber(vehicleProps.model)))
						TriggerServerEvent('eden_garage:modifystate', vehicleProps.plate, true)
						TriggerServerEvent('eden_garage:savefuel', vehicleProps.plate, FuelValue)
						TriggerServerEvent("esx_eden_garage:MoveGarage", vehicleProps.plate, garage_name)
						TriggerEvent('esx:showNotification', '~b~Your ~g~Vehicle ~w~Is In The ~b~Garage')
					else
						TriggerEvent('esx:showNotification', "~b~You ~r~Can't ~w~Store This ~b~Vehicle")
					end
				end,vehicleProps, KindOfVehicle, garage_name, vehicle_type)
			end
		else
			TriggerEvent('esx:showNotification', 'You Are Not The Driver Of The Vehicle')
		end
	else
		TriggerEvent('esx:showNotification', 'There Is No Vehicle To Enter')
	end
end
-- Fin fonction qui permet de rentrer un vehicule 

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
		end
		
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

        return vehicleProps
    end
end

-- Fonction qui permet de rentrer un vehicule dans fourriere
function StockVehicleFourriereMenu()
	local playerPed  = PlayerPedId()
	if IsPedInAnyVehicle(playerPed,  false) then
		local vehicle =GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(vehicle)
			if GotTrailer then
				local trailerProps  = ESX.Game.GetVehicleProperties(TrailerHandle)
				ESX.TriggerServerCallback('eden_garage:stockvmecano',function(valid)
					if(valid) then
						DeleteVehicle(TrailerHandle)
						TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', trailerProps, true)
						TriggerEvent('esx:showNotification', 'The Trailer Is In The Impound')
					else
						TriggerEvent('esx:showNotification', 'You Can Not Store This Vehicle')
					end
				end,trailerProps)
			else
				local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
				ESX.TriggerServerCallback('eden_garage:stockvmecano',function(valid)
					if(valid) then
						DeleteVehicle(vehicle)
						TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicleProps, true)
						TriggerEvent('esx:showNotification', 'The vehicle is back in the pound')
					else
						TriggerEvent('esx:showNotification', 'You Can Not Store This Vehicle')
					end
				end,vehicleProps)
			end
		else
			TriggerEvent('esx:showNotification', 'You Are Not The Driver Of The Vehicle')
		end
	else
		TriggerEvent('esx:showNotification', 'There Is No Vehicle To Enter')
	end
end
-- Fin fonction qui permet de rentrer un vehicule dans fourriere
--Fin fonction Menu


function SpawnVehicle(vehicle, garage, garage_name, KindOfVehicle)

 if vehicle.model == 1200192514 or vehicle.model == -1831138000 or vehicle.model == 516749574 then 

    local vehicleNearPoint = GetClosestVehicle(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 3.0, 0, 71)	
    if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 6.0) then
		
	if garage_name == 'TrailerGarage_Centre' then		
	  if vehicle.model == 1200192514 then--Hauler
	     Heading = 220.0
	  elseif vehicle.model == 516749574 then --JetskiT	
	     Heading = 215.0
	 else
	     Heading = garage.SpawnPoint.Heading
	 end
	 
	 elseif garage_name == 'TrailerGarage_Paleto' then	
	  if vehicle.model == 1200192514 then     	  		
	     Heading = 19.00
		elseif vehicle.model == 516749574 then 
		 Heading = 10.00
	 else
	     Heading = garage.SpawnPoint.Heading
	  end
	end
		
	ESX.Game.SpawnVehicleaa7b(vehicle.model, {
		x = garage.SpawnPoint.Pos.x,
		y = garage.SpawnPoint.Pos.y,
		z = garage.SpawnPoint.Pos.z + 1											
		},Heading, function(callback_vehicle)
		
											
	   SetVehicleProperties(callback_vehicle, vehicle)
				
		if vehicle.model == 1200192514 then 
           SetVehicleMod(callback_vehicle, 2)
		elseif vehicle.model == -1831138000 then 
           SetVehicleMod(callback_vehicle, 0)						
		end
			local carplate = GetVehicleNumberPlateText(callback_vehicle)
			table.insert(carInstance, {vehicleentity = callback_vehicle, plate = carplate})
	   end)
		TriggerServerEvent('eden_garage:modifystate', vehicle.plate, false)
    else
        ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
     end
	 
  else

    local vehicleNearPoint = GetClosestVehicle(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 3.0, 0, 71)	
    if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 6.0) then
		
	ESX.Game.SpawnVehicleaa7b(vehicle.model, {
		x = garage.SpawnPoint.Pos.x,
		y = garage.SpawnPoint.Pos.y,
		z = garage.SpawnPoint.Pos.z + 1											
		},garage.SpawnPoint.Heading, function(callback_vehicle)
		
		--False Is On \ True Is Off
		if vehicle.model == -1245980728 then --Drag VL Parachute
		    SetVehicleExtra(callback_vehicle, 2, true)--Don't spawn the race vl with its parachute
		elseif 	
			vehicle.model == -726635538 then --GTR R35 Plate
		    SetVehicleExtra(callback_vehicle, 1, false)--Spawn The GTR With Good Plate always	
        elseif 	
			vehicle.model == 62986539 then --Veneno Plate
		    SetVehicleExtra(callback_vehicle, 1, false)--Spawn The Veneno With Good Plate always					
		end
									
			SetVehicleProperties(callback_vehicle, vehicle)
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
			local carplate = GetVehicleNumberPlateText(callback_vehicle)
			table.insert(carInstance, {vehicleentity = callback_vehicle, plate = carplate})
	   end)
		TriggerServerEvent('eden_garage:modifystate', vehicle.plate, false)
    else
        ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
     end
  end
end

SetVehicleProperties = function(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
	

    if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end

    end
	
	 local carplate = GetVehicleNumberPlateText(vehicle)	
	
	 ESX.TriggerServerCallback('eden_garage:GetFuelLevel', function(fuellvl)		
     FuelValue = tonumber(fuellvl)					
     TriggerEvent("fuel:SetNewData", FuelValue)		
  end,carplate)
end

--Fonction pour spawn vehicule fourriere mecano
function SpawnVehicleMecano(vehicle, garage)
	ESX.Game.SpawnVehicleaa7b(vehicle.model, {
		x = garage.SpawnPoint.Pos.x,
		y = garage.SpawnPoint.Pos.y,
		z = garage.SpawnPoint.Pos.z + 1											
		},garage.SpawnPoint.Heading, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		end)
	TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicle, false)
end
--Fin fonction pour spawn vehicule fourriere mecano

function ReturnVehicleMenu(garage, KindOfVehicle, garage_name, vehicle_type)

	ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)
		local elements, vehiclePropsList = {}, {}
		
		if not table.empty(vehicles) then
			for _,v in pairs(vehicles) do
			
				local vehicleProps = json.decode(v.vehicle)
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleHash = vehicleProps.model
				local vehicleName, vehicleLabel

				if v.vehiclename == 'voiture' then
					vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
				else
					vehicleName = v.vehiclename
				end

				if v.fourrieremecano then
					vehicleLabel = vehicleName..': Police Impound'
					table.insert(elements, {label = vehicleLabel, action = 'fourrieremecano'})
				else
					vehicleLabel = vehicleName..': Exit'
					table.insert(elements, {
						label = vehicleLabel,
						plate = vehicleProps.plate,
						action = 'store'
					})
				end
			end
		else
			table.insert(elements, {label = "No Vehicle To Get Out", action = 'nothing'})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			title    = 'Garage',
			align    = 'bottom-right',
			css      = 'garage',
			elements = elements,
		},
		function(data, menu)
			local vehicleProps = vehiclePropsList[data.current.plate]
			if data.current.action == 'fourrieremecano' then
				ESX.ShowNotification("Check With The Police To Find Out How To Get Your Car Back")
				
			elseif data.current.action ~= nil then
				local doesVehicleExist = false
				for k,v in pairs (carInstance) do
					if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.plate) then
						if DoesEntityExist(v.vehicleentity) then
							doesVehicleExist = true
						else
							table.remove(carInstance, k)
							doesVehicleExist = false
						end
					end
				end
				if not doesVehicleExist then
					local vehicleNearPoint = GetClosestVehicle(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 3.0, 0, 71)	
					if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(garage.SpawnPoint.Pos.x, garage.SpawnPoint.Pos.y, garage.SpawnPoint.Pos.z, 6.0) then
						ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
							if hasEnoughMoney then
								menu.close()						
								SpawnVehicle(vehicleProps, garage, KindOfVehicle)
							else
								ESX.ShowNotification('You Do Not Have Enough Money')						
							end
						end, Config.Price)
					else
						ESX.ShowNotification("~r~Please wait for the current vehicle to move first!")
					end
				else
					ESX.ShowNotification("This Vehicle Is Already Out! Go Find It")
				end				
			end
		end,
		function(data, menu)
			menu.close()
		end
		)
	end, KindOfVehicle, garage_name, vehicle_type)
end

function exitmarker()
	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent("ft_libs:OnClientReady")
AddEventHandler('ft_libs:OnClientReady', function()
	for k,v in pairs (Config.Garages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage", {
			marker = {
				weight = v.Marker.w,
				height = v.Marker.h,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.Marker.w,
				active = {
					callback = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "car")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.Blip.color,
				imageId = Config.Blip.sprite,
			},
			locations = {
				v.Pos				
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_spawnpoint", {
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesMenu(v, "personal", k, "car")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.SpawnPoint.Pos.x,
					y = v.SpawnPoint.Pos.y,
					z = v.SpawnPoint.Pos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_deletepoint", {
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
					if IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleMenu("personal", k, "car")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
	
	for k,v in pairs (Config.GaragesMecano) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_mecanospawnpoint", {
			enable = false,
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesFourriereMenu(v)
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.MecanoBlip.color,
				imageId = Config.MecanoBlip.sprite,
			},
			locations = {
				{
					x = v.SpawnPoint.Pos.x,
					y = v.SpawnPoint.Pos.y,
					z = v.SpawnPoint.Pos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_mecanodeletepoint", {
			enable = false,
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleFourriereMenu()
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
	
		for k,v in pairs (Config.TrailerGarages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage_TrailerGarages", {
			marker = {
				weight = v.Marker.w,
				height = v.Marker.h,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.Marker.w,
				active = {
					callback = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "trailer")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.TrailerBlip.color,
				imageId = Config.TrailerBlip.sprite,
			},
			locations = {
				v.Pos				
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_spawnpoint_TrailerGarages", {
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
					if IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesMenu(v, "personal", k, "trailer")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.SpawnPoint.MarkerPos.x,
					y = v.SpawnPoint.MarkerPos.y,
					z = v.SpawnPoint.MarkerPos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_deletepoint_TrailerGarages", {
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 27,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
					if IsPedInAnyVehicle(PlayerPedId()) then
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleMenu("personal", k, "trailer")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
	
	for k,v in pairs (Config.PoliceGarages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage_PoliceGarages", {
			marker = {
				weight = v.Marker.w,
				height = v.Marker.h,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = -1,
			},
			
			trigger = {
				weight = v.Marker.w,
				active = {
					callback = function()
					if not IsPedInAnyVehicle(PlayerPedId()) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "police")
						end
					  end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},

			locations = {
				v.Pos				
			},
		})
	end
	
	for k,v in pairs (Config.BoatGarages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage_BoatGarages", {
			marker = {
				weight = v.Marker.w,
				height = v.Marker.h,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "boat")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.BoatBlip.color,
				imageId = Config.BoatBlip.sprite,
			},
			locations = {
				v.Pos				
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_spawnpoint_BoatGarages", {
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesMenu(v, "personal", k, "boat")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.SpawnPoint.MarkerPos.x,
					y = v.SpawnPoint.MarkerPos.y,
					z = v.SpawnPoint.MarkerPos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_deletepoint_BoatGarages", {
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleMenu("personal", k, "boat")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
	
	
	for k,v in pairs (Config.AirplaneGarages) do
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_garage_AirplaneGarages", {
			marker = {
				weight = v.Marker.w,
				height = v.Marker.h,
				red = v.Marker.r,
				green = v.Marker.g,
				blue = v.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							OpenMenuGarage(v, "personal", k, "airplane")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			blip = {
				text = v.Name,
				colorId = Config.AirplaneBlip.color,
				imageId = Config.AirplaneBlip.sprite,
			},
			locations = {
				v.Pos				
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_spawnpoint_AirplaneGarages", {
			marker = {
				weight = v.SpawnPoint.Marker.w,
				height = v.SpawnPoint.Marker.h,
				red = v.SpawnPoint.Marker.r,
				green = v.SpawnPoint.Marker.g,
				blue = v.SpawnPoint.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.SpawnPoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.SpawnPoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) and not IsPedInAnyVehicle(PlayerPedId()) then
							ListVehiclesMenu(v, "personal", k, "airplane")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.SpawnPoint.MarkerPos.x,
					y = v.SpawnPoint.MarkerPos.y,
					z = v.SpawnPoint.MarkerPos.z,
				},
			},
		})
		exports.ft_libs:AddArea("esx_eden_garage_area_"..k.."_deletepoint_AirplaneGarages", {
			marker = {
				weight = v.DeletePoint.Marker.w,
				height = v.DeletePoint.Marker.h,
				red = v.DeletePoint.Marker.r,
				green = v.DeletePoint.Marker.g,
				blue = v.DeletePoint.Marker.b,
				type = 1,
			},
			trigger = {
				weight = v.DeletePoint.Marker.w,
				active = {
					callback = function()
						exports.ft_libs:HelpPromt(v.DeletePoint.HelpPrompt)
						if IsControlJustReleased(0, 38) and IsInputDisabled(0) and GetLastInputMethod(2) then
							StockVehicleMenu("personal", k, "airplane")
						end
					end,
				},
				exit = {
					callback = exitmarker
				},
			},
			locations = {
				{
					x = v.DeletePoint.Pos.x,
					y = v.DeletePoint.Pos.y,
					z = v.DeletePoint.Pos.z,
				},
			},
		})
	end
end)

-- Fin controle touche
function dump(o, nb)
  if nb == nil then
    nb = 0
  end
   if type(o) == 'table' then
      local s = ''
      for i = 1, nb + 1, 1 do
        s = s .. "    "
      end
      s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
          for i = 1, nb, 1 do
            s = s .. "    "
          end
         s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
      end
      for i = 1, nb, 1 do
        s = s .. "    "
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

--- garage societe

RegisterNetEvent('esx_eden_garage:ListVehiclesMenu')
AddEventHandler('esx_eden_garage:ListVehiclesMenu', function(garage, society, societygarage)
	if not IsPedInAnyVehicle(PlayerPedId()) then
		ListVehiclesMenu(garage, society, societygarage, "car")
	end
end)

RegisterNetEvent('esx_eden_garage:OpenMenuGarage')
AddEventHandler('esx_eden_garage:OpenMenuGarage', function(garage, society, societygarage)
	if not IsPedInAnyVehicle(PlayerPedId()) then
		OpenMenuGarage(garage, society, societygarage, "car")
	end
end)

RegisterNetEvent('esx_eden_garage:StockVehicleMenu')
AddEventHandler('esx_eden_garage:StockVehicleMenu', function(society, societygarage)
	StockVehicleMenu(society, societygarage, "car")
end)


OpenVehicleMenu = function()
    ESX.TriggerServerCallback("eden_garage:fetchPlayerVehicles", function(fetchedVehicles)
        local menuElements = {}
        local gameVehicles = ESX.Game.GetVehicles()
        local pedCoords = GetEntityCoords(PlayerPedId())

        for key, vehicleData in ipairs(fetchedVehicles) do
            local vehicleProps = vehicleData["props"]

            for _, vehicle in ipairs(gameVehicles) do
                if DoesEntityExist(vehicle) then
                    local dstCheck = math.floor(#(pedCoords - GetEntityCoords(vehicle)))

                    if Config.Trim(GetVehicleNumberPlateText(vehicle)) == Config.Trim(vehicleProps["plate"]) then
                        table.insert(menuElements, {
                            ["label"] =  "Vehicle With Plate - " .. vehicleData["plate"] .. " - " .. dstCheck .. " Meters Away",
                            ["vehicleData"] = vehicleData,
                            ["vehicleEntity"] = vehicle
                        })
                    end
                end
            end
        end

        if #menuElements == 0 then
            table.insert(menuElements, {
                ["label"] = "No Vehicles To Control"
            })
        end
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_vehicle_menu", {
            ["title"] = "Current vehicles.",
            ["align"] = 'bottom-right',
			css      = 'garage',
            ["elements"] = menuElements
        }, function(menuData, menuHandle)
            local currentVehicle = menuData["current"]["vehicleEntity"]

            if currentVehicle then
                ChooseVehicleAction(currentVehicle, function(actionChosen)
                    VehicleAction(currentVehicle, actionChosen)
                end)
            end
        end, function(menuData, menuHandle)
            menuHandle.close()
        end, function(menuData, menuHandle)
            local currentVehicle = menuData["current"]["vehicle"]

            if currentVehicle then
                SpawnLocalVehicle(currentVehicle["props"])
            end
        end)
    end)
end

ChooseVehicleAction = function(vehicleEntity, callback)
    if not cachedData["blips"] then cachedData["blips"] = {} end

    local menuElements = {
        {
            ["label"] = "Turn " .. (GetIsVehicleEngineRunning(vehicleEntity) and "off" or "on") .. " Engine",
            ["action"] = "change_engine_state"
        },
		{
            ["label"] = "Turn " .. (IsVehicleAlarmActivated(vehicleEntity) and "off" or "on") .. " Alarm",
            ["action"] = "change_alarm_state"
        },
        {
            ["label"] = "Turn " .. (DoesBlipExist(cachedData["blips"][vehicleEntity]) and "off" or "on") .. " GPS",
            ["action"] = "change_gps_state"
        },
        {
            ["label"] = "Door Control",
            ["action"] = "change_door_state"
        },
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "second_vehicle_menu", {
        ["title"] = "Choose an action for - " .. GetVehicleNumberPlateText(vehicleEntity),
        ["align"] = 'bottom-right',
		css      = 'garage',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]

        if currentAction then
            menuHandle.close()

            callback(currentAction)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end



VehicleAction = function(vehicleEntity, action)
    local dstCheck = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicleEntity))

    while not NetworkHasControlOfEntity(vehicleEntity) do
        Citizen.Wait(0)
    
        NetworkRequestControlOfEntity(vehicleEntity)
    end

   if action == "change_door_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Remote Can Not Work From This Far Away") end

        ChooseDoor(vehicleEntity, function(doorChosen)
            if doorChosen then
                if GetVehicleDoorAngleRatio(vehicleEntity, doorChosen) == 0 then
                    SetVehicleDoorOpen(vehicleEntity, doorChosen, false, false)
                else
                    SetVehicleDoorShut(vehicleEntity, doorChosen, false, false)
                end
            end
        end)
		
	elseif action == "change_engine_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Remote Can Not Work From This Far Away") end

        if GetIsVehicleEngineRunning(vehicleEntity) then
            SetVehicleEngineOn(vehicleEntity, false, false)

            cachedData["engineState"] = true

            Citizen.CreateThread(function()
                while cachedData["engineState"] do
                    Citizen.Wait(5)

                    SetVehicleUndriveable(vehicleEntity, true)
                end

                SetVehicleUndriveable(vehicleEntity, false)
            end)
        else
            cachedData["engineState"] = false

            SetVehicleEngineOn(vehicleEntity, true, true)
        end	
		
    elseif action == "change_alarm_state" then
        if dstCheck >= Config.RangeCheck then return ESX.ShowNotification("Remote Can Not Work From This Far Away") end

        if IsVehicleAlarmActivated(vehicleEntity) then
            SetVehicleAlarm(vehicleEntity, false)

            cachedData["alarmState"] = true
        else
            cachedData["alarmState"] = false

            SetVehicleAlarm(vehicleEntity, true)
		    StartVehicleAlarm(vehicleEntity)
        end
		
    elseif action == "change_gps_state" then
        if DoesBlipExist(cachedData["blips"][vehicleEntity]) then
            RemoveBlip(cachedData["blips"][vehicleEntity])
        else
            cachedData["blips"][vehicleEntity] = AddBlipForEntity(vehicleEntity)
    
            SetBlipSprite(cachedData["blips"][vehicleEntity], GetVehicleClass(vehicleEntity) == 8 and 226 or 225)
            SetBlipScale(cachedData["blips"][vehicleEntity], 1.05)
            SetBlipColour(cachedData["blips"][vehicleEntity], 30)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Personal vehicle - " .. GetVehicleNumberPlateText(vehicleEntity))
            EndTextCommandSetBlipName(cachedData["blips"][vehicleEntity])
        end
    end
end

ChooseDoor = function(vehicleEntity, callback)
    local menuElements = {
        {
            ["label"] = "Front Left",
            ["door"] = 0
        },
        {
            ["label"] = "Front Right",
            ["door"] = 1
        },
        {
            ["label"] = "Back Left",
            ["door"] = 2
        },
        {
            ["label"] = "Back Right",
            ["door"] = 3
        },
        {
            ["label"] = "Hood",
            ["door"] = 4
        },
        {
            ["label"] = "Trunk",
            ["door"] = 5
        }
    }

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "door_vehicle_menu", {
        ["title"] = "Choose a door",
        ["align"] = 'bottom-right',
		css      = 'garage',
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentDoor = menuData["current"]["door"]

        if currentDoor then
            callback(currentDoor)
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end
--Fonction Menu
