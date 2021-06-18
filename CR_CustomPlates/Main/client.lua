ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
	
		local sleep = 1000
		local playerPos = GetEntityCoords(PlayerPedId())	

		for i = 1, #Config.Locations do
		
			local CustomPlates = vector3(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
		    local distance = #(playerPos - CustomPlates)
			
			if distance < 10.0 then
			   if IsPedSittingInAnyVehicle(PlayerPedId()) then
			      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				  			  
			      if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                     sleep = 5				  
			         DrawM('[~b~Press ~w~[~g~E~w~] To Change Your ~b~Plate~w~]', 27, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)	
						
			        if distance < 1.0 then
			           sleep = 5 
			      			  					  					  			  				   		    					   
				        if IsControlJustReleased(0, 38) then
						
						   local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)	
						   
						   ESX.TriggerServerCallback('CR_CustomPlates:CheckOwner', function(OwnedVehicle)
		                   if OwnedVehicle then	
						   
                           local oldplate = GetVehicleNumberPlateText(vehicle)	
						
					       ESX.TriggerServerCallback('CR_CustomPlates:CanPay', function(HasMoney, Money) 
						   if HasMoney then
						   
						   if Money >= 5 then
						   
						    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_plate_string_input', 
                             {
                               title = 'Enter Your New Plater'
                             },
                            function(data, menu)
																																			
                            local newPlate = string.upper(data.value)
										 
						    if string.match(newPlate, '%p') then
                               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! You Can't Use Special Characters", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   
						   else			
							
                                if newPlate ~= nil and #newPlate == 8 then
									 
							        ESX.TriggerServerCallback('CR_CustomPlates:isPlateTaken', function (isPlateTaken)									 
									if not isPlateTaken then
								   												 									 								 								   									   
                                       TriggerServerEvent('CR_CustomPlates:UpdatePlate', oldplate, newPlate)
                                       SetVehicleNumberPlateText(vehicle, newPlate)									   
									   TriggerServerEvent('CR_CustomPlates:UpdatePurchased')
									   ESX.UI.Menu.CloseAll()
                                   else 
                                       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! This Plate Is Already Being Used", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   									   
								    end
                                  end, newPlate)
                              else 
                                  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! Plate Must Be 8 Letters/Numbers/Spaces", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)								  
                               end
						     end
                           end,
                         function(data, menu)
						    menu.close()
                         end
                          )						  
				      else
                          local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Custom Plate Changes Are ~g~$5 ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						  
			           end
				    else
                        local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Custom Plate Changes Are ~g~$5 ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						
                     end					   
			       end, vehicleProps)
				  else
                      local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] You Don't Own This Vehicle", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)					  
				   end
                 end,vehicleProps)
		       end      		
             end
	       end
	     end
	   end 
     end
	Citizen.Wait(sleep)
  end
end)

Citizen.CreateThread(function()
	while true do
	
		local sleep = 1000		
		local playerPos = GetEntityCoords(PlayerPedId())	
		  
		  for i = 1, #Config.Locations do

			local CustomPlatesMaker = vector3(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
		    local distance = #(playerPos - CustomPlatesMaker)
		  	  
		    if distance < 20.0 then
			   sleep = 5
			   DrawMarker(27, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z - 0.88, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.501, 3.501, 0.5001, 255, 0, 0, 100, false, true, 2, false, false, false, false)
			end
        end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Config.Locations do
		local blip = AddBlipForCoord(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
		SetBlipAsShortRange(blip, true)
		SetBlipSprite(blip, 89) 
		SetBlipColour(blip, 2) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("CR Plate Changes")
		EndTextCommandSetBlipName(blip)
	end
end)

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 1.5)
end