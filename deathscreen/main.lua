local isPlayerDead = false


Citizen.CreateThread(function()
    while true do
        if IsPlayerDead(PlayerId()) then
            if isPlayerDead == false then 
                isPlayerDead = true
                SendNUIMessage({
					setDisplay = true
				})
				DisableControlAction(1, 244, true)
            end
        else 
            if isPlayerDead == true then
                isPlayerDead = false
                SendNUIMessage({
					setDisplay = false
				})
				DisableControlAction(1, 244, false)
            end
        end
        Citizen.Wait(100)
    end
end)


RegisterNetEvent("esx_ambulancejob:PlayScreen")
AddEventHandler("esx_ambulancejob:PlayScreen", function()
SendNUIMessage({setDisplayHospital = true})
end)

RegisterNetEvent('esx_ambulancejob:StopScreen')
AddEventHandler('esx_ambulancejob:StopScreen', function()
SendNUIMessage({setDisplayHospital = false})
end)   
                    

