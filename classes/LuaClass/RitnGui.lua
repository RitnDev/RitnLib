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
---⚠ **Known bugs (P0)** (cf. Phase 2 §D.9):
---- `self.gui = {}` is left empty by the constructor, but `:getElement`, `:on_gui_click`, `:on_gui_selection_state_changed` read `self.gui[1]`. To use this class today, you must extend it and override `self.gui` (see `RitnLibInformatron`).
---- `:on_gui_click` accesses `self.element.valid` without first checking `self.element ~= nil`.
---- The `click = { ui, element, name, action }` table-literal uses 4 global references that don't exist; only the subsequent `click.X = …` assignments give the table content.
---
---⚠ **Implicit contract**: the consumer mod must register a remote interface:
---```lua
---remote.add_interface("<your-mod>", {
---    gui_action_<gui_name> = function(action, event, ...) ... end
---})
---```
---Otherwise `:actionGui` crashes when called.
---
---See: [`temporary-wrappers.md`](../../docs/en/concepts/temporary-wrappers.md), [`gui-pattern.md`](../../docs/en/guides/gui-pattern.md)
---
---──────────────────────────────
---
---**FR**
---
---Description: Base de handler d'événement GUI. Étend `RitnLibPlayer` (hérite de tous ses fields/méthodes). Construite autour d'un event GUI Factorio, dispatche `on_gui_click` / `on_gui_selection_state_changed` via `remote.call(self.mod_name, "gui_action_"..self.gui_name, ...)`.
---
---⚠ Wrapper temporaire. Ne pas stocker dans `storage`. À réinstancier dans chaque handler GUI.
---
---⚠ **Bugs connus (P0)** (cf. Phase 2 §D.9) :
---- `self.gui = {}` reste vide après le constructeur, mais `:getElement`, `:on_gui_click`, `:on_gui_selection_state_changed` lisent `self.gui[1]`. Pour utiliser cette classe aujourd'hui, il faut l'étendre et override `self.gui` (cf. `RitnLibInformatron`).
---- `:on_gui_click` accède à `self.element.valid` sans vérifier d'abord `self.element ~= nil`.
---- Le table-literal `click = { ui, element, name, action }` utilise 4 références globales inexistantes ; seules les assignations `click.X = …` ensuite donnent le contenu de la table.
---
---⚠ **Contrat implicite** : le mod consommateur doit enregistrer une interface remote :
---```lua
---remote.add_interface("<ton-mod>", {
---    gui_action_<gui_name> = function(action, event, ...) ... end
---})
---```
---Sinon `:actionGui` plante à l'appel.
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
---@field gui table                              ⚠ Empty by default — override in subclasses to provide a root LuaGuiElement at index `[1]`
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
---⚠ **Broken** — `self.gui[1]` is nil unless a subclass overrides it. Will return nil or crash when iterating.
---
---──────────────────────────────
---
---**FR**
---
---Description: Récupère un `LuaGuiElement` dans l'arbre GUI en parcourant `self.content[element_type][element_name]` comme un chemin de suffixes préfixés par `self.gui_name`.
---
---⚠ **Cassée** — `self.gui[1]` est nil tant qu'une sous-classe ne l'override pas. Retournera nil ou plantera à l'itération.
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
---⚠ Depends on `:getElement` which is currently broken (see warning above).
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne l'élément sélectionné d'un `list-box` ou `drop-down` identifié par `(element_type, element_name)`.
---
---⚠ Dépend de `:getElement` qui est cassée (cf. warning ci-dessus).
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
---⚠ **Broken** — `self.gui[1]` is nil by default (early return); `self.element.valid` access without nil-check on `self.element`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Handler de clic. Parse `self.element.name` via `self.pattern` en `(ui, element, name)` et dispatche `action = "<element>-<name>"` via `:actionGui`.
---
---⚠ **Cassé** — `self.gui[1]` est nil par défaut (early return) ; accès à `self.element.valid` sans nil-check sur `self.element`.
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
---⚠ **Broken** — same `self.gui[1]` nil issue as `:on_gui_click`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Handler de selection-state-changed pour `list-box` / `drop-down`. Parse le nom d'élément via `self.pattern` et dispatche `action = "<element>-<name>-selection_state_changed"`.
---
---⚠ **Cassé** — même problème `self.gui[1]` nil que `:on_gui_click`.
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
