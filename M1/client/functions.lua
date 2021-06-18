ESX = nil
local PlayerLoaded = false
local Inmenu = false

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

AddEventHandler('esx:onPlayerDeath', function()
  if cachedData["insideMotel"] then 
     ExitInstance()         
     cachedData["insideMotel"] = false
  end
end)

GlobalFunction = function(event, data)
    local options = {
        event = event,
        data = data
    }
    TriggerServerEvent("motel:globalEvent", options)
end

RegisterNetEvent('Motel:CheckPlayer')--Call this a few seconds after your character has loaded in. This will refesh the instance incase you logged out inside your or a players room
AddEventHandler('Motel:CheckPlayer', function()

    ESX.TriggerServerCallback("motel:fetchMotels", function(fetchedMotels, fetchedName)
        if fetchedMotels then
            cachedData["motels"] = fetchedMotels
        end

        if fetchedName then
            ESX.PlayerData["character"] = fetchedName
        else
            ESX.PlayerData["character"] = {
                ["firstname"] = GetPlayerName(PlayerId()),
                ["lastname"] = GetPlayerName(PlayerId())
            }
        end
         TriggerEvent('Motel:CheckPlayerS2') 
    end)
end)

Init = function()
    ESX.TriggerServerCallback("motel:fetchMotels", function(fetchedMotels, fetchedName)
        if fetchedMotels then
            cachedData["motels"] = fetchedMotels
        end

        if fetchedName then
            ESX.PlayerData["character"] = fetchedName
        else
            ESX.PlayerData["character"] = {
                ["firstname"] = GetPlayerName(PlayerId()),
                ["lastname"] = GetPlayerName(PlayerId())
            }
        end
    end)
end

OpenMotelRoomMenu = function(motelRoom)
    local menuElements = {}

    local cachedMotelRoom = cachedData["motels"][motelRoom]

    if cachedMotelRoom then
        for roomIndex, roomData in ipairs(cachedMotelRoom["rooms"]) do
            local roomData = roomData["motelData"]
            local allowed = roomData["displayLabel"] == ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]
            table.insert(menuElements, {["label"] = allowed and "Enter " .. roomData["displayLabel"] .. "'s room" or roomData["displayLabel"] .. "'s Room Is Locked, Knock?",["action"] = roomData,["allowed"] = allowed
           })			
        end
    end

    if #menuElements == 0 then
        table.insert(menuElements, {
            ["label"] = "This Room Is Free To Buy.. Talk To The Clerk"
        })
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_motel_menu", {
        ["title"] = "Motel",
        ["align"] = Config.AlignMenu,
        ["elements"] = menuElements,
		css = 'superete'
    }, function(menuData, menuHandle)
        local action = menuData["current"]["action"]
        local allowed = menuData["current"]["allowed"]

        if action then
            menuHandle.close()
					
            if allowed then
                EnterMotel(action)
            else
                PlayAnimation(PlayerPedId(), "timetable@jimmy@doorknock@", "knockdoor_idle")

                GlobalFunction("knock_motel", action)
            end
       end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

OpenInviteMenu = function(motelRoomData)
    local menuElements = {}

    ExitInstance()
    Citizen.Wait(400)
    local closestPlayers = ESX.Game.GetPlayersInArea(Config.MotelsEntrances[motelRoomData["room"]], 5.0)
    EnterInstance(motelRoomData["uniqueId"])

    for playerIndex = 1, #closestPlayers do
        closestPlayers[playerIndex] = GetPlayerServerId(closestPlayers[playerIndex])
    end

    if #closestPlayers <= 0 then
        return ESX.ShowNotification("Hearing Things? No One Is Outside Your Door")
    end

    ESX.TriggerServerCallback("motel:retreivePlayers", function(playersRetreived)
        if playersRetreived then
            for playerIndex = 1, #playersRetreived do
                local player = playersRetreived[playerIndex]

                table.insert(menuElements, {
                    ["label"] = player["firstname"] .. " " .. player["lastname"],
                    ["action"] = player
                })

                ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_motel_invite", {
                    ["title"] = "Invite someone.",
                    ["align"] = Config.AlignMenu,
                    ["elements"] = menuElements
                }, function(menuData, menuHandle)
                    local action = menuData["current"]["action"]
            
                    if action then
                        menuHandle.close()

                        GlobalFunction("invite_player", {
                            ["motel"] = motelRoomData,
                            ["player"] = action
                        })
                    end
                end, function(menuData, menuHandle)
                    menuHandle.close()
                end)
            end
        else
            ESX.ShowNotification("Couldn't fetch information about players.", "error", 3500)
        end
    end, closestPlayers)
