ESX                = nil
local menuOpen     = false
local wasOpen      = false
local currentopen  = false
local menuOpen2    = false
local wasOpen2     = false
local currentopen2 = false
local dict         = "scr_ba_club"
local particleName = "scr_ba_club_smoke_machine"
local Action       = 0

xSound = exports.xsound

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

RegisterNetEvent('CR_Nightclub:PlayMusic')
AddEventHandler('CR_Nightclub:PlayMusic', function(URL, Vol)
    -- pos = {x = 368.99, y = 277.57, z = 91.19}
    pos = vector3(368.99, 277.57, 91.19)
    xSound:PlayUrlPos("Nightclub", URL, 1, pos)
    xSound:Distance("Nightclub", 25)
	xSound:setVolume("Nightclub", Vol) 
end)

Citizen.CreateThread(function()       
    while true do
        Citizen.Wait(250)
        
        while ESX == nil do
           TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
           Citizen.Wait(0)
        end
        
        while not ESX.IsPlayerLoaded() do 
           Citizen.Wait(250)
        end
        
        if ESX.IsPlayerLoaded() then
            
            if xSound:soundExists("Nightclub") then
                
                pos = {x = 368.99, y = 277.57, z = 91.19}
                local ped_coords = GetEntityCoords(GetPlayerPed(-1), true)
                _,_,z = table.unpack(ped_coords)
                
                if z - pos.z > 5 then
                    if not xSound:isPaused("Nightclub") then
                        
                        if xSound:soundExists("Nightclub") then
                           xSound:Pause("Nightclub")
                           Action = 1
                        end
                    end
                    
                elseif z - pos.z < 10 then
                    
                    if xSound:isPaused("Nightclub") and Action == 1 then
                       xSound:Resume("Nightclub")
                       Action = 0
                    end		 
                end	  	
            end	
        end
    end	
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'nightclub' then
            if IsControlJustReleased(0, 167) then
                OpenF6ActionsMenu()
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        
        local playerPos = GetEntityCoords(PlayerPedId())	
        local DJ = vector3(376.15, 275.35, 91.40)
        local Options = vector3(390.88, 269.81, 94.99)
        local distance = #(playerPos - DJ)
        local distance2 = #(playerPos - Options)
        
        
        if distance < 2.0 then	
           sleep = 5
            
            if not currentopen then
                
                DrawM('[~b~Press ~w~[~g~E~w~] To Change The ~b~Music~w~]', 27, 376.15, 275.35, 91.40)	
                
                if IsControlJustReleased(0, 38) and currentopen == false then
                    
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'nightclub' then	
                        
                        wasOpen = true
                        currentopen = true                                                                  
                        OpenMainMenu()
                        
                        local dict, anim = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', 'hi_dance_facedj_13_v1_male^6'	   										
                        ESX.Streaming.RequestAnimDict(dict)
                        TaskPlayAnim(PlayerPedId(), dict ,anim ,8.0, -8.0, -1, 1, 0, false, false, false )
                    else 				   
                        ESX.ShowNotification("Sorry! You Can't Use This")                    
                    end 	 
                end
            end
        else		  
            if wasOpen then
               wasOpen = false
               currentopen = false
               ESX.UI.Menu.CloseAll()
            end		
        end
        
        if distance2 < 0.8 then
           sleep = 5	
            
            if not currentopen2 then
                
                DrawM('[~b~Press ~w~[~g~E~w~] To Open The ~b~Menu~w~]', 27, 390.88, 269.81, 93.99)	
                
                if IsControlJustReleased(0, 38) and currentopen == false then
                    
                    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'nightclub' or ESX.PlayerData.job.name == 'offnightclub' then	
                        
                        wasOpen2 = true
                        currentopen2 = true
						OpenActionMenu()
                    else 				   
                        ESX.ShowNotification("Sorry! You Can't Use This")
                    end							
                end	   
            end
        else		  
            if wasOpen2 then
               wasOpen2 = false
               currentopen2 = false
               ESX.UI.Menu.CloseAll()
            end		
        end	 		 		 
       Citizen.Wait(sleep)		 
    end
end)

