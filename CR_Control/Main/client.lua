
--Mixture of functions to control world
Citizen.CreateThread(function()
    while true do				
      Citizen.Wait(1)
	
	    local pos = GetEntityCoords(PlayerPedId()) 	
					
    	SetVehicleDensityMultiplierThisFrame(0.4)
		SetRandomVehicleDensityMultiplierThisFrame(0.4)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.4)		
		SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0)
		
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 900.0, pos['y'] - 900.0, pos['z'] - 900.0, pos['x'] + 900.0, pos['y'] + 900.0, pos['z'] + 900.0);
				
		SetGarbageTrucks(0)
		SetRandomBoats(0)    

        SetCreateRandomCops(false)                 -- disable random cops walking/driving around
        SetCreateRandomCopsNotOnScenarios(false)   -- stop random cops (not in a scenario) from spawning
        SetCreateRandomCopsOnScenarios(false)      -- stop random cops (in a scenario) from spawning		
				 	 
	    DisablePlayerVehicleRewards(PlayerPedId()) --Disable Vehicle Rewards
		
		DistantCopCarSirens(false)--Stop Ambiant Cop Sirens in Distance
	   	   
	    --Hide Some On Screen Shit
	    HideHudComponentThisFrame(3)
	    HideHudComponentThisFrame(4)
	    HideHudComponentThisFrame(6)
	    HideHudComponentThisFrame(7)
	    HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        DisplayAmmoThisFrame(false)	   
		SetRadarBigmapEnabled(false, false)

        --Remove Pickups
        RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
        RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun	   
    end
end)


--Disable all dispatches, such as medics arriving to death scenes
Citizen.CreateThread(function()
    for dispatchService = 1, 15 do
        EnableDispatchService(dispatchService, false)
        Citizen.Wait(1)
    end
end)

--Disable vehicle rewards
Citizen.CreateThread(function()
	while true do Citizen.Wait(100)
		if IsPedInAnyPoliceVehicle(GetPlayerPed(-1), -1) or IsPedInAnyHeli(GetPlayerPed(-1)) then
			DisablePlayerVehicleRewards(GetPlayerPed(-1))
		end
	end
end)

