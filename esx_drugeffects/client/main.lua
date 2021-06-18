ESX                  = nil
local stam           = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

--Weed
RegisterNetEvent('CR_drugeffects:onjoints')
AddEventHandler('CR_drugeffects:onjoints', function()
  
  local playerPed = GetPlayerPed(-1)
  
    RequestAnimSet("move_m@hipster@a") 
    while not HasAnimSetLoaded("move_m@hipster@a") do
      Citizen.Wait(0)
    end    

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(5000)
    ClearPedTasksImmediately(playerPed)
	SetTimecycleModifier("spectator5")
    SetPedMovementClipset(playerPed, "move_m@hipster@a", true)
    SetPedIsDrunk(playerPed, true)
    
    --Efects
    local playerPed = GetPlayerPed(-1)   
    Wait(300000)		
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    exports["dpemotes"]:ResetCurrentWalk()
	ESX.ShowNotification('Marijuana Effects Have Now Worn Off')
end)


--Cocaine
RegisterNetEvent('CR_drugeffects:oncocaine')
AddEventHandler('CR_drugeffects:oncocaine', function()
  
  local playerPed = GetPlayerPed(-1)
  local maxHealth = GetEntityMaxHealth(playerPed)


    RequestAnimDict("move_p_m_two_idles@generic")
    while (not HasAnimDictLoaded("move_p_m_two_idles@generic")) do Citizen.Wait(0) end 	  
	TaskPlayAnim(playerPed, "move_p_m_two_idles@generic", "fidget_sniff_fingers", 8.0, -8.0, -1, 1, 0, false, false, false )		


    Citizen.Wait(5000)
    ClearPedTasksImmediately(playerPed)
    SetPedMovementClipset(playerPed, "move_m@hipster@a", true)
    SetPedIsDrunk(playerPed, true)
    stam = 1
    local playerPed = GetPlayerPed(-1)
    SetRunSprintMultiplierForPlayer(playerPed, 1.49) 
    SetSwimMultiplierForPlayer(player, 1.49) 	
    Wait(100000)
	ESX.ShowNotification('Cocaine Effects Are Wearing Off')
	Wait(80000)    
    SetRunSprintMultiplierForPlayer(playerPed, 1.0)
	SetSwimMultiplierForPlayer(player, 1.0)
	ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    exports["dpemotes"]:ResetCurrentWalk()
	ESX.ShowNotification('You Are Now Coming Down Off Cocaine')
	stam = 0
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if stam == 1 then
    RestorePlayerStamina(PlayerId(), 1.0)
  end
 end
end)