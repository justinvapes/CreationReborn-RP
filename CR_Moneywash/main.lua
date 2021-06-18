-----Created By GigaBytes For AustralisGamingNetwork-----

ESX               = nil
local menuOpen    = false
local wasOpen     = false
local notify      = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
 while true do
	Citizen.Wait(5)
	
	local coords = GetEntityCoords(PlayerPedId())

	if GetDistanceBetweenCoords(coords, Config.CircleZones.MoneyWash.coords, true) < 0.5 then
		if not menuOpen then
			
		if notify == 0 then
		   ESX.ShowHelpNotification(_U('Money_Wash'))
		end

			if IsControlJustReleased(0, 38) then
			   wasOpen = true
			   OpenMoneyWash()
			   notify = 1
			end
		else
			   Citizen.Wait(100)
			end
		else
			if wasOpen then
			   wasOpen = false
			   ESX.UI.Menu.CloseAll()
			end
			Citizen.Wait(100)
		end
	end
end)

function OpenMoneyWash()
			
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_', {
	title = _U('wash_money_amount')
	}, function(data, menu)
				
	local amount = tonumber(data.value)
					
    if amount == nil then
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~DOCTOR ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] You Entered An Invalid Amount", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
   else
	   menu.close()
	   TriggerServerEvent('CR_Moneywash:WashMoney', amount)
	   notify = 0
	end
   end, function(data, menu)
		menu.close()
        menuOpen = false	
        notify = 0		  
	end)
end

Citizen.CreateThread(function()
 while true do
	Citizen.Wait(7)
	
	local coords = GetEntityCoords(PlayerPedId())
			
	if (GetDistanceBetweenCoords(coords, 1122.34, -3194.41, -40.40, true) < 2.5) then
	    DrawMarker(27, 1122.35, -3194.69, -41.37, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
	 end
   end
end)