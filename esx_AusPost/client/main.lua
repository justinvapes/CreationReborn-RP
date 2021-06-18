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

ESX                             = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local onDuty                    = false
local BlipCloakRoom             = nil
local BlipVehicle               = nil
local BlipVehicleDeleter		= nil
local Blips                     = {}
local OnJob                     = false
local Done 						= false
local Freezethem 				= false
local showpromppost             = 1
 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
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
	onDuty = false
	CreateBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	onDuty = false
	CreateBlip()
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 5,
    modBrakes       = 4,
    modTransmission = 4,
    modSuspension   = 5,
    modTurbo        = true,
  }
  ESX.Game.SetVehicleProperties(vehicle, props)
end

-- NPC MISSIONS
function SelectPost()
    local index = GetRandomIntInRange(1,  #Config.Post)

    for k,v in pairs(Config.Zones) do
        if v.Pos.x == Config.Post[index].x and v.Pos.y == Config.Post[index].y and v.Pos.z == Config.Post[index].z then
       return k
     end
  end
end

function StartNPCJob()

    NPCTargetPost  = SelectPost()
    local zone     = Config.Zones[NPCTargetPost]

    Blips['NPCTargetPost'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
    SetBlipRoute(Blips['NPCTargetPost'], true)
    ESX.ShowNotification(_U('GPS_info'))
    Done = true
end

function StopNPCJob(cancel)

    if Blips['NPCTargetPost'] ~= nil then
      RemoveBlip(Blips['NPCTargetPost'])
      Blips['NPCTargetPost'] = nil
	end

	OnJob = false
	TriggerServerEvent('esx_auspost:GiveItem')
    Done = true
end

function StopNPCJob2(cancel)

    if Blips['NPCTargetPost'] ~= nil then
      RemoveBlip(Blips['NPCTargetPost'])
      Blips['NPCTargetPost'] = nil
	end

	OnJob = false
    Done = true
end	


Citizen.CreateThread(function()
while true do
    Citizen.Wait(1)

    if NPCTargetPost ~= nil then
       local coords = GetEntityCoords(GetPlayerPed(-1))
       local zone   = Config.Zones[NPCTargetPost]

        if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < 3 and showpromppost == 1 then
           HelpPromt(_U('pickup'))
               			     		
	     if not IsPedInAnyVehicle(PlayerPedId(), false) then 	
		 
          if IsControlJustReleased(1, Keys["G"]) and ESX.PlayerData.job ~= nil then
			 showpromppost = 0
             RequestAnimDict('mp_am_hold_up')
			 Freezethem = true				

             while not HasAnimDictLoaded('mp_am_hold_up') do
             Wait(100)
             end
			 
			 TaskPlayAnim(PlayerPedId(), 'mp_am_hold_up', 'purchase_beerbox_shopkeeper', 8.0, -8, -1, 49, 0, 0, 0, 0)
	         FreezeEntityPosition(PlayerPedId(), true)				
				
			 Wait(3500)
							 
	         FreezeEntityPosition(PlayerPedId(), false)
             ClearPedTasksImmediately(PlayerPedId())
			 StopNPCJob()
		     RemoveBlip(Blips['NPCTargetPost'])
			 Onjob = false
             Done = false
			 Freezethem = false
			 TriggerServerEvent('AGNSkill:AddAusPost', GetPlayerServerId(PlayerId()), (math.random() + 0))
          end
		end
      end
	else
		Citizen.Wait(1000)
	end
  end
end)


Citizen.CreateThread(function()
  while true do
    Wait(0)
    if Freezethem == true then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
      DisableControlAction(0, 24,  true) -- Shoot 
      DisableControlAction(0, 92,  true) -- Shoot in car
      DisableControlAction(0, 75,  true) -- Leave Vehicle	 	  
	  DisableControlAction(0, 323, true) -- x
	  DisableControlAction(0, 105, true) -- x
	  DisableControlAction(0, 73,  true) -- x
	  DisableControlAction(0, 73,  true) -- z
      DisableControlAction(0, 244,  true) -- m	  
	  DisableControlAction(0, 29,  true) -- Point
	  DisableControlAction(0, 22,  true) -- Jump
      DisableControlAction(0, 25,  true) -- disable aim
      DisableControlAction(0, 47,  true) -- disable weapon
      DisableControlAction(0, 58,  true) -- disable weapon
      DisableControlAction(0, 37,  true) -- TAB
      DisableControlAction(0, 243, true) -- ~/Phone	  
      DisableControlAction(0, 289, true) -- F2/Inventory  
      DisableControlAction(0, 170, true) -- F3/Inventory		  
      DisableControlAction(0, 263, true) -- disable melee
      DisableControlAction(0, 264, true) -- disable melee
      DisableControlAction(0, 257, true) -- disable melee
      DisableControlAction(0, 140, true) -- disable melee
      DisableControlAction(0, 141, true) -- disable melee
      DisableControlAction(0, 143, true) -- disable melee
	  DisableControlAction(0, 110, true) -- Numpad5  
	  SetPedCanPlayGestureAnims(playerPed, false)	  	  
    end
  end
end)

-- Prise de service
function CloakRoomMenu()

	local elements = {}

	if onDuty then
		table.insert(elements, {label = _U('end_service'), value = 'citizen_wear'})
		table.insert(elements, {label = 'Get Vehicle',     value = 'Get_Vehicle'})
		table.insert(elements, {label = 'Cash Cheques', value = 'cheque'})
	else
		table.insert(elements, {label = 'Cash Cheques', value = 'cheque'})
		table.insert(elements, {label = _U('take_service'), value = 'job_wear'})
	end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'cloakroom',
        {
            title = 'Auspost CloakRoom',
			align    = 'bottom-right',
			css      = 'anim',
            elements = elements
        },
        function(data, menu)
		
		if data.current.value == 'Get_Vehicle' then
           VehicleMenu()
        end

            if data.current.value == 'citizen_wear' then
			   local health = GetEntityHealth(PlayerPedId())
			   
	        if health >= 150 then
				onDuty = false
				CreateBlip()
				menu.close()
                ESX.ShowNotification(_U('end_service_notif'))
				
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then				
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
				  TriggerEvent('esx:restoreLoadout')
				  ClearPedBloodDamage(PlayerPedId())
				  ResetPedVisibleDamage(PlayerPedId())
				  ClearPedLastWeaponDamage(PlayerPedId())
				  StopNPCJob2(true)
		          RemoveBlip(Blips['NPCTargetPost'])
		          Onjob = false
				end)				
			else 
		          ESX.ShowNotification("You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
		       end
			end
			
			if data.current.value == 'cheque' then
				menu.close()
				ESX.TriggerServerCallback('esx_auspost:hasCheque', function(callback)
					if callback then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "Selling Cheque",
							duration = 2000,
							label = "Selling Cheque",
							useWhileDead = false,
							canCancel = false,
										
							controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						   },
							animation = {
							animDict = "mp_common",
							anim = "givetake2_a",
						   },
						  }, function(status)		 
							ESX.TriggerServerCallback('AGNSkill:GetAusPostSkill', function(auspost)	
								Value = tonumber(auspost)
								TriggerServerEvent('esx_auspost:startVente', Value)			  
							end)							                      				  
							ClearPedTasks(PlayerPedId())
							CurrentAction     = 'cloakroom_menu'
							CurrentActionMsg  = Config.Zones.Cloakroom.hint
							CurrentActionData = {}
						end) 	 
					else
						ESX.ShowNotification("~r~You do not have any cheques to cash")
					end
				end)
			end
			

            if data.current.value == 'job_wear' then
			   local health = GetEntityHealth(PlayerPedId())
			   male         = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	           femalemale   = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
			   
	        if health >= 150 then
				onDuty = true
				CreateBlip()
                menu.close()
				
			if male or femalemale then	
				
		        ESX.ShowNotification(_U('take_service_notif'))				
				setUniform(data.current.value, PlayerPedId())
				ClearPedBloodDamage(PlayerPedId())
				ResetPedVisibleDamage(PlayerPedId())
				ClearPedLastWeaponDamage(PlayerPedId())
		    else	
				ESX.ShowNotification(_U('take_service_notif'))				
				ClearPedBloodDamage(PlayerPedId())
				ResetPedVisibleDamage(PlayerPedId())
				ClearPedLastWeaponDamage(PlayerPedId())
			 end	
			    CloakRoomMenu()
           else 
		        ESX.ShowNotification("You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
		     end					 
           end		  		   
            CurrentAction     = 'cloakroom_menu'
            CurrentActionMsg  = Config.Zones.Cloakroom.hint
            CurrentActionData = {}
        end,
        function(data, menu)

            menu.close()
			CurrentAction     = 'cloakroom_menu'
			CurrentActionMsg  = Config.Zones.Cloakroom.hint
            CurrentActionData = {}
        end
     )
