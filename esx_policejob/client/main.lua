local CurrentActionData, handcuffTimer, dragStatus, currentTask = {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false
local prevMaleVariation         = 0
local prevFemaleVariation       = 0
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash   = GetHashKey("mp_m_freemode_01")

local ESX        = nil
local decorName  = nil
local decorInt   = nil
local bodyBag    = nil
local attached   = false
local loaded     = false
local canCheckInvis = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    while not ESX.IsPlayerLoaded() do
		ESX.IsPlayerLoaded()
    end   

	loaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

RegisterNetEvent('eden_garage:EjectUsers')
AddEventHandler('eden_garage:EjectUsers', function()
	TaskLeaveAnyVehicle(PlayerPedId(), 0, 0)
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
	exports["dpemotes"]:ResetCurrentWalk()
end

function OpenCloakroomMenu()
  
  local grade = ESX.PlayerData.job.grade_name
  
  local elements = {}
  
  table.insert(elements, {label = ('Go Off Duty'),   value = 'citizen_wear'})
  
  if grade == 'Probationary' then			
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'Constable' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	   
    
  elseif grade == 'SnrConstable' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'}) 
    
  elseif grade == 'LSConstable' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	 
    
  elseif grade == 'LSCHighwayI' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})
    
  elseif grade == 'LSCSOGI' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'})	
    
  elseif grade == 'LSCDetectiveI' then	
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'Sergeant' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	 
    
  elseif grade == 'SnrSgtHighwayII' then 
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})	
    
  elseif grade == 'SnrSgtSOGII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'})		
    
  elseif grade == 'SSDetectiveII' then
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})	 
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'Inspector' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	 
    
  elseif grade == 'InspHighwayII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})
    
  elseif grade == 'InspSOGII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'})	
    
  elseif grade == 'InspDetectiveII' then	
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'Superintendent' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	 
    
  elseif grade == 'SuptHighwayIII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})
    
  elseif grade == 'SuptSOGIII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'}) 
    
  elseif grade == 'SuptDetectiveIII' then	
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'Commander' then	
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'ComHighwayIII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})
    
  elseif grade == 'ComSOGIII' then
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'}) 
    
  elseif grade == 'ComDetectiveIII' then
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})		
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})
    
  elseif grade == 'boss' then	
    table.insert(elements, {label = ('Go On Duty'),   value = 'DETuniform'})		
    table.insert(elements, {label = ('GD Uniform [Short Sleeve]'),  value = 'GDUniform'})
    table.insert(elements, {label = ('GD Uniform [Long Sleeve] '),  value = 'GDUniformL'})	 
    table.insert(elements, {label = ('HWY Uniform [Short Sleeve]'), value = 'HWYuniform'})
    table.insert(elements, {label = ('HWY Uniform [Long Sleeve]'),  value = 'HWYuniformL'})
    table.insert(elements, {label = ('SOG Uniform'),  value = 'SOGuniform'})		  
  end
  
  ESX.UI.Menu.CloseAll()
  
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
    title    = _U('cloakroom'),
    align    = 'bottom-right',
    css      = 'entreprise',
    elements = elements
  }, function(data, menu)
    
    if data.current.value == 'citizen_wear' then
      male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
      femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
      
      if male or femalemale then
        
        local health = GetEntityHealth(GetPlayerPed(-1))	
        
        if health >= 150 then
          
          local inventory = ESX.GetPlayerData().inventory
          local count  = 0
          
          for i=1, #inventory, 1 do
            if inventory[i].name == 'pdgps' then
               count = inventory[i].count
            end
          end
		  
		  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now off duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		  TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'Off')
		  TriggerServerEvent('PDDutyLog', 'Off')
		  
          if (count > 0) then	
             TriggerServerEvent('esx_policejob:RemoveGPS')					
          end
          
          ESX.UI.Menu.CloseAll()
          ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            RemoveWepsOffDuty()  
            SetPedArmour(PlayerPedId(), 0)
            SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)				
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerServerEvent('duty:police2')	  	
			Citizen.Wait(1000)
			TriggerEvent('CR_DutyBlips:updateBlip')
            --TriggerServerEvent('CR_DutyBlips:spawned')
            exports.ft_libs:DisableArea("esx_eden_garage_area_police_mecanodeletepoint")		
            exports.ft_libs:DisableArea("esx_eden_garage_area_police_mecanospawnpoint")
         end)
        else 		   
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		   
        end
      else	
          local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Already The Model You Need To Be', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		   		
       end
    end
    
    if data.current.value == 'GDUniform' then
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	   		 
          if canTakeService then         
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')		  
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
               --TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint") 
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')	
			   TriggerServerEvent('PDDutyLog', 'On')
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)							  
           else 
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
            end
         else
			 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
        else	
		   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        end
      end, 'police') 	 	    
    end
    
    if data.current.value == 'GDUniformL' then
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)   
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	   		 
          if canTakeService then         
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')		  
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
            --    TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint") 
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')	
			   TriggerServerEvent('PDDutyLog', 'On')
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)			
           else 
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end
         else
             local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
       else
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        end
      end, 'police') 	 	    
    end   
    
    if data.current.value == 'HWYuniform' then	
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	  		 
          if canTakeService then         
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()		
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
               --TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint")
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')		
			   TriggerServerEvent('PDDutyLog', 'On')
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
           else 
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end 
         else
             local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
       else
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
        end--
      end, 'police') 	
    end 
    
    if data.current.value == 'HWYuniformL' then	
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	  		 
          if canTakeService then         
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()		
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
            --    TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint")
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')	
			   TriggerServerEvent('PDDutyLog', 'On')	
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
           else 
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end 
         else
             local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
        else
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
        end
      end, 'police') 	
    end 
    
    if data.current.value == 'SOGuniform' then	
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	  		 		 
          if canTakeService then         
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')	
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
               --TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint")
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')		
			   TriggerServerEvent('PDDutyLog', 'On')
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
           else 
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end
         else
             local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
        else
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
        end
      end, 'police')  
    end 
    
    if data.current.value == 'DETuniform' then	
      ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
        male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
        femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
        
        if male or femalemale then	  		 		 		 
          if canTakeService then  
            
            local health = GetEntityHealth(GetPlayerPed(-1))
            
            if health >= 150 then
              
               CheckGPS()
              
               ESX.UI.Menu.CloseAll()
               setUniform(data.current.value, PlayerPedId())
               SetPedArmour(PlayerPedId(), 100)
               ClearPedBloodDamage(PlayerPedId())
               ResetPedVisibleDamage(PlayerPedId())
               ClearPedLastWeaponDamage(PlayerPedId())
               TriggerServerEvent('duty:police')	
			   Citizen.Wait(2000)
			   TriggerEvent('CR_DutyBlips:updateBlip')
            --    TriggerServerEvent('CR_DutyBlips:spawned')
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanodeletepoint")		
               exports.ft_libs:EnableArea("esx_eden_garage_area_police_mecanospawnpoint")
			   TriggerServerEvent('esx_policejob:DutyAlerts', GetPlayerServerId(PlayerId()), 'On')			
			   TriggerServerEvent('PDDutyLog', 'On')
			   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~[Duty]', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You are now on duty', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
           else 
               local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Injured! Call Ems Or Go See A Doctor First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
            end
         else
             local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames().. '~s~] Max Police Already In Service ~g~' ..inServiceCount .. '~s~/~r~' .. maxInService, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          end
       else
           local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Can Not Go On duty As These Models', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
        end
      end, 'police')   
    end	
  end, function(data, menu)
     menu.close()
     CurrentAction     = 'menu_cloakroom'
     CurrentActionMsg  = _U('open_cloackroom')
     CurrentActionData = {}
  end)
