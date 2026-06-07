RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.List(label, description, items, index, action, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'list'
    item.Items = items or {}
    item.Index = index or 1
    item.Disabled = disabled or false
    if #item.Items > 0 then
        if item.Index < 1 then item.Index = 1 end
        if item.Index > #item.Items then item.Index = #item.Items end
    end
    return item
end
