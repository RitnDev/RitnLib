---
title: Contrat remote consommateur
type: concept
lang: fr
---

# Contrat remote consommateur (extension `RitnLibGui`)

> **`RitnLibGui` est une classe de base abstraite. Elle ne fait rien seule. C'est ton mod qui la sous-classe, remplit les quatre champs du contrat et enregistre l'interface remote.**

Ce contrat est appliqué dans plusieurs mods (RitnMenuButton, RitnLobbyGame, RitnCharacters).

## Ce que `RitnLibGui` attend de la sous-classe

| Champ | Fourni par | Valeur attendue |
|---|---|---|
| `self.gui[1]` | sous-classe | le **conteneur** (`player.gui.center`, etc.) — pas le frame racine |
| `self.gui_name` | sous-classe | slug logique du GUI (ex. `"changer"`) — préfixe de tous les éléments |
| `self.gui_action` | sous-classe | `{ [gui_name] = { [action] = true, ... } }` |
| `self.content` | sous-classe | table de chemins utilisée par `:getElement()` |

`RitnLibGui.init` ne remplit **pas** ces champs — c'est le constructeur de la sous-classe qui le fait.

## `RitnLibGui.init` — ce qu'il initialise vraiment

```lua
RitnLibGui.init(self, event, mod_name, main_gui)
```

- `mod_name` — nom du mod (cible des `remote.call`)
- `main_gui` — **suffix** du frame racine, pas le `gui_name`. Le nom complet en jeu = `gui_name .. "-" .. main_gui` (ex: `"changer-frame-main"`)

## Convention de nommage des éléments

`RitnLibGuiElement(gui_name, type, name)` génère un nom de la forme `gui_name-type_normalisé-name` :

```
"changer-frame-main"      ← RitnLibGuiElement("changer", "frame",    "main")
"changer-button-select"   ← RitnLibGuiElement("changer", "button",   "select")
"changer-listbox-items"   ← RitnLibGuiElement("changer", "list-box", "items")
```

Types normalisés : `"list-box"` → `"listbox"`, `"drop-down"` → `"dropdown"`, `"sprite-button"` → `"button"`, `"text-box"` → `"textbox"`.

## Dispatch des clics — comment ça marche

`on_gui_click` parse le nom de l'élément cliqué via le pattern `"([^-]*)-?([^-]*)-?([^-]*)"` :

```
"changer-button-select"
    │        │       │
   ui     element   name
```

→ `action = element .. "-" .. name` = `"button-select"`

RitnLibGui vérifie que `self.gui_action[ui][action]` existe, puis appelle :

```lua
remote.call(mod_name, "gui_action_" .. gui_name, action, event)
```

## Interface remote — signature exacte

```lua
remote.add_interface("mon-mod", {
    ["gui_action_" .. gui_name] = function(action, event)
        -- action = "button-close", "button-confirm", etc.
        -- event  = EventData Factorio original
    end,
})
```

> ⚠ La signature est `function(action, event)` — **pas** `function(player_index, element_name)`.

## `self.gui_action` — table des actions autorisées

```lua
self.gui_action = {
    ["changer"] = {              -- clé = gui_name
        ["button-select"] = true,
        ["button-close"]  = true,
    }
}
```

Les clés internes sont les `action` strings (`"type-name"`). Si une action n'est pas dans cette table, le dispatch est ignoré silencieusement.

## Exemple complet — RitnCharacters

```lua
-- classes/RitnGuiChanger.lua

RitnGuiCharacterChanger = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.characters.name, "frame-main")
    self.object_name = "RitnGuiCharacterChanger"
    self.gui_name    = "changer"

    self.gui_action = {
        ["changer"] = {
            ["button-select"] = true,
            -- (open/close déclenchés par shortcut, pas par clic interne)
        }
    }

    self.gui = { self.player.gui.center }  -- conteneur, pas le frame

    self.content = fGui.getContent()
end)

-- modules/storage.lua

remote.add_interface("RitnCharacters", {
    ["gui_action_changer"] = function(action, event)
        if action == "button-select" then
            RitnGuiCharacterChanger(event):action_select()
        end
    end,
})
```

## `self:getElement(type, name)` — naviguer dans la GUI

`getElement` parcourt `self.content[type][name]` comme un chemin depuis `self.gui[1]`, en préfixant chaque étape avec `gui_name .. "-"` :

```lua
-- content.list = { "frame-main", "frame-submain", "flow-selecter", "listbox-characters" }
local list = self:getElement("list")
-- → self.gui[1]["changer-frame-main"]["changer-frame-submain"]
--                  ["changer-flow-selecter"]["changer-listbox-characters"]
```

## Voir aussi

- [Pattern GUI complet](../guides/gui-pattern.md)
- [Modèle d'events](event-model.md)
- [Wrappers temporaires](temporary-wrappers.md)
- [Référence : RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Référence : RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
