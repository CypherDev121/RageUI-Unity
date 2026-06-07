fx_version 'cerulean'
game 'gta5'

author 'RageUI Framework'
description 'Système de menu RageUI complet - Client/Serveur avec NUI'
version '2.0.0'

server_scripts {
    'server.lua'
}

client_scripts {
    'lib/RageUI.lua',
    'config.lua',
    'lib/Colors.lua',
    'lib/Menu.lua',
    'lib/Items.lua',
    'lib/Button.lua',
    'lib/Checkbox.lua',
    'lib/List.lua',
    'lib/Slider.lua',
    'lib/Progress.lua',
    'lib/Pourcentage.lua',
    'lib/Information.lua',
    'lib/RightLabel.lua',
    'lib/Input.lua',
    'lib/Separator.lua',
    'lib/Notification.lua',
    'lib/Header.lua',
    'lib/Badge.lua',
    'lib/ButtonColored.lua',
    'lib/Panels.lua',
    'lib/IdCard.lua',
    'exports.lua',
    'client.lua',
    'test_menu/Config_TestMenu.lua',
    'test_menu/Menu_test.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'lib/*.lua',
    'config.lua',
    'bridge.lua'
}

data_file 'DLC_ITYP_REQUEST' 'stream/rageui.ytyp'

exports {
    'CreateMenu',
    'OpenMenu',
    'CloseMenu',
    'SetVisible',
    'IsVisible',
    'UpdateMenu',
    'Notify',
    'AddItem',
    'ClearItems',
    'CreateButton',
    'CreateSeparator',
    'CreateList',
    'CreateSlider',
    'CreateCheckbox',
    'CreateProgress',
    'CreateHeader',
    'CreateBadge',
    'CreateInput',
    'SendNUI',
    'ShowIdCard',
    'HideIdCard'
}
