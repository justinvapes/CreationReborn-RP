fx_version 'cerulean'

author 'xElementzx'
description 'CR Misc'
game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'client/client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/en.lua',
    'server/server.lua',
}

exports {
    'isCrouching',
}
