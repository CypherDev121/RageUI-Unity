local Original_RageUI = _G.RageUI

local Wrapper = {}
Wrapper.__index = Original_RageUI

function Wrapper.Button(Label, Description, Action, RightLabel, Disabled, Submenu)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    
    local realSubmenu = Submenu
    if Submenu and type(Submenu) == "table" and Submenu._isProxy then
        if style == 1 then realSubmenu = Submenu._v2
        elseif style == 2 then realSubmenu = Submenu._v1
        elseif style == 3 then realSubmenu = Submenu._v3
        end
    end

    if style == 1 then
        return Original_RageUI.Button(Label, Description, Action, RightLabel, Disabled, realSubmenu)
    elseif style == 2 and RageUI_Ancien then
        local rightText = ""
        if RightLabel and type(RightLabel) == "string" then rightText = RightLabel end
        RageUI_Ancien.ButtonWithStyle(Label, Description, { RightLabel = rightText }, not Disabled, function(Hovered, Active, Selected)
            if Selected and Action then Action() end
        end, realSubmenu)
    elseif style == 3 and RageUI_Modern then
        local rightText = ""
        if RightLabel and type(RightLabel) == "string" then rightText = RightLabel end
        RageUI_Modern.Button(Label, Description, { RightLabel = rightText }, not Disabled, function(Hovered, Active, Selected)
            if Selected and Action then Action() end
        end, realSubmenu)
    else
        return Original_RageUI.Button(Label, Description, Action, RightLabel, Disabled, realSubmenu)
    end
end

function Wrapper.CreateMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
    local proxy = {
        _v1 = RageUI_Ancien and RageUI_Ancien.CreateMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A) or nil,
        _v2 = Original_RageUI.CreateMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A),
        _v3 = RageUI_Modern and RageUI_Modern.CreateMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A) or nil,
        _isProxy = true,
    }
    
    if proxy._v1 then proxy._v1.Open = false end
    if proxy._v2 then proxy._v2.Open = false; proxy._v2.Visible = false end
    if proxy._v3 then proxy._v3.Open = false end

    setmetatable(proxy, {
        __index = function(t, k)
            local style = LocalPlayer.state.MenuVisualStyle or 1
            if style == 1 then return t._v2[k]
            elseif style == 2 and t._v1 then return t._v1[k]
            elseif style == 3 and t._v3 then return t._v3[k]
            end
            return t._v2[k]
        end,
        __newindex = function(t, k, v)
            if k == "Open" or k == "Visible" then
                local style = LocalPlayer.state.MenuVisualStyle or 1
                if t._v1 then t._v1[k] = (style == 2) and v or false end
                if t._v2 then t._v2[k] = (style == 1) and v or false end
                if t._v2 and k == "Open" then t._v2.Visible = (style == 1) and v or false end
                if t._v3 then t._v3[k] = (style == 3) and v or false end
            else
                if t._v1 then t._v1[k] = v end
                if t._v2 then t._v2[k] = v end
                if t._v3 then t._v3[k] = v end
            end
        end,
        __call = function(t, ...)
            local style = LocalPlayer.state.MenuVisualStyle or 1
            if style == 2 and t._v1 then
                local meta = getmetatable(t._v1)
                if meta and meta.__call then return meta.__call(t._v1, ...) end
            elseif style == 3 and t._v3 then
                local meta = getmetatable(t._v3)
                if meta and meta.__call then return meta.__call(t._v3, ...) end
            end
            return true
        end
    })

    return proxy
end

