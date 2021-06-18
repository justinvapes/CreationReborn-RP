local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPaid                 = false
local PlayerLoaded            = false
local inmenu                  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function OpenShopMenu()
	HasPaid = false
	inmenu  = true
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = _U('valid_this_purchase'),
			align    = 'bottom-right',
			css      = 'superete',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				local blacklisted = false
				TriggerEvent('skinchanger:getSkin', function(skin)
					skinlist = skin
				end)
				print(ESX.PlayerData.job.name)
				if skinlist.sex == 1 then
					for k,v in pairs(skinlist) do
						if k == 'helmet_1' then
							for i=1, #Config.HelmetBL do
								if Config.HelmetBL[i] == v then
									blacklisted = true
									BLitem = 'helmet_1'
								end
							end
						end
						if k == 'torso_1' then
							for i=1, #Config.FTorsoBL do
								if Config.FTorsoBL[i][1] == v then
									if skinlist.torso_2 == Config.FTorsoBL[i][2] then
										blacklisted = true
										BLitem = 'torso_1, torso_2'
									end
								end
							end
						end
					end
				elseif skinlist.sex == 0 then
					for k,v in pairs(skinlist) do
						if k == 'helmet_1' then
							for i=1, #Config.HelmetBL do
								if Config.HelmetBL[i] == v then
									blacklisted = true
									BLitem = 'helmet_1'
								end
							end
						end
						if k == 'torso_1' then
							for i=1, #Config.MTorsoBL do
								if Config.MTorsoBL[i][1] == v then
									if skinlist.torso_2 == Config.MTorsoBL[i][2] then
										blacklisted = true
										BLitem = 'torso_1, torso_2'
									end
								end
							end
						end
						if k == 'chain_1' and ESX.PlayerData.job.name ~= 'offpolice' then
							for i=1, #Config.ChainBL do
								if Config.ChainBL[i] == v then
									blacklisted = true
									BLitem = 'chain_1'
								end
							end
						end
					end
				end
				if not blacklisted then
					ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
						if bought then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							HasPaid = true
							inmenu  = false
							FreezeEntityPosition(PlayerPedId(), false)

							ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
								if foundStore then
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
									{
										title = _U('save_in_dressing'),
										align    = 'bottom-right',
										css      = 'superete',
										elements = {
											{label = _U('no'),  value = 'no'},
											{label = _U('yes'), value = 'yes'}
										}
									}, function(data2, menu2)
										menu2.close()

										if data2.current.value == 'yes' then
											ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
												title = _U('name_outfit')
											}, function(data3, menu3)
												menu3.close()

												TriggerEvent('skinchanger:getSkin', function(skin)
													TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
												end)

												ESX.ShowNotification(_U('saved_outfit'))
											end, function(data3, menu3)
												menu3.close()
											end)
										end
									end)
								end
							end)

						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))
							inmenu  = false
							FreezeEntityPosition(PlayerPedId(), false)
						end
					end)
				else
					ESX.ShowNotification('Wearing a blacklisted item: ' .. BLitem)
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					inmenu  = false
					FreezeEntityPosition(PlayerPedId(), false)
				end
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				   inmenu  = false
				   FreezeEntityPosition(PlayerPedId(), false)
			end

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end)

	end, function(data, menu)
		menu.close()
		inmenu  = false
        FreezeEntityPosition(PlayerPedId(), false)
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
	    'chain_1',
	    'chain_2',
		'helmet_1',
		'helmet_2',
		'glasses_1',
		'glasses_2',
		'mask_1',
        'mask_2',
		'ears_1',
		'ears_2',
		'watches_1',
	    'watches_2',
	    'bracelets_1',
		'bags_1',
		'bags_2'
	})

end

