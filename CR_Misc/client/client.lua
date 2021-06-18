ESX = nil
playerLoaded = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
    end
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
    end

    -- while not ESX.IsPlayerLoaded() do
	-- 	ESX.IsPlayerLoaded()
    -- end   

	-- playerLoaded = true
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
		Citizen.Wait(50)
    end
	
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end
        
    if ESX.IsPlayerLoaded() then
		playerLoaded = true 
    end    

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- RegisterNetEvent('esx:playerLoaded')
-- AddEventHandler('esx:playerLoaded', function(xPlayer)
-- --AddEventHandler('onResourceStart', function(resourceName)
--   PlayerData = xPlayer
--   playerLoaded = true
-- end)

dir = { [0] = 'N', [90] = 'W', [180] = 'S', [270] = 'E', [360] = 'N'}
 
function CheckPlayerPosition()
    pos = GetEntityCoords(PlayerPedId())
    rua, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    Zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
    for k,v in pairs(dir)do
        heading = GetEntityHeading(PlayerPedId())
        if(math.abs(heading - k) < 45)then
            heading = v
            break
        end
    end
end
 
function drawRct(x,y,width,height,r,g,b,a)
    DrawRect(x+width/2,y+height/2,width,height,r,g,b,a)
end
 
function drawTxt(x,y,scale,text,r,g,b,a,font)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end
 
function disableHud()
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)   
    HideHudComponentThisFrame(8)   
    HideHudComponentThisFrame(9)
end
 
function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
	if aspect_ratio > 2 then aspect_ratio = 16/9 end
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
	if GetAspectRatio(0) > 2 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.911
		Minimap.width = Minimap.width * 0.742
	elseif GetAspectRatio(0) > 1.8 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.2225
		Minimap.width = Minimap.width * 0.995
	end
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

--Disable Radar
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
        if not GPS then
			if IsPedInAnyVehicle(PlayerPedId()) then
                DisplayRadar(true)
                DisplayLocation = true
                CheckPlayerPosition()
			else
				DisplayRadar(false)
                DisplayLocation = false
			end
        elseif GPS then
            ESX.TriggerServerCallback('CR_Misc:hasgps', function(callback)
                if callback then
                    DisplayRadar(true)
                    DisplayLocation = true
                    CheckPlayerPosition()
                else
                    ESX.ShowNotification("~g~GPS ~r~Missing!")
                    DisplayRadar(false)
                    DisplayLocation = false
                    GPS = false
                end
            end)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if DisplayLocation then
            local UI = GetMinimapAnchor()
            drawRct(UI.x, UI.bottom_y - 0.216 , UI.width, 0.04, 0, 0, 0, 55)
            drawTxt(UI.x + 0.001 , UI.bottom_y - 0.217 , 0.58, heading, 250, 218, 94, 255, 8) -- Heading
            drawTxt(UI.x + 0.018 , UI.bottom_y - 0.217 , 0.58,"|", 255, 255, 255, 255, 8) -- Heading
            drawTxt(UI.x + 0.023 , UI.bottom_y - 0.216 , 0.3, GetStreetNameFromHashKey(rua), 255, 255, 255, 255, 8) -- Street
            drawTxt(UI.x + 0.023 , UI.bottom_y - 0.199 , 0.25, Zone, 255, 255, 255, 255, 8) -- Area
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('CR_Misc:gps')
AddEventHandler('CR_Misc:gps', function()
    if GPS == true then
        ESX.ShowNotification("~g~GPS~w~ Turned Off")
		GPS = false
	else
        ESX.ShowNotification("~g~GPS~w~ Turned On")
		GPS = true
	end
end)

RegisterCommand("modelhash", function(source, args)
    local hash = nil
    if args[1] == 'current' then
        hash = GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))
    else
        hash = GetHashKey(args[1])
    end
	print(hash)
end)

RegisterCommand("roll", function(source, args)
    local roll = tonumber(args[1])
    if type(roll) == 'number' then
        roll = args[1]
        local roll = math.random(1,roll)
		RequestAnimDict('mp_player_int_upperwank')
		local myPed = PlayerPedId(-1)
		TaskPlayAnim(myPed, 'mp_player_int_upperwank', 'mp_player_int_wank_01_enter', 8.0, -8, -1, 8, 0, 0, 0, 0)
		Wait(650)
		TaskPlayAnim(myPed, 'mp_player_int_upperwank', 'mp_player_int_wank_01_exit', 8.0, -8, -1, 8, 0, 0, 0, 0)
		Citizen.Wait(700)
        TriggerServerEvent('3dme:shareDisplay', 'Rolls ' .. roll .. ' on a D' .. args[1])
    end
end)
TriggerEvent('chat:addSuggestion', '/roll', 'Usage: /roll (number)')

local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }

