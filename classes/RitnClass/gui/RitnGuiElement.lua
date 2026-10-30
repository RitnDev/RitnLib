-- RitnLibGuiElement
----------------------------------------------------------------
-- FR : Traces de chaque méthode : seulement avec le réglage « Journal de débogage » de RitnLib
-- EN : Traces of each method: only with the RitnLib "Debug log" setting
local other = require(ritnlib.defines.other)
-- CLASSES DEFINES
----------------------------------------------------------------

---**EN**
---
---Description: Fluent builder for a Factorio `LuaGuiElement.add{...}` payload. Every setter returns `self` for chaining; the final `:add(parent)` instantiates the element on a real GUI tree.
---
---The element type name passed to the constructor (e.g. "sprite-button", "text-box") is normalised internally to a short form (e.g. "button", "textbox") used in the `self.gui_name` slug. The original `element_type` is preserved in `self.type` and used as the actual Factorio element type.
---
---⚠ **Known bugs (P0)**:
---- `:text(text)` checks `type(tooltip)` (a non-existent local) instead of `type(text)`. The body therefore never runs.
---- `:verticalScrollPolicy(vsp)` checks `self.hsp_valid[vsp]` instead of a `vsp_valid` table. Works by coincidence since the valid set is identical.
---
---──────────────────────────────
---
---**FR**
---
---Description: Builder fluent pour un payload `LuaGuiElement.add{...}` Factorio. Chaque setter retourne `self` pour le chaînage ; le `:add(parent)` final instancie l'élément sur un vrai arbre GUI.
---
---Le nom de type d'élément passé au constructeur (ex: "sprite-button", "text-box") est normalisé en interne en forme courte (ex: "button", "textbox") utilisée dans le slug `self.gui_name`. Le `element_type` original est préservé dans `self.type` et utilisé comme type d'élément Factorio réel.
---
---⚠ **Bugs connus (P0)** :
---- `:text(text)` teste `type(tooltip)` (un local inexistant) au lieu de `type(text)`. Le corps de la méthode ne s'exécute donc jamais.
---- `:verticalScrollPolicy(vsp)` teste `self.hsp_valid[vsp]` au lieu d'une table `vsp_valid`. Fonctionne par coïncidence car le set valide est identique.
---@class RitnLibGuiElement
---@field object_name "RitnLibGuiElement"           Sentinel read by the custom `util.type()`
---@field gui_name string                           Slug built as `<ui_name>-<normalisedType>-<element_name>`
---@field pattern string                            Regex for parsing back the gui_name into 3 segments
---@field name string                               Element name (constructor arg)
---@field type string                               Factorio element type (constructor arg, NOT the normalised slug)
---@field ui string                                 UI namespace (constructor arg)
---@field action string                             Default action key `<type>-<name>`
---@field hsp "auto"|"never"|"always"|"auto-and-reserve-space"|"dont-show-but-allow-scrolling"  Default horizontal scroll policy ("never")
---@field hsp_valid table<string, true>             Valid scroll-policy values
---@field string_valid table<string, true>          Types accepted for caption/tooltip ("string", "table")
---@field orientation_valid table<string, true>     Types accepting `direction = "horizontal"|"vertical"` (frame, flow, line)
---@field text_valid table<string, true>            Types accepting `text` (textfield, text-box)
---@field button_valid table<string, true>          Types accepting `mouse_button_filter` (button, sprite-button)
---@field sprite_valid table<string, true>          Types accepting `sprite` (sprite, sprite-button)
---@field check_valid table<string, true>           Types with `state` (checkbox, radiobutton)
---@field gui_element table                         The `add{...}` payload being built
---@operator call(string, string, string): RitnLibGuiElement
---@type RitnLibGuiElement
RitnLibGuiElement = ritnlib.classFactory.newclass(function(self, ui_name, element_type, element_name)
    -- GuiElement self
    self.object_name = "RitnLibGuiElement"

    local elementType = element_type
    if element_type == "sprite-button" then elementType = "button" end
    if element_type == "text-box" then elementType = "textbox" end
    if element_type == "list-box" then elementType = "listbox" end
    if element_type == "drop-down" then elementType = "dropdown" end
    if element_type == "choose-elem-button" then elementType = "button" end
    if element_type == "entity-preview" then elementType = "preview" end
    if element_type == "empty-widget" then elementType = "empty" end
    if element_type == "scroll-pane" then elementType = "pane" end
    if element_type == "tabbed-pane" then elementType = "tabbed" end

    self.gui_name = ui_name .. "-" .. elementType .. "-" .. element_name
    self.pattern = "([^-]*)-?([^-]*)-?([^-]*)"
    ----
    self.name = element_name
    self.type = element_type
    self.ui = ui_name
    self.action = element_type .. "-" .. element_name
    ----
    self.hsp = "never"
    self.hsp_valid = {
        auto = true,
        never = true,
        always = true,
        ["auto-and-reserve-space"] = true,
        ["dont-show-but-allow-scrolling"] = true,
    }
    self.string_valid = {
        string = true,
        table = true,
    }
    self.orientation_valid = {
        frame = true,
        flow = true,
        line = true,
    }
    self.text_valid = {
        textfield = true,
        ["text-box"] = true,
    }
    self.button_valid = {
        button = true,
        ["sprite-button"] = true,
    }
    self.sprite_valid = {
        sprite = true,
        ["sprite-button"] = true,
    }
    self.check_valid = {
        checkbox = true,
        radiobutton = true,
    }
    ----
    self.gui_element = {
        type = self.type,
        name = self.gui_name,
        visible = true,
    }

    if element_type == "scroll-pane" then
        self.gui_element.horizontal_scroll_policy = self.hsp
    end
    --------------------------------------------------
end) --[[@as RitnLibGuiElement]]



