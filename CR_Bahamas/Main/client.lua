ESX                = nil
local menuOpen     = false
local wasOpen      = false
local currentopen  = false
local dict         = "scr_ba_club"
local particleName = "scr_ba_club_smoke_machine"
xSound = exports.xsound

Citizen.CreateThread(function()
	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('Bahamas:PlayMusic')
AddEventHandler('Bahamas:PlayMusic', function(URL, Vol)
    -- pos = {x = 335.95, y = -924.12, z = 29.79}
    pos = vector3(335.95, -924.12, 29.79)
    xSound:PlayUrlPos("Bahamas", URL, 1, pos)
    xSound:Distance("Bahamas", 16)
	xSound:setVolume("Bahamas", Vol) 
end)

Citizen.CreateThread(function()
 while true do
	Citizen.Wait(0)
		
	local playerPos = GetEntityCoords(PlayerPedId())	
	local DJ = vector3(337.75, -917.76, 29.49)
    local distance = #(playerPos - DJ)
	 
     if distance < 2.0 then	
      
        if not menuOpen then
	 
	    if currentopen == false then
		    DrawM('[~b~Press ~w~[~g~E~w~] To Change The ~b~Music~w~]', 27, 337.75, -917.76, 29.49)	
		 end

		if IsControlJustReleased(0, 38) and currentopen == false then
		   wasOpen = true
		   currentopen = true
		   
		   ESX.TriggerServerCallback('Bahamas:DJCheck', function(Staff) 
		   if Staff then	
		   
	          OpenMainMenu()
			  local dict, anim = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', 'hi_dance_facedj_13_v1_male^6'	   										
	          ESX.Streaming.RequestAnimDict(dict)
		      TaskPlayAnim(PlayerPedId(), dict ,anim ,8.0, -8.0, -1, 1, 0, false, false, false )
		  else   				   	
			  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Do Not Have Discord Perms To Use This', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		   end
		 end)	 
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
			Citizen.Wait(1000)
	     end
     end
end)

function OpenMainMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Bahamas',
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
		
		if xSound:soundExists("Bahamas") then
		
		   Pause = xSound:isPaused("Bahamas")

            if not Pause then		   
		       TriggerServerEvent('Bahamas:MusicControl', true)		 
	       else
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Music Is Already Paused', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		    end			
		  end
								
		elseif data.current.value == 'Play' then
		
		if xSound:soundExists("Bahamas") then
		
		    Pause = xSound:isPaused("Bahamas")

			if Pause then
		       TriggerServerEvent('Bahamas:MusicControl', false)		 
	       else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Music Is Not Paused', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   
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
               TriggerServerEvent('Bahamas:SetVolume', 'Default', 0.10)					   
				
			elseif data3.current.value == '+' then
			
			if xSound:soundExists("Bahamas") then
			
			   Vol = xSound:getVolume("Bahamas")	   
               Vol = Vol +0.1	
			   
			if Vol < 1.0 then
	           TriggerServerEvent('Bahamas:SetVolume', 'Higher', Vol)		 
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Max Volume Reached!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   			   
            end
          end			
			
			elseif data3.current.value == '-' then
			
			if xSound:soundExists("Bahamas") then
			
			   Vol = xSound:getVolume("Bahamas")	   
               Vol = Vol -0.1
			
			if Vol > 0.1 then
	           TriggerServerEvent('Bahamas:SetVolume', 'Lower', Vol)
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Min Volume Reached!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   
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
			   TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=DY_rFed96mg")  
				
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
                   TriggerServerEvent('Bahamas:SetStation', URL)   			   
                   menu2.close()
				   break	
                end				
			  end				
			else
                local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~BAHAMAS ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Must Enter A URL To Use This!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)				
			 end
         end,
            function(data2, menu2)
			   menu2.close()
            end
          )		 		
			elseif data2.current.value == 'Tomorrowland' then
			   TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=DY_rFed96mg") 		
		  
            -- elseif data2.current.value == 'Progressive' then
			--    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=d8Oc90QevaI") 			  
 		  
            -- elseif data2.current.value == 'House' then
			--    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=PtYe4GwOlNs") 
			   
			-- elseif data2.current.value == 'Tropical' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=htoiDVRh6e4")  
			   
			-- elseif data2.current.value == 'Vocal' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=C6_ql03n-vQ")  
			  
			-- elseif data2.current.value == 'Trap' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=BwuwYELL-tg")   
			   
			-- elseif data2.current.value == 'HHRnB' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=L9Q1HUdUMp0") 
			   
			-- elseif data2.current.value == 'HHRap' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=mNgSEOsWDmc")     
			   
            -- elseif data2.current.value == 'Rap1' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=xDAcHbpl-F8")  

            -- elseif data2.current.value == 'Rap2' then
	        --    TriggerServerEvent('Bahamas:SetStation', "https://www.youtube.com/watch?v=dTtshy4KzSY")  
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