function checkArray (array, val)
    for name, value in ipairs(array) do
        if value == val then
            return true
        end
    end

    return false
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
      while true do
        local sleep = 3000

        if PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData ~= nil and PlayerData.job ~= nil  and PlayerData.job.name == 'ambulance' then

            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then

                local player, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance < 10.0 then

                    if distance ~= -1 and distance <= 2.0 then	
                        if IsPedDeadOrDying(GetPlayerPed(player)) then
                            Start(GetPlayerPed(player))
                        end
                    end

                else
                    sleep = sleep / 100 * distance 
                end

            end

        else
            sleep = 60000
        end
        Citizen.Wait(sleep)

    end
end)

function Start(ped)
    checking = true

    while checking do
        Citizen.Wait(5)

        local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))

        local x,y,z = table.unpack(GetEntityCoords(ped))

        if distance < 2.0 then
            DrawText3D(x,y,z, 'Press [~g~E~s~] to check the body', 0.4)
            
            if IsControlPressed(0, 38) then
                OpenDeathMenu(ped)
            end
        end

        if distance > 7.5 or not IsPedDeadOrDying(ped) then
            checking = false
        end

  end

end

function Notification(x,y,z)
    local timestamp = GetGameTimer()

    while (timestamp + 4500) > GetGameTimer() do
        Citizen.Wait(0)
        DrawText3D(x, y, z, '~r~X~w~', 0.4)
        checking = false
    end
end

function OpenDeathMenu(player)

    loadAnimDict('amb@medic@standing@kneel@base')
    loadAnimDict('anim@gangops@facility@servers@bodysearch@')

    local elements   = {}

    table.insert(elements, {label = 'Try to identify deathcause', value = 'deathcause'})
    table.insert(elements, {label = 'Try to identify where the damage occured', value = 'damage'})


    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'dead_citizen',
        {
            title    = 'Choose Option',
            align    = 'bottom-right',
            elements = elements,
            css      = 'skin',
        },
    function(data, menu)
        local ac = data.current.value

        if ac == 'damage' then

            local bone
            local success = GetPedLastDamageBone(player,bone)

            local success,bone = GetPedLastDamageBone(player)
            if success then
                --print(bone)
                local x,y,z = table.unpack(GetPedBoneCoords(player, bone))
                  Notification(x,y,z)
              
            else
                Notify('Where the damage occured could not be identified')
            end
        end

        if ac == 'deathcause' then
            --gets deathcause
            local d = GetPedCauseOfDeath(player)		
            local playerPed = GetPlayerPed(-1)

            --starts animation

            TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
            TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

            Citizen.Wait(5000)

            --exits animation			

            ClearPedTasksImmediately(playerPed)

            if checkArray(Melee, d) then
                Notify('Probaly hit by something hard in the head')
            elseif checkArray(Bullet, d) then
                Notify('Probaly shot by a bullet, bulletholes in body')
            elseif checkArray(Knife, d) then
                Notify('Probaly knifed by something sharp')
            elseif checkArray(Animal, d) then
                Notify('Probaly bitten by an animal')
            elseif checkArray(FallDamage, d) then
                Notify('Probaly fell, broke both legs')
            elseif checkArray(Explosion, d) then
                Notify('Probaly died by something that explodes')
            elseif checkArray(Gas, d) then
                Notify('Probaly died from asphyxiation')
            elseif checkArray(Burn, d) then
                Notify('Probaly died by fire')
            elseif checkArray(Drown, d) then
                Notify('Probaly drowned')
            elseif checkArray(Car, d) then
                Notify('Probaly died in a car accident')
            else
                Notify('Deathcause unknown')
            end
        end


    end,
    function(data, menu)
      menu.close()
    end
  )
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        
        Citizen.Wait(1)
    end
end

function Notify(message)
    ESX.ShowNotification(message)
end

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if ESX ~= nil and playerLoaded then
            stam = staminaCheck()
        end
    end
end)

function round2(num, numDecimalPlaces)
	local mult = 10^(0)
	return math.floor(num * mult + 0.5) 
end

local checkNum = 0

function staminaCheck()
    if staminaValue == nil then
        --print(checkNum, '1')
        ESX.TriggerServerCallback('CR_Misc:getSkills', function(roadworks, landscaping, auspost, weed, fighting, stamina)
            staminaValue     = stamina
            staminaValue     = round2(staminaValue)
            return round2(staminaValue)
        end)
    else
        if checkNum > 30 then
            ESX.TriggerServerCallback('CR_Misc:getSkills', function(roadworks, landscaping, auspost, weed, fighting, stamina)
                staminaValue     = stamina
                staminaValue     = round2(staminaValue)
                return staminaValue
            end)
            checkNum = 0
            return staminaValue
        else
            checkNum = checkNum + 1
            return staminaValue
        end
    end
end