end

function VehicleMenu()

    local elements = {
        {label = Config.Vehicles.Truck.Label, value = Config.Vehicles.Truck}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'spawn_vehicle',
        {
            title    = _U('Vehicle_Menu_Title'),
			align    = 'bottom-right',
			css      = 'anim',
            elements = elements
        },
        function(data, menu)
            for i=1, #elements, 1 do
				menu.close()
				
		    local coords    = Config.Zones.VehicleSpawnPoint.Pos
			local Heading    = Config.Zones.VehicleSpawnPoint.Heading				
		    local vehicleNearPoint = GetClosestVehicle(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 3.0, 0, 71)
			
            if not DoesEntityExist(vehicleNearPoint) and not IsAnyVehicleNearPoint(Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 6.0) then
				
				ESX.Game.SpawnVehicleaa7b(data.current.value.Hash, coords, Heading, function(vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				exports["LegacyFuel"]:SetFuel(vehicle, 100)
				SetVehicleMaxMods(vehicle)
				SetVehicleDirtLevel(vehicle, 0)
                platenum = math.random(100000, 999999)				
				SetVehicleNumberPlateText(vehicle, "CR"..platenum) 
                plaquevehicule = "CR"..platenum						
			    ESX.ShowNotification(_U('start_job'))
				SetEntityAsMissionEntity(vehicle, true, true)
			    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
                TriggerServerEvent('esx_auspost:removedep', Config.caution)
			    ESX.ShowNotification("~r~$500 ~w~Deposit Has Now Been Taken From You To Rent The Vehicle")	
                CurrentAction = nil
	            ESX.UI.Menu.CloseAll()				
			 end)
			    Citizen.Wait(250)
		        TriggerEvent("fuel:SetNewData", 100)			 
			else
                ESX.ShowNotification("Action ~r~Denied! ~g~Please ~w~Wait For The Current Vehicle To ~g~Move ~w~First")
			 end
				break
           end
              menu.close()
        end,
        function(data, menu)
           menu.close()
           CurrentAction     = 'cloakroom_menu'
           CurrentActionMsg  = Config.Zones.VehicleSpawner.hint
           CurrentActionData = {}
        end
     )
end

AddEventHandler('esx_auspost:hasEnteredMarker', function(zone)

    if zone == 'Cloakroom' then
        CurrentAction        = 'cloakroom_menu'
        CurrentActionMsg     = Config.Zones.Cloakroom.hint
        CurrentActionData    = {}
    end

    if zone == 'VehicleDeleter' then
	   print('yes')
        local playerPed = GetPlayerPed(-1)
		
        if IsPedInAnyVehicle(playerPed,  false) then
           CurrentAction        = 'delete_vehicle'
           CurrentActionMsg     = Config.Zones.VehicleDeleter.hint
           CurrentActionData    = {}
        end
    end
	
end)


AddEventHandler('esx_auspost:hasExitedMarker', function(zone)
       CurrentAction = nil
	   ESX.UI.Menu.CloseAll()
end)

function CreateBlip()

    if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.nameJob then
	
		if BlipCloakRoom == nil then
			BlipCloakRoom = AddBlipForCoord(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z)
			SetBlipSprite(BlipCloakRoom, Config.Zones.Cloakroom.BlipSprite)
			SetBlipColour(BlipCloakRoom, Config.Zones.Cloakroom.BlipColor)
			SetBlipAsShortRange(BlipCloakRoom, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Zones.Cloakroom.BlipName)
			EndTextCommandSetBlipName(BlipCloakRoom)
		end
	else
	
        if BlipCloakRoom ~= nil then
            RemoveBlip(BlipCloakRoom)
            BlipCloakRoom = nil
        end
	end

	if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.nameJob and onDuty then

        BlipVehicleDeleter = AddBlipForCoord(Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z)
        SetBlipSprite(BlipVehicleDeleter, Config.Zones.VehicleDeleter.BlipSprite)
        SetBlipColour(BlipVehicleDeleter, Config.Zones.VehicleDeleter.BlipColor)
        SetBlipAsShortRange(BlipVehicleDeleter, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Zones.VehicleDeleter.BlipName)
        EndTextCommandSetBlipName(BlipVehicleDeleter)
    else

        if BlipVehicle ~= nil then
            RemoveBlip(BlipVehicle)
            BlipVehicle = nil
        end

        if BlipVente ~= nil then
            RemoveBlip(BlipVente)
            BlipVente = nil
        end

        if BlipVehicleDeleter ~= nil then
            RemoveBlip(BlipVehicleDeleter)
            BlipVehicleDeleter = nil
        end
    end
end


Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		if ESX.PlayerData.job ~= nil then
		   local coords = GetEntityCoords(GetPlayerPed(-1))

			if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.nameJob then
				
			   if onDuty then

					for k,v in pairs(Config.Zones) do
						if v ~= Config.Zones.Cloakroom and v ~= Config.Zones.Vente then
							if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
								DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
							end
						end
					end
				end

				    local Cloakroom = Config.Zones.Cloakroom
				if (Cloakroom.Type ~= -1 and GetDistanceBetweenCoords(coords, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, true) < Config.DrawDistance) then
				    DrawMarker(Cloakroom.Type, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Cloakroom.Size.x, Cloakroom.Size.y, Cloakroom.Size.z, Cloakroom.Color.r, Cloakroom.Color.g, Cloakroom.Color.b, 100, false, true, 2, false, false, false, false)
				end
			else
				Citizen.Wait(2000)
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		if ESX.PlayerData.job ~= nil then
		
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			if ESX.PlayerData.job.name == Config.nameJob then
				if onDuty then
					for k,v in pairs(Config.Zones) do
						if v ~= Config.Zones.Cloakroom then
							if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) <= v.Size.x) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end

				local Cloakroom = Config.Zones.Cloakroom
				if(GetDistanceBetweenCoords(coords, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, true) <= 0.5) then
					isInMarker  = true
					currentZone = "Cloakroom"
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_auspost:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_auspost:hasExitedMarker', LastZone)
			else
				Citizen.Wait(1000)
			end
		end
	end
