ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function ()
	while true do
		local sleep = 500
		
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),  Config.Marker.x, Config.Marker.y, Config.Marker.z, true) < 10 then
		   sleep = 5
           DrawMarker(Config.Marker.type, Config.Marker.x, Config.Marker.y, Config.Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
		   
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),  Config.Marker.x, Config.Marker.y, Config.Marker.z, true) < 1 then
		   sleep = 5
		   DisplayHelpText("Press ~INPUT_PICKUP~ To Access The ~b~Job Center")
			
		 if (IsControlJustReleased(1, 51)) then
			SetNuiFocus( true, true )
			SendNUIMessage({
			ativa = true
		  })
	    end
	  end
    end
	Citizen.Wait(sleep)
  end
end)

RegisterNUICallback('1', function(data, cb)

    SetNuiFocus( false )
	  SendNUIMessage({
	  ativa = false
	})
  	  cb('ok')
	 
	TriggerEvent("mythic_progbar:client:progress", {
        name = "Doing Interview",
        duration = 10000,
        label = "Filling Out Paperwork",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
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
         TriggerServerEvent('esx_jk_jobs:setJobLandscaper')			   			   
		 ClearPedTasks(PlayerPedId())
    end) 	 	 	 	 	    
end)

RegisterNUICallback('2', function(data, cb)
	
	SetNuiFocus( false )
	  SendNUIMessage({
	  ativa = false
	})
  	  cb('ok')
	  
	TriggerEvent("mythic_progbar:client:progress", {
        name = "Doing Interview",
        duration = 10000,
        label = "Filling Out Paperwork",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
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
         TriggerServerEvent('esx_jk_jobs:setJobRoadworker')			   			   
		 ClearPedTasks(PlayerPedId())
    end)				
end)

RegisterNUICallback('3', function(data, cb)

    SetNuiFocus( false )
	  SendNUIMessage({
	  ativa = false
	})
  	  cb('ok')
		
	TriggerEvent("mythic_progbar:client:progress", {
        name = "Doing Interview",
        duration = 10000,
        label = "Filling Out Paperwork",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
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
         TriggerServerEvent('esx_jk_jobs:setJobAusPost')			   			   
		 ClearPedTasks(PlayerPedId())
    end)	
end)

RegisterNUICallback('4', function(data, cb)

    SetNuiFocus( false )
	    SendNUIMessage({
	    ativa = false
	 })
  	   cb('ok')
	
	TriggerEvent("mythic_progbar:client:progress", {
        name = "Doing Interview",
        duration = 10000,
        label = "Filling Out Paperwork",
        useWhileDead = false,
        canCancel = false,
					
        controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
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
         TriggerServerEvent('esx_jk_jobs:setJobTrucker')			   			   
		 ClearPedTasks(PlayerPedId())		 		 
    end)
end)

RegisterNUICallback('fechar', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
  	cb('ok')
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
  
   RequestModel(GetHashKey("ig_kerrymcintosh"))
   while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
      Wait(1)
   end
  
   local JobCenterPed = CreatePed(4, 0x5B3BD90D, -235.08, -922.11, 31.21, 345.16, false, true)
   SetEntityHeading(JobCenterPed, 345.16)
   FreezeEntityPosition(JobCenterPed, true)
   SetEntityInvincible(JobCenterPed, true)
   SetBlockingOfNonTemporaryEvents(JobCenterPed, true)
   SetModelAsNoLongerNeeded(JobCenterPed)
end)

Citizen.CreateThread(function()	
	local JC = AddBlipForCoord(Config.Marker.x, Config.Marker.y, Config.Marker.z)

	SetBlipSprite (JC, 407)
	SetBlipDisplay(JC, 4)
	SetBlipScale  (JC, 1.2)
	SetBlipColour (JC, 27)
	SetBlipAsShortRange(JC, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Job Center")
	EndTextCommandSetBlipName(JC)
end)