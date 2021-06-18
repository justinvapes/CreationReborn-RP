--[[ NARCOTIX CLIENT SCRIPT ]]--
--[[      NATURALKHAOS      ]]--
--[[   CREATION REBORN RP   ]]--

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

ESX               = nil
jhigh             = 0
weedtype          = nil
local weedcount   = 0
local rollmed     = false
local activeRoll  = false
local busy     = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Set to a rolling with low buds
RegisterNetEvent('narcotix:roll_lowjoint')
AddEventHandler ('narcotix:roll_lowjoint', function()
  weedtype = Config.Pweed.Items.WeedLow
  rolling('low')
end)

-- Set to rolling with Average buds
RegisterNetEvent('narcotix:roll_avejoint')
AddEventHandler ('narcotix:roll_avejoint', function()
  weedtype = Config.Pweed.Items.WeedAve
  rolling('ave')
end)

-- Set to rolling with Medium buds
RegisterNetEvent('narcotix:roll_medjoint')
AddEventHandler ('narcotix:roll_medjoint', function()
  weedtype = Config.Pweed.Items.WeedMed
  rolling('med')
end)

-- Set to rolling with High buds
RegisterNetEvent('narcotix:roll_highjoint')
AddEventHandler ('narcotix:roll_highjoint', function()
  weedtype = Config.Pweed.Items.WeedHgh
  rolling('high')
end)

-- Set to rolling with Medicinal buds
RegisterNetEvent('narcotix:roll_mjoint')
AddEventHandler ('narcotix:roll_mjoint', function()
  weedtype = Config.Pweed.Items.MBud
  rolling('medi')
end)

function rolling(type)
  print(busy)
  if not busy then
    busy = true
    exports['mythic_notify']:DoHudText('error', 'You are rolling a joint press [E] to cancel')
    TriggerEvent("mythic_progbar:client:progress", {
      name = "rolling_joints",
      duration = 6000,
      label = "Rolling Joints",
      useWhileDead = false,
      canCancel = true,
      controlDisables = {
          disableMovement = false,
          disableCarMovement = false,
          disableMouse = false,
          disableCombat = true,
      },
      animation = {
          animDict = "amb@world_human_bum_standing@twitchy@base",
          anim = "base",
      }
    }, function(status)
      if not status then
        exports['mythic_notify']:DoHudText('success', 'You rolled a joint')
        TriggerServerEvent('narcotix:rolljoint', type)
        ClearPedTasks(GetPlayerPed(-1))
        StopAnimTask(GetPlayerPed(-1), 'amb@world_human_bum_standing@twitchy@base', 'base')
        busy = false
      elseif status then
        exports['mythic_notify']:DoHudText('error', 'Roll Cancelled')
      ClearPedTasks(GetPlayerPed(-1))
      StopAnimTask(GetPlayerPed(-1), 'amb@world_human_bum_standing@twitchy@base', 'base')
      busy = false
      end
    end)
  else
    exports['mythic_notify']:DoHudText('error', 'Already Rolling')
  end
end


-- Roll the joint
-- function rolling()
--   if activeRoll == false then
--     activeRoll = true
--     local inventory = ESX.GetPlayerData().inventory
--     local pCount = 0
--     local wCount = 0
--     for i=1, #inventory, 1 do
--     if inventory[i].name == Config.Pweed.Items.Paper then
--       pCount = inventory[i].count
--     end
--     if inventory[i].name == weedtype then
--       wCount = inventory[i].count
--     end
--     end
--     if (pCount >= 1) then
--     if (wCount >= weedcount) then
--       while (wCount >= weedcount) and (pCount >= 1) and (not IsControlPressed(0, 38)) do
--       LoadAnim("amb@world_human_bum_standing@twitchy@base")
--       TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, 8.0, 5000, 50, 0, false, false, false)
--       local buds = math.random(Config.Pweed.jbudhgh[1], Config.Pweed.jbudhgh[2])
--       if (wCount >= 2) and (buds == 13) and (Config.Pweed.jmed_active) and (rollmed == true) then
--         if weedtype == Config.Pweed.Items.WeedHgh then
--           TriggerServerEvent('narcotix:hmed', "")
--         else
--           TriggerServerEvent('narcotix:mmed', "")
--         end
--       end
--       wCount = wCount - weedcount
--       pCount = pCount - 1
--       Citizen.Wait(6000)
--       if (weedtype == Config.Pweed.Items.MBud) then
--         TriggerServerEvent('narcotix:mroll', "")
--       elseif (weedtype == Config.Pweed.Items.WeedHgh) then
--         TriggerServerEvent('narcotix:rollhigh', "")
--       elseif (weedtype == Config.Pweed.Items.WeedMed) then
--         TriggerServerEvent('narcotix:rollmed', "")
--       elseif (weedtype == Config.Pweed.Items.WeedAve) then
--         TriggerServerEvent('narcotix:rollave', "")
--       elseif (weedtype == Config.Pweed.Items.WeedLow) then
--         TriggerServerEvent('narcotix:rolllow', "")
--       end
--       activeRoll = false
--       end
--     else
--       activeRoll = false
--     end
--     else
--     activeRoll = false
--     end
--   end
-- end

-- Smoke a Medicinal Joint and Restore a small amount of health
RegisterNetEvent('narcotix:smoke_mjoint')
AddEventHandler ('narcotix:smoke_mjoint', function()
    LoadAnim("amb@world_human_smoking_pot@male@idle_a")
    TaskPlayAnim(PlayerPedId(), "amb@world_human_smoking_pot@male@idle_a", "idle_c", 8.0, 8.0, 3000, 50, 0, false, false, false)
    Citizen.Wait(3000)
    if jhigh == 0 then
     local playerPed = PlayerPedId()
     local maxHealth = GetEntityMaxHealth(playerPed)
     local health = GetEntityHealth(playerPed)
     local newHealth = math.min(maxHealth, math.floor(health + maxHealth / Config.Pweed.jmed))
     jhigh = 1
     SetEntityHealth(playerPed, newHealth)
     SetTimecycleModifier("spectator5")
     SetPedMotionBlur(playerPed, true)
     SetPedMovementClipset(playerPed, "MOVE_M@QUICK", true)
     SetPedIsDrunk(playerPed, true)
     AnimpostfxPlay("SuccessMichael", 10000001, true)
     ShakeGameplayCam("DRUNK_SHAKE", 3.0)
     Citizen.Wait(180000)
     SetPedMoveRateOverride(PlayerId(),1.0)
     SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
     SetPedIsDrunk(GetPlayerPed(-1), false)   
     SetPedMotionBlur(playerPed, false)
     ResetPedMovementClipset(GetPlayerPed(-1))
     exports["dpemotes"]:ResetCurrentWalk()
     AnimpostfxStopAll()
     ShakeGameplayCam("DRUNK_SHAKE", 0.0)
     SetTimecycleModifierStrength(0.0)
     jhigh = 0
    else
    exports['mythic_notify']:DoHudText('error', 'You smoke a Medicinal Joint but feel no effect')
    end
end)

function LoadAnim(animDict)
  RequestAnimDict(animDict)

  while not HasAnimDictLoaded(animDict) do
    Citizen.Wait(10)
  end
end