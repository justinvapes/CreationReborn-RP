fx_version 'adamant'

game 'gta5'

dependencies {
	'es_extended',
	'ft_libs'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'esx_jb_eden_garage2_sv.lua'
}

client_scripts {
	'config.lua',
	'esx_jb_eden_garage2_cl.lua'
}
