RageUI = RageUI or {}
RageUI.Colors = RageUI.Colors or {}

RageUI.Colors.Default = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 45, 100, 200, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 45, 100, 200, 255 },
    Highlight = { 30, 75, 150, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Blue = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 35, 85, 190, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 35, 85, 190, 255 },
    Highlight = { 25, 65, 140, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Red = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 200, 45, 45, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 200, 45, 45, 255 },
    Highlight = { 150, 30, 30, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Green = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 45, 200, 45, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 45, 200, 45, 255 },
    Highlight = { 30, 150, 30, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Orange = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 230, 126, 34, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 230, 126, 34, 255 },
    Highlight = { 180, 96, 24, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Purple = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 142, 68, 173, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 142, 68, 173, 255 },
    Highlight = { 112, 48, 143, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.Dark = {
    Background = { 0, 0, 0, 180 },
    Title = { 255, 255, 255, 255 },
    Description = { 180, 180, 180, 255 },
    Selected = { 50, 50, 50, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 40, 40, 40, 255 },
    Highlight = { 80, 80, 80, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 30 },
    Subtitle = { 200, 200, 200, 200 }
}

RageUI.Colors.Gold = {
    Background = { 0, 0, 0, 150 },
    Title = { 255, 255, 255, 255 },
    Description = { 200, 200, 200, 255 },
    Selected = { 212, 175, 55, 255 },
    Unselected = { 255, 255, 255, 255 },
    Header = { 212, 175, 55, 255 },
    Highlight = { 172, 135, 15, 200 },
    Text = { 255, 255, 255, 255 },
    Line = { 255, 255, 255, 50 },
    Subtitle = { 255, 255, 255, 200 }
}

RageUI.Colors.HUD = {
    White = { 255, 255, 255, 255 },
    Black = { 0, 0, 0, 255 },
    Red = { 255, 0, 0, 255 },
    Green = { 0, 255, 0, 255 },
    Blue = { 0, 150, 255, 255 },
    Yellow = { 255, 255, 0, 255 },
    Orange = { 255, 165, 0, 255 },
    Purple = { 200, 0, 200, 255 },
    Grey = { 150, 150, 150, 255 },
    DarkGrey = { 50, 50, 50, 255 },
    Transparent = { 0, 0, 0, 0 },
    TransparentBlack = { 0, 0, 0, 150 }
}

function RageUI.Colors.RGBA(r, g, b, a)
    return { r or 0, g or 0, b or 0, a or 255 }
end

function RageUI.Colors.HexToRGB(hex)
    hex = hex:gsub('#', '')
    if #hex ~= 6 then return { 255, 255, 255, 255 } end
    return {
        tonumber('0x' .. hex:sub(1, 2)) or 255,
        tonumber('0x' .. hex:sub(3, 4)) or 255,
        tonumber('0x' .. hex:sub(5, 6)) or 255,
        255
    }
end

function RageUI.Colors.Lerp(c1, c2, t)
    t = math.max(0, math.min(1, t))
    return {
        math.floor(c1[1] + (c2[1] - c1[1]) * t),
        math.floor(c1[2] + (c2[2] - c1[2]) * t),
        math.floor(c1[3] + (c2[3] - c1[3]) * t),
        math.floor((c1[4] or 255) + ((c2[4] or 255) - (c1[4] or 255)) * t)
    }
end
