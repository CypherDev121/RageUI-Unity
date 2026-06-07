# Guide de création du fichier YTD / YTYP pour RageUI

## Structure des fichiers stream

```
stream/
├── rageui.ytd          # Textures du menu (bannière, icônes, etc.)
├── rageui.ytyp         # (Optionnel) Types d'objets pour le menu
└── README_YTD.md       # Ce fichier
```

---

## 1. Création du fichier .ytd avec OpenIV

### Étape 1 : Installation d'OpenIV
1. Télécharge OpenIV depuis https://openiv.com/
2. Installe et ouvre OpenIV en mode "Edit"

### Étape 2 : Création du YTD
1. Va dans **Tools → Edit mods folder**
2. Crée un nouveau dossier `mods/rageui/stream/`
3. Fais un clic droit dans le dossier → **New → OpenIV.ytd**
4. Nomme-le `rageui.ytd`

### Étape 3 : Textures requises

| Nom de texture | Taille | Description |
|---------------|--------|-------------|
| `banner` | 512x128 | Bannière du menu (fond + texte) |
| `header_bg` | 256x64 | Fond de l'en-tête du menu |
| `gradient_bg` | 256x1024 | Fond dégradé du menu |
| `arrow_left` | 32x32 | Flèche gauche pour listes |
| `arrow_right` | 32x32 | Flèche droite pour listes |
| `checkbox_off` | 32x32 | Case à cocher décochée |
| `checkbox_on` | 32x32 | Case à cocher cochée |
| `slider_track` | 128x16 | Piste du slider |
| `slider_thumb` | 16x16 | Curseur du slider |
| `icon_player` | 64x64 | Icône joueur |
| `icon_car` | 64x64 | Icône véhicule |
| `icon_settings` | 64x64 | Icône paramètres |
| `icon_money` | 32x32 | Icône argent |
| `icon_bank` | 32x32 | Icône banque |
| `icon_health` | 32x32 | Icône santé |
| `icon_armor` | 32x32 | Icône armure |
| `icon_star` | 32x32 | Étoile (favori) |
| `icon_lock` | 32x32 | Cadenas (verrouillé) |
| `icon_check` | 32x32 | Coche (validé) |
| `notification_bg` | 512x128 | Fond de notification |
| `menu_glow` | 256x256 | Effet lumineux du menu |

### Étape 4 : Import des textures
1. Dans OpenIV, ouvre `rageui.ytd`
2. Clique sur **Add texture** (ou glisse-dépose des images PNG)
3. Configure chaque texture :
   - Format : **DXT5** (pour transparence) ou **DXT1** (sans transparence)
   - Mipmaps : Activé
   - Filtre : **Default**

### Étape 5 : Export du YTD
1. Fais **File → Save**
2. Copie le fichier dans `resources/rageui/stream/`

---

## 2. Utilisation dans le code Lua

```lua
-- Définir une bannière sur le menu
RageUI.Menu.SetBanner(menu, 'rageui', 'banner')

-- Afficher une texture dans le menu (dans le rendu personnalisé)
DrawSprite('rageui', 'icon_player', x, y, w, h, 0.0, 255, 255, 255, 255)
```

---

## 3. Création des textures via Code (Canvas)

Si tu préfères générer les textures via Lua au runtime :

```lua
function GenerateBannerTexture()
    local txd = CreateRuntimeTxd('rageui_rt')
    local tex = CreateRuntimeTextureFromImage(txd, 'banner', 'imageresult.png')
    return txd, tex
end
```

---

## 4. Ressources utiles

- **YTD Creator** : https://github.com/root-cause/ytd-creator
- **OpenIV** : https://openiv.com/
- **CodeWalker** : https://github.com/dexyfex/CodeWalker (pour .ytyp et .ytd)

---

## 5. Géneration rapide des textures de base (PowerShell)

Tu peux générer des textures par défaut avec ce script PowerShell (nécessite ImageMagick) :

```powershell
# Installer ImageMagick d'abord: winget install ImageMagick.ImageMagick
magick -size 512x128 gradient:'#2d63c8'-'#1a3a7a' banner.png
magick -size 256x64 gradient:'#2d63c8'-'#1a3a7a' header_bg.png
magick -size 32x32 xc:'transparent' -fill white -draw "polygon 4,4 28,16 4,28" arrow_left.png
magick -size 32x32 xc:'transparent' -fill white -draw "polygon 28,4 4,16 28,28" arrow_right.png
```

Ensuite importe les PNGs dans OpenIV pour créer le YTD.
