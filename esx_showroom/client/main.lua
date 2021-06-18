local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

--action functions
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local Categories          = {}
local Bikes                   = {}
local LastVehicles            = {}
local CurrentVehicleData      = nil
local PlayerData              = {}
local GUI                     = {}
local LastVehiclesHash        = nil
ESX                           = nil
GUI.Time                      = 0


Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  ESX.TriggerServerCallback('esx_Showroom:getCategories', function (categories)
    Categories = categories
  end)

  ESX.TriggerServerCallback('esx_Showroom:getVehicles', function (vehicles)
    Vehicles = vehicles
  end)
  
  ESX.TriggerServerCallback('esx_ShowroomBike:getCategories', function (Categories)
    Categories = Categories
  end)

  ESX.TriggerServerCallback('esx_ShowroomBike:getVehicles', function (bikes)
    Bikes = bikes
  end)
end)

function DeleteKatalogVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		if LastVehiclesHash ~= nil then
			SetModelAsNoLongerNeeded(LastVehiclesHash)
			LastVehiclesHash = nil
		end
		table.remove(LastVehicles, 1)
	end
end

--markers
AddEventHandler('esx_qalle_bilpriser:hasEnteredMarker', function (zone)
  if zone == 'Katalog' then
    CurrentAction     = 'cars_menu'
    CurrentActionMsg  = _U('press_e')
    CurrentActionData = {}
  end
  
  if zone == 'BikeKatalog' then
    CurrentAction     = 'Bike_menu'
    CurrentActionMsg  = _U('press_e')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_qalle_bilpriser:hasExitedMarker', function (zone)
  if not IsInShopMenu then
  end
  CurrentAction = nil
end)

