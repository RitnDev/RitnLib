---
title: Pattern GUI complet
type: guide
lang: fr
---

# Pattern GUI complet

Ce guide montre comment construire une GUI avec `RitnLibGui` et `RitnLibGuiElement`, en partant du cas le plus simple jusqu'au pattern complet utilisé dans RitnCharacters.

## Exemple minimal

Pour une GUI simple (un frame + un bouton), tout peut tenir dans `control.lua`.

### La classe

```lua
-- mon-mod/control.lua

MonGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    -- mod_name + suffix du frame racine ("panel-frame-main" en jeu)
    RitnLibGui.init(self, event, "mon-mod", "frame-main")
    self.object_name = "MonGui"
    self.gui_name    = "panel"

    -- Actions autorisées : "type_normalisé-element_name"
    self.gui_action = {
        [self.gui_name] = {
            ["button-close"] = true,
        }
    }

    -- self.gui[1] = le conteneur, pas le frame racine
    self.gui    = { self.player.gui.center }
    self.content = {}
end)

function MonGui:create()
    -- Vérifie si la GUI existe déjà
    if self.gui[1]["panel-frame-main"] then return self end

    local frame = self.gui[1].add(
        RitnLibGuiElement("panel", "frame", "main"):vertical():get()
    )
    frame.add(
        RitnLibGuiElement("panel", "button", "close"):caption("Fermer"):get()
    )
    return self
end

function MonGui:action_close()
    local frame = self.gui[1]["panel-frame-main"]
    if frame then frame.destroy() end
    return self
end
```

### L'interface remote

```lua
remote.add_interface("mon-mod", {
    gui_action_panel = function(action, event)
        if action == "button-close" then
            MonGui(event):action_close()
        end
    end,
})
```

### Les handlers

```lua
script.on_event(defines.events.on_player_created, function(event)
    MonGui(event):create()
end)

script.on_event(defines.events.on_gui_click, function(event)
    MonGui(event):on_gui_click()
    -- parse "panel-button-close" → action = "button-close"
    -- → remote.call("mon-mod", "gui_action_panel", "button-close", event)
end)
```

---

## Pattern complet — structure 3 fichiers

Pour une GUI plus complexe (liste, flows imbriqués, styles), il est recommandé de séparer en 3 fichiers comme dans RitnCharacters.

```
mon-mod/
├─ gui/mon-panel.lua        ← specs d'éléments + chemins
├─ classes/MonGui.lua       ← classe avec :create() et actions
└─ modules/storage.lua      ← remote.add_interface
```

### `gui/mon-panel.lua` — specs et chemins

```lua
local function getElement(gui_name)
    return {
        frame = {
            main    = RitnLibGuiElement(gui_name, "frame", "main"):vertical():get(),
            submain = RitnLibGuiElement(gui_name, "frame", "submain"):vertical()
                        :style("inside_shallow_frame"):get(),
        },
        flow = {
            footer = RitnLibGuiElement(gui_name, "flow", "footer"):horizontal():get(),
        },
        list    = RitnLibGuiElement(gui_name, "list-box", "items"):get(),
        button  = {
            confirm = RitnLibGuiElement(gui_name, "button", "confirm"):caption("Valider"):get(),
            close   = RitnLibGuiElement(gui_name, "button", "close"):caption("Fermer"):get(),
        },
    }
end

local function getContent()
    return {
        frame  = {
            main    = { "frame-main" },
            submain = { "frame-main", "frame-submain" },
        },
        flow   = {
            footer = { "frame-main", "frame-submain", "flow-footer" },
        },
        list   = { "frame-main", "frame-submain", "listbox-items" },
        button = {
            confirm = { "frame-main", "frame-submain", "flow-footer", "button-confirm" },
            close   = { "frame-main", "frame-submain", "flow-footer", "button-close" },
        },
    }
end

return { getElement = getElement, getContent = getContent }
```

