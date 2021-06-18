ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

local isRepairing = false

RegisterNetEvent('CR_RepairKit:UseRepairKit')
AddEventHandler('CR_RepairKit:UseRepairKit', function()
    if (not IsPedInAnyVehicle(PlayerPedId(), true) and not isRepairing) then
        local ped = PlayerPedId()
	    local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local veh = ObjectInFront(ped, coords)

        local dict
        local model = 'prop_carjack'
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
        local heading = GetEntityHeading(ped)
        local vehicle   = ESX.Game.GetVehicleInDirection()
        if vehicle == 0 or vehicle == nil then
            vehicle, vehicledist = ESX.Game.GetClosestVehicle()
            if vehicledist > 2.5 then
                vehicle = nil
                vehicledist = nil
            end
        end
        if not (vehicle == 0 or vehicle == nil) then
            if GetVehicleEngineHealth(vehicle) < 301 then
                FreezeEntityPosition(veh, true)
            local vehpos = GetEntityCoords(veh)
            dict = 'mp_car_bomb'
            RequestAnimDict(dict)
            RequestModel(model)
            while not HasAnimDictLoaded(dict) or not HasModelLoaded(model) do
                Citizen.Wait(1)
            end
            isRepairing = true
            local vehjack = CreateObject(GetHashKey(model), vehpos.x, vehpos.y, vehpos.z - 0.5, true, true, true)
            exports['progressBars']:startUI(9250, "Setting up vehicle jack")
            AttachEntityToEntity(vehjack, veh, 0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
            Citizen.Wait(1250)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            dict = 'move_crawl'
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.5, true, true, true)
            SetEntityCollision(veh, false, false)
            TaskPedSlideToCoord(ped, offset, heading, 1000)
            Citizen.Wait(1000)
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            exports['progressBars']:startUI(11000, "Repairing the vehicle")
            TaskPlayAnimAdvanced(ped, dict, 'onback_bwd', coords, 0.0, 0.0, heading - 180, 1.0, 0.5, 3000, 1, 0.0, 1, 1)
            dict = 'amb@world_human_vehicle_mechanic@male@base'
            Citizen.Wait(3000)
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(1)
            end
            TaskPlayAnim(ped, dict, 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)
            dict = 'move_crawl'
            Citizen.Wait(5000)
            local coords2 = GetEntityCoords(ped)
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(1)
            end
            TaskPlayAnimAdvanced(ped, dict, 'onback_fwd', coords2, 0.0, 0.0, heading - 180, 1.0, 0.5, 2000, 1, 0.0, 1, 1)
            Citizen.Wait(3000)
            dict = 'mp_car_bomb'
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(1)
            end            
            ClearPedTasksImmediately(playerPed)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1250, 1, 0.0, 1, 1)
            Citizen.Wait(1250)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.4, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.3, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.2, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.15, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.1, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.05, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.025, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            dict = 'move_crawl'
            Citizen.Wait(1000)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + 0.01, true, true, true)
            TaskPlayAnimAdvanced(ped, dict, 'car_bomb_mechanic', coords, 0.0, 0.0, heading, 1.0, 0.5, 1000, 1, 0.25, 1, 1)
            SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z, true, true, true)
            FreezeEntityPosition(veh, false)
            SetModelAsNoLongerNeeded(vehjack)
            DeleteObject(vehjack)
            SetEntityCollision(veh, true, true)
            -- To prevent people from initiating the repair, and giving the kit away to avoid the kit being used.
            ESX.TriggerServerCallback('CR_RepairKit:HasItem', function(hasItem)
                if hasItem then
                    SetVehicleEngineHealth(vehicle, 315.0)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    SetVehicleEngineOn(vehicle, true, true)
                    SetVehicleTyreFixed(vehicle, 0)
                    SetVehicleTyreFixed(vehicle, 1)
                    SetVehicleTyreFixed(vehicle, 2)
                    SetVehicleTyreFixed(vehicle, 3)
                    SetVehicleTyreFixed(vehicle, 4)
                    SetVehicleTyreFixed(vehicle, 5)
                    if GetVehicleClass(vehicle) == 8 then
                        SetVehicleFixed(vehicle)
                        Citizen.Wait(200)
                        SetVehicleEngineHealth(vehicle, 315.0)
                    end
                    TriggerServerEvent('CR_RepairKit:RemoveKit', 'fixkit')
                else
                    exports['mythic_notify']:DoLongHudText('error', 'You don\'t have the neccessary tools..')
                end
            end, 'fixkit', 1)
            else
                exports['mythic_notify']:DoLongHudText('error', 'Vehicle is not damaged enough to repair')
            end
        else
            exports['mythic_notify']:DoLongHudText('error', 'No vehicle to repair')
        end
        isRepairing = false
    end
end)

function ObjectInFront(ped, pos)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.0)
	local car = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 30, ped, 0)
	local _, _, _, _, result = GetRaycastResult(car)
	return result
end