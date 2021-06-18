fx_version 'adamant'

game 'gta5'

server_scripts {
	"@async/async.lua",
	"@mysql-async/lib/MySQL.lua",
	"@es_extended/locale.lua",
	"config.lua",
	"server/main.lua",
	"server/functions.lua",
	"server/database.lua"
}

client_scripts {
    "@es_extended/locale.lua",
	"config.lua",
	"client/functions.lua",
	"client/instance.lua",
	"client/main.lua"
}

dependencies {
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore'
}