function OpenActionMenu()

    local elements = {}
	 
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'offnightclub' then	
       table.insert(elements, {label = 'Go On Duty', value = 'Onduty'})
    end  
	 
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'nightclub' then	
       table.insert(elements, {label = 'Go Off Duty', value = 'OffDuty'})
    end 
	 
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'nightclub' and ESX.PlayerData.job.grade_name == 'boss' then	
       table.insert(elements, {label = 'Boss Actions', value = 'boss_actions'})
    end

    ESX.UI.Menu.CloseAll()
	
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ambulance_actions',
    {
      title    = 'Nightclub Actions',
	  align    = 'bottom-right',
	  css      = 'dj',
      elements = elements
    },
    function(data, menu)
	
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())	
		
		if data.current.value == 'Onduty' then
		
		   ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount) 
	       if canTakeService then 		   
              TriggerServerEvent('duty:Nightclub')
		      ESX.ShowAdvancedNotification('Galaxy Nightclub', '', 'You Are Now ~g~[On Duty]', mugshotStr, 1)
              ESX.UI.Menu.CloseAll()
		      Citizen.Wait(250)
		      OpenActionMenu()
              TriggerServerEvent('GalaxyDutyLog', 'On')
	      else
              ESX.ShowNotification('~r~Max ~w~Players On Duty Reached - ~g~' .. inServiceCount .. '~w~/~y~' .. maxInService)
           end 
        end, 'nightclub')
	 					  
        elseif data.current.value == 'OffDuty' then
		   TriggerServerEvent('duty:Nightclub2')
		   TriggerServerEvent('esx_service:disableService', 'unicorn')
           ESX.ShowAdvancedNotification('Galaxy Nightclub', '', 'You Are Now ~r~[Off Duty]', mugshotStr, 1)		   
		   ESX.UI.Menu.CloseAll()
		   wasOpen2 = false
           currentopen2 = false
           TriggerServerEvent('GalaxyDutyLog', 'Off')
				  	   
        elseif data.current.value == 'boss_actions' then
		   TriggerEvent('c3733e85-777a-8285-4836-20b26c07edbc', 'nightclub', function(data, menu)--Boss Menu	
		      menu.close()
		   end)   
		 end		 
       end,
    function(data, menu)
       menu.close()
	   wasOpen2 = false
       currentopen2 = false
	   ClearPedTasks(GetPlayerPed(-1))
    end
   )
end

--open F6 menu
function OpenF6ActionsMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'galaxy_job_actions', {
        title	= 'Galaxy Worker',
        align	= 'bottom-right',
        css      = 'dj',
        elements = {
            {label = 'Invoice',    value= 'billing'}
        }
    }, function(data, menu)
        if isBusy then return end
        if data.current.value == 'billing' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                title = 'Invoice Amount'
            }, function(data, menu)
                local amount = tonumber(data.value)

                if amount == nil or amount < 0 then
                    ESX.ShowNotification('Amount Invalid')
                else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('No Players Nearby')
                    else
                        ESX.UI.Menu.CloseAll()
                        TriggerServerEvent('qi2yr-473kd-ldk3d-jf73s-3ls3s', GetPlayerServerId(closestPlayer), 'society_nightclub', 'Galaxy Bill - $', amount)
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
  
function OpenMainMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'CR_Nightclub',
        {
        title    = 'DJ Booth',
	    align    = 'bottom-right',
		css      = 'dj',
        elements = {
		    {label = 'Change Music',   value = 'Music'},
		    {label = 'Volume Control', value = 'Volume'},
			{label = 'Pause Music',    value = 'Pause'},
			{label = 'Play Music',     value = 'Play'},
           }
        },
        function(data, menu)
		
		if data.current.value == 'Pause' then
				
		if xSound:soundExists("Nightclub") then
            if not xSound:isPaused("Nightclub") then		   
		       TriggerServerEvent('CR_Nightclub:MusicControl', true)		 
	       else
		       ESX.ShowNotification("Music Is Already Paused")	
		    end
	      end
								
		elseif data.current.value == 'Play' then
		
		if xSound:soundExists("Nightclub") then	
		    if xSound:isPaused("Nightclub") then
		       TriggerServerEvent('CR_Nightclub:MusicControl', false)		 
	       else
		       ESX.ShowNotification("Music Is Not Paused")		
			end
		  end
		  
        elseif data.current.value == 'Volume' then
		
           ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'mobile_vehicle_actions3',
          {
            title    = 'Volume Control',
	        align    = 'bottom-right',
		    css      = 'dj',
            elements = {
                {label = 'Default', value = 'Default'},
			    {label = '+Volume', value = '+'},
			    {label = '-Volume', value = '-'},
               },
            },
            function(data3, menu3)
		  		  
            if data3.current.value == 'Default' then		
               TriggerServerEvent('CR_Nightclub:SetVolume', 'Default', 0.10)					   
				
			elseif data3.current.value == '+' then
			
			if xSound:soundExists("Nightclub") then		
			   Vol = xSound:getVolume("Nightclub")	   
               Vol = Vol +0.1	
			   
			if Vol < 1.0 then
	           TriggerServerEvent('CR_Nightclub:SetVolume', 'Higher', Vol)		 
           else
		       ESX.ShowNotification("Max Volume Reached!")	
            end 
          end			
			
			elseif data3.current.value == '-' then
			
			if xSound:soundExists("Nightclub") then			
			   Vol = xSound:getVolume("Nightclub")	   
               Vol = Vol -0.1
			
			if Vol > 0.1 then
	           TriggerServerEvent('CR_Nightclub:SetVolume', 'Lower', Vol)
           else
	           ESX.ShowNotification("Min Volume Reached!")	
            end				  			   
	      end
	    end 
      end,
         function(data3, menu3)
             menu3.close()
			 currentopen = false
          end
        )
		  	   
        elseif data.current.value == 'Music' then

           ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'mobile_vehicle_actions3',
          {
            title    = 'Station Selection',
	        align    = 'bottom-right',
		    css      = 'dj',
            elements = {
                {label = 'Default Station',   value = 'Default'},
			    {label = 'Custom URL',        value = 'Custom'},
				{label = 'Tomorrowland',      value = 'Tomorrowland'},
				-- {label = 'Progressive House', value = 'Progressive'},
				-- {label = 'Deep House',        value = 'House'},
				-- {label = 'Tropical House',    value = 'Tropical'},			
				-- {label = 'Vocal Trance',      value = 'Vocal'},
				-- {label = 'Trap',              value = 'Trap'},
				-- {label = 'Hip-Hop/RnB',       value = 'HHRnB'},
				-- {label = 'Hip-Hop/Rap',       value = 'HHRap'},
				-- {label = 'Rap Station 1',     value = 'Rap1'},
				-- {label = 'Rap Station 2',     value = 'Rap2'},
               },
            },
            function(data2, menu2)
		  		  
            if data2.current.value == 'Default' then		
			   TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=DY_rFed96mg")  
				
			elseif data2.current.value == 'Custom' then
			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'change_plate_string_input', 
            {
              title = 'Enter The (No Copyright) YT URL'
            },		
            function(data2, menu2)
																																		
            local URL = data2.value 

            string.startswith = function(self, str) 
               return self:find('^' .. str) ~= nil
            end
				
				if URL ~= nil then 

            	for i = 1, #Config.Links do			
				
				if tostring(URL):startswith(Config.Links[i]) then			            	
                   TriggerServerEvent('CR_Nightclub:SetStation', URL)    			   
                   menu2.close()
				   break	
                end				
			  end				
			else
                ESX.ShowNotification("You Must Enter A URL To Use This!")	
			 end
         end,
            function(data2, menu2)
			   menu2.close()
            end
          )		 
		    elseif data2.current.value == 'Tomorrowland' then
			   TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=DY_rFed96mg") 		
		  
            -- elseif data2.current.value == 'Progressive' then
			--    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=d8Oc90QevaI") 			  
 		  
            -- elseif data2.current.value == 'House' then -- Dead
			--    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=PtYe4GwOlNs") 
			   
			-- elseif data2.current.value == 'Tropical' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=htoiDVRh6e4")  
			   
			-- elseif data2.current.value == 'Vocal' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=C6_ql03n-vQ")  
			  
			-- elseif data2.current.value == 'Trap' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=BwuwYELL-tg")   
			   
			-- elseif data2.current.value == 'HHRnB' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=L9Q1HUdUMp0") 
			   
			-- elseif data2.current.value == 'HHRap' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=mNgSEOsWDmc")     
			   
            -- elseif data2.current.value == 'Rap1' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=xDAcHbpl-F8")  

            -- elseif data2.current.value == 'Rap2' then
	        --    TriggerServerEvent('CR_Nightclub:SetStation', "https://www.youtube.com/watch?v=dTtshy4KzSY")  
            end			   
         end,
             function(data2, menu2)
               menu2.close()
			   currentopen = false
            end
           )		   
		end		 
      end,
       function(data, menu)
         menu.close()
	     currentopen = false
		 ClearPedTasks(GetPlayerPed(-1))
      end
    )
