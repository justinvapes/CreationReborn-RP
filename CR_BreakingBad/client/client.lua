ESX = nil
local HasAlreadyEnteredMarker, LastZone = false, nil

------- ESX Thread -------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
     end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
end)

------- MISC Variables -------
local Soundid = GetSoundId()
local CopsOnline = false
local HeistboardLocation = Config.Locations["Heistboard"][1]
local LyeLocation = Config.Locations["LyeShop"][1]
local NPC = { x = LyeLocation[1], y = LyeLocation[2], z = LyeLocation[3], rotation = LyeLocation[4], NetworkSync = true}
local Blips = {}
-- local HeistDraw = false
-- local PbrDraw = false
-- local HlEnterDraw = false
-- local HlExitDraw = false
local TestDraw = false
------- HUMANE LABS -------
local HlScenario = false
-- local HlAlarmTriggered = false
local HlCounter = 1
local HlLocations = Config.Locations["HumaneLabsLocations"]
local KeySpawns = Config.Locations["HumaneLabsLocations"]["KeySpawns"]
-- local HlVan = nil
------- PILLBOX HILL -------
local PbScenario = false -- Rob Pseudoephedrine from Pillbox Medical
-- local PbAlarmTriggered = false
local PbCounter = 1
local PbLocations = Config.Locations["PillboxLocations"]
------- CHEM SUPPLIES -------
local RpScenario = false -- Steal a plane from grapeseed, land in city
-- local RpAlarmTriggered = false
local RpCounter = 1
local RpLocations = Config.Locations["redPhosphorusLocations"]
-- local RpPlane = nil
------- RED PHOSPHORUS -------
local ChemScenario = false -- Rob Pseudoephedrine from Pillbox Medical
local ChemCounter = 1
local ChemLocations = Config.Locations["ChemLocations"]
------- GAS -------
local GasScenario = false -- TBD? Docks are Gas Related, Utility2 is a gas truck thingo
local GasLocations = Config.Locations["GasLocations"]
------- COOK -------
local CookScenario = false
local Cooking = false
local CookTime = 0
local CookLocations = Config.Locations["CookLocations"]
------- SALES -------
local SalesLocations = Config.Locations["SalesLocations"]