function Wrapper.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
    if not (ParentMenu and type(ParentMenu) == "table" and ParentMenu._isProxy) then
        local style = LocalPlayer.state.MenuVisualStyle or 1
        if style == 1 then return Original_RageUI.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
        elseif style == 2 and RageUI_Ancien then return RageUI_Ancien.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
        elseif style == 3 and RageUI_Modern then return RageUI_Modern.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
        end
        return Original_RageUI.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
    end

    local proxy = {
        _v1 = ParentMenu._v1 and RageUI_Ancien and RageUI_Ancien.CreateSubMenu(ParentMenu._v1, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A) or nil,
        _v2 = ParentMenu._v2 and Original_RageUI.CreateSubMenu(ParentMenu._v2, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A) or nil,
        _v3 = ParentMenu._v3 and RageUI_Modern and RageUI_Modern.CreateSubMenu(ParentMenu._v3, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A) or nil,
        _isProxy = true,
    }
    
    if proxy._v1 then proxy._v1.Open = false end
    if proxy._v2 then proxy._v2.Open = false; proxy._v2.Visible = false end
    if proxy._v3 then proxy._v3.Open = false end

    setmetatable(proxy, getmetatable(ParentMenu))

    return proxy
end

function Wrapper.IsVisible(Menu, Callback, Panels)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    
    local realMenu = Menu
    if Menu and type(Menu) == "table" and Menu._isProxy then
        if style == 1 then realMenu = Menu._v2
        elseif style == 2 then realMenu = Menu._v1
        elseif style == 3 then realMenu = Menu._v3
        end
    else
        style = 1
    end

    if style == 1 then
        Original_RageUI.IsVisible(realMenu, Callback, Panels)
    elseif style == 2 and RageUI_Ancien then
        RageUI_Ancien.IsVisible(realMenu, true, false, true, Callback, Panels)
    elseif style == 3 and RageUI_Modern then
        RageUI_Modern.IsVisible(realMenu, Callback, Panels, true)
    else
        Original_RageUI.IsVisible(realMenu, Callback, Panels)
    end
end

function Wrapper.Visible(Menu, Value)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    
    if Menu and type(Menu) == "table" and Menu._isProxy then
        if Value ~= nil then
            Menu.Open = Value
        end
        if style == 1 then return Original_RageUI.Visible(Menu._v2, Value)
        elseif style == 2 and RageUI_Ancien then return RageUI_Ancien.Visible(Menu._v1, Value)
        elseif style == 3 and RageUI_Modern then return RageUI_Modern.Visible(Menu._v3, Value)
        end
        return Original_RageUI.Visible(Menu._v2, Value)
    end

    return Original_RageUI.Visible(Menu, Value)
end

function Wrapper.Separator(Label)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    if style == 1 then
        Original_RageUI.Separator(Label)
    elseif style == 2 and RageUI_Ancien then
        RageUI_Ancien.Separator(Label)
    elseif style == 3 and RageUI_Modern then
        RageUI_Modern.Separator(Label)
    else
        Original_RageUI.Separator(Label)
    end
end

function Wrapper.List(label, description, items, index, action, disabled)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    if style == 1 then
        return Original_RageUI.List(label, description, items, index, action, disabled)
    elseif style == 2 and RageUI_Ancien then
        RageUI_Ancien.List(label, items, index, description, {}, not disabled, function(Index, Hovered, Active, Selected)
            if action then action(Index, items[Index]) end
        end)
    elseif style == 3 and RageUI_Modern then
        RageUI_Modern.List(label, items, index, description, {}, not disabled, {
            onListChange = function(Index, Item)
                if action then action(Index, Item) end
            end
        })
    else
        return Original_RageUI.List(label, description, items, index, action, disabled)
    end
end

function Wrapper.Checkbox(label, description, checked, action, disabled)
    local style = LocalPlayer.state.MenuVisualStyle or 1
    if style == 1 then
        return Original_RageUI.Checkbox(label, description, checked, action, disabled)
    elseif style == 2 and RageUI_Ancien then
        RageUI_Ancien.Checkbox(label, description, checked, {}, function(Hovered, Active, Selected, Checked)
            if Selected and action then
                action(Checked)
            end
        end)
    elseif style == 3 and RageUI_Modern then
        RageUI_Modern.Checkbox(label, description, checked, {}, {
            onChecked = function() if action then action(true) end end,
            onUnChecked = function() if action then action(false) end end
        })
    else
        return Original_RageUI.Checkbox(label, description, checked, action, disabled)
    end
end

_G.RageUI = setmetatable(Wrapper, {
    __index = Original_RageUI
})
