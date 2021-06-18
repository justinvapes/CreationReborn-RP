--[[ PROSPECT CLIENT SCRIPT ]]--
--[[      NATURALKHAOS      ]]--

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

PlayerData = nil
ESX    = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
    end
    while PlayerData == nil do
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


-- Prospect Variables
active = false
local rangeDraw = false
local range2Draw = false

-- Crafting Variables
local craftTable = {}
local CurrentCraft = nil
local ct1Draw = false
local ct2Draw = false


-- Dumpster Diving Variables
local searched = {3423423424}
local searchTime = 10000
local dumpsterDiveTextDraw = false
local canSearch = true

------------------------Prospect-------------------------------------------------------
-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Mine) do
		local blip = AddBlipForCoord(v)
        SetBlipSprite (blip, 617)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.75)
        SetBlipColour (blip, 66)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mine")
        EndTextCommandSetBlipName(blip)
	end
	for k,v in ipairs(Config.Smelter) do
		local blip = AddBlipForCoord(v)
        SetBlipSprite (blip, 618)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.75)
        SetBlipColour (blip, 64)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Smelter")
        EndTextCommandSetBlipName(blip)
	end
	for k,v in ipairs(Config.Scrapyard) do
		local blip = AddBlipForCoord(v)
        SetBlipSprite (blip, 307)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.75)
        SetBlipColour (blip, 64)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Aircraft Scrapyard")
        EndTextCommandSetBlipName(blip)
    end
end)

-- Smelting Text
Citizen.CreateThread(function()
    while true do
        sleep = 1000
        rangeDraw = false
        range2Draw = false
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                local PlyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local SmelterCoords = Config.Smelter[1]
                local SmelterDist = #(PlyCoords - SmelterCoords)
                if SmelterDist < Config.SmeltRender then
                    sleep = 1
                    rangeDraw = true
                    if SmelterDist < Config.SmeltDist then
                        rangeDraw = false
                        range2Draw = true
                    end
                end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 50
        if not canSearch then
            sleep = 1
            DisableControlAction(0, 106, true) -- Disable in-game mouse controls
            DisableControlAction(0, 24,  true) 
            DisableControlAction(0, 25,  true) 
            DisableControlAction(0, 37,  true) 
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 142, true)         
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 69,  true)
            DisableControlAction(0, 323,  true) -- Handsup
            DisableControlAction(0, 29,  true) -- Point
            DisableControlAction(0, 311,  true) -- Ragdoll
            DisableControlAction(0, 20,  true) -- RadialMenu
            DisableControlAction(0, 245,  true) -- Chat
            DisableControlAction(0, 243, true) -- ~/Phone
            DisableControlAction(0, 288, true) -- F2/Inventory				   
            DisableControlAction(0, 289, true) -- F2/Inventory
            DisableControlAction(0, 82, true) -- Surrender
        end
        Citizen.Wait(sleep)
    end
end)

