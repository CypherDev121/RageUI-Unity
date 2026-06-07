--[[
    RageUI Bridge - À inclure dans les ressources externes via:
    '@RageUI/bridge.lua'
    
    Ce fichier redirige les messages NUI vers la ressource RageUI
    via un événement local, car SendNUIMessage est spécifique à chaque ressource.
    
    Doit être chargé APRÈS les fichiers lib/ de RageUI.
]]

RageUI._SendNUI = function(data)
    exports.RageUI:SendNUI(data)
end
