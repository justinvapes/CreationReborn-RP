local ESX		  = nil
local hasBT     = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('Robbery:setDoorFreezeStatusCl')
AddEventHandler('Robbery:setDoorFreezeStatusCl', function(bank, door, status)
    Config.Doors[bank].Doors[door].Frozen = status
end)

RegisterNetEvent('Robbery:text')
AddEventHandler('Robbery:text', function(text, x, y, time)
    drawSub(text, 4, 1, x, y, 0.5, 255, 255, 255, 255, time)
end)

RegisterNetEvent('Robbery:helpTimed')
AddEventHandler('Robbery:helpTimed', function(text, time)
    local faketimer = time
    while faketimer >= 0 do
        faketimer = faketimer - 1
        Wait(0)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end)

RegisterNetEvent('Robbery:Blowtorch')
AddEventHandler('Robbery:Blowtorch', function(text, time)
    local faketimer = time
    while faketimer >= 0 do
        faketimer = faketimer - 1
        Wait(0)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end)

Citizen.CreateThread(function()
    while true do
        while ESX == nil do
			Citizen.Wait(25)
        end
		
        while ESX.GetPlayerData().inventory == nil do
            Citizen.Wait(25)
        end
		
        if ESX.GetPlayerData().inventory ~= nil then
            local Inventory = ESX.GetPlayerData().inventory    
    
            for i=1, #Inventory, 1 do
   
                if Inventory[i].name == "blowtorch" then
                    if Inventory[i].count > 0 then
                        hasBT = true
                    end
                end
            end           
        end
		Citizen.Wait(7500)
    end
end)

local times = 0
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(250)
		
        for i = 1, #Config.Doors do
            local v = Config.Doors[i]
            for j = 1, #v.Doors do
			
                local d = v.Doors[j]
				
                local coords = GetEntityCoords(PlayerPedId())
				
                if GetDistanceBetweenCoords(coords, d.Coords, true) <= 2.5 and d.Frozen then
                    if hasBT then			
					
                        while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), d.Coords, true) <= 1.5 and d.Frozen do
                            local allowed = false
							
                            if j == 1 then
                                allowed = true
                            else
                                if j ~= #v.Doors then
                                    if not v.Doors[j-1].Frozen then
                                        allowed = true
                                    else
                                        allowed = false
                                    end
                                else
                                    allowed = true
                                end
                            end
							
							Citizen.Wait(50)
							
                        if allowed then
							
							coords = vector3(255.23, 223.98, 102.39)
							
							if d.Coords ~= coords then
                               TriggerEvent('Robbery:helpTimed', 'Press ~INPUT_CONTEXT~ To Blowtorch The Door', 50)
								
                                if IsControlPressed(0, 38) then
								   if not IsPedArmed(PlayerPedId(), 4) then
								
                                    ClearPedTasks(PlayerPedId())
                                    SetEntityCoords(PlayerPedId(), d.BTPosition.C)
                                    SetEntityHeading(PlayerPedId(), d.BTPosition.H)
                                    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
                                    blockKeys = true
                                    local Blowtorched = true
										
                                    for i = 1, 100 do
										
									    TriggerEvent('Robbery:Blowtorch', 'Hold ~INPUT_DIVE~ To Stop', 50)
                                        drawSub('Progress ~b~' .. i .. '%', 4,1,0.5,0.96,0.6,255,255,255,255, d.Time)
										
                                        if IsDisabledControlPressed(0, 22) then
                                           ClearPedTasks(PlayerPedId())
                                           blockKeys = false
                                           Blowtorched = false
                                      break
                                        end
                                    end
										
                                    ClearPedTasks(PlayerPedId())
                                    blockKeys = false
										
                                    if Blowtorched then
                                       TriggerServerEvent('Robbery:setDoorFreezeStatus', i, j, false)
									   print(i)
									   print(j)
									   TriggerServerEvent("Robbery:RemoveBlowtorch")
                                    end
									   Citizen.Wait(50)
                                  break									
							  else
							     exports['mythic_notify']:DoHudText('error', 'Put Your Weapon Away First!!')
							     Citizen.Wait(500)
						      end
                           end
                        end
                     end
			      end
               end
            end
         end
      end
   end
end)

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(0)
    end
	Citizen.Wait(250)
    for i = 1, #Config.Doors do
        for j = 1, #Config.Doors[i].Doors do
            TriggerServerEvent('Robbery:getDoorFreezeStatus', i, j)
        end
    end
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        for i = 1, #Config.Doors do
            Wait(0)
            local v = Config.Doors[i]
            for j = 1, #v.Doors do
                Wait(250)
                local d = v.Doors[j]
                local door = GetClosestObjectOfType(d.Coords, 2.0, GetHashKey(d.Object), false, 0, 0)
                if door ~= nil then
                    if not d.Frozen then
                        if d.OpenHeading ~= nil then
                            SetEntityHeading(door, d.OpenHeading)
                        end
                    end
                    FreezeEntityPosition(door, d.Frozen)
                    if d.Frozen then
                        SetEntityHeading(door, d.Heading)
                    end
                end
            end
        end
		Citizen.Wait(500)
    end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function drawSub(text,font,centre,x,y,scale,r,g,b,a, time)
	local timesdone = 0
    while timesdone <= time/10 do
        drawTxt(text, font, centre, x, y, scale, r, g, b, a)
		Wait(0)
		timesdone = timesdone + 1
	end
end