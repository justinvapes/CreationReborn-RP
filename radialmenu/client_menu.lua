ESX = nil
local menu = nil

-- Menu state
local showMenu = false
local menu = nil

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local MAX_MENU_ITEMS = 7


-- RegisterKeyMapping('+menutest', 'Test', 'keyboard', 'z')
RegisterKeyMapping('+radialmenu', 'Open Radial Menu', 'keyboard', 'z')
RegisterCommand('+radialmenu', function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) and not showMenu then
        menu = "car"
        showMenu = true
        local enabledMenus = {}
        for _, menuConfig in ipairs(rootMenuConfig) do
            if menuConfig.group == "car" then
                local dataElements = {}
                local hasSubMenus = false
                if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                    hasSubMenus = true
                    local previousMenu = dataElements
                    local currentElement = {}
                    for i = 1, #menuConfig.subMenus do
                        -- if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
                        --     goto continue
                        -- end
                        currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
                        currentElement[#currentElement].id = menuConfig.subMenus[i]
                        currentElement[#currentElement].enableMenu = nil

                        if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                            previousMenu[MAX_MENU_ITEMS + 1] = {
                                id = "_more",
                                title = "More",
                                icon = "#more",
                                items = currentElement
                            }
                            previousMenu = currentElement
                            currentElement = {}
                        end
                        --::continue::
                    end
                    if #currentElement > 0 then
                        previousMenu[MAX_MENU_ITEMS + 1] = {
                            id = "_more",
                            title = "More",
                            icon = "#more",
                            items = currentElement
                        }
                    end
                    dataElements = dataElements[MAX_MENU_ITEMS + 1].items

                end
                enabledMenus[#enabledMenus+1] = {
                    id = menuConfig.id,
                    title = menuConfig.displayName,
                    functionName = menuConfig.functionName,
                    icon = menuConfig.icon,
                }
                if hasSubMenus then
                    enabledMenus[#enabledMenus].items = dataElements
                end
            end
        end
        SendNUIMessage({
            state = "show",
            resourceName = GetCurrentResourceName(),
            data = enabledMenus,
            menuKeyBind = keyBind
        })
        SetCursorLocation(0.5, 0.5)
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        -- Play sound
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    elseif IsPedOnFoot(GetPlayerPed(-1), false) and not showMenu then
        menu = "foot"
        showMenu = true
        local enabledMenus = {}
        for _, menuConfig in ipairs(rootMenuConfig) do
            if menuConfig.group == "foot" then
                local dataElements = {}
                local hasSubMenus = false
                if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                    hasSubMenus = true
                    local previousMenu = dataElements
                    local currentElement = {}
                    for i = 1, #menuConfig.subMenus do
                        -- if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
                        --     goto continue
                        -- end
                        currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
                        currentElement[#currentElement].id = menuConfig.subMenus[i]
                        currentElement[#currentElement].enableMenu = nil

                        if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                            previousMenu[MAX_MENU_ITEMS + 1] = {
                                id = "_more",
                                title = "More",
                                icon = "#more",
                                items = currentElement
                            }
                            previousMenu = currentElement
                            currentElement = {}
                        end
                        --::continue::
                    end
                    if #currentElement > 0 then
                        previousMenu[MAX_MENU_ITEMS + 1] = {
                            id = "_more",
                            title = "More",
                            icon = "#more",
                            items = currentElement
                        }
                    end
                    dataElements = dataElements[MAX_MENU_ITEMS + 1].items

                end
                enabledMenus[#enabledMenus+1] = {
                    id = menuConfig.id,
                    title = menuConfig.displayName,
                    functionName = menuConfig.functionName,
                    icon = menuConfig.icon,
                }
                if hasSubMenus then
                    enabledMenus[#enabledMenus].items = dataElements
                end
            end
        end
        SendNUIMessage({
            state = "show",
            resourceName = GetCurrentResourceName(),
            data = enabledMenus,
            menuKeyBind = keyBind
        })
        SetCursorLocation(0.5, 0.5)
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        -- Play sound
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    end
end)
RegisterCommand('-radialmenu', function()
    if showMenu then
        -- Clear focus and destroy UI
        showMenu = false
        menu = nil
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            state = 'destroy'
        })

        -- Play sound
        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    end
end)


-- RegisterCommand('radialmenu', function()
--     if IsPedInAnyVehicle(GetPlayerPed(-1), false) and not showMenu then
--         menu = "car"
--         showMenu = true
--         local enabledMenus = {}
--         for _, menuConfig in ipairs(rootMenuConfig) do
--             if menuConfig.group == "car" then
--                 local dataElements = {}
--                 local hasSubMenus = false
--                 if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
--                     hasSubMenus = true
--                     local previousMenu = dataElements
--                     local currentElement = {}
--                     for i = 1, #menuConfig.subMenus do
--                         -- if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
--                         --     goto continue
--                         -- end
--                         currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
--                         currentElement[#currentElement].id = menuConfig.subMenus[i]
--                         currentElement[#currentElement].enableMenu = nil

--                         if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
--                             previousMenu[MAX_MENU_ITEMS + 1] = {
--                                 id = "_more",
--                                 title = "More",
--                                 icon = "#more",
--                                 items = currentElement
--                             }
--                             previousMenu = currentElement
--                             currentElement = {}
--                         end
--                         --::continue::
--                     end
--                     if #currentElement > 0 then
--                         previousMenu[MAX_MENU_ITEMS + 1] = {
--                             id = "_more",
--                             title = "More",
--                             icon = "#more",
--                             items = currentElement
--                         }
--                     end
--                     dataElements = dataElements[MAX_MENU_ITEMS + 1].items

--                 end
--                 enabledMenus[#enabledMenus+1] = {
--                     id = menuConfig.id,
--                     title = menuConfig.displayName,
--                     functionName = menuConfig.functionName,
--                     icon = menuConfig.icon,
--                 }
--                 if hasSubMenus then
--                     enabledMenus[#enabledMenus].items = dataElements
--                 end
--             end
--         end
--         SendNUIMessage({
--             state = "show",
--             resourceName = GetCurrentResourceName(),
--             data = enabledMenus,
--             menuKeyBind = keyBind
--         })
--         SetCursorLocation(0.5, 0.5)
--         SetNuiFocus(true, true)
--         SetNuiFocusKeepInput(true)

--         -- Play sound
--         PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
--     elseif IsPedOnFoot(GetPlayerPed(-1), false) and not showMenu then
--         menu = "foot"
--         showMenu = true
--         local enabledMenus = {}
--         for _, menuConfig in ipairs(rootMenuConfig) do
--             if menuConfig.group == "foot" then
--                 local dataElements = {}
--                 local hasSubMenus = false
--                 if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
--                     hasSubMenus = true
--                     local previousMenu = dataElements
--                     local currentElement = {}
--                     for i = 1, #menuConfig.subMenus do
--                         -- if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
--                         --     goto continue
--                         -- end
--                         currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
--                         currentElement[#currentElement].id = menuConfig.subMenus[i]
--                         currentElement[#currentElement].enableMenu = nil

--                         if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
--                             previousMenu[MAX_MENU_ITEMS + 1] = {
--                                 id = "_more",
--                                 title = "More",
--                                 icon = "#more",
--                                 items = currentElement
--                             }
--                             previousMenu = currentElement
--                             currentElement = {}
--                         end
--                         --::continue::
--                     end
--                     if #currentElement > 0 then
--                         previousMenu[MAX_MENU_ITEMS + 1] = {
--                             id = "_more",
--                             title = "More",
--                             icon = "#more",
--                             items = currentElement
--                         }
--                     end
--                     dataElements = dataElements[MAX_MENU_ITEMS + 1].items

--                 end
--                 enabledMenus[#enabledMenus+1] = {
--                     id = menuConfig.id,
--                     title = menuConfig.displayName,
--                     functionName = menuConfig.functionName,
--                     icon = menuConfig.icon,
--                 }
--                 if hasSubMenus then
--                     enabledMenus[#enabledMenus].items = dataElements
--                 end
--             end
--         end
--         SendNUIMessage({
--             state = "show",
--             resourceName = GetCurrentResourceName(),
--             data = enabledMenus,
--             menuKeyBind = keyBind
--         })
--         SetCursorLocation(0.5, 0.5)
--         SetNuiFocus(true, true)
--         SetNuiFocusKeepInput(true)

--         -- Play sound
--         PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
--     elseif showMenu then
--         -- Clear focus and destroy UI
--         showMenu = false
--         menu = nil
--         SetNuiFocus(false, false)
--         SetNuiFocusKeepInput(false)
--         SendNUIMessage({
--             state = 'destroy'
--         })
    
--         -- Play sound
--         PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showMenu then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 257, true)
            DisableControlAction(1, 263, true)
            DisableControlAction(1, 264, true)
            DisableControlAction(1, 24, true)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) and menu ~= "car" then
                -- Clear focus and destroy UI
                showMenu = false
                menu = nil
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({
                    state = 'destroy'
                })
            
                -- Play sound
                PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            elseif IsPedOnFoot(GetPlayerPed(-1), true) and menu ~= "foot" then
                -- Clear focus and destroy UI
                showMenu = false
                menu = nil
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false)
                SendNUIMessage({
                    state = 'destroy'
                })
            
                -- Play sound
                PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            end
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if showMenu then
            -- Clear focus and destroy UI
            showMenu = false
            menu = nil
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({
                state = 'destroy'
            })
        
            -- Play sound
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
        end
    end
end)

-- Main thread
-- Citizen.CreateThread(function()
--     local keyBind = "a"
--     while true do
--         Citizen.Wait(0)
--         if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) and showMenu then
--             showMenu = false
--             SetNuiFocus(false, false)
--         end
--         if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) then
--             while showMenu == true do Citizen.Wait(100) end
--             Citizen.Wait(100)
--             while IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) do Citizen.Wait(100) end
--         end
--     end
-- end)

-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    menu = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

RegisterCommand('hidemenu', function(playerId, args, rawCommand)
    showMenu = false
    menu = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        state = 'destroy'
    })
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('triggerAction', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    menu = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    ExecuteCommand(data.action)
    -- Send ACK to callback function
    cb('ok')
end)

RegisterNetEvent("menu:menuexit")
AddEventHandler("menu:menuexit", function()
    showMenu = false
    menu = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end)