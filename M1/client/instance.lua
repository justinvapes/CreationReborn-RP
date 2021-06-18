EnterInstance = function(instanceId)
    DecorSetInt(PlayerPedId(), "currentInstance", instanceId)
    DecorSetBool(PlayerPedId(), "inInstance", true)

    --exports["mumble-voip"]:SetRadioChannel(instanceId + 1000)

    --NetworkSetVoiceChannel(instanceId + 1000)
    --NetworkSetTalkerProximity(0.0)
end

ExitInstance = function()
    DecorSetInt(PlayerPedId(), "currentInstance", 0)
    DecorSetBool(PlayerPedId(), "inInstance", false)

	--exports["mumble-voip"]:SetRadioChannel(0)

    --NetworkClearVoiceChannel()
    --NetworkSetTalkerProximity(15.0)
end

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        local sleepThread = 100

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        local currentInstance = DecorGetInt(ped, "currentInstance")

        if currentInstance > 0 then
            sleepThread = 5

            for _, player in pairs(GetActivePlayers()) do
                local playerPed = GetPlayerPed(player)

                if playerPed ~= ped then
                    if DoesEntityExist(playerPed) then
                        if DecorGetInt(playerPed, "currentInstance") ~= currentInstance then
                            SetEntityCoords(playerPed)
                            SetEntityLocallyInvisible(playerPed)
                            SetEntityNoCollisionEntity(ped, playerPed, true)
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(0)

--     while true do
--         local sleepThread = 100

--         local ped = PlayerPedId()
--         local pedCoords = GetEntityCoords(ped)

--         local currentInstance = DecorGetInt(ped, "currentInstance")

--         if currentInstance > 0 then
--             sleepThread = 0
--             --DisableControlAction(0, 249,  true) -- Normal PTT
--             ESX.ShowHelpNotification('Press ~INPUT_VEH_PUSHBIKE_SPRINT~ to talk in the motel', true, true)
--         end

--         Citizen.Wait(sleepThread)
--     end
-- end)