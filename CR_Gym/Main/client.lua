local ESX          = nil
local training     = false
local membership   = false
local HideMarkers  = false
local Hint         = false
local notifIn      = false
local notifOut     = false
local Looping      = false
local closestZone  = 1
local GymTime      = 0

Citizen.CreateThread(function()
  while ESX == nil do
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
     Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  
  Citizen.Wait(5000)
  
  ESX.TriggerServerCallback("CR_Gym:retrieveTime", function(Timer, Time)
    
    if Timer then
       GymTime = Time
       StarTimer()
    end
  end)
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
     return
  end
  
  Citizen.Wait(5000)	
  ESX.TriggerServerCallback("CR_Gym:retrieveTime", function(Timer, Time)
    
    if Timer then
       GymTime = Time
       StarTimer()
    end
  end)
end)

function StartIt()
   TriggerServerEvent("CR_Gym:ResetTime")
   Citizen.Wait(150)	
   ESX.TriggerServerCallback("CR_Gym:retrieveTime", function(Timer, Time) 
      if Looping then
         GymTime = Time   
      else
         GymTime = Time
         StarTimer()
      end
   end)
end

function StarTimer()
  
  Citizen.CreateThread(function()
    	
    while GymTime > 0 do
      Looping = true
      GymTime = GymTime - 1
      TriggerServerEvent("CR_Gym:updateGymTime", GymTime)			
      
         if GymTime == 120 then	          
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)	
		   elseif GymTime == 60 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 30 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 15 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 10 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 5 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 4 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 3 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 2 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
		   elseif GymTime == 1 then             
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have [~g~'..GymTime..'~s~] Minutes Left To Hit The Gym Before Losing Skill Levels', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			   
         end
       Citizen.Wait(60000)
    end
  end)
