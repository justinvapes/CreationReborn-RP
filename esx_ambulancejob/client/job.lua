local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local dragStatus= {}
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false
local blipsambo                     = {}
local blipsamboforpolice            = {}
local HP                            = false
local bodyBag                       = nil
local attached                      = false
local JailLocation                  = Config.JailLocation
local Removed                       = 0	
ESX                                 = nil
local jailTime   = 0
dragStatus.isDragged, isInShopMenu = false, false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("PlayHospital")
AddEventHandler("PlayHospital", function()
SendNUIMessage({
playhospital = true,
sound = 'http://45.32.240.100/radio/8050/hospital.ogg'
})
end)

RegisterNetEvent("StopHospital")
AddEventHandler("StopHospital", function()
SendNUIMessage({
stophospital = true
})
end)

RegisterNetEvent("esx_ambulancejob:CheckTime")
AddEventHandler("esx_ambulancejob:CheckTime", function()

	ESX.TriggerServerCallback("esx_ambulancejob:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
		   jailTime = newJailTime + 1
		   HospitalLogin(jailTime)
		end
	end)
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenAmbulanceActionsMenu()

  local elements = {
    {label = ('Vehicle List'), value = 'vehicle_list'},
	{label = ('Cloakroom'),    value = 'cloakroom'},
	{label = ('Flashlight'),   value = 'getlight'},
   }
	if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
    end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = ('Ambulance Options'),
	  align    = 'bottom-right',
	  css      = 'skin',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

        local elements = {
			{label = ('Sprinter'), value = 'esprinter'}
            }
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'criticalcareparamedic' or
			ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'clinicalsupportofficer' or
			ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then
				table.insert(elements, {label = ('Tahoe'), value = 'tahoe'})
			end
			
            ESX.UI.Menu.CloseAll()

             ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'vehicle_spawner',
              {
                title    = ('vehicle Spawner'),
				align    = 'bottom-right',
				css      = 'skin',
                elements = elements
              },
             function(data, menu)
             menu.close()
			 				
            local vehicleNearPoint = GetClosestVehicle(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 3.0, 0, 71)
            if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 6.0) then
				
                local model = data.current.value
                -- ESX.Game.SpawnVehicleaa7b(model, Config.Zones.VehicleSpawnPoint.Pos, 68.95, function(vehicle)
				ESX.Game.SpawnVehicleaa7b(model, Config.Zones.VehicleSpawnPoint.Pos, 337.65, function(vehicle)
                local playerPed = GetPlayerPed(-1)
				SetVehicleDirtLevel(vehicle, 0.0) --Spawn the vehicle clean
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	            SetVehicleMaxMods(vehicle)
				SetEntityAsMissionEntity(vehicle, true, true)
             end)
			    Citizen.Wait(250)
				TriggerEvent("fuel:SetNewData", 100)
              else
                ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
			  end
  
            end,
                function(data, menu)
                menu.close()
                OpenAmbulanceActionsMenu()
              end
            )
        end
	  	  	  
	  if data.current.value == 'cloakroom' then
        OpenCloakroomMenu()
      end
	  
	   if data.current.value == 'getlight' then
        TriggerServerEvent('esx_ambulancejob:giveWeapon', weapon,  1)
      end
	  
      if data.current.value == 'boss_actions' then
        TriggerEvent('c3733e85-777a-8285-4836-20b26c07edbc', 'ambulance', function(data, menu)--esx_society:openBossMenu
          menu.close()
        end)
      end
    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = _U('actions_prompt')
      CurrentActionData = {}
    end
  )
end


function OpenHelicoptorActionsMenu()

  local elements = {
    {label = ('Vehicle List'), value = 'vehicle_list'},
   }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = ('Ambulance Options'),
	  align    = 'bottom-right',
	  css      = 'skin',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

            local elements = {
			  {label = ('Westpac Helicoptor')}
            }

            ESX.UI.Menu.CloseAll()

             ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'vehicle_spawner',
              {
                title    = ('vehicle Spawner'),
				align    = 'bottom-right',
				css      = 'skin',
                elements = elements
              },
             function(data, menu)
             menu.close()
			 				
            local vehicleNearPoint = GetClosestVehicle(Config.Zones.HelicoptorSpawnPoint.Pos.x, Config.Zones.HelicoptorSpawnPoint.Pos.y, Config.Zones.HelicoptorSpawnPoint.Pos.z, 3.0, 0, 71)
            if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(Config.Zones.HelicoptorSpawnPoint.Pos.x, Config.Zones.HelicoptorSpawnPoint.Pos.y, Config.Zones.HelicoptorSpawnPoint.Pos.z, 6.0) then
				
                local model = data.current.value
                ESX.Game.SpawnVehicleaa7b('aw139', Config.Zones.HelicoptorSpawnPoint.Pos, 70.03, function(vehicle)
                local playerPed = GetPlayerPed(-1)
				SetVehicleDirtLevel(vehicle, 0.0) --Spawn the vehicle clean
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	            SetVehicleMaxMods(vehicle)
				SetEntityAsMissionEntity(vehicle, true, true)
             end)
			    Citizen.Wait(250)
				TriggerEvent("fuel:SetNewData", 100)
              else
                ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
			  end
  
            end,
                function(data, menu)
                menu.close()
                OpenAmbulanceActionsMenu()
              end
            )
        end	  	  	 
    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'ambulance_actions_menu'
      CurrentActionMsg  = _U('actions_prompt')
      CurrentActionData = {}
    end
  )
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        
        Citizen.Wait(1)
    end
