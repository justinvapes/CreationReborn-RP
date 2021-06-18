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
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local TargetCoords            = nil
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local turnEngineOn            = false
GUI.Time                      = 0
local PlayerData              = {}
local menuOpen                = false
local wasOpen                 = false
local currentopen             = false

Citizen.CreateThread(function()
	LoadInterior(GetInteriorAtCoords(-210.81, -1322.11, 30.89))
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 4,
    modBrakes       = 4,
    modTransmission = 4,
    modSuspension   = 3,
    modTurbo        = true,
    SetVehicleDirtLevel(vehicle, 0),
	SetVehicleMod(vehicle, 2)
  }  
    ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenMecanoActionsMenu()

  local elements = {
	{label = _U('work_wear'),    value = 'workuniform'},  
	{label = _U('civ_wear'),     value = 'cloakroom'},
  }
  
   if PlayerData.job and PlayerData.job.name == 'mecano' then
      table.insert(elements,  {label = _U('vehicle_list'), value = 'vehicle_list'})
   end
  
  if Config.EnablePlayerManagement and PlayerData.job and PlayerData.job.grade_name == 'boss' then
     table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mecano_actions',
    {
      title    = _U('mechanic'),
	  align    = 'bottom-right',
	  css      = 'identity',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

            local elements = {
              {label = _U('flat_bed'),  value = 'f100Rapid'},
            }

            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'spawn_vehicle',
              {
                title    = _U('service_vehicle'),
				align    = 'bottom-right',
				css      = 'identity',
                elements = elements
              },
              function(data, menu)
			  
                for i=1, #elements, 1 do
                  if Config.MaxInService == -1 then
				  
				    local vehicleNearPoint = GetClosestVehicle(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 3.0, 0, 71)	
                    if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 6.0) then
				  
                    ESX.Game.SpawnVehicleaa7b(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 0.38, function(vehicle)
					  local currentMods = ESX.Game.GetVehicleProperties(vehicle)
					  ESX.Game.SetVehicleProperties(vehicle, currentMods)
                      TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                      SetVehicleMaxMods(vehicle)					  
					  SetModelAsNoLongerNeeded(vehicle)	
                   end)
				else
                    ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
		         end
               end
             end
             menu.close()
           end,
              function(data, menu)
           menu.close()
           OpenMecanoActionsMenu()
        end
        )     
     end
	  
	if data.current.value == 'cloakroom' then
	   local health = GetEntityHealth(GetPlayerPed(-1))
	   
    if health >= 150 then
				
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin == nil then				
	else
		TriggerEvent('skinchanger:loadSkin', skin)
	 end      
		TriggerServerEvent('duty:mecanoHRDOff')
		TriggerServerEvent('BennysDutyLog', 'Off')
		ESX.UI.Menu.CloseAll()
		Citizen.Wait(250)
		OpenMecanoActionsMenu()
        end)
	else 
		 ESX.ShowNotification("~b~Boss: ~w~You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
		end
      end
	    
	if data.current.value == 'workuniform' then
	   local health = GetEntityHealth(GetPlayerPed(-1))

	   male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	   femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	   
    if health >= 150 then
	 
	  if male or femalemale then	
	 	local playerPed = GetPlayerPed(-1)
        setUniformHardline(data.current.value, playerPed)
		TriggerServerEvent('duty:mecanoHRDOn')
		TriggerServerEvent('BennysDutyLog', 'On')
        ESX.UI.Menu.CloseAll()
		Citizen.Wait(250)
		OpenMecanoActionsMenu()		
	else
		TriggerServerEvent('duty:mecanoHRDOn')	
		TriggerServerEvent('BennysDutyLog', 'On')
		ESX.UI.Menu.CloseAll()
		Citizen.Wait(250)
		OpenMecanoActionsMenu()
	 end
	else 
		ESX.ShowNotification("~b~Boss: ~w~You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
	end
  end
	  	     
      if data.current.value == 'boss_actions' then
        TriggerEvent('c3733e85-777a-8285-4836-20b26c07edbc', 'mecano', function(data, menu)--esx_society:openBossMenu
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mecano_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

function setUniformHardline(job, playerPed)
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

function OpenMobileMecanoActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mobile_mecano_actions',
    {
      title    = _U('mechanic'),
      align    = 'bottom-right',
	  css      = 'identity',
      elements = {
        {label = _U('billing'),       value = 'billing'},
        {label = _U('hijack'),        value = 'hijack_vehicle'},
        {label = _U('repair'),        value = 'fix_vehicle'},
        {label = _U('clean'),         value = 'clean_vehicle'},
        {label = _U('imp_veh'),       value = 'del_vehicle'},
        {label = 'Service Vehicle',   value = 'service'},
      }
    },
    function(data, menu)
      if data.current.value == 'billing' then
        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'billing',
          {
            title = _U('invoice_amount')
          },
          function(data, menu)
            local amount = tonumber(data.value)
            if amount == nil or amount < 0 then
              ESX.ShowNotification(_U('amount_invalid'))
            else
              menu.close()
              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
              if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification(_U('no_players_nearby'))
              else
                TriggerServerEvent('qi2yr-473kd-ldk3d-jf73s-3ls3s', GetPlayerServerId(closestPlayer), 'society_mecano', _U('mechanic'), amount)
              end
            end
          end,
        function(data, menu)
          menu.close()
        end
        )
      end

      if data.current.value == 'hijack_vehicle' then

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
            Citizen.CreateThread(function()
              Citizen.Wait(10000)
              SetVehicleDoorsLocked(vehicle, 1)
              SetVehicleDoorsLockedForAllPlayers(vehicle, false)
              netVeh = VehToNet(vehicle)
              TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 1)
              ClearPedTasksImmediately(playerPed)
              ESX.ShowNotification(_U('vehicle_unlocked'))
            end)
          end
        end
      end

      if data.current.value == 'fix_vehicle' then

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
		

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            Citizen.CreateThread(function()
              Citizen.Wait(20000)
              SetVehicleFixed(vehicle)
              SetVehicleDeformationFixed(vehicle)
			  SetVehicleOnGroundProperly(vehicle)
              SetVehicleUndriveable(vehicle, false)
              SetVehicleEngineOn(vehicle,  true,  true)
              ClearPedTasksImmediately(playerPed)
			  
			  FreezeEntityPosition(vehicle,false)
	          SetVehicleOnGroundProperly(vehicle)
			  SetVehicleOnGroundProperly(vehicle)
	          SetVehicleEngineOn(vehicle,turnEngineOn)
			  
              ESX.ShowNotification(_U('vehicle_repaired'))
            end)
          end
        end
      end

      
      if data.current.value == 'service' then
        TriggerEvent('CR_VehKm:Service')
      end

      if data.current.value == 'clean_vehicle' then

        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            Citizen.CreateThread(function()
              Citizen.Wait(10000)
              SetVehicleDirtLevel(vehicle, 0)
              ClearPedTasksImmediately(playerPed)
              ESX.ShowNotification(_U('vehicle_cleaned'))
            end)
          end
        end
      end

      if data.current.value == 'del_vehicle' then

        local ped = GetPlayerPed( -1 )

        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
          local pos = GetEntityCoords( ped )

          if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then
              ESX.ShowNotification(_U('vehicle_impounded'))
              SetEntityAsMissionEntity( vehicle, true, true )
              deleteCar( vehicle )
            else
              ESX.ShowNotification(_U('must_seat_driver'))
            end
          else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then
              ESX.ShowNotification(_U('vehicle_impounded'))
              SetEntityAsMissionEntity( vehicle, true, true )
              deleteCar( vehicle )
            else
              ESX.ShowNotification(_U('must_near'))
            end
          end
        end
      end
    end,
  function(data, menu)
    menu.close()
  end
  )
