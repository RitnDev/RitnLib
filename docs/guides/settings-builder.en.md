---
title: Building a setting
type: guide
lang: en
---

# Building a setting

This guide shows how to declare Factorio settings via `RitnLibSetting` at the **settings stage**.

> **Current status**: `RitnLibSetting` is in **🚧 beta**. Boolean settings work. Other types (int, double, string, color) are partially implemented — see [limitations](#limitations).

## Structure

```lua
-- my-mod/settings.lua
require("__RitnLib__.defines")

local RitnSetting = require(ritnlib.defines.class.ritnClass.setting)
```

## Boolean setting (startup)

```lua
RitnSetting("my-mod-enable-feature")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

The setting appears in **Settings → Mods** under the "Startup" tab. The name `"my-mod-enable-feature"` is the Factorio identifier.

## Boolean setting (runtime)

```lua
RitnSetting("my-mod-debug-mode")
    :setSettingRuntime()   -- changeable during a game
    :setDefaultValueBool(false)
    :new()
```

## Per-map setting

```lua
RitnSetting("my-mod-alert-volume")
    :setSettingMap()      -- per game / map
    :setDefaultValueBool(true)
    :new()
```

## Reading a setting at runtime

At the runtime stage, settings are accessible via the standard Factorio API:

```lua
-- Startup setting (read once, immutable during a game)
local enabled = settings.startup["my-mod-enable-feature"].value

-- Runtime setting (can change)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "my-mod-debug-mode" then
        local debug = settings.global["my-mod-debug-mode"].value
        log("Debug mode: " .. tostring(debug))
    end
end)
```

## Limitations

`RitnLibSetting` is a simplified wrapper. Some types are not yet complete:

| Type | Status |
|---|---|
| `bool` (startup / runtime / map) | Working |
| `int` | Partially implemented |
| `double` | Partially implemented |
| `string` | Partially implemented |
| `color` | Not implemented |

For unsupported types, use the Factorio API directly:

```lua
-- settings.lua — without RitnLibSetting
data:extend({
    {
        type          = "int-setting",
        name          = "my-mod-max-attempts",
        setting_type  = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 10,
    }
})
```

## See also

- [Life cycle](../concepts/life-cycle.en.md)
- [Reference: RitnLibSetting](../reference/runtime/RitnLibSetting.md)