-- Start digging
RegisterNetEvent('prospect:dig')
AddEventHandler ('prospect:dig', function()
    local ped = GetPlayerPed(GetPlayerFromServerId(playerid))
    local pos = GetEntityCoords(ped, true)
    if (active == false) and (pos.y >= 1065) and not IsPedInAnyVehicle(GetPlayerPed(-1), true)  then
        local dirt = false
        local plat = false
        local rust = false
        local diam = false
        active = true
        LoadAnim("amb@world_human_gardener_plant@female@base")
        TaskPlayAnim(PlayerPedId(), "amb@world_human_gardener_plant@female@base", "base_female", 8.0, 8.0, 5000, 0, 0, false, false, false)
        Citizen.Wait(5000)
        if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 2388.01, 3054.13, 48.15, true) < 150) then -- Aircraft Scrapyard
            dirt = false
            plat = false
            rust = true
            diam = false
        elseif (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 2953.91, 2787.1, 41.49, true) < 400) then -- Davis Quartz Mine
            dirt = true
            plat = false
            rust = false
            diam = true
        elseif (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -472.34, 2088.25, 120.1, true) < 20) then -- Mine shoot 1
            dirt = true
            plat = false
            rust = false
            diam = true
        elseif (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -423.88, 2064.72, 120.03, true) < 20) then -- Mine shoot 2
            dirt = true
            plat = true
            rust = false
            diam = false
        elseif (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -485.04, 1894.67, 119.96, true) < 20) then -- Mine shoot 3
            dirt = true
            plat = false
            rust = false
            diam = true
        elseif (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -563.56, 1887.02, 123.03, true) < 20) then -- Mine shoot 4
            dirt = true
            plat = true
            rust = false
            diam = false
        end
        -- Pay Dirt Handler
        if dirt then
            TriggerServerEvent('prospect:paydirt', "")
            exports['mythic_notify']:DoHudText('success', 'You collected some Paydirt!')
        end
        -- Platinum Handler
        if plat then
            local platc = math.random(Config.Chance.PlatinumC[1], Config.Chance.PlatinumC[2])
            if (platc == 2) then
                TriggerServerEvent('prospect:platinum', "")
                exports['mythic_notify']:DoHudText('success', 'You dug up a piece of Platinum!')
            end
        end
        -- Rust Handler
        if rust then
            local rirnc = math.random(Config.Chance.RustIron[1], Config.Chance.RustIron[2])
            if (rirnc == 2) then
                TriggerServerEvent('prospect:rust', "") 
                exports['mythic_notify']:DoHudText('success', 'You dug up a piece of Rusted Iron!')
            end 
        end
        -- Diamond Handler
        if diam then
            local diac = math.random(Config.Chance.DiamondC[1], Config.Chance.DiamondC[2])
            if (diac == 2) then
                TriggerServerEvent('prospect:diamond', "") 
                exports['mythic_notify']:DoHudText('success', 'You dug up an Uncut Diamond!')
            end
        end
        -- Extra randoms
        local irnc = math.random(Config.Chance.RawIron[1], Config.Chance.RawIron[2])
        local weesee = math.random(Config.Chance.WeedSeed[1], Config.Chance.WeedSeed[2])
        if (irnc == 2) then
            TriggerServerEvent('prospect:rawiron', "") 
            exports['mythic_notify']:DoHudText('success', 'You dug up a piece of Raw Iron!')
        end
        if (weesee == 2) then
            local wdsd = math.random(Config.Chance.WeedSeed[1], Config.Chance.WeedSeed[2])
            exports['mythic_notify']:DoHudText('success', 'You found a seed!')
            if (wdsd == 2) then
                TriggerServerEvent('prospect:weedm', "")
            else
                TriggerServerEvent('prospect:weedf', "")
            end
        end
        active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You cannot do that right now!')
    end
end)

-- Panning handler
RegisterNetEvent('prospect:pan')
AddEventHandler ('prospect:pan', function()
    if (active == false) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        active = true
        if IsEntityInWater(GetPlayerPed(-1)) then
            local inventory = ESX.GetPlayerData().inventory
            local dirtCount = 0
            for i=1, #inventory, 1 do
                if inventory[i].name == Config.Items.PayDirt then
                    dirtCount = inventory[i].count
                    break
                end
            end
            if (dirtCount >= 1) then
                LoadAnim("amb@world_human_gardener_plant@female@idle_a")
                TaskPlayAnim(PlayerPedId(), "amb@world_human_gardener_plant@female@idle_a", "idle_a_female", 8.0, 8.0, 5000, 0, 0, false, false, false)
                Citizen.Wait(5000)
                if dirtCount > 10 then
                    local nuggie = math.random(Config.Chance.GoldNugget[1], Config.Chance.GoldNugget[2])
                    if (nuggie == 2)then
                        exports['mythic_notify']:DoHudText('success', 'You found a gold nugget!')
                        TriggerServerEvent('prospect:ypaydirt', 10)
                    else
                        exports['mythic_notify']:DoHudText('error', 'You did not find any gold!')
                        TriggerServerEvent('prospect:npaydirt', 10)
                    end
                else
                    local nuggie = math.random(Config.Chance.GoldNugget[1], Config.Chance.GoldNugget[2])
                    if (nuggie == 2)then
                        exports['mythic_notify']:DoHudText('success', 'You found a gold nugget!')
                        TriggerServerEvent('prospect:ypaydirt', dirtCount)
                    else
                        exports['mythic_notify']:DoHudText('error', 'You did not find any gold!')
                        TriggerServerEvent('prospect:npaydirt', dirtCount)
                    end
                end
            else
                exports['mythic_notify']:DoHudText('error', 'You have no pay dirt to process!')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'You are not near water!')
        end
    active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You cannot do that right now!')
    end
