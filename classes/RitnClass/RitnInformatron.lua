-- RitnLibInformatron
----------------------------------------------------------------
local font = ritnlib.defines.names.font
local stringUtils = require(ritnlib.defines.constants).strings
local flib = require(ritnlib.defines.other)
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Informatron integration wrapper. Extends `RitnLibGui` (inherits all GUI dispatcher fields/methods). Builds on top of an Informatron event payload to render a page's content into the Informatron screen GUI.
---
---Used together with the (currently commented) `informatron_page_content` remote interface in [`core/interfaces.lua`](../../core/interfaces.lua) — that interface is the entry point Informatron calls when the player opens an Informatron page that targets RitnLib.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate per Informatron event.
---
---──────────────────────────────
---
---**FR**
---
---Description: Wrapper d'intégration Informatron. Étend `RitnLibGui` (hérite des fields/méthodes du dispatcher GUI). Construit autour d'un payload d'event Informatron pour rendre le contenu d'une page dans l'écran GUI d'Informatron.
---
---Utilisé conjointement avec l'interface remote `informatron_page_content` (actuellement commentée) dans [`core/interfaces.lua`](../../core/interfaces.lua) — c'est cette interface qu'Informatron appelle quand le joueur ouvre une page Informatron qui cible RitnLib.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier à chaque event Informatron.
---@class RitnLibInformatron : RitnLibGui
---@field object_name "RitnLibInformatron"            Sentinel (overrides RitnLibGui's)
---@field gui_name "informatron"                     Logical GUI name
---@field page_name string?                          Page name being rendered (read from a global `page_name` at construction time)
---@field gui { [1]: LuaGuiElement }                 Single-entry array holding `self.player.gui.screen` (overrides RitnLibGui's empty default)
---@field content table                              Element-tree cache (consumer-populated)
---@field content_origine string[]                   Path of suffixes to walk from `gui[gui_name]` to the actual content root (`main-flow → content-container → content-pane`)
---@field FLAG_PAGE_DISPLAY true                     Constant — returned by `:setPageContent` on success
---@field FLAG_PAGE_NOT_DISPLAY false                Constant — returned by `:setPageContent` when the page can't be rendered
---@operator call(string, EventData): RitnLibInformatron
---@type RitnLibInformatron
RitnLibInformatron = ritnlib.classFactory.newclass(RitnLibGui, function(self, mod_name, informatron_data)
    RitnLibGui.init(self, informatron_data, mod_name, "main-flow")
    self.object_name = "RitnLibInformatron"
    --------------------------------------------------
    self.gui_name = "informatron"
    self.page_name = page_name
    --------------------------------------------------
    self.gui = { self.player.gui.screen }
    --------------------------------------------------
    self.content = {}
    self.content_origine = {
        "main-flow",
        "content-container",
        "content-pane",
    }
    --------------------------------------------------
    self.FLAG_PAGE_DISPLAY = true
    self.FLAG_PAGE_NOT_DISPLAY = false
end) --[[@as RitnLibInformatron]]

----------------------------------------------------------------


-- renvoie l'element souhaitez selon son nom

---**EN**
---
---Description: Retrieves a `LuaGuiElement` from the Informatron page tree by walking `self.gui[self.gui_name]` through `self.content_origine` (main-flow → content-container → content-pane), then by following `self.content[element_type][element_name]` as a path of suffixes prefixed by `self.gui_name`.
---
---⚠ Reads `self.gui[self.gui_name]` (string key) while the constructor stores `self.player.gui.screen` under integer key `[1]`. Returns `nil` early in current usage unless the consumer overrides `self.gui` with a string-keyed table.
---
---──────────────────────────────
---
---**FR**
---
---Description: Récupère un `LuaGuiElement` dans l'arbre de la page Informatron en parcourant `self.gui[self.gui_name]` à travers `self.content_origine` (main-flow → content-container → content-pane), puis en suivant `self.content[element_type][element_name]` comme un chemin de suffixes préfixés par `self.gui_name`.
---
---⚠ Lit `self.gui[self.gui_name]` (clé string) alors que le constructeur stocke `self.player.gui.screen` à la clé entier `[1]`. Retourne `nil` tôt dans l'usage actuel sauf si le consommateur override `self.gui` avec une table à clés string.
---@param element_type string
---@param element_name? string
---@return LuaGuiElement?
function RitnLibInformatron:getElement(element_type, element_name)
    local prefix = self.gui_name .. "-"

    local tmp_content = self.gui[self.gui_name]
    for i, gui in pairs(self.content_origine) do
        if tmp_content[gui] == nil then
            return
        else
            tmp_content = tmp_content[gui]
        end
    end

    local LuaGuiElement = tmp_content

    local element = {}

    -- get element
    if element_name ~= nil then
        element = self.content[element_type][element_name]
    else
        element = self.content[element_type]
    end

    -- build LuaGui
    for _, name in pairs(element) do
        LuaGuiElement = LuaGuiElement[prefix .. name]
    end

    return LuaGuiElement
end


---**EN**
---
---Description: Renders a page's elements into the Informatron content pane. Returns early with the `FLAG_PAGE_NOT_DISPLAY` flag if `self.page_name ~= self.mod_name` or if the walked `self.gui[self.gui_name]` path is broken; otherwise iterates `pageElements`, calling `parent.add(element.gui)` for each.
---
---Each `pageElements[i]` should have `{name, parent, gui}` where `gui` is the `LuaGuiElement.add{...}` payload.
---
---⚠ Returns the global `FLAG_PAGE_DISPLAY` on success (not `self.FLAG_PAGE_DISPLAY`). Likely a typo — the global is undefined so the return value is `nil`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Rend les éléments d'une page dans le content pane d'Informatron. Return tôt avec le flag `FLAG_PAGE_NOT_DISPLAY` si `self.page_name ~= self.mod_name` ou si le chemin `self.gui[self.gui_name]` est cassé ; sinon itère `pageElements`, appelant `parent.add(element.gui)` pour chacun.
---
---Chaque `pageElements[i]` doit avoir `{name, parent, gui}` où `gui` est le payload `LuaGuiElement.add{...}`.
---
---⚠ Retourne le global `FLAG_PAGE_DISPLAY` en cas de succès (pas `self.FLAG_PAGE_DISPLAY`). Probablement un typo — le global est indéfini donc la valeur retournée est `nil`.
---@param pageElements { name: string, parent: string, gui: table }[]
---@return boolean?
function RitnLibInformatron:setPageContent(pageElements)
    if self.page_name ~= self.mod_name then return self.FLAG_PAGE_NOT_DISPLAY or false end
    if self.gui[self.gui_name] == nil then return self.FLAG_PAGE_NOT_DISPLAY or false end
    local tmp_content = self.gui[self.gui_name]
    for i, gui in pairs(self.content_origine) do
        if tmp_content[gui] == nil then
            return self.FLAG_PAGE_NOT_DISPLAY or false
        else
            tmp_content = tmp_content[gui]
        end
    end

    local content = {}
    content["start"] = tmp_content

    for i, element in pairs(pageElements) do
        log("> add GuiElement : " .. element.name .. stringUtils.special["right-arrow-decorator"] .. element.parent)
        content[element.name] = content[element.parent].add(element.gui)
    end

    return FLAG_PAGE_DISPLAY
end
