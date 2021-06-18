ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.IsPlayerLoaded() do 
		Citizen.Wait(500)
	 end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

local isHide = false
local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,14,17,18,19,20};
local KMWait = 3000
local FuelWait = 2000


Citizen.CreateThread(function()
	while true do
		Wait(41)
		playerPed = GetPlayerPed(-1)
		
		if playerPed and not isHide then
			
			playerCar = GetVehiclePedIsIn(playerPed, false)	
			local vehicleClass = GetVehicleClass(playerCar)
			
			if playerCar and (GetPedInVehicleSeat(playerCar, -1) == playerPed) and (has_value(vehiclesCars, vehicleClass)) then	
				carRPM                    = GetVehicleCurrentRpm(playerCar)
				carSpeed                  = GetEntitySpeed(playerCar)
				carGear                   = GetVehicleCurrentGear(playerCar)
				carHandbrake              = GetVehicleHandbrake(playerCar)
				carBrakePressure          = GetVehicleWheelBrakePressure(playerCar, 0)
				carLS_r, carLS_o, carLS_h = GetVehicleLightsState(playerCar)
				carRunning                = GetIsVehicleEngineRunning(playerCar)
				
				SendNUIMessage({
					ShowHud             = true,
					CurrentCarRPM       = carRPM,
					CurrentCarGear      = carGear,
					CurrentCarSpeed     = carSpeed,
					CurrentCarKmh       = math.ceil(carSpeed * 3.6),
					CurrentCarHandbrake = carHandbrake,
					CurrentCarBrake     = carBrakePressure,
					CurrentCarLS_r      = carLS_r,
					CurrentCarLS_o      = carLS_o,
					CurrentCarLS_h      = carLS_h,
					CurrentCarFuel      = carFuel,
					CurrentCarTraction  = carTraction,
					CurrentCarKM        = KM,
					CurrentCarEngine    = carRunning,
					PlayerID            = GetPlayerServerId(GetPlayerIndex())
				})
				
			else
				SendNUIMessage({HideHud = true})
				Wait(500)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(FuelWait)
		local veh = GetVehiclePedIsIn(PlayerPedId())
		if veh ~= 0 then
			carFuel                   = exports["LegacyFuel"]:GetFuel(playerCar)
			carTraction               = exports["vehicleoptions"]:isTCon()
			FuelWait = 500
		else
			FuelWait = 2000
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(KMWait)
		GetKM()
	end
end)

RegisterCommand('togglegauges', function()
	if isHide then
		isHide = false
	else
		SendNUIMessage({HideHud = true})
		isHide = true
	end
end)

function GetKM()
	local veh = GetVehiclePedIsIn(PlayerPedId(),false)
	if veh ~= 0 then
		-- KM = exports["CR_VehKm"]:ShowKs()
		KM = nil
		KMWait = 500
	else
		KM = nil
		KMWait = 3000
	end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
