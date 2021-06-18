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
		
		for i = 1, #Config.Pawnshop do
			
			local PawnMarker = vector3(Config.Pawnshop[i].x, Config.Pawnshop[i].y, Config.Pawnshop[i].z)
			local dist = #(plyCoords - PawnMarker)
			
			if dist < 3.0 then	
			   sleep = 5		
			   DrawMarker(21, Config.Pawnshop[i].x, Config.Pawnshop[i].y, Config.Pawnshop[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
				
				if dist < 0.5  and wasOpen == false then
				   ESX.ShowHelpNotification("~b~Press ~INPUT_CONTEXT~ ~s~To Sell Your ~y~Items")
					
					if IsControlJustReleased(0, 38) then	       
					   sleep = 5	
					   wasOpen = true
					   OpenPawnShop()
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

-- function OpenPawnShop()
-- 	ESX.UI.Menu.CloseAll()
-- 	local elements = {}

-- 	for k, v in pairs(ESX.GetPlayerData().inventory) do
-- 		local price = Config.PawnShopItems[v.name]

-- 		if price and v.count > 0 then
-- 			table.insert(elements, {
-- 				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
-- 				name = v.name,
-- 				price = price,

-- 				type = 'slider',
-- 				value = 1,
-- 				min = 1,
-- 				max = v.count
-- 			})
-- 		end
-- 	end

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
-- 		title    = _U('dealer_title'),
-- 		align    = 'bottom-right',
-- 		css      = 'superete',
-- 		elements = elements
-- 	}, function(data, menu)	
	
-- 	   TriggerServerEvent('AGN:PawnShop', data.current.name, data.current.value)
--    end, function(data, menu)
-- 		menu.close()
-- 		wasOpen = false
-- 	end)
-- end

function OpenPawnShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.PawnShopItems[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
                price = price,
                iType = 'Item',
                iName = v.name,

				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	for k, v in pairs(ESX.GetPlayerData().loadout) do
        local price = Config.PawnShopItems[v.name]

        if price then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.label,
                price = price,
                iType = 'Weapon',
                iName = v.name,

				type = 'slider',
				value = 1,
				min = 1,
				max = 1
            })
        end
    end
    
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = 'Shop',
		align    = 'bottom-right',
		css      = 'superete',
		elements = elements
	}, function(data, menu)	
	
	   TriggerServerEvent('AGN:PawnShop', data.current.name, data.current.value, data.current.iType, data.current.iName)
   end, function(data, menu)
		menu.close()
		wasOpen = false
	end)
end

Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_jay_norris"))
	
    while not HasModelLoaded(GetHashKey("ig_jay_norris")) do
      Wait(1)
    end
	
    local PawnShopPed = CreatePed(4, 0x7A32EE74, 245.06, -266.06, 53.04, 337.33, false, true)
    SetEntityHeading(PawnShopPed, 337.33)
    FreezeEntityPosition(PawnShopPed, true)
    SetEntityInvincible(PawnShopPed, true)
    SetBlockingOfNonTemporaryEvents(PawnShopPed, true)
	SetModelAsNoLongerNeeded(PawnShopPed)
end)

Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_kerrymcintosh"))
    while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
      Wait(1)
    end
	
    local PawnShopPed2 = CreatePed(4, 0x5B3BD90D, 247.27, -269.34, 53.04, 247.66, false, true)
    SetEntityHeading(PawnShopPed2, 247.66)
    FreezeEntityPosition(PawnShopPed2, true)
    SetEntityInvincible(PawnShopPed2, true)
    SetBlockingOfNonTemporaryEvents(PawnShopPed2, true)
	SetModelAsNoLongerNeeded(PawnShopPed2)
end)
