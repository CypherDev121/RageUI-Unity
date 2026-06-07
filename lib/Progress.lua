RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Progress(label, description, value, max, action, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'progress'
    item.Value = value or 0
    item.Max = max or 100
    item.Disabled = disabled or false
    item.Value = math.max(0, math.min(item.Max, item.Value))
    return item
end
