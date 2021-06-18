-----Created By GigaBytes For AustralisGamingNetwork-----

ESX           = nil
local injured = false
local HealthSet = true
local ArmourSet = true

Citizen.CreateThread(function()
    while ESX == nil do
	 TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	 Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('AGN:GetArmourandHealth')
end)

RegisterNetEvent("AGN:SetHealth")
AddEventHandler("AGN:SetHealth", function(healthlvl)
	Citizen.Wait(1000)
	newhealth = tonumber(healthlvl)
	local ped = nil
	while ped == nil do
		Citizen.Wait(50)
		ped = PlayerPedId()
	end
	SetEntityMaxHealth(ped, 200)
	SetPedMaxHealth(ped, 200)
	SetEntityHealth(ped, newhealth)
	HealthSet = true
end)
   
RegisterNetEvent("AGN:SetArmour")
AddEventHandler("AGN:SetArmour", function(armourlvl)
	Citizen.Wait(1000)
	newarmour = tonumber(armourlvl)
	local ped = nil
	while ped == nil do
		Citizen.Wait(50)
		ped = PlayerPedId()
	end
	SetPedArmour(ped, newarmour)
	ArmourSet = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(120000)
		if PlayerPedId() and PlayerPedId() ~= -1 and HealthSet then 
			local health = GetEntityHealth(PlayerPedId())

			TriggerServerEvent('AGN:Health', GetPlayerServerId(PlayerId()), health)	

			if ArmourSet then
				local armour = GetPedArmour(PlayerPedId())
				TriggerServerEvent('AGN:Armour', GetPlayerServerId(PlayerId()), armour)	
			end
		end
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

	local health = GetEntityHealth(PlayerPedId())	
	if not exports["CR_Misc"]:isCrouching() then
	
    if health <= 150 and health >= 125 then
	
	    RequestAnimSet("move_injured_generic")    
      	while not HasAnimSetLoaded("move_injured_generic") do
        	Citizen.Wait(0)
      	end		
      	SetPedMovementClipset(PlayerPedId(), "move_injured_generic", true)
		injured = true
				
	elseif health <= 124 and health >= 100 then
		
		RequestAnimSet("move_heist_lester")    
      	while not HasAnimSetLoaded("move_heist_lester") do
        	Citizen.Wait(0)
      	end		
      	SetPedMovementClipset(PlayerPedId(), "move_heist_lester", true)
		injured = true
		
    elseif health == 200 and injured == true then
		   ResetPedMovementClipset(PlayerPedId(), 0.0)
		   exports["dpemotes"]:ResetCurrentWalk()
		   injured = false
		end		
	end
	end
end)