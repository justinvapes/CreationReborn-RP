ESX = nil
local IsOpen = false
local Fade = false
local HideMarkers = false
local creating = false
local currentTattoos = {}
local Utils = {}
local cam = -1												
local isCameraActive
local camHeading = 0.0

Citizen.CreateThread(function()
	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerLoaded = true
	AddTextEntry("TattInstructions", Config.HelpText)
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

Citizen.CreateThread(function()

	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Config.TattooShops, 1 do
		local TattShop = AddBlipForCoord(Config.TattooShops[i].x, Config.TattooShops[i].y, Config.TattooShops[i].z)
		SetBlipAsShortRange(TattShop, true)
		SetBlipSprite(TattShop, 75) 
		SetBlipColour(TattShop, 1) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tattoos")
		EndTextCommandSetBlipName(TattShop)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()

    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(250)
    end
	
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
			end
			currentTattoos = tattooList
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000        
		local InMenu = false
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)    
		
		for i = 1, #Config.TattooShops do
			
			local ShopMarker = vector3(Config.TattooShops[i].x, Config.TattooShops[i].y, Config.TattooShops[i].z)
			local dist = #(plyCoords - ShopMarker)
			
			if dist < 3.0 and IsOpen == false then                
			   sleep = 5        
			   DrawMarker(21, Config.TattooShops[i].x, Config.TattooShops[i].y, Config.TattooShops[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
				
				if dist < 0.5 and IsOpen == false then
				   InMenu = true  
				   ESX.ShowHelpNotification("~y~Press ~w~ ~INPUT_CONTEXT~ To Open The ~b~Menu")
					
					if IsControlJustReleased(0, 38) then  
						if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance' and ESX.PlayerData.job.name ~= 'mecano' and ESX.PlayerData.job.name ~= 'mecano2' then 
						   local health = GetEntityHealth(PlayerPedId())	
							
							if health >= 180 then
								sleep = 5    
								IsOpen = true
								OpenShopMenu2(ShopMarker)
								zoomOffset = 1.5
								camOffset = 0.0
							else 
								ESX.ShowNotification("You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
							end  
						else 
							ESX.ShowNotification("You Can't Use This While On Duty")
						end  
					end
				end
			end
		end
		Citizen.Wait(sleep)    
	end
end)

function OpenShopMenu2(ShopMarker)
 
    Citizen.CreateThread(function()
	   Instance()
    end)

    DoScreenFadeOut(200)
    while not IsScreenFadedOut() do
       Citizen.Wait(5)
    end

    if ShopMarker == vector3(321.23, 180.75, 103.59) then	   
	   SetEntityCoords(PlayerPedId(), 323.99, 179.62, 103.59)
	   SetEntityHeading(PlayerPedId(), 73.72)		   
	elseif ShopMarker == vector3(1323.60, -1651.29, 52.28) then 	   
	   SetEntityCoords(PlayerPedId(), 1321.20, -1653.16, 52.28)
	   SetEntityHeading(PlayerPedId(), 313.81)		   
	elseif ShopMarker == vector3(-1153.39, -1424.75, 4.95) then  
	   SetEntityCoords(PlayerPedId(), -1155.8, -1426.59, 4.95)
	   SetEntityHeading(PlayerPedId(), 308.12)	   
	elseif ShopMarker == vector3(-3170.21, 1074.44, 20.83) then
       SetEntityCoords(PlayerPedId(), -3168.9, 1077.2, 20.83)	
	   SetEntityHeading(PlayerPedId(), 161.72) 	   
	elseif ShopMarker == vector3(1861.72, 3749.50, 33.03) then  
	   SetEntityCoords(PlayerPedId(), 1864.6, 3747.7, 33.03)	
	   SetEntityHeading(PlayerPedId(), 28.54)  	   
	elseif ShopMarker == vector3(-291.15, 6198.75, 31.49) then  
	   SetEntityCoords(PlayerPedId(), -293.7, 6200.0, 31.49)
	   SetEntityHeading(PlayerPedId(), 225.02)	   
	end
	   CreateSkinCam()

  TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 0,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 91,
				torso_2  = 0,
				pants_1  = 14,
				pants_2  = 0
			})
		else
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 1,
				tshirt_1 = 34,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 101,
				torso_2  = 1,
				pants_1  = 16,
				pants_2  = 0
			})
		end
	end)
	 
  ESX.UI.Menu.CloseAll()
  
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop',
  {
    title    = 'Tattoo Shop',
    align    = 'bottom-right',
    css      = 'tatoo',
    elements = {
      {label = 'Remove All Tattoos?', value = 'Delete'},
	  {label = 'Buy A New Tattoo', value = 'Buy'},
    }
  },
  function(data, menu)
      
     if data.current.value == 'Buy' then
	    OpenShopMenu(ShopMarker)
	 
    elseif data.current.value == 'Delete' then
      
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop2',
      {
        title    = 'Are You Sure?',
        align    = 'bottom-right',
        css      = 'tatoo',
        elements = {
          {label = 'No', value = 'no'},
          {label = 'Yes', value = 'yes'}
        }
      },
      function(data2, menu)
        
        if data2.current.value == 'yes' then
		   TriggerServerEvent('CR_TattooShops:DeleteTatts')
		   Citizen.Wait(250)
		   ClearPedDecorations(PlayerPedId())
	       TriggerEvent('skinchanger:modelLoaded')
           ESX.ShowNotification('All Your Tattoos Have Now Been Removed ~r~Removed')
		   		             
        elseif data2.current.value == 'no' then
	   
        end			
      end,
      function(data2, menu)
        menu.close()
      end
    )
  end		
