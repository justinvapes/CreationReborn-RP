fx_version 'cerulean'
game 'gta5'

description 'Khaos Robbery'

version '1.1.0'

client_scripts {
	'config.lua',
	'client/cl_main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/sv_main.lua'
}

dependency {
	'es_extended',
	'esx_society',
	'esx_billing'
}