end

function CheckGPS()

    local inventory = ESX.GetPlayerData().inventory
    local count  = 0

    for i=1, #inventory, 1 do
        if inventory[i].name == 'pdgps' then
           count = inventory[i].count
        end
      end
	   
    if (count == 0) then	
	   TriggerServerEvent('esx_policejob:GiveGPS')			
    end
end

RegisterNetEvent('esx_policejob:DutyAlerts')
AddEventHandler('esx_policejob:DutyAlerts', function(serverid, RPname, grade, grade2, onOff)

    local serverid = GetPlayerPed(GetPlayerFromServerId(serverid))
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(serverid)
	TargetName = RPname.firstname..' '..RPname.lastname
		   
	if grade == 'Probationary' then				
       ESX.ShowAdvancedNotification('LSPD', '[Probationary Officer]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
    elseif grade == 'Constable' then	
       ESX.ShowAdvancedNotification('LSPD', '[Constable]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  		  
    elseif grade == 'SnrConstable' then
       ESX.ShowAdvancedNotification('LSPD', '[Snr.Constable]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'LSConstable' then	
       ESX.ShowAdvancedNotification('LSPD', '[LS.Constable]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'LSCHighwayI' then	
       ESX.ShowAdvancedNotification('LSPD', '[LSC.Highway I]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  	  
	elseif grade == 'LSCSOGI' then
       ESX.ShowAdvancedNotification('LSPD', '[LSC.SOG I]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
	elseif grade == 'LSCDetectiveI' then	
       ESX.ShowAdvancedNotification('LSPD', '[LSC.Detective I]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
	elseif grade == 'Sergeant' then	
       ESX.ShowAdvancedNotification('LSPD', '[Sergeant]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			  
    elseif grade == 'SnrSgtHighwayII' then 
       ESX.ShowAdvancedNotification('LSPD', '[Snr.Sgt.Highway II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
    elseif grade == 'SnrSgtSOGII' then
       ESX.ShowAdvancedNotification('LSPD', '[Snr.Sgt.SOG II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			  
    elseif grade == 'SSDetectiveII' then
       ESX.ShowAdvancedNotification('LSPD', '[SS Detective II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
	elseif grade == 'Inspector' then	
       ESX.ShowAdvancedNotification('LSPD', '[Inspector]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'InspHighwayII' then
       ESX.ShowAdvancedNotification('LSPD', '[Insp.Highway II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'InspSOGII' then
       ESX.ShowAdvancedNotification('LSPD', '[Insp.SOG II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'InspDetectiveII' then	
       ESX.ShowAdvancedNotification('LSPD', '[Insp.Detective II]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'Superintendent' then	
       ESX.ShowAdvancedNotification('LSPD', '[Superintendent]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'SuptHighwayIII' then
       ESX.ShowAdvancedNotification('LSPD', '[Supt.Highway III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		 		  
	elseif grade == 'SuptSOGIII' then
       ESX.ShowAdvancedNotification('LSPD', '[Supt.SOG III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'SuptDetectiveIII' then	
       ESX.ShowAdvancedNotification('LSPD', '[Supt.Detective III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'Commander' then	
       ESX.ShowAdvancedNotification('LSPD', '[Commander]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)			  
	elseif grade == 'ComHighwayIII' then
       ESX.ShowAdvancedNotification('LSPD', '[Com.Highway III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'ComSOGIII' then
       ESX.ShowAdvancedNotification('LSPD', '[Com.SOG III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
	elseif grade == 'ComDetectiveIII' then
       ESX.ShowAdvancedNotification('LSPD', '[Com.Detective III]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)		  
    elseif grade2 == 23 then	
       ESX.ShowAdvancedNotification('LSPD', '[Asst.Commissioner]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
    elseif grade2 == 24 then	
       ESX.ShowAdvancedNotification('LSPD', '[Dep.Commissioner]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
    elseif grade2 == 25 then	
       ESX.ShowAdvancedNotification('LSPD', '[Commissioner]', '[~y~'.. TargetName ..'~w~] Is Now ~g~['.. onOff ..' Duty]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, true)				  
	end   		
end)

function RemoveWepsOffDuty()
    Citizen.CreateThread(function()
	
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police'then	
        ESX.TriggerServerCallback('esx_policejob:RemoveWeaponsWhenOffDuuty', function()      
			ESX.SetPlayerData('loadout', {})                   
		end)
	end
	local inventory = ESX.GetPlayerData().inventory
	local count  = 0
	
	for i=1, #inventory, 1 do
	  if inventory[i].name == 'pdgps' then
		 count = inventory[i].count
	  end
	end		  
	if (count > 0) then	
		TriggerServerEvent('esx_policejob:RemoveGPS')					
	 end
  end)
end

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

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('buy_weapons'),  value = 'buy_weapons'},
		{label = ('Weapon Storage'), value = 'WeapStorgage'},
		{label = ('Restock Ammo'), value = 'ammunition'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = elements
	}, function(data, menu)

    if data.current.value == 'buy_weapons' then
	   OpenBuyWeaponsMenu()
	end
	 
	if data.current.value == 'WeapStorgage' then
   	   ESX.TriggerServerCallback("esx_policejob:WeaponStorage", function(cb)
       TriggerEvent('esx_policejob:OpenWeaponStorage', cb)
    end,ESX.GetPlayerData().identifier)
		menu.close()
	end

	if data.current.value == 'ammunition' then
		TriggerServerEvent('esx_policejob:buyAmmo')
	end
	
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'Police',
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
			{label = ('Animations'), value = 'Animations'},
			{label = _U('object_spawner'), value = 'object_spawner'}
			
	}}, function(data, menu)
	
	    if data.current.value == 'Animations' then
	       OpenAnimationsMenupolice()
     	end
		
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = ('Check BAC'), value = 'bac'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
				--{label =   ('Put In BodyBag'),  value = 'bodybag'},			  
			    {label =   ('Revive Player'),value = 'revive'},			  
			    {label =   ('Search player'),value = 'search'},
				{label = 'Fix invis in area',  value = 'invisfix'},
				{label =   ('Remove Mask'),value = 'mask'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'bottom-right',
		        css      = 'entreprise',
				elements = elements
			}, function(data2, menu2)
					
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
			
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
				
					local action = data2.current.value
				    if action == 'bac' then
						OpenIdentityCardMenu(closestPlayer)
					end
					
					if action == 'mask' then
						TriggerServerEvent('esx_policejob:removeClothing', GetPlayerServerId(closestPlayer))
					end

                    if action == 'handcuff' then
					
					TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5', GetPlayerServerId(closestPlayer))			
					elseif action == 'search' then
						TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
						TriggerServerEvent('esx_policejob:notify', GetPlayerServerId(closestPlayer))
						local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Searching: ' .. GetPlayerName(closestPlayer), mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
					elseif action == 'drag' then
					
					if IsPedCuffed(GetPlayerPed(closestPlayer)) then
					   TriggerServerEvent('22fe76e3-719a-4b38-8f63-b0a30853c7a9', GetPlayerServerId(closestPlayer))
				    else
					   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Civilian Must Be Handcuffed First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
					end
					  
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('345e1048-bb15-4328-acf5-3af296e1a207', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('cfc9f1f9-f664-43d7-b444-e2554f825aad', GetPlayerServerId(closestPlayer))
					elseif action == 'bodybag' then							
						TriggerServerEvent('esx_policejob:putinbodybag', GetPlayerServerId(closestPlayer))
					end
										
				if action == 'revive' then
                    if IsEntityDead(GetPlayerPed(closestPlayer)) then
                       ESX.UI.Menu.CloseAll()                 
					   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Revive In Progress.....', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   

					   local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

					    for i=1, 15, 1 do
						  Citizen.Wait(900)
								
						ESX.Streaming.RequestAnimDict(lib, function()
						    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
					    end)
					 end
					    TriggerServerEvent('e8fa6d55-a686-4483-b3a4', GetPlayerServerId(closestPlayer))
                    else
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] This Player Is Not Dead', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
                end      
       end											   
         else
			if data.current.value ~= 'invisfix' then
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] No Civilians Nearby', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			end
		  end
		end, function(data2, menu2)
			 menu2.close()
		 end)
									
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()
			local grade = ESX.PlayerData.job.grade_name
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			
			if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then 	
			 if grade == 'boss' or grade == 'assistant commissioner' or grade == 'chief superintendent' then  
               table.insert(elements, {label = ('Crush The Vehicle'),  value = 'crush_veh'})
            end	
		  end

			if DoesEntityExist(vehicle) then
			   table.insert(elements, {label = ('LockPick Vehicle'), value = 'hijack_vehicle'})
			   table.insert(elements, {label = ('Delete The Vehicle'),    value = 'DeleteVehicle'})
			   table.insert(elements, {label = ('Impound The Vehicle '),   value = 'ImpoudVehicle'}) 			  					   
		    end
			

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'bottom-right',
		        css      = 'entreprise',
				elements = elements
			}, function(data2, menu2)
			
				local coords  = GetEntityCoords(playerPed)
				vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
				if vehicle == 0 then
					vehicle = ESX.Game.GetVehicleInDirection()
				end
			
				if vehicle == 0 or vehicle == nil then
					vehicle, vehicledist = ESX.Game.GetClosestVehicle()
					if vehicledist > 2.5 then
						vehicle = nil
						vehicledist = nil
					end
				end
				action  = data2.current.value
				
                if action == 'crush_veh' then	
	               crushthevehicle() 	
				   
	            elseif action == 'crush_air' then	 
	               crushtheair()
                end
				
			    if DoesEntityExist(vehicle) then
				
				   if action == 'ImpoudVehicle' then
                      Impoundit(vehicle)  				   
				
                    elseif action == 'hijack_vehicle' then
					
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
						   TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
						   Citizen.Wait(20000)
						   ClearPedTasksImmediately(playerPed)
						   SetVehicleDoorsLocked(vehicle, 1)
						   SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						   netVeh = VehToNet(vehicle)
						   TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 1)
						   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Vehicle ~g~Unlocked~s~', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
						end
																												
					elseif action == 'DeleteVehicle' then
						if currentTask.busy then
						   return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100)
						end)

						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
								   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] The Impound Has Been Canceled Because The Vehicle Moved', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
								   ESX.ClearTimeout(currentTask.task)
								   ClearPedTasks(playerPed)
								   currentTask.busy = false
								   break
								end
							end
						end)
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
			
		elseif data.current.value == 'object_spawner' then
		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('traffic_interaction'),
				align    = 'bottom-right',
		        css      = 'entreprise',
				elements = {
					{label = _U('cone'),        model = 'prop_roadcone02a'},
					{label = _U('barrier'),     model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('cash'),        model = 'hei_prop_cash_crate_half_full'}					
			    }}, function(data2, menu2)
			
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local objectCoords = (coords + forward * 1.0)

				ESX.Game.SpawnObject(data2.current.model, objectCoords, function(obj)
				   DecorSetInt(obj ,decorName,decorInt)
				   SetEntityHeading(obj, GetEntityHeading(playerPed))
				   PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()

	for i = 1, #Config.AuthorizedWeapons[ESX.PlayerData.job.grade_name] do
	
	    local v = Config.AuthorizedWeapons[ESX.PlayerData.job.grade_name][i]
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;"></span>'):format(weapon.label)
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
		
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
				   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Have Been Given A [~g~'..data.current.weaponLabel..'~s~]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
				   menu.close()
				   OpenBuyWeaponsMenu()
			   else
				   ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'bottom-right',
		css      = 'entreprise',
		elements = components
	}, function(data, menu)
	
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
					   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Purchased A [~g~'..data.current.componentLabel.. '~s~] For $' ..ESX.Math.GroupDigits(data.current.price), mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_police'),
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
		
	elseif part == 'VehicleDeleter' then
	
    local coords    = GetEntityCoords(PlayerPedId())

    if IsPedInAnyVehicle(PlayerPedId(),  false) then

      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end
    end	
		
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'offpolice' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

--Normal Handcuff 
RegisterNetEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5')
AddEventHandler('80586cd0-4d96-c4c9-8058-1dd3678d14d5', function()

  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if not IsPedCuffed(PlayerPedId()) then
      --TriggerEvent("RPAnimations:CancelHands")
	  --Citizen.Wait(100)
	  
	  ClearPedTasksImmediately(PlayerPedId())
      RequestAnimDict('mp_arresting')
      while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(100)
      end

	  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2, "Handcuff", 0.5)
      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
	  TriggerServerEvent('esx_policejob:SetHandCuffStatus', 'true')
	  DisplayRadar(false)
	  
	if GetEntityModel(playerPed) == femaleHash then -- mp female
       prevFemaleVariation = GetPedDrawableVariation(playerPed, 7)
       SetPedComponentVariation(playerPed, 7, 25, 0, 0)
        
    elseif GetEntityModel(playerPed) == maleHash then -- mp male
       prevMaleVariation = GetPedDrawableVariation(playerPed, 7)
       SetPedComponentVariation(playerPed, 7, 41, 0, 0)
    end
		
    else
	
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
	  TriggerServerEvent('esx_policejob:SetHandCuffStatus', 'false')
	  DisplayRadar(true)
	  
	if GetEntityModel(playerPed) == femaleHash then -- mp female
       SetPedComponentVariation(playerPed, 7, prevFemaleVariation, 0, 0)
               
    elseif GetEntityModel(playerPed) == maleHash then -- mp male
           SetPedComponentVariation(playerPed, 7, prevMaleVariation, 0, 0)
      end
    end
  end)
end)

--Handcuff Hotkey
Citizen.CreateThread(function()    
    while true do
		Citizen.Wait(5)		  
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			if IsControlJustPressed(1, 73) and IsControlPressed(1, 21) then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					if IsPedCuffed(GetPlayerPed(player)) then
						TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5', GetPlayerServerId(player))			   
					else
						TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5', GetPlayerServerId(player))
				--     if IsPedBeingStunned(GetPlayerPed(player)) or IsEntityPlayingAnim(GetPlayerPed(player), "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(GetPlayerPed(player), "random@arrests@busted", "idle_a", 3) then
				-- 	   TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5', GetPlayerServerId(player))
				--   else
				-- 	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Civilian has not got their hands up', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
				--     end
					end
				else
					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] No Civilians Nearby', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
				end
			end
		else
			Citizen.Wait(10000)
		end
	end
end)

RegisterNetEvent('esx_policejob:trackerTaken')
AddEventHandler('esx_policejob:trackerTaken', function()
	if ESX.GetPlayerData().job == 'police' then
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('LSPD', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Your tracker was smashed', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
		TriggerServerEvent('duty:police2')	  	
		Citizen.Wait(1000)
		TriggerEvent('CR_DutyBlips:updateBlip')
		--TriggerServerEvent('CR_DutyBlips:spawned')
		exports.ft_libs:DisableArea("esx_eden_garage_area_police_mecanodeletepoint")		
		exports.ft_libs:DisableArea("esx_eden_garage_area_police_mecanospawnpoint")
	end
end)

RegisterNetEvent('esx_policejob:CheckIsCuffed')
AddEventHandler('esx_policejob:CheckIsCuffed', function()
	isCuffed = false

	ESX.TriggerServerCallback('esx_policejob:GetHandCuffStatus', function(isCuffed)
	if isCuffed then
	
	RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do
       Wait(100)
    end
	
       TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
       SetEnableHandcuffs(PlayerPedId(), true)
       SetPedCanPlayGestureAnims(PlayerPedId(), false)
	   DisplayRadar(false)
	   
	if GetEntityModel(PlayerPedId()) == femaleHash then -- mp female
       prevFemaleVariation = GetPedDrawableVariation(PlayerPedId(), 7)
       SetPedComponentVariation(PlayerPedId(), 7, 25, 0, 0)
        
    elseif GetEntityModel(PlayerPedId()) == maleHash then -- mp male
       prevMaleVariation = GetPedDrawableVariation(PlayerPedId(), 7)
       SetPedComponentVariation(PlayerPedId(), 7, 41, 0, 0)
    end	
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Were Hancuffed When You Left', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
    end
  end)
end)

RegisterNetEvent('22fe76e3-719a-4b38-8f63-b0a30853c7a9')
AddEventHandler('22fe76e3-719a-4b38-8f63-b0a30853c7a9', function(copId)

	if IsPedCuffed(PlayerPedId()) then
	   dragStatus.isDragged = not dragStatus.isDragged
	   dragStatus.CopId = copId
   else
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Player Must Be Handcuffed First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
	end
end)

Citizen.CreateThread(function()
	local wasDragged

	while true do
		Citizen.Wait(0)

		if IsPedCuffed(PlayerPedId()) and dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

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

RegisterNetEvent('345e1048-bb15-4328-acf5-3af296e1a207')
AddEventHandler('345e1048-bb15-4328-acf5-3af296e1a207', function()
	-- if IsPedCuffed(PlayerPedId()) then
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
	-- end
end)

RegisterNetEvent('cfc9f1f9-f664-43d7-b444-e2554f825aad')
AddEventHandler('cfc9f1f9-f664-43d7-b444-e2554f825aad', function()

	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
		ClearPedTasksImmediately(PlayerPedId())
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsPedCuffed(PlayerPedId()) then
		
			--DisableControlAction(0, 1, true) -- Disable pan
			--DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			DisableControlAction(0, 20, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

--Loop To Re Play Animation If cuffed
Citizen.CreateThread(function()
  while true do
    Wait(0)

    if IsPedCuffed(PlayerPedId()) then
     if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
	 
	    RequestAnimDict('mp_arresting')
		
        while not HasAnimDictLoaded('mp_arresting') do
          Wait(100)
        end  
		
	     TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)	  
      end
	else
	    Citizen.Wait(1000)
    end
  end
end)


-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)


JobGrade = { 
    "LSConstable",
    "LSCHighwayI",
    "LSCSOGI",
    "LSCDetectiveI",
    "Sergeant",
    "SnrSgtHighwayII",
    "SnrSgtSOGII",
    "SSDetectiveII",
	"Inspector",
	"InspHighwayII",
    "InspSOGII",
    "InspDetectiveII",
	"Superintendent",
	"SuptHighwayIII",
    "SuptSOGIII",
    "SuptDetectiveIII",
	"Commander",
	"ComHighwayIII",
	"ComSOGIII",
	"ComDetectiveIII",
	"boss",
}

-- Draw markers and more
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, hasExited, letSleep = false, false, true
		local currentStation, currentPart, currentPartNum
		distancemrpd = #(playerCoords - Config.PoliceStations['LSPD']['Blip']['Coords'])
		
		for k,v in pairs(Config.PoliceStations) do
			
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'offpolice' then
				for i=1, #v.Cloakrooms, 1 do
					local distance = #(playerCoords - v.Cloakrooms[i])

					if distance < Config.DrawDistance then
					   DrawMarker(21, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
						end
					end
				end
			end
			
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
				for i=1, #v.Armories, 1 do
					local distance = #(playerCoords - v.Armories[i])

					if distance < Config.DrawDistance then
					   DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				end
						
				for i=1, #v.Vehicles, 1 do
					local distance = #(playerCoords - v.Vehicles[i].Spawner)

					if distance < Config.DrawDistance then
					   DrawMarker(36, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
						end
					end
				end
			 		
                local grade = ESX.PlayerData.job.grade_name
					
			    for i = 1, #JobGrade do			
                  if grade == JobGrade[i] then
				  
		            for i=1, #v.Helicopters, 1 do
					local distance =  #(playerCoords - v.Helicopters[i].Spawner)

					if distance < Config.DrawDistance then
					   DrawMarker(34, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
						end
					  end
				    end   
                  end
                end
			 				
				for i=1, #v.Impounds, 1 do
					local distance =  #(playerCoords - v.Impounds[i].Spawner)

					if distance < Config.DrawDistance then
					   DrawMarker(36, v.Impounds[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 204, 0, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Impounds', i
						end
					end
				end
				
				for i=1, #v.VehicleDeleter, 1 do
					local distance = #(playerCoords - v.VehicleDeleter[i])

					if distance < Config.DrawDistance then
					   DrawMarker(20, v.VehicleDeleter[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					   letSleep = false

						if distance < Config.MarkerSize.x then
						   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'VehicleDeleter', i
						end
					end
				end
											
				if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = #(playerCoords - v.BossActions[i])

						if distance < Config.DrawDistance then
						   DrawMarker(21, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)
						   letSleep = false

							if distance < Config.MarkerSize.x then
							   isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
							end
						end
					end
				end				
			end
		end
					
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
			if (LastStation and LastPart and LastPartNum) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
			   TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			   hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
		   HasAlreadyEnteredMarker = false
		   TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end

		if letSleep then
		   Citizen.Wait(500)
		end
	end
end)

--Enter / Exit entity zone events
Citizen.CreateThread(function()

	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(playerCoords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
			   local objCoords = GetEntityCoords(object)
			   local distance = #(playerCoords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
				   closestDistance = distance
				   closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
			   TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
			   LastEntity = closestEntity
			end
		else
			if LastEntity then
			   TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
			   LastEntity = nil
			end
		end
	end
end)

--Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local Wait = 1000
		if loaded then
			if ESX.PlayerData ~= nil and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData ~= nil and ESX.PlayerData.job.name == 'offpolice' then
				if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
					Wait = 0
					OpenPoliceActionsMenu()
				end
			
				if IsControlJustReleased(0, 38) and currentTask.busy then
					Wait = 0
					ESX.ShowNotification(_U('impound_canceled'))
					ESX.ClearTimeout(currentTask.task)
					ClearPedTasks(PlayerPedId())    
					currentTask.busy = false
				end
				if CurrentAction then
					Wait = 0
					ESX.ShowHelpNotification(CurrentActionMsg)
					if IsControlJustReleased(0, 38) then      
						if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'offpolice' then
							if CurrentAction == 'menu_cloakroom' then
								OpenCloakroomMenu()
							elseif CurrentAction == 'menu_armory' then
								OpenArmoryMenu(CurrentActionData.station)
							elseif CurrentAction == 'menu_vehicle_spawner' then
								OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
							elseif CurrentAction == 'Helicopters' then			
								OpenHelicoptorMenu(CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)	
							elseif CurrentAction == 'delete_vehicle' then
								StoreNearbyVehicle()
							elseif CurrentAction == 'menu_boss_actions' then
								ESX.UI.Menu.CloseAll()
								TriggerEvent('c3733e85-777a-8285-4836-20b26c07edbc', 'police', function(data, menu)
									menu.close()
									CurrentAction     = 'menu_boss_actions'
									CurrentActionMsg  = _U('open_bossmenu')
									CurrentActionData = {}
								end, { wash = false })
							elseif CurrentAction == 'remove_entity' then					
								NetworkRequestControlOfEntity(CurrentActionData.entity) 
								SetEntityAsMissionEntity(CurrentActionData.entity, false, true)
								ESX.Game.DeleteObject(CurrentActionData.entity)
								-- DeleteEntity(CurrentActionData.entity)
							end
							CurrentAction = nil
						end
					end 
				end
			else
				Citizen.Wait(1000)
			end
		end
	end
end)

function OpenHelicoptorMenu(station, part, partNum)
  local shopCoords = Config.PoliceStations[station][part][partNum]['SpawnPoints'][1]['coords']
  local elements = {
    {label = ('Vehicle List'), value = 'vehicle_list'},
   }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'heli_actions',
    {
      title    = ('Police Options'),
	  align    = 'bottom-right',
	  css      = 'entreprise',
      elements = elements
    },
    function(data, menu)
        if data.current.value == 'vehicle_list' then

            local elements = {
			  {label = ('VicPol Helicoptor')}
            }

            ESX.UI.Menu.CloseAll()

             ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'vehicle_spawner',
              {
                title    = ('vehicle Spawner'),
				align    = 'bottom-right',
	            css      = 'entreprise',
                elements = elements
              },
             function(data, menu)
             menu.close()
			 				
            if not IsAnyVehicleNearPoint(shopCoord, 6.0) then
				
                ESX.Game.SpawnVehicleaa7b('polair', shopCoords, Config.PoliceStations[station][part][partNum]['SpawnPoints'][1]['heading'], function(vehicle)
				SetVehicleDirtLevel(vehicle, 0.0)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetEntityAsMissionEntity(vehicle, true, true)
             end)
			    Citizen.Wait(250)
				TriggerEvent("fuel:SetNewData", 100)
            else
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Action Denied! Please Wait For The Current Vehicle To Move First', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
			 end
           end,
               function(data, menu)
                 menu.close()
              end
            )
        end	  	  	 
    end,
    function(data, menu)
       menu.close()
       CurrentAction     = 'Helicopters'
       CurrentActionMsg  = _U('helicopter_prompt')
       CurrentActionData = {station = station, part = part, partNum = partNum}
    end
  )
end

function StoreNearbyVehicle()
  
  if IsPedInAnyVehicle(PlayerPedId(), false) then
  
     local vehicle     = GetVehiclePedIsIn(PlayerPedId(), false)
     local plateNumber = GetVehicleNumberPlateText(vehicle)
	 Fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))
	 FuelValue = tonumber(Fuel) 
    
	ESX.TriggerServerCallback('esx_policejob:Owner', function (isOwner)	
	if isOwner then
	
	    local Passengers = GetVehicleMaxNumberOfPassengers(vehicle)

			for i = -1, Passengers, 1 do
																	    
				local pedSeat = GetPedInVehicleSeat(vehicle, i)	
							
				if pedSeat ~= 0 then						
                   ID = GetPlayerServerId(NetworkGetEntityOwner(pedSeat))						   
                   TriggerServerEvent('esx_policejob:EjectUsers', ID)	
                end							
			end
	
	    TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
	
	    while IsPedInVehicle(PlayerPedId(), vehicle, true) do
		   Citizen.Wait(0)
	    end
		
		if GetVehicleNumberOfPassengers(vehicle) == 0 then
	       Citizen.Wait(1000)
		   ESX.Game.DeleteVehicle(vehicle)
	   else						
		   Citizen.Wait(1300)
		   ESX.Game.DeleteVehicle(vehicle)
		end
		
	     TriggerServerEvent('esx_policejob:modifystate', plateNumber, true)
		 TriggerServerEvent('eden_garage:savefuel', plateNumber, FuelValue)
		 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] This Vehicle Is Now Stored', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
     else 
	     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Do Not Own This Vehicle', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
	  end 
    end, plateNumber)
  end
end

RegisterNetEvent('e8fa6d55-a686-4483-b3a4')--esx_policejob:revive
AddEventHandler('e8fa6d55-a686-4483-b3a4', function()--esx_policejob:revive

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
      Citizen.Wait(0)
    end

    ESX.SetPlayerData('lastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    TriggerServerEvent('esx:updateLastPosition', {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

    RespawnPed(playerPed, {
      x = coords.x,
      y = coords.y,
      z = coords.z
    })

     StopScreenEffect('DeathFailOut')
     DoScreenFadeIn(800)
  end)
end)

AddEventHandler('playerSpawned', function(spawn)

	isDead = false

	if not hasAlreadyJoined then
	   TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function ImpoundVehicle(vehicle)

   ESX.Game.DeleteVehicle(vehicle)
   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] That Vehicle Has Now Been Cleared From The World', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
   currentTask.busy = false
end

function Impoundit(vehicle)

    local playerPed = GetPlayerPed(-1)	
    local vehicle2 =GetVehiclePedIsIn(playerPed,false)
				
	--if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				
      local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	  TriggerServerEvent('eden_garage:ChangeStateFromFourriereMecano', vehicleProps, true)             
      ESX.Game.DeleteVehicle(vehicle)
	  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] That Vehicle Is Now In The Police Impound', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)		
  -- end
end

function crushthevehicle()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local vehicleProps = ESX.Game.GetVehicleProperties(veh)
	
	if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then 
	
	   ESX.Game.DeleteVehicle(veh)
	   TriggerServerEvent('esx_policejob:deleteit', true, vehicleProps)
       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId());ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] That Vehicle Has Now Been Crushed', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
   else
	   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId());ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Must Be In The Drivers Seat', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
    end
end


local Fingerprints = {
	{ ['x'] = 474.45, ['y'] = -1013.21, ['z'] = 26.27 },	
}

Citizen.CreateThread(function()
	while true do
		-- Citizen.Wait(5)    
		local Wait = 500
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for i = 1, #Fingerprints do
			local Marker = vector3(Fingerprints[i].x, Fingerprints[i].y, Fingerprints[i].z)
			local dist = #(pos - Marker)
			if dist < 3.0 then		
				DrawMarker(1, Fingerprints[i].x, Fingerprints[i].y, Fingerprints[i].z - 1, 0, 0, 0, 0, 0, 0, 0.9001, 0.9001, 0.5001, 255, 0, 0, 165, 0,0, 0,0)
				Wait = 0
				if dist < 1.1 then
					DisplayHelpText("~g~Press ~INPUT_CONTEXT~ ~w~To Scan Your Fingerprints")
					if IsControlJustPressed(1, 38) then	
						if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
							local player, distance = ESX.Game.GetClosestPlayer()              
							if distance ~= -1 and distance <= 2.0 then
								TriggerEvent("mythic_progbar:client:progress", {
									name = "police_prints",
									duration = 5500,
									label = "Scanning Fingerprints",
									useWhileDead = false,
									canCancel = false,
									controlDisables = {
										disableMovement = true,
										disableCarMovement = false,
										disableMouse = false,
										disableCombat = true,
									},
									animation = {
										animDict = "cellphone@self@michael@",
										anim = "run_chin",
									},
								},function(status)		                     
									ClearPedTasks(PlayerPedId())
									TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
								end) 															                      
							else
								local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] No Civilians Nearby', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
							end  
						else 
							local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~POLICE ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Are Not A Police Officer', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	   
						end
					end
				end
			end
		end
		Citizen.Wait(Wait)
	end
end)
   	  
function OpenAnimationsMenupolice()

	local elements = {}

	 table.insert(elements, {label = ('Stop Animation'),       value = 'stop'}) 	
	 table.insert(elements, {label = ('Investigating Ground'), value = 'Investigating'}) 
	 table.insert(elements, {label = ('Arms Crossed'),         value = 'armscrossed'}) 
	 table.insert(elements, {label = ('Hands On Belt'),        value = 'Belt'}) 
	 table.insert(elements, {label = ('Traffic Control'),      value = 'Traffic'}) 
	 table.insert(elements, {label = ('Observing'),            value = 'Observing'}) 
	 table.insert(elements, {label = ('Take A Photo'),         value = 'Photo'}) 
	 table.insert(elements, {label = ('Notepad'),              value = 'Notepad'}) 

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'animations',
		{
			title    = 'Police Animations',
			align    = 'bottom-right',
			css      = 'entreprise',
			elements = elements
		},
		function(data, menu)
		
		if data.current.value == 'stop' then
           ClearPedTasksImmediately(PlayerPedId())		
		   
        elseif data.current.value == 'Investigating' then
		   RequestAnimDict("amb@code_human_police_investigate@idle_b")  
	
	       while not HasAnimDictLoaded( "amb@code_human_police_investigate@idle_b") do
	          Citizen.Wait(0)
	       end  
	        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_police_investigate@idle_b" ,"idle_f" ,8.0, -8.0, -1, 0, 0, false, false, false )
		  
		elseif data.current.value == 'armscrossed' then
		   RequestAnimDict("anim@amb@nightclub@peds@")  
	
	       while not HasAnimDictLoaded( "anim@amb@nightclub@peds@") do
	          Citizen.Wait(0)
	       end  		   
	        TaskPlayAnim(GetPlayerPed(-1), "anim@amb@nightclub@peds@" ,"rcmme_amanda1_stand_loop_cop" ,8.0, -8.0, -1, 49, 0, false, false, false )  
		  
        elseif data.current.value == 'Belt' then
           TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, false)		   
		   
		elseif data.current.value == 'Traffic' then
           TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)				   
		   
		elseif data.current.value == 'Observing' then
		   TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, false)	
		   
		elseif data.current.value == 'Photo' then
		   TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_PAPARAZZI", 0, false)	
		   
		elseif data.current.value == 'Notepad' then
		   TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)	
	    end
	end,
	  function(data, menu)
	    menu.close()
	 end
	)
end

RegisterNetEvent('esx_policejob:PutPlayerInBag')
AddEventHandler('esx_policejob:PutPlayerInBag', function()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    deadCheck = IsEntityDead(playerPed)

    if deadCheck and not attached then
        SetEntityVisible(playerPed, false, false)
        
        RequestModel("xm_prop_body_bag")

        while not HasModelLoaded("xm_prop_body_bag") do
            Citizen.Wait(1)
        end

       bodyBag = CreateObject(`xm_prop_body_bag`, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
	   DecorSetInt(bodyBag ,decorName, decorInt)
       AttachEntityToEntity(bodyBag, playerPed, 0, -0.2, 0.75, -0.2, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
       attached = true
	   SetModelAsNoLongerNeeded(bodyBag)
    end	
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		
        local playerPed = PlayerPedId()
        
        deadCheck = IsEntityDead(playerPed)

        if not deadCheck and attached then

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

function RespawnPed(ped, coords)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
  SetPlayerInvincible(ped, false)
  TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
  ClearPedBloodDamage(ped)
  
  if RespawnToHospitalMenu ~= nil then
    RespawnToHospitalMenu.close()
    RespawnToHospitalMenu = nil
  end
    ESX.UI.Menu.CloseAll()
end   
     
function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function OpenIdentityCardMenu(player)

	if Config.EnableESXIdentity then
  
	  ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
  
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
  
		ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'citizen_interaction',
		  {
			title    = _U('citizen_interaction'),
			align    = 'bottom-right',
			css      = 'entreprise',
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

		local jobLabel    = nil
		local sexLabel    = nil
		local sex         = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
  
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