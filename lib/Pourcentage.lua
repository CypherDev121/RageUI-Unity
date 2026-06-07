RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Pourcentage(label, value, max, description, action)
    local item = CreateBase(label, description, action)
    item.Type = 'pourcentage'
    item.Value = value or 0
    item.Max = max or 100
    
    if item.Value > item.Max then item.Value = item.Max end
    if item.Value < 0 then item.Value = 0 end

    -- Keyboard control for percentage
    if RageUI.ActiveMenu and RageUI.ActiveMenu.HoveredItem == item then
        if IsControlPressed(0, 174) then -- Left
            item.Value = item.Value - 1
            if item.Value < 0 then item.Value = 0 end
        elseif IsControlPressed(0, 175) then -- Right
            item.Value = item.Value + 1
            if item.Value > item.Max then item.Value = item.Max end
        end
    end

    if action then
        action(item.Value)
    end

    return item
end