end

RegisterNetEvent('CR_Nightclub:SetVolume')
AddEventHandler('CR_Nightclub:SetVolume', function(lvl, Vol)

    if xSound:soundExists("Nightclub") then

    if lvl == 'Default' then  
	   xSound:setVolumeMax("Nightclub", Vol)     
    elseif lvl == 'Higher' then   	  
	   xSound:setVolumeMax("Nightclub", Vol)	
	elseif lvl == 'Lower' then	
	   xSound:setVolumeMax("Nightclub", Vol)
    end 
  end	
end)

RegisterNetEvent('CR_Nightclub:MusicControl')
AddEventHandler('CR_Nightclub:MusicControl', function(Action)

    if xSound:soundExists("Nightclub") then
  
    if Action == true then
	   xSound:Pause("Nightclub")
	end
	
	if Action == false then
	   xSound:Resume("Nightclub")
    end 
  end	
end)

RegisterNetEvent('CR_Nightclub:SetStation')
AddEventHandler('CR_Nightclub:SetStation', function(URL)

    if xSound:soundExists("Nightclub") then

    Vol = xSound:getVolume("Nightclub")	   

	-- pos = {x = 368.99, y = 277.57, z = 91.19}
    pos = vector3(368.99, 277.57, 91.19)
    xSound:PlayUrlPos("Nightclub", URL, 1, pos)
    xSound:Distance("Nightclub", 25)
	xSound:setVolume("Nightclub", Vol)	 
  end	
end)

--Front door guard
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_doorman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_doorman_01")) do
       Citizen.Wait(0) 
    end
    
    local FDoorGuard =  CreatePed(4, 0x22911304, 356.89, 303.37, 102.71, 25.76, false, true)
    SetEntityHeading(FDoorGuard, 25.76)
    FreezeEntityPosition(FDoorGuard, true)
    SetEntityInvincible(FDoorGuard, true)
    SetBlockingOfNonTemporaryEvents(FDoorGuard, true)
	SetModelAsNoLongerNeeded(FDoorGuard)	
	
    RequestAnimDict("missfam4")	
	
    while (not HasAnimDictLoaded("missfam4")) do 
	   Citizen.Wait(0) 
	end 
	
    TaskPlayAnim(FDoorGuard, "missfam4", "base", 8.0, -8.0, -1, 1, 0, false, false, false )	
	
	local x,y,z = table.unpack(GetEntityCoords(FDoorGuard))
	
	while not HasModelLoaded(GetHashKey("p_amb_clipboard_01")) do
       RequestModel(GetHashKey("p_amb_clipboard_01"))
       Citizen.Wait(0) 
    end
	
	prop = CreateObject(GetHashKey("p_amb_clipboard_01"), x, y, z +0.2, false, true, true)
	AttachEntityToEntity(prop, FDoorGuard, GetPedBoneIndex(FDoorGuard, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop)	
end)

--Bartender1 Front
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
       Citizen.Wait(0) 
    end
    
    local Bartender1 =  CreatePed(4, 0xE5A11106, 352.41, 286.34, 90.19, 169.03, false, true)
    SetEntityHeading(Bartender1, 169.03)
    FreezeEntityPosition(Bartender1, true)
    SetEntityInvincible(Bartender1, true)
    SetBlockingOfNonTemporaryEvents(Bartender1, true)
    SetModelAsNoLongerNeeded(Bartender1)	
end)

--Bartended Back
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
       Citizen.Wait(0) 
    end
    
    local Bartender2 =  CreatePed(4, 0xE5A11106, 357.95, 280.65, 93.19, 251.19, false, true)
    SetEntityHeading(Bartender2, 251.19)
    FreezeEntityPosition(Bartender2, true)
    SetEntityInvincible(Bartender2, true)
    SetBlockingOfNonTemporaryEvents(Bartender2, true)	
    SetModelAsNoLongerNeeded(Bartender2)		