end

function setEntityHeadingFromEntity ( vehicle, playerPed )
    local heading = GetEntityHeading(vehicle)
    SetEntityHeading( playerPed, heading )
end

function getVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

AddEventHandler('esx_Bennys:hasEnteredMarker', function(zone)

  if zone == 'MecanoActions' then
    CurrentAction     = 'mecano_actions_menu'
    CurrentActionMsg  = _U('open_actions')
    CurrentActionData = {}
  end

  if zone == 'Garage' then
    CurrentAction     = 'mecano_harvest_menu'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end

  if zone == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed,  false)

      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('veh_stored')
      CurrentActionData = {vehicle = vehicle}
    end
  end
end)

AddEventHandler('esx_Bennys:hasExitedMarker', function(zone)
  CurrentAction = nil
  ESX.UI.Menu.CloseAll()
end)


RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = _U('mechanic1'),
    number     = 'mecano',
    base64Icon = 'data:image/png;base64,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'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Zones.MecanoActions.Pos.x, Config.Zones.MecanoActions.Pos.y, Config.Zones.MecanoActions.Pos.z)
    SetBlipSprite (blip, 446)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 1.0)
    SetBlipColour (blip, 48)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('Hardline'))
    EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()

  while true do
    Wait(5)
	
	if PlayerData.job and PlayerData.job.name == 'mecano' or PlayerData.job and PlayerData.job.name == 'offmecano' then
       local coords = GetEntityCoords(GetPlayerPed(-1))
      for k,v in pairs(Config.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	
	if PlayerData.job and PlayerData.job.name == 'mecano' or PlayerData.job and PlayerData.job.name == 'offmecano' then
       local coords      = GetEntityCoords(GetPlayerPed(-1))
       local isInMarker  = false
       local currentZone = nil
	  
        for k,v in pairs(Config.Zones) do
         if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1) then
            isInMarker  = true
            currentZone = k
         end
      end
	  
    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_Bennys:hasEnteredMarker', currentZone)
     end
	  
    if not isInMarker and HasAlreadyEnteredMarker then
         HasAlreadyEnteredMarker = false
         TriggerEvent('esx_Bennys:hasExitedMarker', LastZone)
      end
	else
	    Citizen.Wait(250)
    end
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

        if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'mecano' then

        if CurrentAction == 'mecano_actions_menu' then
           OpenMecanoActionsMenu()
        end

        if CurrentAction == 'delete_vehicle' then
           ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
         end

        if CurrentAction == 'remove_entity' then
           DeleteEntity(CurrentActionData.entity)
        end
           CurrentAction = nil
        end
      end

        if IsControlJustReleased(0, Keys['F6']) and PlayerData.job and PlayerData.job.name == 'mecano' then
           OpenMobileMecanoActionsMenu()
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
 while true do
    Citizen.Wait(0)

    if CurrentAction ~= nil then
       SetTextComponentFormat('STRING')
       AddTextComponentString(CurrentActionMsg)
       DisplayHelpTextFromStringLabel(0, 0, 1, -1)

    if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'offmecano' then

        if CurrentAction == 'mecano_actions_menu' then
           OpenMecanoActionsMenu()
        end
           CurrentAction = nil
         end
      end
   end
