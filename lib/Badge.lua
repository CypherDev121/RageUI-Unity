RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

function RageUI.Badge(label, description, badgeType, action, disabled)
    local item = CreateBase(label, description, action)
    item.Type = 'badge'
    item.BadgeType = badgeType or 'none'
    item.Disabled = disabled or false

    local badges = {
        none = '', police = '★', ambulance = '★', fire = '★',
        mechanic = '★', admin = '★', vip = '★',
        lock = '🔒', unlock = '🔓', heart = '♥', star = '★',
        crown = '♛', check = '✔', cross = '✘', arrow = '►', music = '♪'
    }
    item.RightLabel = badges[badgeType] or ''
    return item
end