end  

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)--Remove A Random Amount Of Stamina & Strength From The Player Every 1 Minute
    
    if GymTime == 0 then 
      	  
      ESX.TriggerServerCallback('CR_Gym:GetStaminiaSkill', function(Stamina)      
      Value = tonumber(Stamina)  
        
        if Value ~= 0 and Value > 1 then  
            
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Losing Stamina! Get To The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		       
           TriggerServerEvent('CR_Gym:RemoveStamina', GetPlayerServerId(PlayerId()),  (math.random() * (0.030 - 0.0050) + 0.0050))--Remove Stamina		  		  
        end
      end)
      
      ESX.TriggerServerCallback('CR_Gym:GetFightingSkill', function(Fighting)      
      Value = tonumber(Fighting)  
        
        if Value ~= 0 and Value > 1 then  
        
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Losing Strength! Get To The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			      
           TriggerServerEvent('CR_Gym:RemoveStrength', GetPlayerServerId(PlayerId()), (math.random() * (0.030 - 0.0050) + 0.0050))--Remove Strength
        end
      end)	  
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    
    local sleep = 1000
    
    if HideMarkers == false then	
       local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      
      for i = 1, #Config.gym do
        
        local GymMarker = vector3(Config.gym[i].x, Config.gym[i].y, Config.gym[i].z)
        local dist = #(plyCoords - GymMarker)
        
        if dist <= 15 then
           sleep = 5
           DrawMarker(21, Config.gym[i].x, Config.gym[i].y, Config.gym[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 255, 0, 0, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.5 then
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Open The ~b~Menu')
          
          if IsControlJustPressed(0, 38) then
             OpenGymMenu()
          end				
        end 			 
      end   
      
      for i = 1, #Config.arms do
        
        local ArmMarkers = vector3(Config.arms[i].x, Config.arms[i].y, Config.arms[i].z)
        local dist = #(plyCoords - ArmMarkers)
        
        if dist <= 15 then
           sleep = 5
           DrawMarker(21, Config.arms[i].x, Config.arms[i].y, Config.arms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 0, 255, 50, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.4 and Hint == false then		
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Lift Some ~g~Weights')
          
          if IsControlJustPressed(0, 38) then
            if training == false then
              								
              local inventory = ESX.GetPlayerData().inventory
              local count  = 0
              
              for i=1, #inventory, 1 do
                if inventory[i].name == 'gym_membership' then
                   count = inventory[i].count
                end
              end
              
              if (count > 0) then	
                 HideMarkers = true
                 ESX.UI.Menu.CloseAll()
                 PedSync = PedToNet(PlayerPedId())
                 Scenario = "world_human_muscle_free_weights"							   
                 TriggerServerEvent('CR_Gym:SyncLocation', PedSync, 'arms')
                 Citizen.Wait(250)				   
                 TriggerServerEvent('CR_Gym:SyncScenario', Scenario, 'arms')								   
             else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need A Gym Membership To Use The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
              end
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Still Resting From Your Last Exercise', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)				   
            end				
          end	
        end 		 
      end
      
      for i = 1, #Config.pushup do
        
        local PushupMarkers = vector3(Config.pushup[i].x, Config.pushup[i].y, Config.pushup[i].z)
        local dist = #(plyCoords - PushupMarkers)
        
        if dist <= 15 then
           sleep = 5
           DrawMarker(21, Config.pushup[i].x, Config.pushup[i].y, Config.pushup[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 0, 255, 50, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.4 and Hint == false then
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Do Some ~g~Pushups')
          
          if IsControlJustPressed(0, 38) then
            
            if training == false then
              
              local inventory = ESX.GetPlayerData().inventory
              local count  = 0
              
              for i=1, #inventory, 1 do
                if inventory[i].name == 'gym_membership' then
                  count = inventory[i].count
                end
              end
			                 
              if (count > 0) then
                 HideMarkers = true
                 ESX.UI.Menu.CloseAll()
                 PedSync = PedToNet(PlayerPedId())
                 lib = "amb@world_human_push_ups@male@base"
				     anim = "base"			   
                 TriggerServerEvent('CR_Gym:SyncLocation', PedSync, 'pushup')						
                 TriggerServerEvent('CR_Gym:SyncAnim', lib, anim, 'pushup')                
             else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need A Gym Membership To Use The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
              end
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Still Resting From Your Last Exercise', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			   
            end				
          end				
        end		 
      end
      
      for i = 1, #Config.yoga do
        
        local YogaMarkers = vector3(Config.yoga[i].x, Config.yoga[i].y, Config.yoga[i].z)
        local dist = #(plyCoords - YogaMarkers)
        
        if dist <= 15 then  
           sleep = 5        
           DrawMarker(21, Config.yoga[i].x, Config.yoga[i].y, Config.yoga[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 0, 255, 50, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.4 and Hint == false then
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Do Some ~g~Yoga')
          
          if IsControlJustPressed(0, 38) then
            if training == false then				
              
              local inventory = ESX.GetPlayerData().inventory
              local count  = 0
              
              for i=1, #inventory, 1 do
                if inventory[i].name == 'gym_membership' then
                   count = inventory[i].count
                end
              end
			                  
              if (count > 0) then
                 HideMarkers = true	 
				     ESX.UI.Menu.CloseAll()				
                 PedSync = PedToNet(PlayerPedId())
                 Scenario = "world_human_yoga"				   
                 TriggerServerEvent('CR_Gym:SyncLocation', PedSync, 'yoga')						
                 TriggerServerEvent('CR_Gym:SyncScenario', Scenario, 'yoga')  
             else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need A Gym Membership To Use The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
              end
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Still Resting From Your Last Exercise', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		   
            end				
          end				
        end		 		 
      end
      
      for i = 1, #Config.situps do
        
        local SitupMarkers = vector3(Config.situps[i].x, Config.situps[i].y, Config.situps[i].z)
        local dist = #(plyCoords - SitupMarkers)
        
        if dist <= 15 then
           sleep = 5
           DrawMarker(21, Config.situps[i].x, Config.situps[i].y, Config.situps[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 0, 255, 50, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.4 and Hint == false then
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Do Some ~g~Sit Ups')
          
          if IsControlJustPressed(0, 38) then
            
            if training == false then
              
              local inventory = ESX.GetPlayerData().inventory
              local count  = 0
              
              for i=1, #inventory, 1 do
                if inventory[i].name == 'gym_membership' then
                   count = inventory[i].count
                end
              end			      
              
              if (count > 0) then
                 HideMarkers = true
                 ESX.UI.Menu.CloseAll()				
                 PedSync = PedToNet(PlayerPedId())
				     lib = "amb@world_human_sit_ups@male@base" 
				     anim = "base"
                 TriggerServerEvent('CR_Gym:SyncScenario', Scenario, 'situps') 
                 TriggerServerEvent('CR_Gym:SyncAnim', lib, anim, 'situps')     				 
             else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need A Gym Membership To Use The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
              end
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Still Resting From Your Last Exercise', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
            end				
          end				
        end				 
      end
      
      for i = 1, #Config.chins do
        
        local ChinupMarkers = vector3(Config.chins[i].x, Config.chins[i].y, Config.chins[i].z)
        local dist = #(plyCoords - ChinupMarkers)
        
        if dist <= 15 then
           sleep = 5
           DrawMarker(21, Config.chins[i].x, Config.chins[i].y, Config.chins[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.301, 0.301, 0.3001, 0, 255, 50, 200, false, true, 2, true, false, false, false)
        end
        
        if dist <= 0.4 and Hint == false then
           hintToDisplay('~y~Press ~w~ ~INPUT_CONTEXT~ To Do Some ~g~Chin Ups')
          
          if IsControlJustPressed(0, 38) then
            
            if training == false then
              
              local inventory = ESX.GetPlayerData().inventory
              local count  = 0
              
              for i=1, #inventory, 1 do
                if inventory[i].name == 'gym_membership' then
                   count = inventory[i].count
                end
              end
			                  
              if (count > 0) then
                 HideMarkers = true
                 ESX.UI.Menu.CloseAll()
                 PedSync = PedToNet(PlayerPedId())
                 Scenario = "prop_human_muscle_chin_ups"				   
                 TriggerServerEvent('CR_Gym:SyncLocation', PedSync, 'chins')						
                 TriggerServerEvent('CR_Gym:SyncScenario', Scenario, 'chins')                
             else
				 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Need A Gym Membership To Use The Gym', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
              end
           else
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Are Still Resting From Your Last Exercise', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
            end					
          end				
        end		 
      end
    end
    Citizen.Wait(sleep)
  end
end)

function OpenGymMenu()
  ESX.UI.Menu.CloseAll()
  
  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'gym_menu',
  {
    title    = 'Gym Memberships',
    align    = 'bottom-right',
    css      = 'superete',
    elements = {
      {label = 'Buy A Gym Membership [$100]', value = 'membership'},
    }
  },
  function(data, menu)
    
    if data.current.value == 'membership' then
      
      ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'gym_ship_menu',
      {
        title    = 'Are You Sure?',
        align    = 'bottom-right',
        css      = 'superete',
        elements = {
          {label = 'No', value = 'no'},
          {label = 'Yes', value = 'yes'}
        }
      },
      function(data2, menu)
        
        if data2.current.value == 'yes' then
          
          local inventory = ESX.GetPlayerData().inventory
          local count  = 0
          
          for i=1, #inventory, 1 do
            if inventory[i].name == 'gym_membership' then
               count = inventory[i].count
            end
          end
          
          if (count == 0) then					
             TriggerServerEvent('CR_Gym:buyMembership')	
         else
		     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] Looks Like You Are Already A Member', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
          end  
		  
          ESX.UI.Menu.CloseAll()
          
        elseif data2.current.value == 'no' then
           ESX.UI.Menu.CloseAll()
        end	 			
      end,
      function(data2, menu)
        menu.close()
      end
    )
  end		
end,	
   function(data, menu)
       menu.close()
    end
   )
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    
    if training == true then
       Citizen.Wait(60000)
       training = false
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] You Have Rested And Can Now Exercise Again', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
    else
      Citizen.Wait(100)
    end
  end
end)

function hintToDisplay(text)
   SetTextComponentFormat("STRING")
   AddTextComponentString(text)
   DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
  
   Gymblip = AddBlipForCoord(-1201.2257, -1568.8670, 4.6101)
   SetBlipSprite(Gymblip, 480)
   SetBlipDisplay(Gymblip, 4)
   SetBlipScale(Gymblip, 1.0)
   SetBlipColour(Gymblip, 4)
   SetBlipAsShortRange(Gymblip, true)
   BeginTextCommandSetBlipName("STRING")
   AddTextComponentString("Gym")
   EndTextCommandSetBlipName(Gymblip)
end)

Citizen.CreateThread(function()
  
   RequestModel(GetHashKey("ig_kerrymcintosh"))
   while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
      Wait(1)
   end
  
   local GymPed = CreatePed(4, 0x5B3BD90D, -1195.10, -1577.40, 3.6, 126.83, false, true)
   SetEntityHeading(GymPed, 126.83)
   FreezeEntityPosition(GymPed, true)
   SetEntityInvincible(GymPed, true)
   SetBlockingOfNonTemporaryEvents(GymPed, true)
   SetModelAsNoLongerNeeded(GymPed)
end)

RegisterNetEvent("CR_Gym:DoAnim")
AddEventHandler("CR_Gym:DoAnim", function(lib, anim, Type)
  
    if Type == 'pushup' then 
    
	 startAnimation("amb@world_human_push_ups@male@base","base")	 
     HideMarkers = true
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddStamina', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))              
     ClearPedTasksImmediately(GetPlayerPed(-1))
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Stamina Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()
	 
  elseif Type == 'situps' then 
    
     startAnimation("amb@world_human_sit_ups@male@base","base")
     HideMarkers = true
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddStamina', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))            
     ClearPedTasksImmediately(GetPlayerPed(-1)) 
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Stamina Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()	 	 
  end
end)

RegisterNetEvent("CR_Gym:DoScenario")
AddEventHandler("CR_Gym:DoScenario", function(Scenario, Type)
  
  if Type == 'arms' then
    
     TaskStartScenarioInPlace(GetPlayerPed(-1), Scenario, 0, true)
     HideMarkers = true	
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddFightingSkill', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))
     ClearPedTasksImmediately(GetPlayerPed(-1))	 	 
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Strength Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()	
    
  elseif Type == 'chins' then 
    
     TaskStartScenarioInPlace(GetPlayerPed(-1), Scenario, 0, true)
     HideMarkers = true	
     Hint = true	 
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddFightingSkill', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))
     ClearPedTasksImmediately(GetPlayerPed(-1))
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId());ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Strength Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt() 
    
  elseif Type == 'pushup' then 
    
     TaskStartScenarioInPlace(GetPlayerPed(-1), Scenario, 0, true)
     HideMarkers = true
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddStamina', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))              
     ClearPedTasksImmediately(GetPlayerPed(-1))
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Stamina Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()
	 
   elseif Type == 'yoga' then 
    
	 Citizen.Wait(500)
     TaskStartScenarioInPlace(GetPlayerPed(-1), Scenario, 0, true)
     HideMarkers = true
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddStamina', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))              
     ClearPedTasksImmediately(GetPlayerPed(-1))
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Stamina Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()
	 
  elseif Type == 'situps' then 
    
     TaskStartScenarioInPlace(GetPlayerPed(-1), Scenario, 0, true)
     HideMarkers = true
     Hint = true
     Citizen.Wait(60000)
     TriggerServerEvent('CR_Gym:AddStamina', GetPlayerServerId(PlayerId()), (math.random(0,900)/10000))            
     ClearPedTasksImmediately(GetPlayerPed(-1)) 
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~GYM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~w~] ~g~+ Stamina Gained~s~! Rest for 1 Minute Before Continuing', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
     training = true
     HideMarkers = false
     Hint = false
     StartIt()	 	 
  end
end)

RegisterNetEvent("CR_Gym:SendCoords")
AddEventHandler("CR_Gym:SendCoords", function(PedSync, Type)
  
  SyncedPed = NetToPed(PedSync)
  local plyCoords = GetEntityCoords(SyncedPed, false)
  
  if Type == 'chins' then 
    
    if GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1204.71, -1557.46, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1204.72, -1557.36, 3.6115)
       SetEntityHeading(SyncedPed, 2.31)		
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1206.32, -1557.56, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1206.32, -1557.56, 3.6115)
       SetEntityHeading(SyncedPed, 2.31)				
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1207.95, -1557.81, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1207.91, -1557.74, 3.6115)
       SetEntityHeading(SyncedPed, 7.62)	
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1209.60, -1558.00, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1209.60, -1557.95, 3.6115)
       SetEntityHeading(SyncedPed, 3.79)	
    end
    
  elseif Type == 'arms' then
       
    if GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1203.39, -1558.07, 4.6115, false) < 0.5 then	
       SetEntityCoords(SyncedPed, -1203.39, -1558.07, 3.6115)
       SetEntityHeading(SyncedPed, 125.88)		
      
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1201.63, -1560.61, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1201.63, -1560.61, 3.6115)
       SetEntityHeading(SyncedPed, 125.88)				
      
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1199.83, -1563.17, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1199.83, -1563.17, 3.6115)
       SetEntityHeading(SyncedPed, 125.88)	
      
    elseif GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1198.06, -1565.73, 4.6115, false) < 0.5 then
       SetEntityCoords(SyncedPed, -1198.06, -1565.73, 3.6115)
       SetEntityHeading(SyncedPed, 125.88)				  
    end
    
  elseif Type == 'pushup' then 
     SetEntityHeading(SyncedPed, 303.29)	
    
  elseif Type == 'situps' then 	
     SetEntityHeading(SyncedPed, 127.72)		   
  end	