end)

-- Iron Oxide Handler
RegisterNetEvent('prospect:irust')
AddEventHandler ('prospect:irust', function()
    if (active == false) then
        active = true
        local inventory = ESX.GetPlayerData().inventory
        local ironCount = 0
        for i=1, #inventory, 1 do
            if inventory[i].name == Config.Use.RustyIron then
                ironCount = inventory[i].count
            end
        end
        if (ironCount >= 5) then
            LoadAnim("amb@world_human_bum_standing@twitchy@base")
            TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 0, 0, false, false, false)
            Citizen.Wait(5000)
            exports['mythic_notify']:DoHudText('success', 'You processed some Rusty Iron into Iron Oxide!')
            TriggerServerEvent('prospect:ironoxide', "")
        else
            exports['mythic_notify']:DoHudText('error', 'You have no Rusty Iron to process!')
        end
        active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You are already doing something!')
    end
end)

-- Thermite Handler
RegisterNetEvent('prospect:thermal')
AddEventHandler ('prospect:thermal', function()
    if (active == false) then
        active = true
        local inventory = ESX.GetPlayerData().inventory
        local foilC = 0
        local irnoC = 0
        for i=1, #inventory, 1 do
            if inventory[i].name == Config.Use.Aluminum then
                foilC = inventory[i].count
            end
            if inventory[i].name == Config.Items.IronOxide then
                irnoC = inventory[i].count
            end
        end
        if (foilC >= 1) then
            if (irnoC >= 10) then
                LoadAnim("amb@world_human_bum_standing@twitchy@base")
                TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 0, 0, false, false, false)
                Citizen.Wait(5000)
                TriggerServerEvent('prospect:thermite', "")
                exports['mythic_notify']:DoHudText('success', 'You created a Thermite charge!')
            else
                exports['mythic_notify']:DoHudText('error', 'Not enough Iron Oxide!')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'Not enough Aluminum Foil!')
        end
    active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You are already doing something!')
    end
end)

-- Smelting Gold
RegisterNetEvent('prospect:pgold')
AddEventHandler ('prospect:pgold', function()
    if (active == false) then
        active = true
        if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Smelter[1].x,Config.Smelter[1].y,Config.Smelter[1].z, true) < Config.SmeltDist) then
            local inventory = ESX.GetPlayerData().inventory
            local goldore = 0
            for i=1, #inventory, 1 do
                if inventory[i].name == Config.Items.GoldNugget then
                    goldore = inventory[i].count
                end
            end
            if (goldore >= 10) then
                LoadAnim("amb@world_human_bum_standing@twitchy@base")
                TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 0, 0, false, false, false)
                Citizen.Wait(5000)
                TriggerServerEvent('prospect:smeltgold', "")
                exports['mythic_notify']:DoHudText('success', 'You smelted a Gold Bar!')
            else
                exports['mythic_notify']:DoHudText('error', 'Not enough Gold Nuggets!')
            end  
        else
            exports['mythic_notify']:DoHudText('error', 'You are in the wrong place!')
        end
    active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You are already doing something!')
    end
end)