-- Push Cars

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if ESX ~= nil then
            local ped = PlayerPedId()
            local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
            local vehicleCoords = GetEntityCoords(closestVehicle)
            local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
            if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
                Vehicle.Coords = vehicleCoords
                Vehicle.Dimensions = dimension
                Vehicle.Vehicle = closestVehicle
                Vehicle.Distance = Distance
                if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                    Vehicle.IsInFront = false
                else
                    Vehicle.IsInFront = true
                end
            else
                Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
            end
        end
        Citizen.Wait(wait)
    end
end)
Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local ped = PlayerPedId()
        if Vehicle.Vehicle ~= nil then
            if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 100 then
                wait = 5
                ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', 0.4)
            end
            if IsControlPressed(0, 21) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, 38) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 100 then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                local coords = GetEntityCoords(ped)
                if Vehicle.IsInFront then    
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                else
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                end
                ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                Citizen.Wait(200)
                local currentVehicle = Vehicle.Vehicle
                 while true do
                    Citizen.Wait(5)
                    if IsDisabledControlPressed(0, 34) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
                    end

                    if IsDisabledControlPressed(0, 9) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
                    end

                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(currentVehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(currentVehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(currentVehicle) then
                        SetVehicleOnGroundProperly(currentVehicle)
                    end

                    if not IsDisabledControlPressed(0, 38) then
                        DetachEntity(ped, false, false)
                        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(ped, false)
                        break
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

local handsup = false
RegisterKeyMapping('hu', 'Hands Up', 'keyboard', 'x')
RegisterCommand('hu', function()
    if not lockkeyssurrender then
        local dict = "missminuteman_1ig_2"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        if handsup then
            handsup = false
            ClearPedTasks(GetPlayerPed(-1))
        else
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) ~= PlayerPedId() then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            end
        end
    end
end)



local crouch = false
RegisterKeyMapping('crouch', 'Crouch', 'keyboard', 'lcontrol')
RegisterCommand('crouch',  function()
    DisableControlAction( 0, 36, true )
    if crouch == false then
        crouch = true
        RequestAnimSet("move_ped_crouched")
        RequestAnimSet("MOVE_M@TOUGH_GUY@")     
        while ( not HasAnimSetLoaded("move_ped_crouched")) do 
            Citizen.Wait( 100 )
        end 
        while ( not HasAnimSetLoaded("MOVE_M@TOUGH_GUY@")) do 
            Citizen.Wait( 100 )
        end	  
        SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.55 )
        SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing") 
    else
        crouch = false
        ResetPedMovementClipset(PlayerPedId())
        exports["dpemotes"]:ResetCurrentWalk()
        ResetPedStrafeClipset(PlayerPedId())
        SetPedMovementClipset(PlayerPedId(),"MOVE_M@TOUGH_GUY@", 0.5)	
        Citizen.Wait(400)
        ResetPedMovementClipset(PlayerPedId())	
        exports["dpemotes"]:ResetCurrentWalk()					
    end
end, false)

function isCrouching()
    return crouch
end