end)

carblacklist = { 
   'f100Rapid'
}

Citizen.CreateThread(function() 
while true do
	Citizen.Wait(0)
	
	if IsPedInAnyVehicle(PlayerPedId()) then
	   Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)		

	if PlayerData.job and PlayerData.job.name ~= 'mecano' and PlayerData.job.name ~= 'police' then
	    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
		   checkCar(GetVehiclePedIsIn(PlayerPedId(), false)) 
	    end
	  end
	else  
	    Citizen.Wait(250)
    end
  end
end)

function checkCar(car)
    if car then
	   carModel = GetEntityModel(car)
	   carName = GetDisplayNameFromVehicleModel(carModel)
	   
	if isCarBlacklisted(carModel) then
	   ClearPedTasksImmediately(PlayerPedId()) 
	 end
   end
 end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(carblacklist) do
	 if model == GetHashKey(blacklistedCar) then
		return true
	  end
	end
	return false
end

Citizen.CreateThread(function()
  while true do
  
	local sleep = 1000		
	local coords = GetEntityCoords(PlayerPedId())
	local coords2 = vector3(-227.63, -1327.71, 30.90)
	
   if PlayerData.job and PlayerData.job.name == 'mecano' then
   
    if GetDistanceBetweenCoords(coords, coords2, true) < 5 then
	   sleep = 5
	   DrawMarker(1, -227.63, -1327.71, 29.90, 0, 0, 0, 0, 0, 0, 0.9001, 0.9001, 0.5001, 255, 0, 0, 165, 0,0, 0,0)
   
    if GetDistanceBetweenCoords(coords, coords2, true) < 1 then
	   sleep = 5
      
     if not menuOpen then
	 
	    if currentopen == false then
		    ESX.ShowHelpNotification(_U('shop_prompt'))
		 end

			if IsControlJustReleased(0, 38) then
			   wasOpen = true
			   currentopen = true
			   OpenShopMenu()
			end
		else
			   Citizen.Wait(500)
			end
		else
			if wasOpen then
			   wasOpen = false
			   currentopen = false
			   ESX.UI.Menu.CloseAll()
		    end			
	      end
	    end
      end
	Citizen.Wait(sleep)
  end
end)

function OpenShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Hardline_Shop',
        {
        title    = 'Items',
	    align    = 'bottom-right',
		css      = 'identity',
        elements = {
			{label = 'Engine Oil = $500', value = 'buy_oil'},
			{label = 'Oil Filter = $150', value = 'buy_filter'},
			{label = 'Engine Rebuild Kit = $50,000', value = 'buy_rebuildkit'},
            }
        },
        function(data, menu)
		
        if data.current.value == 'buy_oil' then
		   TriggerServerEvent('esx_Bennys:BuyItem', 'oil')			
        elseif data.current.value == 'buy_filter' then
			TriggerServerEvent('esx_Bennys:BuyItem', 'filter')				
		elseif data.current.value == 'buy_rebuildkit' then
			TriggerServerEvent('esx_Bennys:BuyItem', 'rebuildkit')	
		 end		 
       end,
       function(data, menu)
       menu.close()
	   currentopen = false
    end
   )
end