RageUI = RageUI or {}
RageUI.__index = RageUI
RageUI.__version = '2.0.0'

RageUI.Menus = {}
RageUI.CurrentMenu = nil
RageUI.LastControl = 0
RageUI.ControlTime = 0

RageUI._dirty = false

-- NUI sender (overridable via bridge.lua for cross-resource usage)
RageUI._SendNUI = RageUI._SendNUI or SendNUIMessage

function RageUI._KeyPressed(key, delay)
    if delay == nil then delay = 150 end
    if IsControlPressed(0, key) and (GetGameTimer() - RageUI.ControlTime) > delay then
        RageUI.ControlTime = GetGameTimer()
        return true
    end
    return false
end

function RageUI._KeyJustPressed(key)
    return IsControlJustPressed(0, key)
end

function RageUI.ProcessControls(menu)
    if not menu or not menu.Visible then return end

    local up = RageUI.Config.Keybinds.Up
    local down = RageUI.Config.Keybinds.Down
    local left = RageUI.Config.Keybinds.Left
    local right = RageUI.Config.Keybinds.Right
    local enter = RageUI.Config.Keybinds.Enter
    local back = RageUI.Config.Keybinds.Back

    if RageUI._KeyJustPressed(up) then
        if RageUI.Config.Audio.Enabled then
            PlaySoundFrontend(-1, RageUI.Config.Audio.Scroll[2], RageUI.Config.Audio.Scroll[1], true)
        end
        local originalIndex = menu.Index
        if #menu.Items > 0 then
            repeat
                menu.Index = menu.Index - 1
                if menu.Index < 1 then menu.Index = #menu.Items end
            until (menu.Items[menu.Index] and menu.Items[menu.Index].Type ~= 'separator' and menu.Items[menu.Index].Type ~= 'header') or menu.Index == originalIndex
        end
        menu._dirty = true
    end

    if RageUI._KeyJustPressed(down) then
        if RageUI.Config.Audio.Enabled then
            PlaySoundFrontend(-1, RageUI.Config.Audio.Scroll[2], RageUI.Config.Audio.Scroll[1], true)
        end
        local originalIndex = menu.Index
        if #menu.Items > 0 then
            repeat
                menu.Index = menu.Index + 1
                if menu.Index > #menu.Items then menu.Index = 1 end
            until (menu.Items[menu.Index] and menu.Items[menu.Index].Type ~= 'separator' and menu.Items[menu.Index].Type ~= 'header') or menu.Index == originalIndex
        end
        menu._dirty = true
    end

    if RageUI._KeyJustPressed(enter) then
        local item = menu.Items[menu.Index]
        if item and not item.Disabled then
            if RageUI.Config.Audio.Enabled then
                PlaySoundFrontend(-1, RageUI.Config.Audio.Select[2], RageUI.Config.Audio.Select[1], true)
            end
            RageUI._Execute(item)
        end
    end

    if RageUI._KeyJustPressed(back) then
        if RageUI.Config.Audio.Enabled then
            PlaySoundFrontend(-1, RageUI.Config.Audio.Back[2], RageUI.Config.Audio.Back[1], true)
        end
        RageUI.CloseMenu(menu)
    end

    if RageUI._KeyPressed(left, 120) then
        local item = menu.Items[menu.Index]
        if item and not item.Disabled then
            if item.Type == 'slider' then
                item.Value = math.max(item.Min or 0, item.Value - (item.Step or 1))
                if item.Action then item.Action(item.Value) end
                menu._dirty = true
            elseif item.Type == 'list' then
                item.Index = item.Index - 1
                if item.Index < 1 then item.Index = #item.Items end
                if item.Action then item.Action(item.Index, item.Items[item.Index]) end
                menu._dirty = true
            end
        end
    end

    if RageUI._KeyPressed(right, 120) then
        local item = menu.Items[menu.Index]
        if item and not item.Disabled then
            if item.Type == 'slider' then
                item.Value = math.min(item.Max or 100, item.Value + (item.Step or 1))
                if item.Action then item.Action(item.Value) end
                menu._dirty = true
            elseif item.Type == 'list' then
                item.Index = item.Index + 1
                if item.Index > #item.Items then item.Index = 1 end
                if item.Action then item.Action(item.Index, item.Items[item.Index]) end
                menu._dirty = true
            end
        end
    end
end

function RageUI.BuildMenuData(menu)
    if not menu then return nil end

    local items = {}
    for i, item in ipairs(menu.Items) do
        local entry = {
            type = item.Type or 'button',
            label = item.Label or '',
            description = item.Description or '',
            disabled = item.Disabled or false,
            rightLabel = item.RightLabel or nil,
        }

        if item.Type == 'checkbox' then
            entry.checked = item.Checked or false
        elseif item.Type == 'list' then
            entry.listValue = item.Items and item.Items[item.Index] or ''
            entry.listIndex = item.Index or 1
        elseif item.Type == 'slider' then
            entry.value = item.Value or 0
            entry.min = item.Min or 0
            entry.max = item.Max or 100
        elseif item.Type == 'progress' or item.Type == 'pourcentage' then
            entry.type = 'progress'
            entry.value = item.Value or 0
            entry.max = item.Max or 100
        elseif item.Type == 'badge' then
            entry.badgeType = item.BadgeType or 'none'
        end

        table.insert(items, entry)
    end

    local idx = menu.Index or 1
    local count = #items
    if count > 0 then
        if idx > count then idx = count end
        if idx < 1 then idx = 1 end
    end

    return {
        type = 'rageui:render',
        title = menu.Title or 'Menu',
        subtitle = menu.Subtitle or 'Interagir',
        index = idx,
        items = items,
        bannerColor = menu.HeaderColor or { 45, 100, 200, 255 },
        headerColor = menu.HeaderColor or { 45, 100, 200, 255 },
    }