end

EnterMotel = function(motelRoomData)
    if cachedData["insideMotel"] then 
        ExitInstance()         
        cachedData["insideMotel"] = false
    end

    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(5)
    end

    cachedData["insideMotel"] = true

    ESX.Game.Teleport(PlayerPedId(), Config.MotelInterior["exit"], function()
        FreezeEntityPosition(PlayerPedId(), true)
        EnterInstance(motelRoomData["uniqueId"])
		SetEntityHeading(GetPlayerPed(-1), 2.47)	

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Citizen.Wait(1000)
        end

        DoScreenFadeIn(1000)
        Citizen.Wait(3000)
        FreezeEntityPosition(PlayerPedId(), false)
    end)
		
    while cachedData["insideMotel"] do
        local sleepThread = 500

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for action, position in pairs(Config.MotelInterior) do
            local dstCheck = GetDistanceBetweenCoords(pedCoords, position, true)

            if dstCheck <= 5.0 then
                sleepThread = 5
                
                if dstCheck <= 0.9 then
                    local displayText = "[~g~E~s~] " .. Config.ActionLabel[action] or action

                    DrawScriptText(position, displayText)

                    if IsControlJustPressed(0, 38) then
                        DoMotelAction(action, motelRoomData)
                    end
                end
            end
        end
        Citizen.Wait(sleepThread)
    end	
	    DoScreenFadeOut(1000)
	    while not IsScreenFadedOut() do
        Citizen.Wait(5)
     end

    ESX.Game.Teleport(PlayerPedId(), Config.MotelsEntrances[motelRoomData["room"]], function()
        FreezeEntityPosition(PlayerPedId(), true)
        
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Citizen.Wait(100)
        end
		
	--Set the exit headings depending on what rooms you come out of	as they face different ways
	if motelRoomData["room"] ==  1 or motelRoomData["room"] == 2 or motelRoomData["room"] == 3  or motelRoomData["room"] == 21 or motelRoomData["room"] == 22 or motelRoomData["room"] == 23 or motelRoomData["room"] == 30 or motelRoomData["room"] == 31 or motelRoomData["room"] == 32 then
	   SetEntityHeading(PlayerPedId(), 339.45)	
    elseif motelRoomData["room"] == 7 or motelRoomData["room"] == 8 or motelRoomData["room"] == 9 or motelRoomData["room"] == 18 or motelRoomData["room"] == 19 or motelRoomData["room"] == 20 then		
       SetEntityHeading(PlayerPedId(), 159.30)	   		
	elseif motelRoomData["room"] == 4 or motelRoomData["room"] == 5 or motelRoomData["room"] == 6 or motelRoomData["room"] == 14 or motelRoomData["room"] == 15 or motelRoomData["room"] == 16 or motelRoomData["room"] == 17 then		
       SetEntityHeading(PlayerPedId(), 244.02)	   
    elseif motelRoomData["room"] == 24  or motelRoomData["room"] == 25 or motelRoomData["room"] == 26 or motelRoomData["room"] == 27 or motelRoomData["room"] == 28 or motelRoomData["room"] == 29 or motelRoomData["room"] == 33 or motelRoomData["room"] == 34 or motelRoomData["room"] == 35 or motelRoomData["room"] == 36 or motelRoomData["room"] == 37 or motelRoomData["room"] == 38 then		
	   SetEntityHeading(PlayerPedId(), 72.82)		   	   
	end	 
	
       DoScreenFadeIn(1000)     
       FreezeEntityPosition(PlayerPedId(), false) 		
       ExitInstance()
	   DoScreenFadeIn(1000)  
   end)
end

