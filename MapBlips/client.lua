-- local fightclub = {
-- 	{ ['x'] = 928.8,   ['y'] = -1786.74,   ['z'] = 30.66}	
-- }
local comedyclub = {
	{ ['x'] = -430.08,   ['y'] = 261.24,   ['z'] = 82.03}	
}
-- local courthouse = {
-- 	{ ['x'] = 233.06,   ['y'] = -410.65,   ['z'] = 47.11}	
-- }
local laundromat = {
	{ ['x'] = 244.56, ['y'] = 373.84, ['z'] = 105.75}	
}
local nightclub = {
	{ ['x'] = 355.32, ['y'] = 302.26, ['z'] = 29.269}	
}
local PaleRiders = {
	{ ['x'] = 982.35, ['y'] = -103.60, ['z'] = 74.85}	
}
local Bahama = {
	{ ['x'] = 309.69, ['y'] = -906.92, ['z'] = 74.85}	
}
local DarkMart = {
	{ ['x'] = -210.58, ['y'] = -1606.93, ['z'] = 38.07}	
}
local casino = {
	{ ['x'] = 930.09, ['y'] = 41.63, ['z'] = 80.10}	
}
local WeedSales = {
	{ ['x'] = -2587.93, ['y'] = 1911.08, ['z'] = 167.50}	
}
local Pawnshops = {
	{ ['x'] = 245.64, ['y'] = -264.64, ['z'] = 54.04}	
}
local YouTool = {
	{ ['x'] = 2741.02, ['y'] = 3463.25, ['z'] = 55.67}	
}
-- local Pharmacy = {
-- 	{ ['x'] = 318.35, ['y'] = -1078.30, ['z'] = 28.48}	
-- }

-- Citizen.CreateThread(function()
-- 	while not NetworkIsPlayerActive(PlayerId()) do
-- 		Citizen.Wait(0)
-- 	end
	
-- 	for i = 1, #Pharmacy, 1 do
-- 		local Blip13 = AddBlipForCoord(Pharmacy[i].x, Pharmacy[i].y, Pharmacy[i].z)
-- 		SetBlipAsShortRange(Blip13, true)
-- 		SetBlipSprite(Blip13, 403) 
-- 		SetBlipColour(Blip13, 1) 
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString("Pharmacy")
-- 		EndTextCommandSetBlipName(Blip13)
-- 	end
-- end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #YouTool, 1 do
		local Blip12 = AddBlipForCoord(YouTool[i].x, YouTool[i].y, YouTool[i].z)
		SetBlipAsShortRange(Blip12, true)
		SetBlipSprite(Blip12, 79) 
		SetBlipColour(Blip12, 27) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("YouTool")
		EndTextCommandSetBlipName(Blip12)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Pawnshops, 1 do
		local Blip11 = AddBlipForCoord(Pawnshops[i].x, Pawnshops[i].y, Pawnshops[i].z)
		SetBlipAsShortRange(Blip11, true)
		SetBlipSprite(Blip11, 267) 
		SetBlipColour(Blip11, 3) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Pawnshop")
		EndTextCommandSetBlipName(Blip11)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #WeedSales, 1 do
		local Blip10 = AddBlipForCoord(WeedSales[i].x, WeedSales[i].y, WeedSales[i].z)
		SetBlipAsShortRange(Blip10, true)
		SetBlipSprite(Blip10, 140) 
		SetBlipColour(Blip10, 2) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Weed Sales")
		EndTextCommandSetBlipName(Blip10)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #casino, 1 do
		local Blip9 = AddBlipForCoord(casino[i].x, casino[i].y, casino[i].z)
		SetBlipAsShortRange(Blip9, true)
		SetBlipSprite(Blip9, 431) 
		SetBlipColour(Blip9, 4) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Casino")
		EndTextCommandSetBlipName(Blip9)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #DarkMart, 1 do
		local Blip8 = AddBlipForCoord(DarkMart[i].x, DarkMart[i].y, DarkMart[i].z)
		SetBlipAsShortRange(Blip8, true)
		SetBlipSprite(Blip8, 84) 
		SetBlipColour(Blip8, 4) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dark Mart")
		EndTextCommandSetBlipName(Blip8)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #Bahama, 1 do
		local Blip7 = AddBlipForCoord(Bahama[i].x, Bahama[i].y, Bahama[i].z)
		SetBlipAsShortRange(Blip7, true)
		SetBlipSprite(Blip7, 93) 
		SetBlipColour(Blip7, 8) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bahama Mamas Central")
		EndTextCommandSetBlipName(Blip7)
	end
end)


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #PaleRiders, 1 do
		local Blip6 = AddBlipForCoord(PaleRiders[i].x, PaleRiders[i].y, PaleRiders[i].z)
		SetBlipAsShortRange(Blip6, true)
		SetBlipSprite(Blip6, 226) 
		SetBlipColour(Blip6, 38) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Free Clubhouse")
		EndTextCommandSetBlipName(Blip6)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #nightclub, 1 do
		local Blip5 = AddBlipForCoord(nightclub[i].x, nightclub[i].y, nightclub[i].z)
		SetBlipAsShortRange(Blip5, true)
		SetBlipSprite(Blip5, 304) 
		SetBlipColour(Blip5, 46) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Nightclub")
		EndTextCommandSetBlipName(Blip5)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #comedyclub, 1 do
		local Blip4 = AddBlipForCoord(comedyclub[i].x, comedyclub[i].y, comedyclub[i].z)
		SetBlipAsShortRange(Blip4, true)
		SetBlipSprite(Blip4, 102) 
		SetBlipColour(Blip4, 60) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Split Sides Comedy Club")
		EndTextCommandSetBlipName(Blip4)
	end
end)

-- Citizen.CreateThread(function()
-- 	while not NetworkIsPlayerActive(PlayerId()) do
-- 		Citizen.Wait(0)
-- 	end
	
-- 	for i = 1, #fightclub, 1 do
-- 		local Blip3 = AddBlipForCoord(fightclub[i].x, fightclub[i].y, fightclub[i].z)
-- 		SetBlipAsShortRange(Blip3, true)
-- 		SetBlipSprite(Blip3, 311) 
-- 		SetBlipColour(Blip3, 49) 
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString("Fightclub")
-- 		EndTextCommandSetBlipName(Blip3)
-- 	end
-- end)


-- Citizen.CreateThread(function()
-- 	while not NetworkIsPlayerActive(PlayerId()) do
-- 		Citizen.Wait(0)
-- 	end
	
-- 	for i = 1, #courthouse, 1 do
-- 		local Blip2 = AddBlipForCoord(courthouse[i].x, courthouse[i].y, courthouse[i].z)
-- 		SetBlipAsShortRange(Blip2, true)
-- 		SetBlipSprite(Blip2, 188) 
-- 		SetBlipColour(Blip2, 68) 
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString("Court")
-- 		EndTextCommandSetBlipName(Blip2)
-- 	end
-- end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	for i = 1, #laundromat, 1 do
		local Blip1 = AddBlipForCoord(laundromat[i].x, laundromat[i].y, laundromat[i].z)
		SetBlipAsShortRange(Blip1, true)
		SetBlipSprite(Blip1, 108) 
		SetBlipColour(Blip1, 59) 
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Laundromat")
		EndTextCommandSetBlipName(Blip1)
	end
end)