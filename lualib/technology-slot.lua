---------------------------------------------------------------------------------------------
-- LUALIB : TECHNOLOGY SLOT
---------------------------------------------------------------------------------------------
-- FR : Tuile de technologie comme la liste du jeu (case colorée selon l'état, icône, bande des packs de science ou
--      du déclencheur), en bouton cliquable d'un mod. Styles technology-slot-*-ritngui et
--      technology-ingredients-ritngui (prototypes/gui-style.lua, à charger dans le data.lua du mod).
--      Étape control uniquement.
-- EN : Technology tile like the game list (slot coloured by state, icon, band of the science packs or of the
--      trigger), as a clickable mod button. Styles technology-slot-*-ritngui and technology-ingredients-ritngui
--      (prototypes/gui-style.lua, to load from the mod data.lua). Control stage only.
---------------------------------------------------------------------------------------------

-- FR : Taille d'une tuile (celle du jeu), de son icône, d'une icône de pack
-- EN : Size of a tile (the game one), of its icon, of a pack icon
local WIDTH = 72
local HEIGHT = 100
local ICON = 64
local PACK = 16

-- FR : Le jeu place l'enfant d'un bouton à 4 px du bord (les marges négatives n'y changent rien) : contenu réduit à
--      l'intérieur de la tuile
-- EN : The game places the child of a button 4 px from the edge (negative margins change nothing): content shrunk
--      to the inside of the tile
local INSET = 4


---**EN**
---
---Description: Name of an item, fluid or entity given as a name or as a prototype.
---
---──────────────────────────────
---
---**FR**
---
---Description: Nom d'un objet, fluide ou entité donné en nom ou en prototype.
---@param value string|table|nil
---@return string
local function nameOf(value)
    if type(value) == "table" then
        return value.name
    end
    return value or ""
end


---**EN**
---
---Description: State of a technology, as the colour of its tile: "researched" (green), "available" (yellow: every
---prerequisite researched) or "unavailable" (red).
---
---──────────────────────────────
---
---**FR**
---
---Description: État d'une technologie, comme la couleur de sa tuile : "researched" (vert), "available" (jaune :
---tous les prérequis recherchés) ou "unavailable" (rouge).
---@param technology LuaTechnology
---@return "researched"|"available"|"unavailable"
local function state(technology)
    if technology.researched then
        return "researched"
    end
    for _, prerequisite in pairs(technology.prerequisites) do
        if not prerequisite.researched then
            return "unavailable"
        end
    end
    return "available"
end


---**EN**
---
---Description: Sprite path and count of the trigger of a trigger technology (e.g. "item/iron-plate", 50);
---"utility/warning_icon" for a trigger without an object.
---
---──────────────────────────────
---
---**FR**
---
---Description: Chemin du sprite et quantité du déclencheur d'une technologie à déclencheur
---(ex. « item/iron-plate », 50) ; « utility/warning_icon » pour un déclencheur sans objet.
---@param trigger table   ResearchTrigger (LuaTechnologyPrototype.research_trigger)
---@return string sprite
---@return number? count
local function triggerSprite(trigger)
    local kind = trigger.type
    if kind == "craft-item" or kind == "send-item-to-orbit" then
        return "item/" .. nameOf(trigger.item), trigger.count
    end
    if kind == "craft-fluid" then
        return "fluid/" .. nameOf(trigger.fluid), trigger.amount
    end
    if kind == "mine-entity" then
        local first = trigger.entities and trigger.entities[1] or trigger.entity
        return "entity/" .. nameOf(first), nil
    end
    if (kind == "build-entity" or kind == "capture-spawner") and trigger.entity ~= nil then
        return "entity/" .. nameOf(trigger.entity), nil
    end
    return "utility/warning_icon", nil
end


