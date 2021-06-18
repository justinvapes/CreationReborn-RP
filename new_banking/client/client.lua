--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX                         = nil
inMenu                      = true
local showblips = true
local atbank = false
local bankMenu = true

local banks = {
  {name="Bank", id=108, color=69, x=149.15, y=-1040.39, z=29.374},
  {name="Bank", id=108, color=69, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, color=69, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, color=69, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, color=69, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, color=69, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, color=69, x=247.45, y=223.32, z=106.29},
  {name="Bank", id=108, color=69, x=1175.0643310547, y=2706.6435546875, z=38.094036102295}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('bank:OpenUI')
AddEventHandler('bank:OpenUI', function()
    inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:balance')
end)

if bankMenu then
  Citizen.CreateThread(function()
	 while true do
        local sleep = 100
	   
	if nearBank() then
	   sleep = 5
	   DisplayHelpText("~y~Press ~w~~INPUT_PICKUP~ To ~g~Access ~w~Your ~b~Account ~b~")

		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('bank:balance')
		 end
	  end

		if IsControlJustPressed(1, 322) then
		   inMenu = false
		   SetNuiFocus(false, false)
		   SendNUIMessage({type = 'close'})
      end
	  Citizen.Wait(sleep)
    end
  end)
end

Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)

	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('2e6639e61733280d2a8efe09740792de', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('67349af9c9f7a187356163fdd3e8587e', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('3fdfbcce0a19c340235a320950b77af6', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()

	local playerPos = GetEntityCoords(PlayerPedId())	

	for i = 1, #banks do
				
		local Banks = vector3(banks[i].x, banks[i].y, banks[i].z)
		local distance = #(playerPos - Banks)

		if distance <= 1 then
		   return true
		end
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
