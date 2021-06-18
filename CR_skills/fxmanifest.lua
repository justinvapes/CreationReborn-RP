fx_version 'adamant'

game 'gta5'

client_scripts {
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

ui_page('html/index.html')

files({
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/img/close.png',
  'html/img/logo-long.png',
  'Main/client.lua',
})

exports {
  'staminaCheck',
}