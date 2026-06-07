RageUI = RageUI or {}
RageUI.Menu = RageUI.Menu or {}

function RageUI.Menu.Create(config)
    config = config or {}

    local menu = {
        Title = config.Title or 'Menu',
        Subtitle = config.Subtitle or 'Interagir',
        Description = config.Description or '',
        Width = config.Width or 0.23,
        X = config.X or 0.80,
        Y = config.Y or 0.18,
        Index = config.Index or 1,
        MinIndex = 1,
        MaxIndex = 1,
        SideIndex = 0,
        SliderProgress = nil,
        Visible = false,
        Items = {},
        ItemCount = 0,
        MaxItems = config.MaxItems or RageUI.Config.MaxMenuItems or 12,
        Parent = nil,
        ParentIndex = nil,
        Banner = config.Banner or nil,
        HasListItems = false,
        EnableMouse = config.EnableMouse or false,
        HoveredItem = nil,
        Cursor = nil,
        InstructionalScaleform = 0,
        OnTick = config.OnTick or nil,
        OnClose = config.OnClose or nil,
        OnOpen = config.OnOpen or nil,
        HeaderColor = config.HeaderColor or RageUI.Config.Theme.Header or { 45, 100, 200, 255 },
        HighlightColor = config.HighlightColor or RageUI.Config.Theme.Highlight or { 30, 75, 150, 200 },
        TextColor = config.TextColor or RageUI.Config.Theme.Unselected or { 255, 255, 255, 255 },
        BackgroundColor = config.BackgroundColor or RageUI.Config.Theme.Background or { 0, 0, 0, 150 },
        DescriptionColor = config.DescriptionColor or RageUI.Config.Theme.Description or { 200, 200, 200, 255 },
        LineColor = config.LineColor or RageUI.Config.Theme.Line or { 255, 255, 255, 50 },
        _dirty = false
    }

    table.insert(RageUI.Menus, menu)

    return menu
end

function RageUI.Menu._DrawBanner(menu, x, y, w, h)
    if not menu.Banner then return end

    local r, g, b, a = menu.HeaderColor[1], menu.HeaderColor[2], menu.HeaderColor[3], menu.HeaderColor[4] or 255

    if menu.Banner.Dict and menu.Banner.Name then
        RageUI._DrawSprite(menu.Banner.Dict, menu.Banner.Name, x, y + h / 2, w, h, r, g, b, a)
    else
        RageUI._DrawRect(x, y + h / 2, w, h, r, g, b, a)
    end
end

function RageUI.Menu._DrawHeader(menu, x, y, w, h)
    local r, g, b, a = menu.HeaderColor[1], menu.HeaderColor[2], menu.HeaderColor[3], menu.HeaderColor[4] or 255

    RageUI._DrawRect(x, y + h / 2, w, h, r, g, b, a)

    RageUI._DrawText(
        x,
        y + h / 2 - RageUI._GetTextHeight(0.4, 1) / 2,
        1, 0.4,
        255, 255, 255, 255,
        menu.Title,
        'center',
        true
    )
end



function RageUI.Menu._DrawItemBackground(menu, x, y, w, h, selected, index)
    if selected then
        RageUI._DrawRect(x, y, w, h,
            menu.HighlightColor[1],
            menu.HighlightColor[2],
            menu.HighlightColor[3],
            menu.HighlightColor[4] or 200
        )
    else
        if index % 2 == 0 then
            RageUI._DrawRect(x, y, w, h, 0, 0, 0, 20)
        end
    end
end

