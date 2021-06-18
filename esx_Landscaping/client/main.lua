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
local DisablethemL              = false
local showprompland             = 0


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
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
function SelectPool()
    local index = GetRandomIntInRange(1,  #Config.Pool)

    for k,v in pairs(Config.Zones) do
      if v.Pos.x == Config.Pool[index].x and v.Pos.y == Config.Pool[index].y and v.Pos.z == Config.Pool[index].z then
        return k
      end
    end
end

function StartNPCJob()
    NPCTargetPool     = SelectPool()
    local zone            = Config.Zones[NPCTargetPool]

    Blips['NPCTargetPool'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
    SetBlipRoute(Blips['NPCTargetPool'], true)
    ESX.ShowNotification(_U('GPS_info'))
    Done = true

end
function StopNPCJob(cancel)

    if Blips['NPCTargetPool'] ~= nil then
      RemoveBlip(Blips['NPCTargetPool'])
      Blips['NPCTargetPool'] = nil
	end

	OnJob = false
	TriggerServerEvent('esx_Landscaping:GiveItem')
	Done = true
end

function StopNPCJob2(cancel)

    if Blips['NPCTargetPool'] ~= nil then
      RemoveBlip(Blips['NPCTargetPool'])
      Blips['NPCTargetPool'] = nil
	end
	
	OnJob = false
    Done = true
end	

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if NPCTargetPool ~= nil then
           local coords = GetEntityCoords(GetPlayerPed(-1))
           local zone   = Config.Zones[NPCTargetPool]

         if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < 3 and showprompland == 1 then 
            HelpPromt(_U('pickup'))
			
            if IsControlJustReleased(1, Keys["E"]) and ESX.PlayerData.job ~= nil then
			    showprompland = 0
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
			    DisablethemL = true
	            FreezeEntityPosition(PlayerPedId(), true)
									
             Wait(20000)		

			    DisablethemL = false
	            FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasksImmediately(PlayerPedId())
			    StopNPCJob()
				RemoveBlip(Blips['NPCTargetPool'])
			    Onjob = false
                Done = false					
			    TriggerServerEvent('AGNSkill:AddLandscaping', GetPlayerServerId(PlayerId()), (math.random() + 0))
              end				
           end
		else
		Citizen.Wait(1000)
		end
    end
end)


Citizen.CreateThread(function()
  while true do
    Wait(1)
    if DisablethemL == true then
	   SetPedCanPlayGestureAnims(PlayerPedId(), false)	  
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
       DisableControlAction(0, 170, false) -- F3/Inventory		  
       DisableControlAction(0, 263, false) -- disable melee
       DisableControlAction(0, 264, false) -- disable melee
       DisableControlAction(0, 257, false) -- disable melee
       DisableControlAction(0, 140, false) -- disable melee
       DisableControlAction(0, 141, false) -- disable melee
       DisableControlAction(0, 143, false) -- disable melee
	   DisableControlAction(0, 110, true) -- Numpad5  
    end
  end
end)


function CloakRoomMenu()
	local elements = {}

	if onDuty then
		table.insert(elements, {label = 'Cash Payslips', value = 'payslip'})
		table.insert(elements, {label = _U('end_service'), value = 'citizen_wear'})
		table.insert(elements, {label = 'Get Vehicle',     value = 'Get_Vehicle'})
	else
		table.insert(elements, {label = 'Cash Payslips', value = 'payslip'})
		table.insert(elements, {label = _U('take_service'), value = 'job_wear'})
	 end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'cloakroom',
        {
            title = 'CloakRoom',
			align    = 'bottom-right',
			css      = 'meconcernant',
            elements = elements
        },
        function(data, menu)
		
		if data.current.value == 'Get_Vehicle' then
           VehicleMenu()
        end

		if data.current.value == 'payslip' then
			menu.close()
			ESX.TriggerServerCallback('esx_Landscaping:hasCheque', function(callback)
				if callback then
					TriggerEvent("mythic_progbar:client:progress", {
						name = "Selling Payslips",
						duration = 2000,
						label = "Selling Payslips",
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
						ESX.TriggerServerCallback('AGNSkill:GetLandscapingSkill', function(auspost)	
							Value = tonumber(auspost)	
							TriggerServerEvent('esx_Landscaping:startVente', Value)			  
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

        if data.current.value == 'citizen_wear' then
		   local health = GetEntityHealth(GetPlayerPed(-1))
		   
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
				StopNPCJob2(true)
		        RemoveBlip(Blips['NPCTargetPool'])
		        Onjob = false
				ClearPedLastWeaponDamage(PlayerPedId())
			 end)
		 else 
		        ESX.ShowNotification("You Are ~r~Injured! ~w~Call ~r~Ems ~w~Or Go See A ~r~Doctor ~w~First")
		     end
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
			css      = 'meconcernant',
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
				exports["LegacyFuel"]:SetFuel(vehicle, 100)
			    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleMaxMods(vehicle)
				SetVehicleDirtLevel(vehicle, 0)
                platenum = math.random(100000, 999999)				
				SetVehicleNumberPlateText(vehicle, "CR"..platenum) 
                plaquevehicule = "CR"..platenum			
			    ESX.ShowNotification(_U('start_job'))
			    SetEntityAsMissionEntity(vehicle, true, true)
	            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
			    SetModelAsNoLongerNeeded(vehicle)
				TriggerServerEvent('esx_Landscaping:removedep', Config.caution)
				ESX.ShowNotification("~r~$500 ~w~Deposit Has Now Been Taken From You To Rent The Vehicle")
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
            CurrentAction     = 'vehiclespawn_menu'
            CurrentActionMsg  = Config.Zones.VehicleSpawner.hint
            CurrentActionData = {}
         end
      )
end


AddEventHandler('esx_Landscaping:hasEnteredMarker', function(zone)

    if zone == 'Cloakroom' then
        CurrentAction        = 'cloakroom_menu'
        CurrentActionMsg     = Config.Zones.Cloakroom.hint
        CurrentActionData    = {}
    end

    if zone == 'VehicleDeleter' then
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed,  false) then
          CurrentAction        = 'delete_vehicle'
          CurrentActionMsg     = Config.Zones.VehicleDeleter.hint
          CurrentActionData    = {}
        end
    end

    if zone == 'Vente' then
        CurrentAction        = 'vente'
        CurrentActionMsg     = Config.Zones.Vente.hint
        CurrentActionData    = {}
    end
end)

AddEventHandler('esx_Landscaping:hasExitedMarker', function(zone)
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

-- Activation du marker au sol
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if ESX.PlayerData.job ~= nil then
			local coords = GetEntityCoords(GetPlayerPed(-1))

			if ESX.PlayerData.job.name == Config.nameJob then
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
				if(Cloakroom.Type ~= -1 and GetDistanceBetweenCoords(coords, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(Cloakroom.Type, Cloakroom.Pos.x, Cloakroom.Pos.y, Cloakroom.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Cloakroom.Size.x, Cloakroom.Size.y, Cloakroom.Size.z, Cloakroom.Color.r, Cloakroom.Color.g, Cloakroom.Color.b, 100, false, true, 2, false, false, false, false)
				end
			else
				Citizen.Wait(1000)
			end
		end
	end
end)

-- Detection de l'entrer/sortie de la zone du joueur
Citizen.CreateThread(function()
	while true do
		Wait(1)
		CanWait = true
		
		if ESX.PlayerData.job ~= nil then
		
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			if ESX.PlayerData.job.name == Config.nameJob then
				CanWait = false
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
				TriggerEvent('esx_Landscaping:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_Landscaping:hasExitedMarker', LastZone)
			end

			if CanWait then
				Citizen.Wait(1000)
			end
		end
	end
end)

-- Action après la demande d'accés
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
		
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			
            if (IsControlJustReleased(1, Keys["E"]) or IsControlJustReleased(2, Keys["RIGHT"])) and ESX.PlayerData.job ~= nil then
			
				if ESX.PlayerData.job.name == Config.nameJob then
				
					if CurrentAction == 'cloakroom_menu' then
						if IsPedInAnyVehicle(PlayerPedId(), 0) then
							ESX.ShowNotification(_U('in_vehicle'))
						else
							CloakRoomMenu()
						end
					end
					
			if CurrentAction == 'vente' then
			
			    ESX.TriggerServerCallback('AGNSkill:GetLandscapingSkill', function(landscaping)	
			    Value = tonumber(landscaping)	
					
                if Value <  10 then				   		
				       newamount = 135			   
				elseif Value < 20 then
                       newamount = 140
				elseif Value <  30 then
                       newamount = 145
			    elseif Value <  40 then
                       newamount = 150
				elseif Value <  40 then
                       newamount = 155
				elseif Value <  50 then
	                   newamount = 160
				elseif Value <  60 then
	                   newamount = 165
				elseif Value <  70 then
	                   newamount = 170
			    elseif Value <  80 then
		               newamount = 176
				elseif Value <  90 then
	                   newamount = 177		
				elseif Value < 100 then
	                   newamount = 178	
			    elseif Value < 100 then
	                   newamount = 179	
			    elseif Value < 110 then
	                   newamount = 180	
			    elseif Value < 120 then
	                   newamount = 181				   
			    elseif Value < 130 then
		               newamount = 182	
			    elseif Value < 140 then
		               newamount = 183	
				elseif Value < 150 then
			           newamount = 184	
				elseif Value < 160 then
		               newamount = 185	
			    elseif Value < 170 then
			           newamount = 186	
				elseif Value < 180 then
				       newamount = 187	 
			    elseif Value < 190 then
			           newamount = 188	
			    elseif Value < 200 then
			           newamount = 189	
				elseif Value < 250 then
				       newamount = 190						                          
			        end	
                       TriggerServerEvent('esx_Landscaping:startVente', newamount)					
				    end)							                      				  
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
		                      RemoveBlip(Blips['NPCTargetPool'])
		                      Onjob = false
						      DeleteVehicle(vehicle)
						      TriggerServerEvent('esx_Landscaping:givedep', Config.caution)
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
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.nameJob then
			if IsControlJustReleased(1, Keys["G"]) and ESX.PlayerData.job and ESX.PlayerData.job.name == Config.nameJob and not Onjob then --Start Job [G]
			
			VerifPlaqueVehiculeActuel()
			
			if plaquevehicule == plaquevehiculeactuel then

			if IsPedInAnyVehicle(PlayerPedId(),  false) and IsVehicleModel(GetVehiclePedIsIn(PlayerPedId(),  false), GetHashKey("utillitruck4")) then
				StartNPCJob()
				Onjob = true
				showprompland = 1
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
	
    local AuspostPed = CreatePed(4, 0x7A32EE74, -1546.56, -586.47, 33.87, 300.20, false, true)
    SetEntityHeading(AuspostPed, 300.20)
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