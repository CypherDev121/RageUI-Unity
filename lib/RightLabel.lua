RageUI = RageUI or {}

---@param label string Le texte ou l'icône à afficher à droite du bouton précédent
function RageUI.RightLabel(label)
    local CurrentMenu = RageUI.ActiveMenu
    if CurrentMenu ~= nil then
        local count = CurrentMenu.ItemCount
        if count > 0 then
            local lastItem = CurrentMenu.Items[count]
            if lastItem then
                lastItem.RightLabel = label
                CurrentMenu._dirty = true
            end
        end
    end
end
