RageUI = RageUI or {}
RageUI.Config = {
    Debug = false,
    MaxMenuItems = 12,
    Keybinds = {
        OpenMenu = 289,
        Up = 172,
        Down = 173,
        Left = 174,
        Right = 175,
        Enter = 176,
        Back = 177
    },
    Audio = {
        Enabled = true,
        Scroll = { 'HUD_FRONTEND_DEFAULT_SOUNDSET', 'NAV_UP_DOWN' },
        Select = { 'HUD_FRONTEND_DEFAULT_SOUNDSET', 'SELECT' },
        Back = { 'HUD_FRONTEND_DEFAULT_SOUNDSET', 'BACK' },
        Error = { 'HUD_FRONTEND_DEFAULT_SOUNDSET', 'ERROR' }
    },
    Theme = {
        Background = { 0, 0, 0, 150 },
        Title = { 255, 255, 255, 255 },
        Description = { 200, 200, 200, 255 },
        Selected = { 45, 100, 200, 255 },
        Unselected = { 255, 255, 255, 255 },
        Highlight = { 30, 75, 150, 200 },
        Header = { 45, 100, 200, 255 },
        Line = { 255, 255, 255, 50 }
    },
    HTMLColors = {
        ['bg-menu'] = 'rgba(10, 10, 10, 0.65)',
        ['bg-item'] = 'rgba(18, 18, 18, 0.45)',
        ['bg-item-hover'] = 'rgba(26, 26, 26, 0.8)',
        ['bg-item-selected'] = 'rgba(30, 30, 30, 0.75)',
        ['accent'] = '#ff2a2a',
        ['accent-glow'] = 'rgba(255, 42, 42, 0.3)',
        ['text-primary'] = '#ffffff',
        ['text-secondary'] = '#e0e0e0',
        ['text-muted'] = '#9c9c9c',
        ['border'] = 'rgba(255, 255, 255, 0.05)',
        ['radius'] = '8px',
        ['radius-sm'] = '4px',
        ['font'] = "'Outfit', sans-serif"
    },
    Instructions = {
        Enabled = true,
        Scaleform = "INSTRUCTIONAL_BUTTONS"
    },
    Mouse = {
        Enabled = true,
        Speed = 1.0
    },
    Animation = {
        Slide = false,
        SlideSpeed = 0.1
    },
    SafeZone = {
        Enabled = true,
        OffsetX = 0.05,
        OffsetY = 0.05
    },
    ResetOnOpen = true
}
