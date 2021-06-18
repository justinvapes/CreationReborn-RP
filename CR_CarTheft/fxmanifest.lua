fx_version 'cerulean'
game 'gta5'

author 'JustDelta'
description 'Car Theft for Creation Reborn'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua',
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua'
}