---**EN**
---
---Description: Adds the built element to `parent` and returns the resulting `LuaGuiElement`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Ajoute l'élément construit à `parent` et retourne le `LuaGuiElement` résultant.
---@param parent LuaGuiElement
---@return LuaGuiElement?
function RitnLibGuiElement:add(parent)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:add('.. parent.name ..')')
    if parent == nil then return end
    return parent.add(self.gui_element)
end

---**EN**
---
---Description: Returns the raw `add{...}` payload without instantiating.
---
---──────────────────────────────
---
---**FR**
---
---Description: Retourne le payload `add{...}` brut sans instancier.
---@return table
function RitnLibGuiElement:get()
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:getGuiElement()')
    return self.gui_element
end


---**EN**
---
---Description: Sets `direction = "horizontal"`. Only effective on frame/flow/line.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `direction = "horizontal"`. Effet seulement sur frame/flow/line.
---@return RitnLibGuiElement self
function RitnLibGuiElement:horizontal()
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:horizontal()')
    if self.orientation_valid[self.type] then
        self.gui_element.direction = "horizontal"
    end
    return self
end

---**EN**
---
---Description: Sets `direction = "vertical"`. Only effective on frame/flow/line.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `direction = "vertical"`. Effet seulement sur frame/flow/line.
---@return RitnLibGuiElement self
function RitnLibGuiElement:vertical()
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:vertical()')
    if self.orientation_valid[self.type] then
        self.gui_element.direction = "vertical"
    end
    return self
end



---**EN**
---
---Description: Sets `auto_center = true`. Frame-only.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `auto_center = true`. Frame uniquement.
---@return RitnLibGuiElement self
function RitnLibGuiElement:autoCenter()
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:autoCenter()')
    if self.type == "frame" then
        self.gui_element.auto_center = true
    end
    return self
end


---**EN**
---
---Description: Sets the element's `visible` flag. No-op if not boolean.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `visible` de l'élément. No-op si pas booléen.
---@param visible boolean
---@return RitnLibGuiElement self
function RitnLibGuiElement:visible(visible)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:visible()')
    if type(visible) ~= "boolean" then return self end

    self.gui_element.visible = visible

    return self
end

---**EN**
---
---Description: Sets the element's `enabled` flag. No-op if not boolean.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le flag `enabled` de l'élément. No-op si pas booléen.
---@param enabled boolean
---@return RitnLibGuiElement self
function RitnLibGuiElement:enabled(enabled)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:enabled()')
    if type(enabled) ~= "boolean" then return self end

    self.gui_element.enabled = enabled

    return self
end

---**EN**
---
---Description: Sets the element's caption. Accepts `LocalisedString` (string or table).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la caption de l'élément. Accepte `LocalisedString` (string ou table).
---@param caption string|table
---@return RitnLibGuiElement self
function RitnLibGuiElement:caption(caption)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:caption()')
    if self.string_valid[type(caption)] then
        self.gui_element.caption = caption
    end

    return self