OpenLandLord = function()

 Inmenu = true
 
    ESX.TriggerServerCallback('motel:DoesOwn', function(Owned)
    if Owned then
	   SellMenu()
	else
	
	cachedData["purchasing"] = true   
    cachedData["cams"] = {
        ["first"] = CreateAnimatedCam({ ["x"] = 321.45541381836, ["y"] = -232.25518798828, ["z"] = 55.720478057861, ["rotationX"] = -22.393700391054, ["rotationY"] = 0.0, ["rotationZ"] = -49.8582675457 }),
        ["second"] = CreateAnimatedCam({ ["x"] = 316.64007568359, ["y"] = -237.73580932617, ["z"] = 56.835788726807, ["rotationX"] = -5.7637794613838, ["rotationY"] = 0.0, ["rotationZ"] = -39.464566767216 }),
        ["third"] = CreateAnimatedCam({ ["x"] = 324.91143798828, ["y"] = -219.40225219727, ["z"] = 59.737957000732, ["rotationX"] = -14.204724386334, ["rotationY"] = 0.0, ["rotationZ"] = 45.795275211334 }),
        ["fourth"] = CreateAnimatedCam({ ["x"] = 325.01739501953, ["y"] = -218.43293762207, ["z"] = 58.954334259033, ["rotationX"] = -12.787401333451, ["rotationY"] = 0.0, ["rotationZ"] = -102.29921241105 })
    }

    RenderScriptCams(true, true, 1500, true, true)
    HandleCam("first", "second", 2000)  
    Citizen.Wait(1000)  
    HandleCam("second", "third", 5000)    
    Citizen.Wait(4500)    
    Citizen.CreateThread(function()
	
        local currentMotel = 1
        
        local CheckCam = function()
            if currentMotel > 20 and not cachedData["positive"] then
                cachedData["positive"] = true

                HandleCam("third", "fourth", 2000)
            elseif currentMotel <= 20 and cachedData["positive"] then
                cachedData["positive"] = false

                HandleCam("fourth", "third", 2000)
            end
        end

        while cachedData["purchasing"] do
            Citizen.Wait(0)

            local markerPos = Config.MotelsEntrances[currentMotel]

            if IsControlJustPressed(0, 246) then
                OpenConfirmBox(currentMotel)
            elseif IsControlJustPressed(0, 174) then
			
                if Config.MotelsEntrances[currentMotel - 1] then
                    currentMotel = currentMotel - 1
                else
                    if currentMotel - 2 < 1 then
                        currentMotel = 39
                    else
                        currentMotel = currentMotel - 2
                    end
                end
				
            elseif IsControlJustPressed(0, 175) then
                if Config.MotelsEntrances[currentMotel + 1] then
                    currentMotel = currentMotel + 1
                else
                    if currentMotel + 2 > 39 then
                        currentMotel = 1
                    else
                        currentMotel = currentMotel + 2
                    end
                end
            elseif IsControlJustPressed(0, 202) then
                Cleanup()
                cachedData["purchasing"] = false
				Inmenu = false
            end

            BeginTextCommandDisplayHelp("Instructions1")
            EndTextCommandDisplayHelp(0, 0, 1, -1)

            CheckCam()

            DrawScriptMarker({
                ["type"] = 2,
                ["pos"] = markerPos,
                ["r"] = 0,
                ["g"] = 255,
                ["b"] = 0,
                ["sizeX"] = 0.4,
                ["sizeY"] = 0.4,
                ["sizeZ"] = 0.4,
                ["rotate"] = true
               })
            end
         end)	
      end
   end)   
end

SellMenu = function()
ESX.UI.Menu.CloseAll()

   local ownedMotel = GetPlayerMotel()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Motel_Menu',
        {
        title    = 'Sell Your Motel Room?',
	    align    = 'center',
		css      = 'superete',
        elements = {
		    {label = '<span style="color: red;">No</span> Keep It', value = 'No'},
			{label = '<span style="color: green;">Yes</span> Sell It', value = 'Sell_Motel'},
            }
        },
        function(data, menu)		
            if data.current.value == 'Sell_Motel' then	
			
            TriggerServerEvent('motel:SellMotel', ownedMotel)
            ESX.UI.Menu.CloseAll()
            TriggerEvent("mythic_progbar:client:progress", {
                name = "Selling_Motel",
                duration = 10000,
                label = "Selling Motel Room",
                useWhileDead = false,
                canCancel = true,
					
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
              },
                animation = {
                animDict = "missheistdockssetup1clipboard@idle_a",
                anim = "idle_a",
               },
                prop = {
                model = "prop_notepad_01"	
               }
            }, function(status)		      
               ESX.ShowNotification("You Just Sold Your Motel Room For $~g~" ..math.ceil(Config.MotelPrice / 2))
		       ClearPedTasks(PlayerPedId())			   
               ESX.UI.Menu.CloseAll()
			   Inmenu = false
            end)
		  end

         if data.current.value == 'No' then	
		    ESX.UI.Menu.CloseAll()
			Inmenu = false
		 end
		  
        end,
          function(data, menu)
          menu.close()
		  Inmenu = false
       end
     )
end