surrender = false
lockkeyssurrender = false
RegisterKeyMapping('surrender', 'Surrender', 'keyboard', 'comma')
RegisterCommand('surrender',  function()
    local playerPed = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(playerPed, true)
    local swimming  = IsPedSwimming(playerPed)
    local shooting  = IsPedShooting(playerPed)
    local climing   = IsPedClimbing(playerPed)
    local cuffed    = IsPedCuffed(playerPed)
    local diving    = IsPedDiving(playerPed)
    local falling   = IsPedFalling(playerPed)
    local jumping   = IsPedJumping(playerPed)
    local jumpveh   = IsPedJumpingOutOfVehicle(playerPed)
    local onfoot    = IsPedOnFoot(playerPed)
    local running   = IsPedRunning(playerPed)
    local Scenario  = IsPedUsingAnyScenario(playerPed)
    local FreeFall  = IsPedInParachuteFreeFall(playerPed)
    local dict1     = 'mp_arresting'
    local dict2     = 'missminuteman_1ig_2'
    local dict3     = 'random@arrests'
    local dict4     = 'random@arrests@busted'
	while not HasAnimDictLoaded(dict1) do
        RequestAnimDict(dict1)
		Citizen.Wait(50)
	end
	while not HasAnimDictLoaded(dict2) do
        RequestAnimDict(dict2)
		Citizen.Wait(50)
	end
	while not HasAnimDictLoaded(dict3) do
        RequestAnimDict(dict3)
		Citizen.Wait(50)
	end
	while not HasAnimDictLoaded(dict4) do
        RequestAnimDict(dict4)
		Citizen.Wait(50)
	end
    if not inVehicle and not swimming and not shooting and not climing and not cuffed and not diving and not falling and not jumping and not jumpveh and onfoot and not running and not Scenario and not FreeFall then
        if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) and surrender and not inAnim then 
            inAnim = true
            TaskPlayAnim(playerPed, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(3000)
            TaskPlayAnim(playerPed, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0)
            inAnim = false
            lockkeyssurrender = false		
            surrender = false		
        elseif not surrender and not inAnim then
            lockkeyssurrender = true
            inAnim = true
            TaskPlayAnim(playerPed, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(4000)
            TaskPlayAnim(playerPed, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(500)
            TaskPlayAnim(playerPed, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            Wait(1000)
            TaskPlayAnim(playerPed, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)		
            inAnim = false
            surrender = true			
        end
        TriggerServerEvent("esx_thief:update", surrender)	
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)     
        if lockkeyssurrender then
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 20, true)--Z
            DisableControlAction(0, 37, true)--Weapon Wheel
            DisableControlAction(0, 288, true)--F1
            DisableControlAction(0, 289, true)--F2
            local playerPed = PlayerPedId()
            if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) then
            elseif IsEntityPlayingAnim(playerPed, "random@arrests@busted", "exit", 3) then
            elseif IsEntityPlayingAnim(playerPed, "random@arrests", "kneeling_arrest_get_up", 3) then
            elseif IsEntityPlayingAnim(playerPed, "random@arrests", "idle_2_hands_up", 3) then
            elseif IsEntityPlayingAnim(playerPed, "random@arrests", "kneeling_arrest_idle", 3) then
            elseif IsEntityPlayingAnim(playerPed, "random@arrests@busted", "enter", 3) then    
            else
                lockkeyssurrender = false	
                surrender = false	
                inAnim = false
                TriggerServerEvent("esx_thief:update", surrender)	
            end
        else	
            Citizen.Wait(250)   
        end
     end
end)
------------------------------
--- STOP STEALING AMBULANCE---
------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, true) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle then
                local isDriver = GetPedInVehicleSeat(vehicle, -1) == ped
                if isDriver then
                    if GetEntityModel(vehicle) == GetHashKey('esprinter') or GetEntityModel(vehicle) == GetHashKey('polair') or GetEntityModel(vehicle) == GetHashKey('aw139') or GetEntityModel(vehicle) == GetHashKey('tahoe') then
                        if PlayerData.job ~= nil and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'offambulance' and PlayerData.job.name ~= 'offambulance' then
                            TaskLeaveVehicle(ped, vehicle, 0)
                            ESX.ShowNotification('You Cannot Enter This Vehicle')
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()	
	RequestModel(GetHashKey("ig_jay_norris"))
	while not HasModelLoaded(GetHashKey("ig_jay_norris")) do
		Wait(1)
	end	
	local YouToolPed = CreatePed(4, 0x7A32EE74, 2740.57, 3461.94, 54.67, 334.78, false, true)
	SetEntityHeading(YouToolPed, 334.78)
	FreezeEntityPosition(YouToolPed, true)
	SetEntityInvincible(YouToolPed, true)
	SetBlockingOfNonTemporaryEvents(YouToolPed)
	SetModelAsNoLongerNeeded(YouToolPed)
end)


local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0
local carriedPlayer = nil
local carryingPlayer = nil

RegisterCommand("crcarry",function(source, args)
	if not carryingBackInProgress then
		local player = PlayerPedId()	
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer and closestPlayerDistance > 1.0 then
            closestPlayer = nil
        end
        target = GetPlayerServerId(closestPlayer)
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 3) then
            drawNativeNotification("Person Already Carrying Someone")
        else
            if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'nm', 'firemans_carry', 3) then
                drawNativeNotification("Person Already Being Carried")
            else
                if closestPlayer ~= -1 and closestPlayer ~= nil then
                    carryingBackInProgress = true
                    carriedPlayer = closestPlayer
                    carryingPlayer = PlayerId()
                    TriggerServerEvent('CR_MiscCarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,carriedPlayer,carryingPlayer)
                else
                    drawNativeNotification("No one nearby to carry!")
                end
            end
        end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
        if carriedPlayer ~= nil then 
            tar = GetPlayerServerId(carriedPlayer)
			TriggerServerEvent("CR_MiscCarryPeople:stop",tar)
        end
        if carryingPlayer ~= nil then
            tar = GetPlayerServerId(carryingPlayer)
            TriggerServerEvent("CR_MiscCarryPeople:stop", tar)
        end
        carryingPlayer = nil
        carriedPlayer = nil
	end
end,false)

