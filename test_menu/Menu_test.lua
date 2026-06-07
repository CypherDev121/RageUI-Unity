local RageUI = RageUI

-- ════════════════════════════════════════════════════════════
--  Menus
-- ════════════════════════════════════════════════════════════
local mainMenu      = nil
local subButtons    = nil
local subCheckbox   = nil
local subSliders    = nil
local subLists      = nil
local subBadges     = nil
local subActions    = nil
local subHeritage   = nil
local isOpen        = false

-- ════════════════════════════════════════════════════════════
--  Création des menus
-- ════════════════════════════════════════════════════════════
Citizen.CreateThread(function()
    mainMenu = RageUI.CreateMenu('RageUI v2', 'Menu de démonstration')
    mainMenu.OnOpen = function() isOpen = true end
    mainMenu.OnClose = function() isOpen = false end

    subButtons = RageUI.CreateSubMenu(mainMenu, 'Boutons', 'Tous les types de boutons')
    subCheckbox = RageUI.CreateSubMenu(mainMenu, 'Checkboxes', 'Options à cocher')
    subSliders = RageUI.CreateSubMenu(mainMenu, 'Sliders', 'Curseurs et progression')
    subLists = RageUI.CreateSubMenu(mainMenu, 'Listes', 'Sélecteurs de liste')
    subBadges = RageUI.CreateSubMenu(mainMenu, 'Badges', 'Icônes et badges')
    subActions = RageUI.CreateSubMenu(mainMenu, 'Actions', 'Commandes serveur')
    subHeritage = RageUI.CreateSubMenu(mainMenu, 'Héritage', 'Création de personnage')

    -- Boucle de rendu
    while true do
        Citizen.Wait(0)

        -- Raccourci clavier (F2 par défaut) pour ouvrir le menu
        -- if IsControlJustPressed(0, RageUI.Config.Keybinds.OpenMenu or 289) then
        --     isOpen = not isOpen
        --     RageUI.Visible(mainMenu, isOpen)
        -- end

        -- ════════════════════════════════════════════════════════════
        --  Menu Principal
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(mainMenu, function()
            RageUI.Header('Navigation')

            RageUI.Button('Boutons', 'Boutons standard, désactivés et colorés', function() RageUI.OpenMenu(subButtons) end, '\u{2192}')
            RageUI.Button('Checkboxes', 'Options à cocher/décocher', function() RageUI.OpenMenu(subCheckbox) end, '\u{2192}')
            RageUI.Button('Sliders', 'Curseurs et barres de progression', function() RageUI.OpenMenu(subSliders) end, '\u{2192}')
            RageUI.Button('Listes', 'Sélecteurs à choix multiples', function() RageUI.OpenMenu(subLists) end, '\u{2192}')
            RageUI.Button('Badges', 'Icônes et indicateurs', function() RageUI.OpenMenu(subBadges) end, '\u{2192}')
            RageUI.Button('Actions', 'Notifications et commandes serveur', function() RageUI.OpenMenu(subActions) end, '\u{2192}')
            RageUI.Button('Héritage', 'Génétique et apparence du personnage', function()
                local model = GetHashKey("mp_m_freemode_01")
                RequestModel(model)
                while not HasModelLoaded(model) do Wait(0) end
                SetPlayerModel(PlayerId(), model)
                SetModelAsNoLongerNeeded(model)
                ApplyHeritage()
                RageUI.OpenMenu(subHeritage) 
            end, '\u{2192}')

            RageUI.Separator('Infos joueur')
            RageUI.Button('Santé', 'Santé actuelle du joueur', nil, GetEntityHealth(PlayerPedId()) .. ' HP')
            RageUI.Button('Armure', 'Armure actuelle du joueur', nil, GetPedArmour(PlayerPedId()) .. '%')
            RageUI.Button('Position', 'Coordonnées actuelles', nil, string.format('%.0f, %.0f', GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y))

            RageUI.Line()
            RageUI.Button('Fermer', 'Ferme le menu', function() RageUI.CloseMenu(mainMenu); isOpen = false end, '\u{2718}')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Boutons
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subButtons, function()
            RageUI.Header('Boutons standard')
            RageUI.Button('Bouton simple', 'Un bouton basique', function() RageUI.Notify('Bouton simple cliqué!') end)
            RageUI.Button('Avec label droite', 'Bouton avec texte à droite', function() RageUI.Notify('Bouton avec label!') end, 'Info')
            RageUI.Button('Action spéciale', 'Déclenche une action spéciale', function() RageUI.Notify('Action spéciale déclenchée!', 'success') end, '\u{26A1}')

            RageUI.Separator('États')
            RageUI.Button('Désactivé', 'Ce bouton est désactivé', nil, nil, true)
            RageUI.Button('Aussi désactivé', 'Un autre bouton désactivé', nil, 'N/A', true)

            RageUI.Separator('Exemples')
            RageUI.Button('Téléportation', 'Se téléporter au spawn', function()
                local ped = PlayerPedId()
                SetEntityCoords(ped, -793.39, 326.38, 210.79, false, false, false, false)
                RageUI.Notify('Téléporté au spawn!', 'success')
            end, 'TP')

            RageUI.Button('Soigner', 'Restaurer la santé à 100%', function()
                SetEntityHealth(PlayerPedId(), 200)
                RageUI.Notify('Santé restaurée!', 'success')
            end, '+HP')

            RageUI.Button('Armure max', 'Ajouter armure complète', function()
                SetPedArmour(PlayerPedId(), 100)
                RageUI.Notify('Armure ajoutée!', 'success')
            end, '+Armure')

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subButtons) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Checkboxes
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subCheckbox, function()
            RageUI.Header('Mode de jeu')
            RageUI.Checkbox('God Mode', 'Activer l\'invincibilité', ConfigTestMenu.prefs.godmode, function(state)
                ConfigTestMenu.prefs.godmode = state
                SetPlayerInvincible(PlayerId(), state)
                RageUI.Notify('God Mode: ' .. (state and 'ON' or 'OFF'), state and 'success' or 'error')
            end)

            RageUI.Checkbox('Invisible', 'Devenir invisible aux autres joueurs', ConfigTestMenu.prefs.invisible, function(state)
                ConfigTestMenu.prefs.invisible = state
                SetEntityVisible(PlayerPedId(), not state, false)
                RageUI.Notify('Invisible: ' .. (state and 'ON' or 'OFF'), state and 'success' or 'error')
            end)

            RageUI.Checkbox('Noclip', 'Voler à travers les murs', ConfigTestMenu.prefs.noclip, function(state)
                ConfigTestMenu.prefs.noclip = state
                RageUI.Notify('Noclip: ' .. (state and 'ON' or 'OFF'), state and 'success' or 'error')
            end)

            RageUI.Separator('Capacités')
            RageUI.Checkbox('Super Jump', 'Sauter plus haut que la normale', ConfigTestMenu.prefs.superJump, function(state)
                ConfigTestMenu.prefs.superJump = state
                SetSuperJumpThisFrame(PlayerId())
                RageUI.Notify('Super Jump: ' .. (state and 'ON' or 'OFF'), state and 'success' or 'error')
            end)

            RageUI.Checkbox('Course rapide', 'Courir plus vite', ConfigTestMenu.prefs.fastRun, function(state)
                ConfigTestMenu.prefs.fastRun = state
                SetRunSprintMultiplierForPlayer(PlayerId(), state and 1.49 or 1.0)
                RageUI.Notify('Course rapide: ' .. (state and 'ON' or 'OFF'), state and 'success' or 'error')
            end)

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subCheckbox) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Sliders
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subSliders, function()
            RageUI.Header('Réglages audio/vidéo')
            RageUI.Slider('Volume', 'Volume général du jeu', ConfigTestMenu.prefs.volume, 0, 100, 5, function(v) ConfigTestMenu.prefs.volume = v end)
            RageUI.Slider('Luminosité', 'Luminosité de l\'écran', ConfigTestMenu.prefs.brightness, 0, 100, 1, function(v) ConfigTestMenu.prefs.brightness = v end)
            RageUI.Slider('Sensibilité', 'Sensibilité de la souris', ConfigTestMenu.prefs.sensitivity, 1, 100, 1, function(v) ConfigTestMenu.prefs.sensitivity = v end)
            RageUI.Slider('FOV', 'Champ de vision', ConfigTestMenu.prefs.fov, 30, 120, 5, function(v) ConfigTestMenu.prefs.fov = v end)

            RageUI.Separator('Progression')
            RageUI.Progress('XP', 'Progression d\'expérience', ConfigTestMenu.prefs.progress, 100, function()
                ConfigTestMenu.prefs.progress = math.min(100, ConfigTestMenu.prefs.progress + 10)
                RageUI.Notify('XP: ' .. ConfigTestMenu.prefs.progress .. '/100', 'info')
            end)
            RageUI.Progress('Rang', 'Progression vers le rang suivant', 67, 100)

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subSliders) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Listes
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subLists, function()
            RageUI.Header('Sélection')
            RageUI.List('Météo', 'Changer la météo du serveur', ConfigTestMenu.weatherList, ConfigTestMenu.prefs.weather, function(i, v)
                ConfigTestMenu.prefs.weather = i
                RageUI.Notify('Météo: ' .. v)
            end)
            RageUI.List('Véhicule', 'Choisir un véhicule à spawner', ConfigTestMenu.vehicleList, ConfigTestMenu.prefs.vehicle, function(i, v)
                ConfigTestMenu.prefs.vehicle = i
                RageUI.Notify('Véhicule: ' .. v)
            end)
            RageUI.List('Arme', 'Choisir une arme', ConfigTestMenu.weaponList, ConfigTestMenu.prefs.weapon, function(i, v)
                ConfigTestMenu.prefs.weapon = i
                RageUI.Notify('Arme: ' .. v)
            end)

            RageUI.Separator('Paramètres')
            RageUI.List('Langue', 'Langue de l\'interface', ConfigTestMenu.languageList, ConfigTestMenu.prefs.language, function(i, v)
                ConfigTestMenu.prefs.language = i
                RageUI.Notify('Langue: ' .. v)
            end)
            RageUI.List('Heure', 'Changer l\'heure du jeu', ConfigTestMenu.timeList, ConfigTestMenu.prefs.time, function(i, v)
                ConfigTestMenu.prefs.time = i
                RageUI.Notify('Heure: ' .. v)
            end)

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subLists) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Badges
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subBadges, function()
            RageUI.Header('Rôles')
            RageUI.Badge('Admin', 'Badge administrateur', 'admin')
            RageUI.Badge('VIP', 'Membre VIP du serveur', 'vip')
            RageUI.Badge('Police', 'Membre des forces de l\'ordre', 'police')

            RageUI.Separator('Icônes')
            RageUI.Badge('C\u{0153}ur', 'Santé du joueur', 'heart')
            RageUI.Badge('\u{00c9}toile', 'Niveau de recherche', 'star')
            RageUI.Badge('Couronne', 'Rang le plus élevé', 'crown')
            RageUI.Badge('Vérifié', 'Joueur vérifié', 'check')
            RageUI.Badge('Musique', 'Lecteur audio', 'music')
            RageUI.Badge('Cadenas', 'Contenu verrouillé', 'lock')

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subBadges) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Actions
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subActions, function()
            RageUI.Header('Notifications')
            RageUI.Button('Classique GTA', 'Affiche une notification native GTA', function() RageUI.Notification('Ceci est une notification classique native GTA ! ~g~Cool~s~ !') end)
            RageUI.Button('Info (NUI)', 'Notification d\'information', function() RageUI.Notify('Ceci est une notification d\'info', 'info') end)
            RageUI.Button('Succès (NUI)', 'Notification de succès', function() RageUI.Notify('Action réussie!', 'success') end)
            RageUI.Button('Erreur (NUI)', 'Notification d\'erreur', function() RageUI.Notify('Une erreur est survenue!', 'error') end)

            RageUI.Separator('Serveur')
            RageUI.Button('Notification serveur', 'Envoie une notification via le serveur', function()
                TriggerServerEvent('RageUI:ServerNotify', {
                    text = 'Message envoyé depuis le menu!',
                    style = 'success'
                })
            end, 'Serveur')
            RageUI.Button('/stats', 'Demander les stats du serveur', function() TriggerServerEvent('RageUI:ValidateCommand', 'stats') end, '>')
            RageUI.Button('/joueurs', 'Liste des joueurs connectés', function() TriggerServerEvent('RageUI:ValidateCommand', 'joueurs') end, '>')

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subActions) end, 'Retour')
        end)

        -- ════════════════════════════════════════════════════════════
        --  Sous-menu : Héritage
        -- ════════════════════════════════════════════════════════════
        RageUI.IsVisible(subHeritage, function()
            RageUI.Header('Génétique')
            RageUI.List('Mère', 'Choix de la mère', ConfigTestMenu.mothers, ConfigTestMenu.prefs.mother, function(i, v)
                ConfigTestMenu.prefs.mother = i
                ApplyHeritage()
            end)
            RageUI.List('Père', 'Choix du père', ConfigTestMenu.fathers, ConfigTestMenu.prefs.father, function(i, v)
                ConfigTestMenu.prefs.father = i
                ApplyHeritage()
            end)

            RageUI.Separator('Ressemblance')
            RageUI.Slider('Ressemblance Visage', '50% = Mixte', ConfigTestMenu.prefs.shapeMix, 0, 100, 5, function(v) 
                ConfigTestMenu.prefs.shapeMix = v 
                ApplyHeritage()
            end)
            RageUI.Slider('Couleur de Peau', '50% = Mixte', ConfigTestMenu.prefs.skinMix, 0, 100, 5, function(v) 
                ConfigTestMenu.prefs.skinMix = v 
                ApplyHeritage()
            end)

            RageUI.Line()
            RageUI.Button('\u{2190} Retour', 'Retour au menu principal', function() RageUI.CloseMenu(subHeritage) end, 'Retour')
        end)
    end
end)

-- Commande pour ouvrir
RegisterCommand('RageUI', function()
    isOpen = not isOpen
    RageUI.Visible(mainMenu, isOpen)
    print("Commande /RageUI exécutée. Menu ouvert : " .. tostring(isOpen))
end, false)

function ApplyHeritage()
    local ped = PlayerPedId()
    local motherID = ConfigTestMenu.motherIDs[ConfigTestMenu.prefs.mother] or 21
    local fatherID = ConfigTestMenu.fatherIDs[ConfigTestMenu.prefs.father] or 0
    
    local shapeMix = ConfigTestMenu.prefs.shapeMix / 100.0
    local skinMix = ConfigTestMenu.prefs.skinMix / 100.0

    SetPedHeadBlendData(
        ped, 
        motherID, fatherID, 0, 
        motherID, fatherID, 0, 
        shapeMix, skinMix, 0.0, 
        false
    )
end
