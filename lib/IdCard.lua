---@class IdCard
RageUI.IdCard = RageUI.IdCard or {}

local isIdCardVisible = false
local idCardTimer = nil

---@param data table { firstname, lastname, dob, sex, height }
---@param duration number Temps d'affichage en ms (Optionnel, par défaut 8000)
function RageUI.ShowIdCard(data, duration)
    if not data then return end
    duration = duration or 8000

    -- Si une carte est déjà affichée, on clear le timer pour ne pas fermer prématurément
    if isIdCardVisible and idCardTimer then
        ClearTimecycleModifier()
    end

    isIdCardVisible = true
    RageUI._SendNUI({
        type = 'rageui:showIdCard',
        data = data
    })

    -- Jouer un son d'UI (comme si on montrait un papier)
    if RageUI.Config.Audio.Enabled then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end

    -- Timer pour cacher la carte automatiquement
    Citizen.CreateThread(function()
        local currentTimer = GetGameTimer()
        idCardTimer = currentTimer
        
        Citizen.Wait(duration)
        
        -- On vérifie que c'est bien le même timer (au cas où on a remontré une carte entre temps)
        if isIdCardVisible and idCardTimer == currentTimer then
            RageUI.HideIdCard()
        end
    end)
end

function RageUI.HideIdCard()
    if isIdCardVisible then
        isIdCardVisible = false
        RageUI._SendNUI({
            type = 'rageui:hideIdCard'
        })
    end
end