end)

--Inside door guard left
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_doorman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_doorman_01")) do
       Citizen.Wait(0) 
    end
    
    local DoorGuard1 =  CreatePed(4, 0x22911304, 345.48, 290.12, 94.78, 30.93, false, true)
    SetEntityHeading(DoorGuard1, 30.93)
    FreezeEntityPosition(DoorGuard1, true)
    SetEntityInvincible(DoorGuard1, true)
    SetBlockingOfNonTemporaryEvents(DoorGuard1, true)
	SetModelAsNoLongerNeeded(DoorGuard1)	
    Wait(2000)
    RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(DoorGuard1, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	  
end)

--Cashier
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
       Citizen.Wait(0) 
    end
    
    local Cashier =  CreatePed(4, 0xE5A11106, 345.87, 285.15, 94.79, 78.70, false, true)
    SetEntityHeading(Cashier, 78.70)
    FreezeEntityPosition(Cashier, true)
    SetEntityInvincible(Cashier, true)
    SetBlockingOfNonTemporaryEvents(Cashier, true)
	SetModelAsNoLongerNeeded(Cashier)	
    Wait(2000)
    RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Cashier, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	  
end)


--Dj 
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("u_m_y_staggrm_01"))
    while not HasModelLoaded(GetHashKey("u_m_y_staggrm_01")) do
       Citizen.Wait(0) 
    end
    
    local ClubDj =  CreatePed(4, 0x9194CE03, 375.27, 276.03, 91.40, 70.73, false, true)
    SetEntityHeading(ClubDj, 70.73)
    FreezeEntityPosition(ClubDj, true)
    SetEntityInvincible(ClubDj, true)
    SetBlockingOfNonTemporaryEvents(ClubDj, true)
	SetModelAsNoLongerNeeded(ClubDj)	
    Wait(2000)
    RequestAnimDict("mini@strip_club@idles@dj@idle_02")
    while (not HasAnimDictLoaded("mini@strip_club@idles@dj@idle_02")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(ClubDj, "mini@strip_club@idles@dj@idle_02", "idle_02", 8.0, -8.0, -1, 1, 0, false, false, false )
end)

--Podium Left dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_F_Y_Stripper_01"))
    while not HasModelLoaded(GetHashKey("S_F_Y_Stripper_01")) do
       Citizen.Wait(0) 
    end
    
    local PodiumDancer1 =  CreatePed(4, 0x52580019, 371.95, 280.04, 90.99, 62.95, false, true)
    SetEntityHeading(PodiumDancer1, 62.95)
    FreezeEntityPosition(PodiumDancer1, true)
    SetEntityInvincible(PodiumDancer1, true)
    SetBlockingOfNonTemporaryEvents(PodiumDancer1, true)
	SetModelAsNoLongerNeeded(PodiumDancer1)
    Wait(2000)
    RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(PodiumDancer1, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )
end)

--Podium Right dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_F_Y_Stripper_01"))
    while not HasModelLoaded(GetHashKey("S_F_Y_Stripper_01")) do
       Citizen.Wait(0) 
    end
    
    local PodiumDancer2 =  CreatePed(4, 0x52580019, 367.33, 273.40, 90.98, 266.83, false, true)
    SetEntityHeading(PodiumDancer2, 266.83)
    FreezeEntityPosition(PodiumDancer2, true)
    SetEntityInvincible(PodiumDancer2, true)
    SetBlockingOfNonTemporaryEvents(PodiumDancer2, true)
	SetModelAsNoLongerNeeded(PodiumDancer2)
    Wait(6000)
    RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(PodiumDancer2, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )
end)


--Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("A_F_Y_Juggalo_01"))
    while not HasModelLoaded(GetHashKey("A_F_Y_Juggalo_01")) do
       Citizen.Wait(0) 
    end
    
    local Dancer1 =  CreatePed(4, 0xDB134533, 371.41, 278.13, 90.19, 254.22, false, true)
    SetEntityHeading(Dancer1, 254.22)
    FreezeEntityPosition(Dancer1, true)
    SetEntityInvincible(Dancer1, true)
    SetBlockingOfNonTemporaryEvents(Dancer1, true)
	SetModelAsNoLongerNeeded(Dancer1)
    Wait(2000)
    RequestAnimDict("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")
    while (not HasAnimDictLoaded("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Dancer1, "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_11_v1_female^2", 8.0, -8.0, -1, 1, 0, false, false, false )
end)

--Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("g_f_y_lost_01"))
    while not HasModelLoaded(GetHashKey("g_f_y_lost_01")) do
       Citizen.Wait(0) 
    end
    
    local Dancer2 =  CreatePed(4, 0xFD5537DE, 371.12, 276.63, 90.19, 213.84, false, true)
    SetEntityHeading(Dancer2, 213.84)
    FreezeEntityPosition(Dancer2, true)
    SetEntityInvincible(Dancer2, true)
    SetBlockingOfNonTemporaryEvents(Dancer2, true)
	SetModelAsNoLongerNeeded(Dancer2)
    Wait(2000)
    RequestAnimDict("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")
    while (not HasAnimDictLoaded("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Dancer2, "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_15_v1_female^1", 8.0, -8.0, -1, 1, 0, false, false, false )
end)

--Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("a_m_y_eastsa_02"))
    while not HasModelLoaded(GetHashKey("a_m_y_eastsa_02")) do
       Citizen.Wait(0) 
    end
    
    local Dancer3 =  CreatePed(4, 0x168775F6, 371.18, 275.64, 90.19, 1.52, false, true)
    SetEntityHeading(Dancer3, 1.52)
    FreezeEntityPosition(Dancer3, true)
    SetEntityInvincible(Dancer3, true)
    SetBlockingOfNonTemporaryEvents(Dancer3, true)
	SetModelAsNoLongerNeeded(Dancer3)
    Wait(2000)
    RequestAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")
    while (not HasAnimDictLoaded("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Dancer3, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_down", 8.0, -8.0, -1, 1, 0, false, false, false )
end)

--Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("csb_jackhowitzer"))
    while not HasModelLoaded(GetHashKey("csb_jackhowitzer")) do
       Citizen.Wait(0) 
    end
    
    local Dancer4 =  CreatePed(4, 0x44BC7BB1, 369.90, 274.36, 90.19, 284.41, false, true)
    SetEntityHeading(Dancer4, 284.41)
    FreezeEntityPosition(Dancer4, true)
    SetEntityInvincible(Dancer4, true)
    SetBlockingOfNonTemporaryEvents(Dancer4, true)
	SetModelAsNoLongerNeeded(Dancer4)
    Wait(2000)
    RequestAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")
    while (not HasAnimDictLoaded("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Dancer4, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", 8.0, -8.0, -1, 1, 0, false, false, false )
end)


--Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_kerrymcintosh"))
    while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
       Citizen.Wait(0) 
    end
    
    local Dancer5 =  CreatePed(4, 0x5B3BD90D, 370.26, 278.15, 90.19, 112.77, false, true)
    SetEntityHeading(Dancer5, 112.77)
    FreezeEntityPosition(Dancer5, true)
    SetEntityInvincible(Dancer5, true)
    SetBlockingOfNonTemporaryEvents(Dancer5, true)
	SetModelAsNoLongerNeeded(Dancer5)
    Wait(2000)
    RequestAnimDict("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")
    while (not HasAnimDictLoaded("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")) do Citizen.Wait(0) end 	  
    TaskPlayAnim(Dancer5, "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v1_female^3", 8.0, -8.0, -1, 1, 0, false, false, false )
end)


Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
       Citizen.Wait(0) 
    end
    
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 362.15, 275.41, 90.19, 10.0, 0.0, 180.0, 5.2, true, true, true)	
    Citizen.Wait(500)
end)

Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
       Citizen.Wait(0)
    end
    
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 367.20, 282.25, 90.19, 50.0, 0.0, 100.0, 5.2, true, true, true)             
    Citizen.Wait(500)  
end)

Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 368.80, 273.45, 90.19, 50.0, 0.0, 220.0, 5.2, true, true, true)             
    Citizen.Wait(500)   
end)

Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
       Citizen.Wait(0)
    end
    
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 376.74, 281.79, 90.19, 50.0, 0.0, 40.0, 5.2, true, true, true)             
    Citizen.Wait(500)  
end)

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.3)
end