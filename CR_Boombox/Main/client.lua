ESX = nil
local menuOpen = false
local wasOpen = false
local lastEntity = nil
local currentData = nil
local radio = nil
local PlacedBoomboxes = 0
RadioChannel = 'Default'
Boomboxes = {}

xSound = exports.xsound

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
	
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end
        
    if ESX.IsPlayerLoaded() then
       TriggerServerEvent('CR_Boombox:SpawnBoomboxes')    
    end    
end)

RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

RegisterNetEvent('CR_Boombox:PlaceTheBox')
AddEventHandler('CR_Boombox:PlaceTheBox', function()
    
    local inventory = ESX.GetPlayerData().inventory
    local count  = 0
    
    for i=1, #inventory, 1 do
        if inventory[i].name == 'boombox' then
           count = inventory[i].count
        end
    end
    
    if (count > 0) then	  
        if PlacedBoomboxes == 0 then
            
            startAnimation("anim@heists@money_grab@briefcase","put_down_case")
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            
            local Ped = PlayerPedId()
            local coords    = GetEntityCoords(Ped)
            local forward   = GetEntityForwardVector(Ped)
            local h = GetEntityHeading(Ped)
            local x, y, z   = table.unpack(coords + forward * 1.0)
            TriggerServerEvent('CR_Boombox:CreateBoombox', x, y, z, h)
            
            local id = 0
            
            if xSound:soundExists('radio'..id) then
                id = id + 1
            else
                radio = 'radio'..id 
            end
            
            Channel = 'radio'..id 
            
            Citizen.Wait(1000)
            local coords = GetEntityCoords(PlayerPedId())       
            Boombox = GetClosestObjectOfType(coords, 3.0, GetHashKey('prop_boombox_01'), false, false, false)
            local objCoords = GetEntityCoords(Boombox)
            
            FreezeEntityPosition(Boombox, true)
            SetEntityCollision(Boombox, false, true)  
            Citizen.Wait(100)			
            TriggerServerEvent('CR_Boombox:SetStation', "https://www.youtube.com/watch?v=DY_rFed96mg", objCoords, Channel)
            TriggerServerEvent('CR_Boombox:TheBox', 'Remove')	
            objPlaced = objCoords			
            PlacedBoomboxes = 1
        else
            ESX.ShowNotification("You Can Only Place One Boombox")	
        end
    else
        ESX.ShowNotification("You Have No Boombox To Place")	
    end
end)

RegisterNetEvent('CR_Boombox:SetStation')
AddEventHandler('CR_Boombox:SetStation', function(URL, objCoords, Channel)  
        
    xSound:PlayUrlPos(Channel, URL, 1, objCoords)    
    xSound:setVolume(Channel, 0.20)
    CurrentVol = xSound:getVolume(Channel)
    NewVol = (CurrentVol * 12)
    xSound:Distance(Channel, NewVol + 5)	
end)

RegisterNetEvent('CR_Boombox:CreateBoombox')
AddEventHandler('CR_Boombox:CreateBoombox',function(id,x,y,z,h)

    local BoomHash = GetHashKey('prop_boombox_01')
    Citizen.CreateThread(function()
        while not HasModelLoaded(BoomHash) do
           RequestModel(BoomHash)
           Citizen.Wait(1)    
        end
    end)
	
    local Boombox = CreateObject(BoomHash, x, y, z, 0, 0, 0)
	DecorSetInt(Boombox ,decorName,decorInt)
    SetEntityHeading(Boombox, h)
    PlaceObjectOnGroundProperly(Boombox)
    SetEntityCollision(Boombox, false, true)
    FreezeEntityPosition(Boombox,true)
    Boomboxes[id] = Boombox
    SetModelAsNoLongerNeeded(Boombox)
end)


RegisterNetEvent('CR_Boombox:RemoveBoombox')
AddEventHandler('CR_Boombox:RemoveBoombox', function(id)

    local obj = Boomboxes[id]
	
    if obj and DoesEntityExist(obj) then
       DeleteObject(obj)
       Boomboxes[id] = nil
    end
end)

RegisterNetEvent('CR_Boombox:PlayMusic')
AddEventHandler('CR_Boombox:PlayMusic', function(URL, Vol, BoomCoords, Channel)

    if xSound:soundExists(Channel) then

       xSound:PlayUrlPos(Channel, URL, 1, BoomCoords)
	   xSound:setVolume(Channel, Vol) 
	   CurrentVol = xSound:getVolume(Channel)
       NewVol = (CurrentVol * 12)
       xSound:Distance(Channel, NewVol + 5)
    end
end)

RegisterNetEvent('CR_Boombox:Destroy')
AddEventHandler('CR_Boombox:Destroy', function(Channel) 

    if xSound:soundExists(Channel) then        
       xSound:Destroy(Channel)
    end
end)

