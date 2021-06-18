ESX = nil
local wasOpen = false
local CurrentActionMsg = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		
		local sleep = 1000		
		
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)	
		
		for i = 1, #Config.Weedshop do
			
			local PawnMarker = vector3(Config.Weedshop[i].x, Config.Weedshop[i].y, Config.Weedshop[i].z)
			local dist = #(plyCoords - PawnMarker)
			
			if dist < 3.0 then	
				sleep = 5		
				DrawMarker(21, Config.Weedshop[i].x, Config.Weedshop[i].y, Config.Weedshop[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
				
				if dist < 0.5  and wasOpen == false then
				   ESX.ShowHelpNotification("~b~Press ~INPUT_CONTEXT~ ~s~To Sell Your ~y~Cannabis")
					
					if IsControlJustReleased(0, 38) then	       
						sleep = 5	
						wasOpen = true
						OpenWeedShop()
					end
				end
			else
				if wasOpen then
					wasOpen = false
					ESX.UI.Menu.CloseAll()
				end
			end
		end
		Citizen.Wait(sleep)	
	end
end)

function OpenWeedShop()

	ESX.UI.Menu.CloseAll()
	local elements = {}
	
	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.WeedShopItems[v.name]
		
		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,
				
				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'bottom-right',
		css      = 'superete',
		elements = elements
	}, function(data, menu)	
		TriggerServerEvent('AGN:WeedShop', data.current.name, data.current.value)
		ESX.UI.Menu.CloseAll()
		Citizen.Wait(250)
		OpenWeedShop()
		
	end, function(data, menu)
		menu.close()
		wasOpen = false
	end)
end






-- Citizen.CreateThread(function()
	
-- 	RequestModel(GetHashKey("ig_jay_norris"))
-- 	while not HasModelLoaded(GetHashKey("ig_jay_norris")) do
-- 		Wait(1)
-- 	end
	
-- 	local WeedShopPed = CreatePed(4, 0x7A32EE74, 378.80, -826.79, 28.30, 177.54, false, true)
-- 	SetEntityHeading(WeedShopPed, 177.54)
-- 	FreezeEntityPosition(WeedShopPed, true)
-- 	SetEntityInvincible(WeedShopPed, true)
-- 	SetBlockingOfNonTemporaryEvents(WeedShopPed)
-- 	SetModelAsNoLongerNeeded(WeedShopPed)
-- end)

-- Citizen.CreateThread(function()
	
-- 	RequestModel(GetHashKey("ig_kerrymcintosh"))
-- 	while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
-- 		Wait(1)
-- 	end
	
-- 	local WeedShopPed2 = CreatePed(4, 0x5B3BD90D, 374.92, -828.96, 28.30, 278.68, false, true)
-- 	SetEntityHeading(WeedShopPed2, 278.68)
-- 	FreezeEntityPosition(WeedShopPed2, true)
-- 	SetEntityInvincible(WeedShopPed2, true)
-- 	SetBlockingOfNonTemporaryEvents(WeedShopPed2, true)
-- 	SetModelAsNoLongerNeeded(WeedShopPed2)
-- end)