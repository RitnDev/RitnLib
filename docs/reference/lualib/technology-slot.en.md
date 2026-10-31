---
title: lualib/technology-slot
type: reference
lang: en
---

# `lualib/technology-slot`


Technology tiles **like the game list** for a mod GUI: slot coloured by state (yellow available, red unavailable,
green researched), technology icon and band of the science packs (or of the trigger). The tile is a clickable button;
its children are ignored by the mouse.

| | |
|---|---|
| **Source** | `lualib/technology-slot.lua` |
| **Type** | function module (returned table), control stage |
| **Access** | `local technologySlot = require(ritnlib.defines.technology_slot)` |

> The `technology-slot-*-ritngui` and `technology-ingredients-ritngui` styles come from `prototypes/gui-style.lua`:
> your `data.lua` must `require(ritnlib.defines.gui_styles)`.

---

## Constants

#### `WIDTH` :: `72` `[Read]`
Tile width (the game one).

#### `HEIGHT` :: `100` `[Read]`
Tile height.

---

## Functions

#### `state(technology)` → `"researched"|"available"|"unavailable"`
Tile colour: researched (green), every prerequisite researched (yellow), otherwise red.

#### `icons(technology)` → `string[]`
Sprites of the band: the science packs (`item/<pack>`), or the trigger sprite.

#### `triggerSprite(trigger)` → `string, number?`
Sprite and count of the trigger of a technology (`LuaTechnologyPrototype.research_trigger`),
e.g. `"item/iron-plate", 50`.

#### `add(parent, gui_name, name, slot)` → `LuaGuiElement`
Builds the tile inside `parent` and returns the button `<gui_name>-button-<name>`. `slot`:

| Field | Type | |
|---|---|---|
| `sprite` | `string` | `"technology/<name>"` |
| `state` | `string` | result of `state` |
| `icons` | `string[]` | result of `icons` |
| `selected` | `boolean?` | highlighted tile |
| `tags` | `table?` | button tags |

The game places the child of a button 4 px from the edge (negative margins change nothing): the content is shrunk to
the inside of the tile so that the icon is centred and the band stays inside the slot.

```lua
local technologySlot = require(ritnlib.defines.technology_slot)
local tech = player.force.technologies["automation"]
technologySlot.add(flow, "mymod_research", "tech_1", {
    sprite = "technology/" .. tech.name,
    state = technologySlot.state(tech),
    icons = technologySlot.icons(tech),
    tags = { technology = tech.name },
})
```
