RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}

function RageUI._CreateBase(label, description, action)
    local item = {
        Label = label or 'Item',
        Description = description or '',
        Action = action or nil,
        Disabled = false,
        Color = nil,
        RightLabel = nil,
        Panel = nil,
        Style = nil
    }
    
    if RageUI.ActiveMenu then
        table.insert(RageUI.ActiveMenu.Items, item)
        RageUI.ActiveMenu.ItemCount = #RageUI.ActiveMenu.Items
        RageUI.ActiveMenu._dirty = true
    end
    
    return item
end

function RageUI._Execute(item)
    if not item or item.Disabled then return end
    if item.Type == 'button' then
        if item.Action then item.Action() end
    elseif item.Type == 'checkbox' then
        item.Checked = not item.Checked
        if item.Action then item.Action(item.Checked) end
    elseif item.Type == 'list' then
        if item.Action then item.Action(item.Index, item.Items[item.Index]) end
    elseif item.Type == 'slider' then
        if item.Action then item.Action(item.Value) end
    elseif item.Type == 'input' then
        DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP8', '', item.Text or '', '', '', '', item.MaxLength or 32)
        item.IsEditing = true
    elseif item.Type == 'button_colored' then
        if item.Action then item.Action() end
    end
end

function RageUI.Panel(item, panel)
    if item then item.Panel = panel end
end

function RageUI.SetDisabled(item, state)
    if item then item.Disabled = state end
end

function RageUI.SetRightLabel(item, label)
    if item then item.RightLabel = label end
end

function RageUI.SetColor(item, r, g, b, a)
    if item then item.Color = { r, g, b, a or 255 } end
end

function RageUI.SetLabel(item, label)
    if item then item.Label = label end
end

function RageUI.SetDescription(item, desc)
    if item then item.Description = desc end
end

function RageUI.SetAction(item, action)
    if item then item.Action = action end
end
