fx_version 'adamant'

game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/cursor.png',
  'html/img/bg1.jpg',
  'html/img/logo-long.png',
  'html/img/*.png',
  'html/img/cursor.png',
  'html/new/index.html',
  'html/new/bootstrap.min.css',
  'html/new/bootstrap-extend.css',
  'html/new/master_style.css',
  'html/new/master_style_dark.css',
  'html/new/master_style_rtl.css',
  'html/new/images/bg.jpg',
  'html/new/images/bg1.jpg',
  'html/new/images/bg2.jpg',
  'html/new/js/jquery-3.3.1.js',
}

dependency 'es_extended'