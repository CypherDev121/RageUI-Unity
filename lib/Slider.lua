RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Slider(label, description, value, min, max, step, action, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'slider'
    item.Value = value or 50
    item.Min = min or 0
    item.Max = max or 100
    item.Step = step or 1
    item.Disabled = disabled or false
    item.Value = math.max(item.Min, math.min(item.Max, item.Value))
    return item
end
