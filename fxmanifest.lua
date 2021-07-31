fx_version 'adamant'

games { 'gta5' }

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
  'config.lua',
  'server/main.lua'
}

dependencies {
  'es_extended'
}