---**EN**
---
---Description: Sprite paths of the band at the bottom of a tile: the science packs of the technology, or its
---trigger.
---
---──────────────────────────────
---
---**FR**
---
---Description: Chemins des sprites de la bande en bas d'une tuile : les packs de science de la technologie, ou son
---déclencheur.
---@param technology LuaTechnology
---@return string[]
local function icons(technology)
    local trigger = technology.prototype.research_trigger
    if trigger ~= nil then
        local sprite = triggerSprite(trigger)
        return { sprite }
    end
    local list = {}
    for _, ingredient in pairs(technology.research_unit_ingredients) do
        list[#list + 1] = "item/" .. ingredient.name
    end
    return list
end


---**EN**
---
---Description: Adds a technology tile to `parent` and returns its button. `slot` gives what to draw (see `state`
---and `icons`), so that a mod can build tiles from data kept outside the technology. Element names:
---`<gui_name>-button-<name>`, children `<name>_content`, `<name>_icon`, `<name>_band`, `<name>_pack_<n>`; the
---children are ignored by the mouse (the whole tile is the button).
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute une tuile de technologie dans `parent` et renvoie son bouton. `slot` donne ce qu'il faut
---dessiner (voir `state` et `icons`), pour qu'un mod puisse construire des tuiles à partir de données gardées hors
---de la technologie. Noms des éléments : `<gui_name>-button-<name>`, enfants `<name>_content`, `<name>_icon`,
---`<name>_band`, `<name>_pack_<n>` ; les enfants sont ignorés par la souris (toute la tuile est le bouton).
---@param parent LuaGuiElement
---@param gui_name string   Names prefix, prefixed by the mod
---@param name string       Name part of the button (no "-")
---@param slot { sprite: string, state: string, icons: string[], selected?: boolean, tags?: table }   sprite = "technology/<name>"
---@return LuaGuiElement button
local function add(parent, gui_name, name, slot)
    local button = parent.add(RitnLibGuiElement(gui_name, "sprite-button", name)
        :toggled(slot.selected == true)
        :tags(slot.tags or {})
        :style("technology-slot-" .. slot.state .. "-ritngui")
        :get())
    RitnLibStyle(button):size(WIDTH, HEIGHT)

    -- FR : Contenu à l'intérieur de la tuile : icône en haut, bande en bas
    -- EN : Content inside the tile: icon at the top, band at the bottom
    local inner_width = WIDTH - 2 * INSET
    local content = button.add(RitnLibGuiElement(gui_name, "flow", name .. "_content"):vertical():get())
    content.ignored_by_interaction = true
    RitnLibStyle(content):size(inner_width, HEIGHT - 2 * INSET):align("center", "top"):verticalSpacing(0):padding(0)
    local icon = content.add(RitnLibGuiElement(gui_name, "sprite", name .. "_icon"):spritePath(slot.sprite):resizeSprite(false):get())
    RitnLibStyle(icon):size(ICON, ICON)
    icon.style.stretch_image_to_widget_size = true
    RitnLibStyle(content.add(RitnLibGuiElement(gui_name, "empty-widget", name .. "_space"):get())):verticalStretch()

    -- FR : Bande des packs (ou du déclencheur), icônes de 16 px centrées par le style
    -- EN : Band of the packs (or of the trigger), 16 px icons centred by the style
    local band = content.add(RitnLibGuiElement(gui_name, "frame", name .. "_band"):horizontal():style("technology-ingredients-ritngui"):get())
    RitnLibStyle(band):width(inner_width)
    for position, sprite in ipairs(slot.icons) do
        local pack = band.add(RitnLibGuiElement(gui_name, "sprite", name .. "_pack_" .. position):spritePath(sprite):resizeSprite(false):get())
        RitnLibStyle(pack):size(PACK, PACK)
        pack.style.stretch_image_to_widget_size = true
    end
    return button
end


---**EN**
---
---Description: Technology tile helpers (control stage): state, band icons, trigger sprite, tile builder, tile size.
---
---──────────────────────────────
---
---**FR**
---
---Description: Fonctions des tuiles de technologie (étape control) : état, icônes de la bande, sprite du
---déclencheur, construction d'une tuile, taille d'une tuile.
---@class RitnLibTechnologySlot
---@field WIDTH integer    Tile width (72)
---@field HEIGHT integer   Tile height (100)
---@field state fun(technology: LuaTechnology): "researched"|"available"|"unavailable"
---@field icons fun(technology: LuaTechnology): string[]
---@field triggerSprite fun(trigger: table): string, number?
---@field add fun(parent: LuaGuiElement, gui_name: string, name: string, slot: table): LuaGuiElement
---@type RitnLibTechnologySlot
local technologySlot = {
    WIDTH = WIDTH,
    HEIGHT = HEIGHT,
    state = state,
    icons = icons,
    triggerSprite = triggerSprite,
    add = add,
}

return technologySlot
