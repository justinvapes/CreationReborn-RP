ESX = nil
GLOBAL_PED, GLOBAL_COORDS = nil, nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("b1g_fishing:StartFish")
AddEventHandler("b1g_fishing:StartFish", function()
	InitFishing(false)
end)

Citizen.CreateThread(function()
	while true do
		GLOBAL_PED = PlayerPedId()
		GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED, true)
		Citizen.Wait(1500)
	end
end)

Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end)-- Prevents RAM LEAKS :)