RegisterNetEvent('CR_MiscCarryPeople:syncTarget')
AddEventHandler('CR_MiscCarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
    if spin == nil then spin = 180.0 end
    ClearPedTasksImmediately(GetPlayerPed(-1))
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
    if controlFlag == nil then controlFlag = 0 end
    if not IsEntityDead(playerPed) then
        TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
    end
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CR_MiscCarryPeople:syncMe')
AddEventHandler('CR_MiscCarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
    if not IsEntityDead(playerPed) then
        TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
    end
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('CR_MiscCarryPeople:cl_stop')
AddEventHandler('CR_MiscCarryPeople:cl_stop', function()
    carryingBackInProgress = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

Citizen.CreateThread(function()
	while true do
        if carryingBackInProgress then 
            --print('Carrying in progress')
			while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
                    TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
                    Citizen.Wait(0)
			end
		end        
        if ESX ~= nil and playerLoaded then
            if stam == 0 or stam == nil then
                stam = 1
            end
            underwater = stam / 3
            underwater = underwater + 15
            underwater = ToFloat(underwater)
            SetPedMaxTimeUnderwater(PlayerPedId(), underwater)
        end
		Wait(0)
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('CR_Misc:UseVest')
AddEventHandler('CR_Misc:UseVest', function()
    SetPedArmour(PlayerPedId(), 100)
end)

RegisterCommand("crsetowned", function(source, args)
    if args[1] then
        if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
            local vehicleProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
            TriggerServerEvent('6542189746351698432-465465138435168541', tonumber(args[1]), vehicleProps)
        else
            exports['mythic_notify']:DoHudText('error', 'Not in a vehicle')
        end
    else
        exports['mythic_notify']:DoHudText('error', 'No PlayerID Specified use (/crsetowned [id])')
    end
end, false)

RegisterCommand("fix", function(source, args)
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0)
	else
	end    
end, true)

-- Citizen.CreateThread(function()
	
-- 	RequestModel(GetHashKey("ig_kerrymcintosh"))
-- 	while not HasModelLoaded(GetHashKey("ig_kerrymcintosh")) do
-- 		Wait(1)
-- 	end
	
-- 	local WeedShopPed2 = CreatePed(4, 0x5B3BD90D, 374.92, -828.96, 28.30, 278.68, false, true)
-- 	SetEntityHeading(WeedShopPed2, 278.68)
-- 	FreezeEntityPosition(WeedShopPed2, true)
-- 	SetEntityInvincible(WeedShopPed2, true)
-- 	SetBlockingOfNonTemporaryEvents(WeedShopPed2, true)
-- 	SetModelAsNoLongerNeeded(WeedShopPed2)
-- end)


--   RegisterCommand("test", function(source)
--       local vehicle = GetVehiclePedIsIn(PlayerPedId())
--       print(vehicle)
--       SetVehicleExtra(vehicle, 1, 1)
--   end, false)

--- 3dme ---

RegisterCommand('me', function(source, args, raw)
    local text = string.sub(raw, 4)
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 2.3
    Display(GetPlayerFromServerId(source), text, offset)
end)

function Display(mePlayer, text, offset)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(5000)
        displaying = false
    end)
	
    Citizen.CreateThread(function()
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 500 then
                 DrawText3DMe(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset-1.250, text)
            end
        end
    end)
end

function DrawText3DMe(x,y,z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
		SetTextScale(0.35, 0.45)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 0, 0, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
    end
end

--- End 3dMe--

--- Start Holstering ---
CooldownPolice = 700
CooldownNormal = 1700

-- Add/remove weapon hashes here to be added for holster checks.
HolsterWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_FLAREGUN",
	"WEAPON_STUNGUN",
	"WEAPON_REVOLVER",
}


Citizen.CreateThread(function()
    while(true) do
        inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
		exist     = DoesEntityExist(PlayerPedId())
		dead      = IsEntityDead(PlayerPedId())
		trying    = GetVehiclePedIsTryingToEnter(PlayerPedId()) == 0
		falling   = IsPedInParachuteFreeFall(PlayerPedId())
		job       = PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name == 'police'
		check     = CheckWeapon(PlayerPedId())
        Citizen.Wait(500)
    end
end)

local holstered = true
Citizen.CreateThread(function()   
	while true do
		Citizen.Wait(100)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("reaction@intimidation@1h")
		
		local ped = PlayerPedId()
		
		if job then
			if not inVehicle then
				if exist and not dead and trying and not falling then
					if check then
						if holstered then
							blocked   = true
							TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when removing weapon
							Citizen.Wait(0)
							TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Citizen.Wait(CooldownPolice)
							ClearPedTasks(ped)
							holstered = false
						else
							blocked = false
						end
					else
						if not holstered then
					
							TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
							Citizen.Wait(500)
							TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
							Citizen.Wait(60)
							ClearPedTasks(ped)
							holstered = true
						end
					end
				else
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				end
			else
				holstered = true
			end
		else
			if not inVehicle then
				if exist and not dead and trying and not falling then
					if check then
						if holstered then
							blocked   = true
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )				
							Citizen.Wait(CooldownNormal)
							ClearPedTasks(ped)
							holstered = false
						else
							blocked = false
						end
					else					
						if not holstered then
							TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon						
							Citizen.Wait(1700)
							ClearPedTasks(ped)
							holstered = true
						end
					end
				else
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				end
			else
				holstered = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if blocked then
				DisableControlAction(1, 25, true )
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(1, 23, true)
				DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
				DisablePlayerFiring(ped, true) -- Disable weapon firing
			end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        blocked = false
    end
end)

function CheckWeapon(ped)
	for i = 1, #HolsterWeapons do
		if GetHashKey(HolsterWeapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end
--- End Holstering ---

--- Police Radio Arm ---

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(0)
       
       if PlayerData ~= nil and PlayerData.job and PlayerData.job.name == 'police' or PlayerData ~= nil and PlayerData.job and PlayerData.job.name == 'ambulance' then					
           RequestAnimDict("random@arrests")
           while (not HasAnimDictLoaded("random@arrests")) do 
               Citizen.Wait(0) 
           end  
           
           if IsEntityInWater(GetPlayerPed(-1)) then
               if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
                   ClearPedTasks(PlayerPedId())
               elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
                   ClearPedTasks(PlayerPedId())
               end
           else
               if IsControlJustReleased(0, 19) then 		
               ClearPedTasks(PlayerPedId())
               SetEnableHandcuffs(PlayerPedId(), false)
               else
                   if IsControlJustPressed(0, 19) then						
                   TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                       
                   elseif IsControlJustPressed(0, 19) and IsPlayerFreeAiming(PlayerId()) then 					
                       TaskPlayAnim(PlayerPedId(), "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                   end 
                       
                   if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
                   DisableActions(PlayerPedId())
                   
                   elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
                   DisableActions(PlayerPedId())
                   end
               end
           end
       else
           Citizen.Wait(250)
       end
     end
   end)
   
function DisableActions(ped)
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 141, true)
    DisableControlAction(1, 142, true)
    DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
    DisablePlayerFiring(ped, true) -- Disable weapon firing
end
--- end police radio arm ---


--- Remove Peds from Sandy PD ---
Citizen.CreateThread(function()
    while true do
      local sleep = 5000
      local myCoords = GetEntityCoords(GetPlayerPed(-1))
      local SandyCoords = vector3(1856.10, 3679.10, 33.7)
      if (#(myCoords - SandyCoords) < 80) then
        ClearAreaOfPeds(1856.10,3679.10,33.7, 58.0, 0)
        sleep = 1
      end
      Citizen.Wait(sleep)
    end
  end)
--- End Remove Peds from Sandy PD ---

--- Remove Peds from MRPD ---
Citizen.CreateThread(function()
    while true do
      local sleep = 5000
      local myCoords = GetEntityCoords(GetPlayerPed(-1))
      local mrpd = vector3(440.84, -983.14, 30.69)
      if (#(myCoords - mrpd) < 350) then
        ClearAreaOfPeds(440.84, -983.14, 30.69, 300, 1)
        sleep = 1
      end
      Citizen.Wait(sleep)
    end
  end)
--- End Remove Peds from MRPD ---

--- Pointing ---
local mp_pointing  = false
local once         = true
local keyPressed   = false
RegisterKeyMapping('point', 'Point', 'keyboard', 'b')
RegisterCommand('point', function()
    if not mp_pointing and IsPedOnFoot(PlayerPedId()) then
        startPointing()
        mp_pointing = true
    elseif mp_pointing and IsPedOnFoot(PlayerPedId()) then
        keyPressed = true
        mp_pointing = false
        stopPointing()
    end
end)
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        Wait(0)
        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) then
            if not IsPedOnFoot(ped) then
                stopPointing()
                keyPressed = true
                mp_pointing = false
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)
function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end
function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end
--- End Pointing ---

--- Fix Dead People Being Invis ---
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1000)
--         local coords = GetEntityCoords(PlayerPedId())
--         local players = ESX.Game.GetPlayersInArea(coords, 100.0)