function RageUI.Menu._DrawItemLabel(menu, x, y, w, h, item, selected)
    local textColor = { 255, 255, 255, 255 }

    if item.Disabled then
        textColor = { 100, 100, 100, 180 }
    elseif selected then
        textColor = { 255, 255, 255, 255 }
    elseif item.Color then
        textColor = item.Color
    else
        textColor = menu.TextColor
    end

    if item.Type == 'header' then
        RageUI._DrawRect(x, y, w, h,
            menu.HeaderColor[1],
            menu.HeaderColor[2],
            menu.HeaderColor[3],
            100
        )
        textColor = { 255, 255, 255, 200 }
    end

    if item.Type == 'separator' then
        RageUI._DrawRect(x, y, w, 0.002, menu.LineColor[1], menu.LineColor[2], menu.LineColor[3], menu.LineColor[4] or 100)
        if item.Label and #item.Label > 0 then
            textColor = { 150, 150, 150, 200 }
        else
            return
        end
    end

    if item.Type == 'badge' then
        local badgeMap = {
            none = '', police = '★', ambulance = '★', fire = '★',
            mechanic = '★', admin = '★', vip = '★', lock = '🔒',
            unlock = '🔓', heart = '♥', star = '★', crown = '♛',
            check = '✔', cross = '✘', arrow = '►', music = '♪'
        }
        local badgeChar = badgeMap[item.BadgeType] or ''

        if badgeChar and #badgeChar > 0 then
            RageUI._DrawText(
                x - w / 2 + 0.008,
                y - RageUI._GetTextHeight(0.3, 0) / 2,
                0, 0.3,
                textColor[1], textColor[2], textColor[3], textColor[4],
                badgeChar .. ' ' .. item.Label,
                'left',
                false
            )
            return
        end
    end

    local label = item.Label or ''

    if item.Type == 'checkbox' then
        local checkChar = item.Checked and '✓' or '□'
        RageUI._DrawText(
            x - w / 2 + 0.008,
            y - RageUI._GetTextHeight(0.3, 0) / 2,
            0, 0.3,
            textColor[1], textColor[2], textColor[3], textColor[4],
            label .. '  [' .. checkChar .. ']',
            'left',
            false
        )
        return
    end

    if label and #label > 0 then
        RageUI._DrawText(
            x - w / 2 + 0.008,
            y - RageUI._GetTextHeight(0.3, 0) / 2,
            0, 0.3,
            textColor[1], textColor[2], textColor[3], textColor[4],
            label,
            'left',
            false
        )
    end
end

function RageUI.Menu._DrawItemRightLabel(menu, x, y, w, h, item, selected)
    if item.Type == 'separator' or item.Type == 'header' then return end

    local rightLabel = item.RightLabel or ''

    if item.Type == 'list' and item.Items and #item.Items > 0 then
        rightLabel = '◄ ' .. tostring(item.Items[item.Index] or '') .. ' ►'
    elseif item.Type == 'slider' then
        rightLabel = tostring(item.Value) .. '%'
    elseif item.Type == 'progress' then
        rightLabel = tostring(math.floor((item.Value / (item.Max or 100)) * 100)) .. '%'
    end

    if rightLabel and #rightLabel > 0 then
        local tw = RageUI._GetTextWidth(0.3, 0, rightLabel)
        local r, g, b, a = 200, 200, 200, 200
        if selected then
            r, g, b, a = 255, 255, 255, 255
        end

        RageUI._DrawText(
            x + w / 2 - 0.008,
            y - RageUI._GetTextHeight(0.3, 0) / 2,
            0, 0.3,
            r, g, b, a,
            rightLabel,
            'right',
            false
        )
    end
end

function RageUI.Menu._DrawDescription(menu, x, y, w, h, description)
    RageUI._DrawRect(x, y + h / 2, w, h, 0, 0, 0, 180)

    RageUI._DrawText(
        x - w / 2 + 0.008,
        y + h / 2 - RageUI._GetTextHeight(0.25, 0) / 2,
        0, 0.25,
        menu.DescriptionColor[1], menu.DescriptionColor[2], menu.DescriptionColor[3], menu.DescriptionColor[4] or 255,
        description or '',
        'left',
        false
    )
end

function RageUI.Menu._DrawScrollIndicators(menu, x, y, w, headerH, bannerH, subtitleH, visibleCount, itemH)
    local hasMoreUp = menu.MinIndex > 1
    local hasMoreDown = menu.MaxIndex < #menu.Items
    local subY = y + bannerH + headerH + subtitleH

    if hasMoreUp then
        RageUI._DrawText(
            x,
            subY - 0.002,
            0, 0.25,
            255, 255, 255, 200,
            '▲',
            'center',
            false
        )
    end

    if hasMoreDown then
        local bottomY = subY + visibleCount * itemH + 0.005
        RageUI._DrawText(
            x,
            bottomY,
            0, 0.25,
            255, 255, 255, 200,
            '▼',
            'center',
            false
        )
    end