end

function RageUI.SendToNUI(menu)
    if not menu or not menu.Visible then return end

    local data = RageUI.BuildMenuData(menu)
    if data then
        local dataStr = json.encode(data)
        if menu._lastSentDataStr ~= dataStr then
            RageUI._SendNUI(data)
            menu._lastSentDataStr = dataStr
        end
        menu._dirty = false
    end
end

function RageUI.OpenMenu(menu)
    if not menu then return end

    if RageUI.CurrentMenu and RageUI.CurrentMenu ~= menu and RageUI.CurrentMenu.Visible then
        menu.Parent = RageUI.CurrentMenu
        menu.ParentIndex = RageUI.CurrentMenu.Index
        RageUI.CurrentMenu.Visible = false
    end

    RageUI.CurrentMenu = menu
    menu.Visible = true
    menu.Index = math.max(1, menu.Index or 1)
    menu._dirty = true
    menu._lastSentDataStr = nil -- Force NUI re-render on reopen

    if menu.OnOpen then menu.OnOpen() end

    RageUI.UpdateMenu(menu)
end

function RageUI.CloseMenu(menu)
    if not menu then return end
    menu.Visible = false
    menu._lastSentDataStr = nil -- Reset cache so next open always re-renders

    if menu.Parent then
        RageUI.CurrentMenu = menu.Parent
        RageUI.CurrentMenu.Visible = true
        RageUI.CurrentMenu.Index = menu.ParentIndex or 1
        RageUI.CurrentMenu._dirty = true
        RageUI.CurrentMenu._lastSentDataStr = nil -- Force parent re-render too
        RageUI.UpdateMenu(RageUI.CurrentMenu)
    else
        RageUI.CurrentMenu = nil
        RageUI._SendNUI({ type = 'rageui:hide' })
    end

    if menu.OnClose then menu.OnClose() end
end

function RageUI.Visible(menu, state)
    if state ~= nil then
        if state then
            RageUI.OpenMenu(menu)
        else
            RageUI.CloseMenu(menu)
        end
    else
        return menu and menu.Visible or false
    end
end

function RageUI.UpdateMenu(menu)
    if not menu then return end
    local count = #menu.Items
    if count > 0 then
        if menu.Index < 1 then menu.Index = 1 end
        if menu.Index > count then menu.Index = count end
        
        -- Auto-skip separators and headers when menu opens or updates
        if menu.Items[menu.Index] and (menu.Items[menu.Index].Type == 'separator' or menu.Items[menu.Index].Type == 'header') then
            local start = menu.Index
            repeat
                menu.Index = menu.Index + 1
                if menu.Index > count then menu.Index = 1 end
            until (menu.Items[menu.Index] and menu.Items[menu.Index].Type ~= 'separator' and menu.Items[menu.Index].Type ~= 'header') or menu.Index == start
        end
    end
    menu._dirty = true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if RageUI.CurrentMenu and RageUI.CurrentMenu.Visible then
            local menu = RageUI.CurrentMenu
            RageUI.ProcessControls(menu)

            -- Handle active onscreen keyboard inputs
            for _, item in ipairs(menu.Items) do
                if item.Type == 'input' and item.IsEditing then
                    local status = UpdateOnscreenKeyboard()
                    if status == 1 then
                        local result = GetOnscreenKeyboardResult()
                        item.Text = result
                        item.IsEditing = false
                        if item.Action then
                            item.Action(result)
                        end
                        menu._dirty = true
                    elseif status == 2 or status == 3 then
                        item.IsEditing = false
                    end
                end
            end

            if menu._dirty then
                RageUI.SendToNUI(menu)
            end
        end

        for _, menu in ipairs(RageUI.Menus) do
            if menu.OnTick and not menu.Visible then
                menu.OnTick()
            end
        end
    end
end)

-- NUI callbacks from HTML
RegisterNUICallback('rageui', function(data, cb)
    local action = data.action or ''

    if action == 'selectItem' then
        local index = data.index
        local menu = RageUI.CurrentMenu
        if menu and menu.Items[index] then
            local item = menu.Items[index]
            if not item.Disabled then
                if RageUI.Config.Audio.Enabled then
                    PlaySoundFrontend(-1, RageUI.Config.Audio.Select[2], RageUI.Config.Audio.Select[1], true)
                end
                RageUI._Execute(item)
            end
        end
        cb('ok')

    elseif action == 'hoverItem' then
        local index = data.index
        local menu = RageUI.CurrentMenu
        if menu and menu.EnableMouse and index and index >= 1 and index <= #menu.Items then
            if menu.Index ~= index then
                menu.Index = index
                menu._dirty = true
            end
        end
        cb('ok')

    elseif action == 'consoleCommand' then
        TriggerServerEvent('RageUI:ValidateCommand', data.command)
        cb('ok')

    elseif action == 'getPlayers' then
        TriggerServerEvent('RageUI:GetPlayers')
        cb('ok')

    elseif action == 'checkStatus' then
        TriggerServerEvent('RageUI:CheckStatus')
        cb('ok')

    elseif action == 'restartResource' then
        TriggerServerEvent('RageUI:RestartResource')
        cb('ok')

    elseif action == 'adminOpened' or action == 'adminClosed' then
        SetNuiFocus(action == 'adminOpened', action == 'adminOpened')
        if action == 'adminOpened' then
            TriggerServerEvent('RageUI:GetDashboard')
        end
        cb('ok')

    else
        cb('ok')
    end
end)