RegisterNetEvent('CR_Boombox:ChangeStation')
AddEventHandler('CR_Boombox:ChangeStation', function(URL, objCoords, Channel, Vol) 

    if xSound:soundExists(Channel) then 
    
	   xSound:PlayUrlPos(Channel, URL, 1, objCoords)   
	   xSound:setVolume(Channel, Vol)	
       CurrentVol = xSound:getVolume(Channel)
	   NewVol = (CurrentVol * 12)
       xSound:Distance(Channel, NewVol + 5)	
    end	   
end)

RegisterNetEvent('CR_Boombox:SetVolume')
AddEventHandler('CR_Boombox:SetVolume', function(lvl, Vol, Channel)  

   if xSound:soundExists(Channel) then
    
    if lvl == 'Default' then  
       xSound:setVolumeMax(Channel, Vol)
       CurrentVol = xSound:getVolume(Channel)
       NewVol = (CurrentVol * 12)
       xSound:Distance(Channel, NewVol + 5)	 
	   
    elseif lvl == 'Higher' then   	  
       xSound:setVolumeMax(Channel, Vol)
       CurrentVol = xSound:getVolume(Channel)
       NewVol = (CurrentVol * 12)
       xSound:Distance(Channel, NewVol + 5)	
	   
    elseif lvl == 'Lower' then	
       xSound:setVolumeMax(Channel, Vol)
       CurrentVol = xSound:getVolume(Channel)
       NewVol = (CurrentVol * 12)
       xSound:Distance(Channel, NewVol + 5)
    end  
  end	
end)

RegisterNetEvent('CR_Boombox:MusicControl')
AddEventHandler('CR_Boombox:MusicControl', function(Action, Channel)

    if xSound:soundExists(Channel) then
    
    if Action == true then
       xSound:Pause(Channel)
    end
    
    if Action == false then
       xSound:Resume(Channel)
    end
  end	
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        
        if PlacedBoomboxes == 1 then	
            
			local Player = PlayerPedId()
            local plyCoords = GetEntityCoords(Player, false)
            local PlacedBoombox = vector3(objPlaced.x, objPlaced.y, objPlaced.z)        
            local distance = #(plyCoords - PlacedBoombox)
            currentAction = nil
            
            if distance < 2 then	
                sleep = 5
                
                if not menuOpen and not IsEntityDead(Player) then                                 
                   currentAction = 'music'                                       
                   DrawM('[~b~Press ~w~[~g~E~w~] To Control The ~b~Boombox~w~]', 27, objPlaced.x, objPlaced.y, objPlaced.z)
                   DrawM('[~b~Press ~w~[~g~G~w~] To Pickup The ~b~Boombox~w~]', 27, objPlaced.x, objPlaced.y, objPlaced.z - 0.08)
                end      
                if xSound:soundExists(Channel) then
                   DrawM('Currently Playing: ~b~'..RadioChannel, 27, objPlaced.x, objPlaced.y, objPlaced.z + 0.1)
                end 	   
                
                if distance < 1.2 then	
				
                    if IsControlJustReleased(0, 38) and not menuOpen and not IsEntityDead(Player) then --E                     
                       OpenMainMenu()
                       wasOpen = true
                       menuOpen = true     
                        
                       local dict, anim = 'amb@world_human_bum_wash@male@low@idle_a', 'idle_a'	   										
                       ESX.Streaming.RequestAnimDict(dict)
                       TaskPlayAnim(Player, dict ,anim ,8.0, -8.0, -1, 1, 0, false, false, false )
                    end
                end
                
                if distance < 1.2 then	
				
                    if IsControlJustReleased(0, 47) and not IsEntityDead(Player) then --G					
                       NetworkRequestControlOfEntity(Boombox)
                       startAnimation("anim@heists@narcotics@trash","pickup")
                       Citizen.Wait(700)
                       SetEntityAsMissionEntity(Boombox, false, true)
                       ESX.Game.DeleteObject(Boombox)          
                       TriggerServerEvent('CR_Boombox:Destroy', Channel)
                       TriggerServerEvent('CR_Boombox:RemoveBoombox') 
                       TriggerServerEvent('CR_Boombox:TheBox', 'Give')			   
                       ClearPedTasks(Player)
                       PlacedBoomboxes = 0
                       RadioChannel = 'Default'
                    end
                end
            else		  
                if wasOpen then
                   wasOpen = false
                   menuOpen = false
                   ESX.UI.Menu.CloseAll()
                end		
            end
            
            if distance > 30 then	
               NetworkRequestControlOfEntity(Boombox) 
               SetEntityAsMissionEntity(Boombox, false, true)
               ESX.Game.DeleteObject(Boombox)          
               TriggerServerEvent('CR_Boombox:Destroy', Channel) 
               TriggerServerEvent('CR_Boombox:RemoveBoombox') 
               TriggerServerEvent('CR_Boombox:TheBox', 'Give')	
               ESX.ShowNotification("Boombox Removed! Distance Was To Far From")			   
               PlacedBoomboxes = 0 
            end	 
        end
        Citizen.Wait(sleep)
    end
end)

