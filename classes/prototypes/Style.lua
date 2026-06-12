-- RitnProtoStyle
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------



----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["gui-style"].default[<style_name>]`. The constructor always targets `data.raw["gui-style"]["default"]` (so `self.type = "gui-style"`, `self.name = "default"`) and tracks the actual style key in `self.style_name`. Overrides `:update()` to write back to the nested `data.raw["gui-style"].default[style_name]`.
---
---Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["gui-style"].default[<style_name>]`. Le constructeur cible toujours `data.raw["gui-style"]["default"]` (donc `self.type = "gui-style"`, `self.name = "default"`) et garde le nom du style réel dans `self.style_name`. Override `:update()` pour réécrire dans `data.raw["gui-style"].default[style_name]`.
---
---Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoStyle : RitnPrototype
---@field object_name "RitnProtoStyle"
---@field style_name string?                           Actual style key under `data.raw["gui-style"].default`
---@field style { type: string, name: string, parent: string, padding: number, size: number[] }  Style payload being built (for `:extend*` methods)
---@operator call(string?): RitnProtoStyle
---@type RitnProtoStyle
local RitnProtoStyle = class.newclass(RitnProtoBase, function(base, style_name)
    -- prototype init
    RitnProtoBase.init(base, "default", "gui-style")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoStyle"
    base.style_name = style_name
    ----
    if data.raw[base.type][base.name] == nil then return end
    if base.style_name ~= nil then
        if data.raw[base.type][base.name][base.style_name] == nil then return end
        base.prototype = table.deepcopy(data.raw[base.type][base.name][base.style_name])
    else
        base.prototype = table.deepcopy(data.raw[base.type][base.name])
    end
    ----
    base.style = {
        type = "",
        name = "",
        parent = "",
        padding = 0,
        size = { 40, 40 }
    }
    --------------------------------------------------
end) --[[@as RitnProtoStyle]]


---**EN**
---
---Description: Sets the style payload's `type` (e.g. `"button_style"`, `"frame_style"`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `type` du payload de style (ex: `"button_style"`, `"frame_style"`).
---@param type_gui string
---@return RitnProtoStyle self  Chainable
function RitnProtoStyle:setType(type_gui)
    if type(type_gui) ~= 'string' then return self end
    self.style.type = type_gui

    return self
end

---**EN**
---
---Description: Sets the style payload's `name` (the key under `data.raw["gui-style"].default`).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `name` du payload de style (la clé sous `data.raw["gui-style"].default`).
---@param name string
---@return RitnProtoStyle self  Chainable
function RitnProtoStyle:setName(name)
    if type(name) ~= 'string' then return self end
    self.style.name = name

    return self
end

---**EN**
---
---Description: Sets the style payload's `parent` (style to inherit from).
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `parent` du payload de style (style dont hériter).
---@param parent string
---@return RitnProtoStyle self  Chainable
function RitnProtoStyle:setParent(parent)
    if type(parent) ~= 'string' then return self end
    self.style.parent = parent

    return self
end

---**EN**
---
---Description: Sets the style payload's `padding`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit le `padding` du payload de style.
---@param padding number
---@return RitnProtoStyle self  Chainable
function RitnProtoStyle:setPadding(padding)
    if type(padding) ~= 'number' then return self end
    self.style.padding = padding

    return self
end



---**EN**
---
---Description: Commits the current `self.style` payload into `self.prototype[self.style.name]`, then calls `:update()`. Errors if `self.type` or `self.name` is empty.
---
---──────────────────────────────
---
---**FR**
---
---Description: Commit le payload `self.style` courant dans `self.prototype[self.style.name]`, puis appelle `:update()`. Lève une erreur si `self.type` ou `self.name` est vide.
function RitnProtoStyle:extend()
    if self.type == '' then error('style not init ! (type)') return end
    if self.name == '' then error('style not init ! (name)') return end

    self.prototype[self.style.name] = self.style

    self:update()
end


---**EN**
---
---Description: Shorthand to build a button-style child. Sets `style.type = "button_style"`, `style.name`, `style.parent`, then optionally `style.size` (number or `{w,h}` table), then commits via `:extend()`.
---
---──────────────────────────────
---
---**FR**
---
---Description: Raccourci pour construire un style de bouton enfant. Définit `style.type = "button_style"`, `style.name`, `style.parent`, optionnellement `style.size` (number ou table `{w,h}`), puis commit via `:extend()`.
---@param name string         Style key
---@param parent string       Parent style to inherit from
---@param size? number|number[]
function RitnProtoStyle:extendButton(name, parent, size)
    if type(name) ~= 'string' then return self end
    if type(parent) ~= 'string' then return self end

    if size ~= nil then
        if type(size) == 'number' then self.style.size = { size, size } end
        if type(size) == 'table' then self.style.size = size end
    end

    self.style.type = 'button_style'
    self.style.name = name
    self.style.parent = parent

    self:extend()
end


-- UPDATE PROTOTYPE

---**EN**
---
---Description: Overridden `:update()` that respects `self.style_name`. If `style_name` is set, writes to `data.raw["gui-style"].default[style_name]`; otherwise writes to `data.raw["gui-style"].default` directly.
---
---──────────────────────────────
---
---**FR**
---
---Description: `:update()` overridé qui respecte `self.style_name`. Si `style_name` est défini, écrit dans `data.raw["gui-style"].default[style_name]` ; sinon écrit dans `data.raw["gui-style"].default` directement.
function RitnProtoStyle:update()
    if data.raw[self.type][self.name] == nil then return self end
    if self.prototype == nil then return self end
    if self.style_name ~= nil then
        data.raw[self.type][self.name][self.style_name] = self.prototype
    else
        data.raw[self.type][self.name] = self.prototype
    end
end



return RitnProtoStyle
