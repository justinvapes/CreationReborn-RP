fx_version 'adamant'

game 'gta5'

client_scripts {
	"config.lua",
	"client/functions.lua",
	"client/instance.lua",
	"client/main.lua"
}

server_scripts {
	"@async/async.lua",
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/main.lua",
	"server/functions.lua",
	"server/database.lua"
}