end

local canCheckInvis = true

function StartInvisTimer()
	canCheckInvis = false
	local InvisTime = 3
    Citizen.CreateThread(function()
        while InvisTime > 0 and not canCheckInvis do
            InvisTime = InvisTime - 1
            if InvisTime == 0 then
				canCheckInvis = true
            end
            Citizen.Wait(60000)
        end
    end)
end

function OpenMobileAmbulanceActionsMenu()
    loadAnimDict('amb@medic@standing@kneel@base')
    loadAnimDict('anim@gangops@facility@servers@bodysearch@')

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'bottom-right',
		css      = 'skin',
		elements = {		
			{label = ('Citizen Interaction'),   value = 'citizen_interaction'},
			{label = ('Heal Yourself'),    value = 'heal_me'}
		}
	}, function(data, menu)
	
	if data.current.value == 'heal_me' then
	   local PlayerPed = GetPlayerPed(-1) 
	   FreezeEntityPosition(PlayerPed, true)
	   ESX.ShowNotification(('Please ~g~Wait~w~....'))
	   Wait(5000)
	   local PlayerPed = GetPlayerPed(-1) 
	   FreezeEntityPosition(PlayerPed, false)
	   SetEntityHealth(GetPlayerPed(-1), 200)
	   ESX.ShowNotification(('You Have Now Been Healed'))
	  end
	
	
		if data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'bottom-right',
				css      = 'skin',
				elements = {
				    {label = ('Check Details'),      value = 'identity_card'},	
					{label = _U('ems_menu_putincar'),value = 'put_in_vehicle'},
					{label = 'Take from Ambulance', value = 'take_from_car'},
					{label = _U('ems_menu_small'),   value = 'small'},
					{label =   ('Send To Hospital'), value = 'jail'},
					--{label =   ('Put In BodyBag'),   value = 'bodybag'},
					{label = _U('ems_menu_revive'),  value = 'revive'},
					{label = 'Fix invis in area',  value = 'invisfix'},
					{label = 'Drag Patient', value = 'drag'}
				}
			}, function(data, menu)
				if IsBusy then return end		

				if data.current.value == 'invisfix' then
					local coords = GetEntityCoords(PlayerPedId())
					local players = ESX.Game.GetPlayersInArea(coords, 200.0)
					if #players > 1 then
						if canCheckInvis then
							local deadPlayers = {}
							for i = 1, #players do
								if IsPedDeadOrDying(GetPlayerPed(players[i]), 1) then
									table.insert(deadPlayers, GetPlayerServerId(players[i]))
								end
								-- players[i] = GetPlayerServerId(players[i])
							end
							StartInvisTimer()
							TriggerServerEvent('esx_ambulancejob:ragdollfix', deadPlayers)
							deadPlayers = nil
						else
							ESX.ShowNotification(("Can't fix, you can only run this every 3 minutes"))
						end
					end
				end
			

				 local player, distance = ESX.Game.GetClosestPlayer()
                 if distance ~= -1 and distance <= 3.0 then
				 
				    if data.current.value == 'identity_card' then
					  OpenIdentityCardMenu(player)
					  end
					  
					 if data.current.value == 'jail' then					 
			          if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance'then				  
				            hospPlayer(GetPlayerServerId(player))
			          end
					end
					
					if data.current.value == 'drag' then
						TriggerServerEvent('22fe76e3-719a-4b38-8f63-36bf8df1f51b', GetPlayerServerId(player))
					end
					
					if data.current.value == 'bodybag' then
			         if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			            TriggerServerEvent('esx_ambulancejob:putinbodybag', GetPlayerServerId(player))
                     end
			        end

					if data.current.value == 'revive' then

						IsBusy = true
													
								local closestPlayerPed = GetPlayerPed(player)

								if IsPedDeadOrDying(closestPlayerPed, 1) then

									ESX.ShowNotification(_U('revive_inprogress'))

									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

									for i=1, 15, 1 do
										Citizen.Wait(900)
								
										ESX.Streaming.RequestAnimDict(lib, function()
										   TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
										end)
									 end

									TriggerServerEvent('e8fa6d55-a686-4483-b3a4-36bf8df1f56c', GetPlayerServerId(player))

									-- Show revive award?
									if Config.ReviveReward > 0 then
										ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(player), Config.ReviveReward))
									else
										ESX.ShowNotification(_U('revive_complete', GetPlayerName(player)))
									end
								else
									ESX.ShowNotification(_U('player_not_unconscious'))
								end
					
							IsBusy = false

					elseif data.current.value == 'small' then	
					
							local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[PARAMEDIC]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Currently Healing!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
							TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, 5000, 1, 0, false, false, false )
							TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, 5000, 48, 0, false, false, false )
							Citizen.Wait(5000)	
							local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[PARAMEDIC]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Healed Player!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
							TriggerServerEvent('e8fa6d55-a686-4483-b3a4-36bf8df1f51b', GetPlayerServerId(player)) 
				
					elseif data.current.value == 'put_in_vehicle' then
						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(player))
					elseif data.current.value == 'take_from_car' then
						TriggerServerEvent('esx_ambulancejob:takeFromVehicle', GetPlayerServerId(player))
					end
				 else
					if data.current.value ~= 'invisfix' then
						ESX.ShowNotification(('No Players Nearby'))
					end
                end
			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_ambulancejob:PutInBag')
