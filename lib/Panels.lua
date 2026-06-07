RageUI = RageUI or {}
RageUI.Panels = RageUI.Panels or {}

function RageUI.Panels.Percentage(parent, value, action)
    local panel = {
        Type = 'percentage',
        Parent = parent,
        Value = value or 50,
        Min = 0,
        Max = 100,
        Background = { 0, 0, 0, 100 },
        Foreground = { 45, 100, 200, 255 },
        Action = action or nil
    }
    if parent then parent.Panel = panel end
    return panel
end

function RageUI.Panels.Grid(parent, x, y, action)
    local panel = {
        Type = 'grid',
        Parent = parent,
        X = x or 0.5,
        Y = y or 0.5,
        Background = { 0, 0, 0, 100 },
        Foreground = { 45, 100, 200, 255 },
        GridColor = { 255, 255, 255, 30 },
        Action = action or nil
    }
    if parent then parent.Panel = panel end
    return panel
end

function RageUI.Panels.Button(parent, label, action)
    local panel = {
        Type = 'panel_button',
        Parent = parent,
        Label = label or 'Panel Button',
        Background = { 30, 30, 30, 200 },
        Highlight = { 45, 100, 200, 255 },
        Action = action or nil
    }
    if parent then parent.Panel = panel end
    return panel
end

function RageUI.Panels.Color(parent, colors, index, action)
    local panel = {
        Type = 'color',
        Parent = parent,
        Colors = colors or {
            { 255, 0, 0, 255 }, { 0, 255, 0, 255 }, { 0, 0, 255, 255 },
            { 255, 255, 0, 255 }, { 255, 0, 255, 255 }, { 0, 255, 255, 255 },
            { 255, 255, 255, 255 }, { 0, 0, 0, 255 }
        },
        Index = index or 1,
        Action = action or nil,
        SwatchSize = 0.02,
        Spacing = 0.004
    }
    if parent then parent.Panel = panel end
    return panel
end

function RageUI.Panels.Stats(parent, stats)
    local panel = {
        Type = 'stats',
        Parent = parent,
        Stats = stats or {},
        Background = { 0, 0, 0, 100 },
        Foreground = { 45, 100, 200, 255 }
    }
    if parent then parent.Panel = panel end
    return panel
end

function RageUI.Panels.Render(panel, x, y, w, h)
    if not panel then return end

    if panel.Type == 'percentage' then
        RageUI.Panels._RenderPercentage(panel, x, y, w)

    elseif panel.Type == 'grid' then
        RageUI.Panels._RenderGrid(panel, x, y, w, h)

    elseif panel.Type == 'panel_button' then
        RageUI.Panels._RenderButton(panel, x, y, w)

    elseif panel.Type == 'color' then
        RageUI.Panels._RenderColor(panel, x, y, w)

    elseif panel.Type == 'stats' then
        RageUI.Panels._RenderStats(panel, x, y, w)
    end
end

function RageUI.Panels._RenderPercentage(panel, x, y, w)
    local barW = w * 0.75
    local barH = 0.012
    local barX = x
    local barY = y + 0.012

    RageUI._DrawRect(barX, barY, barW, barH,
        panel.Background[1], panel.Background[2], panel.Background[3], panel.Background[4])

    local fill = (panel.Value / (panel.Max - panel.Min)) * barW
    RageUI._DrawRect(barX - barW / 2 + fill / 2, barY, fill, barH,
        panel.Foreground[1], panel.Foreground[2], panel.Foreground[3], 255)

    RageUI._DrawText(barX + barW / 2 + 0.012, barY - 0.006,
        0, 0.2, 255, 255, 255, 200,
        math.floor((panel.Value / (panel.Max - panel.Min)) * 100) .. '%',
        'left', false)
end

function RageUI.Panels._RenderGrid(panel, x, y, w, h)
    local gridSize = w * 0.45
    local gx = x
    local gy = y + 0.015

    RageUI._DrawRect(gx, gy, gridSize, gridSize,
        panel.Background[1], panel.Background[2], panel.Background[3], panel.Background[4])

    local rows, cols = 10, 10
    local cellW, cellH = gridSize / cols, gridSize / rows

    for r = 0, rows do
        local ly = gy - gridSize / 2 + r * cellH
        RageUI._DrawRect(gx, ly, gridSize, 0.001,
            panel.GridColor[1], panel.GridColor[2], panel.GridColor[3], panel.GridColor[4])
    end
    for c = 0, cols do
        local lx = gx - gridSize / 2 + c * cellW
        RageUI._DrawRect(lx, gy, 0.001, gridSize,
            panel.GridColor[1], panel.GridColor[2], panel.GridColor[3], panel.GridColor[4])
    end

    local dotX = gx - gridSize / 2 + panel.X * gridSize
    local dotY = gy - gridSize / 2 + panel.Y * gridSize

    RageUI._DrawRect(dotX, dotY, cellW * 0.7, cellH * 0.7,
        panel.Foreground[1], panel.Foreground[2], panel.Foreground[3], 255)
end

function RageUI.Panels._RenderButton(panel, x, y, w)
    local by = y + 0.012

    RageUI._DrawRect(x, by, w, 0.025,
        panel.Background[1], panel.Background[2], panel.Background[3], panel.Background[4])

    RageUI._DrawText(x, by - 0.008,
        0, 0.25, 255, 255, 255, 255,
        panel.Label or 'Button',
        'center', false)
end

function RageUI.Panels._RenderColor(panel, x, y, w)
    if not panel.Colors or #panel.Colors == 0 then return end

    local num = #panel.Colors
    local cols = math.min(num, 4)
    local rows = math.ceil(num / cols)
    local swatchSize = panel.SwatchSize or 0.02
    local spacing = panel.Spacing or 0.004
    local totalW = cols * (swatchSize + spacing)
    local startX = x - totalW / 2 + swatchSize / 2
    local startY = y + 0.012

    for i, color in ipairs(panel.Colors) do
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        local sx = startX + col * (swatchSize + spacing)
        local sy = startY + row * (swatchSize + spacing) - (rows - 1) * (swatchSize + spacing) / 2

        if i == panel.Index then
            RageUI._DrawRect(sx, sy, swatchSize + 0.004, swatchSize + 0.004, 255, 255, 255, 200)
        end

        RageUI._DrawRect(sx, sy, swatchSize - 0.002, swatchSize - 0.002,
            color[1], color[2], color[3], color[4] or 255)
    end
end

function RageUI.Panels._RenderStats(panel, x, y, w)
    if not panel.Stats then return end

    local statH = 0.018
    local labelW = w * 0.35
    local barW = w * 0.50
    local startY = y + 0.008

    for i, stat in ipairs(panel.Stats) do
        local sy = startY + (i - 1) * (statH + 0.004)
        local fill = (stat.Value / (stat.Max or 100)) * barW

        if stat.Label then
            RageUI._DrawText(x - w / 2, sy - 0.006,
                0, 0.2, 255, 255, 255, 200,
                stat.Label, 'left', false)
        end

        RageUI._DrawRect(x + labelW - w / 2 + barW / 2, sy + 0.002, barW, statH,
            panel.Background[1], panel.Background[2], panel.Background[3], panel.Background[4])

        RageUI._DrawRect(x + labelW - w / 2 + fill / 2, sy + 0.002, fill, statH,
            (stat.Color and stat.Color[1]) or panel.Foreground[1],
            (stat.Color and stat.Color[2]) or panel.Foreground[2],
            (stat.Color and stat.Color[3]) or panel.Foreground[3], 255)
    end
end
