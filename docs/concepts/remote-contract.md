---
title: Contrat remote consommateur
type: concept
lang: fr
---

# Contrat remote consommateur (extension `RitnLibGui`)

> **`RitnLibGui` est une classe de base abstraite. Elle ne fait rien seule. C'est ton mod qui la sous-classe, remplit `self.gui[1]` et enregistre l'interface remote.**

Ce contrat a été vérifié dans plusieurs mods en production (RitnMenuButton, RitnLobbyGame, RitnCharacters).

## Vue d'ensemble

`RitnLibGui` gère le dispatch des clics GUI : quand un joueur clique, elle identifie l'élément GUI concerné, remonte la chaîne de noms jusqu'à trouver le GUI racine, et appelle l'interface remote associée. Pour faire ça, elle a besoin de trois choses que la sous-classe doit fournir :

| Propriété | Fournie par | Valeur attendue |
|---|---|---|
| `self.gui[1]` | sous-classe | le `LuaGuiElement` racine du GUI |
| `self.gui_name` | sous-classe | nom logique du GUI (ex. `"lobby"`) |
| `self.gui_action` | `RitnLibGui.init` | `"gui_action_" .. gui_name` |
| `self.content` | sous-classe | cache des sous-éléments (peut rester `{}`) |

## Implémentation du contrat

### 1. Définir la sous-classe

```lua
-- mon-mod/classes/MonGui.lua
local MonGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event, mod_name)
    -- Appel du parent obligatoire
    RitnLibGui.init(self, event, mod_name, "mon-gui")

    self.object_name = "MonGui"
    self.gui_name    = "mon-gui"

    -- Remplir self.gui[1] avec la racine du GUI
    self.gui = { self.player.gui.center["mon-gui-root"] }

    self.content = {}
end)
```

### 2. Enregistrer l'interface remote

```lua
-- mon-mod/control.lua
remote.add_interface("mon-mod", {
    gui_action_mon_gui = function(player_index, element_name)
        -- logique de traitement du clic
        if element_name == "bouton-ok" then
            -- ...
        end
    end
})
```

### 3. Brancher le handler

```lua
script.on_event(defines.events.on_gui_click, function(event)
    local gui = MonGui(event, "mon-mod")
    gui:on_gui_click()
    -- RitnLibGui identifie l'élément cliqué,
    -- puis appelle remote.call("mon-mod", "gui_action_mon-gui", player_index, element_name)
end)
```

## Pourquoi `self.gui[1]` et pas `self.gui[gui_name]`

`RitnLibGui` accède à la racine via `self.gui[1]` (indice entier). C'est délibéré : au moment de l'instanciation, `gui_name` n'est pas encore connu par la classe de base, et l'indice entier est la forme la plus simple et la plus fiable.

⚠ `RitnLibInformatron` a un bug connu lié à cette convention : son `getElement` lit `self.gui[self.gui_name]` (clé string) au lieu de `self.gui[1]`. Voir la [page de référence](../reference/runtime/RitnLibInformatron.md).

## Nommage des éléments GUI

`RitnLibGui` reconstruit le chemin vers l'élément cliqué en remontant la hiérarchie de noms. Les noms des `LuaGuiElement` doivent suivre la convention `"<gui_name>-<element_name>"` (préfixés par le gui_name).

```lua
-- Lors de la construction du GUI (data stage ou à la volée)
player.gui.center.add({
    type = "frame",
    name = "mon-gui-root",
    direction = "vertical",
    children = {
        { type = "button", name = "mon-gui-bouton-ok" },
        { type = "button", name = "mon-gui-bouton-annuler" },
    }
})
```

Quand le joueur clique sur `mon-gui-bouton-ok`, `on_gui_click` reçoit `element_name = "bouton-ok"` dans l'interface remote.

## Exemple complet — RitnMenuButton

RitnMenuButton est le mod de référence pour ce pattern. Il expose un bouton dans la barre de menu (Factorio 2.0). Sa structure :

```
RitnMenuButton (mod)
└─ classes/RitnMenuButton.lua
   └─ RitnMenuButton = newclass(RitnLibGui, function(self, event, mod_name)
         RitnLibGui.init(self, event, mod_name, "menu-button")
         self.gui_name = "menu-button"
         self.gui = { self.player.gui.top["menu-button-root"] }
      end)

control.lua
├─ remote.add_interface("RitnMenuButton", {
│     gui_action_menu_button = function(player_index, element_name)
│         -- gère les clics
│     end
│  })
└─ script.on_event(on_gui_click, function(event)
       local btn = RitnMenuButton(event, "RitnMenuButton")
       btn:on_gui_click()
   end)
```

## Voir aussi

- [Modèle d'events](event-model.md)
- [Wrappers temporaires](temporary-wrappers.md)
- [Référence : RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Référence : RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
