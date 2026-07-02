---
title: Construire un setting
type: guide
lang: fr
---

# Construire un setting

Ce guide montre comment déclarer des settings Factorio via `RitnLibSetting` au **settings stage**.

> **État actuel** : `RitnLibSetting` est en **🚧 beta**. Les settings booléens fonctionnent. Les autres types (int, double, string, color) sont partiellement implémentés — voir [limitations](#limitations).

## Structure

```lua
-- mon-mod/settings.lua
require("__RitnLib__.defines")

local RitnSetting = require(ritnlib.defines.class.ritnClass.setting)
```

## Setting booléen (startup)

```lua
RitnSetting("mon-mod-activer-feature")
    :setSettingStartup()
    :setDefaultValueBool(true)
    :new()
```

Le setting apparaît dans **Paramètres → Mods** sous l'onglet "Au lancement". Le nom `"mon-mod-activer-feature"` est l'identifiant Factorio.

## Setting booléen (runtime)

```lua
RitnSetting("mon-mod-mode-debug")
    :setSettingRuntime()   -- changeable en cours de partie
    :setDefaultValueBool(false)
    :new()
```

## Setting par joueur (map)

```lua
RitnSetting("mon-mod-volume-alertes")
    :setSettingMap()      -- par partie / carte
    :setDefaultValueBool(true)
    :new()
```

## Lire un setting au runtime

Au runtime stage, les settings sont accessibles via l'API Factorio standard :

```lua
-- Startup setting (lu une fois, immuable en cours de partie)
local enabled = settings.startup["mon-mod-activer-feature"].value

-- Runtime setting (peut changer)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting == "mon-mod-mode-debug" then
        local debug = settings.global["mon-mod-mode-debug"].value
        log("Debug mode : " .. tostring(debug))
    end
end)
```

## Limitations

`RitnLibSetting` est un wrapper simplifié. Certains types ne sont pas encore complets :

| Type | État |
|---|---|
| `bool` (startup / runtime / map) | Fonctionne |
| `int` | Partiellement implémenté |
| `double` | Partiellement implémenté |
| `string` | Partiellement implémenté |
| `color` | Non implémenté |

Pour les types non supportés, utilise directement l'API Factorio :

```lua
-- settings.lua — sans RitnLibSetting
data:extend({
    {
        type    = "int-setting",
        name    = "mon-mod-nb-tentatives",
        setting_type = "startup",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 10,
    }
})
```

## Voir aussi

- [Cycle de vie](../concepts/life-cycle.md)
- [Référence : RitnLibSetting](../reference/runtime/RitnLibSetting.md)
