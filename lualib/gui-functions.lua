------------------------------------------------------------------------------------
-- Fonction "GUI"
------------------------------------------------------------------------------------


-- Retourne une copie une copie d'un élément "source" dans le default_gui de Factorio

---**EN**
---
---Description: Deep-copies the style table `source` into `data.raw['gui-style'].default[dupl]` and returns the new entry. Data-stage helper used to derive new GUI styles from existing ones.
---
---⚠ No collision check — if `dupl` already exists in `default_gui` it is silently overwritten. Namespace your style names (e.g. with the `SUFFIX` constant).
---
---──────────────────────────────
---
---**FR**
---
---Description: Deep-copie la table de style `source` dans `data.raw['gui-style'].default[dupl]` et retourne la nouvelle entrée. Helper data-stage utilisé pour dériver de nouveaux styles GUI depuis des styles existants.
---
---⚠ Pas de vérification de collision — si `dupl` existe déjà dans `default_gui` il est écrasé silencieusement. Namespace tes noms de styles (ex: avec la constante `SUFFIX`).
---@param dupl string    New style key
---@param source table   Existing style table to copy
---@return table         The newly created style entry
local function copyDefaultGui(dupl, source)
    local default_gui = data.raw['gui-style'].default
    default_gui[dupl] = table.deepcopy(source)
    return default_gui[dupl]
end


-- Convertion en empty-widget

---**EN**
---
---Description: Replaces (or creates) `data.raw['gui-style'].default[dupl]` with a bare `empty_widget_style` (no graphics). Used to visually neutralise a style slot.
---
---──────────────────────────────
---
---**FR**
---
---Description: Remplace (ou crée) `data.raw['gui-style'].default[dupl]` par un `empty_widget_style` nu (sans graphismes). Utilisé pour neutraliser visuellement un slot de style.
---@param dupl string    Style key
---@return table         The newly created style entry
local function convertEmpty(dupl)
    local default_gui = data.raw['gui-style'].default
    default_gui[dupl] = {type = 'empty_widget_style', graphical_set = {}}
    return default_gui[dupl]
end



------------------------------------------------------------------------------------

---**EN**
---
---Description: RitnLib GUI data-stage helpers — used by [`prototypes/gui-style.lua`](../prototypes/gui-style.lua) to build the `*-ritngui` style set.
---
---──────────────────────────────
---
---**FR**
---
---Description: Helpers GUI data-stage de RitnLib — utilisés par [`prototypes/gui-style.lua`](../prototypes/gui-style.lua) pour construire le set de styles `*-ritngui`.
---@class RitnLibGuiFunctions
---@field SUFFIX "-ritngui"                                       Naming suffix for RitnLib-derived styles
---@field copyDefaultGui fun(dupl: string, source: table): table
---@field convertEmpty fun(dupl: string): table
local flib = {}
------------------------------------------------------------------------------------
-- Chargement des fonctions
flib.SUFFIX =  '-ritngui'
flib.copyDefaultGui = copyDefaultGui
flib.convertEmpty = convertEmpty
------------------------------------------------------------------------------------
return flib
------------------------------------------------------------------------------------
