fx_version 'adamant'

game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'main.lua'
}

dependencies {
	'es_extended'
}