AddEventHandler('esx_ambulancejob:PutInBag', function()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if IsEntityDead(playerPed) and not attached then
        SetEntityVisible(playerPed, false, false)
		       
        RequestModel("xm_prop_body_bag")

        while not HasModelLoaded("xm_prop_body_bag") do
            Citizen.Wait(1)
        end

        bodyBag = CreateObject(`xm_prop_body_bag`, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
		DecorSetInt(bodyBag ,decorName,decorInt)

        AttachEntityToEntity(bodyBag, playerPed, 0, -0.2, 0.75, -0.2, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
        attached = true
		SetModelAsNoLongerNeeded(bodyBag)
    end
end)

RegisterNetEvent('22fe76e3-719a-4b38-8f63-36bf8df1f51b')
AddEventHandler('22fe76e3-719a-4b38-8f63-36bf8df1f51b', function(ambId)
	   dragStatus.isDragged = not dragStatus.isDragged
	   dragStatus.ambId = ambId
end)

Citizen.CreateThread(function()
	local wasDragged

	while true do
		Citizen.Wait(0)

		if dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.ambId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Citizen.Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(PlayerPedId(), true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(PlayerPedId(), true, false)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		
        local playerPed = PlayerPedId()
        
        if not IsEntityDead(playerPed) and attached then

            DetachEntity(playerPed, true, false)
            SetEntityVisible(playerPed, true, true)

            SetEntityAsMissionEntity(bodyBag, false, false)
            SetEntityVisible(bodybag, false)
            SetModelAsNoLongerNeeded(bodyBag)
            
            DeleteObject(bodyBag)
            DeleteEntity(bodyBag)

            bodyBag = nil
            attached = false

        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('e8fa6d55-a686-4483-b3a4-36bf8df1f51b')
AddEventHandler('e8fa6d55-a686-4483-b3a4-36bf8df1f51b', function()
	SetEntityHealth(GetPlayerPed(-1), 200)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[PARAMEDIC]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Have Been Healed!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
end)

function OpenIdentityCardMenu(player)

  if Config.EnableESXIdentity then

    ESX.TriggerServerCallback('esx_ambulancejob:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = 'Male'
        else
          sex = 'Female'
        end
        sexLabel = 'Sex : ' .. sex
      else
        sexLabel = 'Sex : Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height : ' .. data.height
      else
        heightLabel = 'Height : Unknown'
      end

	  if data.license then
		  nameLabel = 'Name : ' .. data.firstname .. " " .. data.lastname  
		  if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
		  else
			jobLabel = 'Job : ' .. data.job.label
		  end
		  if data.dob ~= nil then
			  dobLabel = 'DOB : ' .. data.dob
		  else
			  dobLabel = 'DOB : Unknown'
		  end
	  else
		  nameLabel = 'Name : Unknown'
		  jobLabel = 'Job : Unknown'
		  dobLabel = 'DOB : Unknown'
	  end
  
	  local elements = {
		  {label = nameLabel, value = nil},
		  {label = sexLabel,    value = nil},
		  {label = dobLabel,    value = nil},
		  {label = heightLabel, value = nil},
		  {label = jobLabel,    value = nil},
		}

      if data.drunk ~= nil then
        table.insert(elements, {label = ('Alcohol Level: ') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'bottom-right',
		  css      = 'skin',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

  else

    ESX.TriggerServerCallback('esx_ambulancejob:getOtherPlayerData', function(data)

      local jobLabel = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Job : ' .. data.job.label
      end

        local elements = {
          {label = _U('name') .. data.name, value = nil},
          {label = jobLabel,              value = nil},
        }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac') .. data.drunk .. '%', value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licenses ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = _U('citizen_interaction'),
          align    = 'bottom-right',
		  css      = 'skin',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))
  end
end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

	ESX.Game.Teleport(playerPed, coords, function()
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
	end)
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum
				

		for hospitalNum,hospital in pairs(Config.Hospitals) do
		
		    --Fast Travels
			for k,v in ipairs(hospital.FastTravels) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < v.Marker.x then
					FastTravel(v.To.coords, v.To.heading)
				end
			end
			
			--Fast Travels (Prompt)
			for k,v in ipairs(hospital.FastTravelsPrompt) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < v.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k
				end
			end
			
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'offambulance' then

			-- Ambulance Actions
			for k,v in ipairs(hospital.AmbulanceActions) do
				local distance = #(playerCoords - v)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
				end
			end
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			--Helicopter Spawners
			for k,v in ipairs(hospital.Helicopters) do
				local distance = #(playerCoords - v.Spawner)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < v.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
				end
			end
			
			--vehicle deleter
			for k,v in ipairs(hospital.VehicleDeleter) do
				local distance = #(playerCoords - v)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehicleDeleter', k
				end
			 end
			end
		  end
		end

		-- Logic for exiting & entering markers
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

			if
				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'offambulance' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Helicopters' then
			CurrentAction = part
			CurrentActionMsg = _U('helicopter_prompt')
			CurrentActionData = {hospital = hospital, partNum = partNum}
		elseif part == 'FastTravelsPrompt' then
			local travelItem = Config.Hospitals[hospital][part][partNum]
			CurrentAction = part
			CurrentActionMsg = travelItem.Prompt
			CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}			
		elseif part == 'VehicleDeleter' then	
		
		    local playerPed = GetPlayerPed(-1)
			
        if IsPedInAnyVehicle(playerPed,  false) then
		   CurrentAction = part
		   CurrentActionMsg = _U('store_veh')
		   CurrentActionData = {}
	    end
      end		
    end
  end)
  
AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()				
				elseif CurrentAction == 'Helicopters' then
					OpenHelicoptorActionsMenu()	
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)					
				elseif CurrentAction == 'VehicleDeleter' then
				       DeleteVeh()   				 
				end
				
				CurrentAction = nil
			end

		elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and not IsDead then
			if IsControlJustReleased(0, Keys['F6']) then
			   OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteVeh()
    local ped = GetPlayerPed( -1 )
	if (IsPedSittingInAnyVehicle(ped)) then
    local vehicle = GetVehiclePedIsIn(ped, false) 	
	DeleteEntity(vehicle)
	TriggerEvent('esx:showNotification', 'The Vehicle Has Now Been Stored')
  end
end

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords, 5.0) then
        local vehicle = ESX.Game.GetClosestVehicle(coords)

        if DoesEntityExist(vehicle) then
            local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

            for i=maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    if i ~= -1 then
                        freeSeat = i
                        break
                    end
                end
            end

            if freeSeat then
                TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                dragStatus.isDragged = false
            end
        end
    end
end)


RegisterNetEvent('esx_ambulancejob:takeFromVehicle')
AddEventHandler('esx_ambulancejob:takeFromVehicle', function()
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
		ClearPedTasksImmediately(PlayerPedId())
	end
end)

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {}
	
	table.insert(elements, {label = ('Citizen Wear'),   value = 'citizen_wear'})
	
	if grade == 'graduateacp' then			
	   table.insert(elements, {label = ('Student Uniform'),  value = 'StudentUniform'})
	   
    elseif grade == 'advancedcareparamedic' then	
	   table.insert(elements, {label = ('Paramedic Uniform'),  value = 'ParamdeicUniform'})
	   
	elseif grade == 'criticalcareparamedic' then	
	   table.insert(elements, {label = ('Paramedic Uniform'),  value = 'ParamdeicUniform'})	 
	   
    elseif grade == 'clinicalsupportofficer' then	
	   table.insert(elements, {label = ('Paramedic Uniform'),  value = 'ParamdeicUniform'})	 
       table.insert(elements, {label = ('Crew Superviser Uniform'),  value = 'SuperviserUniform'})	 

    elseif grade == 'boss' then	
		table.insert(elements, {label = ('Student Uniform'),  value = 'StudentUniform'})
		table.insert(elements, {label = ('Paramedic Uniform'),  value = 'ParamdeicUniform'})
    	table.insert(elements, {label = ('Crew Superviser Uniform'),  value = 'SuperviserUniform'})	 	   
		table.insert(elements, {label = ('Operations Manager Uniform'),  value = 'ManagerUniform'})	   
    end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'bottom-right',
		css      = 'skin',
		elements = elements
	}, function(data, menu)
	
	if data.current.value == 'citizen_wear' then
	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	   
	    if male or femalemale then
		
		local inventory = ESX.GetPlayerData().inventory
        local count  = 0

        for i=1, #inventory, 1 do
            if inventory[i].name == 'emsgps' then
               count = inventory[i].count
            end
         end
	   
        if (count > 0) then	
		   TriggerServerEvent('esx_ambulancejob:RemoveGPS')				
		end
	   		
	    ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        SetPedArmour(playerPed, 0)
		SetPedComponentVariation(playerPed, 9, 0, 1, 2)				
		TriggerEvent('skinchanger:loadSkin', skin)
		TriggerServerEvent('duty:Ambulance2')	  	
		Citizen.Wait(1000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')
		TriggerServerEvent('esx_ambulancejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'Off')
		TriggerServerEvent('EMSDutyLog', 'Off')
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now off duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
	 end)
	else
		ESX.ShowNotification("You Are Already The Model You Need To Be!")
     end
  end
	
    if data.current.value == 'StudentUniform' then
	 
       ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
		  
	  if male or femalemale then	   		 
       if canTakeService then
		
        CheckGPS()	
				
		ESX.UI.Menu.CloseAll()
		setUniformEMS(data.current.value, PlayerPedId())
		SetPedArmour(PlayerPedId(), 100)
        ClearPedBloodDamage(PlayerPedId())
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedLastWeaponDamage(PlayerPedId())
		TriggerServerEvent('duty:Ambulance')		  
		Citizen.Wait(2000)
		TriggerEvent('CR_DutyBlips:updateBlip')
        --TriggerServerEvent('CR_DutyBlips:spawned')
		TriggerServerEvent('esx_ambulancejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')	  
		TriggerServerEvent('EMSDutyLog', 'On')
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    else
        ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
     end
    else
        ESX.ShowNotification("You Can Not Go On duty As These Models!")	   
     end
   end, 'ambulance') 	 	    
  end
  
    if data.current.value == 'ParamdeicUniform' then
	 
       ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
		  
	  if male or femalemale then	   		 
       if canTakeService then   
	   
		local grade = ESX.PlayerData.job.grade_name
		  		
		CheckGPS()
		
		ESX.UI.Menu.CloseAll()
		setUniformEMS(data.current.value, PlayerPedId())
		SetPedArmour(PlayerPedId(), 100)
        ClearPedBloodDamage(PlayerPedId())
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedLastWeaponDamage(PlayerPedId())
		TriggerServerEvent('duty:Ambulance')		  
		Citizen.Wait(2000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')			
		TriggerServerEvent('esx_ambulancejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')		
		TriggerServerEvent('EMSDutyLog', 'On')		  
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    else
        ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
     end
    else
	   ESX.ShowNotification("You Can Not Go On duty As These Models!")	
    end
   end, 'ambulance') 	 	    
  end

    if data.current.value == 'SuperviserUniform' then
	 
       ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
		  
	  if male or femalemale then	   		 
       if canTakeService then     
	   		  
		CheckGPS()
		
		ESX.UI.Menu.CloseAll()
		setUniformEMS(data.current.value, PlayerPedId())
		SetPedArmour(PlayerPedId(), 100)
        ClearPedBloodDamage(PlayerPedId())
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedLastWeaponDamage(PlayerPedId())
		TriggerServerEvent('duty:Ambulance')	  
		Citizen.Wait(2000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')
		TriggerServerEvent('esx_ambulancejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')		
		TriggerServerEvent('EMSDutyLog', 'On')
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	  
    else
        ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
     end
    else
	   ESX.ShowNotification("You Can Not Go On duty As These Models!")	
    end
   end, 'ambulance') 	 	    
  end
  
    if data.current.value == 'ManagerUniform' then
	 
       ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
		  
	  if male or femalemale then	   		 
       if canTakeService then  
       		  		
		CheckGPS()
		
		ESX.UI.Menu.CloseAll()
		setUniformEMS(data.current.value, PlayerPedId())
		SetPedArmour(PlayerPedId(), 100)
        ClearPedBloodDamage(PlayerPedId())
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedLastWeaponDamage(PlayerPedId())
		TriggerServerEvent('duty:Ambulance')		  
		Citizen.Wait(2000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')
		TriggerServerEvent('esx_ambulancejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')		 
		TriggerServerEvent('EMSDutyLog', 'On') 
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    else
        ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
     end
    else
	   ESX.ShowNotification("You Can Not Go On duty As These Models!")	
    end
   end, 'ambulance') 	 	    
  end	
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('actions_prompt')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx_ambulancejob:DutyAlerts')
AddEventHandler('esx_ambulancejob:DutyAlerts', function(serverid, RPname, grade, onOff)      
                                                                                   
    local serverid = GetPlayerPed(GetPlayerFromServerId(serverid))
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(serverid)
		   
	if grade == 'graduateacp' then				
       ESX.ShowAdvancedNotification('EMS', '[Graduate ACP]', '[~y~'.. RPname.firstname..' '..RPname.lastname..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1)		  
    elseif grade == 'advancedcareparamedic' then	
       ESX.ShowAdvancedNotification('EMS', '[AC Paramedic]', '[~y~'.. RPname.firstname..' '..RPname.lastname..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1)		  		  
    elseif grade == 'criticalcareparamedic' then
       ESX.ShowAdvancedNotification('EMS', '[CC Paramedic]', '[~y~'.. RPname.firstname..' '..RPname.lastname..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1)		  
	elseif grade == 'clinicalsupportofficer' then	
       ESX.ShowAdvancedNotification('EMS', '[CSO Paramedic]', '[~y~'.. RPname.firstname..' '..RPname.lastname..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1)		  
	elseif grade == 'boss' then	
       ESX.ShowAdvancedNotification('EMS', '[Commissioner]', '[~y~'.. RPname.firstname..' '..RPname.lastname..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1)		  	  				  
	end   		
	PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
	UnregisterPedheadshot(mugshot)	
end)

