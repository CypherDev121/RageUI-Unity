---@class Information
local Information = {}

local LastInformationTick = 0
local LastInformationHash = nil

---@param Title string Le titre du panneau d'information
---@param Data table Un tableau contenant les labels et les valeurs (ex: { {"Job", "Police"}, {"Jail", "~r~Non"} })
function RageUI.Information(Title, Data)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu.Visible then
        LastInformationTick = GetGameTimer()
        
        local hash = Title or "Informations"
        local items = {}
        for i=1, #Data do
            local label = Data[i][1] or ""
            local value = Data[i][2] or ""
            hash = hash .. label .. value
            table.insert(items, {
                label = label,
                value = value
            })
        end
        
        if LastInformationHash ~= hash then
            RageUI._SendNUI({
                type = 'rageui:renderInformation',
                title = Title or 'Informations',
                items = items
            })
            LastInformationHash = hash
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if LastInformationHash ~= nil and (GetGameTimer() - LastInformationTick) > 150 then
            RageUI._SendNUI({ type = 'rageui:hideInformation' })
            LastInformationHash = nil
        end
    end
end)
