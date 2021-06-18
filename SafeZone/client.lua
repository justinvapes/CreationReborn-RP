local notifIn      = false
local notifOut     = false
local closestZone  = 1
local PlayerData   = {}
ESX                = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local zones = {
	-- { ['x'] = 334.88,  ['y'] = -581.99,   ['z'] = 76.62}, --Pillbox
	-- { ['x'] = -233.82,  ['y'] = -1935.8,   ['z'] = 26.79}, --DMV
	{ ['x'] = 451.4,    ['y'] = -990.01,   ['z'] = 29.73 } --PD	
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 50.0 then  
		   DrawAdvancedText(0.130, 0.998, 0.005, 0.0028, 0.30,"You Are In A Safe Zone!", 0, 255, 0, 255, 0, 1)
		   SetPlayerInvincible(PlayerId(), true)
		
			if not notifIn then																			   
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(PlayerPedId(),GetHashKey("WEAPON_UNARMED"),true)
				notifIn = true
				notifOut = false
			end
		else
		    SetPlayerInvincible(PlayerId(), false)
			Citizen.Wait(250)
			
			if not notifOut then
				NetworkSetFriendlyFireOption(true)		       
				notifOut = true
				notifIn = false
			end
		end
		
		if notifIn and PlayerData.job ~= nil and PlayerData.job and PlayerData.job.name ~= 'police' then 
    	   DisableControlAction(0, 106, true) -- Disable in-game mouse controls
           DisableControlAction(0, 24,  true) 
	       DisableControlAction(0, 25,  true) 
	       DisableControlAction(0, 37,  true) 
	       DisableControlAction(0, 140, true)
           DisableControlAction(0, 142, true)         
           DisableControlAction(0, 263, true)
		   DisableControlAction(0, 69,  true)		   
		end
	end
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