end

---**EN**
---
---Description: Sets the element's tooltip. Accepts `LocalisedString` (string or table).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la tooltip de l'élément. Accepte `LocalisedString` (string ou table).
---@param tooltip string|table
---@return RitnLibGuiElement self
function RitnLibGuiElement:tooltip(tooltip)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:tooltip()')
    if not self.string_valid[type(tooltip)] then return self end

    self.gui_element.tooltip = tooltip

    return self
end

---**EN**
---
---Description: Sets the element's `tags` (dynamic data read back in the event handlers, e.g. the item of a row).
---Only serialisable values (no function, no Lua object).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les `tags` de l'élément (données dynamiques relues dans les gestionnaires, ex. l'objet d'une ligne).
---Valeurs sérialisables seulement (ni fonction, ni objet Lua).
---@param tags table
---@return RitnLibGuiElement self
function RitnLibGuiElement:tags(tags)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:tags()')
    -- FR : Pas une table : ignoré
    -- EN : Not a table: ignored
    if type(tags) ~= "table" then
        return self
    end

    self.gui_element.tags = tags

    return self
end


---**EN**
---
---Description: Sets `column_count` of a table (creation-only property: it must be in the spec).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `column_count` d'un tableau (propriété de création seulement : elle doit être dans la spec).
---@param count integer   Number of columns (at least 1)
---@return RitnLibGuiElement self
function RitnLibGuiElement:columnCount(count)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:columnCount()')
    -- FR : Pas un tableau, ou nombre invalide : ignoré
    -- EN : Not a table, or invalid count: ignored
    if self.type ~= "table" or type(count) ~= "number" or count < 1 then
        return self
    end

    self.gui_element.column_count = count

    return self
end


---**EN**
---
---Description: Sets the `number` shown in the corner of a sprite-button (e.g. a count or an index).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `number` affiché dans le coin d'un sprite-button (ex. une quantité ou un numéro).
---@param value number
---@return RitnLibGuiElement self
function RitnLibGuiElement:number(value)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:number()')
    -- FR : Pas un sprite-button, ou pas un nombre : ignoré
    -- EN : Not a sprite-button, or not a number: ignored
    if self.type ~= "sprite-button" or type(value) ~= "number" then
        return self
    end

    self.gui_element.number = value

    return self
end


---**EN**
---
---Description: Sets `toggled` of a sprite-button (drawn pressed, e.g. the selected tab of a row of buttons).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `toggled` d'un sprite-button (dessiné enfoncé, ex. l'onglet choisi d'une rangée de boutons).
---@param value? boolean   Default true
---@return RitnLibGuiElement self
function RitnLibGuiElement:toggled(value)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:toggled()')
    -- FR : Pas un sprite-button : ignoré
    -- EN : Not a sprite-button: ignored
    if self.type ~= "sprite-button" then
        return self
    end

    self.gui_element.toggled = value ~= false

    return self
end

---**EN**
---
---Description: Sets the element's `index` (insertion position in parent).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit l'`index` de l'élément (position d'insertion dans le parent).
---@param index integer
---@return RitnLibGuiElement self
function RitnLibGuiElement:index(index)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:index()')
    if type(index) ~= "number" then return self end

    self.gui_element.index = index

    return self
end

---**EN**
---
---Description: Sets the element's text content (textfield / text-box only).
---
---⚠ **Broken (P0)** — body tests `type(tooltip)` (undefined global) instead of `type(text)`. The body never runs in current code.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le contenu texte de l'élément (textfield / text-box uniquement).
---
---⚠ **Cassé (P0)** — corps teste `type(tooltip)` (global indéfini) au lieu de `type(text)`. Le corps ne s'exécute jamais.
---@param text string
---@return RitnLibGuiElement self
function RitnLibGuiElement:text(text)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:text()')
    if type(tooltip) ~= "string" then return self end

    if self.text_valid[self.type] then
        self.gui_element.text = text
    end

    return self
end

---**EN**
---
---Description: Sets the element's `style` (a registered GUI style name).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `style` de l'élément (nom de style GUI enregistré).
---@param style string
---@return RitnLibGuiElement self
function RitnLibGuiElement:style(style)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:style()')
    if type(style) ~= "string" then return self end

    self.gui_element.style = style

    return self
