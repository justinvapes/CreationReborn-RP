fx_version 'adamant'

game 'gta5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    'client/html/sounds/detector.ogg',
	'client/html/sounds/Unlock.ogg',
	'client/html/sounds/Lock.ogg',
	'client/html/sounds/off.ogg',
    'client/html/sounds/Handcuff.ogg',
	'client/html/sounds/Keys.ogg',
	'client/html/sounds/Defib.ogg',
	'client/html/sounds/bellynoises.ogg',
	'client/html/sounds/drinking.ogg',
	'client/html/sounds/eating.ogg',
	'client/html/sounds/EnterKey.ogg',	
	'client/html/sounds/seatbelton.ogg',	
	'client/html/sounds/seatbeltoff.ogg',	
	'client/html/sounds/seatbeltalarm.ogg',	
	'client/html/sounds/lockpick.ogg',	
	'client/html/sounds/*.ogg',
	'client/html/sounds/door.ogg',
	'client/html/sounds/robbery.ogg',
})