end

function RageUI.Menu.AddItem(menu, item)
    if not menu or not item then return end
    table.insert(menu.Items, item)
    menu.ItemCount = #menu.Items
    menu._dirty = true
end

function RageUI.Menu.RemoveItem(menu, index)
    if not menu or index < 1 or index > #menu.Items then return end
    table.remove(menu.Items, index)
    menu.ItemCount = #menu.Items
    if menu.Index > #menu.Items then
        menu.Index = #menu.Items
    end
    RageUI.UpdateMenu(menu)
end

function RageUI.Menu.ClearItems(menu)
    if not menu then return end
    menu.Items = {}
    menu.ItemCount = 0
    RageUI.UpdateMenu(menu)
end

function RageUI.Menu.SetBanner(menu, dict, name)
    if not menu then return end
    if dict and name then
        menu.Banner = { Dict = dict, Name = name }
    end
end

function RageUI.Menu.SetColors(menu, colors)
    if not menu or not colors then return end
    menu.HeaderColor = colors.Header or menu.HeaderColor
    menu.HighlightColor = colors.Highlight or menu.HighlightColor
    menu.TextColor = colors.Text or menu.TextColor
    menu.BackgroundColor = colors.Background or menu.BackgroundColor
    menu.DescriptionColor = colors.Description or menu.DescriptionColor
end

function RageUI.Menu.SetPosition(menu, x, y)
    if not menu then return end
    menu.X = x or menu.X
    menu.Y = y or menu.Y
end

function RageUI.Menu.SetWidth(menu, width)
    if not menu then return end
    menu.Width = width or menu.Width
end

function RageUI.Menu.IsVisible(menu)
    if not menu then return false end
    return RageUI.CurrentMenu == menu and menu.Visible
end

function RageUI.Menu.GetItems(menu)
    return menu and menu.Items or {}
end

function RageUI.Menu.GetItemCount(menu)
    return menu and #menu.Items or 0
end

function RageUI.Menu.GetCurrentIndex(menu)
    return menu and menu.Index or 1
end

function RageUI.Menu.SetSubtitle(menu, subtitle)
    if menu then menu.Subtitle = subtitle end
end

function RageUI.Menu.SetTitle(menu, title)
    if menu then menu.Title = title end
end

function RageUI.Menu.SetDescription(menu, desc)
    if menu then menu.Description = desc end
end

function RageUI.Menu.Destroy(menu)
    if not menu then return end
    menu.Visible = false
    for i, m in ipairs(RageUI.Menus) do
        if m == menu then
            table.remove(RageUI.Menus, i)
            break
        end
    end
    if RageUI.CurrentMenu == menu then
        RageUI.CurrentMenu = nil
    end
end

RageUI.Menu.Refresh = RageUI.UpdateMenu
RageUI.Menu.SetVisible = RageUI.Visible

-- ════════════════════════════════════════════════════════════
--  Compatibilité RageUI V1 / Ancienne Syntaxe V2
-- ════════════════════════════════════════════════════════════

function RageUI.CreateMenu(title, subtitle)
    return RageUI.Menu.Create({ Title = title or '', Subtitle = subtitle or '' })
end

function RageUI.CreateSubMenu(parent, title, subtitle)
    local menu = RageUI.Menu.Create({ Title = title or '', Subtitle = subtitle or '' })
    if parent then
        menu.HeaderColor = parent.HeaderColor
        menu.HighlightColor = parent.HighlightColor
    end
    return menu
end

function RageUI.IsVisible(menu, cb)
    if RageUI.Menu.IsVisible(menu) then
        RageUI.Menu.ClearItems(menu)
        local previousMenu = RageUI.ActiveMenu
        RageUI.ActiveMenu = menu
        
        if cb then 
            cb() 
            RageUI.ActiveMenu = previousMenu
        end
        
        return true
    end
    return false
end