-- Main thread
Citizen.CreateThread(function()
    while true do
        local MainWaitTime = 1000
        local Ped = PlayerPedId()
        local Veh = GetEntityModel(GetVehiclePedIsIn(Ped))
        local Dead = IsEntityDead(Ped)
        local PlyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local IsInMarker = false
        local CurrentZone = nil
        local HeistboardCoords = vector3(HeistboardLocation[1], HeistboardLocation[2], HeistboardLocation[3])
        local HeistboardDist = #(PlyCoords - HeistboardCoords)
        local WorkshopCoords = vector3(CookLocations["Workshop"][1], CookLocations["Workshop"][2], CookLocations["Workshop"][3])
        local WorkshopDist = #(PlyCoords - WorkshopCoords)
        local LyeCoords = vector3(LyeLocation[1], LyeLocation[2], LyeLocation[3])
        local LyeDist = #(PlyCoords - LyeCoords)
        HeistDraw = false
        CookDraw = false
        if (HeistboardDist < 25) then
            HeistDraw = true
            if (HeistboardDist < 2) then
                IsInMarker = true
                CurrentZone = 'heistboard'
            end
        end
        if (LyeDist < 1) then
            IsInMarker = true
            CurrentZone = 'lye_shop'
        end
        if (not CookScenario and Veh == GetHashKey(Config.CookVehicle) and (WorkshopDist < 20)) then
            CookDraw = true
            if ((WorkshopDist < 5) and IsDriver()) then
            IsInMarker = true
            CurrentZone = 'workshop'
            end
        end
        if HlScenario then
            local HlCoords = vector3(HlLocations["HLCenter"][1], HlLocations["HLCenter"][2], HlLocations["HLCenter"][3])
            local HlDist = #(PlyCoords - HlCoords)
            local Garage1Coords = vector3(HlLocations["Garage1"][1], HlLocations["Garage1"][2], HlLocations["Garage1"][3])
            local Garage1Dist = #(PlyCoords - Garage1Coords)
            local Garage2Coords = vector3(HlLocations["Garage2"][1], HlLocations["Garage2"][2], HlLocations["Garage2"][3])
            local Garage2Dist = #(PlyCoords - Garage2Coords)
            local ElevatorInCoords = vector3(HlLocations["ElevatorIn"][1], HlLocations["ElevatorIn"][2], HlLocations["ElevatorIn"][3])
            local ElevatorInDist = #(PlyCoords - ElevatorInCoords)
            local ElevatorOutCoords = vector3(HlLocations["ElevatorOut"][1], HlLocations["ElevatorOut"][2], HlLocations["ElevatorOut"][3])
            local ElevatorOutDist = #(PlyCoords - ElevatorOutCoords)
            local VanEndCoords = vector3(HlLocations["VanEndLocation"][1], HlLocations["VanEndLocation"][2], HlLocations["VanEndLocation"][3])
            local VanEndDist= #(PlyCoords - VanEndCoords)
            HlEnterDraw = false
            HlExitDraw = false
            HlVanDraw = false
            if (HlCounter == 1) and (Garage1Dist < 30) then
                MainWaitTime = 200
            end
            if (HlCounter == 1 and (Garage1Dist < 4)) then
                IsInMarker = true
                CurrentZone = 'hlGarage'
            elseif (HlCounter == 1 and (Garage2Dist < 4)) then
                IsInMarker = true
                CurrentZone = 'hlGarage'
            elseif (ElevatorInDist < 4) then
                HlEnterDraw = true
                if (ElevatorInDist < 2) then
                    IsInMarker = true
                    CurrentZone = 'hlEnter'
                end
            elseif (ElevatorOutDist < 4) then
                HlExitDraw = true
                if (ElevatorOutDist < 2) then
                    IsInMarker = true
                    CurrentZone = 'hlExit'
                end
            elseif (HlCounter == 2 and KeyId ~= nil) then
                local KeyLocation = KeySpawns[KeyId];
                if (GetDistanceBetweenCoords(PlyCoords, KeyLocation[1], KeyLocation[2], KeyLocation[3], true) < 2) then
                    IsInMarker = true
                    CurrentZone = 'hlKeys'
                end
            elseif (HlCounter == 3 and Veh == GetHashKey(Config.HLVehicle)) then
                HlCounter = 4
                ESX.ShowNotification(_U('take_the_van'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                TriggerEvent('cr_breakingbad:locationblip', HlLocations["VanEndLocation"][1], HlLocations["VanEndLocation"][2], HlLocations["VanEndLocation"][3])
                exports["LegacyFuel"]:SetFuel(HlVan, 100)
            elseif (HlCounter == 5 and Veh == GetHashKey(Config.HLVehicle)) then
                if (VanEndDist < 50) then
                    HlVanDraw = true
                    if (VanEndDist < 7) then
                        IsInMarker = true
                        CurrentZone = 'hlVan'
                    end
                end
            end
            if (HlCounter >= 3 and DoesEntityExist(HlVan)) then
                if GetVehicleEngineHealth(HlVan) <= 0 then
                    EndScenario("HL", 'vehicle_destroyed', true)
                end
                if (IsEntityInWater(HlVan) and not GetIsVehicleEngineRunning(HlVan)) then
                    EndScenario("HL", 'vehicle_destroyed', true)
                end
            elseif (HlCounter >= 3 and not DoesEntityExist(HlVan)) then
                EndScenario("HL", 'vehicle_destroyed', true)
            end
            if (HlAlarmTriggered and HlCounter ~= 4 and (HlDist > 150)) then
                EndScenario("HL", 'left_humane_labs', true)
            elseif (HlAlarmTriggered and HlCounter == 4 and (HlDist > 150)) then
                TriggerServerEvent("cr_breakingbad:killalarm", false, "Humane Labs")
                StopSound(Soundid)
                HlAlarmTriggered = false
                HlCounter = 5 
            end
        end
        if PbScenario then
            local RestrictedCoords = vector3(PbLocations["RestrictedArea"][1],PbLocations["RestrictedArea"][2],PbLocations["RestrictedArea"][3])
            local RestrictedDist = #(PlyCoords - RestrictedCoords)
            local TheftCoords = vector3(PbLocations["TheftLocation"][1], PbLocations["TheftLocation"][2], PbLocations["TheftLocation"][3])
            local TheftDist = #(PlyCoords - TheftCoords)
            local PbCenterCoords = vector3(PbLocations["PBCenter"][1], PbLocations["PBCenter"][2], PbLocations["PBCenter"][3])
            local PbCenterDist = #(PlyCoords - PbCenterCoords)
            PbrDraw = false
            if (PbCounter == 1 and (RestrictedDist < 15)) then
                MainWaitTime = 200
            end
            if (PbCounter == 1 and (RestrictedDist < 3.7)) then
                IsInMarker = true
                CurrentZone = 'pbRestrictedArea'
            end
            if (PbCounter == 2 and (TheftDist < 15)) then
                PbrDraw = true
                if (TheftDist < 1) then
                    IsInMarker = true
                    CurrentZone = 'pbRobbery'
                end
            end
            if (PbCounter == 2 and PbAlarmTriggered  and (PbCenterDist > 3.5)) then
                EndScenario("PB", 'pb_too_far', true)
            end
        end
        if ChemScenario then
            local RestrictedCoords = vector3(ChemLocations["RestrictedArea"][1],ChemLocations["RestrictedArea"][2],ChemLocations["RestrictedArea"][3])
            local RestrictedDist = #(PlyCoords - RestrictedCoords)
            local RestrictedCoords2 = vector3(ChemLocations["RestrictedArea2"][1],ChemLocations["RestrictedArea2"][2],ChemLocations["RestrictedArea2"][3])
            local RestrictedDist2 = #(PlyCoords - RestrictedCoords2)
            local RestrictedCoords3 = vector3(ChemLocations["RestrictedArea3"][1],ChemLocations["RestrictedArea3"][2],ChemLocations["RestrictedArea3"][3])
            local RestrictedDist3 = #(PlyCoords - RestrictedCoords3)
            local TheftCoords = vector3(ChemLocations["TheftLocation"][1], ChemLocations["TheftLocation"][2], ChemLocations["TheftLocation"][3])
            local TheftDist = #(PlyCoords - TheftCoords)
            local ChemCenterCoords = vector3(ChemLocations["ChemCenter"][1], ChemLocations["ChemCenter"][2], ChemLocations["ChemCenter"][3])
            local ChemCenterDist = #(PlyCoords - ChemCenterCoords)
            ChemDraw = false
            if (ChemCounter == 1 and (RestrictedDist < 15)) then
                MainWaitTime = 200
            end
            if (ChemCounter == 1 and (RestrictedDist < 2)) then
                IsInMarker = true
                CurrentZone = 'chemRestrictedArea'
            elseif (ChemCounter == 1 and (RestrictedDist2 < 2)) then
                IsInMarker = true
                CurrentZone = 'chemRestrictedArea'
            elseif (ChemCounter == 1 and (RestrictedDist3 < 2)) then
                IsInMarker = true
                CurrentZone = 'chemRestrictedArea'
            end

            if (ChemCounter == 2 and (TheftDist < 15)) then
                ChemDraw = true
                if (TheftDist < 2) then
                    IsInMarker = true
                    CurrentZone = 'chemRobbery'
                end
            end
            if (ChemAlarmTriggered and ChemCounter == 2 and (ChemCenterDist > 15)) then
                EndScenario("CHEM", 'chem_too_far', true)
            end
        end
        if RpScenario then
            local RpKeyLoc = vector3(RpLocations["KeyLoc"][1], RpLocations["KeyLoc"][2], RpLocations["KeyLoc"][3])
            local RpKeyDist = #(PlyCoords - RpKeyLoc)
            local RefillCoords = vector3(RpLocations["PlaneRefill"][1], RpLocations["PlaneRefill"][2], RpLocations["PlaneRefill"][3])
            local RefillDist = #(PlyCoords - RefillCoords)
            local RpEndCoords = vector3(RpLocations["PlaneEnd"][1], RpLocations["PlaneEnd"][2], RpLocations["PlaneEnd"][3])
            local RpEndDist = #(PlyCoords - RpEndCoords)
            local RpAirfieldCoords = vector3(RpLocations["AirfieldCenter"][1], RpLocations["AirfieldCenter"][2], RpLocations["AirfieldCenter"][3])
            local RpAirfieldDist = #(PlyCoords - RpAirfieldCoords)
            RpKeyDraw = false
            if (RpCounter == 1 and (RpKeyDist < 50)) then
                RpKeyDraw = true
                if(RpKeyDist < 2) then
                    IsInMarker = true
                    CurrentZone = 'rpKeys'
                end
            elseif (RpCounter == 3 and (RefillDist < 30)) then
                RpPlaneRefillDraw = true
                if(RefillDist < 7) then
                    IsInMarker = true
                    CurrentZone = 'planeRefill'
                end
            elseif (RpCounter == 6 and (RpEndDist < 30)) then
                RpPlaneEndDraw = true
                if(RpEndDist < 7) then
                    IsInMarker = true
                    CurrentZone = 'planeEnd'
                end
            end
            if (RpPlane ~= nil and RpCounter == 2 and Veh == GetHashKey(Config.RPVehicle)) then
                RpCounter = 3
                TriggerEvent('cr_breakingbad:locationblip', RpLocations["PlaneRefill"][1], RpLocations["PlaneRefill"][2], RpLocations["PlaneRefill"][3])
                ESX.ShowNotification(_U('need_refill'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                exports["LegacyFuel"]:SetFuel(RpPlane, 100)
            end
            if (RpCounter >= 2 and DoesEntityExist(RpPlane)) then -- Check if plane gets destroyed
                if (GetVehicleEngineHealth(RpPlane) <= 0) then
                    EndScenario("RP", 'vehicle_destroyed', true)
                end
                if (IsEntityInWater(RpPlane) and not GetIsVehicleEngineRunning(RpPlane)) then
                    EndScenario("RP", 'vehicle_destroyed', true)
                end
            elseif (RpCounter >= 2 and not DoesEntityExist(RpPlane)) then -- continue check from above
                EndScenario("RP", 'vehicle_destroyed', true)
            end
            if (RpCounter ~= 5 and RpAlarmTriggered and (RpAirfieldDist > 150)) then
                EndScenario("RP", 'left_grapeseed_airfield', true)
            elseif (RpCounter == 5 and RpAlarmTriggered and (RpAirfieldDist > 150)) then
                RpCounter = 6
                RpAlarmTriggered = false
                TriggerServerEvent("cr_breakingbad:killalarm", false, "Grapeseed Airfield")
                StopSound(Soundid)
            end
        end
        if GasScenario then
            local KeyCoords = vector3(GasLocations["KeyLocation"][1], GasLocations["KeyLocation"][2], GasLocations["KeyLocation"][3])
            local KeyDist = #(PlyCoords - KeyCoords)
            local DocksCenterCoords = vector3(GasLocations["DocksCenter"][1], GasLocations["DocksCenter"][2], GasLocations["DocksCenter"][3])
            local DocksDist = #(PlyCoords - DocksCenterCoords)
            local BoatDeliveryCoords = vector3(GasLocations["BoatDelivery"][1], GasLocations["BoatDelivery"][2], GasLocations["BoatDelivery"][3])
            local BoatDeliveryDist = #(PlyCoords - BoatDeliveryCoords)
            local BikeDeliveryCoords = vector3(GasLocations["BikeDelivery"][1], GasLocations["BikeDelivery"][2], GasLocations["BikeDelivery"][3])
            local BikeDeliveryDist = #(PlyCoords - BikeDeliveryCoords)
            BoatKeyDraw = false
            BoatDeliveryDraw = false
            BikeDeliveryDraw = false
            if (GasCounter == 4 and Veh == GetHashKey(Config.GasBoat)) then
                GasCounter = 5
                ESX.ShowNotification(_U('take_the_boat'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                TriggerEvent('cr_breakingbad:locationblip', GasLocations["BoatDelivery"][1], GasLocations["BoatDelivery"][2], GasLocations["BoatDelivery"][3])
                exports["LegacyFuel"]:SetFuel(GasBoat, 100)
            elseif (GasCounter == 5 and Veh == GetHashKey(Config.GasBoat) and BoatDeliveryDist < 100) then
                BoatDeliveryDraw = true
                if BoatDeliveryDist < 5 then
                    IsInMarker = true
                    CurrentZone = 'boatDelivery'
                end
            elseif (GasCounter == 6 and Veh == GetHashKey(Config.GasBike)) then
                GasCounter = 7
                ESX.Game.DeleteVehicle(GasBoat)
                ESX.ShowNotification(_U('take_the_bike'))
                TriggerEvent('cr_breakingbad:locationblip', GasLocations["BikeDelivery"][1], GasLocations["BikeDelivery"][2], GasLocations["BikeDelivery"][3])
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                exports["LegacyFuel"]:SetFuel(GasBike, 100)
            elseif (GasCounter == 7 and Veh == GetHashKey(Config.GasBike) and BikeDeliveryDist < 50) then
                BikeDeliveryDraw = true
                if BikeDeliveryDist < 5 then
                    IsInMarker = true
                    CurrentZone = 'bikeDelivery'
                end
            end
            if (GasCounter > 1 and GasCounter < 4 and (DocksDist > 150) and GasAlarmTriggered) then
                EndScenario("GAS", 'left_docks', true)
            elseif (GasCounter == 1 and (DocksDist < 150)) then
                GasCounter = 2
                TriggerEvent('cr_breakingbad:killlocationblip')
                TriggerAlarm("Docks", 0, true)
                ESX.ShowNotification(_U('docks_alarm_triggered'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            if (GasCounter == 2 and (KeyDist < 5)) then
                BoatKeyDraw = true
                if (KeyDist < 2) then
                    IsInMarker = true
                    CurrentZone = 'boatKeys'
                end
            end
            if (GasCounter >= 6 and DoesEntityExist(GasBike)) then -- Check if bike gets destroyed
                if GetVehicleEngineHealth(GasBike) <= 0 then
                    EndScenario("GAS", 'vehicle_destroyed', true)
                end
                if (IsEntityInWater(GasBike) and not GetIsVehicleEngineRunning(GasBike)) then
                    EndScenario("GAS", 'vehicle_destroyed', true)
                end
            elseif (GasCounter >= 6 and not DoesEntityExist(GasBike)) then -- continue check from above
                EndScenario("GAS", 'vehicle_destroyed', true)
            end
            if (DoesEntityExist(GasBoat) and GasCounter >= 4 and GasCounter <= 5) then -- Check if boat gets destroyed
                if GetVehicleEngineHealth(GasBoat) <= 0 then
                    EndScenario("GAS", 'vehicle_destroyed', true)
                end
            elseif (not DoesEntityExist(GasBoat) and GasCounter >= 4 and GasCounter <= 5) then -- continue boat from above
                EndScenario("GAS", 'vehicle_destroyed', true)
            end
        end
        if CookScenario then
            if (not Cooking and Veh == GetHashKey(Config.CookVehicle) and IsDriver()) then
                IsInMarker = true
                CurrentZone = 'cook'
            end
            if (Cooking and Veh ~= GetHashKey(Config.CookVehicle)) and PedOutOfVehicle ~= true then
                OutOfVehicle()
            elseif (Cooking and Veh == GetHashKey(Config.CookVehicle) and CookTime <= 72) then
                if (CookTime <= 72 and CookTime > 48) then
                    IsInMarker = true
                    CurrentZone = 'end_cook1'
                elseif (CookTime <= 48 and CookTime > 24) then
                    IsInMarker = true
                    CurrentZone = 'end_cook2'
                elseif (CookTime <= 24 and CookTime > 0) then
                    IsInMarker = true
                    CurrentZone = 'end_cook3'
                end
            end
            if DoesEntityExist(CookVehicle) then -- Check if plane gets destroyed
                if GetVehicleEngineHealth(CookVehicle) <= 0 then
                    EndScenario("COOK", 'vehicle_destroyed', true)
                end
                if IsEntityInWater(CookVehicle) and not GetIsVehicleEngineRunning(CookVehicle) then
                    EndScenario("COOK", 'vehicle_destroyed', true)
                end
            elseif not DoesEntityExist(CookVehicle) then -- continue check from above
                EndScenario("COOK", 'vehicle_destroyed', true)
            end
        end
        if Selling then
            local SaleCoords = vector3(SaleLoc[1], SaleLoc[2], SaleLoc[3])
            local SaleDist = #(PlyCoords - SaleCoords)
            SalesDraw = false
            if (SaleDist < 20) then
                SalesDraw = true
                if (SaleDist < 1) then
                    IsInMarker = true
                    CurrentZone = 'sales'
                end
            end
        end
        if (IsInMarker and not HasAlreadyEnteredMarker) or (IsInMarker and LastZone ~= CurrentZone) then
            HasAlreadyEnteredMarker = true
            LastZone = CurrentZone
            TriggerEvent('cr_breakingbad:enteredMarker', CurrentZone)
        end
        if (not IsInMarker and HasAlreadyEnteredMarker) then
            HasAlreadyEnteredMarker = false
            TriggerEvent('cr_breakingbad:leftMarker', LastZone)
        end
        if (HlScenario and Dead) or (PbScenario and Dead) or (ChemScenario and Dead) or (RpScenario and Dead) or (GasScenario and Dead) or (CookScenario and Dead) or (Selling and Dead) then
            if HlScenario then
                EndScenario("HL", 'died', true)
            elseif PbScenario then
                EndScenario("PB", 'died', true)
            elseif ChemScenario then
                EndScenario("CHEM", 'died', true)
            elseif RpScenario then
                EndScenario("RP", 'died', true)
            elseif GasScenario then
                EndScenario("GAS", 'died', true)
            elseif CookScenario then
                EndScenario("COOK", 'died', true)
            elseif Selling then
                Selling = false
                SalesDraw = false
                TriggerEvent("cr_breakingbad:killsalesblip")
            end
        end
        --print(MainWaitTime)
        Citizen.Wait(MainWaitTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        while ESX == nil do
            Citizen.Wait(50)
        end
        ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
            if Police >= Config.RequiredShowMarker then
                CopsOnline = true
            else
                CopsOnline = false
            end
        end)
        Citizen.Wait(120000)
    end
end)

-- Draw Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (HeistDraw ~= nil) and (HeistDraw == true) and (CopsOnline == true) then
            DrawMarker(21, HeistboardLocation[1], HeistboardLocation[2], HeistboardLocation[3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (HlEnterDraw ~= nil) and (HlEnterDraw == true) then
            DrawText3d(HlLocations["ElevatorIn"][1], HlLocations["ElevatorIn"][2], HlLocations["ElevatorIn"][3], _U('hlEnter_elevator'), 100)
        elseif (HlExitDraw ~= nil) and (HlExitDraw == true) then
            DrawText3d(HlLocations["ElevatorOut"][1], HlLocations["ElevatorOut"][2], HlLocations["ElevatorOut"][3], _U('hlExit_elevator'), 100)
        elseif (HlVanDraw ~= nil) and (HlVanDraw == true) then
            DrawMarker(27, HlLocations["VanEndLocation"][1], HlLocations["VanEndLocation"][2], HlLocations["VanEndLocation"][3],0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,true,0,0)
        elseif (PbrDraw ~= nil) and (PbrDraw == true) then
            DrawMarker(21, PbLocations["TheftLocation"][1], PbLocations["TheftLocation"][2], PbLocations["TheftLocation"][3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (ChemDraw ~= nil) and (ChemDraw == true) then
            DrawMarker(21, ChemLocations["TheftLocation"][1], ChemLocations["TheftLocation"][2], ChemLocations["TheftLocation"][3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (CrackDraw ~= nil) and (CrackDraw == true) then
            DrawTxt(_U('rp_safe_controls'), 0.5, 0.90, 255, 255, 255)
            DrawTxt(_U('rp_safe_controls2'), 0.5, 0.94, 255, 0, 0)
        elseif (RpKeyDraw ~= nil) and (RpKeyDraw == true) then
            DrawMarker(21, RpLocations["KeyLoc"][1], RpLocations["KeyLoc"][2], RpLocations["KeyLoc"][3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (RpPlaneRefillDraw ~= nil) and (RpPlaneRefillDraw == true) then
            DrawMarker(27, RpLocations["PlaneRefill"][1], RpLocations["PlaneRefill"][2], RpLocations["PlaneRefill"][3],0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,true,0,0)
        elseif (RpPlaneEndDraw ~= nil) and (RpPlaneEndDraw == true) then
            DrawMarker(27, RpLocations["PlaneEnd"][1], RpLocations["PlaneEnd"][2], RpLocations["PlaneEnd"][3],0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,true,0,0)
        elseif (BoatCrackDraw ~= nil) and (BoatCrackDraw == true) then
            DrawTxt(_U('gas_crack_controls'), 0.5, 0.895, 255, 255, 255)
        elseif (BoatKeyDraw ~= nil) and (BoatKeyDraw == true) then
            DrawMarker(21, GasLocations["KeyLocation"][1], GasLocations["KeyLocation"][2], GasLocations["KeyLocation"][3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (BoatDeliveryDraw ~= nil) and (BoatDeliveryDraw == true) then
            DrawMarker(27, GasLocations["BoatDelivery"][1], GasLocations["BoatDelivery"][2], GasLocations["BoatDelivery"][3],0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,false,0,true)
        elseif (BikeDeliveryDraw ~= nil) and (BikeDeliveryDraw == true) then
            DrawMarker(27, GasLocations["BikeDelivery"][1], GasLocations["BikeDelivery"][2], GasLocations["BikeDelivery"][3],0,0,0,0,0,0,7.0,7.0,7.0,255,0,0,200,0,false,0,true)
        elseif (CookDraw ~= nil) and (CookDraw == true) and (CopsOnline == true) then
            DrawMarker(27, CookLocations["Workshop"][1], CookLocations["Workshop"][2], CookLocations["Workshop"][3],0,0,0,0,0,0,5.0,5.0,5.0,255,0,0,200,0,false,0,true)
        elseif (Selling == true) and (SalesDraw ~= nil) and (SalesDraw == true) then
            DrawMarker(21, SaleLoc[1], SaleLoc[2], SaleLoc[3],0,0,0,0,0,0,0.5,0.5,0.5,255,0,0,200,0,false,0,true)
        elseif (TestDraw ~= nil) and (TestDraw == true) then
            DrawMarker(28, ChemLocations["RestrictedArea3"][1],ChemLocations["RestrictedArea3"][2],ChemLocations["RestrictedArea3"][3],0,0,0,0,0,0,2.0,2.0,2.0,255,0,0,200,0,true,0,0)
            -- drawTxt(_U('rp_safe_controls2'), 0.5, 0.94, 255, 0, 0)
        else
            Citizen.Wait(1000)
        end
    end
end)



-- Key Actions Thread
Citizen.CreateThread (function()
    while true do
        Citizen.Wait(0)
        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg, false, true, 200)
            if (IsControlJustPressed(0, 38)) then
                if CurrentAction == 'heistboard' then                    
                    OpenHeistMenu()
                    CurrentAction = nil
                elseif CurrentAction == 'hlKeys' then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "hlKeys",
                        duration = Config.HLKeys,
                        label = _U('grabbing_keys'),
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "amb@prop_human_bum_bin@base",
                            anim = "base",
                        },
                        prop = {
                            model = "prop_cs_keys_01",
                        }
                    }, function(status)
                        if not status then
                            ClearPedTasks(PlayerPedId())
                            ESX.Game.SpawnVehicleaa7b(Config.HLVehicle, vector3(HlLocations["VanSpawn"][1], HlLocations["VanSpawn"][2], HlLocations["VanSpawn"][3]), HlLocations["VanSpawn"][4], function(vehicle)
                                HlVan = vehicle
                            end)
                            ESX.ShowNotification(_U('van_in_garage'))
                            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            CurrentAction = nil
                            Citizen.Wait(1000)
                            HlCounter = 3
                            KeyId = nil
                        end
                    end)
                elseif CurrentAction == 'hlEnter' then
                    CurrentAction = nil
                    TeleportPlayer(PlayerPedId(), HlLocations["ElevatorOut"][1], HlLocations["ElevatorOut"][2], HlLocations["ElevatorOut"][3], HlLocations["ElevatorOut"][4]) -- Config Elevator In
                    if(HlCounter == 1) then
                        ESX.ShowNotification(_U('hl_key2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                        HlCounter = 2
                        SpawnHumaneKey()
                        TriggerEvent('cr_breakingbad:killlocationblip')
                        TriggerAlarm("Humane Labs", Config.HLDelay, true)
                    end
                elseif CurrentAction == 'hlExit' then
                    CurrentAction = nil
                    TeleportPlayer(PlayerPedId(), HlLocations["ElevatorIn"][1], HlLocations["ElevatorIn"][2], HlLocations["ElevatorIn"][3], HlLocations["ElevatorIn"][4]) -- Config Elevator Out
                elseif CurrentAction == 'hlVan' then
                    if GetVehiclePedIsIn(PlayerPedId()) == HlVan then
                        FreezeEntityPosition(HlVan, true)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "crush_hl_van",
                            duration = Config.HLVanCrush,
                            label = _U('crushing_van'),
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        }, function(status)
                            if not status then
                                FreezeEntityPosition(HlVan, false)
                                ClearPedTasks(PlayerPedId())
                                DeleteVehicle()
                                EndScenario("HL", 'hl_success', false)
                                CurrentAction = nil
                                TriggerServerEvent("cr_breakingbad:supplies", "hydriodicacid")
                            else
                                FreezeEntityPosition(HlVan, false)
                            end
                        end)
                    else
                        ESX.ShowNotification(_U('wrong_vehicle'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                elseif CurrentAction == 'pbRobbery' then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "rob_pillbox",
                        duration = Config.PBRobberyLength,
                        label = _U('robbing_pillbox'),
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false,
                        }
                    }, function(cancel)
                        if not cancel then
                            PbrDraw = false
                            EndScenario("PB", 'pbsuccessful_robbery', false)
                            TriggerServerEvent("cr_breakingbad:supplies", 'pseudoephedrine')
                            CurrentAction = nil
                        end
                    end)
                    PbCounter = 3
                    while PbCounter == 3 do
                        Citizen.Wait(0)
                        local ped = PlayerPedId()
                        local pedLoc = GetEntityCoords(ped)
                        if (GetDistanceBetweenCoords(pedLoc, PbLocations["TheftLocation"][1], PbLocations["TheftLocation"][2], PbLocations["TheftLocation"][3], true) > 10) then
                            TriggerEvent("mythic_progbar:client:cancel")
                            EndScenario("PB", 'pb_cancelled', true)
                        else
                            Citizen.Wait(1000)
                        end
                    end
                elseif CurrentAction == 'chemRobbery' then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "rob_chemistry",
                        duration = Config.ChemRobberyLength,
                        label = _U('robbing_chemistry'),
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false,
                        }
                    }, function(cancel)
                        if not cancel then
                            ChemDraw = false
                            EndScenario("CHEM", 'chemsuccessful_robbery', false)
                            TriggerServerEvent("cr_breakingbad:supplies", 'chemistrysupplies')
                            CurrentAction = nil
                        end
                    end)
                    ChemCounter = 3
                    while ChemCounter == 3 do
                        Citizen.Wait(0)
                        local ped = PlayerPedId()
                        local pedLoc = GetEntityCoords(ped)
                        if (GetDistanceBetweenCoords(pedLoc, ChemLocations["TheftLocation"][1], ChemLocations["TheftLocation"][2], ChemLocations["TheftLocation"][3], true) > 10) then
                            TriggerEvent("mythic_progbar:client:cancel")
                            EndScenario("CHEM", 'chem_cancelled', true)
                        else
                            Citizen.Wait(1000)
                        end
                    end
                elseif CurrentAction == 'rpKeys' then
                    if RpAlarmTriggered ~= true then
                        TriggerAlarm("Grapeseed Airfield", 0)
                        ESX.ShowNotification(_U('grapeseed_alarm_triggered'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                    --math.random(1,99),
                    CrackDraw = true
                    local res = createSafe({math.random(0,99), math.random(0,99), math.random(0,99)})
                    -- local res = exports["pd-safe"]:createSafe({math.random(0,99), math.random(0,99), math.random(0,99)})
                    if res then
                        CrackDraw = false
                        TriggerEvent('cr_breakingbad:killlocationblip')
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.Game.SpawnVehicleaa7b(Config.RPVehicle, vector3(RpLocations["PlaneSpawn"][1], RpLocations["PlaneSpawn"][2], RpLocations["PlaneSpawn"][3]), RpLocations["PlaneSpawn"][4], function(vehicle)
                            RpPlane = vehicle
                        end)
                        CurrentAction = nil
                        Citizen.Wait(1000)
                        RpCounter = 2
                    elseif res ~= true then
                        CrackDraw = false
                        ClearPedTasksImmediately(PlayerPedId())
                        RpCounter = 1
                    end 
                elseif CurrentAction == 'refillPlane' then
                    if GetVehiclePedIsIn(PlayerPedId()) == RpPlane then
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "refill_plane",
                            duration = Config.RPRefillTime,
                            label = _U('refilling_plane'),
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        }, function(status)
                            if not status then
                                RpCounter = 5
                                RpPlaneRefillDraw = false
                                TriggerEvent('cr_breakingbad:killlocationblip')
                                BlipPlaneDelivery = AddBlipForCoord(RpLocations["PlaneEnd"][1], RpLocations["PlaneEnd"][2], RpLocations["PlaneEnd"][3])
                                SetBlipSprite(BlipPlaneDelivery, 57)
                                SetBlipScale(BlipPlaneDelivery, 0.5)
                                SetBlipColour(BlipPlaneDelivery, 27)
                                SetBlipRoute(BlipPlaneDelivery, true)
                                ESX.ShowNotification(_U('delivery_location_marked'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end)
                        RpCounter = 4
                        while RpCounter == 4 do
                            Citizen.Wait(0)
                            local ped = PlayerPedId()
                            local pedLoc = GetEntityCoords(ped)
                            if(GetDistanceBetweenCoords(pedLoc, RpLocations["PlaneRefill"][1], RpLocations["PlaneRefill"][2], RpLocations["PlaneRefill"][3], true) > 7) then
                                TriggerEvent("mythic_progbar:client:cancel")
                                RpCounter = 3
                            else
                                Citizen.Wait(1000)
                            end
                        end
                    else
                        ESX.ShowNotification(_U('wrong_vehicle'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                
                elseif CurrentAction == 'crushPlane' then
                    if GetVehiclePedIsIn(PlayerPedId()) == RpPlane then
                        FreezeEntityPosition(RpPlane, true)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "crush_rp_plane",
                            duration = Config.RPPlaneCrush,
                            label = _U('crushing_plane'),
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        }, function(status)
                            if not status then
                                FreezeEntityPosition(RpPlane, false)
                                ClearPedTasks(PlayerPedId())
                                DeleteVehicle()
                                RpPlaneEndDraw = false
                                CurrentAction = nil
                                EndScenario("RP", 'rp_success')
                                TriggerServerEvent("cr_breakingbad:supplies", "redphosphorus")
                            else
                                FreezeEntityPosition(RpPlane, false)
                            end
                        end)
                    else
                        ESX.ShowNotification(_U('wrong_vehicle'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                elseif CurrentAction == 'workshop' then
                    Veh = GetVehiclePedIsIn(PlayerPedId())
                    Model = GetEntityModel(Veh)
                    if Model == GetHashKey(Config.CookVehicle) then
                        ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                            if Police >= Config.RequiredPoliceCook then
                                ESX.TriggerServerCallback('cr_breakingbad:outfitvan', function(canOutfit)
                                    if canOutfit then
                                        FreezeEntityPosition(Veh, true)
                                        TriggerEvent("mythic_progbar:client:progress", {
                                            name = "outfit_veh",
                                            duration = Config.OutfitTime,
                                            label = _U('outfit_veh'),
                                            useWhileDead = false,
                                            canCancel = true,
                                            controlDisables = {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }
                                        }, function(status)
                                            if not status then
                                                SpawnBottle('prop_gascyl_01a')
                                                FreezeEntityPosition(Veh, false)
                                                ClearPedTasks(PlayerPedId())
                                                CurrentAction = nil
                                                CookScenario = true
                                                CookVehicle = Veh
                                                Citizen.Wait(1000)
                                                GasBottle = GasBottle
                                            else
                                                FreezeEntityPosition(Veh, false)
                                            end
                                        end)
                                    else
                                        ESX.ShowNotification(_U('missing_items_outfit'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                    end
                                end)
                            else
                                ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceCook .. _U('not_enough_cops2'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end)
                    end
                elseif CurrentAction == 'begin_cook' then
                    ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                        if Police >= Config.RequiredPoliceCook then
                            ESX.TriggerServerCallback('cr_breakingbad:startcook', function(canCook)
                                if canCook then
                                    Cook()
                                    ESX.ShowNotification(_U('started_cooking'))
                                    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                else
                                    ESX.ShowNotification(_U('missing_items_cook'))
                                    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                end
                            end)
                        else
                            ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceCook .. _U('not_enough_cops2'))
                            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                        end
                    end)
                elseif CurrentAction == 'end_cook' then
                    CookCancelled = true
                    ESX.ShowNotification(_U('cook_ended'))
                    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                elseif CurrentAction == 'lye_shop' then
                    OpenLyeMenu()
                elseif CurrentAction == 'sales' then
                    ESX.TriggerServerCallback('cr_breakingbad:cansellmeth', function(canSell)
                        if canSell then
                            Chance = math.random(1, 100)
                            if Chance <= Config.SalesChance then
                                local Coords = GetEntityCoords(PlayerPedId())
                                TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', "A Civilian has reported some suspicious handoff happening here", { x = Coords['x'], y = Coords['y'], z = Coords['z'] })
                            end
                            CurrentAction = nil
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "selling_meth",
                                duration = Config.SalesDuration,
                                label = _U('selling_meth'),
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "missheistfbisetup1",
                                    anim = "unlock_loop_janitor",
                                },
                            }, function(status)
                                if not status then
                                    TriggerServerEvent('cr_breakingbad:sellmeth', SellingType)
                                    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                    TriggerEvent('cr_breakingbad:killsalesblip')
                                    Selling = false
                                    SalesDraw = false
                                    ClearPedTasks(PlayerPedId())
                                else                    
                                    ClearPedTasks(PlayerPedId())
                                end
                            end)
                        else
                            ESX.TriggerServerCallback('cr_breakingbad:getlabel', function(label)
                                ESX.ShowNotification(_U('no_product_inventory') .. label .._U('no_product_inventory2'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end, SellingType)
                            TriggerEvent('cr_breakingbad:killsalesblip')
                            Selling = false
                            SalesDraw = false
                        end
                    end, SellingType)
                elseif CurrentAction == 'boatKeys' then
                    GasCounter = 3
                    CurrentAction = nil
                    NewTabletProp()
                    StartAnim('amb@world_human_partying@female@partying_cellphone@base', 'base')
                    Citizen.Wait(1000)
                    StartDatacrack(Config.BoatKeyDifficulty)
                    -- exports["datacrack"]:Start(Config.BoatKeyDifficulty)
                    BoatCrackDraw = true
                elseif CurrentAction == 'boatDelivery' then
                    if GetVehiclePedIsIn(PlayerPedId()) == GasBoat then
                        local Coords = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', _U('police_notification_boat'), { x = Coords['x'], y = Coords['y'], z = Coords['z'] })
                        FreezeEntityPosition(GasBoat, true)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "crush_gas_boat",
                            duration = Config.GasBoatCrush,
                            label = _U('swapping_boat'),
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }
                        }, function(status)
                            if not status then
                                ClearPedTasks(PlayerPedId())
                                FreezeEntityPosition(GasBoat, false)
                                ESX.Game.SpawnVehicleaa7b(Config.GasBike, vector3(GasLocations["BikeSpawn"][1], GasLocations["BikeSpawn"][2], GasLocations["BikeSpawn"][3]), GasLocations["BikeSpawn"][4], function(vehicle)
                                    GasBike = vehicle
                                end)
                                ESX.ShowNotification(_U('grab_blazer'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                                TriggerEvent('cr_breakingbad:killlocationblip')
                                CurrentAction = nil
                                Citizen.Wait(1000)
                                GasCounter = 6
                            else
                                FreezeEntityPosition(GasBoat, false)
                            end
                        end)
                    else
                        ESX.ShowNotification(_U('wrong_vehicle'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                elseif CurrentAction == 'bikeDelivery' then
                        if GetVehiclePedIsIn(PlayerPedId()) == GasBike then
                            FreezeEntityPosition(GasBike, true)
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "crush_gas_bike",
                                duration = Config.GasBikeCrush,
                                label = _U('crush_bike'),
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }
                            }, function(status)
                                if not status then
                                    ClearPedTasks(PlayerPedId())
                                    FreezeEntityPosition(GasBike, false)
                                    TriggerEvent('cr_breakingbad:killlocationblip')
                                    CurrentAction = nil
                                    DeleteVehicle()
                                    BikeDeliveryDraw = false
                                    EndScenario("GAS", 'gas_success')
                                    TriggerServerEvent("cr_breakingbad:supplies", "hydrogenchloridegas")
                                else
                                    FreezeEntityPosition(GasBike, false)
                                end
                            end)
                        else
                            ESX.ShowNotification(_U('wrong_vehicle'))
                            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                        end
                    
                end
            end
        else
        Citizen.Wait(1000)
        end
    end
end)

local Dealer = nil

-- Create NPC Thread
Citizen.CreateThread(function()
        RequestModel(GetHashKey("s_m_y_strvend_01"))
        
        while not HasModelLoaded(GetHashKey("s_m_y_strvend_01")) do
          Wait(1)
        end
        Dealer = CreatePed(4, GetHashKey("s_m_y_strvend_01"), LyeLocation[1], LyeLocation[2], LyeLocation[3]-1, 139.93, false, true)
        SetEntityHeading(Dealer, 139.93)
        FreezeEntityPosition(Dealer, true)
        SetEntityInvincible(Dealer, true)
        SetBlockingOfNonTemporaryEvents(Dealer, true)
        TaskStartScenarioInPlace(Dealer, "WORLD_HUMAN_COP_IDLES", 0, true)
        SetModelAsNoLongerNeeded(Dealer)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if Dealer ~= nil then
            --print('RipMike')
            DeletePed(Dealer)
        end
    end
end)

-- Threaded Functions
function Cook()
    CookCancelled = false
    CookTime = 97
    Cooking = true
    local SitTime = 0
    Citizen.CreateThread(function()
        while CookTime > 0 and not CookCancelled and Cooking do
            CookTime = CookTime - 1
            if CookTime == 0 then
                FinishCook(4)
                Cooking = false
                break
            end
            ESX.ShowNotification(_U('dont_leave_vehicle'))
            ESX.ShowNotification(_U('cooktime_left') .. CookTime .. _U('cooktime_left2'))
            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            local Coords = GetEntityCoords(GetPlayerPed(-1), false)
            local CopChance = math.random(0, 100)
            local chance = 0
            if PrevPos ~= nil then
                local SitDist = #(Coords - PrevPos)
                if SitDist < 30 then
                    SitTime = SitTime + 1
                    if SitTime >= 2 and SitTime < 5 then
                        chance = Config.Chance1
                    elseif SitTime >= 5 and SitTime < 8 then
                        chance = Config.Chance2
                    elseif SitTime >= 8 then
                        chance = Config.Chance3
                    end
                    if CopChance < chance and PoliceAlerted == 0 then
                        TriggerServerEvent('esx_addons_gcphone:SendCoords', 'police', _U('police_notification_cook'), { x = Coords['x'], y = Coords['y'], z = Coords['z'] })
                        PoliceAlerted = 1
                    end
                else
                    PoliceAlerted = 0
                    SitTime = 0
                end
            end
            PrevPos = Coords
                    
            Citizen.Wait(60000)
        end
        if CookCancelled then
            if CookTime <= 96 and CookTime > 72 then
                FinishCook(0)
                Cooking = false
            elseif CookTime <= 72 and CookTime > 48 then
                FinishCook(1)
                Cooking = false
            elseif CookTime <= 48 and CookTime > 24 then
                FinishCook(2)
                Cooking = false
            elseif CookTime <= 24 and CookTime > 0 then
                FinishCook(3)
                Cooking = false
            end
        end
    end)
end

function OutOfVehicle()
    OutTimer = 3
    PedOutOfVehicle = true
    Citizen.CreateThread(function()
        while OutTimer > 0 and not CookCancelled and Cooking and PedOutOfVehicle do
            if Cooking and not CookCancelled and (GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == GetHashKey(Config.CookVehicle)) then
                ESX.ShowNotification(_U('back_in_vehicle'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                PedOutOfVehicle = false
                break
            end
            OutTimer = OutTimer - 1
            if OutTimer == 0 then
                EndScenario("COOK", 'out_of_vehicle', true)
                PedOutOfVehicle = false
                break
            end
            ESX.ShowNotification(_U('left_vehicle'))
            ESX.ShowNotification(_U('left_timer') .. OutTimer .. _U('left_timer2'))
            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            Citizen.Wait(60000)
        end
    end)
end

-- Functions
function OpenHeistMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heist_menu', {
        title = _U('menu_title'),
        align = 'bottom-right',
        elements = {
            {label = _U('hlScenario'), value = 'hlScenario'},
            {label = _U('redphosphorus'), value = 'redphosphorus'},
            {label = _U('pbRobbery'), value = 'pbRobbery'},
            {label = _U('chemRobbery'), value = 'chemRobbery'},
            {label = _U('gasRobbery'), value = 'gasRobbery'},
            {label = _U('lye'), value = 'lye'},
            {label = _U('finale'), value = 'finale'}
        }
    }, function (data, menu)
        if isBusy then return end
    
        if data.current.value == 'hlScenario' then
            if not HlScenario then
                ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                    if Police >= Config.RequiredPoliceHL then
                        ESX.TriggerServerCallback('cr_breakingbad:startscenario', function(startHL)
                            if startHL == 'startedHL' then
                                ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
                                    if callback then
                                        HlScenario = true
                                        TriggerEvent('cr_breakingbad:locationblip', HlLocations['Garage1'][1], HlLocations['Garage1'][2], HlLocations['Garage1'][3])
                                        ESX.ShowNotification(_U('started_hlscenario'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)                                        
                                    end
                                end, 'Humane Labs')
                            else
                                ESX.ShowNotification(_U('hlscenario_not_long_enough'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end, "Humane Labs")
                    else
                        ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceHL .. _U('not_enough_cops2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end)
            else
                ESX.ShowNotification(_U('hlscenario_already_started'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'redphosphorus' then
            if not RpScenario then
                ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                    if Police >= Config.RequiredPoliceRP then
                        ESX.TriggerServerCallback('cr_breakingbad:startscenario', function(startRP)
                            if startRP == 'startedRP' then
                                ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
                                    if callback then
                                        RpScenario = true
                                        TriggerEvent('cr_breakingbad:locationblip', RpLocations['KeyLoc'][1], RpLocations['KeyLoc'][2], RpLocations['KeyLoc'][3])
                                        ESX.ShowNotification(_U('started_redphosphorus'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)                                     
                                    end
                                end, 'McKenzie Airfield')
                            else
                                ESX.ShowNotification(_U('redphosphorus_not_long_enough'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end, "Red Phosphorus")
                    else
                        ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceRP .. _U('not_enough_cops2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end)
            else
                ESX.ShowNotification(_U('redphosphorus_already_started'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'pbRobbery' then
            if not PbScenario then
                ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                    if Police >= Config.RequiredPolicePB then
                        ESX.TriggerServerCallback('cr_breakingbad:startscenario', function(startPB)
                            if startPB == 'startedPB' then
                                ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
                                    if callback then
                                        PbScenario = true
                                        TriggerEvent('cr_breakingbad:locationblip', PbLocations['RestrictedArea'][1], PbLocations['RestrictedArea'][2], PbLocations['RestrictedArea'][3])
                                        ESX.ShowNotification(_U('started_pbscenario'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)                                   
                                    end
                                end, 'Pillbox Hospital')
                            else
                                ESX.ShowNotification(_U('pbscenario_not_long_enough'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end, "Pillbox Medical")
                    else
                        ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPolicePB .. _U('not_enough_cops2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end)
            else
                ESX.ShowNotification(_U('pb_already_started'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'chemRobbery' then
            if not ChemScenario then
                ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                    if Police >= Config.RequiredPoliceChem then
                        ESX.TriggerServerCallback('cr_breakingbad:startscenario', function(startChem)
                            if startChem == 'startedChem' then
                                ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
                                    if callback then
                                        ChemScenario = true
                                        TriggerEvent('cr_breakingbad:locationblip', ChemLocations['RestrictedArea'][1], ChemLocations['RestrictedArea'][2], ChemLocations['RestrictedArea'][3])
                                        ESX.ShowNotification(_U('started_chemscenario'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)                               
                                    end
                                end, 'Ace Liquor')
                            else
                                ESX.ShowNotification(_U('chemscenario_not_long_enough'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end, "Chemistry")
                    else
                        ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceChen .. _U('not_enough_cops2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end)
            else
                ESX.ShowNotification(_U('chem_already_started'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'gasRobbery' then
            if not GasScenario then
                ESX.TriggerServerCallback('cr_breakingbad:countpolice', function(Police)
                    if Police >= Config.RequiredPoliceGas then
                        ESX.TriggerServerCallback('cr_breakingbad:startscenario', function(startGas)
                            if startGas == 'startedGas' then
                                ESX.TriggerServerCallback('CR_Misc:CanRobGCD', function(callback)
                                    if callback then
                                        GasScenario = true
                                        GasCounter = 1
                                        TriggerEvent('cr_breakingbad:locationblip', GasLocations['DocksCenter'][1], GasLocations['DocksCenter'][2], GasLocations['DocksCenter'][3])
                                        ESX.ShowNotification(_U('started_gas'))
                                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)                              
                                    end
                                end, 'Docks')
                            else
                                ESX.ShowNotification(_U('gas_not_long_enough'))
                                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                            end
                        end, "Gas")
                    else
                        ESX.ShowNotification(_U('not_enough_cops') .. Config.RequiredPoliceGas .. _U('not_enough_cops2'))
                        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
                    end
                end)
            else
                ESX.ShowNotification(_U('gas_already_started'))
                PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            end
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'lye' then
            ESX.ShowNotification(_U('lye_msg'))
            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            menu.close()
            CurrentAction = 'heistboard'
        end
        if data.current.value == 'finale' then
            ESX.ShowNotification(_U('finale_msg'))
            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
            menu.close()
            CurrentAction = 'heistboard'
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'heistboard'
    end)
end

function OpenLyeMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lye_menu', {
        title = _U('lye_menu'),
        align = 'bottom-right',
        elements = {
            {label = _U('buy_lye') .. '<span style="color:green;">' .. Config.LyeCost .. '</span>' .. _U('buy_lye2'), value = 'buyLye'},
        }
    }, function (data, menu)
        if isBusy then return end
        if data.current.value == 'buyLye' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'buy_lye_amount', {
                title = _U('lye_amount')
            }, function(data2, menu2)
                local amount = tonumber(data2.value)

                if amount == nil then
                    ESX.ShowNotification(_U('invalid_amount'))
                else
                    menu2.close()
                    TriggerServerEvent('cr_breakingbad:buylye', amount)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
            menu.close()
            CurrentAction = 'lye_shop'
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'lye_shop'
    end)
end

function SpawnHumaneKey()
    -- When an event is triggered (ie: walking through one of the 2 entrances)
    -- spawn a key at a location determined in an array of possible spots.
    -- Then spawn the Humane Van (Boxville3)
    KeyId = math.random(#KeySpawns)
    --KeyId = 1 -- temporary
    --print("Spawned Key ", KeyId, " / ", #KeySpawns)
end

function TriggerAlarm(location, delay, sound)
    -- Trigger an alarm for police, giving the brief location
    Citizen.Wait(delay)
    if location == "Humane Labs" then
        HlAlarmTriggered = true
        TriggerServerEvent("cr_breakingbad:alarm", location, HlLocations["Garage1"][1], HlLocations["Garage1"][2], HlLocations["Garage1"][3])
        if delay <= 0 then
            ESX.ShowNotification(_U('hl_key'))
            PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
        end
        if sound then
            PlaySoundFromCoord(Soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", HlLocations["HLCenter"][1], HlLocations["HLCenter"][2], HlLocations["HLCenter"][3], 0, 0, 150, 0)
        end
    elseif location == "Pillbox Medical" then
        PbAlarmTriggered = true
        TriggerServerEvent("cr_breakingbad:alarm", location, PbLocations["RestrictedArea"][1], PbLocations["RestrictedArea"][2], PbLocations["RestrictedArea"][3])
        if sound then
            PlaySoundFromCoord(Soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", PbLocations["RestrictedArea"][1], PbLocations["RestrictedArea"][2], PbLocations["RestrictedArea"][3], 0, 0, 150, 0)
        end
    elseif location == "Ace Liquor" then
        ChemAlarmTriggered = true
        TriggerServerEvent("cr_breakingbad:alarm", location, ChemLocations["RestrictedArea"][1], ChemLocations["RestrictedArea"][2], ChemLocations["RestrictedArea"][3])
        if sound then
            PlaySoundFromCoord(Soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", ChemLocations["RestrictedArea"][1], ChemLocations["RestrictedArea"][2], ChemLocations["RestrictedArea"][3], 0, 0, 150, 0)
        end
    elseif location == "Grapeseed Airfield" then
        RpAlarmTriggered = true
        TriggerServerEvent("cr_breakingbad:alarm", location, RpLocations["KeyLoc"][1], RpLocations["KeyLoc"][2], RpLocations["KeyLoc"][3])
        if sound then
            PlaySoundFromCoord(Soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", RpLocations["KeyLoc"][1], RpLocations["KeyLoc"][2], RpLocations["KeyLoc"][3], 0, 0, 150, 0)
        end
    elseif location == "Docks" then
        GasAlarmTriggered = true
        TriggerServerEvent("cr_breakingbad:alarm", location, GasLocations["DocksCenter"][1], GasLocations["DocksCenter"][2], GasLocations["DocksCenter"][3])
        if sound then
            PlaySoundFromCoord(Soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", GasLocations["DocksCenter"][1], GasLocations["DocksCenter"][2], GasLocations["DocksCenter"][3], 0, 0, 150, 0)
        end
    end
end

function EndScenario(scenario, message, Failed)
    if scenario == "HL" then
        if HlAlarmTriggered and Failed then
            HlAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", true, "Humane Labs")
            StopSound(Soundid)
        elseif HlAlarmTriggered and not Failed then
            HlAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", false, "Humane Labs")
            StopSound(Soundid)
        end
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
        if HlVan ~= nil then
            ESX.Game.DeleteVehicle(HlVan)
        end
        HlVan = nil
        HlCounter = 1
        HlScenario = false
        HlVanDraw = false
        HlEnterDraw = nil
        HlExitDraw = nil
        HlVanDraw = nil
        TriggerEvent('cr_breakingbad:killlocationblip')
    elseif scenario == "PB" then
        PbScenario = false
        PbCounter = 1
        PbrDraw = nil
        TriggerEvent('cr_breakingbad:killlocationblip')
        if PbAlarmTriggered and Failed then
            PbAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", true, "Pillbox Medical")
            StopSound(Soundid)
        elseif PbAlarmTriggered and not Failed then
            PbAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", false, "Pillbox Medical")
            StopSound(Soundid)
        end
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    elseif scenario == "CHEM" then
        if ChemAlarmTriggered and Failed then
            ChemAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", true, "Ace Liquor")
            StopSound(Soundid)
        elseif ChemAlarmTriggered and not Failed then
            ChemAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", false, "Ace Liquor")
            StopSound(Soundid)
        end
        ChemScenario = false
        ChemCounter = 1
        ChemDraw = nil
        TriggerEvent('cr_breakingbad:killlocationblip')
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    elseif scenario == "RP" then
        if RpAlarmTriggered and Failed then
            RpAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", true, "Grapeseed Airfield")
            StopSound(Soundid)
        elseif RpAlarmTriggered and not Failed then
            RpAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", false, "Grapeseed Airfield")
            StopSound(Soundid)
        end
        if RpPlane ~= nil then
            ESX.Game.DeleteVehicle(RpPlane)
        end
        RpPlane = nil
        RpCounter = 1
        RpScenario = false
        CrackDraw = nil
        RPKeyDraw = nil
        RpPlaneRefillDraw = false
        RpPlaneEndDraw = false
        TriggerEvent('cr_breakingbad:killlocationblip')
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
        RemoveBlip(BlipPlaneDelivery)
    elseif scenario == "GAS" then
        if GasAlarmTriggered and Failed then
            GasAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", true, "Docks")
            StopSound(Soundid)
        elseif GasAlarmTriggered and not Failed then
            GasAlarmTriggered = false
            TriggerServerEvent("cr_breakingbad:killalarm", false, "Docks")
            StopSound(Soundid)
        end
        if GasBike ~= nil then
            ESX.Game.DeleteVehicle(GasBike)
        end
        if GasBoat ~= nil then
            ESX.Game.DeleteVehicle(GasBoat)
        end
        GasScenario = false
        GasCounter = 0
        BoatCrackDraw = nil
        BoatKeyDraw = nil
        BoatDeliveryDraw = nil
        BikeDeliveryDraw = nil
        TriggerEvent('cr_breakingbad:killlocationblip')
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    elseif scenario == "COOK" then
        DeleteObject(GasBottle)
        CookScenario = false
        Cooking = false
        CookCancelled = false
        PoliceAlerted = 0
        ESX.ShowNotification(_U(message))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    end
end

function FinishCook(quality)
    DeleteObject(GasBottle)
    CookCancelled = false
    CookTime = 0
    CookScenario = false
    PoliceAlerted = 0
    if quality == 1 then
        TriggerServerEvent("cr_breakingbad:supplies", "meth1")
    elseif quality == 2 then
        TriggerServerEvent("cr_breakingbad:supplies", "meth2")
    elseif quality == 3 then
        TriggerServerEvent("cr_breakingbad:supplies", "meth3")
    elseif quality == 4 then
        TriggerServerEvent("cr_breakingbad:supplies", "meth4")
    end

end

function SpawnBottle(prop)
    local player = GetPlayerPed(-1)
    local bottlehash = GetHashKey(prop)
    Citizen.CreateThread(function() 
        while not HasModelLoaded(bottlehash) do
            RequestModel(bottlehash)
            Citizen.Wait(1)
        end
        local coords = GetEntityCoords(player)
        Obj = CreateObject(bottlehash, coords.x, coords.y, coords.z, true, false, true)
        GasBottle = Obj
        AttachEntityToEntity(Obj, GetVehiclePedIsIn(PlayerPedId(), false), 0, 0.7, -3.6, 0.43, 0.0, 0.0, 180.0, true, true, true, true, 0, true)
        SetModelAsNoLongerNeeded(Obj)
        --SetEntityCollision(newVeh, false, false)
        --SetVehicleDoorsLocked(newVeh, 2)
        --SetEntityAsMissionEntity(newVeh, true, true)
    end)
end

function CreateNPC(hash)
    if not Dealer then
        ClearAreaOfPeds(NPC.x, NPC.y, NPC.z, 2, 1)
        Citizen.Wait(300)
        Dealer = CreatePed(0, hash , NPC.x,NPC.y,NPC.z - 1, NPC.rotation, NPC.NetworkSync)
        FreezeEntityPosition(Dealer, true)
        SetEntityInvincible(Dealer, true)
        SetBlockingOfNonTemporaryEvents(Dealer, true)
        TaskStartScenarioInPlace(Dealer, "WORLD_HUMAN_COP_IDLES", 0, true)
        --print(Dealer)
    end
end

function TeleportPlayer(entity,x,y,z,h)
    DoScreenFadeOut(500)
    Citizen.Wait(750)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(entity) do
      RequestCollisionAtCoord(x, y, z)
      Citizen.Wait(0)
    end
    Citizen.Wait(500)
    SetEntityCoords(entity, x, y, z)
    SetEntityHeading(entity, h)
    DoScreenFadeIn(500)
  end

function DrawText3d(x,y,z, text, alpha)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
      
    if onScreen then
        SetTextScale(0.5, 0.5)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, alpha)
        SetTextDropshadow(0, 0, 0, 0, alpha)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
        SetTextFont(4)
    end
end

function DrawTxt(text, x, y, r, g, b)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.4, 0.4)
    SetTextColour(r, g, b, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function DeleteVehicle()
    if IsDriver() then
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            ESX.Game.DeleteVehicle(vehicle)
        end
        ESX.ShowNotification(_U('vehicle_deleted'))
    end
end

function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

function StartAnim(dictionary,animation)
    RequestAnimDict(dictionary)
    while not HasAnimDictLoaded(dictionary) do Wait(10) end
    TaskPlayAnim(PlayerPedId(), dictionary, animation, 1.5, 1.5, -1, 16, 0, 0, 0, 0)
end

function NewTabletProp()
    DeleteTablet()
    TabletHash = GetHashKey('prop_cs_tablet')
    Citizen.CreateThread(function()
        while not HasModelLoaded(TabletHash) do
            RequestModel(TabletHash)
            Citizen.Wait(1) 
        end
    end)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    TabletProp = CreateObject(TabletHash, coords.x, coords.y, coords.z, 1, 1, 0)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
    AttachEntityToEntity(TabletProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetModelAsNoLongerNeeded(TabletProp)
end

function DeleteTablet ()
    if TabletProp ~= 0 then
        TabletProp = 0
    end
end

------- EVENTS -------

AddEventHandler('cr_breakingbad:enteredMarker', function(Zone)
    --print('Entered Marker Event for: ' ,Zone)
    if Zone == 'heistboard' then
        if CopsOnline then
            CurrentAction = 'heistboard'
            CurrentActionMsg = _U('open_heist_menu')
        end
    end
    if Zone == 'hlGarage' then
        TriggerEvent('cr_breakingbad:killlocationblip')
        TriggerAlarm("Humane Labs", 0, true)
        HlCounter = 2
        SpawnHumaneKey()
    end
    if Zone == 'hlKeys' then
        CurrentAction = 'hlKeys'
        CurrentActionMsg = _U('hlKeys')
    end
    if Zone == 'hlEnter' then
        CurrentAction = 'hlEnter'
        CurrentActionMsg = _U('hlEnter_elevator')
    end
    if Zone == 'hlExit' then
        CurrentAction = 'hlExit'
        CurrentActionMsg = _U('hlExit_elevator')
    end
    if Zone =='hlVan' then
        CurrentAction = 'hlVan'
        CurrentActionMsg = _U('crush_hl_van')
    end
    if Zone == 'pbRobbery' then
        CurrentAction = 'pbRobbery'
        CurrentActionMsg = _U('robPseudoephedrine')
    end
    if Zone == "pbRestrictedArea" then
        TriggerEvent('cr_breakingbad:killlocationblip')
        TriggerAlarm("Pillbox Medical", 0, true)
        PbCounter = 2
    end
    if Zone == 'chemRobbery' then
        CurrentAction = 'chemRobbery'
        CurrentActionMsg = _U('robChemistry')
    end
    if Zone == "chemRestrictedArea" then
        TriggerEvent('cr_breakingbad:killlocationblip')
        TriggerAlarm("Ace Liquor", 0, true)
        ChemCounter = 2
    end
    if Zone == "rpKeys" then
        CurrentAction = 'rpKeys'
        CurrentActionMsg = _U('open_key_box')
    end
    if Zone == "planeRefill" then
        CurrentAction = 'refillPlane'
        CurrentActionMsg = _U('refill_plane')
    end
    if Zone == "planeEnd" then
        CurrentAction = 'crushPlane'
        CurrentActionMsg =_U('crush_plane')
    end
    if Zone == "workshop" then
        if CopsOnline then
            CurrentAction = 'workshop'
            CurrentActionMsg = _U('workshop')
        end
    end
    if Zone == "cook" then
        CurrentAction = 'begin_cook'
        CurrentActionMsg = _U('begin_cook')
    end
    if Zone == "end_cook1" then
        CurrentAction = 'end_cook'
        CurrentActionMsg = _U('end_cook1')
    end
    if Zone == "end_cook2" then
        CurrentAction = 'end_cook'
        CurrentActionMsg = _U('end_cook2')
    end
    if Zone == "end_cook3" then
        CurrentAction = 'end_cook'
        CurrentActionMsg = _U('end_cook3')
    end
    if Zone == "lye_shop" then
        CurrentAction = 'lye_shop'
        CurrentActionMsg = _U('lye_shop')
    end
    if Zone == "sales" then
        CurrentAction ='sales'
        CurrentActionMsg = _U('sales')
    end
    if Zone == "boatKeys" then
        CurrentAction = 'boatKeys'
        CurrentActionMsg = _U('boatKeys')
    end
    if Zone == "boatDelivery" then
        CurrentAction = 'boatDelivery'
        CurrentActionMsg = _U('boatDelivery')
    end
    if Zone == "bikeDelivery" then
        CurrentAction = 'bikeDelivery'
        CurrentActionMsg = _U('bikeDelivery')
    end
end)

AddEventHandler('cr_breakingbad:leftMarker', function(zone)
    --print('Left Marker Event for: ' ,zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('cr_breakingbad:locationblip')
AddEventHandler('cr_breakingbad:locationblip', function(x,y,z)
    Locationblip = AddBlipForCoord(x, y, z)
    SetBlipSprite(Locationblip, 1)
    SetBlipScale(Locationblip, 1.0)
    SetBlipColour(Locationblip, 43)
    SetBlipRoute(Locationblip, true)
end)

RegisterNetEvent('cr_breakingbad:killlocationblip')
AddEventHandler('cr_breakingbad:killlocationblip', function()
    RemoveBlip(Locationblip)
end)

RegisterNetEvent('cr_breakingbad:salesblip')
AddEventHandler('cr_breakingbad:salesblip', function(x,y,z)
    SalesBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(SalesBlip, 1)
    SetBlipScale(SalesBlip, 1.0)
    SetBlipColour(SalesBlip, 43)
    SetBlipRoute(SalesBlip, true)
end)

RegisterNetEvent('cr_breakingbad:killsalesblip')
AddEventHandler('cr_breakingbad:killsalesblip', function()
    RemoveBlip(SalesBlip)
end)

RegisterNetEvent('cr_breakingbad:setrobblip')
AddEventHandler('cr_breakingbad:setrobblip', function(x, y, z, AlarmId)
    RobBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(RobBlip , 161)
    SetBlipScale(RobBlip , 2.0)
    SetBlipColour(RobBlip, 3)
    PulseBlip(RobBlip)
    Blips[AlarmId] = RobBlip
    TriggerEvent('InteractSound_CL:PlayOnOne', 'robbery', 0.2)
end)

RegisterNetEvent('cr_breakingbad:killrobblip')
AddEventHandler('cr_breakingbad:killrobblip', function(KillAlarmId)
    RemoveBlip(Blips[KillAlarmId])
end)


RegisterNetEvent('cr_breakingbad:findsales')
AddEventHandler('cr_breakingbad:findsales', function(type)
    if not Selling then
        SaleId = math.random(#SalesLocations)
        SaleLoc = SalesLocations[SaleId]
        Selling = true
        SellingType = type
        TriggerEvent('cr_breakingbad:salesblip', SaleLoc[1], SaleLoc[2], SaleLoc[3])
    elseif Selling and SellingType ~= type then
        ESX.TriggerServerCallback('cr_breakingbad:getlabel', function(label)
            ESX.ShowNotification(_U('already_selling') .. label)
        end, SellingType)
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
        TriggerEvent('cr_breakingbad:killsalesblip')
        Selling = false
        SalesDraw = false
    else
        ESX.TriggerServerCallback('cr_breakingbad:getlabel', function(label)
            ESX.ShowNotification(_U('check_map') .. label .. _U('check_map2'))
        end, SellingType)
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
    end
end)

RegisterNetEvent('cr_breakingbad:notification')
AddEventHandler('cr_breakingbad:notification', function(Notification)
    ESX.ShowNotification(_U(Notification))
    PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
end)

AddEventHandler("datacrack", function(Output)
    if Output then
        ClearPedTasks(PlayerPedId())
        ESX.Game.SpawnVehicleaa7b(Config.GasBoat, vector3(GasLocations["BoatSpawn"][1], GasLocations["BoatSpawn"][2], GasLocations["BoatSpawn"][3]), GasLocations["BoatSpawn"][4], function(vehicle)
            GasBoat = vehicle
        end)
        BoatCrackDraw = false
        ESX.ShowNotification(_U('boat_spawned'))
        PlaySoundFrontend(-1, "COLLECTED", "HUD_AWARDS", 1)
        DeleteObject(TabletProp)
        TriggerServerEvent("cr_breakingbad:killalarm", false, "Docks")
        GasAlarmTriggered = false
        StopSound(Soundid)
        Citizen.Wait(1000)
        GasCounter = 4
    elseif not Output then
        ClearPedTasks(PlayerPedId())
        GasCounter = 2
        BoatCrackDraw = false
        DeleteObject(TabletProp)
    end
end)