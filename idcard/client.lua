local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open')
AddEventHandler('jsfour-idcard:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if open then
           hintToDisplay('~y~Press ~s~~INPUT_CELLPHONE_CANCEL~ To ~r~Close')
		end
		
		if IsControlJustPressed(0, 177) and open then
			SendNUIMessage({
			  action = "close"
			})
			open = false
		end				
	end
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