-- Smelting Platinum
RegisterNetEvent('prospect:pplat')
AddEventHandler ('prospect:pplat', function()
    if (active == false) then
        active = true
        if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Smelter[1].x,Config.Smelter[1].y,Config.Smelter[1].z, true) < Config.SmeltDist) then
            local inventory = ESX.GetPlayerData().inventory
            local platore = 0
            for i=1, #inventory, 1 do
                if inventory[i].name == Config.Items.Platinum then
                    platore = inventory[i].count
                end
            end
            if (platore >= 10) then
                LoadAnim("amb@world_human_bum_standing@twitchy@base")
                TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 0, 0, false, false, false)
                Citizen.Wait(5000)
                TriggerServerEvent('prospect:smeltplat', "")
                exports['mythic_notify']:DoHudText('success', 'You smelted a platinum bar!')
            else
                exports['mythic_notify']:DoHudText('error', 'Not enough Platinum Ore!')
            end 
        else
            exports['mythic_notify']:DoHudText('error', 'You are in the wrong place!')
        end
    active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You are already doing something!')
    end
end)

-- Smelting Iron
RegisterNetEvent('prospect:piron')
AddEventHandler ('prospect:piron', function()
    if (active == false) then
        active = true
        if (GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Smelter[1].x,Config.Smelter[1].y,Config.Smelter[1].z, true) < Config.SmeltDist) then
            local inventory = ESX.GetPlayerData().inventory
            local ironore = 0
            for i=1, #inventory, 1 do
                if inventory[i].name == Config.Items.RawIron then
                    ironore = inventory[i].count
                end
            end
            if (ironore >= 5) then
                LoadAnim("amb@world_human_bum_standing@twitchy@base")
                TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 0, 0, false, false, false)
                Citizen.Wait(5000)
                TriggerServerEvent('prospect:smeltiron', "")
                exports['mythic_notify']:DoHudText('success', 'You smelted an Iron Bar!')
            else
                exports['mythic_notify']:DoHudText('error', 'Not enough Iron Ore!')
            end        
        else
            exports['mythic_notify']:DoHudText('error', 'You are in the wrong place!')
        end
    active = false
    else
        exports['mythic_notify']:DoHudText('error', 'You are already doing something!')
    end
end)

function LoadAnim(animDict)
    RequestAnimDict(animDict)
  
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(10)
    end
end

------------------------Search Dumpsters-----------------------------------------------
Citizen.CreateThread(function()
    while true do
        sleep = 1000
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            if dumpster.config.canSearch then
                local pos = GetEntityCoords(PlayerPedId())
                local dumpsterFound = false
                for i = 1, #dumpster.dumpsters do
                    local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpster.dumpsters[i], false, false, false)
                    local dumpPos = GetEntityCoords(dumpster)
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpPos.x, dumpPos.y, dumpPos.z, true) < 1.8 then
                        sleep = 1
                        DrawText3D(dumpPos.x, dumpPos.y, dumpPos.z + 1.0, 'Press [~y~H~w~] to dumpster dive')
                        if IsControlJustReleased(0, 74) then
                            for i = 1, #searched do
                                if searched[i] == dumpster then
                                    dumpsterFound = true
                                end
                                if i == #searched and dumpsterFound then
                                    exports['mythic_notify']:DoHudText('error', 'You have already searched this dumpster!')
                                elseif i == #searched and not dumpsterFound then
                                    startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base')
                                    TriggerServerEvent('onyx:startDumpsterTimer', dumpster)
                                    table.insert(searched, dumpster)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('onyx:removeDumpster')
AddEventHandler('onyx:removeDumpster', function(object)
    for i = 1, #searched do
        if searched[i] == object then
            table.remove(searched, i)
        end
    end
end)

function startSearching(time, dict, anim)
    local animDict = dict
    local animation = anim
    local ped = PlayerPedId()
    canSearch = false
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    exports['progressBars']:startUI(time, "Searching Dumpster")
    TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)
    local ped = PlayerPedId()
    Wait(time)
    ClearPedTasks(ped)
    canSearch = true
    TriggerServerEvent('onyx:giveDumpsterReward')
end

