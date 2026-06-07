RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Header(label)
    local item = CreateBase(label or '', '')
    item.Type = 'header'
    item.Style = 'header'
    return item
end