function CheckGPS()

    local inventory = ESX.GetPlayerData().inventory
    local count  = 0

    for i=1, #inventory, 1 do
        if inventory[i].name == 'emsgps' then
           count = inventory[i].count
        end
      end
	   
    if (count == 0) then	
	   TriggerServerEvent('esx_ambulancejob:GiveGPS')			
    end
end

function setUniformEMS(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        ESX.ShowNotification(_U('no_outfit'))
      end
    end
  end)
end

function GetAvailableVehicleSpawnPoint(hospital, part, partNum)
	local spawnPoints = Config.Hospitals[hospital][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('garage_blocked'))
		return false
	end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end


function WarpPedInClosestVehicle(ped)
	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then
		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end
	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

function hospPlayer(player)

    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'jail_menu',
        {
            title = ('Hospital Menu'),
        },	  	
        function (data2, menu)
		
        local jailTime = tonumber(data2.value)
        if jailTime == nil then
            ESX.ShowNotification(_U('invalid_amount'))
        else
            TriggerServerEvent("d974e13d-ea12-4447-a38c", player, jailTime + 1)
            menu.close()
        end
    end,
       function (data2, menu)
	   menu.close()
    end
    )
end

--ESX JAILER
-----------------------------------------------------------------------------------------------------

RegisterNetEvent("esx_ambulancejob:jail")
AddEventHandler("esx_ambulancejob:jail", function(jailTime)

		 
	if DoesEntityExist(PlayerPedId()) then
	   SendToHospital(jailTime)
	   DoScreenFadeOut(10)
		
		Citizen.CreateThread(function()
			
			male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	 
            if male or femalemale then
  
	        TriggerEvent('skinchanger:getSkin', function(skin)
		    if male then
			
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1']  = 22, ['torso_2']  = 0,
				['arms']     = 0,
				['pants_1']  = 27, ['pants_2']  = 5,
				['shoes_1']  = 4,  ['shoes_2']  = 2,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
		
			local clothesSkin = {
				['tshirt_1'] = 2,  ['tshirt_2'] = 0,
				['torso_1']  = 79, ['torso_2']  = 2,
				['arms']     = 14,
				['pants_1']  = 3,  ['pants_2']  = 13,
				['shoes_1']  = 1,  ['shoes_2']  = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		 end
       end)	  
		    ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			ResetPedMovementClipset(PlayerPedId(), 0)
			exports["dpemotes"]:ResetCurrentWalk()
	     end	
		 	 		 
		    local HospitalBed = 1
			if ESX.Game.GetPlayersInArea(vector3(319.32, -581.01, 43.25), 2)[1] then
				HospitalBed = 2
				if ESX.Game.GetPlayersInArea(vector3(324.19, -582.83, 43.25), 2)[1] then
					HospitalBed = 3
					if ESX.Game.GetPlayersInArea(vector3(322.66, -582.21, 43.25), 2)[1] then
						HospitalBed = 4
						if ESX.Game.GetPlayersInArea(vector3(317.82, -585.40, 43.25), 2)[1] then
							HospitalBed = 5
							if ESX.Game.GetPlayersInArea(vector3(314.53, -584.14, 43.25), 2)[1] then
								HospitalBed = 6
								if ESX.Game.GetPlayersInArea(vector3(311.15, -583.03, 43.24), 2)[1] then
									HospitalBed = 7
									if ESX.Game.GetPlayersInArea(vector3(307.80, -581.75, 43.25), 2)[1] then
										HospitalBed = 8
										if ESX.Game.GetPlayersInArea(vector3(309.31, -577.35, 43.25), 2)[1] then
											HospitalBed = 9
											BedLocation =  {x = 313.78,  y = -579.07, z = 43.25}--Bed 9  	
										else
											BedLocation =  {x = 309.31,  y = -577.35, z = 43.25}--Bed 8	
										end
									else
										BedLocation =  {x = 307.80,  y = -581.75, z = 43.25}--Bed 7 	
									end
								else
									BedLocation =  {x = 311.15,  y = -583.03, z = 43.25}--Bed 6 		
								end
							else
								BedLocation =  {x = 314.53,  y = -584.14, z = 43.25}--Bed 5 		
							end
						else
							BedLocation =  {x = 317.82,  y = -585.40, z = 43.25}--Bed 4 
						end
					else
						BedLocation = {x = 322.66,  y = -587.21, z = 43.25}--Bed 3 	  
					end
				else
					BedLocation = {x = 324.19,  y = -582.83, z = 43.25}--Bed 2 	
				end
			else
				BedLocation = {x = 319.32,  y = -581.01, z = 43.25}--Bed 1 	
			end				
	 				 
			SetEntityCoords(PlayerPedId(), BedLocation.x, BedLocation.y, BedLocation.z)
			
			if HospitalBed == 3 or HospitalBed == 4 or HospitalBed == 5 or HospitalBed == 6 or HospitalBed == 7 then
			   SetEntityHeading(PlayerPedId(), 154.85)	
		    else			
			   SetEntityHeading(PlayerPedId(), 342.35)	
            end			
			
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SUNBATHE_BACK", 0, false)
	        FreezeEntityPosition(PlayerPedId(), true)
			TriggerEvent("PlayHospital", source)
			TriggerEvent("esx_ambulancejob:PlayScreen", source)
			HP = true
			
			Citizen.Wait(1000)
	        DoScreenFadeIn(100)			
		end)
	end
end)

function HospitalLogin(jailTime)

	if DoesEntityExist(PlayerPedId()) then
	   SendToHospital(jailTime)
		
		Citizen.CreateThread(function()
			
			male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	 
            if male or femalemale then
  
	        TriggerEvent('skinchanger:getSkin', function(skin)
		    if male then
			
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1']  = 22, ['torso_2']  = 0,
				['arms']     = 0,
				['pants_1']  = 27, ['pants_2']  = 5,
				['shoes_1']  = 4,  ['shoes_2']  = 2,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
		
			local clothesSkin = {
				['tshirt_1'] = 2,  ['tshirt_2'] = 0,
				['torso_1']  = 79, ['torso_2']  = 2,
				['arms']     = 14,
				['pants_1']  = 3,  ['pants_2']  = 13,
				['shoes_1']  = 1,  ['shoes_2']  = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		 end
       end)	  
		    ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			ResetPedMovementClipset(PlayerPedId(), 0)
			exports["dpemotes"]:ResetCurrentWalk()
	     end	
		 	 		 
		    local HospitalBed = math.random(1, 9) 
				
	        if HospitalBed == 1 then 
	           BedLocation = {x = 319.32,  y = -581.01, z = 43.25}--Bed 1 	
	        elseif HospitalBed == 2 then 
	           BedLocation = {x = 324.19,  y = -582.83, z = 43.25}--Bed 2 	
	        elseif HospitalBed == 3 then 
	           BedLocation = {x = 322.66,  y = -587.21, z = 43.25}--Bed 3 	   
	        elseif HospitalBed == 4 then 
	           BedLocation =  {x = 317.82,  y = -585.40, z = 43.25}--Bed 4 
            elseif HospitalBed == 5 then 
	           BedLocation =  {x = 314.53,  y = -584.14, z = 43.25}--Bed 5 		
			elseif HospitalBed == 6 then 
	           BedLocation =  {x = 311.15,  y = -583.03, z = 43.25}--Bed 6 			   
            elseif HospitalBed == 7 then 
	           BedLocation =  {x = 307.80,  y = -581.75, z = 43.25}--Bed 7 			   
			elseif HospitalBed == 8 then 
	           BedLocation =  {x = 309.31,  y = -577.35, z = 43.25}--Bed 8			   
            elseif HospitalBed == 9 then 
	           BedLocation =  {x = 313.78,  y = -579.07, z = 43.25}--Bed 9  			   
	        end								
	 				 
			SetEntityCoords(PlayerPedId(), BedLocation.x, BedLocation.y, BedLocation.z)
			
			if HospitalBed == 3 or HospitalBed == 4 or HospitalBed == 5 or HospitalBed == 6 or HospitalBed == 7 then
			   SetEntityHeading(PlayerPedId(), 154.85)	
		   else			
			   SetEntityHeading(PlayerPedId(), 342.35)	
            end			
			
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SUNBATHE_BACK", 0, false)
	        FreezeEntityPosition(PlayerPedId(), true)
			HP = true
			
			TriggerEvent("PlayHospital", source)
			TriggerEvent("esx_ambulancejob:PlayScreen", source)			
		end)
	end
end

function SendToHospital(jailTime)

	Citizen.CreateThread(function()

		while jailTime > 0 do
	
			jailTime = jailTime - 1
			
			if jailTime >= 1 then
			   TriggerEvent('esx_status:add', 'hunger', 1000000)
               TriggerEvent('esx_status:add', 'thirst', 1000000)
			end

			TriggerServerEvent('esx_ambulancejob:updateRemaining', jailTime)	

			if jailTime == 0 then
			   ReleaseFromHospital()
			end
			Citizen.Wait(60000)
		end
	end)
		
	Citizen.CreateThread(function()
	local text

		while jailTime > 0 do
		  Citizen.Wait(0)	
		  
			if jailTime >= 1 then
			   text = _U('Hospital_Released_In', jailTime)

			   DrawGenericTextThisFrame()
			   SetTextEntry("STRING")
			   AddTextComponentString(text)
			   DrawText(0.5, 0.95)
			end
		end
	end)
end

function ReleaseFromHospital()
  
    ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	DoScreenFadeOut(10)			
	SetEntityCoords(PlayerPedId(), Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	HP = false
	SetEntityInvincible(PlayerPedId(), false)
	TriggerEvent("StopHospital", source)
	TriggerEvent("esx_ambulancejob:StopScreen", source)
	Citizen.Wait(1000)
	DoScreenFadeIn(100)
	
	SetEntityHealth(PlayerPedId(), 200)
			
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	if skin == nil then				
	else
		TriggerEvent('skinchanger:loadSkin', skin)
	end			
		TriggerEvent('esx:restoreLoadout')
	    ClearPedBloodDamage(PlayerPedId())
	    ResetPedVisibleDamage(PlayerPedId())
		ClearPedLastWeaponDamage(PlayerPedId())
	end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	
    if HP == true then
	   SetPedCanPlayGestureAnims(playerPed, false)	  
	   DisableControlAction(0, 142, false) -- MeleeAttackAlternate
       DisableControlAction(0, 24,  false) -- Shoot 
       DisableControlAction(0, 92,  false) -- Shoot in car
       DisableControlAction(0, 75,  false) -- Leave Vehicle	 	  
	   DisableControlAction(0, 323, false) -- x
	   DisableControlAction(0, 105, false) -- x
	   DisableControlAction(0, 73,  false) -- x
	   DisableControlAction(0, 73,  false) -- z
       DisableControlAction(0, 244, false) -- m	  
	   DisableControlAction(0, 29,  false) -- Point
	   DisableControlAction(0, 22,  false) -- Jump
       DisableControlAction(0, 25,  false) -- disable aim
       DisableControlAction(0, 47,  false) -- disable weapon
       DisableControlAction(0, 58,  false) -- disable weapon
       DisableControlAction(0, 37,  false) -- TAB
       DisableControlAction(0, 243, false) -- ~/Phone	  
       DisableControlAction(0, 289, false) -- F2/Inventory  
       DisableControlAction(0, 170, false) -- F3/Inventory	
       DisableControlAction(0, 19,  false) -- Left/Alt
       DisableControlAction(0, 263, false) -- disable melee
       DisableControlAction(0, 264, false) -- disable melee
       DisableControlAction(0, 257, false) -- disable melee
       DisableControlAction(0, 140, false) -- disable melee
       DisableControlAction(0, 141, false) -- disable melee
       DisableControlAction(0, 143, false) -- disable melee
    end
  end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

RegisterNetEvent('esx_policejob:trackerTaken')
AddEventHandler('esx_policejob:trackerTaken', function()
	if ESX.GetPlayerData().job.name == 'ambulance' then
		TriggerServerEvent('duty:Ambulance2')	  	
		Citizen.Wait(1000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('EMS', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Your tracker was smashed', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
	end
end)