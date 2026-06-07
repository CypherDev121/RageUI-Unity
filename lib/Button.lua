RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Button(label, description, action, rightLabel, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'button'
    item.RightLabel = rightLabel or "→"
    item.Disabled = disabled or false
    return item
end
