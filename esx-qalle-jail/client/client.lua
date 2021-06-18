ESX              = nil
PlayerData       = {}
local jailTime   = 0
local unjailthem = false
local group

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()

    while group == nil do       
        Citizen.Wait(250) 
        ESX.TriggerServerCallback('CR_Misc:GetGroup', function(g)
            group = g
        end)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData

	Citizen.Wait(1000)

	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
		   jailTime = newJailTime + 1
		   JailLogin()
		end
	end)
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  
    Citizen.Wait(1000)
	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
		   jailTime = newJailTime + 1
		   JailLogin()
		end
	end)
end)

RegisterNetEvent("esx-qalle-jail:UpdateTheJailTime")
AddEventHandler("esx-qalle-jail:UpdateTheJailTime", function(newJailTime)

	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
		   jailTime = newJailTime + 1
		   JailLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)


RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("esx-qalle-jail:openJailMenuCiv")
AddEventHandler("esx-qalle-jail:openJailMenuCiv", function()
	OpenJailMenuCiv()
end)

RegisterNetEvent("hf736-3ihr6-49d04-lkfh34")
AddEventHandler("hf736-3ihr6-49d04-lkfh34", function(newJailTime)
	jailTime = newJailTime
	Cutscene()
end)

RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
	jailTime = 0
	UnJail()
end)

--User AFK Kick--
secondsUntilKick = 1200 --20mins
kickWarning = true

Citizen.CreateThread(function()
while true do
	Citizen.Wait(1000)
	
	   local Coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, 402.91567993164, -996.75970458984, -99.000259399414, false) > 2 then	
	
	if jailTime == 0 then
	
           playerPed = GetPlayerPed(-1)	  
		   
	    if playerPed and not IsEntityDead(playerPed) then
		   currentPos = GetEntityCoords(playerPed, true)
		   
		    if currentPos == prevPos then
		      if group == "user" then
		        if time > 0 then			
		          if kickWarning and time == math.ceil(secondsUntilKick / 4) then
			         TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You Will Be Kicked In " .. time .. " Seconds For Being AFK!")
			      end
				  if kickWarning and time == math.ceil(secondsUntilKick / 20) then
					TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You Will Be Kicked In " .. time .. " Seconds For Being AFK!")
					TriggerEvent('InteractSound_CL:PlayOnOne', 'Alarmclock', 0.3)
				  end
			         time = time - 1
		         else
			         TriggerServerEvent("aca0fc51-10c0-465a-832f")
		          end
                end				  
	          else
		        time = secondsUntilKick
		     end
		   prevPos = currentPos
        end
      end
    end
  end
end)

--Staff AFK Job Change--
Citizen.CreateThread(function()
while true do
	Citizen.Wait(1000)
	
	   local Coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, 402.91567993164, -996.75970458984, -99.000259399414, false) > 2 then	
	
	if jailTime == 0 then
	
           playerPed = GetPlayerPed(-1)	   
		   
	    if playerPed then
		   currentPos = GetEntityCoords(playerPed, true)
		   
		    if currentPos == prevPos then
		      if group == "mod" or group == "smod" then 
		        if time > 0 then			
		          if kickWarning and time == math.ceil(secondsUntilKick / 4) then
			         TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1Your Job Will Be Set To Off Duty In " .. time .. " Seconds For Being AFK!")
			      end
			         time = time - 1
		         else
			         TriggerServerEvent("Oaca0fc51-10c0-465a-832f")
		          end
                end				  
	          else
		        time = secondsUntilKick
		     end
		   prevPos = currentPos
        end
      end
    end
  end
end)

