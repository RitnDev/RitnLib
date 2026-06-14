-- RitnLibGui
----------------------------------------------------------------
local modGui = require("mod-gui")
----------------------------------------------------------------


----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: GUI event handler base. Extends `RitnLibPlayer` (inherits all player fields/methods). Built around a Factorio GUI event and dispatches `on_gui_click` / `on_gui_selection_state_changed` to `remote.call(self.mod_name, "gui_action_"..self.gui_name, ...)`.
---
---⚠ Temporary wrapper. Do not store in `storage`. Re-instantiate inside each GUI event handler.
---
---**Extension contract** — `RitnLibGui` is an abstract base, meant to be subclassed with `ritnlib.classFactory.newclass(RitnLibGui, function(self, event) ... end)`. The base constructor leaves four fields empty **on purpose**; each subclass fills them in its own constructor:
---- `self.gui = { <root LuaGuiElement> }` — e.g. `{ player.gui.center }` or `{ mod_gui.get_button_flow(player) }`. `:getElement`, `:on_gui_click`, `:on_gui_selection_state_changed` walk `self.gui[1]`.
---- `self.gui_name` — logical slug (e.g. "lobby"), prefix of every element name.
---- `self.gui_action = { [gui_name] = { [action] = true, ... } }` — the actions this GUI accepts.
---- `self.content` — element-path lookup used by `:getElement`.
---
---The consumer mod must also register the dispatch interface so `:actionGui` can route clicks:
---```lua
---remote.add_interface("<your-mod>", {
---    gui_action_<gui_name> = function(action, event, ...) ... end,
---})
---```
---See `RitnGuiMenuButton` / `RitnLobbyGuiLobby` in the consumer mods for a complete working subclass.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md), [`gui-pattern.md`](../../docs/en/guides/gui-pattern.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: **Classe de base** de handler d'événement GUI (abstraite — destinée à être étendue). Étend `RitnLibPlayer` (hérite de tous ses fields/méthodes). Construite autour d'un event GUI Factorio, dispatche `on_gui_click` / `on_gui_selection_state_changed` via `remote.call(self.mod_name, "gui_action_"..self.gui_name, ...)`.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler GUI.
---
---**Contrat d'extension** — `RitnLibGui` est une base abstraite, destinée à être étendue avec `ritnlib.classFactory.newclass(RitnLibGui, function(self, event) ... end)`. Le constructeur de base laisse quatre champs vides **volontairement** ; chaque sous-classe les remplit dans son propre constructeur :
---- `self.gui = { <LuaGuiElement racine> }` — ex: `{ player.gui.center }` ou `{ mod_gui.get_button_flow(player) }`. `:getElement`, `:on_gui_click`, `:on_gui_selection_state_changed` parcourent `self.gui[1]`.
---- `self.gui_name` — slug logique (ex: "lobby"), préfixe de chaque nom d'élément.
---- `self.gui_action = { [gui_name] = { [action] = true, ... } }` — les actions acceptées par ce GUI.
---- `self.content` — table de chemins d'éléments utilisée par `:getElement`.
---
---Le mod consommateur doit aussi enregistrer l'interface de dispatch pour que `:actionGui` route les clics :
---```lua
---remote.add_interface("<ton-mod>", {
---    gui_action_<gui_name> = function(action, event, ...) ... end,
---})
---```
---Voir `RitnGuiMenuButton` / `RitnLobbyGuiLobby` dans les mods consommateurs pour une sous-classe complète fonctionnelle.
---
---Voir : [`wrappers-temporaires.md`](../../docs/fr/concepts/wrappers-temporaires.md), [`gui-pattern.md`](../../docs/fr/guides/gui-pattern.md)
---@class RitnLibGui : RitnLibPlayer
---@field object_name "RitnLibGui"               Sentinel read by the custom `util.type()` (overrides `RitnLibPlayer`'s)
---@field mod_name string                        Consuming mod name — used to build `remote.call` target
---@field event EventData                        Original Factorio GUI event payload
---@field element LuaGuiElement?                 The clicked/changed element (from `event.element`)
---@field gui_action table<string, table<string, true>>  Map of `[gui_name][action]` registered by the consumer
---@field content table                          Element-tree lookup cache (`self.content[type][name] = path[]`)
---@field gui_name string                        Logical GUI name (e.g. "informatron")
---@field main_gui string?                       Root GUI element name suffix
---@field gui table                              Filled by each subclass: `self.gui[1]` must be the root LuaGuiElement (extension contract)
---@field list_valid table<string, true>         Element types accepted by `:on_gui_selection_state_changed` (listbox, dropdown)
---@field pattern string                         Regex for splitting element names into `ui`/`element`/`name` triplet
---@operator call(EventData, string, string?): RitnLibGui
---@type RitnLibGui
RitnLibGui = ritnlib.classFactory.newclass(RitnLibPlayer, function(self, event, mod_name, main_gui)
    local LuaPlayer = RitnLibEvent(event).player
    if mod_name == nil then log('not mod_name !') return end

    RitnLibPlayer.init(self, LuaPlayer)

    self.object_name = "RitnLibGui"
    self.mod_name = mod_name
    self.event = event
    --------------------------------------------------
    self.element = RitnLibEvent(event).element
    self.gui_action = {}
    self.content = {}
    self.gui_name = ""
    self.main_gui = main_gui
    ----
    self.gui = {
        --screen = LuaPlayer.gui.screen,
        --center = LuaPlayer.gui.center,
        --top = modGui.get_button_flow(LuaPlayer),
        --left = modGui.get_frame_flow(LuaPlayer),
        --goal = LuaPlayer.gui.goal,
    }
    ----
    self.list_valid = {
        ["listbox"] = true,
        ["dropdown"] = true,
    }
    ----
    self.pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    --------------------------------------------------
end) --[[@as RitnLibGui]]

----------------------------------------------------------------


---**EN**
---
---Description: Returns a fresh `RitnLibEvent` wrapping the original event payload.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne un `RitnLibEvent` neuf encapsulant le payload d'event original.
---@return RitnLibEvent
function RitnLibGui:getEvent()
    return RitnLibEvent(self.event)
end


---**EN**
---
---Description: Sets the `main_gui` root element name. No-op if `main_gui` isn't a string.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le nom de l'élément racine `main_gui`. No-op si `main_gui` n'est pas une string.
---@param main_gui string
---@return RitnLibGui self  Chainable
function RitnLibGui:setMainGui(main_gui)
    if type(main_gui) ~= "string" then return self end
    self.main_gui = main_gui
    return self
end



---**EN**
---
---Description: Retrieves a `LuaGuiElement` from the GUI tree by walking `self.content[element_type][element_name]` as a path of suffixes prefixed by `self.gui_name`.
---
---⚠ Relies on the extension contract: the subclass must have set `self.gui[1]` (root element) and `self.content`. Returns nil if the path doesn't resolve.
---
---──────────────────────────────
---
---**FR**
---
---Description: Récupère un `LuaGuiElement` dans l'arbre GUI en parcourant `self.content[element_type][element_name]` comme un chemin de suffixes préfixés par `self.gui_name`.
---
---⚠ Repose sur le contrat d'extension : la sous-classe doit avoir défini `self.gui[1]` (élément racine) et `self.content`. Retourne nil si le chemin ne résout pas.
---@param element_type string
---@param element_name? string
---@return LuaGuiElement?
function RitnLibGui:getElement(element_type, element_name)
    local prefix = self.gui_name .. "-"
    local LuaGui = self.gui[1]
    local element = {}

    -- get element
    if element_name ~= nil then
        element = self.content[element_type][element_name]
    else
        element = self.content[element_type]
    end

    -- build LuaGui
    for _,name in pairs(element) do
        LuaGui = LuaGui[prefix..name]
    end

    return LuaGui
end


---**EN**
---
---Description: Returns the currently-selected item of a `list-box` or `drop-down` element identified by `(element_type, element_name)`.
---
---⚠ Like `:getElement`, relies on the subclass having set `self.gui[1]` / `self.content`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne l'élément sélectionné d'un `list-box` ou `drop-down` identifié par `(element_type, element_name)`.
---
---⚠ Comme `:getElement`, repose sur le fait que la sous-classe a défini `self.gui[1]` / `self.content`.
---@param element_type string
---@param element_name string
---@return string?  The selected item caption, or nil if no selection / invalid list
function RitnLibGui:getListSelectedItem(element_type, element_name)
    log('> '..self.object_name..':getListSelectedItem('.. tostring(element_type) .. ', ' .. tostring(element_name) ..')')
    if type(element_type) ~= 'string' then
        log('element_type is not a string')
        return
    end
    if type(element_name) ~= 'string' then
        log('element_name is not a string')
        return
    end

    local list = self:getElement(element_type, element_name)

    -- verifications
    if list == nil then log('getElement is nil') return end
    if list.valid == false then log('list is not valid') return end
    if list.type ~= 'list-box' and list.type ~= 'drop-down' then
        log('list is not list-box or drop-down => ' .. tostring(list.type))
        return
    end

    local selected_index = list.selected_index

    -- On vérifie qu'il y a bien un élément sélectionné
    if selected_index == nil then return nil end
    if selected_index == 0 then return nil end
    log('selected_index == ' .. tostring(selected_index))

    return list.get_item(selected_index)
end



---**EN**
---
---Description: Dispatches an action via `remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)`. No-op if the action isn't registered in `self.gui_action[self.gui_name]`.
---
---⚠ **Implicit contract**: the consumer mod must `remote.add_interface(mod_name, { gui_action_<gui_name> = function(action, event, ...) ... end })`. Otherwise the `remote.call` raises.
---
---──────────────────────────────
---
---**FR**
---
---Description: Dispatche une action via `remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)`. No-op si l'action n'est pas enregistrée dans `self.gui_action[self.gui_name]`.
---
---⚠ **Contrat implicite** : le mod consommateur doit `remote.add_interface(mod_name, { gui_action_<gui_name> = function(action, event, ...) ... end })`. Sinon le `remote.call` lève une exception.
---@param action string
---@param ... any
---@return RitnLibGui self  Chainable
function RitnLibGui:actionGui(action, ...)
    if self.gui_action[self.gui_name] == nil then return self end
    if self.gui_action[self.gui_name][action] == nil then return self end
    log('> '.. self.object_name ..':actionGui('.. action..')')

    -- it's necessary to create the interface functions for operation.
    remote.call(self.mod_name, "gui_action_"..self.gui_name, action, self.event, ...)

    return self
end



---**EN**
---
---Description: Click handler. Parses `self.element.name` via `self.pattern` into `(ui, element, name)` and dispatches `action = "<element>-<name>"` via `:actionGui`.
---
---⚠ Relies on the extension contract (`self.gui[1]` set by the subclass). Returns early and harmlessly when the GUI isn't the one this handler owns. Designed to be called from the mod's `on_gui_click` event, where `event.element` is always present.
---
---──────────────────────────────
---
---**FR**
---
---Description: Handler de clic. Parse `self.element.name` via `self.pattern` en `(ui, element, name)` et dispatche `action = "<element>-<name>"` via `:actionGui`.
---
---⚠ Repose sur le contrat d'extension (`self.gui[1]` défini par la sous-classe). Retourne tôt et sans dommage quand le GUI n'est pas celui géré par ce handler. Conçue pour être appelée depuis l'event `on_gui_click` du mod, où `event.element` est toujours présent.
---@param ... any
function RitnLibGui:on_gui_click(...)
    if not self.element.valid then return end
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then --[[ log('not gui !') ]] return end


    local LuaGui = self.gui[1][self.gui_name .. "-" .. self.main_gui]
    local click = {
        ui, element, name, action
    }

    -- getGui
    if LuaGui == nil then return end
    --log('> ('..self.mod_name..') -> '.. self.object_name ..':on_gui_click('.. self.gui_name ..", " .. self.main_gui ..')')

    if LuaGui.name ~= self.gui_name .. "-" .. self.main_gui then return end
    if self.element == nil then return end
    if self.element.valid == false then return end

    -- récupération des informations lors du clique
    click.ui, click.element, click.name = string.match(self.element.name, self.pattern)
    click.action = click.element .. "-" .. click.name

    -- Actions
    if click.ui == self.gui_name then
        self:actionGui(click.action, ...)
    end

end



---**EN**
---
---Description: Selection-state-changed handler for `list-box` / `drop-down`. Parses the element name via `self.pattern` and dispatches `action = "<element>-<name>-selection_state_changed"`.
---
---⚠ Same extension contract as `:on_gui_click` (`self.gui[1]` set by the subclass; called from the mod's `on_gui_selection_state_changed` event).
---
---──────────────────────────────
---
---**FR**
---
---Description: Handler de selection-state-changed pour `list-box` / `drop-down`. Parse le nom d'élément via `self.pattern` et dispatche `action = "<element>-<name>-selection_state_changed"`.
---
---⚠ Même contrat d'extension que `:on_gui_click` (`self.gui[1]` défini par la sous-classe ; appelée depuis l'event `on_gui_selection_state_changed` du mod).
---@param ... any
function RitnLibGui:on_gui_selection_state_changed(...)
    if not self.element.valid then log('element invalid !') return end
    if self.main_gui == nil then log('not main_gui !') return end
    if self.main_gui == "" then log('not main_gui !') return end
    if self.gui[1] == nil then --[[ log('not gui !') ]] return end


    local LuaGui = self.gui[1][self.gui_name .. "-" .. self.main_gui]
    local list = {
        ui, element, name, action
    }

    -- getGui
    if LuaGui == nil then return end
    if LuaGui.name ~= self.gui_name .. "-" .. self.main_gui then return end
    if self.element == nil then return end
    if self.element.valid == false then return end

    -- récupération des informations lors du clique
    list.ui, list.element, list.name = string.match(self.element.name, self.pattern)
    list.action = list.element .. "-" .. list.name .. "-selection_state_changed"


    if self.list_valid[list.element] then
    else
        log('element invalid !')
        return
    end

    -- Actions
    if list.ui == self.gui_name then
        self:actionGui(list.action, ...)
    end

end



------------------------------------------------------------
--return RitnLibGui
