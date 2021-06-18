

local IsFishing = false
local rodHandle = nil
local StartFish = false
local showing = false
GLOBAL_FISH = {}

InitFishing = function(cont)

    if StartFish == false then
        StartFish = true
        if IsPedSwimming(GLOBAL_PED) or IsPedInAnyVehicle(GLOBAL_PED) then 
            StartFish = false
            return exports['mythic_notify']:SendAlert('error', 'You cant do that now') 
        end

        ESX.TriggerServerCallback("b1g_fishing:getItems", function(cb)
            if cb == true then
                local waterValidated, castLocation = IsInWater()
                if waterValidated then
                    if not IsFishing then
                        SendBait(castLocation, cont)
                        StartFish = false
                    end
                else
					exports['mythic_notify']:SendAlert('inform', 'Aim to the sea!')
                    StartFish = false
                    TriggerServerEvent("b1g_fishing:BackFish")
                end
            else
			    exports['mythic_notify']:SendAlert('error', 'You need bait!')			   
                StartFish = false
            end
        end)
    end
end

FishingRod = function()
    local fishingRodHash = GetHashKey("prop_fishing_rod_01")

    LoadModels(fishingRodHash)

    rodHandle = CreateObject(fishingRodHash, GLOBAL_COORDS, true)

    AttachEntityToEntity(rodHandle, GLOBAL_PED, GetPedBoneIndex(GLOBAL_PED, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(fishingRodHash)

    Anim("mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(GLOBAL_PED, "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    Anim("amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    return rodHandle
end

Anim = function(dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(GLOBAL_PED, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(GLOBAL_PED, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end

            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(GLOBAL_PED, anim, 0, true)
	end
end

SendBait = function(castLocation, cont)
    IsFishing = true

    if cont == false then
        rodHandle = FishingRod()
    end
    GLOBAL_PED = PlayerPedId()
    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)

    ShowSpinner("Waiting for fish...")
	
    local interupted = false
    
    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)
        if not IsEntityPlayingAnim(GLOBAL_PED, "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true
            break
        end
    end

    if interupted then
        ClearPedTasks(GLOBAL_PED)
        DeleteEntity(rodHandle)
        DeleteEntity(FishRod)
        rodHandle = nil
        RemoveLoadingPrompt()
        IsFishing = false
        return
    else
        TryToCatchFish()
    end
    
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

Show3D = function()
    Citizen.CreateThread(function() 
        local coords = nil
        local close = false
        showing = true
        while #GLOBAL_FISH > 0 do
            close = false
            for i=1, #GLOBAL_FISH, 1 do
                coords = GetEntityCoords(GLOBAL_FISH[i].fishHandle, false)
                if Vdist(GLOBAL_COORDS.x, GLOBAL_COORDS.y, GLOBAL_COORDS.z, coords.x, coords.y, coords.z) <= 2.0 then
                    DrawText3Ds(coords.x, coords.y, coords.z, "[~g~E~w~] - Pick Up")
                    if IsControlJustPressed(1, 38) then
                        if DoesEntityExist(GLOBAL_FISH[i].fishHandle) then
                            loadAnimDict('pickup_object')
                            TaskPlayAnim(GLOBAL_PED,'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
                            AttachEntityToEntity(GLOBAL_FISH[i].fishHandle, GLOBAL_PED, GetPedBoneIndex(GLOBAL_PED, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                            if not GLOBAL_FISH[i].rewardtype.trash then
                                Citizen.Wait(1000)
                                DeleteEntity(GLOBAL_FISH[i].fishHandle)
                                ESX.TriggerServerCallback("b1g_fishing:receiveFish", function(received)
                                    if received then
                                        --TriggerEvent('inventory:client:ItemBox', ESX.ItemsList['fish'], 'add')
                                        --TriggerEvent('inventory:client:ItemBox', ESX.ItemsList['fishbait'], 'remove')
                                    end
                                end, GLOBAL_FISH[i].rewardtype.name)
                            else
                                exports['mythic_notify']:SendAlert('error', 'This is trash..') 
                                Citizen.Wait(1000)
                                DetachEntity(GLOBAL_FISH[i].fishHandle, GLOBAL_PED, true)
                                DeleteEntity(GLOBAL_FISH[i].fishHandle)
                            end
                            table.remove(GLOBAL_FISH, i)
                            ClearPedSecondaryTask(PlayerPedId())
                        end
                    end
                    close = true
                    break
                end
            end
            if close then
                Citizen.Wait(0)
            else
                Citizen.Wait(250)
            end
        end
        showing = false
    end)
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

TryToCatchFish = function()
    local foundFish = false
    local fishNumber = 0

    repeat
        Wait(10)
        local rnd = 1
        rnd = math.random(1, #Config.FishTable)
        if math.random(100) <= Config.FishTable[rnd].chance then
            foundFish = true
            fishNumber = rnd
        end
    until foundFish

    local rewardtype = Config.FishTable[fishNumber]
    ClearPedTasks(GLOBAL_PED)

    local forwardVector = GetEntityForwardVector(GLOBAL_PED)
    local forwardPos = vector3(GLOBAL_COORDS["x"] + forwardVector["x"] * 5, GLOBAL_COORDS["y"] + forwardVector["y"] * 5, GLOBAL_COORDS["z"])
    local model = GetHashKey(rewardtype.prop)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])
    local fishHandle = nil

    if rewardtype.ped == true then
        fishHandle = CreatePed(28, model, forwardPos, 0.0, false, true)
    else
        fishHandle = CreateObject(model, forwardPos, false, false)
    end

    while not DoesEntityExist(fishHandle) do
        Citizen.Wait(10)
    end

    if rewardtype.ped == true then
        SetEntityHealth(fishHandle, 0.0)
    end

    Citizen.CreateThread(function() 
        while true do
            Citizen.Wait(100)
            local asd = GetEntityCoords(fishHandle, false)
            if Vdist(GetEntityCoords(fishHandle, false), forwardPos) <= 1.5 then
                local v3 = vector3(round((forwardVector.x*-1)+8.0, 2), round((forwardVector.y*-1)+8.0, 2), round((forwardVector.z*-1)+8.0, 2))
                ApplyForceToEntity(fishHandle, 3, v3, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                Citizen.Wait(500)
            else
                break
            end
        end
    end)

    Anim("mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(GLOBAL_PED, "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    Citizen.Wait(1500)

    ClearPedTasks(GLOBAL_PED)
    DeleteEntity(rodHandle)
    DeleteEntity(FishRod)
    rodHandle = nil

    table.insert(GLOBAL_FISH, {["fishHandle"] = fishHandle, ["rewardtype"] = rewardtype})

    if #GLOBAL_FISH > 0 then
        if not showing then
            Show3D()
        end
    end

    IsFishing = false
    RemoveLoadingPrompt()
end

IsInWater = function()

    local startedCheck = GetGameTimer()
    local forwardVector = GetEntityForwardVector(GLOBAL_PED)
    local forwardPos = vector3(GLOBAL_COORDS["x"] + forwardVector["x"] * 10, GLOBAL_COORDS["y"] + forwardVector["y"] * 10, GLOBAL_COORDS["z"]-2)
    local fishHash = "a_c_fish"

    LoadModels(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])
    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false, true)

    SetEntityAlpha(fishHandle, 1, true) -- makes the fish invisible.

    ShowSpinner("Looking for fishing zone...")
	 
    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)
    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

LoadModels = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end

	while not HasModelLoaded(model) do
		Citizen.Wait(7)
	end
end

ShowSpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end


