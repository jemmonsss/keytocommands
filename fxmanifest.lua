fx_version 'cerulean'
game 'gta5'

author 'J_emmons_07'
description 'Keybind Manager'
version '1.0.0'

lua54 'yes' -- ✅ Required for escrow protection

-- ✅ Load Config **BEFORE** Client & Server Scripts
shared_script 'config/config.lua'

-- ✅ Load Client & Server Scripts
client_script 'client/client.lua'
server_scripts {
    'server/server.lua',
    'server/version_check.lua'
}

-- ✅ UI Files (NUI)
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

-- ✅ MySQL Dependency
server_script '@oxmysql/lib/MySQL.lua'

-- ✅ Escrow Protection Setup
escrow_ignore {
    'config/config.lua', -- Keep this editable for users
    'html/**' -- Allow UI modifications
}

dependency '/assetpacks' -- ✅ Required for escrow system