function OpenShopMenu()
  IsInShopMenu = true

  ESX.UI.Menu.CloseAll()

  local playerPed = GetPlayerPed(-1)

  FreezeEntityPosition(playerPed, true)
  SetEntityVisible(playerPed, false)
  SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

  local vehiclesByCategory = {}
  local elements           = {}
  local firstVehicleData   = nil

  for i=1, #Categories, 1 do
    vehiclesByCategory[Categories[i].name] = {}
  end

  for i=1, #Vehicles, 1 do
    table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
  end

  for i=1, #Categories, 1 do
		local category         = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local options          = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(options, vehicle.name .. ' $' .. vehicle.price)
		end

		table.insert(elements, {
			name    = category.name,
			label   = category.label,
			value   = 0,
			type    = 'slider',
			max     = #Categories[i],
			options = options
		})
	end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_shop',
    {
      title    = 'Car Showroom',
      align    = 'bottom-right',
	  css      = 'Magasin',
      elements = elements,
    },
    function (data, menu)
      local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]


    end,
    function (data, menu)

      menu.close()

      DoScreenFadeOut(1000)
      Citizen.Wait(1000)
      DoScreenFadeIn(1000)
      DeleteKatalogVehicles()

      local playerPed = GetPlayerPed(-1)

      CurrentAction     = 'shop_menu'
      CurrentActionMsg  = 'shop menu'
      CurrentActionData = {}

      FreezeEntityPosition(playerPed, false)

      SetEntityCoords(playerPed, Config.Zones.Katalog.Pos.x, Config.Zones.Katalog.Pos.y, Config.Zones.Katalog.Pos.z)
      SetEntityVisible(playerPed, true)
      IsInShopMenu = false
    end,
    function (data, menu)
      local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
      local playerPed   = GetPlayerPed(-1)

      DeleteKatalogVehicles()
	  LastVehiclesHash = vehicleData.model
	  WaitForVehicleToLoad(vehicleData.model)

      ESX.Game.SpawnLocalVehicleaa7b(vehicleData.model, {
        x = Config.Zones.ShopInside.Pos.x,
        y = Config.Zones.ShopInside.Pos.y,
        z = Config.Zones.ShopInside.Pos.z
      }, Config.Zones.ShopInside.Heading, function(vehicle)
        table.insert(LastVehicles, vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(vehicle)
      end)
    end
  )

  DeleteKatalogVehicles()
  WaitForVehicleToLoad(firstVehicleData.model)
  LastVehiclesHash = firstVehicleData.model

  ESX.Game.SpawnLocalVehicleaa7b(firstVehicleData.model, {
    x = Config.Zones.ShopInside.Pos.x,
    y = Config.Zones.ShopInside.Pos.y,
    z = Config.Zones.ShopInside.Pos.z
  }, Config.Zones.ShopInside.Heading, function (vehicle)
    table.insert(LastVehicles, vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    FreezeEntityPosition(vehicle, true)
	SetModelAsNoLongerNeeded(vehicle)
  end)
end

function OpenBikeShopMenu()
  IsInShopMenu = true

  ESX.UI.Menu.CloseAll()

  local playerPed = GetPlayerPed(-1)

  FreezeEntityPosition(playerPed, true)
  SetEntityVisible(playerPed, false)
  SetEntityCoords(playerPed, Config.Zones.BikeShopInside.Pos.x, Config.Zones.BikeShopInside.Pos.y, Config.Zones.BikeShopInside.Pos.z)

  local vehiclesByCategory = {}
  local elements           = {}
  local firstVehicleData   = nil

  for i=1, #Categories, 1 do
    vehiclesByCategory[Categories[i].name] = {}
  end

  for i=1, #Vehicles, 1 do
    table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
  end

  
  for i=1, #Categories, 1 do
		local category         = Categories[i]
		local categoryVehicles = vehiclesByCategory[category.name]
		local options          = {}

		for j=1, #categoryVehicles, 1 do
			local vehicle = categoryVehicles[j]

			if i == 1 and j == 1 then
				firstVehicleData = vehicle
			end

			table.insert(options, vehicle.name .. ' $' .. vehicle.price)
		end

		table.insert(elements, {
			name    = category.name,
			label   = category.label,
			value   = 0,
			type    = 'slider',
			max     = #Categories[i],
			options = options
		})
	end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_shop',
    {
      title    = 'Benefactor Showroom',
      align    = 'bottom-right',
	  css      = 'Magasin',
      elements = elements,
    },
    function (data, menu)	
    local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
    end,
	
    function (data, menu)

      menu.close()

        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)

      DeleteKatalogVehicles()

      local playerPed = GetPlayerPed(-1)

      CurrentAction     = 'shop_menu'
      CurrentActionMsg  = 'shop menu'
      CurrentActionData = {}

      FreezeEntityPosition(playerPed, false)
      SetEntityCoords(playerPed, Config.Zones.BikeKatalog.Pos.x, Config.Zones.BikeKatalog.Pos.y, Config.Zones.BikeKatalog.Pos.z)
      SetEntityVisible(playerPed, true)
      IsInShopMenu = false

    end,
    function (data, menu)
      local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
      local playerPed   = GetPlayerPed(-1)

      DeleteKatalogVehicles()
	  LastVehiclesHash = vehicleData.model
	  WaitForVehicleToLoad(vehicleData.model)

      ESX.Game.SpawnLocalVehicleaa7b(vehicleData.model, {
        x = Config.Zones.BikeShopInside.Pos.x,
        y = Config.Zones.BikeShopInside.Pos.y,
        z = Config.Zones.BikeShopInside.Pos.z
      }, Config.Zones.BikeShopInside.Heading, function(vehicle)
        table.insert(LastVehicles, vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(vehicle)
      end)
    end
  )

  DeleteKatalogVehicles()
  WaitForVehicleToLoad(firstVehicleData.model)
  LastVehiclesHash = firstVehicleData.model

  ESX.Game.SpawnLocalVehicleaa7b(firstVehicleData.model, {
    x = Config.Zones.BikeShopInside.Pos.x,
    y = Config.Zones.BikeShopInside.Pos.y,
    z = Config.Zones.BikeShopInside.Pos.z
  }, Config.Zones.BikeShopInside.Heading, function (vehicle)
    table.insert(LastVehicles, vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    FreezeEntityPosition(vehicle, true)
	SetModelAsNoLongerNeeded(vehicle)
  end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)
			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)
			DisableControlAction(0, 75, true) -- F
            DisableControlAction(0, 86, true) -- E	
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
            DisableControlAction(0, 24,  true) -- Shoot 
            DisableControlAction(0, 92,  true) -- Shoot in car
            DisableControlAction(0, 75,  true) -- Leave Vehicle	 	  
	        DisableControlAction(0, 323, true) -- x
	        DisableControlAction(0, 105, true) -- x
	        DisableControlAction(0, 73,  true) -- x
	        DisableControlAction(0, 29,  true) -- Point
	        DisableControlAction(0, 22,  true) -- Jump
            DisableControlAction(0, 24,  true) -- disable attack
            DisableControlAction(0, 25,  true) -- disable aim
            DisableControlAction(0, 47,  true) -- disable weapon
            DisableControlAction(0, 58,  true) -- disable weapon
            DisableControlAction(0, 142, true) -- Left Click
            DisableControlAction(0, 37,  true) -- TAB
            DisableControlAction(0, 243, true) -- ~/Phone	
			DisableControlAction(0, 288, true) -- F1/Inventory  
            DisableControlAction(0, 289, true) -- F2/Inventory  
            DisableControlAction(0, 170, true) -- F3/Inventory		  
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee

			drawLoadingText(_U('shop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end


--keycontrols
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(5)

    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
	  
        if CurrentAction == 'cars_menu' then
		   DoScreenFadeOut(1000)
           Wait(1000)
           DoScreenFadeIn(1000)
           OpenShopMenu()
        end
		
		if CurrentAction == 'Bike_menu' then
		   DoScreenFadeOut(1000)
           Wait(1000)
           DoScreenFadeIn(1000)
           OpenBikeShopMenu()
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    else
      Citizen.Wait(1000)
    end
  end
end)

-- Display markers
Citizen.CreateThread(function ()
  while true do
    Wait(5)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(1000)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
        isInMarker  = true
        currentZone = k
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('esx_qalle_bilpriser:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_qalle_bilpriser:hasExitedMarker', LastZone)
    end
  end
end)

---- FUNCTIONS ----
function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsInShopMenu then
            DisableControlAction(0, 75, true) -- F
            DisableControlAction(0, 86, true) -- E	
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
            DisableControlAction(0, 24,  true) -- Shoot 
            DisableControlAction(0, 92,  true) -- Shoot in car
            DisableControlAction(0, 75,  true) -- Leave Vehicle	 	  
	        DisableControlAction(0, 323, true) -- x
	        DisableControlAction(0, 105, true) -- x
	        DisableControlAction(0, 73,  true) -- x
	        DisableControlAction(0, 29,  true) -- Point
	        DisableControlAction(0, 22,  true) -- Jump
            DisableControlAction(0, 24,  true) -- disable attack
            DisableControlAction(0, 25,  true) -- disable aim
            DisableControlAction(0, 47,  true) -- disable weapon
            DisableControlAction(0, 58,  true) -- disable weapon
            DisableControlAction(0, 142, true) -- Left Click
            DisableControlAction(0, 37,  true) -- TAB
            DisableControlAction(0, 243, true) -- ~/Phone	
			DisableControlAction(0, 288, true) -- F1/Inventory  
            DisableControlAction(0, 289, true) -- F2/Inventory  
            DisableControlAction(0, 170, true) -- F3/Inventory		  
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
        end
    end
end)

--notification
function sendNotification(message, messageType, messageTimeout)
  exports['mythic_notify']:DoHudText('error', message)
	-- TriggerEvent("pNotify:SendNotification", {
	-- 	text = message,
	-- 	type = messageType,
	-- 	queue = "katalog",
	-- 	timeout = messageTimeout,
	-- 	layout = "bottomCenter"
	-- })
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end