------------------------Crafting------------------------------------------------------

--DELTAS ATTEMPT AT OPTIMIZING SHIT YO
local HasAlreadyEnteredMarker, LastZone = false, nil

AddEventHandler('khaos_prospect:enteredMarker', function(zone)
    if zone == 'craftingtable1' then
        craftTable = Crafting.Items
        CurrentAction = 'craftingtable1'
    end

    if zone == 'craftingtable2' then
        craftTable = Crafting.ItemsG
        CurrentAction = 'craftingtable2'
    end
end)

AddEventHandler('khaos_prospect:leftMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Main Thread for Crafting
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped, false)
        local IsInMarker = false
        local CurrentZone = nil
        dumpsterDiveTextDraw = false
        local craftingtable1Coords = vector3(Crafting.Locations[1].x,Crafting.Locations[1].y,Crafting.Locations[1].z)
        local craftingtable2Coords = vector3(Crafting.Locations[2].x,Crafting.Locations[2].y,Crafting.Locations[2].z)
        local ct1Dist = #(playerCoords - craftingtable1Coords)
        local ct2Dist = #(playerCoords - craftingtable2Coords)
        ct1Draw = false
        ct2Draw = false
        if(ct1Dist < 5) then
            ct1Draw = true
            if(ct1Dist < 2) then
                IsInMarker = true
                CurrentZone = 'craftingtable1'
            end
        end
        if PlayerData.job ~= nil then
            if (PlayerData.job.name == 'nightclub') and (PlayerData.job.grade == 4) or (PlayerData.job.name == 'nightclub') and (PlayerData.job.grade == 3) then
                if(ct2Dist < 5) then
                    ct2Draw = true
                    if(ct2Dist < 2) then
                        IsInMarker = true
                        CurrentZone = 'craftingtable2'
                    end
                end
            end
        end

        if (IsInMarker and not HasAlreadyEnteredMarker) or (IsInMarker and LastZone ~= CurrentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = CurrentZone
			TriggerEvent('khaos_prospect:enteredMarker', CurrentZone)
		end
		if (not IsInMarker and HasAlreadyEnteredMarker) then
			HasAlreadyEnteredMarker = false
			TriggerEvent('khaos_prospect:leftMarker', LastZone)
		end
    end
end)

-- Draw thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (ct1Draw ~= nil) and (ct1Draw) then
            DrawText3D(1208.73, -3114.41, 5.55, "[~g~E~w~] to craft item")
        elseif (ct2Draw ~= nil) and (ct2Draw) then
            DrawText3D(379.12, 258.88, 92.19, "[~g~E~w~] to craft item")
        elseif (rangeDraw ~= nil) and (rangeDraw) then
            DrawText3D(Config.Smelter[1].x,Config.Smelter[1].y,Config.Smelter[1].z, 'Come closer to the smelter')
        elseif (range2Draw ~= nil) and (range2Draw) then
            DrawText3D(Config.Smelter[1].x,Config.Smelter[1].y,Config.Smelter[1].z, '~g~Use~w~ your ore to smelt it')
        else
            Citizen.Wait(1000)
        end
    end
end)

--Key Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(CurrentAction) then
            if (IsControlJustPressed(0, 38)) then
                if CurrentAction == 'craftingtable1' then
                    OpenCraftMenu()
                elseif CurrentAction == 'craftingtable2' then
                    if (PlayerData.job.name == 'nightclub') and (PlayerData.job.grade == 4) or (PlayerData.job.name == 'nightclub') and (PlayerData.job.grade == 3) then
                        OpenCraftMenu()
                    else
                        exports['mythic_notify']:DoHudText('error', 'You cannot use this!')
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback('CraftingSuccess', function()
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(PlayerPedId(),false)
    if craftTable == Crafting.ItemsG then
        TriggerServerEvent("rs_crafting:CraftingSuccessG", CurrentCraft)
    elseif craftTable == Crafting.Items then
        TriggerServerEvent("rs_crafting:CraftingSuccess", CurrentCraft)
    end
end)