RegisterNetEvent('Bahamas:SetVolume')
AddEventHandler('Bahamas:SetVolume', function(lvl, Vol)

    if xSound:soundExists("Bahamas") then

    if lvl == 'Default' then  
	   xSound:setVolumeMax("Bahamas", Vol)     
    elseif lvl == 'Higher' then   	  
	   xSound:setVolumeMax("Bahamas", Vol)	
	elseif lvl == 'Lower' then	
	   xSound:setVolumeMax("Bahamas", Vol)
    end  
  end
end)

RegisterNetEvent('Bahamas:MusicControl')
AddEventHandler('Bahamas:MusicControl', function(Action)

    if xSound:soundExists("Bahamas") then
  
    if Action == true then
	   xSound:Pause("Bahamas")
	end
	
	if Action == false then
	   xSound:Resume("Bahamas")
    end  
  end
end)

RegisterNetEvent('Bahamas:SetStation')
AddEventHandler('Bahamas:SetStation', function(URL)

   if xSound:soundExists("Bahamas") then

    Vol = xSound:getVolume("Bahamas")	   

	-- pos = {x = 335.95, y = -924.12, z = 29.79}
    pos = vector3(335.95, -924.12, 29.79)
    xSound:PlayUrlPos("Bahamas", URL, 1, pos)
    xSound:Distance("Bahamas", 16)
	xSound:setVolume("Bahamas", Vol)
 end	
end)

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.3)
end

--Bahamas Peds
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("u_m_y_staggrm_01"))
	
    while not HasModelLoaded(GetHashKey("u_m_y_staggrm_01")) do
	   Citizen.Wait(1)
    end

    local ClubDj =  CreatePed(4, 0x9194CE03, 336.10, -917.64, 29.47, 178.20, false, true)
    SetEntityHeading(ClubDj, 178.20)
    FreezeEntityPosition(ClubDj, true)
    SetEntityInvincible(ClubDj, true)
    SetBlockingOfNonTemporaryEvents(ClubDj, true)
	Citizen.Wait(2000)
	RequestAnimDict("mini@strip_club@idles@dj@idle_02")
    while (not HasAnimDictLoaded("mini@strip_club@idles@dj@idle_02")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDj, "mini@strip_club@idles@dj@idle_02", "idle_02", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDj)
end)

--Stage Dancer 1
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_F_Y_Stripper_01"))
	
    while not HasModelLoaded(GetHashKey("S_F_Y_Stripper_01")) do
       Citizen.Wait(1)
    end

    local stripperped1 =  CreatePed(4, 0x52580019, 339.63, -917.39, 29.73, 98.45, false, true)
    SetEntityHeading(stripperped1, 98.45)
    FreezeEntityPosition(stripperped1, true)
    SetEntityInvincible(stripperped1, true)
    SetBlockingOfNonTemporaryEvents(stripperped1, true)	  
	RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end  
	TaskPlayAnim(stripperped1, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )	
    SetModelAsNoLongerNeeded(stripperped1)	
end)

