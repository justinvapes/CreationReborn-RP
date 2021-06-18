ESX = nil
local GUI = {}
local PlayerData = {}
local vehiclePlate = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
    end
	
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end   
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
end)

AddEventHandler('onResourceStart', function(resourceName)

  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  
    TriggerServerEvent("esx_trunk_inventory:getOwnedVehicule")
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

RegisterNetEvent("esx_trunk_inventory:setOwnedVehicule")
AddEventHandler("esx_trunk_inventory:setOwnedVehicule", function(vehicle)
    vehiclePlate = vehicle
end)

-- Key controls
-- Citizen.CreateThread(function()
--     while true do
--       Citizen.Wait(0)
	  
--         local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))   
--         local vehicle = GetClosestVehicle(x, y, z, 3.0, 0, 71)
-- 	    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
-- 	    local locked = GetVehicleDoorLockStatus(vehicle)
-- 	    local class = GetVehicleClass(vehicle)
		
-- 		if IsAnyVehicleNearPoint(x, y, z, 3.0) then	
	  
--         if IsControlJustReleased(0, Config.OpenKey) then
-- 				if not IsPedInAnyVehicle(PlayerPedId()) then

-- 					if class ~= 15 or class ~= 16 or class ~= 14 then
-- 					OpenTrunkInventory()				  
-- 					else
-- 					ESX.ShowNotification("The Trunk Is Locked 1")
-- 					end
-- 				else
-- 					ESX.ShowNotification("You Can't Do This In A Vehicle")
-- 				end
--             end
-- 		else
-- 			Citizen.Wait(1500)
-- 		end
--     end
-- end)

-- Key controls
RegisterKeyMapping('opentrunk', 'Open Trunk', 'keyboard', 'G')
RegisterCommand('opentrunk', function()
	  
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))   
	local vehicle = GetClosestVehicle(x, y, z, 3.0, 0, 71)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	local locked = GetVehicleDoorLockStatus(vehicle)
	local class = GetVehicleClass(vehicle)
	
	if IsAnyVehicleNearPoint(x, y, z, 3.0) then	
		if not IsPedInAnyVehicle(PlayerPedId()) then

			if class ~= 15 or class ~= 16 or class ~= 14 then
			OpenTrunkInventory()				  
			else
			ESX.ShowNotification("The Trunk Is Locked 1")
			end
		else
			ESX.ShowNotification("You Can't Do This In A Vehicle")
		end
	end
end)


function OpenTrunkInventory()--We open the menu
	
	local playerPed = PlayerPedId()
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))   
	local vehicle = GetClosestVehicle(x, y, z, 3.0, 0, 71)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	local locked = GetVehicleDoorLockStatus(vehicle)
	local class = GetVehicleClass(vehicle)
	
	if ESX.GetPlayerData().job.name == 'police' then
		OpenInventoryMenu(GetVehicleNumberPlateText(vehicle))	
        SetVehicleDoorOpen(vehicle, 5, false, false)		
	else	
		
		ESX.TriggerServerCallback('esx_trunk_inventory:Owner', function(isOwnedVehicle)
			if isOwnedVehicle then
				
				if locked ~= 4 then
					OpenInventoryMenu(GetVehicleNumberPlateText(vehicle))
                    SetVehicleDoorOpen(vehicle, 5, false, false)					
				else	
					ESX.ShowNotification("The Trunk Is Locked")
				end
			else
				ESX.ShowNotification("You ~r~Don't ~w~Own This ~g~Vehicle")
			end		
		end, vehicleProps)
	end
end

function OpenInventoryMenu(plate)
	ESX.TriggerServerCallback("esx_trunk:getInventoryV",function(inventory) 
        Trunkweapons = inventory.weapons  
        text = _U("trunk_info", plate)
        data = {plate = plate, text = text}
        TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.blackMoney, inventory.items, Trunkweapons)
    end, plate)
	
	Citizen.Wait(1000)	 
	Total = #Trunkweapons 
	TriggerEvent('esx_inventoryhud:OpenTotal', Total, plate)
end