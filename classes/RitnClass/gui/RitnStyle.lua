-- RitnLibStyle
----------------------------------------------------------------
local color = require("__RitnLib__.core.constants").color
----------------------------------------------------------------

---**EN**
---
---Description: Fluent helper to mutate a `LuaStyle` on an existing `LuaGuiElement`. Every setter returns `self` for chaining. Provides both atomic setters (width, height, padding) and preset templates (smallButton, frame, listbox…).
---
---⚠ **Known bugs (P0)**:
---- `:straitFrame()` calls `self:standardFrame()` which doesn't exist on the class. Crashes immediately.
---- `:visible(bool)` logs `self.gui_name .. ...` but `self.gui_name` is never defined on `RitnLibStyle`. Crashes on the concatenation (`attempt to concatenate a nil value`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Helper fluent pour muter un `LuaStyle` sur un `LuaGuiElement` existant. Chaque setter retourne `self` pour le chaînage. Fournit des setters atomiques (width, height, padding) et des presets (smallButton, frame, listbox…).
---
---⚠ **Bugs connus (P0)** :
---- `:straitFrame()` appelle `self:standardFrame()` qui n'existe pas sur la classe. Plante immédiatement.
---- `:visible(bool)` log `self.gui_name .. ...` mais `self.gui_name` n'est jamais défini sur `RitnLibStyle`. Plante sur la concaténation (`attempt to concatenate a nil value`).
---@class RitnLibStyle
---@field object_name "RitnLibStyle"           Sentinel read by the custom `util.type()`
---@field style LuaStyle                       The wrapped `LuaGuiElement.style` reference
---@field stretch boolean                      Internal toggle reused across `:horizontalStretch` / `:verticalStretch` (defaults to true)
---@field visible boolean                      Initial visibility state (default false) — independent from `:visible(...)` setter
---@field center "center"                      Constant string used as default align value
---@field color table                          Reference to `core/constants.lua::color` palette
---@field alignH string                        Current horizontal alignment (default "center")
---@field alignV string                        Current vertical alignment (default "center")
---@operator call(LuaGuiElement): RitnLibStyle
---@type RitnLibStyle
RitnLibStyle = ritnlib.classFactory.newclass(function(self, LuaGuiElement)
    if LuaGuiElement == nil then return end
    if LuaGuiElement.object_name ~= "LuaGuiElement" then return end

    self.object_name = "RitnLibStyle"
    self.style = LuaGuiElement.style
    ----
    self.stretch = true
    self.visible = false
    self.center = "center"
    ----
    self.color = color
    ----
    self.alignH = self.center
    self.alignV = self.center
    --------------------------------------------------
end) --[[@as RitnLibStyle]]



---**EN**
---
---Description: Preset: label (minimal_height = 25).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : label (minimal_height = 25).
---@return RitnLibStyle self
function RitnLibStyle:label()
    self.style.minimal_height = 25
    return self
end


---**EN**
---
---Description: Preset: scroll-pane (minimal_height = 220, horizontally_stretchable).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : scroll-pane (minimal_height = 220, horizontally_stretchable).
---@return RitnLibStyle self
function RitnLibStyle:scrollpane()
    self.style.minimal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


---**EN**
---
---Description: Preset: listbox (min+max_height = 220, horizontally_stretchable).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : listbox (min+max_height = 220, horizontally_stretchable).
---@return RitnLibStyle self
function RitnLibStyle:listbox()
    self.style.minimal_height = 220
    self.style.maximal_height = 220
    self.style.horizontally_stretchable = self.stretch
    return self
end


---**EN**
---
---Description: Preset: small button (height = 30, min_width = 90, max_width = 100).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : petit bouton (height = 30, min_width = 90, max_width = 100).
---@return RitnLibStyle self
function RitnLibStyle:smallButton()

    self.style.height = 30
    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_width = 90
    self.style.maximal_width = 100

    return self
end

---**EN**
---
---Description: Preset: normal button (min_height = 45, min_width = 200).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : bouton normal (min_height = 45, min_width = 200).
---@return RitnLibStyle self
function RitnLibStyle:normalButton()

    self.style.horizontally_stretchable = self.stretch
    self.style.minimal_height = 45
    self.style.minimal_width = 200

    return self
end

---**EN**
---
---Description: Preset: menu button (normalButton + min_width = 220 + dark grey font).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : bouton menu (normalButton + min_width = 220 + police gris foncé).
---@return RitnLibStyle self
function RitnLibStyle:menuButton()
    self:normalButton()
    self.style.minimal_width = 220
    self.style.font_color = self.color.darkgrey
    self.style.hovered_font_color = self.color.darkgrey
    self.style.clicked_font_color = self.color.darkgrey

    return self
end


---**EN**
---
---Description: Sets the font_color, optionally also for the hovered/clicked states.
---
---⚠ The first param shadows the upvalue `color` constants table; reading `self.color[color]` works because `color` here is the parameter (a string lookup key).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le font_color, optionnellement aussi pour les états hovered/clicked.
---
---⚠ Le premier param shadow l'upvalue `color` (la table de constantes) ; la lecture `self.color[color]` fonctionne car `color` ici est le paramètre (une clé string).
---@param color string|table  Either a key into `self.color` (e.g. "white", "darkgrey") or a `{r,g,b,a}` table
---@param hovered? boolean    If true, also apply to `hovered_font_color`
---@param clicked? boolean    If true, also apply to `clicked_font_color`
---@return RitnLibStyle self
function RitnLibStyle:fontColor(color, hovered, clicked)
    local defaultColor = self.color.white
    local optHovered = false
    local optClicked = false

    if type(color) == "string" then
        if self.color[color] then
            defaultColor = self.color[color]
        end
    elseif type(color) == "table" then
        defaultColor = color
    else
        return self
    end

    self.style.font_color = defaultColor

    if hovered ~= nil and type(hovered) == "boolean" then
        optHovered = hovered
    end
    if clicked ~= nil and type(clicked) == "boolean" then
        optClicked = clicked
    end

    if optHovered then
        self.style.hovered_font_color = defaultColor
    end
    if optClicked then
        self.style.clicked_font_color = defaultColor
    end

    return self
end


---**EN**
---
---Description: Preset: sprite button. Sets square dimensions from `size` (number or `{w,h}` table). Default 32.
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : sprite button. Définit des dimensions carrées depuis `size` (number ou table `{w,h}`). Défaut 32.
---@param size? number|number[]
---@return RitnLibStyle self
function RitnLibStyle:spriteButton(size)

    local default_size = 32
    if type(size) == "number" then
        if size ~= nil then default_size = size end
    end
    local width = default_size
    local height = default_size

    if type(size) == "table" then
        width = size[1]
		height = size[2]
    end

    self.style.padding = 0
    self.style.minimal_width = width
    self.style.maximal_width = width
    self.style.minimal_height = height
    self.style.maximal_height = height

    return self
end

---**EN**
---
---Description: Preset: close button (smallButton + width = 100).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : bouton de fermeture (smallButton + width = 100).
---@return RitnLibStyle self
function RitnLibStyle:closeButton()

    self:smallButton()
    self.style.width = 100

    return self
end

---**EN**
---
---Description: Preset: standard frame (paddings + max_height = 338 + max_width = 220).
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : frame standard (paddings + max_height = 338 + max_width = 220).
---@return RitnLibStyle self
function RitnLibStyle:frame()

    self.style.left_padding = 4
    self.style.right_padding = 4
    self.style.bottom_padding = 4
    self.style.maximal_height = 338
    self.style.maximal_width = 220

    return self
end

---**EN**
---
---Description: Preset: strait frame (was meant to extend a `standardFrame()` preset).
---
---⚠ **Broken (P0)** — calls `self:standardFrame()` which doesn't exist on this class. Will raise. Probably meant `self:frame()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Preset : strait frame (devait étendre un preset `standardFrame()`).
---
---⚠ **Cassée (P0)** — appelle `self:standardFrame()` qui n'existe pas sur cette classe. Lève une exception. Devait probablement appeler `self:frame()`.
---@return RitnLibStyle self
function RitnLibStyle:straitFrame()
    self:standardFrame()
    self.style.minimal_width = 220
    self.style.maximal_height = 310

    return self
end


---**EN**
---
---Description: Sets `style.visible`.
---
---⚠ **Broken (P0)** — log line concatenates `self.gui_name` which is never defined on `RitnLibStyle`. Will raise on first call.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `style.visible`.
---
---⚠ **Cassée (P0)** — le log concatène `self.gui_name` qui n'est jamais défini sur `RitnLibStyle`. Lève une exception au premier appel.
---@param visible boolean
---@return RitnLibStyle self
function RitnLibStyle:visible(visible)
    log(self.gui_name .. ' > RitnLibStyle:visible()')
    if type(visible) ~= "boolean" then return self end

    self.style.visible = visible

    return self
end


---**EN**
---
---Description: Sets `padding = 0`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `padding = 0`.
---@return RitnLibStyle self
function RitnLibStyle:noPadding()
    self.style.padding = 0

    return self
end

---**EN**
---
---Description: Shortcut: applies `:horizontalStretch()` + `:verticalStretch()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci : applique `:horizontalStretch()` + `:verticalStretch()`.
---@return RitnLibStyle self
function RitnLibStyle:stretchable()

    self:horizontalStretch()
    self:verticalStretch()

    return self
end

---**EN**
---
---Description: Sets `horizontally_stretchable`. Reads/updates `self.stretch` if `value` is boolean, then resets `self.stretch = true`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `horizontally_stretchable`. Lit/met à jour `self.stretch` si `value` est booléen, puis reset `self.stretch = true`.
---@param value? boolean
---@return RitnLibStyle self
function RitnLibStyle:horizontalStretch(value)
    if value ~= nil then
        if type(value) == "boolean" then
            self.stretch = value
        end
    end

    self.style.horizontally_stretchable = self.stretch

    self.stretch = true
    return self
end

---**EN**
---
---Description: Sets `vertically_stretchable`. Same semantics as `:horizontalStretch`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `vertically_stretchable`. Mêmes sémantiques que `:horizontalStretch`.
---@param value? boolean
---@return RitnLibStyle self
function RitnLibStyle:verticalStretch(value)
    if value ~= nil then
        if type(value) == "boolean" then
            self.stretch = value
        end
    end

    self.style.vertically_stretchable = self.stretch

    self.stretch = true
    return self
end


---**EN**
---
---Description: Sets `horizontal_spacing`. Number-only; no-op otherwise.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `horizontal_spacing`. Number uniquement ; no-op sinon.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:horizontalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.horizontal_spacing = value

    return self
end

---**EN**
---
---Description: Sets `vertical_spacing`. Number-only; no-op otherwise.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `vertical_spacing`. Number uniquement ; no-op sinon.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:verticalSpacing(value)
    if value == nil then return self end
    if type(value) ~= "number" then return self end

    self.style.vertical_spacing = value

    return self
end

---**EN**
---
---Description: Sets both horizontal and vertical spacing.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit l'espacement horizontal et vertical.
---@param horizontal number
---@param vertical number
---@return RitnLibStyle self
function RitnLibStyle:spacing(horizontal, vertical)
    self:horizontalSpacing(horizontal)
    self:verticalSpacing(vertical)
    return self
end


---**EN**
---
---Description: Sets `horizontal_align` and `vertical_align`. Defaults to current `self.alignH`/`self.alignV` ("center").
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `horizontal_align` et `vertical_align`. Défauts : `self.alignH`/`self.alignV` ("center").
---@param valueH? string  e.g. "left", "center", "right"
---@param valueV? string  e.g. "top", "center", "bottom"
---@return RitnLibStyle self
function RitnLibStyle:align(valueH, valueV)
    if valueH ~= nil then self.alignH = valueH end
    if valueV ~= nil then self.alignV = valueV end

    self.style.horizontal_align = self.alignH
    self.style.vertical_align = self.alignV

    return self
end


--------------------------------

---**EN**
---
---Description: Sets width and height in one call.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit largeur et hauteur en un appel.
---@param width number
---@param height number
---@return RitnLibStyle self
function RitnLibStyle:size(width, height)
    self:width(width)
    self:height(height)

    return self
end

---**EN**
---
---Description: Sets `width`. Number-only.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `width`. Number uniquement.
---@param width number
---@return RitnLibStyle self
function RitnLibStyle:width(width)
    if width == nil then return self end
    if type(width) ~= 'number' then return self end

    self.style.width = width

    return self
end

---**EN**
---
---Description: Sets `height`. Number-only.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `height`. Number uniquement.
---@param height number
---@return RitnLibStyle self
function RitnLibStyle:height(height)
    if height == nil then return self end
    if type(height) ~= 'number' then return self end

    self.style.height = height

    return self
end


---**EN**
---
---Description: Sets `maximal_height`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `maximal_height`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:maxHeight(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.maximal_height = value

    return self
end

---**EN**
---
---Description: Sets `maximal_width`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `maximal_width`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:maxWidth(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.maximal_width = value

    return self
end

---**EN**
---
---Description: Sets `minimal_height`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `minimal_height`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:minHeight(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.minimal_height = value

    return self
end

---**EN**
---
---Description: Sets `minimal_width`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `minimal_width`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:minWidth(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.minimal_width = value

    return self
end

---**EN**
---
---Description: Sets the `font` (registered font name).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit la `font` (nom de police enregistrée).
---@param font string
---@return RitnLibStyle self
function RitnLibStyle:font(font)
    if font == nil then return self end
    if type(font) ~= 'string' then return self end

    self.style.font = font

    return self
end

---**EN**
---
---Description: Sets all 4 margins (top/bottom/left/right).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les 4 marges (top/bottom/left/right).
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:margin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:topMargin(value)
    self:bottomMargin(value)
    self:leftMargin(value)
    self:rightMargin(value)

    return self
end

---**EN**
---
---Description: Sets left and right margins.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les marges gauche et droite.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:horizontalMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:leftMargin(value)
    self:rightMargin(value)

    return self
end

---**EN**
---
---Description: Sets top and bottom margins.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les marges haut et bas.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:verticalMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:topMargin(value)
    self:bottomMargin(value)

    return self
end

---**EN**
---
---Description: Sets `top_margin`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `top_margin`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:topMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.top_margin = value

    return self
end

---**EN**
---
---Description: Sets `bottom_margin`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `bottom_margin`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:bottomMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.bottom_margin = value

    return self
end

---**EN**
---
---Description: Sets `left_margin`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `left_margin`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:leftMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.left_margin = value

    return self
end

---**EN**
---
---Description: Sets `right_margin`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `right_margin`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:rightMargin(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.right_margin = value

    return self
end


---**EN**
---
---Description: Sets all 4 paddings (top/bottom/left/right).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les 4 paddings (top/bottom/left/right).
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:padding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:topPadding(value)
    self:bottomPadding(value)
    self:leftPadding(value)
    self:rightPadding(value)

    return self
end


---**EN**
---
---Description: Sets top and bottom paddings.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les paddings haut et bas.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:verticalPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:topPadding(value)
    self:bottomPadding(value)

    return self
end


---**EN**
---
---Description: Sets left and right paddings.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit les paddings gauche et droit.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:horizontalPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self:leftPadding(value)
    self:rightPadding(value)

    return self
end


---**EN**
---
---Description: Sets `top_padding`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `top_padding`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:topPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.top_padding = value

    return self
end

---**EN**
---
---Description: Sets `bottom_padding`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `bottom_padding`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:bottomPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.bottom_padding = value

    return self
end

---**EN**
---
---Description: Sets `left_padding`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `left_padding`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:leftPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.left_padding = value

    return self
end

---**EN**
---
---Description: Sets `right_padding`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `right_padding`.
---@param value number
---@return RitnLibStyle self
function RitnLibStyle:rightPadding(value)
    if value == nil then return self end
    if type(value) ~= 'number' then return self end

    self.style.right_padding = value

    return self
end


----------------------------------------------------------------
--return RitnLibStyle