--Stage Dancer 2
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_F_Y_Stripper_01"))
	
    while not HasModelLoaded(GetHashKey("S_F_Y_Stripper_01")) do
       Citizen.Wait(1)
    end

    local stripperped1 =  CreatePed(4, 0x52580019, 333.26, -917.28, 29.73, 98.45, false, true)
    SetEntityHeading(stripperped1, 98.45)
    FreezeEntityPosition(stripperped1, true)
    SetEntityInvincible(stripperped1, true)
    SetBlockingOfNonTemporaryEvents(stripperped1, true)	  
	RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end  
	TaskPlayAnim(stripperped1, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )	
    SetModelAsNoLongerNeeded(stripperped1)	
end)

--Floor Dancer1
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("a_f_m_beach_01"))
	
    while not HasModelLoaded(GetHashKey("a_f_m_beach_01")) do
       Citizen.Wait(1)
    end

    local ClubDancer =  CreatePed(4, 0x303638A7, 332.50, -922.19, 28.79, 93.24, false, true)
    SetEntityHeading(ClubDancer, 93.24)
    FreezeEntityPosition(ClubDancer, true)
    SetEntityInvincible(ClubDancer, true)
    SetBlockingOfNonTemporaryEvents(ClubDancer, true)
    Citizen.Wait(2000)
	RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDancer, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDancer)
end)

--Floor Dancer2
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("g_f_y_lost_01"))
    while not HasModelLoaded(GetHashKey("g_f_y_lost_01")) do
       Citizen.Wait(1)
    end

    local ClubDancer2 =  CreatePed(4, 0xFD5537DE, 334.08, -923.10, 28.79, 93.24, false, true)
    SetEntityHeading(ClubDancer2, 93.24)
    FreezeEntityPosition(ClubDancer2, true)
    SetEntityInvincible(ClubDancer2, true)
    SetBlockingOfNonTemporaryEvents(ClubDancer2, true)
	Citizen.Wait(2000)
	RequestAnimDict("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")
    while (not HasAnimDictLoaded("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDancer2, "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_15_v1_female^1", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDancer2)
end)

--Floor Dancer3
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("a_m_y_eastsa_02"))
	
    while not HasModelLoaded(GetHashKey("a_m_y_eastsa_02")) do
       Citizen.Wait(1)
    end

    local ClubDancer2 =  CreatePed(4, 0x168775F6, 335.89, -921.53, 28.79, 6.84, false, true)
    SetEntityHeading(ClubDancer2, 6.84)
    FreezeEntityPosition(ClubDancer2, true)
    SetEntityInvincible(ClubDancer2, true)
    SetBlockingOfNonTemporaryEvents(ClubDancer2, true)
	Citizen.Wait(2000)
	RequestAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")
    while (not HasAnimDictLoaded("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDancer2, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_down", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDancer2)
end)

--Floor Dancer4
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("csb_jackhowitzer"))
	
    while not HasModelLoaded(GetHashKey("csb_jackhowitzer")) do
       Citizen.Wait(1)
    end

    local ClubDancer2 =  CreatePed(4, 0x44BC7BB1, 338.31, -922.24, 28.79, 177.09, false, true)
    SetEntityHeading(ClubDancer2, 177.09)
    FreezeEntityPosition(ClubDancer2, true)
    SetEntityInvincible(ClubDancer2, true)
    SetBlockingOfNonTemporaryEvents(ClubDancer2, true)
	Citizen.Wait(2000)
	RequestAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")
    while (not HasAnimDictLoaded("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDancer2, "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "high_center", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDancer2)
end)

