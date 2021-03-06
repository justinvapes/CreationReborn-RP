--====================================================================================
--  Function APP BANK
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updateBankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]

-- ES / ESX Implementation

local bank = 0
local firstname = ''
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setBankBalance(account.money)
                  break
            end
      end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)



--===============================================
--==         Transfer Event                    ==
--===============================================
AddEventHandler('gcphone:bankTransfer', function(data)
      TriggerServerEvent('3fdfbcce0a19c340235a320950b77af6', tonumber(data.id), tonumber(data.amount))
    TriggerServerEvent('bank:balance')
end)