end,	
   function(data, menu)
   
		DoScreenFadeOut(500)   
		while not IsScreenFadedOut() do
		   Citizen.Wait(5)
		end
		
		if ShopMarker == vector3(321.23, 180.75, 103.59) then	   
		   SetEntityCoords(PlayerPedId(), 321.23, 180.75, 103.59)
		   SetEntityHeading(PlayerPedId(), 165.96)		   
		elseif ShopMarker == vector3(1323.60, -1651.29, 52.28) then		   
		   SetEntityCoords(PlayerPedId(), 1323.60, -1651.29, 52.28)
		   SetEntityHeading(PlayerPedId(), 42.39)			   
		elseif ShopMarker == vector3(-1153.39, -1424.75, 4.95) then		   
		   SetEntityCoords(PlayerPedId(), -1153.39, -1424.75, 4.95)
		   SetEntityHeading(PlayerPedId(), 32.73)		   
		elseif ShopMarker == vector3(-3170.21, 1074.44, 20.83) then
		   SetEntityCoords(PlayerPedId(), -3170.21, 1074.44, 20.83)
		   SetEntityHeading(PlayerPedId(), 253.43) 		   
		elseif ShopMarker == vector3(1861.72, 3749.5, 33.03) then
		   SetEntityCoords(PlayerPedId(), 1861.72, 3749.50, 33.03)
		   SetEntityHeading(PlayerPedId(), 104.09)  		   
		elseif ShopMarker == vector3(-291.15, 6198.75, 31.49) then  
		   SetEntityCoords(PlayerPedId(), -291.15, 6198.75, 31.49)
		   SetEntityHeading(PlayerPedId(), 300.62)	   
		end
	    
	    IsOpen = false
	    Fade = false
		creating = false
	    menu.close()	
	    DeleteSkinCam()
	    setPedSkin()	
	    cleanPlayer()	
        DoScreenFadeIn(500)
        Utils.NetworkClearVoiceChannel() 
        SetPlayerInvincible(PlayerPedId(), false)	    
     end
    )
end

function OpenShopMenu(ShopMarker)
	local elements = {}
		   				
	for k,v in pairs(Config.TattooCategories) do
		table.insert(elements, {label= v.name, value = v.value})		
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop3', {
		title    = _U('tattoos'),
		align    = 'bottom-right',
		css      = 'tatoo',
		elements = elements
	}, function(data, menu)
	
		local currentLabel, currentValue = data.current.label, data.current.value
		
		if data.current.value then
		   elements = {}
			
			for k,v in pairs(Config.TattooList[data.current.value]) do
				table.insert(elements, {
					label = _U('tattoo_item', k, _U('money_amount', ESX.Math.GroupDigits(v.price))),
					value = k,
					price = v.price
				})
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				title    = _U('tattoos') .. ' | '..currentLabel,
				align    = 'bottom-right',
				css      = 'tatoo',
				elements = elements
			}, function(data2, menu2)
			
				local price = data2.current.price
				
				if data2.current.value ~= nil then
								
				if currentValue == 'mpCustomskull_overlays' or currentValue == 'mpCustom_overlays' then
				
				ESX.TriggerServerCallback('esx_tattooshop:SubscriberCheck', function(Sub) 
				if Sub then
			
			       ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
						if success then
							table.insert(currentTattoos, {collection = currentValue, texture = data2.current.value})
						end
					end, currentTattoos, price, {collection = currentValue, texture = data2.current.value})	
                   else	
					   ESX.ShowNotification('You Must Be A ~y~Giga Level Donator ~w~Or ~b~Higher ~w~To ~g~Apply ~w~The Tattoos In This ~b~Section')								
                    end	
                end)
            else
  
                ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
					if success then
					   table.insert(currentTattoos, {collection = currentValue, texture = data2.current.value})
					end
				end, currentTattoos, price, {collection = currentValue, texture = data2.current.value})			
			end										
		end				
			end, function(data2, menu2)
				cleanPlayer()
				menu2.close()				
			end, function(data2, menu2) 
			
				if data2.current.value ~= nil then
				   drawTattoo(data2.current.value, currentValue)
				end
			end)
		end
	end, function(data, menu)
		 menu.close()
		 cleanPlayer()			
	end)
end

function CreateSkinCam()

	local playerHeading = GetEntityHeading(PlayerPedId())
	
	if playerHeading + 94 < 360.0 then
		camHeading = playerHeading + 90.0
	elseif playerHeading + 94 >= 360.0 then
		camHeading = playerHeading - 266.0 --194
	end
	isCameraActive = true	
