fx_version 'adamant'

game 'gta5'

-- server scripts
server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server/main.lua",
}

-- client scripts
client_scripts {
	"client/main.lua",
}