Citizen.CreateThread(function()
  while true do
	Citizen.Wait(0)

	if Inmenu == true then
	
	   --Mouse	  
       DisableControlAction(0, 1, true) -- Disable pan
	   DisableControlAction(0, 2, true) -- Disable tilt
		
	   --Movement
	   DisableControlAction(0, 30, true) -- disable left/right
       DisableControlAction(0, 31, true) -- disable forward/back
       DisableControlAction(0, 36, true) -- INPUT_DUCK
       DisableControlAction(0, 21, true) -- disable sprint	

       --Keys
	   DisableControlAction(0, 38,  true) -- E
	   DisableControlAction(0, 20,  true) -- Z	 
       DisableControlAction(0, 303, true) -- U	 
	   DisableControlAction(0, 288, true) -- F1
	   DisableControlAction(0, 289, true) -- F2
	   DisableControlAction(0, 170, true) -- F3
	   DisableControlAction(0, 56,  true) -- F9
	   DisableControlAction(0, 56,  true) -- 57
		   	   
       --Combat 
       DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
       DisableControlAction(0, 24, true) -- disable attack
       DisableControlAction(0, 25, true) -- disable aim
       DisableControlAction(1, 37, true) -- disable weapon select
       DisableControlAction(0, 47, true) -- disable weapon
       DisableControlAction(0, 58, true) -- disable weapon
       DisableControlAction(0, 140, true) -- disable melee
       DisableControlAction(0, 141, true) -- disable melee
       DisableControlAction(0, 142, true) -- disable melee
       DisableControlAction(0, 143, true) -- disable melee
       DisableControlAction(0, 263, true) -- disable melee
       DisableControlAction(0, 264, true) -- disable melee
       DisableControlAction(0, 257, true) -- disable melee	   
   else
	   Citizen.Wait(500)
    end 
  end
end)

OpenConfirmBox = function(motelRoom)

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_accept_motel", {
        ["title"] = "Do You Want To Buy #" .. motelRoom .. "?",
        ["align"] = Config.AlignMenu,
		css      = 'superete',
        ["elements"] = {          
            {
                ["label"] = '<span style="color: red;">No</span> Cancel',
                ["action"] = "no"
            },
			 {
                ["label"] = '<span style="color: green;">Yes</span> Confirm Purchase',
				
                ["action"] = "yes"
            }
        }
    }, function(menuData, menuHandle)
        local action = menuData["current"]["action"]

        if action == "yes" then
		
           ESX.TriggerServerCallback("motel:buyMotel", function(bought)
           if bought then                  
              Cleanup()           
              cachedData["purchasing"] = false
								
			TriggerEvent("mythic_progbar:client:progress", {
                name = "Buying_Motel",
                duration = 10000,
                label = "Purchasing Room "..motelRoom,
                useWhileDead = false,
                canCancel = true,
					
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
              },
			  
            animation = {
               animDict = "missheistdockssetup1clipboard@idle_a",
               anim = "idle_a",
             },
			 
            prop = {
               model = "prop_notepad_01"	
              }
            }, function(status)		      
               ESX.ShowNotification("~b~Paid ~g~$25,000 ~w~To LandLord.. You Now ~g~Own ~w~Room ~b~#" .. motelRoom)	
		       ClearPedTasks(PlayerPedId())
			   TriggerEvent("motel:RefreshInit")--Refresh data and cache it after buying
			   Inmenu = false
            end)	  
             else
                ESX.ShowNotification("You Don't Have Enough Money")
             end
               menuHandle.close()
            end, motelRoom)
        else
            menuHandle.close()
			Cleanup()           
            cachedData["purchasing"] = false
			Inmenu = false
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

