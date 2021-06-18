fx_version 'adamant'

game 'gta5'

ui_page "index.html"

files {
	"index.html"
}

client_script {
	'config.lua',
	'client.lua'
}

server_scripts {
	'server.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua'
} 








































version 'qalle'