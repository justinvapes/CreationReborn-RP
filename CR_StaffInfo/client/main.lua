ESX                = nil
playerDistances    = {}
local blipsPlayer  = {}
local NameDistance = 15    --Distance You Can See The Name/ID From
local NameHight    = 1.15  --The Hight Of Names/ID Above The Players Head
local PlayerAmount = 1     --If The Is Only 1 Player In The Server Then No Point In Allowing It To Work. Set To 0 If You Want To Test It
local names        = false --Don't Touch
local UseCommand   = false --Make This [true] And UseKey [false] If You Want To Use The Command /pnames To Toggle On/Off
local UseKey       = true  --Make This [true] And UseCommand [false] If You Want To Use The Key [L] To Toggle On/Off
local group

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(250)
    end

    while group == nil do       
        Citizen.Wait(250) 
        ESX.TriggerServerCallback('CR_Misc:GetGroup', function(g)
            group = g
        end)
    end
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
    group = g
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Citizen.Wait(10000)
    TriggerServerEvent("PlayerBlips:Update")
end)

RegisterCommand("pnames",function() --Chat Command
    if group ~= nil then       
        if group ~= "user" then 
            
            if UseCommand == true and UseKey == false then
                
                local players = GetActivePlayers() 
                
                if #players > PlayerAmount then			
                    names = not names
                    TriggerEvent('PlayerBlips:Update')
                    ESX.ShowNotification("Names/Blips -~g~ Enabled")	
                else
                    ESX.ShowNotification("You Are The Only Player In The Server")
                end			
            else
                ESX.ShowNotification("Error! Using Command Is Disabled Or [UseKey] Is Set To [true]")
            end
        else
            ESX.ShowNotification("Only Staff Can Use This Command")
        end
    end
end) 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)			
		if GetLastInputMethod(2) and IsControlJustReleased(0, 182) then -- Key [L]
            if group ~= nil then			
                if group ~= "user" then                     
                    if UseKey == true and UseCommand == false then 
                        
                        local players = GetActivePlayers() 
                        
                        if #players > PlayerAmount then
                            names = not names
                            TriggerEvent('PlayerBlips:Update')	
                        else
                            ESX.ShowNotification("You Are The Only Player In The Server")
                        end
                    else
                        ESX.ShowNotification("Error! Using Key Is Disabled Or [UseCommand] Is Set To [true]")
                    end
                end
                Citizen.Wait(1000)
            end
			Citizen.Wait(1000)			 
		end	
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)	
        
        if IsControlJustReleased(0, 182) then
            Citizen.Wait(150)
            if group ~= nil then
                if group ~= "user" then 
                    
                    if names then
                    ESX.ShowNotification("Names/Blips -~g~ Enabled")	
                    PlaySoundFrontend(-1, "ERROR","HUD_AMMO_SHOP_SOUNDSET", 1)
                else   
                    ESX.ShowNotification("Names/Blips -~r~ Disabled")
                    PlaySoundFrontend(-1, "ERROR","HUD_AMMO_SHOP_SOUNDSET", 1)		   
                    end        	 
                end
            Citizen.Wait(0)
            end

        Citizen.Wait(0)
        end	  
    end
end)

RegisterNetEvent('PlayerBlips:Update')
AddEventHandler('PlayerBlips:Update', function()
    
    if names then 
        
        for k, existingBlip in pairs(blipsPlayer) do
           RemoveBlip(existingBlip)
        end
        blipsPlayer = {}
        
        for _, player in ipairs(GetActivePlayers()) do
            
            if NetworkIsPlayerActive(player) and GetPlayerPed(player) ~= PlayerPedId() then
               createBlip(player)
            end			   
        end  
    else	
        for k, existingBlip in pairs(blipsPlayer) do
            RemoveBlip(existingBlip)
        end			
        blipsPlayer = {}
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)	 
        
        if names then
            
            for _, player in ipairs(GetActivePlayers()) do
                
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
                distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))

                if player ~= nil then
                    if GetPlayerPed(player) ~= GetPlayerPed(-1) then	
                        if playerDistances[player] ~= nil and NameDistance ~= nil then
                            if (playerDistances[player] < NameDistance) then
                                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
                                if player ~= nil and GetPlayerName(player) ~= nil and GetPlayerServerId(player) ~= nil then
                                    DrawText3D(x2, y2, z2+NameHight, '~b~'..GetPlayerName(player)..' ~w~- ID:[~b~'..GetPlayerServerId(player).. '~w~]', 255,255,255)						
                                end
                            end 	
                        end				 
                    end   
                end
            end
        else	
            Citizen.Wait(100)	   
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        
        for _, player in ipairs(GetActivePlayers()) do
            
            if GetPlayerPed(player) ~= GetPlayerPed(-1) then
               x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
               x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(player), true))
               distance   = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
               playerDistances[player] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)

function DrawText3D(x,y,z, text, r,g,b) 
    
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1) 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
       SetTextScale(0.0*scale, 0.55*scale)
       SetTextFont(0)
       SetTextProportional(1)
       SetTextColour(r, g, b, 255)
       SetTextDropshadow(0, 0, 0, 0, 255)
       SetTextEdge(2, 0, 0, 0, 150)
       SetTextDropShadow()
       SetTextOutline()
       SetTextEntry("STRING")
       SetTextCentre(1)
       AddTextComponentString(text)
       DrawText(_x,_y)
    end
end

function createBlip(id)
    
    local ped = GetPlayerPed(id)
    local blip = GetBlipFromEntity(ped)
    
    if not DoesBlipExist(blip) then 
       blip = AddBlipForEntity(ped)
       SetBlipSprite(blip, 1)
       ShowHeadingIndicatorOnBlip(blip, true) 
       SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) 
        
       SetBlipColour(blip, 4)
       SetBlipScale(blip, 0.85)
       SetBlipAsShortRange(blip, true)
       table.insert(blipsPlayer, blip) 
    end
end