end)

------------------------------------------------------------------
------------------------------------------------------------------

----Fighting----
Citizen.CreateThread(function()
  while true do
    
    if IsPedInMeleeCombat(PlayerPedId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED") then 
      
      ESX.TriggerServerCallback('CR_Gym:GetFightingSkill', function(Fighting)
        Value = tonumber(Fighting)  
        
        if IsControlPressed(0, 223)  then--Stop continues glitch punching	
           disable = true
           Citizen.Wait(500)
           disable = false
        end
        
        if Value <= 5 then 
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.1)			
        elseif Value <= 10 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.2)			
        elseif Value <= 15 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.3)				
        elseif Value <= 20 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.4)				
        elseif Value <= 25 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.5)				
        elseif Value <= 30 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.6)				
        elseif Value <= 35 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.7)				
        elseif Value <= 40 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.8)				
        elseif Value <= 45 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.9) 		
        elseif Value <= 50 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.0)			
        elseif Value <= 55 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.1)			
        elseif Value <= 60 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.2)			
        elseif Value <= 65 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.3)			
        elseif Value <= 70 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.4)			
        elseif Value <= 75 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.5)			
        elseif Value <= 80 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.6)			
        elseif Value <= 85 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.7)			
        elseif Value <= 90 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.8)			
        elseif Value <= 95 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 1.9)			
        elseif Value <= 100 then
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 2.5)	
        elseif Value > 100 then		
           N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 3.0)	
        end 		   		   	
      end)			       	    
    end
    Citizen.Wait(1000)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
	
    if disable == true then
       DisableControlAction(0, 24, true)
    end	 
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    
    if HideMarkers == true then     
       DisableControlAction(0, 106, true) -- Disable in-game mouse controls
       DisableControlAction(0, 24,  true) 
       DisableControlAction(0, 25,  true) 
       DisableControlAction(0, 37,  true) 
       DisableControlAction(0, 140, true)
       DisableControlAction(0, 142, true)         
       DisableControlAction(0, 263, true)
       DisableControlAction(0, 69,  true)
       DisableControlAction(0, 323,  true) -- Handsup
       DisableControlAction(0, 29,  true) -- Point
       DisableControlAction(0, 311,  true) -- Ragdoll
       DisableControlAction(0, 20,  true) -- RadialMenu
       DisableControlAction(0, 245,  true) -- Chat
       DisableControlAction(0, 243, true) -- ~/Phone
       DisableControlAction(0, 288, true) -- F2/Inventory				   
       DisableControlAction(0, 289, true) -- F2/Inventory
       DisableControlAction(0, 82, true) -- Surrender
   else
       Citizen.Wait(500)
    end
  end