OpenWardrobe = function()
	local elements = {}	
	
	 table.insert(elements, {label = ('Your Outfits'),     value = 'player_dressing'})
	 table.insert(elements, {label = ('Remove An Outfit'), value = 'remove_cloth'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = "Your Wardrobe",
		align    = 'bottom-right',
	    css      = 'apps',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'player_dressing' then
 
                ESX.TriggerServerCallback('motel:getPlayerDressing', function(dressing)
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
						ESX.TriggerServerCallback('motels:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('motel:getPlayerDressing', function(dressing)
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
					TriggerServerEvent('motels:removeOutfit', data2.current.value)
					ESX.ShowNotification(('You Just Threw Out Those Clothes'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

DoMotelAction = function(action, motelRoomData)
    if action == "exit" then
        cachedData["insideMotel"] = false
				
    elseif action == "drawer" then
	
	if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then
	
        ESX.TriggerServerCallback("lsrp-motels:getPropertyInventory", function(cb)
            TriggerEvent('esx_inventoryhud:openMotelsInventory', cb)
			MotelDrawInventory = cb.weapons			
        end,ESX.GetPlayerData().identifier)	
		
		Citizen.Wait(700)	 
	    Total = #MotelDrawInventory 
	    TriggerEvent('esx_inventoryhud:OpenTotal', Total)		
	else
		exports['mythic_notify']:DoHudText('error', 'You Can Not Access This While On Duty')
	 end
			
    elseif action == "bed" then 
	
	if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then
	
        ESX.TriggerServerCallback("lsrp-motels:getPropertyInventoryBed", function(cb)
            TriggerEvent('esx_inventoryhud:openMotelsInventoryBed', cb)
			MotelBedInventory = cb.weapons		
        end,ESX.GetPlayerData().identifier)
		
		Citizen.Wait(700)	 
	    Total = #MotelBedInventory 
	    TriggerEvent('esx_inventoryhud:OpenTotal', Total)	
	else
		exports['mythic_notify']:DoHudText('error', 'You Can Not Access This While On Duty')
	 end
		
    elseif action == "wardrobe" then
	if ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then
        OpenWardrobe()
	else
		exports['mythic_notify']:DoHudText('error', 'You Can Not Access This While On Duty')
	end	
		
    elseif action == "invite" then
        OpenInviteMenu(motelRoomData)
    end
end

GetPlayerMotel = function()
    if not ESX.PlayerData["character"] then return end

    if GetGameTimer() - cachedData["lastCheck"] < 5000 then
        return cachedData["cachedRoom"] or false
    end

    cachedData["lastCheck"] = GetGameTimer()

    for doorIndex, doorData in pairs(cachedData["motels"]) do
        for roomIndex, roomData in ipairs(doorData["rooms"]) do
            local roomData = roomData["motelData"]
    
            local allowed = roomData["displayLabel"] == ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]

            if allowed then
                cachedData["cachedRoom"] = roomData

                return roomData
            end
        end
    end
    cachedData["cachedRoom"] = nil
    return false
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

DrawScriptText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])
	local factor = string.len(text) / 370
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    AddTextComponentString(text)

	DrawText(_x, _y)	  
    DrawRect(_x, _y + 0.0125, -0.005 + factor, 0.03, 31, 31, 31, 150)    
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

CreateAnimatedCam = function(camIndex)
    local camInformation = camIndex

    if not cachedData["cams"] then
        cachedData["cams"] = {}
    end

    if cachedData["cams"][camIndex] then
        DestroyCam(cachedData["cams"][camIndex])
    end

    cachedData["cams"][camIndex] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(cachedData["cams"][camIndex], camInformation["x"], camInformation["y"], camInformation["z"])
    SetCamRot(cachedData["cams"][camIndex], camInformation["rotationX"], camInformation["rotationY"], camInformation["rotationZ"])

    return cachedData["cams"][camIndex]
end

HandleCam = function(camIndex, secondCamIndex, camDuration)
    if camIndex == 0 then
        RenderScriptCams(false, false, 0, 1, 0)
        
        return
    end

    local cam = cachedData["cams"][camIndex]
    local secondCam = cachedData["cams"][secondCamIndex] or nil

    local InterpolateCams = function(cam1, cam2, duration)
        SetCamActive(cam1, true)
        SetCamActiveWithInterp(cam2, cam1, duration, true, true)
    end

    if secondCamIndex then
        InterpolateCams(cam, secondCam, camDuration or 5000)
    end
end

RegisterNetEvent('Motel:CheckPlayerS2')
AddEventHandler('Motel:CheckPlayerS2', function()

    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 152.51, -1004.7, -99.0, false) <= 5 then
       DoScreenFadeOut(1000)

        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        local ownedMotel = GetPlayerMotel()

        if ownedMotel then
            EnterMotel(ownedMotel)
        else
            ESX.Game.Teleport(PlayerPedId(), Config.LandLord["position"], function()             
         end)
       end
           DoScreenFadeIn(1000)
      end
end)

Cleanup = function()
    RenderScriptCams(false, false, 0, 1, 0)

    for camIndex, camThingy in pairs(cachedData["cams"]) do
        if DoesCamExist(camThingy) then
            DestroyCam(camThingy)
        end
    end
end


Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_abigail"))
	
    while not HasModelLoaded(GetHashKey("ig_abigail")) do
      Wait(1)
    end
	
    local DoorPed =  CreatePed(4, 0x400AEC41, 325.12, -229.54, 53.22, 164.41, false, true)
    SetEntityHeading(DoorPed, 164.41)
    FreezeEntityPosition(DoorPed, true)
    SetEntityInvincible(DoorPed, true)
    SetBlockingOfNonTemporaryEvents(DoorPed, true)
	SetModelAsNoLongerNeeded(DoorPed)
end)