function JailLogin()
	
	local Randomcell = math.random(1, 4) 
	
	if Randomcell == 1 then 
	   JailPosition = {x = 467.67,  y = -994.35, z = 23.91}
	
	elseif Randomcell == 2 then 
	   JailPosition = {x = 471.97,  y = -994.40, z = 23.91}
	
	elseif Randomcell == 3 then 
	   JailPosition = {x = 476.26,  y = -994.28, z = 23.91}
	   
	elseif Randomcell == 4 then 
	   JailPosition = {x = 480.42,  y = -994.25, z = 23.91}  	   
	end
		
	male       = IsPedModel(PlayerPedId(),"mp_m_freemode_01")
	femalemale = IsPedModel(PlayerPedId(),"mp_f_freemode_01")
	 
    if male or femalemale then
  
	TriggerEvent('skinchanger:getSkin', function(skin)
		if male then
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1']  = 22, ['torso_2']  = 0,
				['arms']     = 0,
				['pants_1']  = 27, ['pants_2']  = 2,
				['shoes_1']  = 4,  ['shoes_2']  = 2,
				['mask_1']   = 0,  ['mask_2']   = 0,
		        ['helmet_1'] = -1,  ['helmet_2'] = 0,
				['bags_1']   = 0,  ['bags_2']   = 0,
				['chain_1']  = 0,  ['chain_2']  = 0,
			} 
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
			local clothesSkin = {
				['tshirt_1'] = 2,  ['tshirt_2'] = 0,
				['torso_1']  = 79, ['torso_2']  = 2,
				['arms']     = 14,
				['pants_1']  = 3,  ['pants_2']  = 15,
				['shoes_1']  = 1,  ['shoes_2']  = 0,
				['mask_1']   = 0,  ['mask_2']   = 0,
		        ['helmet_1'] = -1,  ['helmet_2'] = 0,
				['bags_1']   = 0,  ['bags_2']   = 0,
				['chain_1']  = 0,  ['chain_2']  = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		 end
      end)
   end	
   SetEntityCoords(PlayerPedId(), JailPosition.x, JailPosition.y, JailPosition.z)
   InJail()
end

function UnJail()
	InJail()
	SetEntityCoords(PlayerPedId(), Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	SetEntityHeading(PlayerPedId(), 94.51)
	
	
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	if skin == nil then				
	else
		TriggerEvent('skinchanger:loadSkin', skin)
	 end
   end)
   if IsPedCuffed(PlayerPedId()) then
	TriggerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5')
   end
	ESX.ShowNotification("~b~You ~w~Have Now Been ~g~Released ~w~From ~b~Jail")
end


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
	
	local Player   = GetEntityCoords(PlayerPedId(), true)
	local PlayerPosition = Config.Cutscene["PhotoPosition"]	
	local PhotoDist = Vdist(PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"], Player['x'], Player['y'], Player['z'])
	
	if jailTime > 0 and PhotoDist > 2 then
	   local Distance = Vdist(JailPosition.x, JailPosition.y, JailPosition.z, Player['x'], Player['y'], Player['z'])
			 
	  if Distance > 2 then
	     SetEntityCoords(PlayerPedId(), JailPosition.x, JailPosition.y, JailPosition.z)
      end
    end
  end
end)

function InJail()

	Citizen.CreateThread(function()

		while jailTime > 0 do
	
			jailTime = jailTime - 1
			
			if jailTime >= 1 then
			   TriggerEvent('esx_status:add', 'hunger', 1000000)
               TriggerEvent('esx_status:add', 'thirst', 1000000)
			end

			TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)

			if jailTime == 0 then
				UnJail()
				TriggerServerEvent("esx-qalle-jail:updateJailTime", 0)
			end
			Citizen.Wait(60000)
		end
	end)
	
	Citizen.CreateThread(function()
	local text

		while jailTime > 0 do
		  Citizen.Wait(0)	
		  
			if jailTime >= 1 then
			   text = _U('respawn_available_in', jailTime)

			   DrawGenericTextThisFrame()
			   SetTextEntry("STRING")
			   AddTextComponentString(text)
			   DrawText(0.5, 0.95)
			end
		end
	end)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