end)

--SafeZone
-- Citizen.CreateThread(function()

--   while not NetworkIsPlayerActive(PlayerId()) do
--     Citizen.Wait(0)
--   end
  
--   while true do
--     Citizen.Wait(0)
    
--     local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
--     local dist = Vdist(Config.safezone[closestZone].x, Config.safezone[closestZone].y, Config.safezone[closestZone].z, x, y, z)
    
--     if dist <= 12.0 then  
--        SetPlayerInvincible(PlayerId(), true)
--        DrawAdvancedText(0.130, 0.998, 0.005, 0.0028, 0.30,"You Are In A Safe Zone!", 0, 255, 0, 255, 0, 1)
      
--       if not notifIn then																			   
--          NetworkSetFriendlyFireOption(false)
--          ClearPlayerWantedLevel(PlayerId())
--          SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
--          notifIn = true
--          notifOut = false
--       end
--     else
--       SetPlayerInvincible(PlayerId(), false)
--       Citizen.Wait(250)
      
--       if not notifOut then
--          NetworkSetFriendlyFireOption(true)		       
--          notifOut = true
--          notifIn = false
--       end
--     end
    
--     if notifIn and ESX.GetPlayerData().job.name ~= 'police' then 
--        DisableControlAction(0, 106, true) -- Disable in-game mouse controls
--        DisableControlAction(0, 24,  true) 
--        DisableControlAction(0, 25,  true) 
--        DisableControlAction(0, 37,  true) 
--        DisableControlAction(0, 140, true)
--        DisableControlAction(0, 142, true)         
--        DisableControlAction(0, 263, true)
--        DisableControlAction(0, 69,  true)		   
--     end
--   end
-- end)

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

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end