AddEventHandler('esx_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('esx_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Shops, 1 do
		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
		for k,v in pairs(Config.Zones2) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end
		
		for k,v in pairs(Config.Zones2) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_clotheshop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
		
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance 'then
					if CurrentAction == 'shop_menu' then
						OpenShopMenu()
					end
					CurrentAction = nil
				else
					exports['mythic_notify']:DoHudText('error', 'You Can Not Use This While On Duty!')
				end
			elseif IsControlJustReleased(0, Keys['G']) then
				if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance 'then
					  if CurrentAction == 'shop_menu' then
						  OpenChangingMenu()
					  end
					  CurrentAction = nil
				else
					exports['mythic_notify']:DoHudText('error', 'You Can Not Use This While On Duty!')
				end				
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function OpenChangingMenu()	
	ESX.UI.Menu.CloseAll()
	local elements = {}
	table.insert(elements, {label = 'Change Outfit', value = 'change_outfit'})
	table.insert(elements, {label = 'Remove Outfits', value = 'remove_outfits'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Clothing', {
		title = "Clothing Store",
		align = "bottom-right",
		css = "apps",
		elements = elements
	}, function (data, menu)
			if data.current.value == 'change_outfit' then
				menu.close()
				ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
					local elements = {}
			
					for i=1, #dressing, 1 do
						table.insert(elements, {
							label = dressing[i],
							value = i
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
						title    = "Outfits",
						align    = 'bottom-right',
						css      = 'apps',
						elements = elements
					}, function(data2, menu2)
						TriggerEvent('skinchanger:getSkin', function(skin)
							ESX.TriggerServerCallback('esx_clotheshop:getPlayerOutfit', function(clothes)
								TriggerEvent('skinchanger:loadClothes', skin, clothes)
								TriggerEvent('esx_skin:setLastSkin', skin)
			
								TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
								end)
							end, data2.current.value)
						end)
					end, function(data2, menu2)
						CurrentAction = 'shop_menu'
						menu2.close()
					end)
				end)
			elseif data.current.value == 'remove_outfits' then
				menu.close()
				ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
					local elements = {}
			
					for i=1, #dressing, 1 do
						table.insert(elements, {
							label = dressing[i],
							value = i
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
						title    = "Remove Outfit",
						align    = 'bottom-right',
						css      = 'apps',
						elements = elements
					}, function(data2, menu2)
						menu2.close()
						TriggerServerEvent('esx_clotheshop:removeOutfit', data2.current.value)
						ESX.ShowNotification(('You Just Threw Out Those Clothes'))
						CurrentAction = 'shop_menu'
					end, function(data2, menu2)
						CurrentAction = 'shop_menu'
						menu2.close()
					end)
				end)
			end
		end, function(data, menu)
			menu.close()
			CurrentAction = 'shop_menu'
		end)
	-- ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
	-- 	local elements = {}

	-- 	for i=1, #dressing, 1 do
	-- 		table.insert(elements, {
	-- 			label = dressing[i],
	-- 			value = i
	-- 		})
	-- 	end
	-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
	-- 		title    = "Remove Outfit",
	-- 		align    = 'bottom-right',
	-- 		css      = 'apps',
	-- 		elements = elements
	-- 	}, function(data2, menu2)
	-- 		menu2.close()
	-- 		TriggerServerEvent('esx_clotheshop:removeOutfit', data2.current.value)
	-- 		ESX.ShowNotification(('You Just Threw Out Those Clothes'))
	-- 	end, function(data2, menu2)
	-- 		menu2.close()
	-- 	end)
	-- end)


	-- ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
	-- 	local elements = {}

	-- 	for i=1, #dressing, 1 do
	-- 		table.insert(elements, {
	-- 			label = dressing[i],
	-- 			value = i
	-- 		})
	-- 	end
	-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
	-- 		title    = "Outfits",
	-- 		align    = 'bottom-right',
	-- 		css      = 'apps',
	-- 		elements = elements
	-- 	}, function(data, menu)
	-- 		TriggerEvent('skinchanger:getSkin', function(skin)
	-- 			ESX.TriggerServerCallback('esx_clotheshop:getPlayerOutfit', function(clothes)
	-- 				TriggerEvent('skinchanger:loadClothes', skin, clothes)
	-- 				TriggerEvent('esx_skin:setLastSkin', skin)

	-- 				TriggerEvent('skinchanger:getSkin', function(skin)
	-- 					TriggerServerEvent('esx_skin:save', skin)
	-- 				end)
	-- 			end, data.current.value)
	-- 		end)
	-- 	end, function(data, menu)
	-- 		CurrentAction = 'shop_menu'
	-- 		menu.close()
	-- 	end)
	-- end)
end


-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
     if inmenu then
	    FreezeEntityPosition(PlayerPedId(), true)
		DisableControlAction(0, 30,  true) -- MoveLeftRight
        DisableControlAction(0, 31,  true) -- MoveUpDown
		DisableControlAction(0, 24,  true) -- LMB
		
        DisableControlAction(0, 140,  true) -- R
        DisableControlAction(0, 141,  true) -- Q
        DisableControlAction(0, 142,  true) -- RMB
        DisableControlAction(0, 22,  true) -- Jump
    end
  end
end)


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
 end