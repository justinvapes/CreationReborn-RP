local ESX		= nil
local Hack      = {}
local InAnim    = false
local decorName = nil
local decorInt  = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("dexac:HereAreYourDecors")
AddEventHandler("dexac:HereAreYourDecors", function( decorN, decorI)
	decorName = decorN
	decorInt = decorI
end)

StartComputer = function()
    Citizen.CreateThread(function()
    mycb = true
	TriggerEvent("mhacking:show") 
	TriggerEvent("mhacking:start", 4, 20, mycb1) --This line is the difficulty and tells it to start. First number is how long the blocks will be the second is how much time they have is.
	Hack.Tablet(true)
	InAnim = true
  end)
end

function mycb1(success, timeremaining)
  if success then

	 TriggerEvent('mhacking:hide')
     TriggerServerEvent('Robbery:VaultOpened')	 
	 exports['mythic_notify']:DoHudText('success', 'You Successfully Hacked The Vault! Silent Alarm Has Been Triggered')
	 HackingCompleted(true)
	 Hack.Tablet(false)
     InAnim = false	 
 else
	 TriggerEvent('mhacking:hide')
	 TriggerServerEvent("Robbery:BeingRobbed")
	 exports['mythic_notify']:DoHudText('error', 'You Failed. Silent Alarm Has Been Triggered')
	 HackingCompleted(false)
	 Hack.Tablet(false)
	 InAnim = false
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

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(5)
	
		if InAnim == true then   
    	   DisableControlAction(0, 106, true) 
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