--         if #players > 1 and IsEntityDead(PlayerPedId()) then
--             startRagdollWorkaround()
--             Citizen.Wait(1000 * 60 * 3) -- cooldown
--         else
--             Citizen.Wait(30000)
--         end
--     end
-- end)

RegisterNetEvent('CR_Misc:ragdollfix')
AddEventHandler('CR_Misc:ragdollfix', function()
    if IsEntityDead(PlayerPedId()) then
        startRagdollWorkaround()
    end
end)

function startRagdollWorkaround()
    local work = true
    SetTimecycleModifier('hud_def_blur')
    local players = {}

    for player=0, 255 do
        if NetworkIsPlayerActive(player) then
            players[player] = true
        end
    end

    Citizen.CreateThread(function()
        while work do
            Citizen.Wait(0)
            drawLoadingText('Fixing your character', 255,255,255,255)
            DisableAllControlActions(0)

            for k,v in pairs(players) do
                local targetPed = GetPlayerPed(k)

                SetEntityLocallyInvisible(targetPed)
                SetEntityNoCollisionEntity(PlayerPedId(), targetPed, true)
            end
        end
    end)

    for i=1, 10 do
        ClearPedTasksImmediately(PlayerPedId())
        Citizen.Wait(700)
    end

    for k,v in pairs(players) do
        if NetworkIsPlayerActive(k) then
            SetEntityLocallyVisible(GetPlayerPed(k))
        end
    end

    work = false
    SetTimecycleModifier('default')
