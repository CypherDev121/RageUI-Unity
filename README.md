# RageUI-Unity

# Tutoriel : Créer un menu avec RageUI v2 (Syntaxe Classique)

Bienvenue dans ce tutoriel pour apprendre à créer des menus avec **RageUI v2 2026 !** (version optimisée avec interface NUI).
Grâce à une mise à jour récente de la ressource, vous pouvez désormais utiliser **l'exacte même syntaxe qu'à l'ancienne (V1)**, tout en profitant des nouvelles performances et des nouveaux arguments plus clairs !

## 1. Installation dans votre ressource

Pour utiliser RageUI dans vos propres scripts, vous devez inclure les fichiers de la bibliothèque directement dans le `fxmanifest.lua` de votre ressource. Il faut **obligatoirement** inclure `@RageUI/bridge.lua` à la fin pour que le lien NUI se fasse correctement.

Dans votre `fxmanifest.lua` :
```lua
client_scripts {
    '@RageUI/lib/RageUI.lua',
    '@RageUI/config.lua',
    '@RageUI/lib/Colors.lua',
    '@RageUI/lib/Menu.lua',
    '@RageUI/lib/Items.lua',
    '@RageUI/lib/Button.lua',
    '@RageUI/lib/Checkbox.lua',
    '@RageUI/lib/List.lua',
    '@RageUI/lib/Slider.lua',
    '@RageUI/lib/Progress.lua',
    '@RageUI/lib/Input.lua',
    '@RageUI/lib/Separator.lua',
    '@RageUI/lib/Header.lua',
    '@RageUI/lib/Badge.lua',
    '@RageUI/lib/ButtonColored.lua',
    '@RageUI/lib/Panels.lua',
    '@RageUI/bridge.lua',

    -- Votre script en dessous :
    'client.lua'
}
```

## 2. Création de la base du menu

Dans votre `client.lua`, commencez par créer la structure de votre menu avec `RageUI.CreateMenu` :

```lua
local mainMenu = RageUI.CreateMenu("Mon Serveur", "Menu Principal")
-- Pour un sous menu :
local subMenu = RageUI.CreateSubMenu(mainMenu, "Options", "Sous-menu")
```

## 3. Le système de rendu (La Boucle)

RageUI v2 nécessite que vous vérifiiez si le menu est ouvert chaque tick (frame).
Pour l'ouverture du menu, il est fortement recommandé d'utiliser `RegisterKeyMapping` au lieu de `IsControlJustPressed`.

```lua
local isOpen = false

-- Commande et touche pour ouvrir (F2 par défaut)
RegisterKeyMapping('mon_menu', 'Ouvrir mon menu serveur', 'keyboard', 'F2')
RegisterCommand('mon_menu', function()
    isOpen = not isOpen
    RageUI.Visible(mainMenu, isOpen)
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Si le menu principal est ouvert, cette fonction s'exécute
        RageUI.IsVisible(mainMenu, function()
            -- PLUS BESOIN de RageUI.Menu.AddItem ! On écrit directement l'élément !
            RageUI.Header('Bienvenue !')
            RageUI.Separator('--- Vos Choix ---')
            RageUI.Line()
            
            RageUI.Button('Ouvrir les options', 'Aller au sous-menu', function()
                RageUI.OpenMenu(subMenu)
            end, '→')
        end)

        -- Rendu du sous-menu
        RageUI.IsVisible(subMenu, function()
            RageUI.Button('Retour', '', function()
                RageUI.CloseMenu(subMenu)
            end)
        end)
    end
end)
```

## 4. Les différents types d'éléments (Items)

L'avantage de cette version est que **les arguments sont beaucoup plus simples** que l'ancienne V1 ! Vous n'avez plus besoin de mettre des tables bizarres `{}, true, {onSelected = function()}`.

### Bouton Simple
```lua
-- Syntaxe: Label, Description, Fonction (Action), TexteDroite, Désactivé(boolean)
RageUI.Button(
    'Mon Premier Bouton', 
    'Description en bas', 
    function()
        print("Bouton cliqué !")
    end, 
    '→'
)
```

### Séparateurs et En-têtes
```lua
RageUI.Separator('--- Options ---')
RageUI.Line() -- Ligne vide
RageUI.Header('Gros Titre Coloré')
```

### Checkbox
Pour les cases à cocher, stockez la variable juste au dessus de la boucle.
```lua
-- Syntaxe: Label, Description, EtatActuel, Fonction(NouvelEtat), Désactivé
RageUI.Checkbox(
    'Mode Passif', 
    'Active le godmode', 
    modePassif, 
    function(checked)
        modePassif = checked
        SetEntityInvincible(PlayerPedId(), checked)
    end
)
```

### Slider (Curseur de 1 à X)
```lua
-- Syntaxe: Label, Description, ValeurActuelle, Minimum, Maximum, Pas, Fonction(NouvelleValeur)
RageUI.Slider(
    'Volume', 
    'Réglez le volume', 
    volume, 
    0, 100, 5,
    function(value)
        volume = value
        print("Nouveau volume : " .. volume)
    end
)
```

### Liste Multichoix
```lua
local villes = { "Los Santos", "Sandy Shores", "Paleto Bay" }
local villeIndex = 1

-- Syntaxe: Label, Description, TableItems, IndexActuel, Fonction(NouvelIndex, ValeurItem)
RageUI.List(
    'Point de départ', 
    'Choisissez votre ville', 
    villes, 
    villeIndex, 
    function(index, value)
        villeIndex = index
        print("Ville : " .. value)
    end
)
```

## 5. Les Notifications

RageUI met à votre disposition deux fonctions pour afficher des notifications à vos joueurs, n'importe où dans vos scripts.

### Notification Classique (Native GTA)
Utilise le système d'origine de GTA en haut au-dessus de la minimap.
```lua
RageUI.Notification("Voici un message ~g~vert~s~ standard !")
```

### Notification NUI (Moderne)
Utilise le design moderne inclus dans cette version de RageUI (qui s'affiche joliment à l'écran).
```lua
-- Syntaxe: Texte, Style ('info', 'success', 'error'), Durée en ms (optionnel)
RageUI.Notify("Action réussie avec succès !", "success")
```

## 📝 Résumé des bonnes pratiques
1. Ne **jamais oublier** d'inclure `@RageUI/bridge.lua` dans votre manifest si vous utilisez la ressource à distance.
2. Utilisez toujours `RageUI.IsVisible(menu, function() ... end)` pour englober la création de vos boutons.
3. Conserver l'état (les variables d'index, de checkbox, de slider) à **l'extérieur** de votre boucle `while true`.
4. Tous vos boutons s'ajouteront **automatiquement** dans le menu actif !

## 6. La Carte d'Identité NUI (ID Card)

RageUI inclut désormais nativement un système d'affichage de **carte d'identité ultra-moderne** (Glassmorphism) à l'écran. 
Pour l'utiliser, assurez-vous d'avoir bien mis `@RageUI/lib/IdCard.lua` dans votre `fxmanifest.lua` !

### Afficher la carte d'identité
La carte disparaîtra d'elle-même après 8 secondes par défaut, ou selon le temps défini en paramètre.
```lua
-- Syntaxe: RageUI.ShowIdCard(Données, TempsEnMs)
RageUI.ShowIdCard({
    firstname = "John",
    lastname = "Doe",
    dob = "01/01/1990",
    sex = "M",
    height = 180
}, 8000) -- Reste affiché 8 secondes
```

### Cacher manuellement la carte d'identité
Si vous avez besoin de cacher la carte avant la fin du temps (par exemple si le joueur ferme le menu).
```lua
RageUI.HideIdCard()
```
