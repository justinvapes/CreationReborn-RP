local ESX = nil
local InHack = false	
local RobTime = 0	

function DeleteNetObj(obj)
  local tablet = ObjToNet(obj)
  TriggerServerEvent('CR_Atm_Robbery:DeleteNetObj', tablet)
end

RegisterNetEvent("CR_Atm_Robbery:DeleteNetObj")
AddEventHandler("CR_Atm_Robbery:DeleteNetObj", function(obj)
    local tablet = NetToObj(obj)
    DeleteEntity(tablet)
end)

Citizen.CreateThread(function()
  while ESX == nil do
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
     Citizen.Wait(0)
  end
  
  AddTextEntry("InstructionsATM", Config.HelpTextMessage)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  
  Citizen.Wait(5000)
  
  ESX.TriggerServerCallback("CR_Atm_Robbery:RetrieveTime", function(Timer, Time)
    
    if Timer then
       RobTime = Time
       RunTimer()
    end
  end)
end)

AddEventHandler('onResourceStart', function(resourceName)

  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  
  Citizen.Wait(5000)	
  ESX.TriggerServerCallback("CR_Atm_Robbery:RetrieveTime", function(Timer, Time)
    
    if Timer then
       RobTime = Time
       RunTimer()
    end
  end)
end)

function StartTimer()
  
  TriggerServerEvent("CR_Atm_Robbery:SetTime")
  Citizen.Wait(100)
  
  ESX.TriggerServerCallback("CR_Atm_Robbery:RetrieveTime", function(Timer, Time)
    
    if Timer then
       RobTime = Time
       RunTimer()
    end
  end)
end

function RunTimer()
  Citizen.CreateThread(function()
    
    while RobTime > 0 do
      
       RobTime = RobTime - 1
       TriggerServerEvent("CR_Atm_Robbery:updateRobTime", RobTime)								 
       Citizen.Wait(60000)
    end
  end)
end 

RegisterNetEvent('CR_Atm_Robbery:Succsess')
AddEventHandler('CR_Atm_Robbery:Succsess', function(HackAmount)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~ATM ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~s~] Hack Success! You Recieved $[~g~"..HackAmount..'~s~]', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
end)

--ATM Hacking
--levels is how many levels you want. Max is 4, Min is 1
--lifes is how many life player has, Max is 6, Min is 1
--time is how much time player has in minutes, Max is 9, min is 1 (I highly recommend to set it between 3-1)
--callback is the callback function to catch the outcome

Citizen.CreateThread(function()
  while true do
    local sleep = 100
    
    if nearATM() then
       sleep = 5
      
      if ESX.GetPlayerData().job.name == 'police' then
         DisplayHelpText("~y~Press ~w~~INPUT_PICKUP~ To ~g~Use ~w~The ~b~ATM ~b~")
     else
         BeginTextCommandDisplayHelp("InstructionsATM")
         EndTextCommandDisplayHelp(0, 0, 1, -1)
      end
      
      if IsControlJustPressed(1, 38) then
         TriggerEvent('bank:OpenUI')
        
      elseif IsControlJustPressed(1, 47) then
        
        ESX.TriggerServerCallback("CR_Atm_Robbery:RetrieveTime", function(Timer, Time)
          if Timer then					
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~ATM ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~s~] You Can't Hack Another ATM For [~g~"..Time..'~s~]~b~Minutes', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
          else  
            
            ESX.TriggerServerCallback('CR_Atm_Robbery:GetCops', function(PoliceOnline)
              if PoliceOnline >= Config.PoliceNeeded then
                			
                local inventory = ESX.GetPlayerData().inventory
                local count = 0 
                
                for i=1, #inventory, 1 do
                  if inventory[i].name == 'fscanner' then
                     count = inventory[i].count
                  end
                end
                
                if (count > 0) then	
                  
                  InHack = true				
                  local PoliceChance = math.random(0, 100)
                  
                  if PoliceChance <= Config.PoliceChance then	
                     local playerloc = GetEntityCoords(PlayerPedId(), 0)
                     TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', "Someone Has Been Spotted Tampering With An Atm At", { x = playerloc['x'], y = playerloc['y'], z = playerloc['z'] })
                  end
                  local playerPed = PlayerPedId()
                  local dict = "amb@world_human_seat_wall_tablet@female@base"
                  RequestAnimDict(dict)
                  if tabletObject == nil then
                      tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
                      AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                  end
                  while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
                  if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
                      TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
                  end
                  TriggerEvent("utk_fingerprint:Start", 4, 2, 2, function(outcome, reason)			
                    if outcome == true then              
                       InHack = false	
                       DeleteNetObj(tabletObject)
                       ClearPedTasks(PlayerPedId())
                       tabletObject = nil
                       TriggerServerEvent('CR_Atm_Robbery:GiveMoney')
                       StartTimer()				   
                    elseif outcome == false then
                      DeleteNetObj(tabletObject)
                      ClearPedTasks(PlayerPedId())
                      tabletObject = nil
                       local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~ATM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Hack Attempt ~r~Failed! - ' .. reason, mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
                       InHack = false	
                    end				
                  end)				  
                else
				   local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~ATM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Need A Fingerprint Scanner To Attempt This!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
                end
              else
			     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~ATM ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] Sorry! There Is Currently Not Enough Police Online!', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
              end				    
            end)
          end
        end)
      end	
    end
    Citizen.Wait(sleep)
  end
end)

function nearATM()
  
  local playerPos = GetEntityCoords(PlayerPedId())	
  
  for i = 1, #Config.Atms do
    
    local Atms = vector3(Config.Atms[i].x, Config.Atms[i].y, Config.Atms[i].z)
    local distance = #(playerPos - Atms)
    
    if distance <= 0.7 then
       return true
    end
  end
end

function DisplayHelpText(str)
   SetTextComponentFormat("STRING")
   AddTextComponentString(str)
   DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    
    if InHack then		
       DisableControlAction(0, 1, true)--Disable Mouse Pan
       DisableControlAction(0, 2, true)--Disable Mouse Tilt	 
   else
       Citizen.Wait(500)
    end
  end
end)