end

function drawLoadingText(text, red, green, blue, alpha)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(1.0, 1.5)
    SetTextColour(red, green, blue, alpha)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.5)
end
--- End Fix Dead People Being Invis ---

local Mechanics = false
local MechanicFix = vec3(732.41, -1088.89, 21.21)
local repairing = false
local MechanicBlip = nil

Citizen.CreateThread(function()
    while true do    
        while ESX == nil do
            Citizen.Wait(50) 
        end
        ESX.TriggerServerCallback('CR_Misc:countMechanics', function(callback)
            if callback > 0 then
                Mechanics = true
                RepairMarker(false)
            else
                Mechanics = false
                RepairMarker(true)
            end
        end)
        Citizen.Wait(120000)   
    end
end)

function RepairMarker(create)
    if create then
        if MechanicBlip == nil then
            MechanicBlip = AddBlipForCoord(MechanicFix.x, MechanicFix.y, MechanicFix.z)
            SetBlipAsShortRange(MechanicBlip, true)
            SetBlipSprite(MechanicBlip, 446) 
            SetBlipColour(MechanicBlip, 83) 
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Vehicle Repairs")
            EndTextCommandSetBlipName(MechanicBlip)
        end
    elseif not create then
        RemoveBlip(MechanicBlip)
        MechanicBlip = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not Mechanics then
            local playerPed = GetPlayerPed(-1)
            local dist = #(GetEntityCoords(playerPed) - MechanicFix)
            if dist <= 25 then
                DrawMarker(27, MechanicFix.x, MechanicFix.y, MechanicFix.z,0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,true,0,0)
                if dist <= 3.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to repair your car for $1200', true, false, -1)
                    if (IsControlJustPressed(0, 38)) and not repairing and IsPedInAnyVehicle(playerPed, false) then
                        ESX.TriggerServerCallback('CR_Misc:HasMoney', function(hasMoney)
                            if hasMoney then
                                repairing = true
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "reparing_car",
                                    duration = 5000,
                                    label = 'Repairing Car',
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                }, function(status)
                                    if not status then
                                        repairing = false
                                        if IsPedInAnyVehicle(playerPed, false) then
                                            TriggerServerEvent('CR_Misc:SV:RepairCar')
                                        end    
                                        -- TriggerServerEvent('CR_DrugSales:SellWeed')
                                        -- PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                        -- TriggerEvent('CR_DrugSales:killsalesblip')
                                        -- Selling = false
                                        -- SalesDraw = false
                                        -- ClearPedTasks(PlayerPedId())
                                    else
                                        reparing = false
                                        -- ClearPedTasks(PlayerPedId())
                                    end
                                end)  
                            else
                                exports['mythic_notify']:DoHudText('error', 'Too Poor! Get a job!')
                            end
                        end)                      
                    end
                end
            else
                Citizen.Wait(3000)
            end
        else
            Citizen.Wait(60000)
        end
    end
end)

RegisterNetEvent('CR_Misc:CL:RepairCar')
AddEventHandler('CR_Misc:CL:RepairCar', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetVehicleEngineHealth(vehicle, 1000)
        SetVehicleEngineOn( vehicle, true, true )
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0)
        exports['mythic_notify']:DoHudText('success', 'Vehicle successfully repaired!')
    end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		if IsPedCuffed(PlayerPedId()) then
		
-- 			--DisableControlAction(0, 1, true) -- Disable pan
-- 			--DisableControlAction(0, 2, true) -- Disable tilt
-- 			DisableControlAction(0, 24, true) -- Attack
-- 			DisableControlAction(0, 257, true) -- Attack 2
-- 			DisableControlAction(0, 25, true) -- Aim
-- 			DisableControlAction(0, 263, true) -- Melee Attack 1

-- 			DisableControlAction(0, 45, true) -- Reload
-- 			DisableControlAction(0, 22, true) -- Jump
-- 			DisableControlAction(0, 44, true) -- Cover
-- 			DisableControlAction(0, 37, true) -- Select Weapon
-- 			DisableControlAction(0, 23, true) -- Also 'enter'?

-- 			DisableControlAction(0, 288,  true) -- Disable phone
-- 			DisableControlAction(0, 289, true) -- Inventory
-- 			DisableControlAction(0, 170, true) -- Animations
-- 			DisableControlAction(0, 167, true) -- Job

-- 			DisableControlAction(0, 0, true) -- Disable changing view
-- 			DisableControlAction(0, 26, true) -- Disable looking behind
-- 			DisableControlAction(0, 73, true) -- Disable clearing animation
-- 			DisableControlAction(2, 199, true) -- Disable pause screen

