ESX           = nil
local notify  = 0
local bag     = false

cachedData = {
	["banks"] = {
  }
}

local Banks = {
	{['x'] = -2956.54, ['y'] = 481.62,   ['z'] = 15.69},	
	{['x'] = 146.79,   ['y'] = -1045.77, ['z'] = 15.697087287903},
	{['x'] = -354.35,  ['y'] = -54.79,   ['z'] = 15.697087287903},
	{['x'] = 253.47,  ['y'] = 228.41,   ['z'] = 101.30}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	ESX.TriggerServerCallback("bankrobberies:getCurrentRobbery", function(found)
		if found then
			for bank, bankData in pairs(found) do
				cachedData["banks"][bank] = bankData["trolleys"]

				RobberyThread({
					["bank"] = bank,
					["trolleys"] = bankData["trolleys"]
				})
			end
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Banks, 1 do
		local BankBlip = AddBlipForCoord(Banks[i].x, Banks[i].y, Banks[i].z)
		SetBlipAsShortRange(BankBlip, true)
		SetBlipSprite(BankBlip, 156) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bank Robbery")
		EndTextCommandSetBlipName(BankBlip)
	end
end)

RegisterNetEvent("bankrobberies:eventHandler")
AddEventHandler("bankrobberies:eventHandler", function(event, eventData)
	if event == "start_robbery" then
		RobberyThread(eventData)
		
	elseif event == "alarm_police" then
		if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "police" then
			SetAudioFlag("LoadMPData", true)
			PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")

			TriggerEvent('esx:showNotification', 'Someone Just ~r~Hacked ~w~The Vault At - ~b~' ..eventData.. ' ~w~Bank')

			local bankValues = Config.Banks[eventData]
			SetNewWaypoint(bankValues["start"]["pos"]["x"], bankValues["start"]["pos"]["y"])
			local blipRobbery = AddBlipForCoord(bankValues["start"]["pos"])

			SetBlipSprite(blipRobbery, 161)
			SetBlipScale(blipRobbery, 2.0)
			SetBlipColour(blipRobbery, 8)			
            Citizen.Wait(30000)
            RemoveBlip(blipRobbery)
		end
		
	elseif event == "alarm_silent" then	
		if ESX.PlayerData["job"] and ESX.PlayerData["job"]["name"] == "police" then
		   SetAudioFlag("LoadMPData", true)
		   PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")

		   TriggerEvent('esx:showNotification', 'Someone Just ~g~Attempted ~w~To Hack The Vault At - ~b~' ..eventData.. ' ~w~Bank')

		   local bankValues = Config.Banks[eventData]
		   SetNewWaypoint(bankValues["start"]["pos"]["x"], bankValues["start"]["pos"]["y"])
		   local blipRobbery = AddBlipForCoord(bankValues["start"]["pos"])

		   SetBlipSprite(blipRobbery, 161)
		   SetBlipScale(blipRobbery, 2.0)
		   SetBlipColour(blipRobbery, 8)			
           Citizen.Wait(10000)
           RemoveBlip(blipRobbery)
	    end
	 else
	end
end)

RegisterNetEvent("Robbery:set0")
AddEventHandler("Robbery:set0", function()
   notify = 0
end)
 


Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		local sleepThread = 500

	  	local ped = PlayerPedId()
	  	local pedCoords = GetEntityCoords(ped)

		for bank, values in pairs(Config.Banks) do
			local dstCheck = GetDistanceBetweenCoords(pedCoords, values["start"]["pos"], true)

			if dstCheck <= 5.0 then
				sleepThread = 5

				if dstCheck <= 0.5 then
					local usable, displayText = not cachedData["banks"][bank], cachedData["hacking"] and "Hacking..." or cachedData["banks"][bank] and "" or "Press ~INPUT_CONTEXT~ To Try Hack The Device"
      
	                if notify == 0 then
					   ESX.ShowHelpNotification(displayText)
					end

					if IsControlJustPressed(0, 38) and notify == 0 then
					   if usable then

					   
					ESX.TriggerServerCallback('Robbery:anycops', function(anycops)
					if anycops >= 4 then  
					
					male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
                    femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
 
                    if male or femalemale then	 										   
					   bag = bagAllowed()	
						
					  if bag then	
						
						  ESX.TriggerServerCallback('Robbery:ItemAmount', function(qtty)
						  if qtty > 0 then
						  
						    ESX.TriggerServerCallback('Robbery:Item2Amount', function(qtty2)
                            if qtty2 > 0 then
							
							TriggerServerEvent("Robbery:CheckAll", bank)                           							
							notify = 1
						else
							exports['mythic_notify']:DoHudText('error', 'You Need A Blowtorch To Get Into The Vault!!')
						 end
					    end, 'blowtorch')						
					else
							exports['mythic_notify']:DoHudText('error', 'You Need A Hacking Laptop To Hack The Vault!!')
				         end						 
					  end, 'laptop_h')	
					     else
						    exports['mythic_notify']:DoHudText('error', 'You Need Bag 45 To Do This Job!')
				         end						 
					else	
					
						ESX.TriggerServerCallback('Robbery:ItemAmount', function(qtty)
						  if qtty > 0 then
						  
						    ESX.TriggerServerCallback('Robbery:Item2Amount', function(qtty2)
                            if qtty2 > 0 then
							
							TriggerServerEvent("Robbery:CheckAll", bank)													                           							
							notify = 1
						else
							exports['mythic_notify']:DoHudText('error', 'You Need A Blowtorch To Get Into The Vault!!')
						 end
					    end, 'blowtorch')						
					else
							exports['mythic_notify']:DoHudText('error', 'You Need A Hacking Laptop To Hack The Vault!!')
				         end						 
					  end, 'laptop_h')						
					end						 						 						 												 
				        else
						    exports['mythic_notify']:DoHudText('error', 'This Is Not Enough Police Online')
				         end						 
					  end) 					  
				   end
				end
			 end
	      end
	   end
	  	 Citizen.Wait(sleepThread)
	end
end)


RegisterNetEvent("Robbery:AttemptRobbery")
AddEventHandler("Robbery:AttemptRobbery", function(bank)
TriggerServerEvent("Robbery:RemoveHackDevice")
StartHackingDevice(bank) 
end)

function bagAllowed()
    local allowed = false
    TriggerEvent('skinchanger:getSkin', function(skin)
        for i = 1, #Config.AllowedBags do
            if skin.bags_1 == Config.AllowedBags[i] then
                allowed = skin.bags_1
                break
            end
        end
    end)
    return allowed
end