end)

-- Action après la demande d'accés
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == Config.nameJob then
		
        if CurrentAction ~= nil then
           SetTextComponentFormat('STRING')
           AddTextComponentString(CurrentActionMsg)
           DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						
            if (IsControlJustReleased(1, Keys["E"]) or IsControlJustReleased(2, Keys["RIGHT"])) then
			    local playerPed = GetPlayerPed(-1)
			

				
					if CurrentAction == 'cloakroom_menu' then
					
						if IsPedInAnyVehicle(playerPed, 0) then
							ESX.ShowNotification(_U('in_vehicle'))
						else
							CloakRoomMenu()
						 end
					 end
					
					if CurrentAction == 'vehiclespawn_menu' then
					
						if IsPedInAnyVehicle(playerPed, 0) then
							ESX.ShowNotification(_U('in_vehicle'))
						else
							VehicleMenu()
						 end
					 end

					if CurrentAction == 'delete_vehicle' then
					   local vehicle   = GetVehiclePedIsIn(PlayerPedId(),  false)
					   local hash      = GetEntityModel(vehicle)
					  
					   VerifPlaqueVehiculeActuel()

					if plaquevehicule == plaquevehiculeactuel then
					   local truck = Config.Vehicles.Truck

						if hash == GetHashKey(truck.Hash) then
							if GetVehicleEngineHealth(vehicle) <= 500 or GetVehicleBodyHealth(vehicle) <= 500 then
								ESX.ShowNotification(_U('vehicle_broken'))
							else
								DeleteVehicle(vehicle)
							    StopNPCJob2(true)
		                        RemoveBlip(Blips['NPCTargetPost'])
		                        Onjob = false
								DeleteVehicle(vehicle)
								TriggerServerEvent('esx_auspost:givedep', Config.caution)
								ESX.ShowNotification("~r~$500 ~w~Deposit Has Now Been Given Back To You For The Vehicle Rent")
							end
						end
					  else
						ESX.ShowNotification(('~b~Checking ~w~Paperwork. ~g~Please Wait~w~.....'))
						Wait(3000)
						ESX.ShowNotification(('~r~Sorry! ~g~Your ID ~w~Does ~r~Not ~w~Match The Person Who Rented This ~b~Vehicle. '))
					  end
					end
               	    CurrentAction = nil
				end
			end
		
		else
			Citizen.Wait(1000)
		end
	end
