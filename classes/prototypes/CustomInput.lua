-- RitnProtoCustomInput
----------------------------------------------------------------
local class = require("__RitnLib__.core.class")
local RitnProtoBase = require("__RitnLib__.classes.RitnClass.RitnPrototype")
----------------------------------------------------------------

---**EN**
---
---Description: Data-stage manipulator for `data.raw["custom-input"][<name>]`. Inherits from [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---
---──────────────────────────────
---
---**FR**
---
---Description: Manipulateur data-stage pour `data.raw["custom-input"][<name>]`. Hérite de [`RitnPrototype`](../RitnClass/RitnPrototype.lua).
---@class RitnProtoCustomInput : RitnPrototype
---@field object_name "RitnProtoCustomInput"
---@operator call(string): RitnProtoCustomInput
---@type RitnProtoCustomInput
local RitnProtoCustomInput = class.newclass(RitnProtoBase, function(base, input_name)
    -- prototype init
    if input_name == nil then return end
    RitnProtoBase.init(base, input_name, "custom-input")
    --------------------------------------------------
    -- prototype base
    base.object_name = "RitnProtoCustomInput"
    ----
    if data.raw[base.type][base.name] == nil then return end
    base.prototype = table.deepcopy(data.raw[base.type][base.name])
    --------------------------------------------------
end) --[[@as RitnProtoCustomInput]]


--ADD NEW CUSTOM-INPUT

---**EN**
---
---Description: Declares a brand-new custom-input via `data:extend({...})` (data stage). Default `consuming = "game-only"` if not specified.
---
---──────────────────────────────
---
---**FR**
---
---Description: Déclare un nouveau custom-input via `data:extend({...})` (data stage). Défaut `consuming = "game-only"` si non spécifié.
---@param name string
---@param key_sequence string  e.g. "CONTROL + SHIFT + R"
---@param consuming? "none"|"game-only"|"script-only"
---@return RitnProtoCustomInput self  Chainable
function RitnProtoCustomInput:extend(name, key_sequence, consuming)
    if name == nil then return end
    local consumingDefault = "game-only"
    if consuming ~= nil then consumingDefault = consuming end

    local input = {
        type = 'custom-input',
        name = name,
        consuming = consumingDefault,
        key_sequence = key_sequence,
    }
    data:extend({input})
    return self
end


---**EN**
---
---Description: Sets `linked_game_control` on the current custom-input, linking it to a built-in Factorio control.
---
---──────────────────────────────
---
---**FR**
---
---Description: Définit `linked_game_control` sur le custom-input courant, le liant à un contrôle Factorio natif.
---@param linked_game_control string  Built-in Factorio control name (e.g. "build", "mine")
---@return RitnProtoCustomInput self  Chainable
function RitnProtoCustomInput:linkedControl(linked_game_control)
    if linked_game_control == nil then return end

    self.prototype.linked_game_control = linked_game_control

    self:update()
    return self
end


return RitnProtoCustomInput
