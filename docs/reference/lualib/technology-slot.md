---
title: lualib/technology-slot
type: reference
lang: fr
---

# `lualib/technology-slot`


Tuiles de technologie **comme la liste du jeu** pour la GUI d'un mod : case colorée selon l'état (jaune disponible, rouge
indisponible, vert recherchée), icône de la technologie et bande des packs de science (ou du déclencheur). La tuile est
un bouton cliquable ; ses enfants sont ignorés par la souris.

| | |
|---|---|
| **Source** | `lualib/technology-slot.lua` |
| **Type** | module de fonctions (table retournée), étape control |
| **Accès** | `local technologySlot = require(ritnlib.defines.technology_slot)` |

> Les styles `technology-slot-*-ritngui` et `technology-ingredients-ritngui` viennent de `prototypes/gui-style.lua` :
> ton `data.lua` doit faire `require(ritnlib.defines.gui_styles)`.

---

## Constantes

#### `WIDTH` :: `72` `[Read]`
Largeur d'une tuile (celle du jeu).

#### `HEIGHT` :: `100` `[Read]`
Hauteur d'une tuile.

---

## Fonctions

#### `state(technology)` → `"researched"|"available"|"unavailable"`
Couleur de la tuile : recherchée (vert), tous les prérequis recherchés (jaune), sinon rouge.

#### `icons(technology)` → `string[]`
Sprites de la bande : les packs de science (`item/<pack>`), ou le sprite du déclencheur.

#### `triggerSprite(trigger)` → `string, number?`
Sprite et quantité du déclencheur d'une technologie (`LuaTechnologyPrototype.research_trigger`),
ex. `"item/iron-plate", 50`.

#### `add(parent, gui_name, name, slot)` → `LuaGuiElement`
Construit la tuile dans `parent` et renvoie le bouton `<gui_name>-button-<name>`. `slot` :

| Champ | Type | |
|---|---|---|
| `sprite` | `string` | `"technology/<nom>"` |
| `state` | `string` | résultat de `state` |
| `icons` | `string[]` | résultat de `icons` |
| `selected` | `boolean?` | tuile en surbrillance |
| `tags` | `table?` | tags du bouton |

Le jeu place l'enfant d'un bouton à 4 px du bord (les marges négatives n'y changent rien) : le contenu est réduit à
l'intérieur de la tuile pour que l'icône soit centrée et la bande dans la case.

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
