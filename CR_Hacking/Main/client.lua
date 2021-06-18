ESX					   = nil
local infront          = 0
local distanceToCheck  = 1.0
local Hack             = {}
local decorName        = nil
local decorInt         = nil

RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('CR_Hacking:currentlyhacking')
AddEventHandler('CR_Hacking:currentlyhacking', function(mycb)
	if VehicleInFront() ~= 0 then
		TriggerServerEvent('CR_Hacking:removehdevice')
		mycb = true
		Hack.Tablet(true)
		TriggerEvent("mhacking:show") --This line is where the hacking even starts
		TriggerEvent("mhacking:start",4, 18, mycb1) --This line is the difficulty and tells it to start. First number is how long the blocks will be the second is how much time they have is.
	else
		local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~HACKING ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Are you blind? there is no Car", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end
					
RegisterNetEvent('CR_Hacking:success')
AddEventHandler('CR_Hacking:success', function()
	TriggerServerEvent('CR_Hacking:hack', mycb)
	Hack.Tablet(true)	
end)
			  									
function mycb1(success, timeremaining)

  if success then

	 TriggerEvent('mhacking:hide')
	 local vehFront = VehicleInFront()	
     SetVehicleDoorsLocked(vehFront, 1)
	 SetVehicleDoorsLockedForAllPlayers(vehFront, false)
	 netVeh = VehToNet(vehFront)
	 TriggerServerEvent('CR_VehicleLocks:LockSync', netVeh, 1) 
	 TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.2)
	 TriggerServerEvent('CR_VehicleLocks:LockSound', netVeh, 2)
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~HACKING ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Unlocking... Get into the vehicle to ensure it stays", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
	 Hack.Tablet(false)	
	--  Citizen.Wait(5000)
    --  SetVehicleDoorsLocked(vehFront, 1)
	--  SetVehicleDoorsLockedForAllPlayers(vehFront, false)
     local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~HACKING ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] The Vehicle Is Now ~g~Unlocked", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	 
else
	 TriggerEvent('mhacking:hide')
	 local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~HACKING ALERT', '[~b~'..ESX.Game.GetPedRPNames().."~w~] Hack Attempt ~r~Failed", mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)	
	 Hack.Tablet(false)
   end
  end							

 Hack.Tablet = function(boolean)
	if boolean then
		Hack.LoadModels({ GetHashKey("prop_cs_tablet") })

		Hack.TabletEntity = CreateObject(GetHashKey("prop_cs_tablet"), GetEntityCoords(PlayerPedId()), true)
		DecorSetInt(Hack.TabletEntity ,decorName,decorInt)
		AttachEntityToEntity(Hack.TabletEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.03, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)	
		Hack.LoadModels({ "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a" })	
		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	
		Citizen.CreateThread(function()
			while DoesEntityExist(Hack.TabletEntity) do
				Citizen.Wait(5)
	
				if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3) then
					TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
				end
			end
			ClearPedTasks(PlayerPedId())
		end)
	else
		DeleteEntity(Hack.TabletEntity)
	end
end

Hack.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not Hack.CachedModels then
			Hack.CachedModels = {}
		end

		table.insert(Hack.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)	
				Citizen.Wait(10)
			end    
		end
	end
end

Hack.UnloadModels = function()
	for modelIndex = 1, #Hack.CachedModels do
		local model = Hack.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end