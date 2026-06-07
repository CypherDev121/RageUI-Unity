local function GetPlayerPingSafe()
    local s, r = pcall(GetPlayerPing, GetPlayerServerId(PlayerId()))
    return s and r or 0
end

Citizen.CreateThread(function()
    TriggerServerEvent('RageUI:InitPlayer')
    
    -- Envoi des couleurs du config au NUI
    Citizen.Wait(2000)
    if RageUI and RageUI.Config and RageUI.Config.HTMLColors then
        TriggerEvent('RageUI:UpdateHTMLColors', RageUI.Config.HTMLColors)
    end
end)

RegisterNetEvent('RageUI:UpdateHTMLColors')
AddEventHandler('RageUI:UpdateHTMLColors', function(colors)
    if colors then
        SendNUIMessage({
            type = 'rageui:updateColors',
            colors = colors
        })
    end
end)

RegisterNetEvent('RageUI:Notify')
AddEventHandler('RageUI:Notify', function(msg)
    SendNUIMessage({ type = 'rageui:notify', text = msg or '', style = 'info', duration = 4000 })
end)

RegisterNetEvent('RageUI:NotifySuccess')
AddEventHandler('RageUI:NotifySuccess', function(msg)
    SendNUIMessage({ type = 'rageui:notify', text = msg or '', style = 'success', duration = 4000 })
end)

RegisterNetEvent('RageUI:NotifyError')
AddEventHandler('RageUI:NotifyError', function(msg)
    SendNUIMessage({ type = 'rageui:notify', text = msg or '', style = 'error', duration = 5000 })
end)

RegisterNetEvent('RageUI:ServerNotify')
AddEventHandler('RageUI:ServerNotify', function(d)
    if d and d.text then
        SendNUIMessage({ type = 'rageui:notify', text = d.text, style = d.style or 'info', duration = d.duration or 4000 })
    end
end)

RegisterNetEvent('RageUI:ServerNotification')
AddEventHandler('RageUI:ServerNotification', function(d)
    if d and d.text then
        SendNUIMessage({ type = 'rageui:notify', text = d.text, style = d.style or 'info', duration = d.duration or 4000 })
    end
end)

RegisterCommand('notiftest', function(_, args)
    TriggerEvent('RageUI:Notify', table.concat(args, ' ') or '~g~Notification de test')
end, false)

RegisterCommand('notifserver', function(_, args)
    TriggerServerEvent('RageUI:ServerNotify', {
        text = table.concat(args, ' ') or '~b~Notification serveur',
        style = 'success', duration = 4000
    })
end, false)

print('[RageUI] Client charg\u{00e9} | v' .. (RageUI.__version or '2.0'))

-- Bridge: permet aux ressources externes d'envoyer des messages NUI à travers RageUI
RegisterNetEvent('RageUI:bridge:sendNUI')
AddEventHandler('RageUI:bridge:sendNUI', function(data)
    if data then
        SendNUIMessage(data)
    end
end)