end


---**EN**
---
---Description: Sets the element's sprite (sprite / sprite-button only).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le sprite de l'élément (sprite / sprite-button uniquement).
---@param sprite string
---@return RitnLibGuiElement self
function RitnLibGuiElement:spritePath(sprite)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:spritePath()')
    if type(sprite) ~= "string" then return self end

    if self.sprite_valid[self.type] then
        self.gui_element.sprite = sprite
    end

    return self
end


---**EN**
---
---Description: Sets the horizontal scroll policy. scroll-pane only.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la politique de scroll horizontal. scroll-pane uniquement.
---@param hsp "auto"|"never"|"always"|"auto-and-reserve-space"|"dont-show-but-allow-scrolling"
---@return RitnLibGuiElement self
function RitnLibGuiElement:horizontalScrollPolicy(hsp)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:horizontalScrollPolicy()')
    if type(hsp) ~= "string" then return self end

    if self.hsp_valid[hsp] then
        if self.type == "scroll-pane" then
            self.gui_element.horizontal_scroll_policy = hsp
        end
    end

    return self
end

---**EN**
---
---Description: Sets the vertical scroll policy. scroll-pane only.
---
---⚠ **Bug**: checks `self.hsp_valid[vsp]` instead of a distinct `vsp_valid` set. Functionally OK today (same allowed values).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la politique de scroll vertical. scroll-pane uniquement.
---
---⚠ **Bug** : teste `self.hsp_valid[vsp]` au lieu d'une table `vsp_valid` distincte. Fonctionnellement OK aujourd'hui (mêmes valeurs autorisées).
---@param vsp "auto"|"never"|"always"|"auto-and-reserve-space"|"dont-show-but-allow-scrolling"
---@return RitnLibGuiElement self
function RitnLibGuiElement:verticalScrollPolicy(vsp)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:verticalScrollPolicy()')
    if type(vsp) ~= "string" then return self end

    if self.hsp_valid[vsp] then
        if self.type == "scroll-pane" then
            self.gui_element.vertical_scroll_policy = vsp
        end
    end

    return self
end


---**EN**
---
---Description: Sets `resize_to_sprite`. sprite-type only.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `resize_to_sprite`. type sprite uniquement.
---@param resize boolean
---@return RitnLibGuiElement self
function RitnLibGuiElement:resizeSprite(resize)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:resizeSprite()')
    if type(resize) ~= "boolean" then return self end

    if self.type == "sprite" then
        self.gui_element.resize_to_sprite = resize
    end

    return self
end

---**EN**
---
---Description: Sets the checked state (checkbox / radiobutton). Default `true` if no arg.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit l'état coché (checkbox / radiobutton). Défaut `true` si pas d'argument.
---@param check? boolean
---@return RitnLibGuiElement self
function RitnLibGuiElement:checked(check)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:checked()')
    local state = true
    if check ~= nil then
        if type(check) ~= "boolean" then return self end
        state = check
    end

    if self.check_valid[self.type] then
        self.gui_element.state = state
    end

    return self
end


---**EN**
---
---Description: Sets `value` (0..100) on progressbar. Default 0.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `value` (0..100) sur progressbar. Défaut 0.
---@param value? number
---@return RitnLibGuiElement self
function RitnLibGuiElement:progress(value)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:progress()')
    local valueDefault = 0
    if value ~= nil then
        if type(value) ~= "number" then return self end
        if value > 100 or value < 0 then return self end
        valueDefault = value
    end

    if self.type == "progressbar" then
        self.gui_element.value = valueDefault
    end

    return self
end


---**EN**
---
---Description: Sets the `mouse_button_filter` (button / sprite-button). Default `{"left"}`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `mouse_button_filter` (button / sprite-button). Défaut `{"left"}`.
---@param value? string[]
---@return RitnLibGuiElement self
function RitnLibGuiElement:mouseButtonFilter(value)
    other.debugLog(self.gui_name .. ' > RitnLibGuiElement:mouseButtonFilter()')
    local valueDefault = {'left'}
    if value ~= nil then
        if type(value) ~= "table" then return self end
        valueDefault = value
    end

    if self.button_valid[self.type] then
        self.gui_element.mouse_button_filter = valueDefault
    end

    return self
end

----------------------------------------------------------------
--return RitnLibGuiElement
