RageUI = RageUI or {}
RageUI.Items = RageUI.Items or {}
local CreateBase = RageUI._CreateBase

--- Crée un item checkbox
--- @param label string Texte affiché
--- @param description string Description (optionnel)
--- @param checked boolean État coché par défaut
--- @param action function Callback appelé avec l'état (boolean) au toggle
--- @param disabled boolean Désactivé
--- @return table item
RageUI.Checkbox = {}

setmetatable(RageUI.Checkbox, {
    __call = function(self, label, description, checked, action, disabled)
        local item = CreateBase(label, description, action)
        item.Type = 'checkbox'
        item.Checked = checked or false
        item.Disabled = disabled or false
        return item
    end
})

--- Définit l'état coché d'une checkbox (met à jour le NUI)
--- @param item table L'item checkbox
--- @param state boolean Nouvel état
--- @param silent boolean Si true, ne déclenche pas le callback
function RageUI.Checkbox.SetChecked(item, state, silent)
    if not item or item.Type ~= 'checkbox' then return end
    item.Checked = state and true or false
    if not silent and item.Action then
        item.Action(item.Checked)
    end
    -- Notifie le NUI du changement sans re-render complet
    if RageUI.CurrentMenu then
        RageUI.CurrentMenu._dirty = true
    end
end

--- Retourne l'état coché
--- @param item table L'item checkbox
--- @return boolean
function RageUI.Checkbox.IsChecked(item)
    if not item or item.Type ~= 'checkbox' then return false end
    return item.Checked or false
end

--- Bascule l'état de la checkbox
--- @param item table L'item checkbox
--- @param silent boolean Si true, ne déclenche pas le callback
function RageUI.Checkbox.Toggle(item, silent)
    if not item or item.Type ~= 'checkbox' then return end
    RageUI.Checkbox.SetChecked(item, not item.Checked, silent)
end

--- Change le label de la checkbox
--- @param item table L'item checkbox
--- @param label string Nouveau label
function RageUI.Checkbox.SetLabel(item, label)
    if not item then return end
    item.Label = label
    if RageUI.CurrentMenu then
        RageUI.CurrentMenu._dirty = true
    end
end

--- Change la description de la checkbox
--- @param item table L'item checkbox
--- @param description string Nouvelle description
function RageUI.Checkbox.SetDescription(item, description)
    if not item then return end
    item.Description = description
    if RageUI.CurrentMenu then
        RageUI.CurrentMenu._dirty = true
    end
end
