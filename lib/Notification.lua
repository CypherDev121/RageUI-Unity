RageUI = RageUI or {}

--- Affiche une notification en jeu (Style par défaut de GTA)
--- @param message string Le texte de la notification
function RageUI.Notification(message)
    if not message then return end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

--- Affiche une notification (Style NUI de cette version de RageUI)
--- @param message string Le texte
--- @param style string (optionnel) 'info', 'success', 'error'
--- @param duration number (optionnel) Temps en ms
function RageUI.Notify(message, style, duration)
    if not message then return end
    TriggerEvent('RageUI:Notify', message, style, duration)
end