Citizen.CreateThread(function()
  while true do
    Wait(0)
	
    if jailTime ~= 0 then
       Stopall = true  
	end
	
	if jailTime == 0 then
	   Stopall = false  
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)	
	
    if Stopall == true then
	   SetPedCanPlayGestureAnims(playerPed, false)	  
	   DisableControlAction(0, 142, false) -- MeleeAttackAlternate
       DisableControlAction(0, 24,  false) -- Shoot 
       DisableControlAction(0, 92,  false) -- Shoot in car
       DisableControlAction(0, 75,  false) -- Leave Vehicle	 	  
	   DisableControlAction(0, 323, false) -- x
	   DisableControlAction(0, 105, false) -- x
	   DisableControlAction(0, 73,  false) -- x
	   DisableControlAction(0, 73,  false) -- z
       DisableControlAction(0, 82, false) -- ,<	  
	   DisableControlAction(0, 22,  false) -- Jump
       DisableControlAction(0, 25,  false) -- disable aim
       DisableControlAction(0, 47,  false) -- disable weapon
       DisableControlAction(0, 58,  false) -- disable weapon
       DisableControlAction(0, 37,  false) -- TAB
       DisableControlAction(0, 243, false) -- ~/Phone
       DisableControlAction(0, 11, false) -- Vmenu
	   DisableControlAction(0, 288, false) -- F1/Player Options  
       DisableControlAction(0, 289, false) -- F2/Inventory  
       DisableControlAction(0, 170, false) -- F3/Inventory	
       DisableControlAction(0, 166, false) -- F5
	   DisableControlAction(0, 167, false) -- F6
       DisableControlAction(0, 168, false) -- F7
       DisableControlAction(0, 263, false) -- disable melee
       DisableControlAction(0, 264, false) -- disable melee
       DisableControlAction(0, 257, false) -- disable melee
       DisableControlAction(0, 140, false) -- disable melee
       DisableControlAction(0, 141, false) -- disable melee
       DisableControlAction(0, 143, false) -- disable melee
   else
	   Citizen.Wait(500)
    end	
  end
end)


function OpenJailMenuCiv()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Prison Menu",
			align    = 'bottom-right',
			css      = 'superete',
			elements = {
				{ label = "Pay To Get A Player Out Of Prison", value = "unjail_player" }
			}
		}, 
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Send To Jail! (In Minutes)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("The Time Needs To Be In Minutes!")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("No players nearby!")

					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Jail Reason"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								ESX.ShowNotification("You need to put something here!")
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("No players nearby!")
								else
								  	TriggerServerEvent("hf736-3ihr6-49d04-lkfh34", GetPlayerServerId(closestPlayer), jailTime, reason)
									TriggerServerEvent('esx_policejob:CheckCuffsJail', GetPlayerServerId(closestPlayer))
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					ESX.ShowNotification("Your jail is empty!")
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Prisoner: " .. playerArray[i].name .. " | Jail Time: " .. playerArray[i].jailTime .. " minutes", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Unjail Player For $70k",
						align = "center",
						css   = 'entreprise',
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value
					ESX.UI.Menu.CloseAll()
					
					TriggerServerEvent('esx-qalle-jail:checkmoney')
					Wait(1000)
					
					if unjailthem == true then
					   ESX.ShowNotification("~b~Player Is Being Released! ~g~Please Wait...")
					   menu2.close()
					   Wait(10000)	
					   TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)
					   unjailthem = false					   
					end
													
					menu2.close()
									
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)	
end

RegisterNetEvent('esx-qalle-jail:success')
AddEventHandler('esx-qalle-jail:success', function()													  					   
    unjailthem = true
end)


function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Prison Menu",
			align    = 'bottom-right',
			css      = 'entreprise',
			elements = {
				{ label = "Jail Closest Person", value = "jail_closest_player" },
				{ label = "Unjail Person", value = "unjail_player" }
			}
		}, 
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Send If Cuffed! (In Minutes)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("The Time Needs To Be In Minutes!")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("No players nearby!")

					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Jail Reason"
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								ESX.ShowNotification("You need to put something here!")
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("No players nearby!")
								else
								  	TriggerServerEvent("hf736-3ihr6-49d04-lkfh34", GetPlayerServerId(closestPlayer), jailTime, reason)
									TriggerServerEvent('80586cd0-4d96-c4c9-8058-1dd3678d14d5', GetPlayerServerId(closestPlayer))
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					ESX.ShowNotification("Your jail is empty!")
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Prisoner: " .. playerArray[i].name .. " | Jail Time: " .. playerArray[i].jailTime .. " minutes", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Unjail Player",
						align = "center",
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)	
end
