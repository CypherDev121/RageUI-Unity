RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.ButtonColored(label, description, color, colorHighlight, action, rightLabel, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'button_colored'
    item.Color = color or { 255, 255, 255, 255 }
    item.ColorHighlight = colorHighlight or { 255, 255, 255, 255 }
    item.RightLabel = rightLabel or "→"
    item.Disabled = disabled or false
    return item
end