RegisterNUICallback('CraftingFailed', function()
    SetNuiFocus(false, false)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1),false)
    if craftTable == Crafting.ItemsG then
        TriggerServerEvent("rs_crafting:CraftingFailedG", CurrentCraft)
    elseif craftTable == Crafting.Items then
        TriggerServerEvent("rs_crafting:CraftingFailed", CurrentCraft)
    end
    exports['mythic_notify']:DoHudText('error', 'You failed to craft the item!')
end)

function OpenCraftMenu()
    local elements = {}
    ESX.TriggerServerCallback('rs_crafting:GetSkillLevel', function(level)
        for item, v in pairs(craftTable) do
            if tonumber(level) >= v.threshold then
                local elementlabel = v.label .. ": "
                local somecount = 1
                for k, need in pairs(v.needs) do
                    if somecount == 1 then
                        somecount = somecount + 1
                        elementlabel = elementlabel .. need.label .. " ("..need.count..")"
                    else
                        elementlabel = elementlabel .. " - "..need.label .. " ("..need.count..")"
                    end
                end
                table.insert(elements, {value = item, label = elementlabel})
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_actions', {
            title    = "Crafting Table",
            elements = elements,
            align    = 'bottom-right',
        }, function(data, menu)
            menu.close()
            CurrentCraft = data.current.value
            if craftTable == Crafting.ItemsG then
                ESX.TriggerServerCallback('rs_crafting:HasTheItemsG', function(result)
                    if result then
                        if not busy then
                            busy = true
                            exports['mythic_notify']:DoHudText('success', 'You are currently crafting press [E] to cancel!')
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "crafting_galaxy",
                                duration = 15000,
                                label = "Crafting",
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = true,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_ped",
                                }
                            }, function(status)
                                if not status then
                                exports['mythic_notify']:DoHudText('success', 'You finished crafting!')
                                TriggerServerEvent("rs_crafting:CraftingSuccessG", CurrentCraft)
                                ClearPedTasks(GetPlayerPed(-1))
                                StopAnimTask(GetPlayerPed(-1), 'mini@repair', 'fixing_a_ped')
                                busy = false
                                elseif status then
                                exports['mythic_notify']:DoHudText('error', 'Crafting Cancelled!')
                                ClearPedTasks(GetPlayerPed(-1))
                                StopAnimTask(GetPlayerPed(-1), 'mini@repair', 'fixing_a_ped')
                                busy = false
                                end
                            end)
                        end
                        -- SetNuiFocus(true,true)
                        -- SendNUIMessage({
                        --     action = "opengame",
                        -- })
                        -- RequestAnimDict("mini@repair")
                        -- while (not HasAnimDictLoaded("mini@repair")) do
                        --     Citizen.Wait(0)
                        -- end
                        -- TaskPlayAnim(GetPlayerPed(-1), "mini@repair" ,"fixing_a_ped" ,8.0, -8.0, -1, 1, 0, false, false, false )
                        -- FreezeEntityPosition(GetPlayerPed(-1),true)
                    else
                        exports['mythic_notify']:DoHudText('error', 'You do not have the required items!')
                    end
                end, CurrentCraft)
            elseif craftTable == Crafting.Items then
                ESX.TriggerServerCallback('rs_crafting:HasTheItems', function(result)
                    if result then
                        SetNuiFocus(true,true)
                        SendNUIMessage({
                            action = "opengame",
                        })
                        RequestAnimDict("mini@repair")
                        while (not HasAnimDictLoaded("mini@repair")) do
                            Citizen.Wait(0)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "mini@repair" ,"fixing_a_ped" ,8.0, -8.0, -1, 1, 0, false, false, false )
                        FreezeEntityPosition(GetPlayerPed(-1),true)
                    else
                        exports['mythic_notify']:DoHudText('error', 'You do not have the required items!')
                    end
                end, CurrentCraft)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

DrawText3D = function(x, y, z, text)
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
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	ClearDrawOrigin()
end