function OpenMainMenu()
    ESX.UI.Menu.CloseAll()
    
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Boombox',
    {
        title    = 'Boombox Control',
        align    = 'bottom-right',
        css      = 'boombox',
        elements = {
            {label = 'Change Music',   value = 'Music'},
            {label = 'Volume Control', value = 'Volume'},
            {label = 'Pause Music',    value = 'Pause'},
            {label = 'Play Music',     value = 'Play'},
        }
    },
    function(data, menu)
        				 		  		   
        if data.current.value == 'Pause' then
		
		if xSound:soundExists(Channel) then
            
            if not xSound:isPaused(Channel) then		   
                TriggerServerEvent('CR_Boombox:MusicControl', true, Channel)		 
            else
                ESX.ShowNotification("Music Is Already Paused")	
             end
		   end
            
        elseif data.current.value == 'Play' then
		
		if xSound:soundExists(Channel) then
            
            if xSound:isPaused(Channel) then
               TriggerServerEvent('CR_Boombox:MusicControl', false, Channel)		 
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
                css      = 'boombox',
                elements = {
                    {label = 'Default', value = 'Default'},
                    {label = '+Volume', value = '+'},
                    {label = '-Volume', value = '-'},
                },
            },
            function(data3, menu3)
                
                if data3.current.value == 'Default' then		
                   TriggerServerEvent('CR_Boombox:SetVolume', 'Default', 0.10, Channel)  			   
                    
                elseif data3.current.value == '+' then
				
				if xSound:soundExists(Channel) then
                 
                   Vol = xSound:getVolume(Channel)	   
                   Vol = Vol +0.1	
                    
                    if Vol < 1.0 then
                       TriggerServerEvent('CR_Boombox:SetVolume', 'Higher', Vol, Channel)  	 
                   else
                       ESX.ShowNotification("Max Volume Reached!")	
                    end  
                  end					
                    
                elseif data3.current.value == '-' then
				
                if xSound:soundExists(Channel) then    
                   Vol = xSound:getVolume(Channel)	   
                   Vol = Vol -0.1
                    
                    if Vol > 0.2 then
                       TriggerServerEvent('CR_Boombox:SetVolume', 'Lower', Vol, Channel)  
                   else
                       ESX.ShowNotification("Min Volume Reached!")	
                    end				  			   
                  end	
                end				
              end,
                 function(data3, menu3)
                   menu3.close()
                end
             )
		  	   
        elseif data.current.value == 'Music' then
    
        ESX.UI.Menu.Open(
         'default', GetCurrentResourceName(), 'mobile_vehicle_actions3',
        {
        title    = 'Station Selection',
        align    = 'bottom-right',
        css      = 'boombox',
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
           TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=DY_rFed96mg", objPlaced, Channel)  
            
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
                   TriggerServerEvent('CR_Boombox:ChangeStation', URL, objPlaced, Channel)  
                   RadioChannel = 'Custom URL [' ..URL..']'				   
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
			   RadioChannel = 'Tomorrowland'
			   TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=DY_rFed96mg", objPlaced, Channel) 		
		  
            -- elseif data2.current.value == 'Progressive' then
			--    RadioChannel = 'Progressive House'
			--    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=d8Oc90QevaI", objPlaced, Channel) 			  
 		  
            -- elseif data2.current.value == 'House' then
			--    RadioChannel = 'Deep House'
			--    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=PtYe4GwOlNs", objPlaced, Channel) 
			   
			-- elseif data2.current.value == 'Tropical' then
			--    RadioChannel = 'Tropical House'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=htoiDVRh6e4", objPlaced, Channel)  
			   
			-- elseif data2.current.value == 'Vocal' then
			--    RadioChannel = 'Vocal Trance'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=C6_ql03n-vQ", objPlaced, Channel)  
			  
			-- elseif data2.current.value == 'Trap' then
			--    RadioChannel = 'Trap'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=BwuwYELL-tg", objPlaced, Channel)   
			   
			-- elseif data2.current.value == 'HHRnB' then
			--    RadioChannel = 'Hip-Hop/RnB'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=L9Q1HUdUMp0", objPlaced, Channel) 
			   
			-- elseif data2.current.value == 'HHRap' then
			--    RadioChannel = 'Hip-Hop/Rap'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=mNgSEOsWDmc", objPlaced, Channel)     
			   
            -- elseif data2.current.value == 'Rap1' then
			--    RadioChannel = 'Rap Station 1'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=xDAcHbpl-F8", objPlaced, Channel)  

            -- elseif data2.current.value == 'Rap2' then
			--    RadioChannel = 'Rap Station 2'
	        --    TriggerServerEvent('CR_Boombox:ChangeStation', "https://www.youtube.com/watch?v=dTtshy4KzSY", objPlaced, Channel)  		   
	       end	 		 				  
         end,
             function(data2, menu2)
               menu2.close()
            end
           )		   
		end		 
      end,
       function(data, menu)
         menu.close()
		 ClearPedTasks(GetPlayerPed(-1))
		 menuOpen = false
      end
    )
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 0.5}, hint, 0.5)
end

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end