--Floor Dancer5
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("ig_kerrymcintosh"))
	
    while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
       Citizen.Wait(1)
    end

    local ClubDancer2 =  CreatePed(4, 0x5B3BD90D, 337.39, -924.70, 28.79, 215.02, false, true)
    SetEntityHeading(ClubDancer2, 215.02)
    FreezeEntityPosition(ClubDancer2, true)
    SetEntityInvincible(ClubDancer2, true)
    SetBlockingOfNonTemporaryEvents(ClubDancer2, true)
	Citizen.Wait(2000)
	RequestAnimDict("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")
    while (not HasAnimDictLoaded("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(ClubDancer2, "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v1_female^3", 8.0, -8.0, -1, 1, 0, false, false, false )
    SetModelAsNoLongerNeeded(ClubDancer2)
end)

--Chair Dancer
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("S_F_Y_Stripper_01"))
	
    while not HasModelLoaded(GetHashKey("S_F_Y_Stripper_01")) do
       Citizen.Wait(1)
    end

    local stripperped1 =  CreatePed(4, 0x52580019, 341.94, -919.88, 29.28, 30.28, false, true)
    SetEntityHeading(stripperped1, 30.28)
    FreezeEntityPosition(stripperped1, true)
    SetEntityInvincible(stripperped1, true)
    SetBlockingOfNonTemporaryEvents(stripperped1, true)	  
	RequestAnimDict("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")
    while (not HasAnimDictLoaded("mini@strip_club@lap_dance@ld_girl_a_song_a_p1")) do Citizen.Wait(0) end  
	TaskPlayAnim(stripperped1, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0, false, false, false )	
    SetModelAsNoLongerNeeded(stripperped1)	
end)

--Bartended Front
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
       Citizen.Wait(1)
    end

    local stripperpedbar2 =  CreatePed(4, 0xE5A11106, 322.99, -920.37, 28.29, 171.49, false, true)
    SetEntityHeading(stripperpedbar2, 171.49)
    FreezeEntityPosition(stripperpedbar2, true)
    SetEntityInvincible(stripperpedbar2, true)
    SetBlockingOfNonTemporaryEvents(stripperpedbar2, true)	  
    SetModelAsNoLongerNeeded(stripperpedbar2)
end)

--Bartended Back
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_barman_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_y_barman_01")) do
       Citizen.Wait(1)
    end

    local stripperpedbar2 =  CreatePed(4, 0xE5A11106, 350.63, -921.05, 28.79, 87.79, false, true)
    SetEntityHeading(stripperpedbar2, 87.79)
    FreezeEntityPosition(stripperpedbar2, true)
    SetEntityInvincible(stripperpedbar2, true)
    SetBlockingOfNonTemporaryEvents(stripperpedbar2, true)	  
    SetModelAsNoLongerNeeded(stripperpedbar2) 
end)

--Front door guard left
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_y_doorman_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_y_doorman_01")) do
       Citizen.Wait(1)
    end

    local Bouncer =  CreatePed(4, 0x22911304, 309.58, -904.82, 28.29, 92.84, false, true)
    SetEntityHeading(Bouncer, 92.84)
    FreezeEntityPosition(Bouncer, true)
    SetEntityInvincible(Bouncer, true)
    SetBlockingOfNonTemporaryEvents(Bouncer, true)
	RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(Bouncer, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	
    SetModelAsNoLongerNeeded(Bouncer)  
end)

--Front door guard Right
Citizen.CreateThread(function()
    
    RequestModel(GetHashKey("s_m_m_bouncer_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_m_bouncer_01")) do
       Citizen.Wait(1)
    end

    local Bouncer =  CreatePed(4, 0x9FD4292D, 309.58, -909.08, 28.29, 92.00, false, true)
    SetEntityHeading(Bouncer, 92.84)
    FreezeEntityPosition(Bouncer, true)
    SetEntityInvincible(Bouncer, true)
    SetBlockingOfNonTemporaryEvents(Bouncer, true)
	Citizen.Wait(2000)
	RequestAnimDict("amb@world_human_stand_guard@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@idle_a")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(Bouncer, "amb@world_human_stand_guard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false )	
    SetModelAsNoLongerNeeded(Bouncer)  
end)


--Smoke Machines
Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
	
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end   
	
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 337.74, -919.13, 30.36, 10.0, 0.0, 90.0, 5.2, true, true, true)	
end)

Citizen.CreateThread(function()
    RequestNamedPtfxAsset(dict)
	
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end 
	
    UseParticleFxAssetNextCall(dict)
    StartParticleFxLoopedAtCoord(particleName, 334.93, -918.97, 30.36, 10.0, 0.0, 90.0, 5.2, true, true, true)	
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(7)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end