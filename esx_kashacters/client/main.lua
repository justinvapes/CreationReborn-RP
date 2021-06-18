ESX                  = nil
local PlayerLoaded   = false
local MakethemInvis  = false
local cam            = nil
local cam2           = nil
local IsChoosing     = true

Citizen.CreateThread(function()

	while ESX == nil do
	   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	   Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
	   Citizen.Wait(100)
	end
	
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if NetworkIsSessionStarted() then
		   Citizen.Wait(100)
		   TriggerServerEvent("kashactersS:SetupCharacters")
		   TriggerEvent("kashactersC:SetupCharacters")				
		   return 
		end
	end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
		
        if IsChoosing then
           DisplayHud(false)
           DisplayRadar(false)
        end
    end
end)

RegisterNetEvent('kashactersC:SetupCharacters')
AddEventHandler('kashactersC:SetupCharacters', function()

    DoScreenFadeOut(10)
	
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
	
    SetTimecycleModifier('hud_def_blur')
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('kashactersC:SetupUI')
AddEventHandler('kashactersC:SetupUI', function(Characters)

    DoScreenFadeIn(500)
    Citizen.Wait(500)	
    SetNuiFocus(true, true)
	
    SendNUIMessage({
      action = "openui",
      characters = Characters,
    })
end)

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn, isnew)
	
	TriggerServerEvent('es:firstJoinProper')
	TriggerEvent('es:allowedToSpawn')
	Citizen.Wait(500)
	TriggerEvent('kashactersC:CheckAll')	
	
	local pos = spawn	
	local Me = GetEntityCoords(PlayerPedId())
	
	if not isnew then
	   TriggerEvent('esx_skin:CheckSkin')
		
		if GetDistanceBetweenCoords(Me.x, Me.y, Me.z, 402.91567993164, -996.75970458984, -99.000259399414, false) < 2 then	
		   pos = vector3(-205.81, -1012.60, 29.15)
	   else
		   pos = spawn
		end
	end
	
	SetTimecycleModifier('default')
	SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
	SetEntityHeading(GetPlayerPed(-1), 176.22499084473)		
	DoScreenFadeIn(500)
	Citizen.Wait(500)
	cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1355.93,-1487.78,520.75, 300.00,0.00,0.00, 100.00, false, 0)
	PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
	SetCamActiveWithInterp(cam2, cam, 900, true, true)
	Citizen.Wait(900)
	exports.spawnmanager:setAutoSpawn(false)
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
	PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
	SetCamActiveWithInterp(cam, cam2, 3700, true, true)
	Citizen.Wait(3700)
	PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
	RenderScriptCams(false, true, 500, true, true)
	PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
	FreezeEntityPosition(GetPlayerPed(-1), false)
	Citizen.Wait(500)
	SetCamActive(cam, false)
	DestroyCam(cam, true)
	IsChoosing = false
	DisplayHud(true)
	DisplayRadar(true)	
	Citizen.Wait(250)
	TriggerEvent('kashactersS:SetInvis')
	TriggerEvent('esx_ambulancejob:multicharacter', source)
	Citizen.Wait(250)
	TriggerEvent('esx_ambulancejob:CheckTime')
	Citizen.Wait(250)
	TriggerEvent('esx_policejob:CheckIsCuffed', source)
	Citizen.Wait(250)
	TriggerEvent('CR_Misc:CheckZiptied', source)
	Citizen.Wait(500)
	TriggerEvent('Motel:CheckPlayer')
	Citizen.Wait(1)
	TriggerEvent('Motel2:CheckPlayer')
	Citizen.Wait(1)
	TriggerEvent('Motel3:CheckPlayer')
end)

RegisterNetEvent('kashactersC:CheckAll')
AddEventHandler('kashactersC:CheckAll', function()

    CheckInventory()
      Citizen.Wait(500)
    RefreshInfo()
end)

