-- Exports de base
function CreateMenu(config)
    return RageUI.Menu.Create(config)
end

function OpenMenu(menu)
    RageUI.OpenMenu(menu)
end

function CloseMenu(menu)
    RageUI.CloseMenu(menu)
end

function SetVisible(menu, state)
    RageUI.Visible(menu, state)
end

function IsVisible(menu)
    return RageUI.CurrentMenu == menu and menu.Visible
end

function UpdateMenu(menu)
    RageUI.UpdateMenu(menu)
end

function Notify(message, style, duration)
    TriggerEvent('RageUI:Notify', message, style, duration)
end

-- Exports pour les items
function AddItem(menu, item)
    RageUI.Menu.AddItem(menu, item)
end

function ClearItems(menu)
    RageUI.Menu.ClearItems(menu)
end

-- Constructeurs d'items
function CreateButton(label, description, action, rightLabel, disabled)
    return RageUI.Button(label, description, action, rightLabel, disabled)
end

function CreateSeparator(label)
    return RageUI.Separator(label)
end

function CreateList(label, description, items, index, action, disabled)
    return RageUI.List(label, description, items, index, action, disabled)
end

function CreateSlider(label, description, value, min, max, step, action, disabled)
    return RageUI.Slider(label, description, value, min, max, step, action, disabled)
end

function CreateCheckbox(label, description, checked, action, disabled)
    return RageUI.Checkbox(label, description, checked, action, disabled)
end

function CreateProgress(label, description, value, max, action, disabled)
    return RageUI.Progress(label, description, value, max, action, disabled)
end

function CreateHeader(label)
    return RageUI.Header(label)
end

function CreateBadge(label, description, badgeType)
    return RageUI.Badge(label, description, badgeType)
end

function CreateInput(label, description, text, maxLength, action, disabled)
    return RageUI.Input(label, description, text, maxLength, action, disabled)
end

function SendNUI(data)
    if data then
        SendNUIMessage(data)
    end
end
