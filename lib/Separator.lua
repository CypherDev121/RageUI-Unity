RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Separator(label)
    local item = CreateBase(label or '', '')
    item.Type = 'separator'
    return item
end

function RageUI.Line()
    return RageUI.Separator('')
end