end

Citizen.CreateThread(function()    
	while true do
		Citizen.Wait(0)
		
		if isCameraActive == true then
		    local playerPed = PlayerPedId()
		    local coords = GetEntityCoords(playerPed)
									
			if IsDisabledControlPressed(0, 34) and not Left then
          			                     				
               local currentHeading = GetEntityHeading(playerPed)
			   
			    heading = currentHeading -1.5
			    SetEntityHeading(GetPlayerPed(-1), heading) 
				
                if IsDisabledControlJustReleased(0, 34) then
			       Left = false 
			    end				          
		    end
		
		    if IsDisabledControlPressed(0, 35) then
  			          				
               local currentHeading = GetEntityHeading(playerPed)
			   
			    heading = currentHeading +1.5
			    SetEntityHeading(GetPlayerPed(-1), heading) 
				
                if IsDisabledControlJustReleased(0, 35) then
			       Right = false 
			    end				      
		    end
				
		    if IsDisabledControlPressed(0, 87) then
			   local CurrentZoom = zoomOffset
			   
			   NewZoom = CurrentZoom - 0.01			
       		   
			   if NewZoom > 0.5 then
			      zoomOffset = NewZoom
			   end
			   
            elseif IsDisabledControlPressed(0, 88) then
			
               local CurrentZoom = zoomOffset
			   
			   NewZoom = CurrentZoom + 0.01	
			   
                if NewZoom < 1.90 then
			       zoomOffset = NewZoom
			    end			   
		    end
								
			if IsDisabledControlPressed(0, 44) then
			   local CurrentOffset = camOffset
			   		
			   NewOffset = CurrentOffset + 0.01				      
			   
               if NewOffset < 0.80 then
			       camOffset = NewOffset
			    end				   
			   					   
            elseif IsDisabledControlPressed(0, 46) then
			   local CurrentOffset = camOffset
			   
			   NewOffset = CurrentOffset - 0.01			
			   
			   if NewOffset > -0.80 then
			       camOffset = NewOffset
			    end				       		   
		    end
			
			
			if not DoesCamExist(cam) then
			   cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			end

			SetCamActive(cam, true)
			RenderScriptCams(true, true, 500, true, true)
									
			local angle = camHeading * math.pi / 180.0
			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + (zoomOffset * theta.x),
				y = coords.y + (zoomOffset * theta.y)
			}

			local angleToLook = camHeading - 200.0 
			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0
			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + (zoomOffset * thetaToLook.x),
				y = coords.y + (zoomOffset * thetaToLook.y)
			}

			SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
		    PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
			
			if Fade == false then
		       Citizen.Wait(500)
			   DoScreenFadeIn(500)
			   Fade = true
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
        if isCameraActive then
		   BeginTextCommandDisplayHelp("TattInstructions")
           EndTextCommandDisplayHelp(0, 0, 1, -1)
		   DisableControlAction(0, 30,  true) -- MoveLeftRight
           DisableControlAction(0, 31,  true) -- MoveUpDown
		   DisableControlAction(0, 44,  true) -- Q
		   DisableControlAction(0, 38,  true) -- E
		   DisableControlAction(0, 20,  true) -- Z
		   DisableControlAction(0, 288,  true) -- F1
		   DisableControlAction(0, 289,  true) -- F2
		   DisableControlAction(0, 170,  true) -- F3
        end
    end
end)

function setPedSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
    
	Citizen.Wait(500)

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

function drawTattoo(current, collection)
	
	ClearPedDecorations(PlayerPedId())
	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end	
	ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(Config.TattooList[collection][current].nameHash))   
end

function DeleteSkinCam()
   isCameraActive = false
   SetCamActive(cam, false)
   RenderScriptCams(false, true, 500, true, true)
   cam = nil
end

function cleanPlayer()
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
	   ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(Config.TattooList[v.collection][v.texture].nameHash))
	end
end

function Utils.NetworkClearVoiceChannel()
    return Citizen.InvokeNative(0xE036A705F989E049)
end

function Instance()
	local ped = PlayerPedId()
	NetworkSetVoiceChannel(math.random(100,1000))
	SetPlayerInvincible(ped, true)
	creating = true
	
	while creating do 
		Citizen.Wait(0)
		SetLocalPlayerVisibleLocally(true)
		
		for _, player in pairs(GetActivePlayers()) do
			local playerPed = GetPlayerPed(player)
			
			if playerPed ~= ped then
				if DoesEntityExist(playerPed) then
					local xC = GetEntityCoords(ped)
					local tC = GetEntityCoords(playerPed)
					
					if GetDistanceBetweenCoords(xC.x, xC.y, xC.z, tC.x, tC.y, tC.z, false) < 10.0 then
					   SetEntityCoords(playerPed)
					   SetEntityLocallyInvisible(playerPed)
					   SetEntityNoCollisionEntity(ped, playerPed, true)
					end
				end
			end
		end
	end
end