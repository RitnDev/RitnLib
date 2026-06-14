---
title: RitnLibStyle
type: reference
lang: fr
---

# `RitnLibStyle`

🇬🇧 [English version](../../../en/reference/runtime/RitnLibStyle.md)

Helper **fluent** pour muter le [`LuaStyle`](https://lua-api.factorio.com/latest/classes/LuaStyle.html) d'un `LuaGuiElement` **déjà créé**. Chaque setter renvoie `self` pour le chaînage. Fournit des **presets** prêts à l'emploi (label, frame, listbox, boutons…) et des **setters atomiques** (dimensions, marges, paddings, alignement, police).

> À distinguer de [`RitnLibGuiElement`](RitnLibGuiElement.md) qui, lui, construit le *payload* de création. `RitnLibStyle` s'applique **après**, sur l'élément instancié.

| | |
|---|---|
| **Source** | `classes/RitnClass/gui/RitnStyle.lua` |
| **Stage** | control (runtime) |
| **Accès** | global — injecté dans `_G` par `core/setup-classes.lua`. Aucun `require`. |
| **Hérite de** | — (classe de base) |
| **`object_name`** | `"RitnLibStyle"` |

---

## Constructeur

#### `RitnLibStyle(element)` → [`RitnLibStyle`](RitnLibStyle.md)

Valide l'entrée (doit être un `LuaGuiElement`) et capture sa référence `.style`. Tous les setters mutent ce `LuaStyle`.

**Paramètres**
- `element` :: [`LuaGuiElement`](https://lua-api.factorio.com/latest/classes/LuaGuiElement.html) — l'élément dont on veut styler le `LuaStyle`.

```lua
RitnLibStyle(content.frame.lobby):frame():maxHeight(450):maxWidth(260)
```

---

## Attributs

#### `style` :: [`LuaStyle`](https://lua-api.factorio.com/latest/classes/LuaStyle.html) `[Read]`
Le `LuaStyle` enveloppé (référence vivante de `element.style`).

#### `stretch` :: `boolean` `[Read]`
Drapeau réutilisé par les helpers de stretch (défaut `true`, remis à `true` après chaque appel).

#### `color` :: `table` `[Read]`
Référence vers la palette `core/constants.lua::color` (clés `"white"`, `"darkgrey"`…).

#### `alignH` · `alignV` :: `string` `[Read]`
Alignement courant (défaut `"center"`).

---

## Presets

| Preset | Effet |
|---|---|
| `:label()` | `minimal_height = 25` |
| `:frame()` | paddings + `maximal_height = 338` + `maximal_width = 220` |
| `:scrollpane()` | `minimal_height = 220` + stretch horizontal |
| `:listbox()` | `min`/`max_height = 220` + stretch horizontal |
| `:smallButton()` | `height = 30`, `min_width = 90`, `max_width = 100` |
| `:normalButton()` | `min_height = 45`, `min_width = 200` |
| `:menuButton()` | `normalButton` + `min_width = 220` + police gris foncé |
| `:closeButton()` | `smallButton` + `width = 100` |
| `:spriteButton(size?)` | dimensions carrées (`number` ou `{w,h}`, défaut 32) |

#### `:fontColor(color, hovered?, clicked?)` → [`RitnLibStyle`](RitnLibStyle.md)
Définit `font_color`. `color` = clé de la palette (`"white"`, `"darkgrey"`…) ou table `{r,g,b,a}`. Si `hovered`/`clicked` valent `true`, applique aussi aux états correspondants.

#### `:straitFrame()` → [`RitnLibStyle`](RitnLibStyle.md)
> **Avertissement** — Défaut connu : appelle `self:standardFrame()` qui n'existe pas → **lève si appelée** (devait probablement appeler `:frame()`). Voir [bugs connus](../../debt/known-bugs.md).

---

## Setters atomiques

#### `:visible(visible)` → [`RitnLibStyle`](RitnLibStyle.md)
Définit `style.visible`.
> **Avertissement** — Défaut connu : la ligne `log` concatène `self.gui_name`, jamais défini sur `RitnLibStyle` → **lève au premier appel**. Voir [bugs connus](../../debt/known-bugs.md).

**Dimensions**

| Méthode | Effet |
|---|---|
| `:size(width, height)` | largeur + hauteur |
| `:width(w)` · `:height(h)` | dimension unique |
| `:minWidth(v)` · `:minHeight(v)` | `minimal_*` |
| `:maxWidth(v)` · `:maxHeight(v)` | `maximal_*` |

**Étirement & alignement**

| Méthode | Effet |
|---|---|
| `:stretchable()` | stretch horizontal + vertical |
| `:horizontalStretch(value?)` · `:verticalStretch(value?)` | stretch sur un axe |
| `:align(valueH?, valueV?)` | `horizontal_align` / `vertical_align` (défaut `"center"`) |

**Espacement, marges & paddings** (tous en `number`)

| Famille | Méthodes |
|---|---|
| Spacing | `:spacing(h, v)` · `:horizontalSpacing(v)` · `:verticalSpacing(v)` |
| Marges | `:margin(v)` · `:horizontalMargin(v)` · `:verticalMargin(v)` · `:topMargin(v)` · `:bottomMargin(v)` · `:leftMargin(v)` · `:rightMargin(v)` |
| Paddings | `:padding(v)` · `:horizontalPadding(v)` · `:verticalPadding(v)` · `:topPadding(v)` · `:bottomPadding(v)` · `:leftPadding(v)` · `:rightPadding(v)` · `:noPadding()` |

**Police**

#### `:font(font)` → [`RitnLibStyle`](RitnLibStyle.md)
Définit `style.font` (nom de police enregistrée, ex. `ritnlib.defines.names.font.bold18`).

---

## Exemple d'usage

**Styler un arbre GUI après création** (`RitnLobbyGame/classes/RitnGuiLobby.lua`) :

```lua
RitnLibStyle(content.frame.lobby):frame():maxHeight(450):maxWidth(260)
RitnLibStyle(content.flow.main):align():stretchable()
RitnLibStyle(content.button.create):menuButton():font(font.bold18)
RitnLibStyle(content.pane):scrollpane()
RitnLibStyle(content.list):listbox()
RitnLibStyle(content.flow.dialog):stretchable():topPadding(4):align("left")
RitnLibStyle(content.empty):size(30, 30)
```

---

## Remarques

- **S'applique à un élément existant** — passe un `LuaGuiElement` déjà ajouté ; le wrapper mute son `.style`.
- **Presets puis ajustements** — typiquement on applique un preset (`:frame()`, `:menuButton()`…) puis on affine (`:maxWidth()`, `:font()`…).
- **`:straitFrame()` / `:visible()` cassées** — voir les avertissements ci-dessus.

## Voir aussi

- [Carte des classes](../overview.md)
- [`RitnLibGuiElement`](RitnLibGuiElement.md) · [`RitnLibGui`](RitnLibGui.md)
- [Bugs connus](../../debt/known-bugs.md)