end)

function VerifPlaqueVehiculeActuel()
	plaquevehiculeactuel = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == Config.nameJob then
			if IsControlJustReleased(1, Keys["G"]) and not Onjob and IsPedInAnyVehicle(PlayerPedId(),  false) and IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(),  false), GetHashKey("postvan")) then --Start Job [G]		
				VerifPlaqueVehiculeActuel()
				if plaquevehicule == plaquevehiculeactuel then
					if IsPedInAnyVehicle(PlayerPedId(),  false) and IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(),  false), GetHashKey("postvan")) then
						StartNPCJob()
						Onjob = true
						showpromppost = 1
					else
						ESX.ShowNotification(_U('not_good_veh'))
					end
				else
					ESX.ShowNotification(('~r~Sorry! ~g~Your ID ~w~Does ~r~Not ~w~Match The Person Who Rented This ~b~Vehicle. '))
				end
			end
		else
			Citizen.Wait(1000)
		end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         if Onjob == true then
--             DisableControlAction(0, 47, true) 
--         end
--     end
-- end)

function setUniform(job, playerPed)
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

Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_jay_norris"))
    while not HasModelLoaded(GetHashKey("ig_jay_norris")) do
      Wait(1)
    end
	
    local AuspostPed = CreatePed(4, 0x7A32EE74, 53.52, 114.63, 78.20, 346.85, false, true)
    SetEntityHeading(AuspostPed, 346.85)
    FreezeEntityPosition(AuspostPed, true)
    SetEntityInvincible(AuspostPed, true)
    SetBlockingOfNonTemporaryEvents(AuspostPed, true)
	SetModelAsNoLongerNeeded(AuspostPed)
end)

function HelpPromt(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)
	end)
end