RegisterNetEvent('kashactersC:ReloadCharacters')
AddEventHandler('kashactersC:ReloadCharacters', function()
    TriggerServerEvent("kashactersS:SetupCharacters")
    TriggerEvent("kashactersC:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)

	id = tonumber(data.charid)
	
	if id == 1 then
		SendNUIMessage({type = 'Refresh'})	
		SetNuiFocus(false,false)
		DoScreenFadeOut(500)
		TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar)
		while not IsScreenFadedOut() do
		   Citizen.Wait(10)
		end
		cb("ok")
		
	elseif id == 2 then
		ESX.TriggerServerCallback('CR:isMember', function(Bronze) 
			if Bronze then
				
				SendNUIMessage({type = 'Refresh'})	
				SetNuiFocus(false,false)
				DoScreenFadeOut(500)
				TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				cb("ok")		   
			else   
				SendNUIMessage({
					type = "member",
					bronze = true
				})	 	  
			end
		end, data.charid)
		
	elseif id == 3 then
		ESX.TriggerServerCallback('CR:isMember', function(Silver) 
			if Silver then
				
				SendNUIMessage({type = 'Refresh'})	
				SetNuiFocus(false,false)
				DoScreenFadeOut(500)
				TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				cb("ok")		   
			else   
				SendNUIMessage({
					type = "member",
					plat = true
				})
			end
		end, data.charid)
		
	elseif id == 4 then
		ESX.TriggerServerCallback('CR:isMember', function(Gold) 
			if Gold then
				
				SendNUIMessage({type = 'Refresh'})	
				SetNuiFocus(false,false)
				DoScreenFadeOut(500)
				TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
				cb("ok")		 		   
			else   
				SendNUIMessage({
					type = "member",
					plat = true
				})
			end
		end, data.charid)	
	end
end)

RegisterNUICallback("DeleteCharacter", function(data, cb)
	SendNUIMessage({type = 'Refresh'})	
	SetNuiFocus(false,false)
	DoScreenFadeOut(500)
	TriggerServerEvent('kashactersS:DeleteCharacter', data.charid)
	
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	cb("ok")	
end)

function CheckInventory()
	
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
		
		ESX.TriggerServerCallback('kashactersS:RemoveWeaponsWhenOffDuuty', function()      
			ESX.SetPlayerData('loadout', {})                   
		end)
		
		local inventory = ESX.GetPlayerData().inventory
		local count = 0
		
		for i=1, #inventory, 1 do
			if inventory[i].name == 'pdgps' then
			   count = inventory[i].count
			end
		end
		
		if (count > 0) then	
			TriggerServerEvent('esx_policejob:RemoveGPS')			
		end
		
	elseif ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		
		local inventory = ESX.GetPlayerData().inventory
		local count = 0
		
		for i=1, #inventory, 1 do
			if inventory[i].name == 'emsgps' then
			   count = inventory[i].count
			end
		end
		
		if (count > 0) then	
		   TriggerServerEvent('esx_ambulancejob:RemoveGPS')			
		end
	end
end

function RefreshInfo()
	
	TriggerServerEvent('duty:police2')
	TriggerServerEvent('duty:Ambulance2')
	TriggerServerEvent('duty:mecanoHRDOff')
	TriggerServerEvent('duty:mecanoHSetOff')
	TriggerServerEvent('duty:cardealeroff')
	TriggerServerEvent('duty:cardealer2off')
	TriggerServerEvent("duty:unicorn2")
	TriggerServerEvent("duty:Nightclub2")
end

RegisterNetEvent('kashactersS:SetInvis')
AddEventHandler('kashactersS:SetInvis', function()
	
	MakethemInvis  = not MakethemInvis;
	
	Citizen.CreateThread(function()
		
		if MakethemInvis then
		   SetEntityVisible(PlayerPedId(), false)
	   else
		   SetEntityVisible(PlayerPedId(), true)  
		end
	end)
end)