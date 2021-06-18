ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_shops:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			if (Config.Zones[k] ~= nil) then
				Config.Zones[k].Items = v
			end
		end
	end)
end)

function OpenShopMenu(zone)
	PlayerData = ESX.GetPlayerData()
	
	SendNUIMessage({
		message		= "show",
		clear = true
	})
	
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		SendNUIMessage({
			message		= "add",
			item		= item.item,
			label      	= item.label,
			item       	= item.item,
			price      	= item.price,
			max        	= item.limit,
			loc			= zone
		})

	end
	
	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)

end

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.ZonesMarkers) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
			SetBlipSprite (blip, 52)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, 4)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('shops'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
	
		local sleep = 1000		
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		  
		  for k,v in pairs(Config.Zones) do
		      for i = 1, #v.Pos, 1 do
			  
              local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
		  	  
		    if distance < 5.0 then
			   sleep = 5
			   DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, true, false, false, false)
	        end
	     end
      end
	Citizen.Wait(sleep)
   end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
	
		local sleep       = 150		
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 0.5) then
				    sleep = 5
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', LastZone)
		end
		Citizen.Wait(sleep)
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) then

				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			elseif IsControlJustReleased (0, 44) then
				ESX.SetTimeout(200, function()
					SetNuiFocus(false, false)
				end)	
			end

		else
			Citizen.Wait(500)
		end
	end
end)

function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({message = "hide"})
end

RegisterNUICallback('quit', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
	TriggerServerEvent('esx_shops:buyItem', data.item, data.count, data.loc)
	cb('ok')
end)

RegisterNetEvent('99kr-burglary:Sound')
AddEventHandler('99kr-burglary:Sound', function(sound1, sound2)
  PlaySoundFrontend(-1, sound1, sound2)
end)

 --Gangster
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_prismuscl_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_prismuscl_01")) do
      Wait(1)
    end
	
	RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
      Citizen.Wait(0)
    end    

     
      local Gangster =  CreatePed(4, 0x5F2113A1, -209.93, -1607.08, 37.06, 83.93, false, true)
      SetEntityHeading(Gangster, 83.93)
      FreezeEntityPosition(Gangster, true)
      SetEntityInvincible(Gangster, true)
      SetBlockingOfNonTemporaryEvents(Gangster, true)
	  TaskStartScenarioInPlace(Gangster, "WORLD_HUMAN_SMOKING_POT", 0, 1)
	  SetModelAsNoLongerNeeded(Gangster)
end)