`getContent` décrit le chemin depuis `self.gui[1]` vers chaque élément. `self:getElement("list")` le parcourt en préfixant chaque étape avec `gui_name .. "-"`.

### `classes/MonGui.lua`

```lua
local fGui = require(ritnlib.defines.monmod.gui.panel)

MonGui = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.monmod.name, "frame-main")
    self.object_name = "MonGui"
    self.gui_name    = "panel"

    self.gui_action = {
        ["panel"] = {
            ["button-confirm"] = true,
            ["button-close"]   = true,
        }
    }

    self.gui     = { self.player.gui.center }
    self.content = fGui.getContent()
end)

function MonGui:create()
    if self.gui[1]["panel-frame-main"] then return self end

    local e = fGui.getElement(self.gui_name)
    local c = {}
    c.frame_main    = self.gui[1].add(e.frame.main)
    c.frame_submain = c.frame_main.add(e.frame.submain)
    c.list          = c.frame_submain.add(e.list)
    c.flow_footer   = c.frame_submain.add(e.flow.footer)
    c.btn_confirm   = c.flow_footer.add(e.button.confirm)
    c.btn_close     = c.flow_footer.add(e.button.close)

    -- Styles post-création
    RitnLibStyle(c.frame_main):padding(4)
    RitnLibStyle(c.list):horizontalStretch():maxHeight(400)
    RitnLibStyle(c.flow_footer):align("right")

    for _, item in pairs({ "Option A", "Option B", "Option C" }) do
        c.list.add_item(item)
    end
    return self
end

function MonGui:action_close()
    local frame = self.gui[1]["panel-frame-main"]
    if frame then frame.destroy() end
    return self
end

function MonGui:action_confirm()
    local list = self:getElement("list")
    if not list or list.selected_index == 0 then return self end
    self.player.player.print("Sélection : " .. list.get_item(list.selected_index))
    self:action_close()
    return self
end
```

### `modules/storage.lua`

```lua
remote.add_interface("mon-mod", {
    ["gui_action_panel"] = function(action, event)
        if action == "button-confirm" then
            MonGui(event):action_confirm()
        elseif action == "button-close" then
            MonGui(event):action_close()
        end
    end,
})
return {}
```

---

## Référence rapide

### `RitnLibGuiElement` — nommage

`RitnLibGuiElement(gui_name, type, name)` génère le nom en jeu `gui_name-type_normalisé-name` :

| Type passé | Normalisé | Exemple avec gui_name="panel" |
|---|---|---|
| `"frame"` | `"frame"` | `"panel-frame-main"` |
| `"flow"` | `"flow"` | `"panel-flow-footer"` |
| `"button"` / `"sprite-button"` | `"button"` | `"panel-button-close"` |
| `"list-box"` | `"listbox"` | `"panel-listbox-items"` |
| `"drop-down"` | `"dropdown"` | `"panel-dropdown-x"` |
| `"text-box"` | `"textbox"` | `"panel-textbox-x"` |

### Méthodes courantes

| Méthode | Rôle |
|---|---|
| `:horizontal()` / `:vertical()` | Direction (frame, flow, line) |
| `:caption(text)` | Texte affiché |
| `:style(name)` | Style GUI Factorio |
| `:tooltip(text)` | Infobulle |
| `:visible(bool)` | Visibilité initiale |
| `:enabled(bool)` | Actif/inactif |
| `:get()` | Retourne le payload brut (à passer à `parent.add(...)`) |
| `:add(parent)` | Ajoute directement à `parent`, retourne le `LuaGuiElement` |

## Voir aussi

- [Contrat remote consommateur](../concepts/remote-contract.md)
- [Interfaces remote](remote-interfaces.md)
- [Wrappers temporaires](../concepts/temporary-wrappers.md)
- [Référence : RitnLibGui](../reference/runtime/RitnLibGui.md)
- [Référence : RitnLibGuiElement](../reference/runtime/RitnLibGuiElement.md)
