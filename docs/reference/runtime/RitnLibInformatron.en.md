---
title: RitnLibInformatron
type: reference
lang: en
---

# `RitnLibInformatron`


> 🚧 **Beta — do not use in production.**
>
> `RitnLibInformatron` is a **beta** class with two known blocking defects: `:getElement()` reads `self.gui[self.gui_name]` (string key `"informatron"`) while the constructor stores the element under integer key `[1]` — always returns `nil`. `:setPageContent()` returns the undefined global `FLAG_PAGE_DISPLAY` instead of `self.FLAG_PAGE_DISPLAY` — always returns `nil`. Furthermore, the `informatron_page_content` remote interface in `core/interfaces.lua` is **commented out**, making the class end-to-end unusable. Full reference documentation will be written once the class is stabilised.

| | |
|---|---|
| **Source** | `classes/RitnClass/RitnInformatron.lua` |
| **Inherits from** | [`RitnLibGui`](RitnLibGui.md) |
| **Stage** | control (runtime) |
| **Access** | `require(ritnlib.defines.class.ritnClass.informatron)` |
| **Status** | 🚧 beta (blocked) |
| **`object_name`** | `"RitnLibInformatron"` |

## Intent (target)

Integration wrapper for [Informatron](https://mods.factorio.com/mod/informatron). Built around an Informatron event payload to render a page's content into the Informatron screen GUI via the `informatron_page_content` remote interface.

```lua
-- intended usage once the class is stabilised (inside the Informatron remote handler)
remote.add_interface("my-mod", {
    informatron_page_content = function(data)
        local informatron = RitnLibInformatron("my-mod", data)
        return informatron:setPageContent({
            { name = "my-panel", parent = "start", gui = { type = "frame", ... } },
        })
    end
})
```

In the meantime, use the Informatron API directly (`remote.call("informatron", ...)`) and build the GUI manually.

## Constructor

```lua
RitnLibInformatron(mod_name, informatron_data)
```

| Parameter | Type | Description |
|---|---|---|
| `mod_name` | `string` | Mod name (passed to `RitnLibGui.init` as `action`) |
| `informatron_data` | `EventData` | Informatron event payload (`player_index` field required) |

> **Note** — `self.page_name = page_name` reads the global `page_name` at construction time. This global must be set by the caller (Informatron injects it before calling the remote interface).

## Fields inherited from `RitnLibGui`

See [`RitnLibGui`](RitnLibGui.md) for all dispatcher fields (`.player`, `.mod_name`, `.gui_action`, etc.).

## Own fields

| Field | Type | Value |
|---|---|---|
| `gui_name` | `"informatron"` | Logical GUI name |
| `page_name` | `string?` | Name of the page being rendered (read from global `page_name`) |
| `gui` | `{ [1]: LuaGuiElement }` | `{ self.player.gui.screen }` |
| `content` | `table` | Element-tree cache (consumer-populated) |
| `content_origine` | `string[]` | Path `{ "main-flow", "content-container", "content-pane" }` |
| `FLAG_PAGE_DISPLAY` | `true` | Success constant |
| `FLAG_PAGE_NOT_DISPLAY` | `false` | Failure constant |

## Methods

#### `:getElement(element_type, element_name?)`

Retrieves a `LuaGuiElement` from the page tree by walking `content_origine` then `self.content[element_type][element_name]`.

> ⚠ **Beta defect** — reads `self.gui[self.gui_name]` (key `"informatron"`) but the constructor stores under `self.gui[1]`. Always returns `nil`.

**Parameters:**

| Name | Type | Description |
|---|---|---|
| `element_type` | `string` | Element category in `self.content` |
| `element_name` | `string?` | Element name (optional) |

**Return value:** `LuaGuiElement?`

---

#### `:setPageContent(pageElements)`

Iterates `pageElements` and adds each element to the Informatron content pane via `parent.add(element.gui)`.

> ⚠ **Beta defect** — returns the undefined global `FLAG_PAGE_DISPLAY` (not `self.FLAG_PAGE_DISPLAY`). Return value is always `nil`.

**Parameters:**

| Name | Type | Description |
|---|---|---|
| `pageElements` | `{ name: string, parent: string, gui: table }[]` | List of elements to add |

**Return value:** `boolean?` (intent: `true` = success, `false` = page not displayed)

## See also

- [`RitnLibGui`](RitnLibGui.md) — parent class (extension contract)
- [`core/interfaces.lua`](../core/interfaces.md) — Informatron remote interface (commented out)
- [Known bugs](../../debt/known-bugs.md)
- [Class map](../overview.md)
