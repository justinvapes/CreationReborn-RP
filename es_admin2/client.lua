local group
local states      = {}
states.frozen     = false
states.frozenPos  = nil
local ESX         = nil

Citizen.CreateThread(function()
	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(0)
	end
	
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end
        
    if ESX.IsPlayerLoaded() then
    --    NetworkSetTalkerProximity(6.0)
    --    TriggerServerEvent('es_admin2:PlayerLoaded')    
    end

    while group == nil do       
        Citizen.Wait(250) 
        ESX.TriggerServerCallback('CR_Misc:GetGroup', function(g)
            group = g
        end)
    end

end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if (IsControlJustPressed(1, 212) and IsControlJustPressed(1, 213)) then
			if group ~= nil then
				if group ~= "user" then
					SetNuiFocus(true, true)
					SendNUIMessage({type = 'open', players = getPlayers()})
				end
			end
		end
	end
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
       SetNuiFocus(false)    
    end
end)

RegisterNUICallback('dev', function(data)
    TriggerServerEvent('es_admin:DevOptions', data.type)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "revive_all" then
		TriggerServerEvent('310a7025-571e-4742-8817-4f3f140d2070', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('vehicle', function(data, cb)
   TriggerServerEvent('es_admin:VehicleOptions', data.id, data.type)
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)

local noclip    = false
local change    = false
local Explosive = false

RegisterNetEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(t, target)

	-- if t == "skin" then 
	-- 	TriggerEvent('esx_skin:openMenu')
	-- 	TriggerEvent("chatMessage", "[CR Staff] - ", {255, 0, 0}, " You Have Had A Skin Menu ^2Forced")
	-- end
	
	if t == "slay" then 
		SetEntityHealth(PlayerPedId(), 0) 
	end
		
	if t == "explode" then 
		local Coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		AddExplosion(Coords.x, Coords.y, Coords.z, 5, 50.0, true, false, true)
	end	
	
	if t == "goto" then 
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))))	   
	end
	
	if t == "bring" then 
		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
	end
	
	if t == "crash" then 
		Citizen.CreateThread(function()
			while true do end
		end) 
	end
	
	if t == "freeze" then
		local player = PlayerId()
		
		local ped = GetPlayerPed(-1)
		
		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)
		
		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end
			
			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end
			
			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)
			
			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
	end
	
	if t == "heal" then
		TriggerEvent('6dhrgt-47632g-kfjt84-jfgh73', PlayerPedId())
		TriggerEvent("chatMessage", "[CR Staff] - ", {255, 0, 0}, " You Have Been ^2Revived")
	end
end)


RegisterNetEvent('es_admin:quickAll')
AddEventHandler('es_admin:quickAll', function(t, target)
	
	if t == "slay" then 
		SetEntityHealth(PlayerPedId(), 0) 
	end
		
	if t == "explode" then 
		local Coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		AddExplosion(Coords.x, Coords.y, Coords.z, 5, 50.0, true, false, true)
	end	
	
	if t == "goto" then 
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))))	   
	end
	
	if t == "bring" then 
		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
	end
		
	if t == "revive_all" then
		TriggerEvent('6dhrgt-47632g-kfjt84-jfgh73', PlayerPedId())
		TriggerEvent("chatMessage", "[CR Staff] - ", {255, 0, 0}, " You Have Been ^2Revived")
	end
end)

RegisterNetEvent('es_admin:vehicle')
AddEventHandler('es_admin:vehicle', function(t, target)

	if t == "ExplosiveB" then 
		Explosive = not Explosive;
			
		if Explosive then
			ESX.ShowNotification('Explosive Bullets [~g~On~s~]')	
			while Explosive == true do		
				Citizen.Wait(0)
				
				if IsPedArmed(GetPlayerPed(GetPlayerFromServerId(target)), 7) then
					
					local State, ImpactCoord = GetPedLastWeaponImpactCoord(GetPlayerPed(GetPlayerFromServerId(target)))
					
					if State then
						AddExplosion(ImpactCoord.x, ImpactCoord.y, ImpactCoord.z, 5, 50.0, true, false, true)
					end
				else end
			end
		else 
			ESX.ShowNotification('Explosive Bullets [~r~Off~s~]')	
		end
	end
	
	if t == "flip180" then 
		
		if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), false) then
			
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(target)))
			local Heading = GetEntityHeading(vehicle)
			local speed = GetEntitySpeed(vehicle)
			
			if NetworkRequestControlOfEntity(vehicle) then
				
				if Heading > 180.0 then
					Heading = Heading - 180.0
				else 
					Heading = Heading + 180.0
				end
				SetEntityHeading(vehicle, Heading)
				SetVehicleForwardSpeed(vehicle, speed)
			end
		end
	end
	
	if t == "kickflip" then 
		
		if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), false) then
			
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(target)))
			local Heading = GetEntityHeading(vehicle)
			local speed = GetEntitySpeed(vehicle)
			
			if NetworkRequestControlOfEntity(vehicle) then
				ApplyForceToEntity(vehicle, 1, 0.0, 0.0, 10.0, 15.0, 0.0, 0.0, true, false, true, true, true, true)
			end
		end
	end
	
	if t == "rainbow" then 
		
		if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), false) then
			
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(target)))
			local Heading = GetEntityHeading(vehicle)
			local speed = GetEntitySpeed(vehicle)
			SetVehicleDirtLevel(vehicle, 0.0)
			
			if NetworkRequestControlOfEntity(vehicle) then	  
				change = not change;
				
				if change then
					while change == true do		
						Citizen.Wait(300)
						
						col = math.random(001, 160)	  
						SetVehicleColours(vehicle, col, col)
					end
				else end	 			    
			end
		end
	end
	
	if t == "pink" then 
		
		if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), false) then
			
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(target)))
			local Heading = GetEntityHeading(vehicle)
			local speed = GetEntitySpeed(vehicle)
			SetVehicleDirtLevel(vehicle, 0.0)
			
			if NetworkRequestControlOfEntity(vehicle) then	  																	 
				SetVehicleColours(vehicle, 137, 137)									 			    
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			SetEntityCoords(GetPlayerPed(-1), states.frozenPos)
		end
	end
