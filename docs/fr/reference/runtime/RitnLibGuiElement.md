---
title: RitnLibGuiElement
type: reference
lang: fr
---

# `RitnLibGuiElement`

🇬🇧 [English version](../../../en/reference/runtime/RitnLibGuiElement.md)

Builder **fluent** pour un payload `LuaGuiElement.add{...}`. Chaque setter renvoie `self` pour le chaînage ; à la fin, `:add(parent)` instancie l'élément sur un vrai arbre GUI, ou `:get()` renvoie juste le payload. Construit aussi un nom d'élément normalisé (`<ui>-<type>-<name>`) compatible avec le routing de [`RitnLibGui`](RitnLibGui.md).

| | |
|---|---|
| **Source** | `classes/RitnClass/gui/RitnGuiElement.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnLibGuiElement"` |

---

## Constructeur

#### `RitnLibGuiElement(ui_name, element_type, element_name)` → [`RitnLibGuiElement`](RitnLibGuiElement.md)

Initialise le payload `add{...}`. Le `element_type` (type Factorio, ex. `"sprite-button"`, `"text-box"`, `"scroll-pane"`) est normalisé en forme courte pour le slug (`button`, `textbox`, `pane`…) ; le type Factorio réel est conservé dans [`type`](#type--string-read).

**Paramètres**
- `ui_name` :: `string` — namespace UI (préfixe), typiquement le `gui_name` du GUI parent.
- `element_type` :: `string` — type d'élément Factorio (`"flow"`, `"frame"`, `"button"`, `"label"`, `"sprite-button"`, `"scroll-pane"`, `"list-box"`…).
- `element_name` :: `string` — nom logique de l'élément.

**Valeur de retour** → [`RitnLibGuiElement`](RitnLibGuiElement.md). Le nom final de l'élément (`gui_element.name`) est `ui_name-<typeNormalisé>-element_name`.

```lua
local payload = RitnLibGuiElement("lobby", "flow", "common"):horizontal():get()
```

---

## Attributs

#### `gui_name` :: `string` `[Read]`
Slug `ui-typeNormalisé-name` — utilisé comme `name` de l'élément et pour le routing GUI.

#### `name` · `type` · `ui` :: `string` `[Read]`
Arguments du constructeur conservés tels quels (`type` = type Factorio réel, **pas** le slug).

#### `action` :: `string` `[Read]`
Clé d'action par défaut `<type>-<name>`.

#### `gui_element` :: `table` `[Read]`
Le payload `add{...}` en cours de construction (renvoyé par [`:get()`](#get--table)).

> **Note** — La classe garde aussi des tables de validation internes (`hsp_valid`, `string_valid`, `orientation_valid`, `text_valid`, `button_valid`, `sprite_valid`, `check_valid`) qui filtrent les setters selon le type d'élément.

---

## Méthodes — sortie

#### `:add(parent)` → [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html)`?`
Ajoute l'élément construit à `parent` et renvoie le `LuaGuiElement` créé.

**Paramètres** : `parent` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html).

#### `:get()` → `table`
Renvoie le payload `add{...}` brut, sans instancier (pratique pour le passer à `parent.add(...)` plus tard).

---

## Méthodes — orientation & disposition

| Méthode | Effet |
|---|---|
| `:horizontal()` | `direction = "horizontal"` (frame/flow/line) |
| `:vertical()` | `direction = "vertical"` (frame/flow/line) |
| `:autoCenter()` | `auto_center = true` (frame uniquement) |
| `:index(index)` | position d'insertion dans le parent (`index :: integer`) |

---

## Méthodes — contenu

#### `:caption(caption)` → self · `:tooltip(tooltip)` → self
Définissent caption / tooltip. Acceptent une [`LocalisedString`](https://lua-api.factorio.com/latest/concepts/LocalisedString.html) (`string` ou `table`).

#### `:text(text)` → self
Définit le texte (`textfield` / `text-box`).

> **Avertissement** — Défaut connu : la méthode teste `type(tooltip)` (variable inexistante) au lieu de `type(text)` ; le texte n'est donc **jamais** appliqué. Voir [bugs connus](../../debt/known-bugs.md).

---

## Méthodes — état

| Méthode | Effet |
|---|---|
| `:visible(visible)` | flag `visible` (`boolean`) |
| `:enabled(enabled)` | flag `enabled` (`boolean`) |
| `:checked(check?)` | état coché (checkbox/radiobutton ; défaut `true`) |
| `:progress(value?)` | valeur 0..100 (progressbar ; défaut 0) |

---

## Méthodes — apparence

| Méthode | Effet |
|---|---|
| `:style(style)` | nom de style GUI enregistré (`string`) |
| `:spritePath(sprite)` | sprite (sprite / sprite-button) |
| `:resizeSprite(resize)` | `resize_to_sprite` (type sprite) |
| `:mouseButtonFilter(value?)` | `mouse_button_filter` (button/sprite-button ; défaut `{"left"}`) |

---

## Méthodes — scroll (scroll-pane)

#### `:horizontalScrollPolicy(hsp)` → self
Politique de scroll horizontal. `hsp` ∈ `"auto"` | `"never"` | `"always"` | `"auto-and-reserve-space"` | `"dont-show-but-allow-scrolling"`.

#### `:verticalScrollPolicy(vsp)` → self
Politique de scroll vertical (mêmes valeurs).

> **Note** — Défaut mineur connu : valide `vsp` contre `hsp_valid` au lieu d'un set dédié. Sans effet aujourd'hui (mêmes valeurs autorisées).

---

## Exemple d'usage

**Construire un arbre GUI** (`RitnLobbyGame/gui/lobby.lua`) :

```lua
return {
    flow = {
        common = RitnLibGuiElement(gui_name, "flow", "common"):horizontal():get(),
        main   = RitnLibGuiElement(gui_name, "flow", "main"):vertical():get(),
    },
    button = {
        request = RitnLibGuiElement(gui_name, "button", "request")
            :caption(captions.button_request)
            :style("confirm_button")
            :tooltip({ "tooltip.button-valid" })
            :get(),
    },
}
```

---

## Remarques

- **Builder, pas wrapper d'élément vivant** — `RitnLibGuiElement` construit un *payload* ; l'élément réel naît au `:add(parent)`.
- **Nommage** — le slug `ui-type-name` permet à [`RitnLibGui`](RitnLibGui.md) de re-router les events de clic.
- **Filtrage par type** — les setters spécifiques (orientation, sprite, scroll…) sont no-op sur un type d'élément incompatible.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibGui`](RitnLibGui.md) · [`RitnLibStyle`](RitnLibStyle.md)
- [Bugs connus](../../debt/known-bugs.md)