-- 			DisableControlAction(0, 59, true) -- Disable steering in vehicle
-- 			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
-- 			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

-- 			DisableControlAction(2, 36, true) -- Disable going stealth

-- 			DisableControlAction(0, 47, true)  -- Disable weapon
-- 			DisableControlAction(0, 264, true) -- Disable melee
-- 			DisableControlAction(0, 257, true) -- Disable melee
-- 			DisableControlAction(0, 140, true) -- Disable melee
-- 			DisableControlAction(0, 141, true) -- Disable melee
-- 			DisableControlAction(0, 142, true) -- Disable melee
-- 			DisableControlAction(0, 143, true) -- Disable melee
-- 			DisableControlAction(0, 75, true)  -- Disable exit vehicle
-- 			DisableControlAction(27, 75, true) -- Disable exit vehicle
-- 			DisableControlAction(0, 20, true) -- Disable exit vehicle
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

RegisterNetEvent('CR_Misc:UseZiptie')
AddEventHandler('CR_Misc:UseZiptie', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()				
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('CR_Misc:ZipTieNearest', GetPlayerServerId(closestPlayer))	
    else
        exports['mythic_notify']:SendAlert('error', 'Nobody Nearby')
    end
end)

RegisterNetEvent('CR_Misc:UseZiptieCutter')
AddEventHandler('CR_Misc:UseZiptieCutter', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()				
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('CR_Misc:UnZipTieNearest', GetPlayerServerId(closestPlayer))	
    else
        exports['mythic_notify']:SendAlert('error', 'Nobody Nearby')
    end
end)


RegisterNetEvent('CR_Misc:ZipTieNearest')
AddEventHandler('CR_Misc:ZipTieNearest', function(antagonist)
  local playerPed = GetPlayerPed(-1)
  Citizen.CreateThread(function()
    if not IsPedCuffed(PlayerPedId()) then
        if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) and surrender and not inAnim then
            ESX.TriggerServerCallback('CR_Misc:HasZipTies', function(HasZipties)
                if HasZipties then        
                    ClearPedTasksImmediately(PlayerPedId())
                    RequestAnimDict('mp_arresting')
                    while not HasAnimDictLoaded('mp_arresting') do
                        Citizen.Wait(100)
                    end
                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
                    SetEnableHandcuffs(playerPed, true)
                    SetPedCanPlayGestureAnims(playerPed, false)
                    TriggerServerEvent('CR_Misc:SetZipTieStatus', 'true')
                    DisplayRadar(false)		
                    inAnim = false
                    lockkeyssurrender = false		
                    surrender = false	
                end
            end, antagonist)
        else
            TriggerServerEvent('CR_Misc:SendAlertMsg', antagonist, "Not Surrendered")            
        end
    end
  end)
end)

RegisterNetEvent('CR_Misc:RemoveZipTieNearest')
AddEventHandler('CR_Misc:RemoveZipTieNearest', function()
  local playerPed = GetPlayerPed(-1)
  Citizen.CreateThread(function()
    if IsPedCuffed(PlayerPedId()) then
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed,  true)
        TriggerServerEvent('CR_Misc:SetZipTieStatus', 'false')
        DisplayRadar(true)	
    end
  end)
end)

RegisterNetEvent('CR_Misc:CheckZiptied')
AddEventHandler('CR_Misc:CheckZiptied', function()
	isZipTied = false
	ESX.TriggerServerCallback('CR_Misc:GetZipTieStatus', function(isZipTied)
        if isZipTied then        
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
            end            
            TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetEnableHandcuffs(PlayerPedId(), true)
            SetPedCanPlayGestureAnims(PlayerPedId(), false)
            DisplayRadar(false)
            local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId()); ESX.ShowAdvancedNotification('CR', '~y~PLAYER ALERT', '[~b~'..ESX.Game.GetPedRPNames()..'~s~] You Were ZipTied When You Left', mugshotStr, 1); ESX.Game.UnregisterMugShot(mugshot, false)
        end
    end)
end)

RegisterCommand("animfix", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local isDead = false

    if not IsEntityInAir(ped) then
        if not IsPedRagdoll(ped) then
            if not IsPedInAnyVehicle(ped) then
                ClearPedTasksImmediately(ped)
                ClearPedSecondaryTask(ped)
                SetPedCanPlayGestureAnims(ped, true)
            else
                exports['mythic_notify']:SendAlert('error', 'You can\'t use this command while you\'re in a car.')
            end
        else
            exports['mythic_notify']:SendAlert('error', 'You can\'t use this command if you\'re not standing.')
        end
    else
        exports['mythic_notify']:SendAlert('error', 'You can\'t use this command if you\'re in the air.')
    end

end, false)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/animfix', 'Use this command if your animation gets bugged. It will stop your animation and save you.')
end)