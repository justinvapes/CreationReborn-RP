fx_version 'adamant'

game 'gta5'

-- Requiring essentialmode
dependency 'essentialmode'

client_script 'client.lua'


ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/style.css'
}

server_scripts {

  '@mysql-async/lib/MySQL.lua',
  'server.lua'

}