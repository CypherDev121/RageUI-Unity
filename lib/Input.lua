RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Input(label, description, text, maxLength, action, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'input'
    item.Text = text or ''
    item.MaxLength = maxLength or 32
    item.Disabled = disabled or false
    item.RightLabel = '>'
    item.IsEditing = false
    return item
end
