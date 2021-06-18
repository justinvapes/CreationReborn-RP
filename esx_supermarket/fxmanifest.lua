fx_version 'adamant'

game 'gta5'

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/iransans.otf',
	
	"html/img/scissors.png",
	
	"html/img/highgradefemaleseed.png",
	"html/img/highgrademaleseed.png",
	"html/img/lowgradefemaleseed.png",
	"html/img/lowgrademaleseed.png",

	"html/img/lowgradefert.png",
	"html/img/highgradefert.png",

	"html/img/averagequalitybud.png",
	"html/img/highqualitybud.png",
	"html/img/lowqualitybud.png",
	"html/img/mediumqualitybud.png",  

	"html/img/miricle_grow.png",
	"html/img/wateringcan.png",
	"html/img/purifiedwater.png",
	"html/img/plantpot.png",
	"html/img/soil.png",
	
    "html/img/boombox.png",
    "html/img/fscanner.png",
    "html/img/bobbypin.png",
    "html/img/screwdriver.png",
	'html/img/lockpick.png',
	'html/img/hdevice.png',
	'html/img/cocaine.png',
	'html/img/clip.png',
	'html/img/vest.png',
	'html/img/plate.png',
	'html/img/blowtorch.png',
	'html/img/radardetector.png',
	'html/img/handcuffkeys.png',	
	'html/img/cannabis_seed.png',
	'html/img/watering_can.png',
	'html/img/miricle_grow.png',	
	'html/img/close.png',
	'html/img/plus.png',
	'html/img/minus.png',
	'html/img/bread.png',
	'html/img/beer.png',
	'html/img/cigarett.png',
	'html/img/lighter.png',
	'html/img/lotteryticket.png',
	'html/img/milk.png',
	'html/img/tequila.png',
	'html/img/vodka.png',
	'html/img/water.png',
	'html/img/whisky.png',
	'html/img/wine.png',
	'html/img/coins.png',
	'html/img/dice.png',
	'html/img/hamburger.png',
	'html/img/notepad.png',
	'html/img/binoculars.png',
	'html/img/phone.png',
	'html/img/simcard.png',
	'html/img/*.png'
}

ui_page 'html/ui.html'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

dependency 'es_extended'