end)

local heading = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(noclip)then
			SetEntityCoordsNoOffset(GetPlayerPed(-1),  noclip_pos.x,  noclip_pos.y,  noclip_pos.z,  0, 0, 0)

			if(IsControlPressed(1,  34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end
				SetEntityHeading(GetPlayerPed(-1),  heading)
			end
			if(IsControlPressed(1,  9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end
				SetEntityHeading(GetPlayerPed(-1),  heading)
			end
			if(IsControlPressed(1,  8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
			end
			if(IsControlPressed(1,  32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1,  27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, 1.0)
			end
			if(IsControlPressed(1,  173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, -1.0)
			end
		end
	end
end)

RegisterNetEvent('es_admin:spawnVehicle')
AddEventHandler('es_admin:spawnVehicle', function(v)
	local carid = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 then
		RequestModel(carid)
		while not HasModelLoaded(carid) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)

		veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
		DecorSetInt(veh, "owner", GetPlayerServerId(PlayerId()))
		SetVehicleAsNoLongerNeeded(veh)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
	end
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = GetPlayerPed(-1)

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		--SetCharNeverTargetted(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		--SetCharNeverTargetted(ped, true)
		SetPlayerInvincible(player, true)
		--RemovePtfxFromPed(ped)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('aca0fc51-10c0-465a-832f-7c7174ea1447')
AddEventHandler('aca0fc51-10c0-465a-832f-7c7174ea1447', function(x, y, z)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:givePosition')
AddEventHandler('es_admin:givePosition', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local string = "{ ['x'] = " .. pos.x .. ", ['y'] = " .. pos.y .. ", ['z'] = " .. pos.z .. " },\n"
	TriggerServerEvent('es_admin:givePos', string)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position saved to file.')
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(GetPlayerPed(-1), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
end)

function getPlayers()
	local players = {}	
	
	for _, player in ipairs(GetActivePlayers()) do
	 table.insert(players, {id = GetPlayerServerId(player), name = GetPlayerName(player)})		
  end
	return players
end
 

 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	if group ~= nil then
		if IsControlPressed(0, 84) and group ~= "user" then
		if (DoesEntityExist(PlayerPedId()) and not IsEntityDead(PlayerPedId())) then 
			local pos = GetEntityCoords(PlayerPedId())

			if (IsPedSittingInAnyVehicle(PlayerPedId())) then 
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

				if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then 
					--SetEntityAsMissionEntity(vehicle, true, true)
					ESX.Game.DeleteVehicle(vehicle)

					if (DoesEntityExist(vehicle)) then 
						exports['mythic_notify']:DoHudText('error', 'Unable To Delete Vehicle, Try Again')
						PlaySoundFrontend(-1, "ERROR","HUD_AMMO_SHOP_SOUNDSET", 1)
					else 
						exports['mythic_notify']:DoHudText('success', 'Vehicle Deleted')
						PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
					end 
				else 
					exports['mythic_notify']:DoHudText('error', 'You Must Be In The Drivers Seat')
					PlaySoundFrontend(-1, "ERROR","HUD_AMMO_SHOP_SOUNDSET", 1)
				end 
			else
			
				local vehicle = ESX.Game.GetVehicleInDirection()
				local dstCheck = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
				if dstCheck > 4.0 then 
				else
					vehicle = nil
				end

				if vehicle == nil or vehicle == 0 then
					vehicle, vehicledist = ESX.Game.GetClosestVehicle()
					if vehicledist > 4.0 then
						vehicle = nil
						vehicledist = nil
					end
				end

				if vehicle ~= nil then
					if (DoesEntityExist(vehicle)) then 
						--SetEntityAsMissionEntity(vehicle, true, true)
						ESX.Game.DeleteVehicle(vehicle)

						if not (DoesEntityExist(vehicle)) then 
							exports['mythic_notify']:DoHudText('success', 'Vehicle Deleted')
							PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
						end 	
					end
					else
						exports['mythic_notify']:DoHudText('error', 'No Vehicle Found')
						PlaySoundFrontend(-1, "ERROR","HUD_AMMO_SHOP_SOUNDSET", 1)
				end 
				end 
			end
			Citizen.Wait(500)		 
		end	
		end		
	end
end)  