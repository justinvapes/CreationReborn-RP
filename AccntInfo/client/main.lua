local minutesToWait = 10

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000 * 60 * minutesToWait)
		TriggerServerEvent('scrp-idlogs:updateTime', minutesToWait)
	end
end)
