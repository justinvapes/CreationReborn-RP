ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- RegisterCommand("testcommand", function(source, args)
-- 	ESX.TriggerServerCallback('CR_CustomNumbers:CanPay', function(HasMoney, Money) 
-- 		if HasMoney then						   
-- 			if Money >= 5 then
-- 				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_plate_string_input', 
-- 				{
-- 				title = 'Enter Your New Number'
-- 				},
-- 				function(data, menu)																				
-- 					local newNumber = string.upper(data.value)										 
-- 					if string.match(newNumber, '%p') or string.match(newNumber, '%a') or string.match(newNumber, '%c') or string.match(newNumber, '%l') or string.match(newNumber, '%p') or string.match(newNumber, '%s') then
-- 						local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! You Can't Use Non Number Characters", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   
-- 					else
-- 						if newNumber ~= nil and #newNumber == 7 then
-- 							num1 = string.sub(newNumber, 1, 3)
-- 							num2 = string.sub(newNumber, 4, 7)
-- 							newNumber = num1 .. '-' .. num2
-- 							ESX.TriggerServerCallback('CR_CustomNumbers:isTaken', function (isTaken)									 
-- 								if not isTaken then
-- 									-- make newNumber
-- 									-- TriggerServerEvent('gcPhone:changeNumber', newNumber)
-- 									-- TriggerServerEvent('CR_CustomPlates:UpdatePurchased')
-- 									-- print(newNumber)
-- 									-- Change Number
-- 									ESX.UI.Menu.CloseAll()
-- 								else 
-- 									local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! This Number Is Already Being Used", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   									   
-- 								end
-- 							end, newNumber)
-- 						else 
-- 							local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! Number Must Be 7 Numbers", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)								  
-- 						end
-- 					end
-- 				end,
-- 				function(data, menu)
-- 					menu.close()
-- 				end)				  
-- 			else
-- 				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Number Changes Are ~g~5 Credits ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						  
-- 			end
-- 		else
-- 			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Number Changes Are ~g~5 Credits ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						
-- 		end					   
-- 	end)
-- end, false)

Citizen.CreateThread(function()
	while true do	
		while ESX == nil do
			Citizen.Wait(50)
		end
		local sleep = 1000
		local playerPos = GetEntityCoords(PlayerPedId())	
		for i = 1, #Config.Locations do		
			local CustomNumbers = vector3(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
		    local distance = #(playerPos - CustomNumbers)			
			if distance < 10.0 then
				if distance < 1.0 then
					sleep = 5			
					ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to change your phone number', true, true, -1)      			  					  					  			  				   		    					   
					if IsControlJustReleased(0, 38) then				
						ESX.TriggerServerCallback('CR_CustomNumbers:CanPay', function(HasMoney, Money) 
							if HasMoney then						   
								if Money >= 5 then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_number_string_input', 
									{
									title = 'Enter Your New Number'
									},
									function(data, menu)																				
										local newNumber = string.upper(data.value)										 
										if string.match(newNumber, '%p') or string.match(newNumber, '%a') or string.match(newNumber, '%c') or string.match(newNumber, '%l') or string.match(newNumber, '%p') or string.match(newNumber, '%s') then
											local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! You Can't Use Non Number Characters", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   
										else
											if newNumber ~= nil and #newNumber == 7 then
												num1 = string.sub(newNumber, 1, 3)
												num2 = string.sub(newNumber, 4, 7)
												newNumber = num1 .. '-' .. num2
												ESX.TriggerServerCallback('CR_CustomNumbers:isTaken', function (isTaken)									 
													if not isTaken then
														-- make newNumber
														TriggerServerEvent('gcPhone:changeNumber', newNumber)
														TriggerServerEvent('CR_CustomPlates:UpdatePurchased')
														-- print(newNumber)
														-- Change Number
														ESX.UI.Menu.CloseAll()
													else 
														local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! This Number Is Already Being Used", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							   									   
													end
												end, newNumber)
											else 
												local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~NUMBER ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Sorry! Number Must Be 7 Numbers", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)								  
											end
										end
									end,
									function(data, menu)
										menu.close()
									end)				  
								else
									local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Number Changes Are ~g~5 Credits ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						  
								end
							else
								local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLATE ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Number Changes Are ~g~5 Credits ~w~Visit ~b~[~b~www.creationreborn.net~w~]", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)						
							end					   
						end)
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
			local CustomNumberMaker = vector3(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
		    local distance = #(playerPos - CustomNumberMaker)		  	  
		    if distance < 20.0 then
			   sleep = 5
			   DrawMarker(21, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.500, 0.500, 0.500, 255, 0, 0, 200, false, true, 2, true, false, false, false)
			--    DrawMarker(27, Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z - 0.88, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1, 1, 0.5001, 255, 0, 0, 100, false, true, 2, false, false, false, false)
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
		SetBlipColour(blip, 11) 
		SetBlipScale(blip, 0.5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("CR Number Changes")
		EndTextCommandSetBlipName(blip)
	end
end)