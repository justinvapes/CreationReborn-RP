-----Created By GigaBytes For AustralisGamingNetwork-----

ESX           = nil
cachedPlates  = {}

Citizen.CreateThread(function()
    while ESX == nil do
	 TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	 Citizen.Wait(0)
  end
end)

RegisterNetEvent('CR_FakePlates:AddDodgyPlate')
AddEventHandler('CR_FakePlates:AddDodgyPlate', function()   
 
    local vehicle = ESX.Game.GetVehicleInDirection()
    local plateNumber   = GetVehicleNumberPlateText(vehicle)
	
	if not (IsPedSittingInAnyVehicle(PlayerPedId())) then 	
	 if (DoesEntityExist(vehicle)) then
	   if cachedPlates[OriginalPlate] == nil then 
	 
        ESX.TriggerServerCallback('CR_FakePlates:Owner', function (isOwner)	 
	    if isOwner then
  
        TriggerServerEvent('CR_FakePlates:Items')  
        exports['progressBars']:startUI(10000, "Changing Plate")
		TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)		  
	    DoingAnima = true
		  
		Citizen.Wait(10000)
		  
	    DoingAnima = false		
        ClearPedTasksImmediately(PlayerPedId())
		  
        CarModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))					
	    OriginalPlate = GetVehicleNumberPlateText(vehicle, false)
		cachedPlates[OriginalPlate] = true  
		
		NewPlate = math.random(1000, 9999) ..math.random(1000, 9999)

		TriggerServerEvent('CR_FakePlates:SetPlate', "NewPlate", vehicle, NewPlate) 
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Dodgy Plates Have Been Fitted", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    else 
		exports['mythic_notify']:DoHudText('error', 'You Do Not Own This Vehicle!')
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Dodgy Plates Have Been Fitted", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
     end
   end, plateNumber)   
    else
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] You Already Have A Plate Changed On One Of Your Vehicles", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
     end   
    else
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] No Vehicle Found", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
     end
  else
      local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] You Can't Be In A Vehicle When Using This", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
   end
end)

RegisterNetEvent('CR_FakePlates:AddOrigPlate')
AddEventHandler('CR_FakePlates:AddOrigPlate', function()

    local vehicle = ESX.Game.GetVehicleInDirection()

    if (DoesEntityExist(vehicle)) then 
        model_name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	
	  if CarModel == model_name then	

        TriggerServerEvent('CR_FakePlates:RemoveOrigPlate')  
        exports['progressBars']:startUI(10000, "Changing Plate")
	    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
	    DoingAnima = true
	   
	    Citizen.Wait(10000)
	   
	    DoingAnima = false
	    ClearPedTasksImmediately(PlayerPedId())
		TriggerServerEvent('CR_FakePlates:SetPlate', "Original", vehicle, OriginalPlate)  
		cachedPlates[OriginalPlate] = nil  
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Original Plates Have Been Fitted", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
    else
        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] This Is Not The Original Vehicle For This Plate", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
     end	 
    else
       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] No Vehicle Found", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
    end
end)

RegisterNetEvent('CR_FakePlates:ChangeThePlate')
AddEventHandler('CR_FakePlates:ChangeThePlate', function(PlateType, vehicle, Plate)

   if PlateType == 'Original' then
      SetVehicleNumberPlateText(vehicle, Plate)
	  
  elseif PlateType == 'NewPlate' then
	  SetVehicleNumberPlateText(vehicle, Plate)
   end
end)

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(0)
	
    if DoingAnima then
       DisableControlAction(0, 37,  true) -- TAB
       DisableControlAction(0, 243, true) -- ~/Phone	 
       DisableControlAction(0, 288, true) -- F1
       DisableControlAction(0, 289, true) -- F2
       DisableControlAction(0, 170, true) -- F3
       DisableControlAction(0, 166, true) -- F5	
       DisableControlAction(0, 167, true) -- F6	  	  	  
       DisableControlAction(0, 168, true) -- F7	  
       DisableControlAction(0, 169, true) -- F8
       DisableControlAction(0, 56, true)  -- F9
       DisableControlAction(0, 57, true)  -- F10	
   else
	   Citizen.Wait(1000)
    end
  end
end)